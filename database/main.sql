-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.account_interests (
  account_id uuid NOT NULL,
  interest_id integer NOT NULL,
  CONSTRAINT account_interests_pkey PRIMARY KEY (account_id, interest_id),
  CONSTRAINT account_interests_account_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id),
  CONSTRAINT account_interests_interest_fkey FOREIGN KEY (interest_id) REFERENCES public.interests(id)
);
CREATE TABLE public.accounts (
  id uuid NOT NULL,
  first_name character varying NOT NULL,
  last_name character varying NOT NULL,
  user_name character varying NOT NULL UNIQUE,
  location USER-DEFINED,
  created_at timestamp with time zone DEFAULT now(),
  instagram_url character varying,
  twitter_url character varying,
  tiktok_url character varying,
  bio text,
  avatar_url character varying,
  website_url character varying,
  is_public boolean NOT NULL DEFAULT true,
  show_attending boolean NOT NULL DEFAULT true,
  show_connections boolean NOT NULL DEFAULT true,
  email_recommendations boolean NOT NULL DEFAULT true,
  notify_connections boolean NOT NULL DEFAULT false,
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT accounts_pkey PRIMARY KEY (id),
  CONSTRAINT accounts_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id)
);
CREATE TABLE public.connections (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  requester_id uuid NOT NULL,
  addressee_id uuid NOT NULL,
  status USER-DEFINED NOT NULL DEFAULT 'pending'::connection_status,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT connections_pkey PRIMARY KEY (id),
  CONSTRAINT connections_requester_fk FOREIGN KEY (requester_id) REFERENCES public.accounts(id),
  CONSTRAINT connections_addressee_fk FOREIGN KEY (addressee_id) REFERENCES public.accounts(id)
);
CREATE TABLE public.event_attendance (
  account_id uuid NOT NULL,
  event_id uuid NOT NULL,
  status USER-DEFINED NOT NULL DEFAULT 'going'::attendance_status,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT event_attendance_pkey PRIMARY KEY (account_id, event_id),
  CONSTRAINT event_attendance_account_fk FOREIGN KEY (account_id) REFERENCES public.accounts(id),
  CONSTRAINT event_attendance_event_fk FOREIGN KEY (event_id) REFERENCES public.events(id)
);
CREATE TABLE public.event_favorites (
  account_id uuid NOT NULL,
  event_id uuid NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT event_favorites_pkey PRIMARY KEY (account_id, event_id),
  CONSTRAINT event_favorites_account_fk FOREIGN KEY (account_id) REFERENCES public.accounts(id),
  CONSTRAINT event_favorites_event_fk FOREIGN KEY (event_id) REFERENCES public.events(id)
);
CREATE TABLE public.event_images (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  event_id uuid NOT NULL,
  image_url character varying NOT NULL,
  sort_order integer NOT NULL DEFAULT 0,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT event_images_pkey PRIMARY KEY (id),
  CONSTRAINT event_images_event_fk FOREIGN KEY (event_id) REFERENCES public.events(id)
);
CREATE TABLE public.events (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  organizer_id uuid NOT NULL,
  title character varying NOT NULL,
  description text,
  category character varying,
  vibe_tags ARRAY,
  neighborhood_id integer,
  venue_name character varying,
  address character varying,
  location USER-DEFINED,
  starts_at timestamp with time zone NOT NULL,
  ends_at timestamp with time zone,
  cover_image_url character varying,
  ticket_price numeric DEFAULT 0,
  ticket_url character varying,
  capacity integer,
  status USER-DEFINED NOT NULL DEFAULT 'published'::event_status,
  is_free boolean NOT NULL DEFAULT false,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT events_pkey PRIMARY KEY (id),
  CONSTRAINT events_organizer_fk FOREIGN KEY (organizer_id) REFERENCES public.accounts(id),
  CONSTRAINT events_neighborhood_fk FOREIGN KEY (neighborhood_id) REFERENCES public.neighborhoods(id)
);
CREATE TABLE public.interests (
  id integer NOT NULL DEFAULT nextval('interests_id_seq'::regclass),
  name character varying NOT NULL UNIQUE,
  CONSTRAINT interests_pkey PRIMARY KEY (id)
);
CREATE TABLE public.messages (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  sender_id uuid NOT NULL,
  recipient_id uuid NOT NULL,
  body text NOT NULL,
  read_at timestamp with time zone,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT messages_pkey PRIMARY KEY (id),
  CONSTRAINT messages_sender_fk FOREIGN KEY (sender_id) REFERENCES public.accounts(id),
  CONSTRAINT messages_recipient_fk FOREIGN KEY (recipient_id) REFERENCES public.accounts(id)
);
CREATE TABLE public.neighborhoods (
  id integer NOT NULL DEFAULT nextval('neighborhoods_id_seq'::regclass),
  name character varying NOT NULL UNIQUE,
  slug character varying NOT NULL UNIQUE,
  geo USER-DEFINED,
  CONSTRAINT neighborhoods_pkey PRIMARY KEY (id)
);
CREATE TABLE public.post_comments (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  post_id uuid NOT NULL,
  account_id uuid NOT NULL,
  content text NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT post_comments_pkey PRIMARY KEY (id),
  CONSTRAINT post_comments_post_fk FOREIGN KEY (post_id) REFERENCES public.posts(id),
  CONSTRAINT post_comments_account_fk FOREIGN KEY (account_id) REFERENCES public.accounts(id)
);
CREATE TABLE public.post_favorites (
  account_id uuid NOT NULL,
  post_id uuid NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT post_favorites_pkey PRIMARY KEY (account_id, post_id),
  CONSTRAINT post_favorites_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id),
  CONSTRAINT post_favorites_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id)
);
CREATE TABLE public.post_images (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  post_id uuid NOT NULL,
  image_url character varying NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  sort_order integer NOT NULL DEFAULT 0,
  CONSTRAINT post_images_pkey PRIMARY KEY (id),
  CONSTRAINT post_images_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id)
);
CREATE TABLE public.post_likes (
  account_id uuid NOT NULL,
  post_id uuid NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT post_likes_pkey PRIMARY KEY (account_id, post_id),
  CONSTRAINT post_likes_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id),
  CONSTRAINT post_likes_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id)
);
CREATE TABLE public.posts (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  account_id uuid NOT NULL,
  title character varying NOT NULL,
  content text NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  event_id uuid,
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT posts_pkey PRIMARY KEY (id),
  CONSTRAINT posts_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id),
  CONSTRAINT posts_event_fk FOREIGN KEY (event_id) REFERENCES public.events(id)
);
CREATE TABLE public.spatial_ref_sys (
  srid integer NOT NULL CHECK (srid > 0 AND srid <= 998999),
  auth_name character varying,
  auth_srid integer,
  srtext character varying,
  proj4text character varying,
  CONSTRAINT spatial_ref_sys_pkey PRIMARY KEY (srid)
);
CREATE TABLE public.tickets (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  account_id uuid NOT NULL,
  event_id uuid NOT NULL,
  quantity integer NOT NULL DEFAULT 1 CHECK (quantity > 0),
  unit_price numeric NOT NULL DEFAULT 0,
  total_price numeric DEFAULT ((quantity)::numeric * unit_price),
  status USER-DEFINED NOT NULL DEFAULT 'active'::ticket_status,
  purchased_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT tickets_pkey PRIMARY KEY (id),
  CONSTRAINT tickets_account_fk FOREIGN KEY (account_id) REFERENCES public.accounts(id),
  CONSTRAINT tickets_event_fk FOREIGN KEY (event_id) REFERENCES public.events(id)
);