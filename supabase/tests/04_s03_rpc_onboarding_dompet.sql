begin;
select plan(18);

-- Persiapan Pengguna Uji (Rizky & Dina)
create temp table _test_users (
  name text primary key,
  id uuid not null
);

insert into _test_users (name, id)
values
  ('rizky', gen_random_uuid()),
  ('dina', gen_random_uuid());

insert into auth.users (id, email)
select id, name || '@test.com' from _test_users;

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

-- 1. T-SEC-03: Role anon ditolak memanggil ketiga RPC
set local role anon;

select throws_ok(
  $$select public.complete_onboarding_v1(gen_random_uuid(), 0)$$,
  '42501',
  null,
  'T-SEC-03: Role anon ditolak memanggil complete_onboarding_v1'
);

select throws_ok(
  $$select public.create_wallet_v1(gen_random_uuid(), 'Dompet Test', 'cash', 0, false)$$,
  '42501',
  null,
  'T-SEC-03: Role anon ditolak memanggil create_wallet_v1'
);

select throws_ok(
  $$select public.update_wallet_v1(gen_random_uuid(), gen_random_uuid(), 'Dompet Test', 'cash', 0, false)$$,
  '42501',
  null,
  'T-SEC-03: Role anon ditolak memanggil update_wallet_v1'
);

-- 2. T-SEC-06: Panggilan tanpa auth.uid() ditolak
reset role;
set local role authenticated;
select set_config('request.jwt.claim.sub', '', true);

select throws_ok(
  $$select public.complete_onboarding_v1(gen_random_uuid(), 0)$$,
  'P0001',
  'authentication_required',
  'T-SEC-06: complete_onboarding_v1 tanpa auth.uid() ditolak'
);

-- Setup sesi sebagai Rizky
select set_config('request.jwt.claim.sub', current_setting('test.rizky_id'), true);

-- 3. T-IDM-04: client_request_id wajib (tidak boleh null)
select throws_ok(
  $$select public.complete_onboarding_v1(null, 1000)$$,
  'P0001',
  'client_request_id_required',
  'T-IDM-04: complete_onboarding_v1 menolak client_request_id null'
);

select throws_ok(
  $$select public.create_wallet_v1(null, 'Dompet Baru', 'bank', 0, false)$$,
  'P0001',
  'client_request_id_required',
  'T-IDM-04: create_wallet_v1 menolak client_request_id null'
);

-- 4. T-WAL-04: Onboarding dilewati (saldo awal Saldo Utama tetap 0, onboarded_at terisi)
select is(
  (select onboarded_at from public.profiles where id = current_setting('test.rizky_id')::uuid),
  null,
  'Sebelum onboarding, onboarded_at bernilai null'
);

select ok(
  (select (public.complete_onboarding_v1(gen_random_uuid()))->>'success')::boolean,
  'T-WAL-04: complete_onboarding_v1 sukses saat dilewati tanpa parameter saldo'
);

select is(
  (select opening_balance from public.wallets where user_id = current_setting('test.rizky_id')::uuid and is_default = true),
  0::bigint,
  'T-WAL-04: Saldo awal Saldo Utama tetap 0 saat onboarding dilewati'
);

select ok(
  (select onboarded_at from public.profiles where id = current_setting('test.rizky_id')::uuid) is not null,
  'T-WAL-04: onboarded_at terisi setelah complete_onboarding_v1 dipanggil'
);

-- 5. T-MON-06: Batas nominal opening_balance (0 <= x <= 100 miliar)
select throws_ok(
  $$select public.create_wallet_v1(gen_random_uuid(), 'Dompet Jumbo', 'bank', 100000000001, false)$$,
  'P0001',
  null,
  'T-MON-06: Nominal di atas Rp 100 miliar ditolak'
);

select throws_ok(
  $$select public.create_wallet_v1(gen_random_uuid(), 'Dompet Minus', 'bank', -100, false)$$,
  'P0001',
  null,
  'T-MON-06: Nominal negatif ditolak'
);

-- 6. create_wallet_v1 & Tepat 1 default per pengguna
-- Buat dompet BCA sebagai default baru
do $$
declare
  v_req_id uuid := 'a0000000-0000-0000-0000-000000000001'::uuid;
  v_res jsonb;
begin
  v_res := public.create_wallet_v1(v_req_id, 'Bank BCA', 'bank', 15000000, true);
  perform set_config('test.bca_id', v_res->>'wallet_id', true);
end $$;

select is(
  (select count(*) from public.wallets where user_id = current_setting('test.rizky_id')::uuid and is_default = true),
  1::bigint,
  'Tepat satu dompet default aktif setelah membuat default baru'
);

select is(
  (select name from public.wallets where user_id = current_setting('test.rizky_id')::uuid and is_default = true),
  'Bank BCA',
  'Dompet default berpindah ke Bank BCA'
);

-- 7. T-IDM-06: create_wallet_v1 diulang dengan client_request_id sama menghasilkan efek idempoten
select ok(
  (select (public.create_wallet_v1('a0000000-0000-0000-0000-000000000001'::uuid, 'Bank BCA', 'bank', 15000000, true))->>'success')::boolean,
  'T-IDM-06: Pemanggilan ulang create_wallet_v1 dengan client_request_id sama berhasil'
);

select is(
  (select count(*) from public.wallets where user_id = current_setting('test.rizky_id')::uuid),
  2::bigint,
  'T-IDM-06: Tidak ada dompet duplikat yang dibuat (tetap 2 dompet)'
);

-- 8. T-WAL-05: update_wallet_v1 mengubah saldo awal
select ok(
  (select (public.update_wallet_v1(gen_random_uuid(), current_setting('test.bca_id')::uuid, 'Bank BCA Prioritas', 'bank', 25000000, true))->>'success')::boolean,
  'T-WAL-05: update_wallet_v1 berhasil memperbarui nama dan saldo awal'
);

select is(
  (select opening_balance from public.wallets where id = current_setting('test.bca_id')::uuid),
  25000000::bigint,
  'T-WAL-05: Saldo awal dompet BCA berhasil diperbarui menjadi 25.000.000'
);

select * from finish();
rollback;

