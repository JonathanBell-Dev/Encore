

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS postgis;


-- ============================================================
--  ACCOUNTS  — add new columns to existing table
-- ============================================================
ALTER TABLE public.accounts
  ADD COLUMN IF NOT EXISTS bio                    text,
  ADD COLUMN IF NOT EXISTS avatar_url             varchar,
  ADD COLUMN IF NOT EXISTS website_url            varchar,
  ADD COLUMN IF NOT EXISTS is_public              boolean     NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS show_attending         boolean     NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS show_connections       boolean     NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS email_recommendations  boolean     NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS notify_connections     boolean     NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS updated_at             timestamptz NOT NULL DEFAULT now();


-- ============================================================
--  SHARED updated_at TRIGGER FUNCTION
-- ============================================================
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS accounts_updated_at ON public.accounts;
CREATE TRIGGER accounts_updated_at
  BEFORE UPDATE ON public.accounts
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


-- ============================================================
--  AUTO-CREATE ACCOUNT ROW ON SIGN-UP
-- ============================================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  INSERT INTO public.accounts (id, first_name, last_name, user_name)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'first_name', ''),
    COALESCE(NEW.raw_user_meta_data->>'last_name', ''),
    COALESCE(NEW.raw_user_meta_data->>'user_name', NEW.email)
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


-- ============================================================
--  INTERESTS
-- ============================================================
CREATE TABLE IF NOT EXISTS public.interests (
  id    serial  PRIMARY KEY,
  name  varchar NOT NULL UNIQUE
);

INSERT INTO public.interests (name) VALUES
  ('Music'), ('Food & Drink'), ('Arts & Culture'), ('Sports'),
  ('Comedy'), ('Nightlife'), ('Outdoor & Adventure'), ('Film & Media'),
  ('Tech & Innovation'), ('Health & Wellness'), ('Family'),
  ('Business & Networking')
ON CONFLICT (name) DO NOTHING;

CREATE TABLE IF NOT EXISTS public.account_interests (
  account_id   uuid NOT NULL,
  interest_id  int  NOT NULL,
  CONSTRAINT account_interests_pkey          PRIMARY KEY (account_id, interest_id),
  CONSTRAINT account_interests_account_fkey  FOREIGN KEY (account_id)  REFERENCES public.accounts(id)  ON DELETE CASCADE,
  CONSTRAINT account_interests_interest_fkey FOREIGN KEY (interest_id) REFERENCES public.interests(id) ON DELETE CASCADE
);


-- ============================================================
--  CONNECTIONS
-- ============================================================
DO $$ BEGIN
  CREATE TYPE public.connection_status AS ENUM ('pending', 'accepted', 'declined');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

CREATE TABLE IF NOT EXISTS public.connections (
  id            uuid                     NOT NULL DEFAULT gen_random_uuid(),
  requester_id  uuid                     NOT NULL,
  addressee_id  uuid                     NOT NULL,
  status        public.connection_status NOT NULL DEFAULT 'pending',
  created_at    timestamptz              NOT NULL DEFAULT now(),
  updated_at    timestamptz              NOT NULL DEFAULT now(),

  CONSTRAINT connections_pkey         PRIMARY KEY (id),
  CONSTRAINT connections_no_self      CHECK (requester_id <> addressee_id),
  CONSTRAINT connections_unique       UNIQUE (requester_id, addressee_id),
  CONSTRAINT connections_requester_fk FOREIGN KEY (requester_id) REFERENCES public.accounts(id) ON DELETE CASCADE,
  CONSTRAINT connections_addressee_fk FOREIGN KEY (addressee_id) REFERENCES public.accounts(id) ON DELETE CASCADE
);

DROP TRIGGER IF EXISTS connections_updated_at ON public.connections;
CREATE TRIGGER connections_updated_at
  BEFORE UPDATE ON public.connections
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


-- ============================================================
--  NEIGHBORHOODS
-- ============================================================
CREATE TABLE IF NOT EXISTS public.neighborhoods (
  id    serial  PRIMARY KEY,
  name  varchar NOT NULL UNIQUE,
  slug  varchar NOT NULL UNIQUE,
  geo   geography(POLYGON, 4326)
);

