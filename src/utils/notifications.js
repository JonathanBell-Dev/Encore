/**
 * notifications.js — notification bell for all authenticated pages
 *
 * Usage (call after Supabase client and currentUser are known):
 *   mountNotifBell(sb, currentUser.id);
 *
 * Injects a bell icon before #nav-auth-actions in any nav. Shows badge
 * count of unread messages + pending connection requests. Dropdown lists
 * each item with a link to the relevant page.
 */

const REFRESH_MS = 60_000;

window.mountNotifBell = async function mountNotifBell(sb, userId) {
  if (!userId) return;
  if (document.getElementById('notif-bell-wrap')) return; // already mounted

  injectStyles();

  const wrap = document.createElement('div');
  wrap.id = 'notif-bell-wrap';
  wrap.className = 'notif-bell-wrap';
  wrap.innerHTML = `
    <button class="notif-bell-btn" id="notif-bell-btn" aria-label="Notifications">
      <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/>
        <path d="M13.73 21a2 2 0 0 1-3.46 0"/>
      </svg>
      <span class="notif-badge" id="notif-badge" style="display:none">0</span>
    </button>
    <div class="notif-dropdown" id="notif-dropdown">
      <div class="notif-dropdown-header">Notifications</div>
      <div class="notif-list" id="notif-list">
        <div class="notif-empty">Loading…</div>
      </div>
    </div>
  `;

  // Inject into the appropriate nav container
  const authActions = document.getElementById('nav-auth-actions');
  const navLogout   = document.getElementById('nav-logout');
  if (authActions?.parentNode) {
    authActions.parentNode.insertBefore(wrap, authActions);
  } else if (navLogout?.parentNode) {
    navLogout.parentNode.insertBefore(wrap, navLogout);
  } else {
    const nav = document.querySelector('nav.site-nav, nav, header');
    if (nav) nav.appendChild(wrap);
    else return;
  }

  document.getElementById('notif-bell-btn').addEventListener('click', e => {
    e.stopPropagation();
    document.getElementById('notif-dropdown').classList.toggle('open');
  });
  document.addEventListener('click', () => {
    document.getElementById('notif-dropdown')?.classList.remove('open');
  });

  await refreshBell(sb, userId);
  setInterval(() => refreshBell(sb, userId), REFRESH_MS);
};

async function refreshBell(sb, userId) {
  const [msgResult, connResult] = await Promise.all([
    sb.from('messages')
      .select('id', { count: 'exact', head: true })
      .eq('recipient_id', userId)
      .is('read_at', null),
    sb.from('connections')
      .select('id, requester_id, accounts!connections_requester_id_fkey(first_name,last_name,user_name,avatar_url)')
      .eq('addressee_id', userId)
      .eq('status', 'pending')
  ]);

  const unreadMsgs   = msgResult.count  || 0;
  const pendingConns = connResult.data   || [];
  const total        = unreadMsgs + pendingConns.length;

  const badge = document.getElementById('notif-badge');
  if (badge) {
    badge.textContent    = total > 99 ? '99+' : String(total);
    badge.style.display  = total > 0 ? 'flex' : 'none';
  }

  const list = document.getElementById('notif-list');
  if (!list) return;

  const depth  = window.location.pathname.split('/').filter(Boolean).length;
  const prefix = depth <= 1 ? './' : '../'.repeat(depth - 1);

  const items = [];

  pendingConns.forEach(c => {
    const acc  = c.accounts || {};
    const name = [acc.first_name, acc.last_name].filter(Boolean).join(' ') || acc.user_name || 'Someone';
    const init = name.split(' ').map(w => w[0]).join('').toUpperCase().slice(0, 2);
    const color = '#e8470a';
    items.push(`
      <a class="notif-item" href="${prefix}profile/connections.html">
        <div class="notif-av" style="background:${color}">${escH(init)}</div>
        <div class="notif-body">
          <span class="notif-name">${escH(name)}</span> wants to connect
          <div class="notif-time">Tap to view &amp; accept</div>
        </div>
      </a>`);
  });

  if (unreadMsgs > 0) {
    items.push(`
      <a class="notif-item" href="${prefix}profile/messages.html">
        <div class="notif-av" style="background:#4A90E2">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
            <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
          </svg>
        </div>
        <div class="notif-body">
          <span class="notif-name">${unreadMsgs} unread message${unreadMsgs > 1 ? 's' : ''}</span>
          <div class="notif-time">Tap to open messages</div>
        </div>
      </a>`);
  }

  list.innerHTML = items.length
    ? items.join('')
    : '<div class="notif-empty">You\'re all caught up ✓</div>';

  // Push subscribe prompt (only if not already subscribed)
  if ('PushManager' in window && Notification.permission === 'default') {
    const dropdown = document.getElementById('notif-dropdown');
    if (dropdown && !dropdown.querySelector('.notif-push-btn')) {
      const btn = document.createElement('button');
      btn.className = 'notif-push-btn';
      btn.textContent = '🔔 Enable push notifications';
      btn.onclick = async (e) => {
        e.stopPropagation();
        btn.textContent = 'Enabling…';
        await window.subscribePush(sb, userId);
        btn.remove();
      };
      dropdown.appendChild(btn);
    }
  }
}

