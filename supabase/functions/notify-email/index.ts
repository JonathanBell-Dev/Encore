import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const RESEND_API_KEY = Deno.env.get('RESEND_API_KEY') ?? 're_LJhRRbWs_P1zhdfbTAYXfMxmS8Q7QLcJq';
const FROM = 'Encore ATL <no-reply@encore-atl.com>';
const BASE_URL = 'https://encore-atl.vercel.app';

const SUPABASE_URL = Deno.env.get('SUPABASE_URL') ?? '';
const SERVICE_ROLE = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '';

async function getUserEmail(userId: string): Promise<string | null> {
  if (!SUPABASE_URL || !SERVICE_ROLE) return null;
  const admin = createClient(SUPABASE_URL, SERVICE_ROLE);
  const { data, error } = await admin.auth.admin.getUserById(userId);
  return error ? null : (data?.user?.email ?? null);
}

const CORS = { 'Access-Control-Allow-Origin': '*', 'Access-Control-Allow-Headers': 'authorization, content-type' };

function layout(content: string) {
  return `<!DOCTYPE html>
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
    <div style="padding:2rem;">${content}</div>
    <div style="padding:1rem 2rem;border-top:1px solid #262626;font-size:.75rem;color:#555;">
      © 2026 Encore ATL · Atlanta's event community
    </div>
  </div>
</body>
</html>`;
}

function btn(href: string, label: string) {
  return `<a href="${href}" style="display:inline-block;background:#e8470a;color:#fff;text-decoration:none;border-radius:10px;padding:.75rem 1.5rem;font-weight:700;font-size:.9rem;">${label}</a>`;
}

function muted(s: string) {
  return `<p style="color:#9A9590;font-size:.9rem;margin:0 0 1.5rem;">${s}</p>`;
}

async function sendEmail(to: string, subject: string, html: string) {
  const res = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: { 'Authorization': `Bearer ${RESEND_API_KEY}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({ from: FROM, to, subject, html }),
  });
  if (!res.ok) throw new Error(await res.text());
}

serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response(null, { headers: CORS });

  const payload = await req.json();
  const { type } = payload;

  try {
    if (type === 'connection_request') {
      // Someone sent you a connection request
      const { to: toOverride, recipientId, toName, fromName, fromId } = payload;
      const to = toOverride || (recipientId ? await getUserEmail(recipientId) : null);
      if (!to) return new Response(JSON.stringify({ ok: true, skipped: 'no email' }), { headers: { 'Content-Type': 'application/json', ...CORS } });
      const recipientName = toName || 'there';
      const profileUrl = `${BASE_URL}/profile/connection-profile.html?id=${fromId}`;
      const html = layout(`
        <h1 style="font-size:1.4rem;font-weight:800;margin:0 0 .5rem;letter-spacing:-.02em;">New connection request</h1>
        ${muted(`Hey ${recipientName}, someone wants to connect with you on Encore ATL.`)}
        <div style="background:#1C1C1C;border:1px solid #262626;border-radius:12px;padding:1.25rem;margin-bottom:1.5rem;">
          <div style="font-size:1rem;font-weight:700;">${fromName}</div>
          <div style="font-size:.85rem;color:#9A9590;margin-top:.3rem;">wants to connect with you</div>
        </div>
        ${btn(profileUrl, 'View Profile & Accept →')}
      `);
      await sendEmail(to, `${fromName} wants to connect with you on Encore ATL`, html);

    } else if (type === 'new_message') {
      // Someone sent you a direct message
      const { to, toName, fromName, preview, conversationUrl } = payload;
      const url = conversationUrl || `${BASE_URL}/community/community.html`;
      const html = layout(`
        <h1 style="font-size:1.4rem;font-weight:800;margin:0 0 .5rem;letter-spacing:-.02em;">New message from ${fromName}</h1>
        ${muted(`Hey ${toName}, you have a new message.`)}
        <div style="background:#1C1C1C;border:1px solid #262626;border-radius:12px;padding:1.25rem;margin-bottom:1.5rem;">
          <div style="font-size:.85rem;color:#9A9590;font-style:italic;">"${preview}"</div>
        </div>
        ${btn(url, 'Reply →')}
      `);
      await sendEmail(to, `New message from ${fromName} on Encore ATL`, html);

    } else if (type === 'new_rsvp') {
      // Someone RSVPed to your event
      const { organizerId, to: toOverride, organizerName, attendeeName, eventTitle, eventId, count } = payload;
      const to = toOverride || (organizerId ? await getUserEmail(organizerId) : null);
      if (!to) return new Response(JSON.stringify({ ok: true, skipped: 'no email' }), { headers: { 'Content-Type': 'application/json', ...CORS } });
      const orgName = organizerName || 'there';
      const eventUrl = `${BASE_URL}/events/detail.html?id=${eventId}`;
      const analyticsUrl = `${BASE_URL}/events/analytics.html?event=${eventId}`;
      const html = layout(`
        <h1 style="font-size:1.4rem;font-weight:800;margin:0 0 .5rem;letter-spacing:-.02em;">New RSVP for your event!</h1>
        ${muted(`Hey ${orgName}, someone just marked they're going to your event.`)}
        <div style="background:#1C1C1C;border:1px solid #262626;border-radius:12px;padding:1.25rem;margin-bottom:1.5rem;">
          <div style="font-size:1rem;font-weight:700;margin-bottom:.5rem;">${eventTitle}</div>
          <div style="font-size:.85rem;color:#9A9590;margin-bottom:.3rem;">🎉 <strong style="color:#F0EDE8;">${attendeeName}</strong> is going</div>
          ${count ? `<div style="font-size:.85rem;color:#9A9590;">${count} people going total</div>` : ''}
        </div>
        <div style="display:flex;gap:.75rem;flex-wrap:wrap;">
          ${btn(eventUrl, 'View Event')}
          <a href="${analyticsUrl}" style="display:inline-block;background:#1C1C1C;color:#F0EDE8;text-decoration:none;border-radius:10px;padding:.75rem 1.5rem;font-weight:700;font-size:.9rem;border:1px solid #262626;">View Analytics</a>
        </div>
      `);
      await sendEmail(to, `${attendeeName} is going to "${eventTitle}"!`, html);

    } else {
      return new Response(JSON.stringify({ error: 'Unknown notification type' }), { status: 400, headers: { 'Content-Type': 'application/json', ...CORS } });
    }

    return new Response(JSON.stringify({ ok: true }), { headers: { 'Content-Type': 'application/json', ...CORS } });
  } catch (err) {
    return new Response(JSON.stringify({ error: String(err) }), { status: 500, headers: { 'Content-Type': 'application/json', ...CORS } });
  }
});
