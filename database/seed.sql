-- ============================================================
-- Encore / ATL Events — Seed Data
-- Run this AFTER schema.sql in Supabase SQL Editor
-- ============================================================

-- ── Interests ─────────────────────────────────────────────────
INSERT INTO public.interests (name) VALUES
  ('Music'),
  ('Food & Drink'),
  ('Arts & Culture'),
  ('Sports'),
  ('Comedy'),
  ('Nightlife'),
  ('Outdoor & Adventure'),
  ('Film & Media'),
  ('Tech & Innovation'),
  ('Health & Wellness'),
  ('Family'),
  ('Business & Networking')
ON CONFLICT (name) DO NOTHING;

-- ── Atlanta neighborhoods ─────────────────────────────────────
INSERT INTO public.neighborhoods (name, slug) VALUES
  ('Old Fourth Ward',    'old-fourth-ward'),
  ('Little Five Points', 'little-five-points'),
  ('Midtown',            'midtown'),
  ('Buckhead',           'buckhead'),
  ('Grant Park',         'grant-park'),
  ('Inman Park',         'inman-park'),
  ('Poncey-Highland',    'poncey-highland'),
  ('East Atlanta',       'east-atlanta'),
  ('West End',           'west-end'),
  ('Decatur',            'decatur'),
  ('Edgewood',           'edgewood'),
  ('Castleberry Hill',   'castleberry-hill')
ON CONFLICT (slug) DO NOTHING;
