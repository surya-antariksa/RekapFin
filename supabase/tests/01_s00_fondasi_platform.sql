begin;
select plan(12);

-- 1. Uji ekstensi terpasang
select has_extension('pg_trgm', 'Ekstensi pg_trgm harus terpasang');
select has_extension('pg_cron', 'Ekstensi pg_cron harus terpasang');

-- 2. Uji skema private
select has_schema('private', 'Skema private harus ada');

-- 3. Uji enum platform utama
select has_type('public', 'transaction_type', 'Tipe public.transaction_type harus ada');
select has_type('public', 'transaction_source', 'Tipe public.transaction_source harus ada');
select has_type('public', 'wallet_kind', 'Tipe public.wallet_kind harus ada');
select has_type('public', 'category_kind', 'Tipe public.category_kind harus ada');
select has_type('public', 'debt_direction', 'Tipe public.debt_direction harus ada');
select has_type('public', 'payment_channel', 'Tipe public.payment_channel harus ada');

-- 4. T-SEC-04: Semua fungsi SECURITY DEFINER harus memiliki search_path tetap
select is(
  (
    select count(*)
    from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where p.prosecdef = true
      and n.nspname in ('public', 'private')
      and (p.proconfig is null or not exists (
        select 1 from unnest(p.proconfig) cfg where cfg like 'search_path=%'
      ))
  ),
  0::bigint,
  'T-SEC-04: Semua fungsi SECURITY DEFINER di public dan private wajib memiliki search_path tetap'
);

-- 5. T-SEC-05: Tidak ada fungsi di skema public yang dapat dieksekusi oleh anon atau PUBLIC
select is(
  (
    select count(*)
    from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public'
      and (
        has_function_privilege('anon', p.oid, 'EXECUTE')
        or has_function_privilege('public', p.oid, 'EXECUTE')
      )
  ),
  0::bigint,
  'T-SEC-05: Tidak boleh ada fungsi di public yang executable oleh anon atau PUBLIC'
);

-- 6. T-RLS-10: Semua tabel di skema public harus mengaktifkan Row Level Security
select is(
  (
    select count(*)
    from pg_class c
    join pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public'
      and c.relkind in ('r', 'p')
      and not c.relrowsecurity
  ),
  0::bigint,
  'T-RLS-10: Semua tabel di skema public wajib mengaktifkan RLS'
);

select * from finish();
rollback;