INSERT INTO public.neighborhoods (name, slug) VALUES
  ('Old Fourth Ward',    'old-fourth-ward'),
  ('Little Five Points', 'little-five-points'),
  ('Midtown',            'midtown'),
  ('Buckhead',           'buckhead'),
  ('Grant Park',         'grant-park'),
  ('Inman Park',         'inman-park'),
  ('Ponce City Market',  'ponce-city-market'),
  ('Downtown',           'downtown'),
  ('East Atlanta',       'east-atlanta'),
  ('West End',           'west-end')
ON CONFLICT (slug) DO NOTHING;


-- ============================================================
--  EVENTS
-- ============================================================
DO $$ BEGIN
  CREATE TYPE public.event_status AS ENUM ('draft', 'published', 'cancelled', 'ended');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

CREATE TABLE IF NOT EXISTS public.events (
  id               uuid                NOT NULL DEFAULT gen_random_uuid(),
  organizer_id     uuid                NOT NULL,
  title            varchar             NOT NULL,
  description      text,
  category         varchar,
  vibe_tags        varchar[],
  neighborhood_id  int,
  venue_name       varchar,
  address          varchar,
  location         geography(POINT, 4326),
  starts_at        timestamptz         NOT NULL,
  ends_at          timestamptz,
  cover_image_url  varchar,
  ticket_price     numeric(10,2)       DEFAULT 0,
  ticket_url       varchar,
  capacity         int,
  status           public.event_status NOT NULL DEFAULT 'published',
  is_free          boolean             NOT NULL DEFAULT false,
  created_at       timestamptz         NOT NULL DEFAULT now(),
  updated_at       timestamptz         NOT NULL DEFAULT now(),

  CONSTRAINT events_pkey            PRIMARY KEY (id),
  CONSTRAINT events_organizer_fk    FOREIGN KEY (organizer_id)    REFERENCES public.accounts(id)      ON DELETE SET NULL,
  CONSTRAINT events_neighborhood_fk FOREIGN KEY (neighborhood_id) REFERENCES public.neighborhoods(id) ON DELETE SET NULL
);

DROP TRIGGER IF EXISTS events_updated_at ON public.events;
CREATE TRIGGER events_updated_at
  BEFORE UPDATE ON public.events
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TABLE IF NOT EXISTS public.event_images (
  id          uuid        NOT NULL DEFAULT gen_random_uuid(),
  event_id    uuid        NOT NULL,
  image_url   varchar     NOT NULL,
  sort_order  int         NOT NULL DEFAULT 0,
  created_at  timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT event_images_pkey     PRIMARY KEY (id),
  CONSTRAINT event_images_event_fk FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE
);


-- ============================================================
--  EVENT ATTENDANCE
-- ============================================================
DO $$ BEGIN
  CREATE TYPE public.attendance_status AS ENUM ('going', 'interested', 'not_going');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

CREATE TABLE IF NOT EXISTS public.event_attendance (
  account_id  uuid                     NOT NULL,
  event_id    uuid                     NOT NULL,
  status      public.attendance_status NOT NULL DEFAULT 'going',
  created_at  timestamptz              NOT NULL DEFAULT now(),

  CONSTRAINT event_attendance_pkey       PRIMARY KEY (account_id, event_id),
  CONSTRAINT event_attendance_account_fk FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE,
  CONSTRAINT event_attendance_event_fk   FOREIGN KEY (event_id)   REFERENCES public.events(id)   ON DELETE CASCADE
);


-- ============================================================
--  TICKETS
-- ============================================================
DO $$ BEGIN
  CREATE TYPE public.ticket_status AS ENUM ('active', 'used', 'refunded', 'cancelled');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

