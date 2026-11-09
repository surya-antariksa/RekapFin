-- ============================================================================
-- S01 Idempotensi dan Konfigurasi
-- ============================================================================

-- 1. Tabel request_log (Kelas A)
create table if not exists public.request_log (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  client_request_id uuid not null,
  rpc_name text not null,
  payload_hash text not null,
  result jsonb null,
  created_at timestamptz not null default now(),
  constraint request_log_user_req_id_key unique (user_id, client_request_id)
);

create index if not exists request_log_created_at_idx on public.request_log (created_at);

-- RLS untuk request_log: hanya baca data sendiri, dilarang DML langsung
alter table public.request_log enable row level security;

create policy request_log_select_own on public.request_log
  for select to authenticated
  using (user_id = (select auth.uid()));

revoke insert, update, delete, truncate on public.request_log from authenticated, anon, public;

-- 2. Pembantu Idempotensi di Skema private
create or replace function private.start_idempotent_request(
  p_user_id uuid,
  p_client_request_id uuid,
  p_rpc_name text,
  p_payload jsonb default '{}'::jsonb
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_payload_hash text;
  v_existing record;
begin
  if p_user_id is null then
    raise exception 'user_id is required';
  end if;

  if p_client_request_id is null then
    raise exception 'client_request_id is required';
  end if;

  v_payload_hash := md5(coalesce(p_payload::text, ''));

  select rpc_name, payload_hash, result
  into v_existing
  from public.request_log
  where user_id = p_user_id and client_request_id = p_client_request_id;

  if found then
    if v_existing.rpc_name = p_rpc_name and v_existing.payload_hash = v_payload_hash then
      return v_existing.result;
    else
      raise exception 'request_id_reuse';
    end if;
  else
    insert into public.request_log (user_id, client_request_id, rpc_name, payload_hash, result)
    values (p_user_id, p_client_request_id, p_rpc_name, v_payload_hash, null);
    return null;
  end if;
end;
$$;

create or replace function private.finish_idempotent_request(
  p_user_id uuid,
  p_client_request_id uuid,
  p_result jsonb
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  update public.request_log
  set result = p_result
  where user_id = p_user_id and client_request_id = p_client_request_id;
end;
$$;

-- 3. Tabel app_config (Kelas C: Konfigurasi)
create table if not exists public.app_config (
  id uuid primary key default gen_random_uuid(),
  platform text not null check (platform in ('android', 'ios')),
  min_app_version text not null,
  recommended_version text not null,
  update_url text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint app_config_platform_key unique (platform)
);

alter table public.app_config enable row level security;

-- DML & Direct SELECT dicabut dari pengguna publik/authenticated (hanya via RPC get_app_config_v1)
revoke all on public.app_config from anon, authenticated, public;

create trigger set_app_config_updated_at
  before update on public.app_config
  for each row execute function private.set_updated_at();

-- Data awal app_config
insert into public.app_config (platform, min_app_version, recommended_version, update_url)
values ('android', '1.0.0', '1.0.0', 'https://drive.google.com')
on conflict (platform) do nothing;

-- 4. RPC get_app_config_v1
create or replace function public.get_app_config_v1(p_platform text)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_res jsonb;
begin
  if (select auth.uid()) is null then
    raise exception 'authentication_required';
  end if;

  select json_build_object(
    'platform', platform,
    'min_app_version', min_app_version,
    'recommended_version', recommended_version,
    'update_url', update_url
  )::jsonb
  into v_res
  from public.app_config
  where platform = p_platform;

  return v_res;
end;
$$;

revoke execute on function public.get_app_config_v1(text) from anon, public;
grant execute on function public.get_app_config_v1(text) to authenticated;

-- 5. Pekerjaan pg_cron: Pembersih request_log 30 hari (OI-45)
do $$
begin
  if exists (select 1 from pg_extension where extname = 'pg_cron') then
    if exists (select 1 from cron.job where jobname = 'clean_old_request_log') then
      perform cron.unschedule('clean_old_request_log');
    end if;
    perform cron.schedule(
      'clean_old_request_log',
      '0 3 * * *',
      $cron_job$delete from public.request_log where created_at < now() - interval '30 days'$cron_job$
    );
  end if;
end $$;

