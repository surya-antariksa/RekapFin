-- ============================================================================
-- S02 Profil, Dompet, Kategori
-- ============================================================================

-- 1. Tabel profiles (Kelas B: bebas invarian lintas tabel, hak kolom terbatas)
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default '',
  phone text null check (phone is null or phone ~ '^\+62[0-9]{8,15}$'),
  birth_date date null,
  avatar_path text null,
  timezone text not null default 'Asia/Jakarta' check (timezone in ('Asia/Jakarta', 'Asia/Makassar', 'Asia/Jayapura')),
  plan text not null default 'free' check (plan in ('free')),
  onboarded_at timestamptz null,
  biometric_lock boolean not null default false,
  keep_receipt_images boolean not null default false,
  deletion_requested_at timestamptz null,
  ai_consent_at timestamptz null,
  ai_consent_version text null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger set_profiles_updated_at
  before update on public.profiles
  for each row execute function private.set_updated_at();

alter table public.profiles enable row level security;

create policy profiles_select_own on public.profiles
  for select to authenticated
  using (id = (select auth.uid()));

create policy profiles_update_own on public.profiles
  for update to authenticated
  using (id = (select auth.uid()))
  with check (id = (select auth.uid()));

-- Hak akses kolom untuk profiles (T-CNS-05, T-RLS-09):
-- Klien hanya boleh mengubah kolom tertentu; plan, onboarded_at, deletion_requested_at,
-- ai_consent_at, ai_consent_version hanya lewat RPC / fungsi internal.
revoke all on public.profiles from anon, public;
revoke all on public.profiles from authenticated;
grant select on public.profiles to authenticated;
grant update (
  full_name,
  phone,
  birth_date,
  avatar_path,
  timezone,
  biometric_lock,
  keep_receipt_images
) on public.profiles to authenticated;


-- 2. Tabel wallets (Kelas A: dijaga invarian, DML langsung dicabut)
create table if not exists public.wallets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null check (char_length(btrim(name)) > 0 and char_length(name) <= 100),
  kind public.wallet_kind not null default 'cash',
  opening_balance bigint not null default 0 check (opening_balance >= 0 and opening_balance <= 100000000000),
  is_default boolean not null default false,
  archived_at timestamptz null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint wallets_user_id_id_key unique (user_id, id)
);

-- Tepat satu dompet default per pengguna
create unique index if not exists wallets_user_one_default_idx
  on public.wallets (user_id)
  where (is_default = true);

create index if not exists wallets_user_id_idx on public.wallets (user_id);
create index if not exists wallets_user_kind_idx on public.wallets (user_id, kind);

create trigger set_wallets_updated_at
  before update on public.wallets
  for each row execute function private.set_updated_at();

alter table public.wallets enable row level security;

create policy wallets_select_own on public.wallets
  for select to authenticated
  using (user_id = (select auth.uid()));

-- DML langsung dicabut dari authenticated, anon, dan public (Kelas A: T-SEC-01)
revoke all on public.wallets from anon, public;
revoke insert, update, delete, truncate on public.wallets from authenticated;
grant select on public.wallets to authenticated;


-- 3. Tabel categories (Kelas B: kategori kustom oleh pemilik, kategori sistem tidak dapat diubah/dihapus)
create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null check (char_length(btrim(name)) > 0 and char_length(name) <= 50),
  kind public.category_kind not null,
  icon text not null default 'tag',
  is_system boolean not null default false,
  sort_order integer not null default 0,
  archived_at timestamptz null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint categories_user_id_id_key unique (user_id, id)
);

create unique index if not exists categories_user_kind_lower_name_key
  on public.categories (user_id, kind, lower(btrim(name)));

create index if not exists categories_user_kind_sort_idx
  on public.categories (user_id, kind, sort_order);

create trigger set_categories_updated_at
  before update on public.categories
  for each row execute function private.set_updated_at();

alter table public.categories enable row level security;

create policy categories_select_own on public.categories
  for select to authenticated
  using (user_id = (select auth.uid()));

create policy categories_insert_own on public.categories
  for insert to authenticated
  with check (user_id = (select auth.uid()) and is_system = false);

create policy categories_update_own on public.categories
  for update to authenticated
  using (user_id = (select auth.uid()) and is_system = false)
  with check (user_id = (select auth.uid()) and is_system = false);

create policy categories_delete_own on public.categories
  for delete to authenticated
  using (user_id = (select auth.uid()) and is_system = false);

revoke all on public.categories from anon, public;
revoke truncate on public.categories from authenticated;
grant select, insert, update, delete on public.categories to authenticated;


-- 4. Pemicu Pendaftaran Pengguna (auth.users -> profil, dompet, 16 kategori)
create or replace function private.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_timezone text;
  v_full_name text;
begin
  -- 1. Evaluasi metadata zona waktu bila ada dan diizinkan, selain itu Asia/Jakarta
  v_timezone := coalesce(new.raw_user_meta_data->>'timezone', '');
  if not (v_timezone in ('Asia/Jakarta', 'Asia/Makassar', 'Asia/Jayapura')) then
    v_timezone := 'Asia/Jakarta';
  end if;

  v_full_name := coalesce(new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'name', '');

  -- 2. Buat profil pengguna
  insert into public.profiles (id, full_name, timezone)
  values (new.id, v_full_name, v_timezone)
  on conflict (id) do nothing;

  -- 3. Buat dompet Saldo Utama
  insert into public.wallets (user_id, name, kind, opening_balance, is_default)
  values (new.id, 'Saldo Utama', 'cash', 0, true)
  on conflict do nothing;

  -- 4. Buat 16 kategori sistem bawaan (8 pengeluaran, 8 pemasukan)
  insert into public.categories (user_id, name, kind, icon, is_system, sort_order)
  values
    -- 8 Kategori Pengeluaran (BR-25)
    (new.id, 'Makanan', 'expense', 'utensils', true, 1),
    (new.id, 'Transport', 'expense', 'car', true, 2),
    (new.id, 'Belanja', 'expense', 'shopping-bag', true, 3),
    (new.id, 'Tagihan', 'expense', 'receipt', true, 4),
    (new.id, 'Hiburan', 'expense', 'film', true, 5),
    (new.id, 'Kesehatan', 'expense', 'heart-pulse', true, 6),
    (new.id, 'Pendidikan', 'expense', 'graduation-cap', true, 7),
    (new.id, 'Lainnya', 'expense', 'more-horizontal', true, 8),
    -- 8 Kategori Pemasukan (BR-25)
    (new.id, 'Gaji', 'income', 'banknote', true, 1),
    (new.id, 'Bonus', 'income', 'gift', true, 2),
    (new.id, 'Freelance', 'income', 'briefcase', true, 3),
    (new.id, 'Investasi', 'income', 'trending-up', true, 4),
    (new.id, 'Hadiah', 'income', 'sparkles', true, 5),
    (new.id, 'Penjualan', 'income', 'store', true, 6),
    (new.id, 'Refund', 'income', 'rotate-ccw', true, 7),
    (new.id, 'Lainnya', 'income', 'more-horizontal', true, 8)
  on conflict (user_id, kind, lower(btrim(name))) do nothing;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function private.handle_new_user();

