-- ============================================================
-- Scraped Events from atlanta-ga.events
-- Source: https://atlanta-ga.events (April 20 – May 3, 2026)
-- Safe to re-run: uses ON CONFLICT DO NOTHING
-- NOTE: The source site has 1609 total events but renders them
-- via JavaScript pagination. This file contains the ~65 unique
-- events visible in the initial page load.
-- ============================================================

-- Ensure system organizer account exists
INSERT INTO auth.users (id, instance_id, email, encrypted_password, email_confirmed_at, created_at, updated_at, role, aud)
VALUES ('00000000-0000-0000-0000-000000000001','00000000-0000-0000-0000-000000000000','system@encoreatl.app','',now(),now(),now(),'authenticated','authenticated')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.accounts (id, first_name, last_name, user_name)
VALUES ('00000000-0000-0000-0000-000000000001','Encore','ATL','encoreatl')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.events (
  organizer_id, title, description, category, vibe_tags,
  neighborhood_id, venue_name, address,
  starts_at, ends_at,
  ticket_price, ticket_url, is_free, status
) VALUES

-- ── APRIL 20 ─────────────────────────────────────────────────

(
  '00000000-0000-0000-0000-000000000001',
  'Cut Worms',
  'Cut Worms brings his nostalgic indie rock and country-tinged sound to The Earl in East Atlanta Village.',
  'Music', ARRAY['live-music','indie','concert'],
  (SELECT id FROM public.neighborhoods WHERE slug='east-atlanta'),
  'The Earl', '488 Flat Shoals Avenue, Atlanta, GA 30316',
  '2026-04-20 20:30:00-04', '2026-04-20 23:30:00-04',
  20.00, 'https://atlanta-ga.events/event/cut-worms-atlanta-monday-april-20-2026-830-pm/?pid=3856', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Baby Keem',
  'Kendrick Lamar''s cousin and one of hip-hop''s hottest rising stars performs at Coca-Cola Roxy.',
  'Music', ARRAY['live-music','hip-hop','concert'],
  (SELECT id FROM public.neighborhoods WHERE slug='buckhead'),
  'Coca-Cola Roxy', '800 Battery Ave SE, Atlanta, GA 30339',
  '2026-04-20 20:30:00-04', '2026-04-20 23:30:00-04',
  45.00, 'https://atlanta-ga.events/event/baby-keem-atlanta-monday-april-20-2026-830-pm/', false, 'published'
),

-- ── APRIL 21 ─────────────────────────────────────────────────

