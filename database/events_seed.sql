-- ============================================================
-- Encore / ATL Events — Real Atlanta Events Seed
-- Run this AFTER schema.sql and seed.sql in Supabase SQL Editor.
-- Safe to re-run: all inserts use ON CONFLICT DO NOTHING.
-- ============================================================

-- ── System / Demo organizer account ──────────────────────────
-- This account owns all seeded events.
-- The UUID is hardcoded so the insert is idempotent.

INSERT INTO auth.users (
  id,
  instance_id,
  email,
  encrypted_password,
  email_confirmed_at,
  created_at,
  updated_at,
  role,
  aud
) VALUES (
  '00000000-0000-0000-0000-000000000001',
  '00000000-0000-0000-0000-000000000000',
  'system@encoreatl.app',
  '',
  now(),
  now(),
  now(),
  'authenticated',
  'authenticated'
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.accounts (id, first_name, last_name, user_name)
VALUES ('00000000-0000-0000-0000-000000000001', 'Encore', 'ATL', 'encoreatl')
ON CONFLICT (id) DO NOTHING;


-- ── Atlanta Events ────────────────────────────────────────────

INSERT INTO public.events (
  organizer_id, title, description, category, vibe_tags,
  neighborhood_id, venue_name, address,
  starts_at, ends_at,
  ticket_price, ticket_url, is_free, status
) VALUES

-- ── APRIL 2026 ───────────────────────────────────────────────

(
  '00000000-0000-0000-0000-000000000001',
  'SweetWater 420 Fest 2026',
  'The iconic annual music and craft beer festival returns to Westside Park. Headliners include Thievery Corporation and Chromeo, with dozens of acts across multiple stages, SweetWater brews on tap, and local food vendors all weekend.',
  'Music',
  ARRAY['live-music','festival','outdoor','beer','chill'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'west-end'),
  'Westside Park (Shirley Clarke Franklin Park)',
  '1660 Coronet Way NW, Atlanta, GA 30318',
  '2026-04-17 12:00:00-04',
  '2026-04-18 23:00:00-04',
  40.00,
  'https://www.420fest.com',
  false,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Atlanta Film Festival — 50th Anniversary (Opening Night)',
  'The Atlanta Film Festival celebrates its 50th year with a landmark opening night screening and filmmaker Q&A at the historic Plaza Theatre. This year''s festival runs through May 3rd across multiple venues.',
  'Arts & Culture',
  ARRAY['film','arts','indie','nightlife'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'poncey-highland'),
  'Plaza Theatre',
  '1049 Ponce de Leon Ave NE, Atlanta, GA 30306',
  '2026-04-23 19:00:00-04',
  '2026-04-23 22:30:00-04',
  20.00,
  'https://www.atlantafilmfestival.com',
  false,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Atlanta Film Festival — Closing Night: Keke Palmer',
  'The 50th Atlanta Film Festival closes with a special screening and appearance by Keke Palmer. One of the most anticipated closing nights in the festival''s history.',
  'Arts & Culture',
  ARRAY['film','arts','celebrity','nightlife'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'poncey-highland'),
  'Tara Theatre',
  '2345 Cheshire Bridge Rd NE, Atlanta, GA 30324',
  '2026-05-03 19:00:00-04',
  '2026-05-03 22:30:00-04',
  25.00,
  'https://www.atlantafilmfestival.com',
  false,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  '54th Annual Inman Park Festival',
  'One of Atlanta''s most beloved neighborhood festivals returns along Freedom Parkway. Browse art from 150+ local vendors, enjoy live music on multiple stages, and experience the famous Inman Park parade. Free and open to all.',
  'Arts & Culture',
  ARRAY['festival','outdoor','arts','family','free'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'inman-park'),
  'Freedom Parkway & Inman Park',
  'Freedom Pkwy NE, Atlanta, GA 30307',
  '2026-04-25 10:00:00-04',
  '2026-04-26 18:00:00-04',
  0.00,
  'https://www.inmanparkfestival.org',
  true,
  'published'
),

-- ── MAY 2026 ─────────────────────────────────────────────────

(
  '00000000-0000-0000-0000-000000000001',
  'Florence + The Machine — Live at State Farm Arena',
  'Florence Welch brings her sweeping, anthemic rock back to Atlanta on the world tour supporting the new record. An unforgettable, emotional live performance.',
  'Music',
  ARRAY['live-music','rock','concert','arena'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'castleberry-hill'),
  'State Farm Arena',
  '1 State Farm Drive, Atlanta, GA 30303',
  '2026-05-01 19:30:00-04',
  '2026-05-01 23:00:00-04',
  75.00,
  'https://www.ticketmaster.com',
  false,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Cardi B — Little Miss Drama Tour',
  'Cardi B brings the Little Miss Drama Tour to Atlanta. Expect high-energy performances, production spectacles, and surprise guests at State Farm Arena.',
  'Music',
  ARRAY['live-music','hip-hop','concert','arena'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'castleberry-hill'),
  'State Farm Arena',
  '1 State Farm Drive, Atlanta, GA 30303',
  '2026-05-02 20:00:00-04',
  '2026-05-02 23:30:00-04',
  85.00,
  'https://www.ticketmaster.com',
  false,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Ari Lennox Live at the Fox Theatre',
  'R&B sensation Ari Lennox performs at one of Atlanta''s most iconic venues. Known for her soulful voice and intimate connection with her audience, this is a can''t-miss night.',
  'Music',
  ARRAY['live-music','r&b','soul','concert'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'midtown'),
  'Fox Theatre',
  '660 Peachtree St NE, Atlanta, GA 30308',
  '2026-05-05 20:00:00-04',
  '2026-05-05 23:00:00-04',
  45.00,
  'https://www.foxtheatre.org',
  false,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Atlanta Restaurant Week Spring 2026',
  'Explore Atlanta''s diverse dining scene during Restaurant Week. Over 100 participating restaurants across the city offer prix-fixe menus at $20, $35, and $55 price points.',
  'Food & Drink',
  ARRAY['food','dining','local','community'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'midtown'),
  'Citywide — Various Restaurants',
  'Atlanta, GA',
  '2026-05-08 11:00:00-04',
  '2026-05-17 22:00:00-04',
  20.00,
  'https://www.atlantarestaurantweek.com',
  false,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Marcus King Band at the Fox Theatre',
  'Southern rock and blues guitar god Marcus King brings his powerhouse band to the Fox Theatre. Raw, soulful, and electrifying — one of the best live acts in the country.',
  'Music',
  ARRAY['live-music','blues','rock','concert'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'midtown'),
  'Fox Theatre',
  '660 Peachtree St NE, Atlanta, GA 30308',
  '2026-05-16 20:00:00-04',
  '2026-05-16 23:00:00-04',
  35.00,
  'https://www.foxtheatre.org',
  false,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Don Toliver — OCTANE World Tour',
  'Don Toliver brings the OCTANE World Tour to Atlanta with chart-topping hits and a massive production. One of the hottest rap tours of 2026.',
  'Music',
  ARRAY['live-music','hip-hop','rap','concert','arena'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'castleberry-hill'),
  'State Farm Arena',
  '1 State Farm Drive, Atlanta, GA 30303',
  '2026-05-19 20:00:00-04',
  '2026-05-19 23:30:00-04',
  65.00,
  'https://www.ticketmaster.com',
  false,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'MomoCon 2026',
  'Atlanta''s premier anime, gaming, and comics convention returns to the Georgia World Congress Center. 50,000+ attendees, major guests, cosplay competitions, gaming tournaments, and panels all weekend.',
  'Arts & Culture',
  ARRAY['gaming','anime','comics','convention','cosplay','family'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'castleberry-hill'),
  'Georgia World Congress Center',
  '285 Andrew Young International Blvd NW, Atlanta, GA 30313',
  '2026-05-20 10:00:00-04',
  '2026-05-24 18:00:00-04',
  50.00,
  'https://www.momocon.com',
  false,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Brew at the Zoo 2026',
  'Sip craft beers from 40+ breweries while wandering Zoo Atlanta after hours. One of the most fun and unique events of the Atlanta summer — 21+ only.',
  'Food & Drink',
  ARRAY['beer','outdoor','nightlife','animals'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'grant-park'),
  'Zoo Atlanta',
  '800 Cherokee Ave SE, Atlanta, GA 30315',
  '2026-05-23 18:00:00-04',
  '2026-05-23 22:00:00-04',
  45.00,
  'https://zooatlanta.org',
  false,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Atlanta Jazz Festival 2026 — Kamasi Washington',
  'The world''s largest free jazz festival opens Memorial Day weekend in Piedmont Park. Saturday night headliner Kamasi Washington brings his cosmic jazz vision to Atlanta. Free and open to all.',
  'Music',
  ARRAY['jazz','live-music','outdoor','festival','free'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'midtown'),
  'Piedmont Park',
  '400 Park Dr NE, Atlanta, GA 30306',
  '2026-05-23 14:00:00-04',
  '2026-05-23 22:00:00-04',
  0.00,
  'https://www.atlantajazzfestival.com',
  true,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Atlanta Jazz Festival 2026 — The Roots',
  'Day two of the world''s largest free jazz festival. Sunday headliners The Roots deliver a legendary live performance in Piedmont Park. Free and open to all.',
  'Music',
  ARRAY['jazz','hip-hop','live-music','outdoor','festival','free'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'midtown'),
  'Piedmont Park',
  '400 Park Dr NE, Atlanta, GA 30306',
  '2026-05-24 14:00:00-04',
  '2026-05-24 22:00:00-04',
  0.00,
  'https://www.atlantajazzfestival.com',
  true,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Atlanta Jazz Festival 2026 — PJ Morton (Closing Night)',
  'The Atlanta Jazz Festival closes on Memorial Day with hometown hero PJ Morton. A fitting end to an extraordinary weekend of free music in Piedmont Park.',
  'Music',
  ARRAY['jazz','r&b','live-music','outdoor','festival','free'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'midtown'),
  'Piedmont Park',
  '400 Park Dr NE, Atlanta, GA 30306',
  '2026-05-25 13:00:00-04',
  '2026-05-25 21:00:00-04',
  0.00,
  'https://www.atlantajazzfestival.com',
  true,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Hot 107.9 Birthday Bash 2026',
  'Atlanta''s biggest hip-hop night of the year. Hot 107.9 Birthday Bash packs State Farm Arena with the hottest names in rap and R&B — lineup TBA but always legendary.',
  'Music',
  ARRAY['hip-hop','r&b','concert','arena','live-music'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'castleberry-hill'),
  'State Farm Arena',
  '1 State Farm Drive, Atlanta, GA 30303',
  '2026-05-24 19:00:00-04',
  '2026-05-24 23:59:00-04',
  55.00,
  'https://www.ticketmaster.com',
  false,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Ponce City Market Rooftop Summer Kickoff',
  'Kick off summer on the rooftop of Ponce City Market with live DJs, lawn games, food, and skyline views. The best rooftop party in Atlanta.',
  'Nightlife',
  ARRAY['rooftop','nightlife','dj','outdoor','summer'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'old-fourth-ward'),
  'Ponce City Market — Skyline Park',
  '675 Ponce De Leon Ave NE, Atlanta, GA 30308',
  '2026-05-29 18:00:00-04',
  '2026-05-29 23:00:00-04',
  15.00,
  'https://www.poncecitymarket.com',
  false,
  'published'
),

-- ── JUNE 2026 ────────────────────────────────────────────────

(
  '00000000-0000-0000-0000-000000000001',
  'Amplify Decatur Music Festival — Opening Night',
  'The Amplify Decatur Music Festival opens with a free concert on Decatur Square. Four days of local and national artists celebrating Decatur''s vibrant music community.',
  'Music',
  ARRAY['live-music','local','festival','outdoor','free'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'decatur'),
  'Decatur Square',
  '101 E Court Square, Decatur, GA 30030',
  '2026-06-04 17:00:00-04',
  '2026-06-04 22:00:00-04',
  0.00,
  'https://www.amplifydecatur.com',
  true,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Amplify Decatur Music Festival — Weekend',
  'The main weekend of Amplify Decatur — multiple stages, 50+ acts, local food and craft vendors on Decatur Square. Free and open to the public.',
  'Music',
  ARRAY['live-music','local','festival','outdoor','free'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'decatur'),
  'Decatur Square',
  '101 E Court Square, Decatur, GA 30030',
  '2026-06-06 12:00:00-04',
  '2026-06-07 22:00:00-04',
  0.00,
  'https://www.amplifydecatur.com',
  true,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Megan Moroney Live at State Farm Arena',
  'Country star Megan Moroney brings her breakout tour to Atlanta. Nashville''s hottest rising voice performs her hits in a big arena show.',
  'Music',
  ARRAY['live-music','country','concert','arena'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'castleberry-hill'),
  'State Farm Arena',
  '1 State Farm Drive, Atlanta, GA 30303',
  '2026-06-08 19:30:00-04',
  '2026-06-08 23:00:00-04',
  55.00,
  'https://www.ticketmaster.com',
  false,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Rick Ross Live at the Fox Theatre',
  'The Boss himself, Rick Ross, takes the stage at Atlanta''s Fox Theatre. A powerhouse hometown performance from one of hip-hop''s biggest icons.',
  'Music',
  ARRAY['live-music','hip-hop','rap','concert'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'midtown'),
  'Fox Theatre',
  '660 Peachtree St NE, Atlanta, GA 30308',
  '2026-06-12 20:00:00-04',
  '2026-06-12 23:00:00-04',
  55.00,
  'https://www.foxtheatre.org',
  false,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  '5 Seconds of Summer — Live at State Farm Arena',
  '5SOS brings their global tour to Atlanta. The Australian pop-rock band delivers an electrifying show packed with anthems for a night to remember.',
  'Music',
  ARRAY['live-music','pop','rock','concert','arena'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'castleberry-hill'),
  'State Farm Arena',
  '1 State Farm Drive, Atlanta, GA 30303',
  '2026-06-16 19:30:00-04',
  '2026-06-16 23:00:00-04',
  60.00,
  'https://www.ticketmaster.com',
  false,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'The Human League & Soft Cell — Together Tour',
  'Two iconic synth-pop legends join forces for a rare double-headliner night at the Fox Theatre. A nostalgic, danceable evening celebrating the golden age of electronic pop.',
  'Music',
  ARRAY['live-music','pop','synth-pop','concert','80s'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'midtown'),
  'Fox Theatre',
  '660 Peachtree St NE, Atlanta, GA 30308',
  '2026-06-19 20:00:00-04',
  '2026-06-19 23:00:00-04',
  45.00,
  'https://www.foxtheatre.org',
  false,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Juneteenth Atlanta Festival 2026',
  'Atlanta celebrates Juneteenth with a three-day festival in Piedmont Park — live music, cultural performances, art, food, and community. Free and open to all.',
  'Arts & Culture',
  ARRAY['festival','outdoor','culture','free','community','music'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'midtown'),
  'Piedmont Park',
  '400 Park Dr NE, Atlanta, GA 30306',
  '2026-06-19 11:00:00-04',
  '2026-06-21 21:00:00-04',
  0.00,
  'https://www.juneteenthatl.com',
  true,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Atlanta Pride Block Party — Midtown',
  'Join Midtown Atlanta for one of the most vibrant Pride celebrations in the South. Live music, drag performances, local vendors, and the city''s best LGBTQ+ community energy.',
  'Nightlife',
  ARRAY['pride','lgbtq','festival','outdoor','community','music'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'midtown'),
  'Midtown Atlanta — 10th & Piedmont',
  '10th St NE & Piedmont Ave NE, Atlanta, GA 30309',
  '2026-06-20 14:00:00-04',
  '2026-06-20 22:00:00-04',
  0.00,
  'https://www.atlantapride.org',
  true,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Shakira — Las Mujeres Ya No Lloran World Tour',
  'Shakira brings her record-breaking world tour to Atlanta. One of the biggest concert spectacles of 2026 — don''t miss it.',
  'Music',
  ARRAY['live-music','pop','latin','concert','arena'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'castleberry-hill'),
  'State Farm Arena',
  '1 State Farm Drive, Atlanta, GA 30303',
  '2026-06-26 20:00:00-04',
  '2026-06-26 23:30:00-04',
  80.00,
  'https://www.ticketmaster.com',
  false,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'East Atlanta Village Strummer Festival',
  'East Atlanta Village''s beloved annual music festival celebrating independent music and community. Multiple outdoor stages, local bands, food trucks, and craft vendors.',
  'Music',
  ARRAY['live-music','indie','local','festival','outdoor','community'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'east-atlanta'),
  'East Atlanta Village',
  'Flat Shoals Ave SE, Atlanta, GA 30316',
  '2026-06-27 13:00:00-04',
  '2026-06-27 22:00:00-04',
  10.00,
  'https://www.strummerfest.com',
  false,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Ponce City Market Summer Night Market',
  'The Summer Night Market returns to Ponce City Market — 80+ local makers, artisans, and food vendors set up in the historic building and courtyard. Free to browse.',
  'Arts & Culture',
  ARRAY['market','local','arts','food','outdoor','free'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'old-fourth-ward'),
  'Ponce City Market',
  '675 Ponce De Leon Ave NE, Atlanta, GA 30308',
  '2026-06-27 17:00:00-04',
  '2026-06-27 22:00:00-04',
  0.00,
  'https://www.poncecitymarket.com',
  true,
  'published'
),

-- ── JULY 2026 ────────────────────────────────────────────────

(
  '00000000-0000-0000-0000-000000000001',
  'Jill Scott Live at the Fox Theatre — Night 1',
  'Queen Jill Scott performs two nights at the iconic Fox Theatre. Soulful, powerful, and deeply intimate — an extraordinary live experience.',
  'Music',
  ARRAY['live-music','r&b','soul','concert'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'midtown'),
  'Fox Theatre',
  '660 Peachtree St NE, Atlanta, GA 30308',
  '2026-07-10 20:00:00-04',
  '2026-07-10 23:00:00-04',
  70.00,
  'https://www.foxtheatre.org',
  false,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Jill Scott Live at the Fox Theatre — Night 2',
  'Jill Scott''s second night at the Fox Theatre. Both nights sold out in hours in prior years — grab your tickets early.',
  'Music',
  ARRAY['live-music','r&b','soul','concert'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'midtown'),
  'Fox Theatre',
  '660 Peachtree St NE, Atlanta, GA 30308',
  '2026-07-11 20:00:00-04',
  '2026-07-11 23:00:00-04',
  70.00,
  'https://www.foxtheatre.org',
  false,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Atlanta Summer Halal Food Festival',
  'Celebrate diverse culinary traditions at Atlantic Station''s Halal Food Festival — 30+ food vendors, live entertainment, and family activities.',
  'Food & Drink',
  ARRAY['food','halal','festival','outdoor','family'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'midtown'),
  'Atlantic Station',
  '1380 Atlantic Dr NW, Atlanta, GA 30363',
  '2026-07-19 11:00:00-04',
  '2026-07-19 20:00:00-04',
  5.00,
  'https://www.atlantahalal.com',
  false,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'ATL Dessert Festival 2026',
  'Atlanta''s sweetest day — the ATL Dessert Festival takes over Grant Park with 50+ dessert vendors, ice cream trucks, bakers, chocolatiers, and more. A must for anyone with a sweet tooth.',
  'Food & Drink',
  ARRAY['food','dessert','festival','outdoor','family'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'grant-park'),
  'Grant Park',
  'Grant Park, Atlanta, GA 30315',
  '2026-07-25 11:00:00-04',
  '2026-07-25 20:00:00-04',
  20.00,
  'https://www.atldessertfestival.com',
  false,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Little Five Points Summer Solstice Festival',
  'L5P''s eclectic annual summer festival — local artists, street performers, vintage markets, food trucks, and live music spilling out of Findley Plaza. Free and weird, in the best way.',
  'Arts & Culture',
  ARRAY['festival','arts','local','outdoor','free','community'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'little-five-points'),
  'Little Five Points — Findley Plaza',
  'Moreland Ave NE & Euclid Ave NE, Atlanta, GA 30307',
  '2026-07-18 12:00:00-04',
  '2026-07-18 21:00:00-04',
  0.00,
  NULL,
  true,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Variety Playhouse Outdoor Summer Series',
  'Little Five Points'' legendary venue hosts its outdoor summer concert series. Intimate shows on the lawn behind Variety Playhouse — local and national indie artists all summer long.',
  'Music',
  ARRAY['live-music','indie','outdoor','intimate','local'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'little-five-points'),
  'Variety Playhouse',
  '1099 Euclid Ave NE, Atlanta, GA 30307',
  '2026-07-11 19:00:00-04',
  '2026-07-11 23:00:00-04',
  22.00,
  'https://www.variety-playhouse.com',
  false,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Buckhead Food & Wine Festival',
  'Buckhead''s premier food and wine event brings top Atlanta chefs and international wineries together for a glamorous evening of tastings, live music, and culinary demonstrations.',
  'Food & Drink',
  ARRAY['food','wine','dining','upscale','nightlife'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'buckhead'),
  'Phipps Plaza',
  '3500 Peachtree Rd NE, Atlanta, GA 30326',
  '2026-07-16 18:00:00-04',
  '2026-07-16 22:00:00-04',
  65.00,
  'https://www.buckheadfoodandwine.com',
  false,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Grant Park Summer Shade Festival',
  'Grant Park''s beloved free arts festival returns — fine art and craft from 150+ artists, live music, kids'' activities, and food under the shade trees in historic Grant Park.',
  'Arts & Culture',
  ARRAY['arts','festival','outdoor','free','family','local'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'grant-park'),
  'Grant Park',
  'Grant Park, Atlanta, GA 30315',
  '2026-07-04 10:00:00-04',
  '2026-07-05 18:00:00-04',
  0.00,
  'https://www.summershade.com',
  true,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Edgewood Ave Block Party',
  'The Edgewood Avenue corridor comes alive for one night with block-party energy — open-air bars, live DJs, and local food vendors transforming one of Atlanta''s most vibrant nightlife streets.',
  'Nightlife',
  ARRAY['nightlife','dj','outdoor','local','community'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'edgewood'),
  'Edgewood Avenue NE',
  'Edgewood Ave NE, Atlanta, GA 30307',
  '2026-07-03 18:00:00-04',
  '2026-07-03 23:59:00-04',
  0.00,
  NULL,
  true,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'West End Market — Summer Edition',
  'The West End Market''s summer showcase brings together local Black-owned businesses, artists, and food vendors in one of Atlanta''s most historic neighborhoods.',
  'Arts & Culture',
  ARRAY['market','local','arts','food','community','black-owned'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'west-end'),
  'West End Market',
  '780 Cascade Ave SW, Atlanta, GA 30310',
  '2026-07-12 10:00:00-04',
  '2026-07-12 18:00:00-04',
  0.00,
  NULL,
  true,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Castleberry Hill Art Stroll — July Edition',
  'The monthly Castleberry Hill Art Stroll is bigger than ever in July. Galleries open their doors, artists set up on the street, and the neighborhood''s creative energy fills the air.',
  'Arts & Culture',
  ARRAY['arts','gallery','local','community','free'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'castleberry-hill'),
  'Castleberry Hill Arts District',
  'Walker St SW, Atlanta, GA 30313',
  '2026-07-10 18:00:00-04',
  '2026-07-10 22:00:00-04',
  0.00,
  NULL,
  true,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Historic Fourth Ward Park Concert Series',
  'Free summer concerts in Historic Fourth Ward Park with views of Ponce City Market. Local and regional artists perform on the lawn — bring a blanket and enjoy the skyline.',
  'Music',
  ARRAY['live-music','outdoor','free','local','community'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'old-fourth-ward'),
  'Historic Fourth Ward Park',
  '680 Dallas St NE, Atlanta, GA 30308',
  '2026-07-17 18:30:00-04',
  '2026-07-17 21:30:00-04',
  0.00,
  NULL,
  true,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Inman Park Outdoor Cinema',
  'Movies under the stars in Inman Park. Grab a blanket and enjoy a classic film screened outdoors in one of Atlanta''s most charming neighborhoods.',
  'Arts & Culture',
  ARRAY['film','outdoor','community','family','free'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'inman-park'),
  'Springvale Park',
  'Springvale Park, Atlanta, GA 30307',
  '2026-07-24 20:30:00-04',
  '2026-07-24 23:00:00-04',
  0.00,
  NULL,
  true,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Poncey-Highland Art Walk',
  'Explore the galleries, studios, and pop-up exhibitions along the Poncey-Highland corridor. Meet local artists, enjoy wine and bites, and discover Atlanta''s thriving visual arts scene.',
  'Arts & Culture',
  ARRAY['arts','gallery','local','free','community'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'poncey-highland'),
  'Poncey-Highland Neighborhood',
  'North Highland Ave NE, Atlanta, GA 30306',
  '2026-07-18 17:00:00-04',
  '2026-07-18 21:00:00-04',
  0.00,
  NULL,
  true,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Decatur Craft Beer Festival',
  'Decatur Square transforms into a craft beer lover''s paradise. 60+ breweries, live music, local food, and the perfect summer afternoon in one of Atlanta''s best walkable neighborhoods.',
  'Food & Drink',
  ARRAY['beer','craft','festival','outdoor','local'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'decatur'),
  'Decatur Square',
  '101 E Court Square, Decatur, GA 30030',
  '2026-07-11 13:00:00-04',
  '2026-07-11 20:00:00-04',
  30.00,
  'https://www.decaturbeerfestival.com',
  false,
  'published'
),

(
  '00000000-0000-0000-0000-000000000001',
  'Star Bar East Atlanta — Weekend Residency',
  'East Atlanta''s beloved Star Bar hosts a weekend residency with three nights of punk, metal, and indie acts. Cheap beer, loud music, and the best dive bar energy in the city.',
  'Music',
  ARRAY['live-music','punk','indie','nightlife','local'],
  (SELECT id FROM public.neighborhoods WHERE slug = 'east-atlanta'),
  'Star Bar',
  '437 Moreland Ave NE, Atlanta, GA 30307',
  '2026-07-17 21:00:00-04',
  '2026-07-19 02:00:00-04',
  10.00,
  'https://www.thestarbar.net',
  false,
  'published'
);
