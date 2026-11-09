-- ============================================================================
-- S00 Fondasi Platform
-- ============================================================================

-- 1. Ekstensi: pg_trgm dan pg_cron
create extension if not exists pg_trgm with schema extensions;
create extension if not exists pg_cron with schema extensions;

-- 2. Skema private untuk fungsi dan objek pembantu internal
create schema if not exists private;

revoke all on schema private from public, anon;
grant usage on schema private to authenticated;

alter default privileges in schema private revoke all on tables from public, anon;
alter default privileges in schema private revoke all on functions from public, anon;

-- 3. Kebijakan hak bawaan skema public:
-- EXECUTE dicabut dari anon dan PUBLIC untuk fungsi baru
alter default privileges in schema public revoke execute on functions from public, anon;
revoke execute on all functions in schema public from public, anon;

-- 4. Tipe Enum Platform
do $$
begin
  if not exists (select 1 from pg_type where typname = 'transaction_type') then
    create type public.transaction_type as enum ('income', 'expense', 'transfer');
  end if;
  if not exists (select 1 from pg_type where typname = 'type') then
    create type public.type as enum ('income', 'expense', 'transfer');
  end if;

  if not exists (select 1 from pg_type where typname = 'transaction_source') then
    create type public.transaction_source as enum ('manual', 'scan', 'chat', 'debt', 'debt_payment', 'investment');
  end if;
  if not exists (select 1 from pg_type where typname = 'source') then
    create type public.source as enum ('manual', 'scan', 'chat', 'debt', 'debt_payment', 'investment');
  end if;

  if not exists (select 1 from pg_type where typname = 'wallet_kind') then
    create type public.wallet_kind as enum ('cash', 'bank', 'ewallet');
  end if;

  if not exists (select 1 from pg_type where typname = 'category_kind') then
    create type public.category_kind as enum ('expense', 'income');
  end if;

  if not exists (select 1 from pg_type where typname = 'debt_direction') then
    create type public.debt_direction as enum ('borrowed', 'lent');
  end if;
  if not exists (select 1 from pg_type where typname = 'direction') then
    create type public.direction as enum ('borrowed', 'lent');
  end if;

  if not exists (select 1 from pg_type where typname = 'payment_channel') then
    create type public.payment_channel as enum ('cash', 'transfer', 'ewallet');
  end if;

  if not exists (select 1 from pg_type where typname = 'debt_offset_side') then
    create type public.debt_offset_side as enum ('receivable', 'payable');
  end if;

  if not exists (select 1 from pg_type where typname = 'investment_kind') then
    create type public.investment_kind as enum ('mutual_fund', 'gold', 'stock', 'other');
  end if;

  if not exists (select 1 from pg_type where typname = 'scan_kind') then
    create type public.scan_kind as enum ('receipt', 'investment');
  end if;

  if not exists (select 1 from pg_type where typname = 'scan_status') then
    create type public.scan_status as enum ('processing', 'done', 'failed');
  end if;

  if not exists (select 1 from pg_type where typname = 'chat_role') then
    create type public.chat_role as enum ('user', 'assistant');
  end if;

  if not exists (select 1 from pg_type where typname = 'pending_action_status') then
    create type public.pending_action_status as enum ('pending', 'confirmed', 'rejected', 'expired');
  end if;

  if not exists (select 1 from pg_type where typname = 'ai_usage_kind') then
    create type public.ai_usage_kind as enum ('chat', 'scan', 'scan_fallback');
  end if;
end $$;

-- 5. Pembantu Pemicu updated_at
create or replace function private.set_updated_at()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  new.updated_at = clock_timestamp();
  return new;
end;
$$;

-- 6. Pembantu Zona Waktu
create or replace function private.is_valid_timezone(p_tz text)
returns boolean
language sql
immutable
security definer
set search_path = ''
as $$
  select p_tz in ('Asia/Jakarta', 'Asia/Makassar', 'Asia/Jayapura');
$$;

create or replace function private.get_user_timezone(p_user_id uuid)
returns text
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_tz text;
begin
  if exists (
    select 1 from information_schema.tables
    where table_schema = 'public' and table_name = 'profiles'
  ) then
    execute 'select timezone from public.profiles where id = $1' into v_tz using p_user_id;
  end if;

  if v_tz is null or not (v_tz in ('Asia/Jakarta', 'Asia/Makassar', 'Asia/Jayapura')) then
    v_tz := 'Asia/Jakarta';
  end if;
  return v_tz;
end;
$$;

