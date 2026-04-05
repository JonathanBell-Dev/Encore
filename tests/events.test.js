
//  events.test.js
//  Tests for events, connections, and interest filtering logic
//  Run with: npx jest events.test.js



// ── Utility functions extracted from the app ─────────────────

function formatEventPrice(price) {
  if (price === null || price === undefined) return 'Free';
  const num = parseFloat(price);
  if (isNaN(num) || num <= 0) return 'Free';
  return `$${num.toFixed(2)}`;
}

function formatEventDate(isoString) {
  if (!isoString) return '';
  const date = new Date(isoString);
  if (isNaN(date.getTime())) return 'Invalid date';
  return date.toLocaleDateString('en-US', {
    weekday: 'short', month: 'short', day: 'numeric',
    hour: 'numeric', minute: '2-digit', hour12: true
  });
}

function isEventUpcoming(startsAt) {
  if (!startsAt) return false;
  return new Date(startsAt) > new Date();
}

function isEventPast(startsAt) {
  if (!startsAt) return false;
  return new Date(startsAt) < new Date();
}

function filterEventsByCategory(events, category) {
  if (!category || category === 'All Events') return events;
  return events.filter(e => e.category === category);
}

function filterEventsByVibe(events, vibe) {
  if (!vibe || vibe === 'All Events') return events;
  return events.filter(e => Array.isArray(e.vibe_tags) && e.vibe_tags.includes(vibe));
}

function sortEventsByDate(events) {
  return [...events].sort((a, b) => new Date(a.starts_at) - new Date(b.starts_at));
}

function searchEvents(events, query) {
  if (!query || query.trim() === '') return events;
  const q = query.toLowerCase();
  return events.filter(e =>
    (e.title        || '').toLowerCase().includes(q) ||
    (e.venue_name   || '').toLowerCase().includes(q) ||
    (e.description  || '').toLowerCase().includes(q) ||
    (e.category     || '').toLowerCase().includes(q)
  );
}

function buildEventAttendanceToggle(currentStatus) {
  if (currentStatus === 'going')      return null;           // remove attendance
  if (currentStatus === 'interested') return 'going';
  return 'going';
}

function getAttendeeCountLabel(count) {
  if (!count || count === 0) return 'Be the first to go!';
  if (count === 1) return '1 attending';
  return `${count} attending`;
}

// ── Connections helpers ──────────────────────────────────────

function getConnectionStatus(connections, myId, theirId) {
  const conn = connections.find(c =>
    (c.requester_id === myId && c.addressee_id === theirId) ||
    (c.requester_id === theirId && c.addressee_id === myId)
  );
  if (!conn) return 'none';
  return conn.status;
}

function canSendMessage(connections, myId, theirId) {
  return getConnectionStatus(connections, myId, theirId) === 'accepted';
}

function getPendingRequests(connections, myId) {
  return connections.filter(c => c.addressee_id === myId && c.status === 'pending');
}

function getAcceptedConnections(connections, userId) {
  return connections.filter(c =>
    (c.requester_id === userId || c.addressee_id === userId) &&
    c.status === 'accepted'
  );
}

// ── Interest helpers ─────────────────────────────────────────

function buildInterestChipState(allInterests, selectedIds) {
  return allInterests.map(interest => ({
    ...interest,
    selected: selectedIds.includes(interest.id)
  }));
}

function getSelectedInterestNames(chips) {
  return chips.filter(c => c.selected).map(c => c.name);
}


// ── Sample data ──────────────────────────────────────────────

const sampleEvents = [
  {
    id: 'evt-1', title: 'ATL Jazz in the Park', category: 'Music',
    vibe_tags: ['Chill', 'Live Music'], venue_name: 'Grant Park',
    starts_at: '2026-06-17T18:30:00Z', ticket_price: 0, description: 'Free jazz night'
  },
  {
    id: 'evt-2', title: 'ONE Musicfest', category: 'Music',
    vibe_tags: ['High Energy', 'Live Music'], venue_name: 'Piedmont Park',
    starts_at: '2026-06-15T16:00:00Z', ticket_price: 89, description: 'Hip-hop festival'
  },
  {
    id: 'evt-3', title: 'Buckhead Brunch Fest', category: 'Food & Drink',
    vibe_tags: ['Chill', 'Date Night'], venue_name: 'Lenox Square',
    starts_at: '2026-06-24T11:00:00Z', ticket_price: 35, description: 'Brunch festival'
  },
  {
    id: 'evt-4', title: 'Hawks vs. Celtics', category: 'Sports',
    vibe_tags: ['High Energy', 'With the Crew'], venue_name: 'State Farm Arena',
    starts_at: '2025-01-01T00:00:00Z', ticket_price: 42, description: 'NBA game'  // past
  },
];

