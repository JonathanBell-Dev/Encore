-- Admin flag on accounts
alter table public.accounts add column if not exists is_admin boolean not null default false;

-- Event check-ins
create table if not exists public.event_checkins (
  id          uuid primary key default gen_random_uuid(),
  event_id    uuid not null references public.events(id) on delete cascade,
  account_id  uuid not null references public.accounts(id) on delete cascade,
  checked_in_at timestamptz not null default now(),
  unique (event_id, account_id)
);

alter table public.event_checkins enable row level security;
create policy "organizer can view checkins" on public.event_checkins for select
  using (exists (select 1 from public.events e where e.id = event_id and e.organizer_id = auth.uid()));
create policy "attendee can check in" on public.event_checkins for insert
  with check (account_id = auth.uid());

-- Push subscriptions
create table if not exists public.push_subscriptions (
  id          uuid primary key default gen_random_uuid(),
  account_id  uuid not null references public.accounts(id) on delete cascade,
  endpoint    text not null,
  p256dh      text not null,
  auth        text not null,
  created_at  timestamptz not null default now(),
  unique (account_id, endpoint)
);

alter table public.push_subscriptions enable row level security;
create policy "owner select" on public.push_subscriptions for select using (account_id = auth.uid());
create policy "owner insert" on public.push_subscriptions for insert with check (account_id = auth.uid());
create policy "owner delete" on public.push_subscriptions for delete using (account_id = auth.uid());
