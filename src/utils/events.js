/**
 * events.js — shared event, connection, and interest utilities
 * Import via ES module in any page:
 *   import { formatEventPrice, searchEvents } from '../../src/utils/events.js';
 */

// ── Event formatting ──────────────────────────────────────────────────────────

export function formatEventPrice(price) {
  if (price === null || price === undefined) return 'Free';
  const num = parseFloat(price);
  if (isNaN(num) || num <= 0) return 'Free';
  return `$${num.toFixed(2)}`;
}

export function formatEventDate(isoString) {
  if (!isoString) return '';
  const date = new Date(isoString);
  if (isNaN(date.getTime())) return 'Invalid date';
  return date.toLocaleDateString('en-US', {
    weekday: 'short', month: 'short', day: 'numeric',
    hour: 'numeric', minute: '2-digit', hour12: true,
  });
}

export function isEventUpcoming(startsAt) {
  if (!startsAt) return false;
  return new Date(startsAt) > new Date();
}

export function isEventPast(startsAt) {
  if (!startsAt) return false;
  return new Date(startsAt) < new Date();
}

// ── Event filtering & sorting ─────────────────────────────────────────────────

export function filterEventsByCategory(events, category) {
  if (!category || category === 'All Events') return events;
  return events.filter(e => e.category === category);
}

export function filterEventsByVibe(events, vibe) {
  if (!vibe || vibe === 'All Events') return events;
  return events.filter(e => Array.isArray(e.vibe_tags) && e.vibe_tags.includes(vibe));
}

export function sortEventsByDate(events) {
  return [...events].sort((a, b) => new Date(a.starts_at) - new Date(b.starts_at));
}

export function searchEvents(events, query) {
  if (!query || query.trim() === '') return events;
  const q = query.toLowerCase();
  return events.filter(e =>
    (e.title       || '').toLowerCase().includes(q) ||
    (e.venue_name  || '').toLowerCase().includes(q) ||
    (e.description || '').toLowerCase().includes(q) ||
    (e.category    || '').toLowerCase().includes(q)
  );
}

// ── Pagination ────────────────────────────────────────────────────────────────

/**
 * Returns the range for a Supabase .range() call.
 * Usage: const { from, to } = getPageRange(page, PAGE_SIZE);
 *        supabase.from('events').select().range(from, to)
 */
export function getPageRange(page, pageSize = 12) {
  const from = page * pageSize;
  const to   = from + pageSize - 1;
  return { from, to };
}

// ── Attendance ────────────────────────────────────────────────────────────────

export function buildEventAttendanceToggle(currentStatus) {
  if (currentStatus === 'going') return null; // remove attendance
  return 'going';
}

export function getAttendeeCountLabel(count) {
  if (!count || count === 0) return 'Be the first to go!';
  if (count === 1) return '1 attending';
  return `${count} attending`;
}

// ── Connections ───────────────────────────────────────────────────────────────

export function getConnectionStatus(connections, myId, theirId) {
  const conn = connections.find(c =>
    (c.requester_id === myId && c.addressee_id === theirId) ||
    (c.requester_id === theirId && c.addressee_id === myId)
  );
  if (!conn) return 'none';
  return conn.status;
}

export function canSendMessage(connections, myId, theirId) {
  return getConnectionStatus(connections, myId, theirId) === 'accepted';
}

export function getPendingRequests(connections, myId) {
  return connections.filter(c => c.addressee_id === myId && c.status === 'pending');
}

export function getAcceptedConnections(connections, userId) {
  return connections.filter(c =>
    (c.requester_id === userId || c.addressee_id === userId) &&
    c.status === 'accepted'
  );
}

// ── Interests ─────────────────────────────────────────────────────────────────

export function buildInterestChipState(allInterests, selectedIds) {
  return allInterests.map(interest => ({
    ...interest,
    selected: selectedIds.includes(interest.id),
  }));
}

export function getSelectedInterestNames(chips) {
  return chips.filter(c => c.selected).map(c => c.name);
}
