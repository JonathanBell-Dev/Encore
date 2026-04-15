-- ============================================================
-- Row Level Security Policies for Encore
-- Safe to re-run: drops existing policies before recreating them.
-- Run this in the Supabase SQL editor (Dashboard → SQL Editor).
-- ============================================================

-- ── Enable RLS on every table ────────────────────────────────
ALTER TABLE public.accounts          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.account_interests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.events            ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.event_attendance  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.event_favorites   ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.event_images      ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.connections       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.posts             ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.post_comments     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.post_likes        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.post_favorites    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.post_images       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.interests         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.neighborhoods     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tickets           ENABLE ROW LEVEL SECURITY;


-- ── accounts ─────────────────────────────────────────────────
-- Any authenticated user can read any account (needed for showing
-- post/comment authors, connections, etc. throughout the app).
-- Only the owner can modify their own row.

DROP POLICY IF EXISTS "accounts_public_read"        ON public.accounts;
DROP POLICY IF EXISTS "accounts_authenticated_read" ON public.accounts;
DROP POLICY IF EXISTS "accounts_owner_insert"       ON public.accounts;
DROP POLICY IF EXISTS "accounts_owner_update"       ON public.accounts;
DROP POLICY IF EXISTS "accounts_owner_delete"       ON public.accounts;

CREATE POLICY "accounts_authenticated_read" ON public.accounts
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "accounts_owner_insert" ON public.accounts
  FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "accounts_owner_update" ON public.accounts
  FOR UPDATE USING (auth.uid() = id) WITH CHECK (auth.uid() = id);

CREATE POLICY "accounts_owner_delete" ON public.accounts
  FOR DELETE USING (auth.uid() = id);


-- ── account_interests ────────────────────────────────────────

DROP POLICY IF EXISTS "account_interests_read"        ON public.account_interests;
DROP POLICY IF EXISTS "account_interests_owner_write" ON public.account_interests;

CREATE POLICY "account_interests_read" ON public.account_interests
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "account_interests_owner_write" ON public.account_interests
  FOR ALL USING (auth.uid() = account_id) WITH CHECK (auth.uid() = account_id);


-- ── interests (lookup table) ─────────────────────────────────

DROP POLICY IF EXISTS "interests_authenticated_read" ON public.interests;

CREATE POLICY "interests_authenticated_read" ON public.interests
  FOR SELECT TO authenticated USING (true);


-- ── neighborhoods (lookup table) ─────────────────────────────

DROP POLICY IF EXISTS "neighborhoods_public_read" ON public.neighborhoods;

CREATE POLICY "neighborhoods_public_read" ON public.neighborhoods
  FOR SELECT USING (true);


-- ── events ───────────────────────────────────────────────────

DROP POLICY IF EXISTS "events_published_read"    ON public.events;
DROP POLICY IF EXISTS "events_organizer_insert"  ON public.events;
DROP POLICY IF EXISTS "events_organizer_update"  ON public.events;
DROP POLICY IF EXISTS "events_organizer_delete"  ON public.events;

CREATE POLICY "events_published_read" ON public.events
  FOR SELECT USING (status = 'published' OR auth.uid() = organizer_id);

CREATE POLICY "events_organizer_insert" ON public.events
  FOR INSERT WITH CHECK (auth.uid() = organizer_id);

CREATE POLICY "events_organizer_update" ON public.events
  FOR UPDATE USING (auth.uid() = organizer_id) WITH CHECK (auth.uid() = organizer_id);

CREATE POLICY "events_organizer_delete" ON public.events
  FOR DELETE USING (auth.uid() = organizer_id);


-- ── event_images ─────────────────────────────────────────────

DROP POLICY IF EXISTS "event_images_read"             ON public.event_images;
DROP POLICY IF EXISTS "event_images_organizer_write"  ON public.event_images;

CREATE POLICY "event_images_read" ON public.event_images
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.events e
      WHERE e.id = event_id AND (e.status = 'published' OR e.organizer_id = auth.uid())
    )
  );

CREATE POLICY "event_images_organizer_write" ON public.event_images
  FOR ALL USING (
    EXISTS (SELECT 1 FROM public.events e WHERE e.id = event_id AND e.organizer_id = auth.uid())
  ) WITH CHECK (
    EXISTS (SELECT 1 FROM public.events e WHERE e.id = event_id AND e.organizer_id = auth.uid())
  );


-- ── event_attendance ─────────────────────────────────────────

DROP POLICY IF EXISTS "event_attendance_read"        ON public.event_attendance;
DROP POLICY IF EXISTS "event_attendance_owner_write" ON public.event_attendance;

CREATE POLICY "event_attendance_read" ON public.event_attendance
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "event_attendance_owner_write" ON public.event_attendance
  FOR ALL USING (auth.uid() = account_id) WITH CHECK (auth.uid() = account_id);


-- ── event_favorites ──────────────────────────────────────────

DROP POLICY IF EXISTS "event_favorites_owner_only" ON public.event_favorites;

CREATE POLICY "event_favorites_owner_only" ON public.event_favorites
  FOR ALL USING (auth.uid() = account_id) WITH CHECK (auth.uid() = account_id);


-- ── connections ──────────────────────────────────────────────

