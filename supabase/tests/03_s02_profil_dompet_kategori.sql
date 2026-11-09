begin;
select plan(24);

-- Persiapan Fixture Pengguna (Rizky dan Dina)
create temp table _test_users (
  name text primary key,
  id uuid not null,
  raw_meta jsonb
);

insert into _test_users (name, id, raw_meta)
values
  ('rizky', gen_random_uuid(), '{"full_name": "Rizky Pratama", "timezone": "Asia/Jakarta"}'::jsonb),
  ('dina', gen_random_uuid(), '{"full_name": "Dina Rahma", "timezone": "Asia/Makassar"}'::jsonb),
  ('budi', gen_random_uuid(), '{"full_name": "Budi Santoso", "timezone": "Invalid/Timezone"}'::jsonb);

-- Simulasikan pendaftaran di auth.users (trigger handle_new_user akan berjalan)
insert into auth.users (id, email, raw_user_meta_data)
select id, name || '@test.com', raw_meta from _test_users;

-- 1. Verifikasi trigger pendaftaran: Profil
select is(
  (select count(*) from public.profiles where id in (select id from _test_users)),
  3::bigint,
  'Pendaftaran membuat tepat 1 profil per pengguna'
);

-- 2. T-TZ-01 & T-TZ-02: Evaluasi Zona Waktu
select is(
  (select timezone from public.profiles where id = (select id from _test_users where name = 'rizky')),
  'Asia/Jakarta',
  'T-TZ-01: Timezone Rizky sesuai metadata Asia/Jakarta'
);

select is(
  (select timezone from public.profiles where id = (select id from _test_users where name = 'dina')),
  'Asia/Makassar',
  'T-TZ-02: Timezone Dina sesuai metadata Asia/Makassar'
);

select is(
  (select timezone from public.profiles where id = (select id from _test_users where name = 'budi')),
  'Asia/Jakarta',
  'T-TZ-02: Timezone tidak valid fallback ke Asia/Jakarta'
);

-- 3. Verifikasi trigger pendaftaran: Dompet Saldo Utama
select is(
  (select count(*) from public.wallets where user_id = (select id from _test_users where name = 'rizky') and is_default = true and name = 'Saldo Utama'),
  1::bigint,
  'Pendaftaran membuat tepat 1 dompet default Saldo Utama'
);

-- 4. Verifikasi trigger pendaftaran: 16 Kategori Sistem (8 Pengeluaran, 8 Pemasukan)
select is(
  (select count(*) from public.categories where user_id = (select id from _test_users where name = 'rizky') and is_system = true),
  16::bigint,
  'Pendaftaran membuat tepat 16 kategori sistem'
);

select is(
  (select count(*) from public.categories where user_id = (select id from _test_users where name = 'rizky') and is_system = true and kind = 'expense'),
  8::bigint,
  'Tepat 8 kategori sistem pengeluaran'
);

select is(
  (select count(*) from public.categories where user_id = (select id from _test_users where name = 'rizky') and is_system = true and kind = 'income'),
  8::bigint,
  'Tepat 8 kategori sistem pemasukan'
);

-- 5. Verifikasi kendala FK komposit (user_id, id) pada wallets dan categories
select col_is_pk('public', 'wallets', ARRAY['id'], 'wallets PK adalah id');
select col_is_pk('public', 'categories', ARRAY['id'], 'categories PK adalah id');

select ok(
  exists (
    select 1 from pg_constraint
    where conrelid = 'public.wallets'::regclass
      and contype = 'u'
      and conname = 'wallets_user_id_id_key'
  ),
  'wallets memiliki constraint UNIQUE (user_id, id) untuk FK komposit'
);

select ok(
  exists (
    select 1 from pg_constraint
    where conrelid = 'public.categories'::regclass
      and contype = 'u'
      and conname = 'categories_user_id_id_key'
  ),
  'categories memiliki constraint UNIQUE (user_id, id) untuk FK komposit'
);

-- ============================================================================
-- Pengujian RLS dan Hak Keamanan (T-RLS & T-SEC)
-- ============================================================================

