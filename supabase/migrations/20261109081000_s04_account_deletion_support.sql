-- ============================================================================
-- S04 Dukungan Hapus Akun
-- ============================================================================

-- 1. request_account_deletion_v1 (dipanggil oleh delete-account dengan JWT pengguna)
create or replace function public.request_account_deletion_v1(
  p_client_request_id uuid
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
  v_deletion_requested_at timestamptz;
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

  -- 3. Idempotensi
  v_payload := '{}'::jsonb;
  v_cached := private.start_idempotent_request(v_user_id, p_client_request_id, 'request_account_deletion_v1', v_payload);
  if v_cached is not null then
    return v_cached;
  end if;

  -- 4. Tandai deletion_requested_at pada profiles
  update public.profiles
  set deletion_requested_at = coalesce(deletion_requested_at, clock_timestamp())
  where id = v_user_id
  returning deletion_requested_at into v_deletion_requested_at;

  v_res := json_build_object(
    'success', true,
    'deletion_requested_at', v_deletion_requested_at
  )::jsonb;

  perform private.finish_idempotent_request(v_user_id, p_client_request_id, v_res);
  return v_res;
end;
$$;

revoke execute on function public.request_account_deletion_v1(uuid) from anon, public;
grant execute on function public.request_account_deletion_v1(uuid) to authenticated;


-- 2. purge_user_data_v1 (Hanya dieksekusi oleh service_role untuk Edge Function delete-account)
create or replace function public.purge_user_data_v1(
  p_user_id uuid
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_deleted_request_logs bigint;
  v_deleted_categories bigint;
  v_deleted_wallets bigint;
  v_deleted_profiles bigint;
  v_res jsonb;
begin
  -- 1. Validasi masukan
  if p_user_id is null then
    raise exception 'user_id_required';
  end if;

  -- 2. Hapus baris data pengguna di seluruh tabel fase 1 (eksplisit & idempoten)
  delete from public.request_log where user_id = p_user_id;
  get diagnostics v_deleted_request_logs = row_count;

  delete from public.categories where user_id = p_user_id;
  get diagnostics v_deleted_categories = row_count;

  delete from public.wallets where user_id = p_user_id;
  get diagnostics v_deleted_wallets = row_count;

  delete from public.profiles where id = p_user_id;
  get diagnostics v_deleted_profiles = row_count;

  v_res := json_build_object(
    'success', true,
    'purged_user_id', p_user_id,
    'deleted_request_logs', v_deleted_request_logs,
    'deleted_categories', v_deleted_categories,
    'deleted_wallets', v_deleted_wallets,
    'deleted_profiles', v_deleted_profiles
  )::jsonb;

  return v_res;
end;
$$;

-- T-SEC-08: purge_user_data_v1 dicabut dari anon, public, dan authenticated!
revoke all on function public.purge_user_data_v1(uuid) from anon, public, authenticated;
grant execute on function public.purge_user_data_v1(uuid) to service_role;