CREATE TABLE IF NOT EXISTS public.tickets (
  id           uuid                 NOT NULL DEFAULT gen_random_uuid(),
  account_id   uuid                 NOT NULL,
  event_id     uuid                 NOT NULL,
  quantity     int                  NOT NULL DEFAULT 1 CHECK (quantity > 0),
  unit_price   numeric(10,2)        NOT NULL DEFAULT 0,
  total_price  numeric(10,2)        GENERATED ALWAYS AS (quantity * unit_price) STORED,
  status       public.ticket_status NOT NULL DEFAULT 'active',
  purchased_at timestamptz          NOT NULL DEFAULT now(),

  CONSTRAINT tickets_pkey       PRIMARY KEY (id),
  CONSTRAINT tickets_account_fk FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE,
  CONSTRAINT tickets_event_fk   FOREIGN KEY (event_id)   REFERENCES public.events(id)   ON DELETE CASCADE
);


-- ============================================================
--  EVENT FAVORITES
-- ============================================================
CREATE TABLE IF NOT EXISTS public.event_favorites (
  account_id  uuid        NOT NULL,
  event_id    uuid        NOT NULL,
  created_at  timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT event_favorites_pkey       PRIMARY KEY (account_id, event_id),
  CONSTRAINT event_favorites_account_fk FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE,
  CONSTRAINT event_favorites_event_fk   FOREIGN KEY (event_id)   REFERENCES public.events(id)   ON DELETE CASCADE
);


-- ============================================================
--  POSTS 
-- ============================================================
ALTER TABLE public.posts
  ADD COLUMN IF NOT EXISTS event_id   uuid,
  ADD COLUMN IF NOT EXISTS updated_at timestamptz NOT NULL DEFAULT now();

DO $$ BEGIN
  ALTER TABLE public.posts
    ADD CONSTRAINT posts_event_fk
    FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE SET NULL;
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DROP TRIGGER IF EXISTS posts_updated_at ON public.posts;
CREATE TRIGGER posts_updated_at
  BEFORE UPDATE ON public.posts
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


-- ============================================================
--  POST IMAGES 
-- ============================================================
ALTER TABLE public.post_images
  ADD COLUMN IF NOT EXISTS sort_order int NOT NULL DEFAULT 0;


-- ============================================================
--  POST COMMENTS  
-- ============================================================
CREATE TABLE IF NOT EXISTS public.post_comments (
  id          uuid        NOT NULL DEFAULT gen_random_uuid(),
  post_id     uuid        NOT NULL,
  account_id  uuid        NOT NULL,
  content     text        NOT NULL,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT post_comments_pkey       PRIMARY KEY (id),
  CONSTRAINT post_comments_post_fk    FOREIGN KEY (post_id)    REFERENCES public.posts(id)    ON DELETE CASCADE,
  CONSTRAINT post_comments_account_fk FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE
);

DROP TRIGGER IF EXISTS post_comments_updated_at ON public.post_comments;
CREATE TRIGGER post_comments_updated_at
  BEFORE UPDATE ON public.post_comments
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


-- ============================================================
--  ROW LEVEL SECURITY
-- ============================================================

-- accounts
ALTER TABLE public.accounts ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public profiles viewable by everyone"  ON public.accounts;
CREATE POLICY "Public profiles viewable by everyone"
  ON public.accounts FOR SELECT
  USING (is_public = true OR auth.uid() = id);

DROP POLICY IF EXISTS "Users can insert their own account"    ON public.accounts;
CREATE POLICY "Users can insert their own account"
  ON public.accounts FOR INSERT
  WITH CHECK (auth.uid() = id);

DROP POLICY IF EXISTS "Users can update their own account"    ON public.accounts;
CREATE POLICY "Users can update their own account"
  ON public.accounts FOR UPDATE
  USING (auth.uid() = id);

-- account_interests
ALTER TABLE public.account_interests ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users manage their own interests"      ON public.account_interests;
CREATE POLICY "Users manage their own interests"
  ON public.account_interests FOR ALL
  USING (auth.uid() = account_id);

-- connections
ALTER TABLE public.connections ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users view their connections"          ON public.connections;
CREATE POLICY "Users view their connections"
  ON public.connections FOR SELECT
  USING (auth.uid() = requester_id OR auth.uid() = addressee_id);

DROP POLICY IF EXISTS "Users send connection requests"        ON public.connections;
CREATE POLICY "Users send connection requests"
  ON public.connections FOR INSERT
  WITH CHECK (auth.uid() = requester_id);

