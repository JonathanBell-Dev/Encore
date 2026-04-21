-- Event chat messages
create table if not exists event_messages (
  id          uuid primary key default gen_random_uuid(),
  event_id    uuid not null references events(id) on delete cascade,
  sender_id   uuid not null references accounts(id) on delete cascade,
  body        text not null check (char_length(body) <= 2000),
  created_at  timestamptz not null default now()
);

create index if not exists event_messages_event_id_idx on event_messages(event_id, created_at);

-- RLS
alter table event_messages enable row level security;

-- Attendees and organizer can read messages
create policy "event_messages_read" on event_messages
  for select using (
    exists (
      select 1 from event_attendance
      where event_attendance.event_id = event_messages.event_id
        and event_attendance.account_id = auth.uid()
    )
    or exists (
      select 1 from events
      where events.id = event_messages.event_id
        and events.organizer_id = auth.uid()
    )
  );

-- Attendees and organizer can insert messages
create policy "event_messages_insert" on event_messages
  for insert with check (
    sender_id = auth.uid()
    and (
      exists (
        select 1 from event_attendance
        where event_attendance.event_id = event_messages.event_id
          and event_attendance.account_id = auth.uid()
      )
      or exists (
        select 1 from events
        where events.id = event_messages.event_id
          and events.organizer_id = auth.uid()
      )
    )
  );

-- Users can only delete their own messages
create policy "event_messages_delete" on event_messages
  for delete using (sender_id = auth.uid());
