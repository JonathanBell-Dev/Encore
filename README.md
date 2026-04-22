# Encore ATL

Atlanta's event discovery and community platform. Find concerts, events, and experiences across Atlanta's neighborhoods — then connect with the people who make the city move.

**Live site:** https://encore-v1.vercel.app

---

## About

Encore ATL is a full-stack social event platform built specifically for Atlanta. It combines event discovery with a social layer — so you're not just finding events, you're seeing what your friends are going to, connecting with people who share your vibe, and building your ATL social calendar in one place.

Whether you're an attendee looking for your next night out or an organizer promoting your event, Encore gives you the tools to do it.

---

## Features

### Event Discovery
- Browse hundreds of upcoming Atlanta events across categories — Music, Food & Drink, Art, Nightlife, Sports, Comedy, Networking, and more
- Filter by category, vibe tags (Live Music, Free Entry, Rooftop, DJ Set, Outdoor, etc.), neighborhood, and date range
- Full-text search across event titles, venues, and descriptions
- Interactive neighborhood map — click any ATL neighborhood to see what's happening there
- Personalized "For You" recommendations based on your past RSVPs and interests
- Trending events section updated in real time

### RSVP & Attendance
- Mark yourself as Going or Interested on any event
- RSVP confirmation email sent automatically via Resend
- Save events to your personal favorites list
- See how many people are going to each event
- Check in at events using a QR code scan

### Social & Community
- Friend/connection system — send and accept connection requests
- Friend activity feed on the homepage showing what your connections are going to
- Community feed — post updates, share experiences, react and comment
- Real-time event chat room for each event, visible to all attendees
- Click trending hashtags to see matching events
- Browse and connect with other Atlanta community members

### Event Organizers
- Create and publish events with full details — title, description, date/time, venue, category, vibe tags, ticket price, cover image URL
- View detailed analytics for your events — going count, interested count, check-ins, estimated reach, bar charts, full attendee list
- Generate a QR code for event check-in that attendees scan on arrival
- Get email notifications when someone RSVPs to your event
- Delete your events

### Notifications & Alerts
- In-app notification bell for connection requests, RSVPs, and messages
- Email notifications for:
  - RSVP confirmation (sent to attendee)
  - New RSVP on your event (sent to organizer)
  - New connection request (sent to recipient)
- Web push notifications (browser-based, opt-in)

### Profiles
- Public profile pages with bio, location, interests, and social stats
- View another user's profile, events they're going to, and mutual connections
- Connect, block, or report users from their profile
- Onboarding flow that captures your interests and suggests people to follow

### Admin Dashboard
- Overview stats — total users, events, posts, reports
- View and dismiss user-submitted reports (events and users)
- Manage blocked users
- Search and delete any event
- View all users and toggle admin privileges

### PWA
- Installable as a mobile app on iOS and Android
- Offline support via service worker cache
- Push notification support

---

## Tech Stack

| Layer | Tech |
|---|---|
| Frontend | Vanilla HTML, CSS, JavaScript |
| Backend | Supabase (Postgres + Auth + Realtime + Storage) |
| Edge Functions | Deno (Supabase Functions) |
| Email | Resend API |
| Maps | Leaflet.js + OpenStreetMap |
| Hosting | Vercel |
| PWA | Service Worker + Web Manifest |
| Push | Web Push API + VAPID |

---

## Project Structure

```
├── homepage/         # Main event discovery page
├── events/           # Event detail, creation, analytics, check-in, chat
├── community/        # Community feed
├── profile/          # User profile and connections
├── admin/            # Admin dashboard (requires is_admin flag)
├── auth/             # Login, signup, onboarding, password reset
├── login/            # Login page
├── css/              # Global styles
├── src/utils/        # Shared JS utilities (notifications, reports, auth guard)
├── supabase/
│   └── functions/    # Edge Functions (rsvp-email, send-push, notify-email)
├── database/         # SQL migration files
├── sw.js             # Service worker (PWA + push notifications)
└── manifest.json     # PWA manifest
```

---

## Database Setup

Run these SQL files in your Supabase SQL Editor in order:

1. `database/admin_checkins.sql` — check-ins, push subscriptions, is_admin flag
2. `database/reports_blocks.sql` — reports and blocks tables
3. `database/event_messages.sql` — event chat messages

---

## Edge Functions

Deploy with the Supabase CLI:

```bash
supabase functions deploy rsvp-email
supabase functions deploy send-push
supabase functions deploy notify-email
```

Set required secrets:

```bash
supabase secrets set RESEND_API_KEY=your_key_here
```

`SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY` are injected automatically by Supabase at runtime.

---

## Admin Access

To grant admin privileges, run in Supabase SQL Editor:

```sql
update accounts set is_admin = true
where id = (select id from auth.users where email = 'your@email.com');
```

Then navigate to `/admin/admin.html`.

---

## Local Development

No build step required. Open any `.html` file directly or use a local server:

```bash
npx serve .
```

---

## Environment

Supabase project URL and anon key are referenced directly in each page's script block. To point to a different Supabase project, find and replace the URL and anon key across the codebase.