function escH(s) {
  return String(s || '').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}

function injectStyles() {
  if (document.getElementById('notif-bell-css')) return;
  const s = document.createElement('style');
  s.id = 'notif-bell-css';
  s.textContent = `
    .notif-bell-wrap { position: relative; display: flex; align-items: center; }
    .nav-links .notif-bell-wrap { flex-direction: row; gap: 0; }
    .notif-bell-btn {
      position: relative; width: 36px; height: 36px;
      border-radius: 9px; border: 1.5px solid #262626;
      background: #141414; color: #9A9590;
      display: flex; align-items: center; justify-content: center;
      cursor: pointer; transition: border-color .18s, color .18s;
      flex-shrink: 0;
    }
    .notif-bell-btn:hover { border-color: #e8470a; color: #e8470a; }
    .notif-badge {
      position: absolute; top: -5px; right: -5px;
      min-width: 17px; height: 17px;
      background: #e8470a; color: #fff;
      font-size: .6rem; font-weight: 700;
      border-radius: 999px;
      display: flex; align-items: center; justify-content: center;
      padding: 0 3px; font-family: 'Inter', sans-serif;
      border: 2px solid #0C0C0C; pointer-events: none;
    }
    .notif-dropdown {
      display: none; position: absolute;
      top: calc(100% + 10px); right: 0;
      width: 300px; background: #141414;
      border: 1px solid #262626; border-radius: 12px;
      box-shadow: 0 8px 32px rgba(0,0,0,.6);
      z-index: 1000; overflow: hidden;
    }
    .notif-dropdown.open { display: block; }
    .notif-dropdown-header {
      padding: .65rem 1rem;
      font-size: .72rem; font-weight: 700;
      text-transform: uppercase; letter-spacing: .07em;
      color: #9A9590; border-bottom: 1px solid #262626;
      font-family: 'Inter', sans-serif;
    }
    .notif-list { max-height: 320px; overflow-y: auto; }
    .notif-item {
      display: flex; align-items: center; gap: .75rem;
      padding: .85rem 1rem; text-decoration: none; color: #F0EDE8;
      transition: background .15s; border-bottom: 1px solid #1a1a1a;
      font-family: 'Inter', sans-serif; font-size: .84rem; line-height: 1.45;
    }
    .notif-item:hover { background: #1C1C1C; }
    .notif-item:last-child { border-bottom: none; }
    .notif-av {
      width: 36px; height: 36px; border-radius: 50%;
      display: flex; align-items: center; justify-content: center;
      font-size: .78rem; font-weight: 700; color: #fff; flex-shrink: 0;
    }
    .notif-body { flex: 1; min-width: 0; }
    .notif-name { font-weight: 600; }
    .notif-time { font-size: .72rem; color: #9A9590; margin-top: .15rem; }
    .notif-empty {
      padding: 1.5rem 1rem; text-align: center;
      font-size: .85rem; color: #9A9590; font-family: 'Inter', sans-serif;
    }
    .notif-push-btn {
      display: block; width: calc(100% - 2rem); margin: .75rem 1rem;
      background: rgba(232,71,10,.12); border: 1px solid rgba(232,71,10,.3);
      border-radius: 8px; padding: .55rem .9rem; color: #e8470a;
      font-size: .8rem; font-weight: 700; cursor: pointer; font-family: 'Inter', sans-serif;
      text-align: left;
    }
    .notif-push-btn:hover { background: rgba(232,71,10,.2); }
  `;
  document.head.appendChild(s);
}

// ── Push subscription ─────────────────────────────────────────────────────
const VAPID_PUBLIC = 'BPjzFeudnl6Oan0EZJyY3bV2XmfnhoPc7x6xErRvuUYjAZqYyuiz6QOMGyfggXC-C8ACC39tSwbByyGc1AW8D6I';

window.subscribePush = async function subscribePush(sb, userId) {
  if (!('serviceWorker' in navigator) || !('PushManager' in window)) return;
  const perm = await Notification.requestPermission();
  if (perm !== 'granted') return;
  try {
    const reg = await navigator.serviceWorker.ready;
    const existing = await reg.pushManager.getSubscription();
    const sub = existing || await reg.pushManager.subscribe({
      userVisibleOnly: true,
      applicationServerKey: urlBase64ToUint8Array(VAPID_PUBLIC),
    });
    const j = sub.toJSON();
    await sb.from('push_subscriptions').upsert({
      account_id: userId,
      endpoint: j.endpoint,
      p256dh: j.keys.p256dh,
      auth: j.keys.auth,
    }, { onConflict: 'account_id,endpoint' });
  } catch (_) {}
};

function urlBase64ToUint8Array(base64String) {
  const padding = '='.repeat((4 - base64String.length % 4) % 4);
  const base64 = (base64String + padding).replace(/-/g, '+').replace(/_/g, '/');
  const raw = atob(base64);
  return Uint8Array.from([...raw].map(c => c.charCodeAt(0)));
}
