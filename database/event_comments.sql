-- ============================================================
-- event_comments table + RLS
-- Run this in Supabase SQL Editor after schema.sql and seed.sql.
-- Safe to re-run (uses IF NOT EXISTS / DROP POLICY IF EXISTS).
-- ============================================================

CREATE TABLE IF NOT EXISTS public.event_comments (
  id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  event_id    uuid        NOT NULL REFERENCES public.events(id)   ON DELETE CASCADE,
  account_id  uuid        NOT NULL REFERENCES public.accounts(id) ON DELETE CASCADE,
  content     text        NOT NULL,
  created_at  timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.event_comments ENABLE ROW LEVEL SECURITY;

-- Anyone can read comments on published events (or the organizer's own events)
DROP POLICY IF EXISTS "event_comments_read" ON public.event_comments;
CREATE POLICY "event_comments_read" ON public.event_comments
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.events e
      WHERE e.id = event_id
        AND (e.status = 'published' OR e.organizer_id = auth.uid())
    )
  );

-- Authenticated users can comment
DROP POLICY IF EXISTS "event_comments_author_insert" ON public.event_comments;
CREATE POLICY "event_comments_author_insert" ON public.event_comments
  FOR INSERT WITH CHECK (auth.uid() = account_id);

-- Authors can delete their own comments
DROP POLICY IF EXISTS "event_comments_author_delete" ON public.event_comments;
CREATE POLICY "event_comments_author_delete" ON public.event_comments
  FOR DELETE USING (auth.uid() = account_id);
