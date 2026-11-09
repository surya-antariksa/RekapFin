begin;
select plan(15);

-- Persiapan Fixture Pengguna (Rizky & Dina)
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

-- 1. T-SEC-03: anon ditolak memanggil request_account_deletion_v1 & purge_user_data_v1
set local role anon;

select throws_ok(
  $$select public.request_account_deletion_v1(gen_random_uuid())$$,
  '42501',
  null,
  'T-SEC-03: Role anon ditolak memanggil request_account_deletion_v1'
);

select throws_ok(
  $$select public.purge_user_data_v1(current_setting('test.dina_id')::uuid)$$,
  '42501',
  null,
  'T-SEC-03: Role anon ditolak memanggil purge_user_data_v1'
);

-- 2. T-SEC-08: authenticated ditolak memanggil purge_user_data_v1
reset role;
set local role authenticated;
select set_config('request.jwt.claim.sub', current_setting('test.dina_id'), true);

select throws_ok(
  $$select public.purge_user_data_v1(current_setting('test.dina_id')::uuid)$$,
  '42501',
  null,
  'T-SEC-08: Role authenticated ditolak memanggil purge_user_data_v1'
);

-- 3. T-IDM-04: request_account_deletion_v1 menolak client_request_id null
select throws_ok(
  $$select public.request_account_deletion_v1(null)$$,
  'P0001',
  'client_request_id_required',
  'T-IDM-04: request_account_deletion_v1 menolak client_request_id null'
);

-- 4. request_account_deletion_v1 mengisi profiles.deletion_requested_at
select is(
  (select deletion_requested_at from public.profiles where id = current_setting('test.dina_id')::uuid),
  null,
  'Sebelum permintaan hapus akun, deletion_requested_at bernilai null'
);

do $$
declare
  v_req_id uuid := 'b0000000-0000-0000-0000-000000000001'::uuid;
  v_res jsonb;
begin
  v_res := public.request_account_deletion_v1(v_req_id);
end $$;

select ok(
  (select deletion_requested_at from public.profiles where id = current_setting('test.dina_id')::uuid) is not null,
  'deletion_requested_at terisi setelah memanggil request_account_deletion_v1'
);

-- Idempoten saat diulang dengan ID yang sama
select ok(
  (select (public.request_account_deletion_v1('b0000000-0000-0000-0000-000000000001'::uuid))->>'success')::boolean,
  'request_account_deletion_v1 idempoten saat diulang dengan client_request_id sama'
);

-- 5. Eksekusi purge_user_data_v1 sebagai service_role
reset role;
set local role service_role;

select ok(
  (select (public.purge_user_data_v1(current_setting('test.dina_id')::uuid))->>'success')::boolean,
  'purge_user_data_v1 berhasil dieksekusi oleh service_role'
);

-- 6. T-DEL-01: Verifikasi seluruh data Dina terhapus bersih
select is(
  (select count(*) from public.profiles where id = current_setting('test.dina_id')::uuid),
  0::bigint,
  'T-DEL-01: Profil Dina terhapus'
);

select is(
  (select count(*) from public.wallets where user_id = current_setting('test.dina_id')::uuid),
  0::bigint,
  'T-DEL-01: Dompet Dina terhapus'
);

select is(
  (select count(*) from public.categories where user_id = current_setting('test.dina_id')::uuid),
  0::bigint,
  'T-DEL-01: Kategori Dina terhapus'
);

-- 7. T-DEL-01: Verifikasi data Rizky tetap utuh
select is(
  (select count(*) from public.profiles where id = current_setting('test.rizky_id')::uuid),
  1::bigint,
  'T-DEL-01: Profil Rizky tetap utuh'
);

select is(
  (select count(*) from public.wallets where user_id = current_setting('test.rizky_id')::uuid),
  1::bigint,
  'T-DEL-01: Dompet Rizky tetap utuh'
);

-- 8. T-DEL-03: purge_user_data_v1 idempoten saat diulang
select ok(
  (select (public.purge_user_data_v1(current_setting('test.dina_id')::uuid))->>'success')::boolean,
  'T-DEL-03: purge_user_data_v1 dipanggil ulang sukses tanpa error'
);

-- 9. T-CHK-05: Graf FK di skema public bebas dari siklus (DAG tanpa relasi melingkar)
with recursive fk_edges as (
  select
    conrelid::regclass::text as from_table,
    confrelid::regclass::text as to_table
  from pg_constraint
  join pg_namespace n on n.oid = connamespace
  where contype = 'f' and n.nspname = 'public'
),
fk_paths as (
  select
    from_table,
    to_table,
    array[from_table] as path,
    false as is_cycle
  from fk_edges
  union all
  select
    p.from_table,
    e.to_table,
    p.path || e.from_table,
    e.to_table = any(p.path)
  from fk_paths p
  join fk_edges e on e.from_table = p.to_table
  where not p.is_cycle and array_length(p.path, 1) < 20
)
select is(
  (select count(*) from fk_paths where is_cycle = true),
  0::bigint,
  'T-CHK-05: Graf Foreign Key di skema public bebas siklus (tidak ada FK melingkar)'
);

select * from finish();
rollback;

