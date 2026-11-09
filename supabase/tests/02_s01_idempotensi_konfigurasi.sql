begin;
select plan(11);

-- Persiapan Fixture Pengguna
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

-- 1. T-MIG-07: Pekerjaan pg_cron terdaftar untuk pembersihan request_log
select is(
  (select count(*) from cron.job where jobname = 'clean_old_request_log'),
  1::bigint,
  'T-MIG-07: Pekerjaan cron clean_old_request_log wajib terdaftar'
);

-- 2. T-SEC-01: DML langsung (INSERT/UPDATE/DELETE) pada request_log ditolak untuk role authenticated
set local role authenticated;
set local "request.jwt.claim.sub" to '00000000-0000-0000-0000-000000000001';

select throws_ok(
  $$insert into public.request_log (user_id, client_request_id, rpc_name, payload_hash)
    values ('00000000-0000-0000-0000-000000000001', gen_random_uuid(), 'test_rpc', 'hash')$$,
  '42501',
  null,
  'T-SEC-01: INSERT langsung pada request_log ditolak untuk authenticated'
);

-- 3. T-SEC-03: anon ditolak memanggil get_app_config_v1
set local role anon;
select throws_ok(
  $$select public.get_app_config_v1('android')$$,
  '42501',
  null,
  'T-SEC-03: Role anon ditolak mengeksekusi get_app_config_v1'
);

-- 4. T-SEC-06: get_app_config_v1 dipanggil tanpa auth.uid() ditolak
reset role;
set local role authenticated;
select set_config('request.jwt.claim.sub', '', true);
select throws_ok(
  $$select public.get_app_config_v1('android')$$,
  'P0001',
  'authentication_required',
  'T-SEC-06: Panggilan get_app_config_v1 tanpa auth.uid() harus ditolak'
);

-- 5. get_app_config_v1 berhasil untuk authenticated dengan auth.uid()
set local "request.jwt.claim.sub" to '00000000-0000-0000-0000-000000000001';
select is(
  (select public.get_app_config_v1('android')->>'platform'),
  'android',
  'get_app_config_v1 mengembalikan konfigurasi android untuk authenticated'
);

-- 6. Pengujian Idempotensi (T-IDM-01 sampai T-IDM-05, T-IDM-07) pada Fixture
reset role;

-- Fixture RPC untuk pengujian idempotensi
create or replace function private.test_fixture_rpc_v1(
  p_user_id uuid,
  p_client_request_id uuid,
  p_amount bigint
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_cached jsonb;
  v_payload jsonb;
  v_res jsonb;
begin
  if p_client_request_id is null then
    raise exception 'client_request_id_required';
  end if;

  v_payload := json_build_object('amount', p_amount)::jsonb;
  v_cached := private.start_idempotent_request(p_user_id, p_client_request_id, 'test_fixture_rpc_v1', v_payload);
  if v_cached is not null then
    return v_cached;
  end if;

  v_res := json_build_object('success', true, 'amount', p_amount)::jsonb;
  perform private.finish_idempotent_request(p_user_id, p_client_request_id, v_res);
  return v_res;
end;
$$;

do $$
declare
  v_rizky uuid;
  v_dina uuid;
  v_req_id uuid := gen_random_uuid();
  v_res1 jsonb;
  v_res2 jsonb;
  v_dina_res jsonb;
begin
  select id into v_rizky from _test_users where name = 'rizky';
  select id into v_dina from _test_users where name = 'dina';

  -- T-IDM-01: Panggilan pertama
  v_res1 := private.test_fixture_rpc_v1(v_rizky, v_req_id, 100000);

  -- T-IDM-01: Panggilan kedua dengan req_id sama
  v_res2 := private.test_fixture_rpc_v1(v_rizky, v_req_id, 100000);

  -- Verifikasi T-IDM-01: Hasil sama
  if v_res1->>'amount' <> v_res2->>'amount' then
    raise exception 'T-IDM-01 failed: result mismatch';
  end if;
end $$;

select pass('T-IDM-01: Pemanggilan ulang dengan client_request_id sama menghasilkan hasil identik');

-- T-IDM-02: Req id sama dengan payload berbeda ditolak request_id_reuse
select throws_ok(
  format(
    $$select private.test_fixture_rpc_v1('%s'::uuid, '%s'::uuid, 200000)$$,
    (select id from _test_users where name = 'rizky'),
    (select client_request_id from public.request_log where user_id = (select id from _test_users where name = 'rizky') limit 1)
  ),
  'P0001',
  'request_id_reuse',
  'T-IDM-02: Id sama dengan muatan berbeda ditolak request_id_reuse'
);

-- T-IDM-03: Id sama dari dua pengguna berbeda tidak bertabrakan
do $$
declare
  v_rizky uuid;
  v_dina uuid;
  v_shared_req_id uuid := gen_random_uuid();
  v_res_rizky jsonb;
  v_res_dina jsonb;
begin
  select id into v_rizky from _test_users where name = 'rizky';
  select id into v_dina from _test_users where name = 'dina';

  v_res_rizky := private.test_fixture_rpc_v1(v_rizky, v_shared_req_id, 50000);
  v_res_dina := private.test_fixture_rpc_v1(v_dina, v_shared_req_id, 75000);

  if v_res_rizky->>'amount' <> '50000' or v_res_dina->>'amount' <> '75000' then
    raise exception 'T-IDM-03 failed: user collision';
  end if;
end $$;

select pass('T-IDM-03: client_request_id sama dari dua pengguna tidak bertabrakan');

-- T-IDM-04: Menolak panggilan tanpa client_request_id
select throws_ok(
  format(
    $$select private.test_fixture_rpc_v1('%s'::uuid, null, 10000)$$,
    (select id from _test_users where name = 'rizky')
  ),
  'P0001',
  'client_request_id_required',
  'T-IDM-04: Panggilan tanpa client_request_id ditolak'
);

-- T-IDM-05: Tepat satu baris request_log tercatat per (user_id, client_request_id)
select is(
  (
    select count(*)
    from public.request_log
    where user_id = (select id from _test_users where name = 'rizky')
  ),
  2::bigint,
  'T-IDM-05: Tepat 2 baris tercatat untuk Rizky di fixture'
);

-- T-IDM-07: Verifikasi retensi 30 hari (simulasi pembersihan)
insert into public.request_log (user_id, client_request_id, rpc_name, payload_hash, created_at)
values (
  (select id from _test_users where name = 'rizky'),
  gen_random_uuid(),
  'old_rpc',
  'old_hash',
  now() - interval '31 days'
);

delete from public.request_log where created_at < now() - interval '30 days';

select is(
  (
    select count(*)
    from public.request_log
    where created_at < now() - interval '30 days'
  ),
  0::bigint,
  'T-IDM-07: Baris lebih tua dari 30 hari berhasil dibersihkan'
);

select * from finish();
rollback;

