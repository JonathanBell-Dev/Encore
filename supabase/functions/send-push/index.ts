import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

// VAPID keys — replace VAPID_PRIVATE_KEY secret via: supabase secrets set VAPID_PRIVATE_KEY=...
const VAPID_PUBLIC  = 'BPjzFeudnl6Oan0EZJyY3bV2XmfnhoPc7x6xErRvuUYjAZqYyuiz6QOMGyfggXC-C8ACC39tSwbByyGc1AW8D6I';
const VAPID_PRIVATE = Deno.env.get('VAPID_PRIVATE_KEY') ?? '';
const VAPID_SUBJECT = 'mailto:admin@encore-atl.com';

const SUPABASE_URL  = Deno.env.get('SUPABASE_URL') ?? '';
const SUPABASE_KEY  = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '';

interface PushPayload {
  userId: string;
  title: string;
  body: string;
  url?: string;
}

// Simple Web Push implementation using the Web Crypto API
async function sendWebPush(subscription: { endpoint: string; p256dh: string; auth: string }, payload: string) {
  // Build minimal VAPID JWT header + payload
  const audience = new URL(subscription.endpoint).origin;
  const now = Math.floor(Date.now() / 1000);
  const jwtHeader = btoa(JSON.stringify({ typ: 'JWT', alg: 'ES256' })).replace(/=/g,'').replace(/\+/g,'-').replace(/\//g,'_');
  const jwtPayload = btoa(JSON.stringify({ aud: audience, exp: now + 86400, sub: VAPID_SUBJECT })).replace(/=/g,'').replace(/\+/g,'-').replace(/\//g,'_');
  const sigInput = `${jwtHeader}.${jwtPayload}`;

  // Import private key
  const privKeyBytes = Uint8Array.from(atob(VAPID_PRIVATE.replace(/-/g,'+').replace(/_/g,'/')), c => c.charCodeAt(0));
  const privateKey = await crypto.subtle.importKey('pkcs8', privKeyBytes, { name: 'ECDSA', namedCurve: 'P-256' }, false, ['sign']);
  const sig = await crypto.subtle.sign({ name: 'ECDSA', hash: 'SHA-256' }, privateKey, new TextEncoder().encode(sigInput));
  const jwt = `${sigInput}.${btoa(String.fromCharCode(...new Uint8Array(sig))).replace(/=/g,'').replace(/\+/g,'-').replace(/\//g,'_')}`;

  const res = await fetch(subscription.endpoint, {
    method: 'POST',
    headers: {
      'Authorization': `vapid t=${jwt},k=${VAPID_PUBLIC}`,
      'Content-Type': 'application/octet-stream',
      'Content-Encoding': 'aes128gcm',
      'TTL': '86400',
    },
    body: new TextEncoder().encode(payload),
  });
  return res.status;
}

serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response(null, { headers: { 'Access-Control-Allow-Origin': '*', 'Access-Control-Allow-Headers': 'authorization,content-type' } });

  const { userId, title, body, url } = await req.json() as PushPayload;
  const sb = createClient(SUPABASE_URL, SUPABASE_KEY);

  const { data: subs } = await sb.from('push_subscriptions').select('endpoint,p256dh,auth').eq('account_id', userId);
  if (!subs?.length) return new Response(JSON.stringify({ sent: 0 }), { headers: { 'Content-Type': 'application/json' } });

  const message = JSON.stringify({ title, body, url: url || '/' });
  let sent = 0;
  for (const sub of subs) {
    try {
      const status = await sendWebPush(sub, message);
      if (status === 201 || status === 200) sent++;
      if (status === 410 || status === 404) {
        await sb.from('push_subscriptions').delete().eq('endpoint', sub.endpoint);
      }
    } catch (_) { /* ignore */ }
  }

  return new Response(JSON.stringify({ sent }), { headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' } });
});
