-- Reports table: users can flag content or other users
create table if not exists public.reports (
  id            uuid primary key default gen_random_uuid(),
  reporter_id   uuid not null references public.accounts(id) on delete cascade,
  target_type   text not null check (target_type in ('event','post','comment','user')),
  target_id     uuid not null,
  reason        text not null check (reason in ('spam','harassment','inappropriate','misinformation','other')),
  details       text,
  created_at    timestamptz not null default now()
);

-- Blocks table: users can block other users
create table if not exists public.blocks (
  id          uuid primary key default gen_random_uuid(),
  blocker_id  uuid not null references public.accounts(id) on delete cascade,
  blocked_id  uuid not null references public.accounts(id) on delete cascade,
  created_at  timestamptz not null default now(),
  unique (blocker_id, blocked_id)
);

-- Only reporter can see their own reports; admins see all (add admin role later)
alter table public.reports enable row level security;
create policy "reporters see own" on public.reports for select using (reporter_id = auth.uid());
create policy "reporters insert" on public.reports for insert with check (reporter_id = auth.uid());

-- Blocks: each user sees only their own blocks
alter table public.blocks enable row level security;
create policy "blocker select" on public.blocks for select using (blocker_id = auth.uid());
create policy "blocker insert" on public.blocks for insert with check (blocker_id = auth.uid());
create policy "blocker delete" on public.blocks for delete using (blocker_id = auth.uid());