DROP POLICY IF EXISTS "Users update their connections"        ON public.connections;
CREATE POLICY "Users update their connections"
  ON public.connections FOR UPDATE
  USING (auth.uid() = addressee_id OR auth.uid() = requester_id);

DROP POLICY IF EXISTS "Users delete their connections"        ON public.connections;
CREATE POLICY "Users delete their connections"
  ON public.connections FOR DELETE
  USING (auth.uid() = requester_id OR auth.uid() = addressee_id);

-- events
ALTER TABLE public.events ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Published events visible to everyone"  ON public.events;
CREATE POLICY "Published events visible to everyone"
  ON public.events FOR SELECT
  USING (status = 'published' OR auth.uid() = organizer_id);

DROP POLICY IF EXISTS "Authenticated users can create events" ON public.events;
CREATE POLICY "Authenticated users can create events"
  ON public.events FOR INSERT
  WITH CHECK (auth.uid() = organizer_id);

DROP POLICY IF EXISTS "Organizers can update their events"    ON public.events;
CREATE POLICY "Organizers can update their events"
  ON public.events FOR UPDATE
  USING (auth.uid() = organizer_id);

DROP POLICY IF EXISTS "Organizers can delete their events"    ON public.events;
CREATE POLICY "Organizers can delete their events"
  ON public.events FOR DELETE
  USING (auth.uid() = organizer_id);

-- event_attendance
ALTER TABLE public.event_attendance ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Attendance viewable by everyone"       ON public.event_attendance;
CREATE POLICY "Attendance viewable by everyone"
  ON public.event_attendance FOR SELECT
  USING (true);

DROP POLICY IF EXISTS "Users manage their own attendance"     ON public.event_attendance;
CREATE POLICY "Users manage their own attendance"
  ON public.event_attendance FOR ALL
  USING (auth.uid() = account_id);

-- tickets
ALTER TABLE public.tickets ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users view their own tickets"          ON public.tickets;
CREATE POLICY "Users view their own tickets"
  ON public.tickets FOR SELECT
  USING (auth.uid() = account_id);

DROP POLICY IF EXISTS "Users can purchase tickets"            ON public.tickets;
CREATE POLICY "Users can purchase tickets"
  ON public.tickets FOR INSERT
  WITH CHECK (auth.uid() = account_id);

-- event_favorites
ALTER TABLE public.event_favorites ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users manage their own event favorites" ON public.event_favorites;
CREATE POLICY "Users manage their own event favorites"
  ON public.event_favorites FOR ALL
  USING (auth.uid() = account_id);

-- posts
ALTER TABLE public.posts ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Posts viewable by everyone"            ON public.posts;
CREATE POLICY "Posts viewable by everyone"
  ON public.posts FOR SELECT USING (true);

DROP POLICY IF EXISTS "Users can create posts"                ON public.posts;
CREATE POLICY "Users can create posts"
  ON public.posts FOR INSERT
  WITH CHECK (auth.uid() = account_id);

DROP POLICY IF EXISTS "Users can update their own posts"      ON public.posts;
CREATE POLICY "Users can update their own posts"
  ON public.posts FOR UPDATE
  USING (auth.uid() = account_id);

DROP POLICY IF EXISTS "Users can delete their own posts"      ON public.posts;
CREATE POLICY "Users can delete their own posts"
  ON public.posts FOR DELETE
  USING (auth.uid() = account_id);

-- post_likes
ALTER TABLE public.post_likes ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Post likes are public"                 ON public.post_likes;
CREATE POLICY "Post likes are public"
  ON public.post_likes FOR SELECT USING (true);

DROP POLICY IF EXISTS "Users manage their own likes"          ON public.post_likes;
CREATE POLICY "Users manage their own likes"
  ON public.post_likes FOR ALL
  USING (auth.uid() = account_id);

-- post_favorites
ALTER TABLE public.post_favorites ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users manage their own post favorites" ON public.post_favorites;
CREATE POLICY "Users manage their own post favorites"
  ON public.post_favorites FOR ALL
  USING (auth.uid() = account_id);

