-- Provision public beta signup lead capture for the landing page form.
-- Anonymous users may insert, but browser clients cannot read submitted leads.

create extension if not exists "pgcrypto";

create table if not exists public.beta_signups (
  id uuid primary key default gen_random_uuid(),
  full_name text not null,
  company text not null,
  email text not null,
  referral_source text,
  user_agent text,
  created_at timestamptz default now()
);

alter table public.beta_signups add column if not exists full_name text;
alter table public.beta_signups add column if not exists company text;
alter table public.beta_signups add column if not exists email text;
alter table public.beta_signups add column if not exists referral_source text;
alter table public.beta_signups add column if not exists user_agent text;
alter table public.beta_signups add column if not exists created_at timestamptz default now();

create index if not exists idx_beta_signups_email on public.beta_signups(email);
create index if not exists idx_beta_signups_created_at on public.beta_signups(created_at desc);

alter table public.beta_signups enable row level security;

drop policy if exists "beta_signups_anon_insert" on public.beta_signups;
create policy "beta_signups_anon_insert" on public.beta_signups
  for insert
  to anon
  with check (true);