(
  '00000000-0000-0000-0000-000000000001',
  'Black Pistol Fire',
  'The powerful rock duo Black Pistol Fire tears up the Masquerade with their high-energy garage rock set.',
  'Music', ARRAY['live-music','rock','concert'],
  (SELECT id FROM public.neighborhoods WHERE slug='castleberry-hill'),
  'Hell at The Masquerade', '75 MLK Jr Dr SW, Atlanta, GA 30303',
  '2026-04-21 19:00:00-04', '2026-04-21 22:30:00-04',
  22.00, 'https://atlanta-ga.events/event/black-pistol-fire-atlanta-tuesday-april-21-2026-700-pm/?pid=6740', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Boys Like Girls, iDKHOW & Arrows In Action',
  'A stacked pop-rock lineup at Buckhead Theatre — Boys Like Girls and iDKHOW headline with Arrows In Action opening.',
  'Music', ARRAY['live-music','pop','rock','concert'],
  (SELECT id FROM public.neighborhoods WHERE slug='buckhead'),
  'Buckhead Theatre', '3110 Roswell Road, Atlanta, GA 30305',
  '2026-04-21 19:00:00-04', '2026-04-21 23:00:00-04',
  35.00, 'https://atlanta-ga.events/event/boys-like-girls-idkhow-and-arrows-in-action-atlanta-tuesday-april-21-2026-700-pm/?pid=3834', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Spring Classic: Georgia Bulldogs vs. Georgia Tech Yellow Jackets',
  'The annual Spring Classic college baseball rivalry game between UGA and Georgia Tech at Truist Park.',
  'Sports', ARRAY['sports','baseball','college'],
  (SELECT id FROM public.neighborhoods WHERE slug='buckhead'),
  'Truist Park', '1100 Circle 75 Pkwy, Atlanta, GA 30339',
  '2026-04-21 19:00:00-04', '2026-04-21 22:00:00-04',
  15.00, 'https://atlanta-ga.events/event/spring-classic-georgia-bulldogs-vs-georgia-tech-yellow-jackets-atlanta-tuesday-april-21-2026-700-pm/?pid=4960', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Dropout Improv',
  'Dropout Improv brings fast, funny, and completely unscripted comedy to Coca-Cola Roxy for a night of laughs.',
  'Arts & Culture', ARRAY['comedy','improv','nightlife'],
  (SELECT id FROM public.neighborhoods WHERE slug='buckhead'),
  'Coca-Cola Roxy', '800 Battery Ave SE, Atlanta, GA 30339',
  '2026-04-21 19:30:00-04', '2026-04-21 22:00:00-04',
  25.00, 'https://atlanta-ga.events/event/dropout-improv-atlanta-tuesday-april-21-2026-730-pm/', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Native Land Podcast Live',
  'The Native Land Podcast records a special live episode at City Winery Atlanta with an intimate audience.',
  'Arts & Culture', ARRAY['podcast','community','nightlife'],
  (SELECT id FROM public.neighborhoods WHERE slug='poncey-highland'),
  'City Winery Atlanta', '675 Ponce De Leon Ave, Atlanta, GA 30308',
  '2026-04-21 19:30:00-04', '2026-04-21 22:00:00-04',
  20.00, 'https://atlanta-ga.events/event/native-land-podcast-atlanta-tuesday-april-21-2026-730-pm/', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Theresa Caputo Live',
  'The Long Island Medium, Theresa Caputo, brings her live show to The Tabernacle for an evening of readings and connection.',
  'Arts & Culture', ARRAY['nightlife','arts'],
  (SELECT id FROM public.neighborhoods WHERE slug='castleberry-hill'),
  'The Tabernacle', '152 Luckie St, Atlanta, GA 30303',
  '2026-04-21 19:30:00-04', '2026-04-21 22:30:00-04',
  45.00, 'https://atlanta-ga.events/event/theresa-caputo-atlanta-tuesday-april-21-2026-730-pm/?pid=2412', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Lexa Gates',
  'Lexa Gates performs at Heaven Stage at the Masquerade — soulful R&B and alt-pop from one of Atlanta''s rising voices.',
  'Music', ARRAY['live-music','r&b','concert'],
  (SELECT id FROM public.neighborhoods WHERE slug='castleberry-hill'),
  'Heaven Stage at Masquerade', '75 MLK Jr Dr SW, Atlanta, GA 30303',
  '2026-04-21 20:00:00-04', '2026-04-21 23:00:00-04',
  18.00, 'https://atlanta-ga.events/event/lexa-gates-atlanta-tuesday-april-21-2026-800-pm/?pid=8877', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'OCT – On Company Time',
  'OCT brings their eclectic blend of funk, soul, and good vibes to Aisle 5 in Little Five Points.',
  'Music', ARRAY['live-music','funk','soul','nightlife'],
  (SELECT id FROM public.neighborhoods WHERE slug='little-five-points'),
  'Aisle 5', '1123 Euclid Ave NE, Atlanta, GA 30307',
  '2026-04-21 20:00:00-04', '2026-04-21 23:30:00-04',
  12.00, 'https://atlanta-ga.events/event/oct-on-company-time-atlanta-tuesday-april-21-2026-800-pm/', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Lily Allen',
  'British pop icon Lily Allen performs at the Fabulous Fox Theatre on her intimate tour.',
  'Music', ARRAY['live-music','pop','concert'],
  (SELECT id FROM public.neighborhoods WHERE slug='midtown'),
  'Fox Theatre', '660 Peachtree St NE, Atlanta, GA 30308',
  '2026-04-21 20:00:00-04', '2026-04-21 23:00:00-04',
  55.00, 'https://atlanta-ga.events/event/lily-allen-atlanta-tuesday-april-21-2026-800-pm/', false, 'published'
),

-- ── APRIL 22 ─────────────────────────────────────────────────

