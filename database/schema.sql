-- ============================================================
-- Encore / ATL Events — Executable Schema
-- Run this FIRST in Supabase SQL Editor (Dashboard → SQL Editor)
-- ============================================================

-- ── Extensions ───────────────────────────────────────────────
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- ── Enum types ───────────────────────────────────────────────
CREATE TYPE connection_status AS ENUM ('pending', 'accepted', 'declined');
CREATE TYPE attendance_status AS ENUM ('going', 'interested');
CREATE TYPE event_status      AS ENUM ('draft', 'published', 'cancelled');
CREATE TYPE ticket_status     AS ENUM ('active', 'cancelled', 'refunded');

-- ── Lookup tables (no foreign-key deps) ──────────────────────

CREATE TABLE public.interests (
  id   serial      PRIMARY KEY,
  name varchar NOT NULL UNIQUE
);

CREATE TABLE public.neighborhoods (
  id   serial      PRIMARY KEY,
  name varchar NOT NULL UNIQUE,
  slug varchar NOT NULL UNIQUE,
  geo  geography                        -- polygon for neighborhood boundary
);

-- ── Core tables ───────────────────────────────────────────────

CREATE TABLE public.accounts (
  id                     uuid        PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  first_name             varchar     NOT NULL DEFAULT '',
  last_name              varchar     NOT NULL DEFAULT '',
  user_name              varchar     NOT NULL UNIQUE,
  location               text,                          -- display string, e.g. "Atlanta, GA"
  bio                    text,
  avatar_url             varchar,
  website_url            varchar,
  instagram_url          varchar,
  twitter_url            varchar,
  tiktok_url             varchar,
  is_public              boolean     NOT NULL DEFAULT true,
  show_attending         boolean     NOT NULL DEFAULT true,
  show_connections       boolean     NOT NULL DEFAULT true,
  email_recommendations  boolean     NOT NULL DEFAULT true,
  notify_connections     boolean     NOT NULL DEFAULT false,
  created_at             timestamptz          DEFAULT now(),
  updated_at             timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.account_interests (
  account_id  uuid    NOT NULL REFERENCES public.accounts(id)   ON DELETE CASCADE,
  interest_id integer NOT NULL REFERENCES public.interests(id)  ON DELETE CASCADE,
  PRIMARY KEY (account_id, interest_id)
);

CREATE TABLE public.events (
  id               uuid         PRIMARY KEY DEFAULT gen_random_uuid(),
  organizer_id     uuid         NOT NULL REFERENCES public.accounts(id)       ON DELETE CASCADE,
  title            varchar      NOT NULL,
  description      text,
  category         varchar,
  vibe_tags        text[],
  neighborhood_id  integer      REFERENCES public.neighborhoods(id),
  venue_name       varchar,
  address          varchar,
  location         geography(Point, 4326),              -- lat/lng for map features
  starts_at        timestamptz  NOT NULL,
  ends_at          timestamptz,
  cover_image_url  varchar,
  ticket_price     numeric               DEFAULT 0,
  ticket_url       varchar,
  capacity         integer,
  status           event_status NOT NULL DEFAULT 'published',
  is_free          boolean      NOT NULL DEFAULT false,
  created_at       timestamptz  NOT NULL DEFAULT now(),
  updated_at       timestamptz  NOT NULL DEFAULT now()
);

CREATE TABLE public.event_attendance (
  account_id  uuid              NOT NULL REFERENCES public.accounts(id) ON DELETE CASCADE,
  event_id    uuid              NOT NULL REFERENCES public.events(id)   ON DELETE CASCADE,
  status      attendance_status NOT NULL DEFAULT 'going',
  created_at  timestamptz       NOT NULL DEFAULT now(),
  PRIMARY KEY (account_id, event_id)
);

CREATE TABLE public.event_favorites (
  account_id  uuid        NOT NULL REFERENCES public.accounts(id) ON DELETE CASCADE,
  event_id    uuid        NOT NULL REFERENCES public.events(id)   ON DELETE CASCADE,
  created_at  timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (account_id, event_id)
);

CREATE TABLE public.event_images (
  id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  event_id    uuid        NOT NULL REFERENCES public.events(id) ON DELETE CASCADE,
  image_url   varchar     NOT NULL,
  sort_order  integer     NOT NULL DEFAULT 0,
  created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.connections (
  id            uuid              PRIMARY KEY DEFAULT gen_random_uuid(),
  requester_id  uuid              NOT NULL REFERENCES public.accounts(id) ON DELETE CASCADE,
  addressee_id  uuid              NOT NULL REFERENCES public.accounts(id) ON DELETE CASCADE,
  status        connection_status NOT NULL DEFAULT 'pending',
  created_at    timestamptz       NOT NULL DEFAULT now(),
  updated_at    timestamptz       NOT NULL DEFAULT now()
);

CREATE TABLE public.messages (
  id            uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  sender_id     uuid        NOT NULL REFERENCES public.accounts(id) ON DELETE CASCADE,
  recipient_id  uuid        NOT NULL REFERENCES public.accounts(id) ON DELETE CASCADE,
  body          text        NOT NULL,
  read_at       timestamptz,
  created_at    timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.posts (
  id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  account_id  uuid        NOT NULL REFERENCES public.accounts(id) ON DELETE CASCADE,
  title       varchar     NOT NULL,
  content     text        NOT NULL,
  event_id    uuid        REFERENCES public.events(id) ON DELETE SET NULL,
  created_at  timestamptz          DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.post_comments (
  id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id     uuid        NOT NULL REFERENCES public.posts(id)    ON DELETE CASCADE,
  account_id  uuid        NOT NULL REFERENCES public.accounts(id) ON DELETE CASCADE,
  content     text        NOT NULL,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.post_likes (
  account_id  uuid        NOT NULL REFERENCES public.accounts(id) ON DELETE CASCADE,
  post_id     uuid        NOT NULL REFERENCES public.posts(id)    ON DELETE CASCADE,
  created_at  timestamptz          DEFAULT now(),
  PRIMARY KEY (account_id, post_id)
);

CREATE TABLE public.post_favorites (
  account_id  uuid        NOT NULL REFERENCES public.accounts(id) ON DELETE CASCADE,
  post_id     uuid        NOT NULL REFERENCES public.posts(id)    ON DELETE CASCADE,
  created_at  timestamptz          DEFAULT now(),
  PRIMARY KEY (account_id, post_id)
);

CREATE TABLE public.post_images (
  id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id     uuid        NOT NULL REFERENCES public.posts(id) ON DELETE CASCADE,
  image_url   varchar     NOT NULL,
  sort_order  integer     NOT NULL DEFAULT 0,
  created_at  timestamptz          DEFAULT now()
);

CREATE TABLE public.tickets (
  id           uuid          PRIMARY KEY DEFAULT gen_random_uuid(),
  account_id   uuid          NOT NULL REFERENCES public.accounts(id) ON DELETE CASCADE,
  event_id     uuid          NOT NULL REFERENCES public.events(id)   ON DELETE CASCADE,
  quantity     integer       NOT NULL DEFAULT 1 CHECK (quantity > 0),
  unit_price   numeric       NOT NULL DEFAULT 0,
  total_price  numeric       GENERATED ALWAYS AS (quantity::numeric * unit_price) STORED,
  status       ticket_status NOT NULL DEFAULT 'active',
  purchased_at timestamptz   NOT NULL DEFAULT now()
);
