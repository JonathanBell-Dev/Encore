import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';

const RESEND_API_KEY = Deno.env.get('RESEND_API_KEY') ?? '';
const FROM = 'Encore ATL <no-reply@encore-atl.com>';

interface RsvpPayload {
  to: string;
  name: string;
  eventTitle: string;
  eventDate: string;
  eventVenue: string;
  eventId: string;
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: { 'Access-Control-Allow-Origin': '*', 'Access-Control-Allow-Headers': 'authorization, content-type' } });
  }

  const payload: RsvpPayload = await req.json();
  const { to, name, eventTitle, eventDate, eventVenue, eventId } = payload;

  const eventUrl = `https://encore-atl.vercel.app/events/detail.html?id=${eventId}`;

  const html = `
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"></head>
<body style="margin:0;padding:0;background:#0C0C0C;font-family:'Helvetica Neue',Arial,sans-serif;color:#F0EDE8;">
  <div style="max-width:560px;margin:2rem auto;background:#141414;border-radius:16px;overflow:hidden;border:1px solid #262626;">
    <div style="background:#e8470a;padding:1.5rem 2rem;">
      <div style="display:inline-flex;align-items:center;gap:.5rem;">
        <div style="width:28px;height:28px;background:rgba(255,255,255,.2);border-radius:6px;display:flex;align-items:center;justify-content:center;font-weight:800;font-size:.9rem;color:#fff;">E</div>
        <span style="font-size:1.1rem;font-weight:800;color:#fff;">Encore ATL</span>
      </div>
    </div>
    <div style="padding:2rem;">
      <h1 style="font-size:1.4rem;font-weight:800;margin:0 0 .5rem;letter-spacing:-.02em;">You're going! 🎉</h1>
      <p style="color:#9A9590;font-size:.9rem;margin:0 0 1.5rem;">Hey ${name}, your RSVP is confirmed.</p>
      <div style="background:#1C1C1C;border:1px solid #262626;border-radius:12px;padding:1.25rem;margin-bottom:1.5rem;">
        <div style="font-size:1.05rem;font-weight:700;margin-bottom:.5rem;">${eventTitle}</div>
        <div style="font-size:.85rem;color:#9A9590;margin-bottom:.3rem;">📅 ${eventDate}</div>
        <div style="font-size:.85rem;color:#9A9590;">📍 ${eventVenue}</div>
      </div>
      <a href="${eventUrl}" style="display:inline-block;background:#e8470a;color:#fff;text-decoration:none;border-radius:10px;padding:.75rem 1.5rem;font-weight:700;font-size:.9rem;">View Event Details</a>
    </div>
    <div style="padding:1rem 2rem;border-top:1px solid #262626;font-size:.75rem;color:#555;">
      © 2026 Encore ATL · Atlanta's event community
    </div>
  </div>
</body>
</html>`;

  const res = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: { 'Authorization': `Bearer ${RESEND_API_KEY}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({ from: FROM, to, subject: `You're going to ${eventTitle}! 🎉`, html }),
  });

  if (!res.ok) {
    const err = await res.text();
    return new Response(JSON.stringify({ error: err }), { status: 500, headers: { 'Content-Type': 'application/json' } });
  }

  return new Response(JSON.stringify({ ok: true }), { headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' } });
});
