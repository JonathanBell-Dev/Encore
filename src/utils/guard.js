/**
 * guard.js — authentication guard for protected pages
 *
 * Add this as the FIRST script on any page that requires login:
 *
 *   <script type="module">
 *     import { guardPage } from '../../src/utils/guard.js';
 *     const session = await guardPage();
 *     // session is guaranteed non-null here; page logic continues below
 *   </script>
 *
 * While the session check is in flight the page shows a loading overlay
 * (defined in css/components.css as .auth-guard-loading).
 * Unauthenticated visitors are immediately redirected to the login page.
 */

const SUPABASE_URL  = 'https://qgvoznhldglucpsaisfs.supabase.co';
const SUPABASE_ANON = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFndm96bmhsZGdsdWNwc2Fpc2ZzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzYxOTU4MjUsImV4cCI6MjA5MTc3MTgyNX0.e-5X1Lh4Tg8cP-FL-3eorV5pAZCDe4CR6i2AFeDKHWQ';

// Resolve the CDN path relative to any page depth
let _sb = null;
async function getSb() {
  if (_sb) return _sb;
  // Use the globally-loaded supabase UMD bundle (loaded via <script> tag)
  // or fall back to dynamic import from CDN.
  if (window.supabase) {
    _sb = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON);
  } else {
    const { createClient } = await import('https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm');
    _sb = createClient(SUPABASE_URL, SUPABASE_ANON);
  }
  return _sb;
}

/**
 * Injects a full-screen loading overlay if one doesn't already exist.
 */
function injectOverlay() {
  if (document.getElementById('auth-guard-overlay')) return;
  const overlay = document.createElement('div');
  overlay.id = 'auth-guard-overlay';
  overlay.className = 'auth-guard-loading';
  overlay.innerHTML = `
    <div style="display:flex;flex-direction:column;align-items:center;gap:1rem;">
      <div class="spinner spinner-dark" style="display:block;width:28px;height:28px;border-width:3px;"></div>
      <p style="font-family:'Inter',sans-serif;font-size:.85rem;color:#6b6b7b;">Loading…</p>
    </div>`;
  document.body.prepend(overlay);
}

function removeOverlay() {
  const overlay = document.getElementById('auth-guard-overlay');
  if (!overlay) return;
  overlay.classList.add('hidden');
  setTimeout(() => overlay.remove(), 350);
}

/**
 * Resolves the correct login-page path relative to the current page.
 * Works for pages nested up to 3 levels deep.
 */
function loginPath() {
  const depth = window.location.pathname.split('/').filter(Boolean).length;
  const prefix = depth <= 1 ? './' : '../'.repeat(depth - 1);
  return `${prefix}login/login.html`;
}

/**
 * Guards the current page. Call at the top of any protected page's module script.
 * Returns the active Supabase session or redirects to login.
 */
export async function guardPage() {
  injectOverlay();
  const sb = await getSb();
  const { data: { session } } = await sb.auth.getSession();

  if (!session) {
    window.location.replace(loginPath());
    return null; // never reached (redirect pending), but keeps TS happy
  }

  removeOverlay();
  return session;
}

/** Shared Supabase client for pages that import guard.js */
export async function getClient() {
  return getSb();
}

/** Sign the user out and redirect to login. */
export async function signOut() {
  const sb = await getSb();
  await sb.auth.signOut();
  window.location.href = loginPath();
}
