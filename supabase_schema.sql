-- Birthday Jeng live database starter (Supabase PostgreSQL)
-- SECURITY NOTE: Never put the Supabase service-role key in the browser.
-- Guest code validation and admin actions must be implemented through Edge Functions.

create extension if not exists pgcrypto;

create table if not exists public.guests (
  id uuid primary key default gen_random_uuid(),
  nickname text not null,
  full_name text not null,
  instagram text,
  secret_code_hash text unique not null,
  avatar_path text,
  is_admin boolean not null default false,
  deleted_at timestamptz,
  created_at timestamptz not null default now()
);

create table if not exists public.guest_state (
  guest_id uuid primary key references public.guests(id) on delete cascade,
  rsvp text not null default 'PENDING' check (rsvp in ('PENDING','YES','NO')),
  plus_one_name text,
  description text,
  photo_verified boolean not null default false,
  fortune_credits integer not null default 2 check (fortune_credits between 0 and 2),
  updated_at timestamptz not null default now()
);

create table if not exists public.fortune_draws (
  id uuid primary key default gen_random_uuid(),
  guest_id uuid not null references public.guests(id) on delete cascade,
  draw_number integer not null check (draw_number in (1,2)),
  fortune_text text not null,
  category text not null,
  created_at timestamptz not null default now(),
  unique (guest_id, draw_number),
  unique (fortune_text)
);

create table if not exists public.fortune_pool (
  id uuid primary key default gen_random_uuid(),
  category text not null,
  fortune_text text not null unique,
  enabled boolean not null default true
);

create table if not exists public.event_settings (
  key text primary key,
  value jsonb not null,
  updated_at timestamptz not null default now()
);

insert into public.event_settings(key,value) values
 ('plus_one_limit','3'::jsonb),
 ('rsvp_deadline','"2027-01-29"'::jsonb),
 ('event_datetime','"2027-01-30T21:00:00+08:00"'::jsonb),
 ('event_venue','"Alibaba, M3 Mall"'::jsonb)
on conflict (key) do nothing;

alter table public.guests enable row level security;
alter table public.guest_state enable row level security;
alter table public.fortune_draws enable row level security;
alter table public.fortune_pool enable row level security;
alter table public.event_settings enable row level security;

-- No direct anonymous policies are intentionally added.
-- Use Edge Functions with service role (server-side only) for code validation,
-- guest data reads/writes, capacity enforcement, Fortune draws, and admin actions.