(
  '00000000-0000-0000-0000-000000000001',
  'Damien Escobar — Early Show',
  'Violinist and producer Damien Escobar performs his blend of R&B and classical music at City Winery Atlanta.',
  'Music', ARRAY['live-music','r&b','jazz','intimate'],
  (SELECT id FROM public.neighborhoods WHERE slug='poncey-highland'),
  'City Winery Atlanta', '675 Ponce De Leon Ave, Atlanta, GA 30308',
  '2026-04-22 18:00:00-04', '2026-04-22 20:30:00-04',
  35.00, 'https://atlanta-ga.events/event/damien-escobar-atlanta-wednesday-april-22-2026-600-pm/?pid=4121', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Georgia Tech Yellow Jackets vs. Furman Paladins',
  'ACC baseball action as Georgia Tech hosts the Furman Paladins at Shirley Clements Mewborn Field.',
  'Sports', ARRAY['sports','baseball','college'],
  (SELECT id FROM public.neighborhoods WHERE slug='midtown'),
  'Shirley Clements Mewborn Field', '935 Fowler Street, Atlanta, GA 30332',
  '2026-04-22 18:00:00-04', '2026-04-22 21:00:00-04',
  10.00, 'https://atlanta-ga.events/event/georgia-tech-yellow-jackets-vs-furman-paladins-atlanta-wednesday-april-22-2026-600-pm/?pid=5828', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'LANY',
  'Dreamy indie-pop trio LANY brings their lush, emotional sound to Coca-Cola Roxy.',
  'Music', ARRAY['live-music','indie','pop','concert'],
  (SELECT id FROM public.neighborhoods WHERE slug='buckhead'),
  'Coca-Cola Roxy', '800 Battery Ave SE, Atlanta, GA 30339',
  '2026-04-22 19:30:00-04', '2026-04-22 23:00:00-04',
  40.00, 'https://atlanta-ga.events/event/lany-atlanta-wednesday-april-22-2026-730-pm/?pid=941', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Hunter Hayes',
  'Country singer-songwriter Hunter Hayes performs at Center Stage Theatre with his signature pop-country sound.',
  'Music', ARRAY['live-music','country','concert'],
  (SELECT id FROM public.neighborhoods WHERE slug='midtown'),
  'Center Stage Theatre', '1374 West Peachtree Street NW, Atlanta, GA 30309',
  '2026-04-22 19:30:00-04', '2026-04-22 23:00:00-04',
  30.00, 'https://atlanta-ga.events/event/hunter-hayes-atlanta-wednesday-april-22-2026-730-pm/?pid=2906', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Atlanta United FC vs. New England Revolution',
  'Atlanta United host the New England Revolution at Mercedes-Benz Stadium in MLS action.',
  'Sports', ARRAY['sports','soccer','mls'],
  (SELECT id FROM public.neighborhoods WHERE slug='castleberry-hill'),
  'Mercedes-Benz Stadium', 'MLK Jr Dr SW & Northside Dr NW, Atlanta, GA 30313',
  '2026-04-22 19:30:00-04', '2026-04-22 22:00:00-04',
  30.00, 'https://atlanta-ga.events/event/atlanta-united-fc-vs-new-england-revolution-atlanta-wednesday-april-22-2026-730-pm/?pid=671', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Victor Jones',
  'Victor Jones brings his smooth neo-soul and R&B to Aisle 5 for an intimate night in Little Five Points.',
  'Music', ARRAY['live-music','r&b','soul','intimate'],
  (SELECT id FROM public.neighborhoods WHERE slug='little-five-points'),
  'Aisle 5', '1123 Euclid Ave NE, Atlanta, GA 30307',
  '2026-04-22 20:00:00-04', '2026-04-22 23:30:00-04',
  12.00, 'https://atlanta-ga.events/event/victor-jones-atlanta-wednesday-april-22-2026-800-pm/', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Fantastic Cat',
  'Fantastic Cat performs their brand of feel-good indie folk at Vinyl in Midtown Atlanta.',
  'Music', ARRAY['live-music','indie','folk','chill'],
  (SELECT id FROM public.neighborhoods WHERE slug='midtown'),
  'Vinyl', '1374 West Peachtree Street, Atlanta, GA 30309',
  '2026-04-22 20:00:00-04', '2026-04-22 23:30:00-04',
  15.00, 'https://atlanta-ga.events/event/fantastic-cat-atlanta-wednesday-april-22-2026-800-pm/', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Snail Mail',
  'Indie rock darling Snail Mail performs at Variety Playhouse in Little Five Points on her latest tour.',
  'Music', ARRAY['live-music','indie','rock','concert'],
  (SELECT id FROM public.neighborhoods WHERE slug='little-five-points'),
  'Variety Playhouse', '1099 Euclid Ave NE, Atlanta, GA 30307',
  '2026-04-22 20:00:00-04', '2026-04-22 23:30:00-04',
  28.00, 'https://atlanta-ga.events/event/snail-mail-atlanta-wednesday-april-22-2026-800-pm/?pid=1392', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'King Tuff',
  'Garage rock legend King Tuff takes the stage at The Earl in East Atlanta Village.',
  'Music', ARRAY['live-music','rock','indie','concert'],
  (SELECT id FROM public.neighborhoods WHERE slug='east-atlanta'),
  'The Earl', '488 Flat Shoals Avenue, Atlanta, GA 30316',
  '2026-04-22 20:30:00-04', '2026-04-22 23:59:00-04',
  18.00, 'https://atlanta-ga.events/event/king-tuff-atlanta-wednesday-april-22-2026-830-pm/?pid=1935', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Damien Escobar — Late Show',
  'A second intimate performance by Damien Escobar at City Winery Atlanta — late night vibes with live violin and R&B.',
  'Music', ARRAY['live-music','r&b','jazz','intimate','nightlife'],
  (SELECT id FROM public.neighborhoods WHERE slug='poncey-highland'),
  'City Winery Atlanta', '675 Ponce De Leon Ave, Atlanta, GA 30308',
  '2026-04-22 21:30:00-04', '2026-04-22 23:59:00-04',
  35.00, 'https://atlanta-ga.events/event/damien-escobar-atlanta-wednesday-april-22-2026-930-pm/?pid=4121', false, 'published'
),

-- ── APRIL 23 ─────────────────────────────────────────────────