const sampleConnections = [
  { id: 'c1', requester_id: 'user-1', addressee_id: 'user-2', status: 'accepted' },
  { id: 'c2', requester_id: 'user-3', addressee_id: 'user-1', status: 'pending'  },
  { id: 'c3', requester_id: 'user-1', addressee_id: 'user-4', status: 'declined' },
  { id: 'c4', requester_id: 'user-5', addressee_id: 'user-1', status: 'pending'  },
];

const sampleInterests = [
  { id: 1, name: 'Music' },
  { id: 2, name: 'Food & Drink' },
  { id: 3, name: 'Arts & Culture' },
  { id: 4, name: 'Sports' },
  { id: 5, name: 'Comedy' },
];



//  TEST SUITES


describe('Event Price Formatting', () => {

  test('returns Free for price of 0', () => {
    expect(formatEventPrice(0)).toBe('Free');
  });

  test('returns Free for null price', () => {
    expect(formatEventPrice(null)).toBe('Free');
  });

  test('returns Free for undefined price', () => {
    expect(formatEventPrice(undefined)).toBe('Free');
  });

  test('formats integer price correctly', () => {
    expect(formatEventPrice(45)).toBe('$45.00');
  });

  test('formats decimal price correctly', () => {
    expect(formatEventPrice(89.99)).toBe('$89.99');
  });

  test('formats string price correctly', () => {
    expect(formatEventPrice('35')).toBe('$35.00');
  });

  test('returns Free for negative price', () => {
    expect(formatEventPrice(-5)).toBe('Free');
  });

});


describe('Event Date Formatting', () => {

  test('returns empty string for null date', () => {
    expect(formatEventDate(null)).toBe('');
  });

  test('returns Invalid date for bad string', () => {
    expect(formatEventDate('not-a-date')).toBe('Invalid date');
  });

  test('returns formatted string for valid ISO date', () => {
    const result = formatEventDate('2026-06-14T18:00:00Z');
    expect(typeof result).toBe('string');
    expect(result.length).toBeGreaterThan(0);
  });

});


describe('Event Upcoming / Past Detection', () => {

  test('correctly identifies a future event as upcoming', () => {
    expect(isEventUpcoming('2099-01-01T00:00:00Z')).toBe(true);
  });

  test('correctly identifies a past event as not upcoming', () => {
    expect(isEventUpcoming('2020-01-01T00:00:00Z')).toBe(false);
  });

  test('correctly identifies a past event as past', () => {
    expect(isEventPast('2020-01-01T00:00:00Z')).toBe(true);
  });

  test('correctly identifies a future event as not past', () => {
    expect(isEventPast('2099-01-01T00:00:00Z')).toBe(false);
  });

  test('returns false for null starts_at', () => {
    expect(isEventUpcoming(null)).toBe(false);
    expect(isEventPast(null)).toBe(false);
  });

});


describe('Event Filtering and Search', () => {

  test('filterEventsByCategory returns all events for "All Events"', () => {
    expect(filterEventsByCategory(sampleEvents, 'All Events')).toHaveLength(4);
  });

  test('filterEventsByCategory returns only Music events', () => {
    const result = filterEventsByCategory(sampleEvents, 'Music');
    expect(result).toHaveLength(2);
    expect(result.every(e => e.category === 'Music')).toBe(true);
  });

  test('filterEventsByCategory returns empty for unknown category', () => {
    expect(filterEventsByCategory(sampleEvents, 'Theater')).toHaveLength(0);
  });

  test('filterEventsByVibe returns events matching vibe tag', () => {
    const result = filterEventsByVibe(sampleEvents, 'Chill');
    expect(result).toHaveLength(2);
  });

  test('filterEventsByVibe returns all events for "All Events"', () => {
    expect(filterEventsByVibe(sampleEvents, 'All Events')).toHaveLength(4);
  });

  test('searchEvents matches by title (case-insensitive)', () => {
    const result = searchEvents(sampleEvents, 'jazz');
    expect(result).toHaveLength(1);
    expect(result[0].title).toBe('ATL Jazz in the Park');
  });

  test('searchEvents matches by venue name', () => {
    const result = searchEvents(sampleEvents, 'piedmont');
    expect(result).toHaveLength(1);
    expect(result[0].title).toBe('ONE Musicfest');
  });

  test('searchEvents returns all events for empty query', () => {
    expect(searchEvents(sampleEvents, '')).toHaveLength(4);
  });

  test('searchEvents returns empty array when nothing matches', () => {
    expect(searchEvents(sampleEvents, 'zzznomatch')).toHaveLength(0);
  });

  test('sortEventsByDate returns events in chronological order', () => {
    const sorted = sortEventsByDate(sampleEvents);
    for (let i = 1; i < sorted.length; i++) {
      expect(new Date(sorted[i].starts_at).getTime()).toBeGreaterThanOrEqual(new Date(sorted[i - 1].starts_at).getTime());
    }
  });

  test('sortEventsByDate does not mutate the original array', () => {
    const original = [...sampleEvents];
    sortEventsByDate(sampleEvents);
    expect(sampleEvents[0].id).toBe(original[0].id);
  });

});