-- post_comments
ALTER TABLE public.post_comments ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Comments viewable by everyone"         ON public.post_comments;
CREATE POLICY "Comments viewable by everyone"
  ON public.post_comments FOR SELECT USING (true);

DROP POLICY IF EXISTS "Users can comment"                     ON public.post_comments;
CREATE POLICY "Users can comment"
  ON public.post_comments FOR INSERT
  WITH CHECK (auth.uid() = account_id);

DROP POLICY IF EXISTS "Users can update their own comments"   ON public.post_comments;
CREATE POLICY "Users can update their own comments"
  ON public.post_comments FOR UPDATE
  USING (auth.uid() = account_id);

DROP POLICY IF EXISTS "Users can delete their own comments"   ON public.post_comments;
CREATE POLICY "Users can delete their own comments"
  ON public.post_comments FOR DELETE
  USING (auth.uid() = account_id);


-- ============================================================
--  VIEWS
-- ============================================================
CREATE OR REPLACE VIEW public.profile_view AS
SELECT
  a.id,
  a.first_name,
  a.last_name,
  a.user_name,
  a.bio,
  a.location,
  a.avatar_url,
  a.website_url,
  a.instagram_url,
  a.twitter_url,
  a.tiktok_url,
  a.is_public,
  a.created_at,
  (SELECT COUNT(*) FROM public.event_attendance ea
     WHERE ea.account_id = a.id AND ea.status = 'going')        AS events_attending,
  (SELECT COUNT(*) FROM public.connections c
     WHERE (c.requester_id = a.id OR c.addressee_id = a.id)
       AND c.status = 'accepted')                               AS connections_count,
  (SELECT COUNT(*) FROM public.events e
     WHERE e.organizer_id = a.id AND e.status = 'published')   AS events_hosted,
  (SELECT COUNT(*) FROM public.tickets t
     WHERE t.account_id = a.id)                                AS tickets_purchased,
  (SELECT COUNT(*) FROM public.event_favorites ef
     WHERE ef.account_id = a.id)                               AS event_favorites_count
FROM public.accounts a;

CREATE OR REPLACE VIEW public.event_view AS
SELECT
  e.*,
  n.name AS neighborhood_name,
  n.slug AS neighborhood_slug,
  (SELECT COUNT(*) FROM public.event_attendance ea
     WHERE ea.event_id = e.id AND ea.status = 'going') AS attendee_count,
  (SELECT COUNT(*) FROM public.event_favorites ef
     WHERE ef.event_id = e.id)                          AS favorites_count
FROM public.events e
LEFT JOIN public.neighborhoods n ON n.id = e.neighborhood_id;


-- ============================================================
--  INDEXES
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_events_starts_at          ON public.events (starts_at);
CREATE INDEX IF NOT EXISTS idx_events_status             ON public.events (status);
CREATE INDEX IF NOT EXISTS idx_events_category           ON public.events (category);
CREATE INDEX IF NOT EXISTS idx_events_neighborhood       ON public.events (neighborhood_id);
CREATE INDEX IF NOT EXISTS idx_events_organizer          ON public.events (organizer_id);
CREATE INDEX IF NOT EXISTS idx_event_attendance_event    ON public.event_attendance (event_id);
CREATE INDEX IF NOT EXISTS idx_event_attendance_account  ON public.event_attendance (account_id);
CREATE INDEX IF NOT EXISTS idx_tickets_account           ON public.tickets (account_id);
CREATE INDEX IF NOT EXISTS idx_tickets_event             ON public.tickets (event_id);
CREATE INDEX IF NOT EXISTS idx_connections_requester     ON public.connections (requester_id);
CREATE INDEX IF NOT EXISTS idx_connections_addressee     ON public.connections (addressee_id);
CREATE INDEX IF NOT EXISTS idx_posts_account             ON public.posts (account_id);
CREATE INDEX IF NOT EXISTS idx_posts_event               ON public.posts (event_id);
CREATE INDEX IF NOT EXISTS idx_post_likes_post           ON public.post_likes (post_id);
CREATE INDEX IF NOT EXISTS idx_post_comments_post        ON public.post_comments (post_id);