(
  '00000000-0000-0000-0000-000000000001',
  'Princesss',
  'Princesss brings her unique blend of alt-pop and hyperpop to Altar Stage at The Masquerade.',
  'Music', ARRAY['live-music','pop','indie','concert'],
  (SELECT id FROM public.neighborhoods WHERE slug='castleberry-hill'),
  'Altar at Masquerade', '75 MLK Jr Dr SW, Atlanta, GA 30303',
  '2026-04-23 18:00:00-04', '2026-04-23 21:00:00-04',
  15.00, 'https://atlanta-ga.events/event/princesss-atlanta-thursday-april-23-2026-600-pm/', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Damien Escobar — Early Show (Thu)',
  'Damien Escobar returns for another evening performance at City Winery Atlanta on Thursday.',
  'Music', ARRAY['live-music','r&b','jazz','intimate'],
  (SELECT id FROM public.neighborhoods WHERE slug='poncey-highland'),
  'City Winery Atlanta', '675 Ponce De Leon Ave, Atlanta, GA 30308',
  '2026-04-23 18:00:00-04', '2026-04-23 20:30:00-04',
  35.00, 'https://atlanta-ga.events/event/damien-escobar-atlanta-thursday-april-23-2026-600-pm/?pid=4121', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Candlelight: The Best of Frank Sinatra and Nat King Cole',
  'A stunning candlelight concert featuring the timeless music of Sinatra and Nat King Cole performed live at The Wimbish House.',
  'Music', ARRAY['live-music','jazz','intimate','chill','date-night'],
  (SELECT id FROM public.neighborhoods WHERE slug='midtown'),
  'The Wimbish House', '1150 Peachtree St NE, Atlanta, GA 30309',
  '2026-04-23 18:30:00-04', '2026-04-23 21:00:00-04',
  40.00, 'https://atlanta-ga.events/event/candlelight-the-best-of-frank-sinatra-and-nat-king-cole-atlanta-thursday-april-23-2026-630-pm/', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Candlelight: Best of Bridgerton on Strings',
  'A magical candlelit strings performance of the best music from Bridgerton at The Chapel on Sycamore in Decatur.',
  'Music', ARRAY['live-music','classical','intimate','chill','date-night'],
  (SELECT id FROM public.neighborhoods WHERE slug='decatur'),
  'The Chapel on Sycamore', '318 Sycamore Street, Decatur, GA 30030',
  '2026-04-23 18:30:00-04', '2026-04-23 21:00:00-04',
  40.00, 'https://atlanta-ga.events/event/candlelight-best-of-bridgerton-on-strings-decatur-thursday-april-23-2026-630-pm/', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'The Red Pears & Together Pangea',
  'The Red Pears and Together Pangea team up for a high-energy punk and indie rock show at The Masquerade.',
  'Music', ARRAY['live-music','punk','indie','rock','concert'],
  (SELECT id FROM public.neighborhoods WHERE slug='castleberry-hill'),
  'Hell at The Masquerade', '75 MLK Jr Dr SW, Atlanta, GA 30303',
  '2026-04-23 19:00:00-04', '2026-04-23 23:00:00-04',
  20.00, 'https://atlanta-ga.events/event/the-red-pears-and-together-pangea-atlanta-thursday-april-23-2026-700-pm/?pid=6877', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Gatecreeper',
  'Death metal heavyweights Gatecreeper bring their crushing sound to the Purgatory Stage at The Masquerade.',
  'Music', ARRAY['live-music','metal','rock','concert'],
  (SELECT id FROM public.neighborhoods WHERE slug='castleberry-hill'),
  'Purgatory Stage at Masquerade', '75 MLK Jr Dr SW, Atlanta, GA 30303',
  '2026-04-23 19:00:00-04', '2026-04-23 23:00:00-04',
  18.00, 'https://atlanta-ga.events/event/gatecreeper-atlanta-thursday-april-23-2026-700-pm/?pid=7213', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'NBA Playoffs: Atlanta Hawks vs. New York Knicks — Game 3',
  'The Atlanta Hawks host the New York Knicks in Game 3 of the NBA Eastern Conference First Round at State Farm Arena.',
  'Sports', ARRAY['sports','basketball','nba','playoffs'],
  (SELECT id FROM public.neighborhoods WHERE slug='castleberry-hill'),
  'State Farm Arena', '1 State Farm Drive, Atlanta, GA 30303',
  '2026-04-23 19:00:00-04', '2026-04-23 22:30:00-04',
  75.00, 'https://atlanta-ga.events/event/nba-eastern-conference-first-round-atlanta-hawks-vs-new-york-knicks-home-game-1-series-game-3-atlanta-thursday-april-23-2026-700-pm/?pid=1225', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'T-26 H3 Cowboys & East Indians',
  'A thought-provoking theatrical production exploring identity and culture at the Alliance Theatre''s Hertz Stage.',
  'Arts & Culture', ARRAY['arts','theater','community'],
  (SELECT id FROM public.neighborhoods WHERE slug='midtown'),
  'Hertz Stage at Alliance Theatre', '1280 Peachtree Street NE, Atlanta, GA 30309',
  '2026-04-23 19:30:00-04', '2026-04-23 22:00:00-04',
  30.00, 'https://atlanta-ga.events/event/t-26-h3-cowboys-and-east-indians-atlanta-thursday-april-23-2026-730-pm/', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Atlanta Symphony Orchestra: Giancarlo Guerrero & Pacho Flores',
  'The Atlanta Symphony Orchestra performs Márquez with conductor Giancarlo Guerrero and trumpet soloist Pacho Flores at Atlanta Symphony Hall.',
  'Arts & Culture', ARRAY['live-music','classical','arts','orchestra'],
  (SELECT id FROM public.neighborhoods WHERE slug='midtown'),
  'Atlanta Symphony Hall', '1280 Peachtree St NE, Atlanta, GA 30309',
  '2026-04-23 20:00:00-04', '2026-04-23 22:30:00-04',
  45.00, 'https://atlanta-ga.events/event/atlanta-symphony-orchestra-giancarlo-guerrero-and-pacho-flores-marquez-atlanta-thursday-april-23-2026-800-pm/?pid=673', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Driveways',
  'Driveways bring their dreamy indie rock sound to The Loft at Center Stage in Midtown Atlanta.',
  'Music', ARRAY['live-music','indie','rock','concert'],
  (SELECT id FROM public.neighborhoods WHERE slug='midtown'),
  'The Loft at Center Stage', '1374 W. Peachtree Street, Atlanta, GA 30309',
  '2026-04-23 20:00:00-04', '2026-04-23 23:30:00-04',
  18.00, 'https://atlanta-ga.events/event/driveways-atlanta-thursday-april-23-2026-800-pm/?pid=5836', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Willie Nelson',
  'Country music legend Willie Nelson performs at the Synovus Bank Amphitheater at Chastain Park under the stars.',
  'Music', ARRAY['live-music','country','concert','outdoor'],
  (SELECT id FROM public.neighborhoods WHERE slug='buckhead'),
  'Synovus Bank Amphitheater at Chastain Park', '4469 Stella Drive NW, Atlanta, GA 30327',
  '2026-04-23 20:00:00-04', '2026-04-23 23:00:00-04',
  65.00, 'https://atlanta-ga.events/event/willie-nelson-atlanta-thursday-april-23-2026-800-pm/?pid=4210', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'The Yawpers',
  'Denver rock band The Yawpers bring their raw Americana sound to Vinyl in Midtown.',
  'Music', ARRAY['live-music','rock','indie','concert'],
  (SELECT id FROM public.neighborhoods WHERE slug='midtown'),
  'Vinyl', '1374 West Peachtree Street, Atlanta, GA 30309',
  '2026-04-23 20:00:00-04', '2026-04-23 23:30:00-04',
  15.00, 'https://atlanta-ga.events/event/the-yawpers-atlanta-thursday-april-23-2026-800-pm/', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'CupcakKe',
  'Rapper CupcakKe brings her boundary-pushing and unapologetically bold performance to Variety Playhouse.',
  'Music', ARRAY['live-music','hip-hop','rap','concert'],
  (SELECT id FROM public.neighborhoods WHERE slug='little-five-points'),
  'Variety Playhouse', '1099 Euclid Ave NE, Atlanta, GA 30307',
  '2026-04-23 20:00:00-04', '2026-04-23 23:30:00-04',
  25.00, 'https://atlanta-ga.events/event/cupcakke-atlanta-thursday-april-23-2026-800-pm/?pid=2793', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Concrete Boys',
  'Gunna''s Concrete Boys collective brings the ATL sound back home with a headlining show at Center Stage.',
  'Music', ARRAY['live-music','hip-hop','rap','concert'],
  (SELECT id FROM public.neighborhoods WHERE slug='midtown'),
  'Center Stage Theatre', '1374 West Peachtree Street NW, Atlanta, GA 30309',
  '2026-04-23 20:00:00-04', '2026-04-23 23:30:00-04',
  35.00, 'https://atlanta-ga.events/event/concrete-boys-atlanta-thursday-april-23-2026-800-pm/?pid=6396', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Polyrhythmics',
  'Seattle funk ensemble Polyrhythmics plays Aisle 5 in Little Five Points for a dance-heavy evening of grooves.',
  'Music', ARRAY['live-music','funk','jazz','dance','nightlife'],
  (SELECT id FROM public.neighborhoods WHERE slug='little-five-points'),
  'Aisle 5', '1123 Euclid Ave NE, Atlanta, GA 30307',
  '2026-04-23 20:00:00-04', '2026-04-23 23:30:00-04',
  15.00, 'https://atlanta-ga.events/event/polyrhythmics-atlanta-thursday-april-23-2026-800-pm/?pid=10028', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Damien Escobar — Late Show (Thu)',
  'A late-night encore performance by Damien Escobar at City Winery Atlanta on Thursday.',
  'Music', ARRAY['live-music','r&b','jazz','intimate','nightlife'],
  (SELECT id FROM public.neighborhoods WHERE slug='poncey-highland'),
  'City Winery Atlanta', '675 Ponce De Leon Ave, Atlanta, GA 30308',
  '2026-04-23 21:30:00-04', '2026-04-23 23:59:00-04',
  35.00, 'https://atlanta-ga.events/event/damien-escobar-atlanta-thursday-april-23-2026-930-pm/?pid=4121', false, 'published'
),

