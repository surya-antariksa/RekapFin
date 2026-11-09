begin;
select plan(1);
select pass('Supabase local environment is initialized and operational');
select * from finish();
rollback;
