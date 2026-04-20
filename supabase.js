/**
 * supabase.js — shared Supabase client (ES module, browser)
 *
 * Used by pages that import via ES module:
 *   import { supabase, requireAuth } from '../supabase.js';
 *
 * Configuration:
 *   - In production:  set SUPABASE_URL and SUPABASE_ANON_KEY directly below.
 *   - In local dev:   copy .env.example → .env and run through a local server
 *     that injects env vars (e.g. Vite, or the Supabase CLI dev server).
 */

import { createClient } from 'https://cdn.jsdelivr.net/npm/@supabase/supabase-js/+esm';
 
const SUPABASE_URL  = 'https://qgvoznhldglucpsaisfs.supabase.co';
const SUPABASE_ANON = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFndm96bmhsZGdsdWNwc2Fpc2ZzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzYxOTU4MjUsImV4cCI6MjA5MTc3MTgyNX0.e-5X1Lh4Tg8cP-FL-3eorV5pAZCDe4CR6i2AFeDKHWQ';

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON);

// ── Auth helpers ─────────────────────────────────────────────────────────────

export async function getSession() {
  const { data: { session } } = await supabase.auth.getSession();
  return session;
}

/**
 * Redirect unauthenticated users to the login page.
 * Pass a relative path from the current page to login.html.
 */
export async function requireAuth(redirectTo = '../login/login.html') {
  const session = await getSession();
  if (!session) {
    window.location.replace(redirectTo);
    return null;
  }
  return session;
}

export async function signOut(redirectTo = '../login/login.html') {
  await supabase.auth.signOut();
  window.location.href = redirectTo;
}