-- ── APRIL 24 ─────────────────────────────────────────────────

(
  '00000000-0000-0000-0000-000000000001',
  'The Troubadours Tour: Josh Baldwin, Matt Maher & John Mark McMillan',
  'An evening of worship and folk songwriting with Josh Baldwin, Matt Maher and John Mark McMillan.',
  'Music', ARRAY['live-music','folk','community'],
  (SELECT id FROM public.neighborhoods WHERE slug='buckhead'),
  'Dunwoody Baptist Church', '1445 Mount Vernon Rd, Dunwoody, GA 30338',
  '2026-04-24 19:00:00-04', '2026-04-24 22:00:00-04',
  25.00, 'https://atlanta-ga.events/event/the-troubadours-tour-josh-baldwin-matt-maher-and-john-mark-mcmillan-atlanta-friday-april-24-2026-700-pm/', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Panchiko',
  'The cult favorite Panchiko performs at The Eastern — dreamy shoegaze and glitch-pop for a very special Atlanta night.',
  'Music', ARRAY['live-music','indie','shoegaze','concert'],
  (SELECT id FROM public.neighborhoods WHERE slug='grant-park'),
  'The Eastern', '800 Old Flat Shoals Road SE, Atlanta, GA 30316',
  '2026-04-24 19:30:00-04', '2026-04-24 23:00:00-04',
  22.00, 'https://atlanta-ga.events/event/panchiko-atlanta-friday-april-24-2026-730-pm/?pid=2938', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'MJT The Band',
  'MJT The Band brings their high-energy funk and R&B sound to Aisle 5 in Little Five Points.',
  'Music', ARRAY['live-music','funk','r&b','nightlife'],
  (SELECT id FROM public.neighborhoods WHERE slug='little-five-points'),
  'Aisle 5', '1123 Euclid Ave NE, Atlanta, GA 30307',
  '2026-04-24 20:00:00-04', '2026-04-24 23:30:00-04',
  12.00, 'https://atlanta-ga.events/event/mjt-the-band-atlanta-friday-april-24-2026-800-pm/', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Curren$y',
  'New Orleans rap icon Curren$y brings his laid-back, weed-influenced style to Center Stage Theatre.',
  'Music', ARRAY['live-music','hip-hop','rap','concert'],
  (SELECT id FROM public.neighborhoods WHERE slug='midtown'),
  'Center Stage Theatre', '1374 West Peachtree Street NW, Atlanta, GA 30309',
  '2026-04-24 20:00:00-04', '2026-04-24 23:30:00-04',
  30.00, 'https://atlanta-ga.events/event/currendollary-atlanta-friday-april-24-2026-800-pm/?pid=1432', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Georgia Tech vs. Florida State — Baseball',
  'ACC baseball: Georgia Tech Yellow Jackets host the Florida State Seminoles at Shirley Clements Mewborn Field.',
  'Sports', ARRAY['sports','baseball','college'],
  (SELECT id FROM public.neighborhoods WHERE slug='midtown'),
  'Shirley Clements Mewborn Field', '935 Fowler Street, Atlanta, GA 30332',
  '2026-04-24 18:00:00-04', '2026-04-24 21:00:00-04',
  10.00, 'https://atlanta-ga.events/event/georgia-tech-yellow-jackets-vs-florida-state-seminoles-atlanta-friday-april-24-2026-600-pm/', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Georgia Tech vs. Wake Forest — Baseball (Fri)',
  'Georgia Tech hosts Wake Forest in ACC baseball at Russ Chandler Stadium.',
  'Sports', ARRAY['sports','baseball','college'],
  (SELECT id FROM public.neighborhoods WHERE slug='midtown'),
  'Russ Chandler Stadium', '255 Ferst Drive NW, Atlanta, GA 30318',
  '2026-04-24 19:00:00-04', '2026-04-24 22:00:00-04',
  10.00, 'https://atlanta-ga.events/event/georgia-tech-yellow-jackets-vs-wake-forest-demon-deacons-atlanta-friday-april-24-2026-700-pm/', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Atlanta Braves vs. Philadelphia Phillies (Fri)',
  'The Atlanta Braves open a home series against the Philadelphia Phillies at Truist Park.',
  'Sports', ARRAY['sports','baseball','mlb'],
  (SELECT id FROM public.neighborhoods WHERE slug='buckhead'),
  'Truist Park', '1100 Circle 75 Pkwy, Atlanta, GA 30339',
  '2026-04-24 19:15:00-04', '2026-04-24 22:30:00-04',
  30.00, 'https://atlanta-ga.events/event/atlanta-braves-vs-philadelphia-phillies-atlanta-friday-april-24-2026-715-pm/', false, 'published'
),