-- Variabel id untuk pengujian role
do $$
declare
  v_rizky uuid;
  v_dina uuid;
begin
  select id into v_rizky from _test_users where name = 'rizky';
  select id into v_dina from _test_users where name = 'dina';
  perform set_config('test.rizky_id', v_rizky::text, true);
  perform set_config('test.dina_id', v_dina::text, true);
end $$;

-- 6. T-RLS-05: Anon tanpa JWT ditolak mengakses profiles, wallets, categories
set local role anon;

select throws_ok(
  $$select * from public.profiles$$,
  '42501',
  null,
  'T-RLS-05: Role anon ditolak SELECT pada profiles'
);

select throws_ok(
  $$select * from public.wallets$$,
  '42501',
  null,
  'T-RLS-05: Role anon ditolak SELECT pada wallets'
);

select throws_ok(
  $$select * from public.categories$$,
  '42501',
  null,
  'T-RLS-05: Role anon ditolak SELECT pada categories'
);

-- 7. T-RLS-01: Dina SELECT baris Rizky -> 0 baris
reset role;
set local role authenticated;
select set_config('request.jwt.claim.sub', current_setting('test.dina_id'), true);

select is(
  (select count(*) from public.profiles where id = current_setting('test.rizky_id')::uuid),
  0::bigint,
  'T-RLS-01: Dina tidak dapat melihat profile Rizky'
);

select is(
  (select count(*) from public.wallets where user_id = current_setting('test.rizky_id')::uuid),
  0::bigint,
  'T-RLS-01: Dina tidak dapat melihat dompet Rizky'
);

select is(
  (select count(*) from public.categories where user_id = current_setting('test.rizky_id')::uuid),
  0::bigint,
  'T-RLS-01: Dina tidak dapat melihat kategori Rizky'
);

-- 8. T-SEC-01: Authenticated DML langsung pada wallets (Kelas A) ditolak
select throws_ok(
  $$insert into public.wallets (user_id, name, kind, opening_balance) values (current_setting('test.dina_id')::uuid, 'Dompet Liar', 'cash', 1000)$$,
  '42501',
  null,
  'T-SEC-01: INSERT langsung pada wallets ditolak untuk authenticated'
);

select throws_ok(
  $$delete from public.wallets where user_id = current_setting('test.dina_id')::uuid$$,
  '42501',
  null,
  'T-SEC-01: DELETE langsung pada wallets ditolak untuk authenticated'
);

-- 9. T-RLS-09: Authenticated mencoba mengubah kolom 'plan' pada profiles ditolak oleh hak kolom
select throws_ok(
  $$update public.profiles set plan = 'pro' where id = current_setting('test.dina_id')::uuid$$,
  '42501',
  null,
  'T-RLS-09: Authenticated ditolak mengubah kolom plan pada profiles'
);

-- 10. T-CNS-05: Authenticated mencoba mengubah 'ai_consent_at' langsung pada profiles ditolak
select throws_ok(
  $$update public.profiles set ai_consent_at = now() where id = current_setting('test.dina_id')::uuid$$,
  '42501',
  null,
  'T-CNS-05: Authenticated ditolak mengubah kolom ai_consent_at langsung pada profiles'
);

-- 11. Kategori sistem tidak dapat diubah atau dihapus oleh pengguna
-- Coba update kategori sistem
update public.categories
set name = 'Makanan Baru'
where user_id = current_setting('test.dina_id')::uuid and is_system = true;

select is(
  (select count(*) from public.categories where user_id = current_setting('test.dina_id')::uuid and name = 'Makanan Baru'),
  0::bigint,
  'Kategori sistem tidak terpengaruh oleh perintah UPDATE pengguna'
);

-- Coba delete kategori sistem
delete from public.categories
where user_id = current_setting('test.dina_id')::uuid and is_system = true;

select is(
  (select count(*) from public.categories where user_id = current_setting('test.dina_id')::uuid and is_system = true),
  16::bigint,
  'Kategori sistem tidak terhapus oleh perintah DELETE pengguna'
);

select * from finish();
rollback;