DROP POLICY IF EXISTS "connections_participant_read"   ON public.connections;
DROP POLICY IF EXISTS "connections_requester_insert"   ON public.connections;
DROP POLICY IF EXISTS "connections_participant_update" ON public.connections;
DROP POLICY IF EXISTS "connections_participant_delete" ON public.connections;

CREATE POLICY "connections_participant_read" ON public.connections
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "connections_requester_insert" ON public.connections
  FOR INSERT WITH CHECK (auth.uid() = requester_id);

CREATE POLICY "connections_participant_update" ON public.connections
  FOR UPDATE USING (auth.uid() = addressee_id OR auth.uid() = requester_id);

CREATE POLICY "connections_participant_delete" ON public.connections
  FOR DELETE USING (auth.uid() = requester_id OR auth.uid() = addressee_id);


-- ── messages ─────────────────────────────────────────────────

DROP POLICY IF EXISTS "messages_participant_read" ON public.messages;
DROP POLICY IF EXISTS "messages_sender_insert"    ON public.messages;
DROP POLICY IF EXISTS "messages_sender_delete"    ON public.messages;

CREATE OR REPLACE FUNCTION public.are_connected(a uuid, b uuid)
RETURNS boolean LANGUAGE sql SECURITY DEFINER AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.connections
    WHERE status = 'accepted'
      AND ((requester_id = a AND addressee_id = b)
        OR (requester_id = b AND addressee_id = a))
  );
$$;

CREATE POLICY "messages_participant_read" ON public.messages
  FOR SELECT USING (auth.uid() = sender_id OR auth.uid() = recipient_id);

CREATE POLICY "messages_sender_insert" ON public.messages
  FOR INSERT WITH CHECK (
    auth.uid() = sender_id
    AND public.are_connected(sender_id, recipient_id)
  );

CREATE POLICY "messages_sender_delete" ON public.messages
  FOR DELETE USING (auth.uid() = sender_id);


-- ── posts ────────────────────────────────────────────────────

DROP POLICY IF EXISTS "posts_authenticated_read" ON public.posts;
DROP POLICY IF EXISTS "posts_author_insert"      ON public.posts;
DROP POLICY IF EXISTS "posts_author_update"      ON public.posts;
DROP POLICY IF EXISTS "posts_author_delete"      ON public.posts;

CREATE POLICY "posts_authenticated_read" ON public.posts
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "posts_author_insert" ON public.posts
  FOR INSERT WITH CHECK (auth.uid() = account_id);

CREATE POLICY "posts_author_update" ON public.posts
  FOR UPDATE USING (auth.uid() = account_id) WITH CHECK (auth.uid() = account_id);

CREATE POLICY "posts_author_delete" ON public.posts
  FOR DELETE USING (auth.uid() = account_id);


-- ── post_comments ────────────────────────────────────────────

DROP POLICY IF EXISTS "post_comments_authenticated_read" ON public.post_comments;
DROP POLICY IF EXISTS "post_comments_author_insert"      ON public.post_comments;
DROP POLICY IF EXISTS "post_comments_author_delete"      ON public.post_comments;

CREATE POLICY "post_comments_authenticated_read" ON public.post_comments
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "post_comments_author_insert" ON public.post_comments
  FOR INSERT WITH CHECK (auth.uid() = account_id);

CREATE POLICY "post_comments_author_delete" ON public.post_comments
  FOR DELETE USING (auth.uid() = account_id);


-- ── post_likes ───────────────────────────────────────────────

DROP POLICY IF EXISTS "post_likes_authenticated_read" ON public.post_likes;
DROP POLICY IF EXISTS "post_likes_owner_write"        ON public.post_likes;

CREATE POLICY "post_likes_authenticated_read" ON public.post_likes
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "post_likes_owner_write" ON public.post_likes
  FOR ALL USING (auth.uid() = account_id) WITH CHECK (auth.uid() = account_id);


-- ── post_favorites ───────────────────────────────────────────

DROP POLICY IF EXISTS "post_favorites_owner_only" ON public.post_favorites;

CREATE POLICY "post_favorites_owner_only" ON public.post_favorites
  FOR ALL USING (auth.uid() = account_id) WITH CHECK (auth.uid() = account_id);


-- ── post_images ──────────────────────────────────────────────

DROP POLICY IF EXISTS "post_images_authenticated_read"  ON public.post_images;
DROP POLICY IF EXISTS "post_images_post_author_write"   ON public.post_images;

CREATE POLICY "post_images_authenticated_read" ON public.post_images
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "post_images_post_author_write" ON public.post_images
  FOR ALL USING (
    EXISTS (SELECT 1 FROM public.posts p WHERE p.id = post_id AND p.account_id = auth.uid())
  ) WITH CHECK (
    EXISTS (SELECT 1 FROM public.posts p WHERE p.id = post_id AND p.account_id = auth.uid())
  );


-- ── tickets ──────────────────────────────────────────────────

DROP POLICY IF EXISTS "tickets_owner_only" ON public.tickets;

CREATE POLICY "tickets_owner_only" ON public.tickets
  FOR ALL USING (auth.uid() = account_id) WITH CHECK (auth.uid() = account_id);