-- ── APRIL 25 ─────────────────────────────────────────────────

(
  '00000000-0000-0000-0000-000000000001',
  'Georgia Tech vs. Wake Forest — Baseball (Sat)',
  'Saturday afternoon ACC baseball at Russ Chandler Stadium: Georgia Tech vs. Wake Forest.',
  'Sports', ARRAY['sports','baseball','college'],
  (SELECT id FROM public.neighborhoods WHERE slug='midtown'),
  'Russ Chandler Stadium', '255 Ferst Drive NW, Atlanta, GA 30318',
  '2026-04-25 15:00:00-04', '2026-04-25 18:00:00-04',
  10.00, 'https://atlanta-ga.events/event/georgia-tech-yellow-jackets-vs-wake-forest-demon-deacons-atlanta-saturday-april-25-2026-300-pm/', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Georgia Tech vs. Florida State — Baseball (Sat)',
  'Saturday ACC baseball: Georgia Tech hosts Florida State at Shirley Clements Mewborn Field.',
  'Sports', ARRAY['sports','baseball','college'],
  (SELECT id FROM public.neighborhoods WHERE slug='midtown'),
  'Shirley Clements Mewborn Field', '935 Fowler Street, Atlanta, GA 30332',
  '2026-04-25 16:00:00-04', '2026-04-25 19:00:00-04',
  10.00, 'https://atlanta-ga.events/event/georgia-tech-yellow-jackets-vs-florida-state-seminoles-atlanta-saturday-april-25-2026-400-pm/', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'NBA Playoffs: Atlanta Hawks vs. New York Knicks — Game 4',
  'The Hawks host the Knicks in Game 4 of the NBA Eastern Conference First Round at State Farm Arena.',
  'Sports', ARRAY['sports','basketball','nba','playoffs'],
  (SELECT id FROM public.neighborhoods WHERE slug='castleberry-hill'),
  'State Farm Arena', '1 State Farm Drive, Atlanta, GA 30303',
  '2026-04-25 18:00:00-04', '2026-04-25 21:30:00-04',
  75.00, 'https://atlanta-ga.events/event/nba-eastern-conference-first-round-atlanta-hawks-vs-new-york-knicks-home-game-2-series-game-4-atlanta-saturday-april-25-2026-600-pm/', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Atlanta Braves vs. Philadelphia Phillies (Sat)',
  'The Braves continue their home series against the Phillies on Saturday night at Truist Park.',
  'Sports', ARRAY['sports','baseball','mlb'],
  (SELECT id FROM public.neighborhoods WHERE slug='buckhead'),
  'Truist Park', '1100 Circle 75 Pkwy, Atlanta, GA 30339',
  '2026-04-25 19:15:00-04', '2026-04-25 22:30:00-04',
  30.00, 'https://atlanta-ga.events/event/atlanta-braves-vs-philadelphia-phillies-atlanta-saturday-april-25-2026-715-pm/', false, 'published'
),