describe('Event Attendance', () => {

  test('going → toggle removes attendance (returns null)', () => {
    expect(buildEventAttendanceToggle('going')).toBeNull();
  });

  test('interested → toggle upgrades to going', () => {
    expect(buildEventAttendanceToggle('interested')).toBe('going');
  });

  test('none → toggle sets to going', () => {
    expect(buildEventAttendanceToggle(null)).toBe('going');
  });

  test('getAttendeeCountLabel shows correct label for 0', () => {
    expect(getAttendeeCountLabel(0)).toBe('Be the first to go!');
  });

  test('getAttendeeCountLabel shows "1 attending" for 1', () => {
    expect(getAttendeeCountLabel(1)).toBe('1 attending');
  });

  test('getAttendeeCountLabel shows plural for many', () => {
    expect(getAttendeeCountLabel(430)).toBe('430 attending');
  });

});


describe('Connections', () => {

  test('getConnectionStatus returns accepted for connected users', () => {
    expect(getConnectionStatus(sampleConnections, 'user-1', 'user-2')).toBe('accepted');
  });

  test('getConnectionStatus works regardless of who sent the request', () => {
    // user-3 sent to user-1, checking from user-1 perspective
    expect(getConnectionStatus(sampleConnections, 'user-1', 'user-3')).toBe('pending');
  });

  test('getConnectionStatus returns none for unconnected users', () => {
    expect(getConnectionStatus(sampleConnections, 'user-1', 'user-99')).toBe('none');
  });

  test('canSendMessage returns true only for accepted connections', () => {
    expect(canSendMessage(sampleConnections, 'user-1', 'user-2')).toBe(true);
  });

  test('canSendMessage returns false for pending connection', () => {
    expect(canSendMessage(sampleConnections, 'user-1', 'user-3')).toBe(false);
  });

  test('canSendMessage returns false for no connection', () => {
    expect(canSendMessage(sampleConnections, 'user-1', 'user-99')).toBe(false);
  });

  test('getPendingRequests returns only pending requests addressed to user', () => {
    const pending = getPendingRequests(sampleConnections, 'user-1');
    expect(pending).toHaveLength(2);
    expect(pending.every(c => c.status === 'pending')).toBe(true);
  });

  test('getAcceptedConnections returns only accepted connections for a user', () => {
    const accepted = getAcceptedConnections(sampleConnections, 'user-1');
    expect(accepted).toHaveLength(1);
    expect(accepted[0].status).toBe('accepted');
  });

});


describe('Interests / Profile Chips', () => {

  test('buildInterestChipState marks selected interests correctly', () => {
    const chips = buildInterestChipState(sampleInterests, [1, 3]);
    expect(chips.find(c => c.id === 1).selected).toBe(true);
    expect(chips.find(c => c.id === 3).selected).toBe(true);
    expect(chips.find(c => c.id === 2).selected).toBe(false);
  });

  test('buildInterestChipState marks all as unselected when none selected', () => {
    const chips = buildInterestChipState(sampleInterests, []);
    expect(chips.every(c => !c.selected)).toBe(true);
  });

  test('getSelectedInterestNames returns correct names', () => {
    const chips = buildInterestChipState(sampleInterests, [1, 2]);
    const names = getSelectedInterestNames(chips);
    expect(names).toContain('Music');
    expect(names).toContain('Food & Drink');
    expect(names).not.toContain('Sports');
  });

  test('getSelectedInterestNames returns empty array when none selected', () => {
    const chips = buildInterestChipState(sampleInterests, []);
    expect(getSelectedInterestNames(chips)).toHaveLength(0);
  });

});