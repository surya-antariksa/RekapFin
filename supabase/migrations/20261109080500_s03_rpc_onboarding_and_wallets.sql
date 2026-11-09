-- ============================================================================
-- S03 RPC Dompet dan Onboarding
-- ============================================================================

-- 1. complete_onboarding_v1
create or replace function public.complete_onboarding_v1(
  p_client_request_id uuid,
  p_opening_balance bigint default null
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid;
  v_cached jsonb;
  v_payload jsonb;
  v_default_wallet_id uuid;
  v_res jsonb;
begin
  -- 1. Validasi konteks autentikasi
  v_user_id := (select auth.uid());
  if v_user_id is null then
    raise exception 'authentication_required';
  end if;

  -- 2. T-IDM-04: client_request_id wajib
  if p_client_request_id is null then
    raise exception 'client_request_id_required';
  end if;

  -- 3. Idempotensi: cek riwayat request_log
  v_payload := json_build_object('opening_balance', p_opening_balance)::jsonb;
  v_cached := private.start_idempotent_request(v_user_id, p_client_request_id, 'complete_onboarding_v1', v_payload);
  if v_cached is not null then
    return v_cached;
  end if;

  -- 4. Validasi nominal opening_balance bila diberikan (T-MON-06)
  if p_opening_balance is not null then
    if p_opening_balance < 0 or p_opening_balance > 100000000000 then
      raise exception 'invalid_amount: opening_balance must be between 0 and 100000000000';
    end if;

    -- Update saldo awal dompet default (Saldo Utama)
    update public.wallets
    set opening_balance = p_opening_balance
    where user_id = v_user_id and is_default = true
    returning id into v_default_wallet_id;
  else
    select id into v_default_wallet_id
    from public.wallets
    where user_id = v_user_id and is_default = true;
  end if;

  -- 5. Tandai profil sudah onboarding (onboarded_at)
  update public.profiles
  set onboarded_at = coalesce(onboarded_at, now())
  where id = v_user_id;

  -- 6. Simpan hasil idempotensi
  v_res := json_build_object(
    'success', true,
    'wallet_id', v_default_wallet_id,
    'opening_balance', coalesce(p_opening_balance, 0)
  )::jsonb;

  perform private.finish_idempotent_request(v_user_id, p_client_request_id, v_res);
  return v_res;
end;
$$;

revoke execute on function public.complete_onboarding_v1(uuid, bigint) from anon, public;
grant execute on function public.complete_onboarding_v1(uuid, bigint) to authenticated;


-- 2. create_wallet_v1
create or replace function public.create_wallet_v1(
  p_client_request_id uuid,
  p_name text,
  p_kind public.wallet_kind default 'cash',
  p_opening_balance bigint default 0,
  p_is_default boolean default false
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid;
  v_cached jsonb;
  v_payload jsonb;
  v_wallet_id uuid;
  v_res jsonb;
  v_trimmed_name text;
  v_is_default boolean;
begin
  -- 1. Validasi konteks autentikasi
  v_user_id := (select auth.uid());
  if v_user_id is null then
    raise exception 'authentication_required';
  end if;

  -- 2. T-IDM-04: client_request_id wajib
  if p_client_request_id is null then
    raise exception 'client_request_id_required';
  end if;

  -- 3. Validasi parameter input
  v_trimmed_name := btrim(coalesce(p_name, ''));
  if char_length(v_trimmed_name) = 0 or char_length(v_trimmed_name) > 100 then
    raise exception 'invalid_name: wallet name cannot be empty and max 100 characters';
  end if;

  if p_kind is null then
    raise exception 'invalid_kind: wallet kind is required';
  end if;

  if p_opening_balance is null or p_opening_balance < 0 or p_opening_balance > 100000000000 then
    raise exception 'invalid_amount: opening_balance must be between 0 and 100000000000';
  end if;

  v_is_default := coalesce(p_is_default, false);

  -- 4. Idempotensi
  v_payload := json_build_object(
    'name', v_trimmed_name,
    'kind', p_kind::text,
    'opening_balance', p_opening_balance,
    'is_default', v_is_default
  )::jsonb;

  v_cached := private.start_idempotent_request(v_user_id, p_client_request_id, 'create_wallet_v1', v_payload);
  if v_cached is not null then
    return v_cached;
  end if;

  -- 5. Jika dijadikan default, lepas status default dari dompet lama
  if v_is_default then
    update public.wallets
    set is_default = false
    where user_id = v_user_id and is_default = true;
  end if;

  -- 6. Insert dompet baru
  insert into public.wallets (user_id, name, kind, opening_balance, is_default)
  values (v_user_id, v_trimmed_name, p_kind, p_opening_balance, v_is_default)
  returning id into v_wallet_id;

  v_res := json_build_object(
    'success', true,
    'wallet_id', v_wallet_id,
    'name', v_trimmed_name,
    'kind', p_kind::text,
    'opening_balance', p_opening_balance,
    'is_default', v_is_default
  )::jsonb;

  perform private.finish_idempotent_request(v_user_id, p_client_request_id, v_res);
  return v_res;
end;
$$;

revoke execute on function public.create_wallet_v1(uuid, text, public.wallet_kind, bigint, boolean) from anon, public;
grant execute on function public.create_wallet_v1(uuid, text, public.wallet_kind, bigint, boolean) to authenticated;


-- 3. update_wallet_v1
create or replace function public.update_wallet_v1(
  p_client_request_id uuid,
  p_wallet_id uuid,
  p_name text,
  p_kind public.wallet_kind,
  p_opening_balance bigint,
  p_is_default boolean default null
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid;
  v_cached jsonb;
  v_payload jsonb;
  v_existing record;
  v_trimmed_name text;
  v_target_default boolean;
  v_res jsonb;
begin
  -- 1. Validasi konteks autentikasi
  v_user_id := (select auth.uid());
  if v_user_id is null then
    raise exception 'authentication_required';
  end if;

  -- 2. T-IDM-04: client_request_id & wallet_id wajib
  if p_client_request_id is null then
    raise exception 'client_request_id_required';
  end if;

  if p_wallet_id is null then
    raise exception 'wallet_id_required';
  end if;

  -- 3. Validasi parameter
  v_trimmed_name := btrim(coalesce(p_name, ''));
  if char_length(v_trimmed_name) = 0 or char_length(v_trimmed_name) > 100 then
    raise exception 'invalid_name: wallet name cannot be empty and max 100 characters';
  end if;

  if p_kind is null then
    raise exception 'invalid_kind: wallet kind is required';
  end if;

  if p_opening_balance is null or p_opening_balance < 0 or p_opening_balance > 100000000000 then
    raise exception 'invalid_amount: opening_balance must be between 0 and 100000000000';
  end if;

  -- 4. Idempotensi
  v_payload := json_build_object(
    'wallet_id', p_wallet_id,
    'name', v_trimmed_name,
    'kind', p_kind::text,
    'opening_balance', p_opening_balance,
    'is_default', p_is_default
  )::jsonb;

  v_cached := private.start_idempotent_request(v_user_id, p_client_request_id, 'update_wallet_v1', v_payload);
  if v_cached is not null then
    return v_cached;
  end if;

  -- 5. Cek kepemilikan dompet
  select id, is_default, archived_at
  into v_existing
  from public.wallets
  where user_id = v_user_id and id = p_wallet_id
  for update;

  if not found then
    raise exception 'wallet_not_found: wallet does not exist or does not belong to user';
  end if;

  -- 6. Logika is_default:
  if p_is_default is not null then
    if p_is_default = true and v_existing.is_default = false then
      -- Jadikan default baru: lepas status default dari dompet lama
      update public.wallets
      set is_default = false
      where user_id = v_user_id and is_default = true;
      v_target_default := true;
    elsif p_is_default = false and v_existing.is_default = true then
      -- Tidak dapat melepas status default secara sepihak
      raise exception 'invalid_operation: cannot unset default wallet without selecting another default wallet';
    else
      v_target_default := v_existing.is_default;
    end if;
  else
    v_target_default := v_existing.is_default;
  end if;

  -- 7. Update data dompet
  update public.wallets
  set
    name = v_trimmed_name,
    kind = p_kind,
    opening_balance = p_opening_balance,
    is_default = v_target_default
  where user_id = v_user_id and id = p_wallet_id;

  v_res := json_build_object(
    'success', true,
    'wallet_id', p_wallet_id,
    'name', v_trimmed_name,
    'kind', p_kind::text,
    'opening_balance', p_opening_balance,
    'is_default', v_target_default
  )::jsonb;

  perform private.finish_idempotent_request(v_user_id, p_client_request_id, v_res);
  return v_res;
end;
$$;

revoke execute on function public.update_wallet_v1(uuid, uuid, text, public.wallet_kind, bigint, boolean) from anon, public;
grant execute on function public.update_wallet_v1(uuid, uuid, text, public.wallet_kind, bigint, boolean) to authenticated;