-- ── APRIL 26 ─────────────────────────────────────────────────

(
  '00000000-0000-0000-0000-000000000001',
  'Georgia Tech vs. Florida State — Baseball (Sun)',
  'Sunday series finale: Georgia Tech vs. Florida State at Shirley Clements Mewborn Field.',
  'Sports', ARRAY['sports','baseball','college'],
  (SELECT id FROM public.neighborhoods WHERE slug='midtown'),
  'Shirley Clements Mewborn Field', '935 Fowler Street, Atlanta, GA 30332',
  '2026-04-26 13:00:00-04', '2026-04-26 16:00:00-04',
  10.00, 'https://atlanta-ga.events/event/georgia-tech-yellow-jackets-vs-florida-state-seminoles-atlanta-sunday-april-26-2026-100-pm/', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Georgia Tech vs. Wake Forest — Baseball (Sun)',
  'Sunday finale of the Wake Forest series at Russ Chandler Stadium.',
  'Sports', ARRAY['sports','baseball','college'],
  (SELECT id FROM public.neighborhoods WHERE slug='midtown'),
  'Russ Chandler Stadium', '255 Ferst Drive NW, Atlanta, GA 30318',
  '2026-04-26 13:00:00-04', '2026-04-26 16:00:00-04',
  10.00, 'https://atlanta-ga.events/event/georgia-tech-yellow-jackets-vs-wake-forest-demon-deacons-atlanta-sunday-april-26-2026-100-pm/', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Atlanta Braves vs. Philadelphia Phillies (Sun)',
  'Sunday afternoon series finale between the Atlanta Braves and Philadelphia Phillies at Truist Park.',
  'Sports', ARRAY['sports','baseball','mlb'],
  (SELECT id FROM public.neighborhoods WHERE slug='buckhead'),
  'Truist Park', '1100 Circle 75 Pkwy, Atlanta, GA 30339',
  '2026-04-26 13:30:00-04', '2026-04-26 17:00:00-04',
  30.00, 'https://atlanta-ga.events/event/atlanta-braves-vs-philadelphia-phillies-atlanta-sunday-april-26-2026-130-pm/', false, 'published'
),

-- ── APRIL 28-30 ──────────────────────────────────────────────

(
  '00000000-0000-0000-0000-000000000001',
  'Atlanta Braves vs. Detroit Tigers (Tue)',
  'The Atlanta Braves open a home series against the Detroit Tigers on Tuesday night at Truist Park.',
  'Sports', ARRAY['sports','baseball','mlb'],
  (SELECT id FROM public.neighborhoods WHERE slug='buckhead'),
  'Truist Park', '1100 Circle 75 Pkwy, Atlanta, GA 30339',
  '2026-04-28 19:15:00-04', '2026-04-28 22:30:00-04',
  30.00, 'https://atlanta-ga.events/event/atlanta-braves-vs-detroit-tigers-atlanta-tuesday-april-28-2026-715-pm/', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Atlanta Braves vs. Detroit Tigers (Wed)',
  'The Braves host the Tigers for game two of the midweek series at Truist Park.',
  'Sports', ARRAY['sports','baseball','mlb'],
  (SELECT id FROM public.neighborhoods WHERE slug='buckhead'),
  'Truist Park', '1100 Circle 75 Pkwy, Atlanta, GA 30339',
  '2026-04-29 19:15:00-04', '2026-04-29 22:30:00-04',
  30.00, 'https://atlanta-ga.events/event/atlanta-braves-vs-detroit-tigers-atlanta-wednesday-april-29-2026-715-pm/', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'NBA Playoffs: Atlanta Hawks vs. New York Knicks — Game 6 (If Necessary)',
  'If the series goes to Game 6, the Hawks host the Knicks back at State Farm Arena in a must-win situation.',
  'Sports', ARRAY['sports','basketball','nba','playoffs'],
  (SELECT id FROM public.neighborhoods WHERE slug='castleberry-hill'),
  'State Farm Arena', '1 State Farm Drive, Atlanta, GA 30303',
  '2026-04-30 19:00:00-04', '2026-04-30 22:30:00-04',
  85.00, 'https://atlanta-ga.events/event/nba-eastern-conference-first-round-atlanta-hawks-vs-new-york-knicks-home-game-3-series-game-6-if-necessary-atlanta-thursday-april-30-2026-tba/', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Atlanta Braves vs. Detroit Tigers (Thu)',
  'Series finale between the Atlanta Braves and Detroit Tigers — Thursday afternoon at Truist Park.',
  'Sports', ARRAY['sports','baseball','mlb'],
  (SELECT id FROM public.neighborhoods WHERE slug='buckhead'),
  'Truist Park', '1100 Circle 75 Pkwy, Atlanta, GA 30339',
  '2026-04-30 12:15:00-04', '2026-04-30 15:30:00-04',
  30.00, 'https://atlanta-ga.events/event/atlanta-braves-vs-detroit-tigers-atlanta-thursday-april-30-2026-1215-pm/', false, 'published'
),

-- ── MAY 1-3 ──────────────────────────────────────────────────

(
  '00000000-0000-0000-0000-000000000001',
  'Georgia Tech vs. Xavier — Baseball (Fri)',
  'Georgia Tech hosts Xavier at Russ Chandler Stadium for a Friday night college baseball matchup.',
  'Sports', ARRAY['sports','baseball','college'],
  (SELECT id FROM public.neighborhoods WHERE slug='midtown'),
  'Russ Chandler Stadium', '255 Ferst Drive NW, Atlanta, GA 30318',
  '2026-05-01 19:00:00-04', '2026-05-01 22:00:00-04',
  10.00, 'https://atlanta-ga.events/event/georgia-tech-yellow-jackets-vs-xavier-musketeers-atlanta-friday-may-1-2026-700-pm/', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Georgia Tech vs. Xavier — Baseball (Sat)',
  'Saturday afternoon college baseball at Russ Chandler Stadium: Georgia Tech vs. Xavier.',
  'Sports', ARRAY['sports','baseball','college'],
  (SELECT id FROM public.neighborhoods WHERE slug='midtown'),
  'Russ Chandler Stadium', '255 Ferst Drive NW, Atlanta, GA 30318',
  '2026-05-02 15:00:00-04', '2026-05-02 18:00:00-04',
  10.00, 'https://atlanta-ga.events/event/georgia-tech-yellow-jackets-vs-xavier-musketeers-atlanta-saturday-may-2-2026-300-pm/', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Atlanta United FC vs. CF Montréal',
  'Atlanta United look to build on their season at home against CF Montréal at Mercedes-Benz Stadium.',
  'Sports', ARRAY['sports','soccer','mls'],
  (SELECT id FROM public.neighborhoods WHERE slug='castleberry-hill'),
  'Mercedes-Benz Stadium', 'MLK Jr Dr SW & Northside Dr NW, Atlanta, GA 30313',
  '2026-05-02 19:30:00-04', '2026-05-02 22:00:00-04',
  30.00, 'https://atlanta-ga.events/event/atlanta-united-fc-vs-cf-montreal-atlanta-saturday-may-2-2026-730-pm/', false, 'published'
),
(
  '00000000-0000-0000-0000-000000000001',
  'Georgia Tech vs. Xavier — Baseball (Sun)',
  'Sunday series finale between Georgia Tech and Xavier at Russ Chandler Stadium.',
  'Sports', ARRAY['sports','baseball','college'],
  (SELECT id FROM public.neighborhoods WHERE slug='midtown'),
  'Russ Chandler Stadium', '255 Ferst Drive NW, Atlanta, GA 30318',
  '2026-05-03 13:00:00-04', '2026-05-03 16:00:00-04',
  10.00, 'https://atlanta-ga.events/event/georgia-tech-yellow-jackets-vs-xavier-musketeers-atlanta-sunday-may-3-2026-100-pm/', false, 'published'
);
