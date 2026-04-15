
//  auth.test.js
//  Tests for user authentication and profile management
//  Run with: npx jest auth.test.js


// Mock Supabase client so tests run without a live database
const mockUser = {
  id: 'abc123-uuid-test',
  email: 'testuser@email.com',
  user_metadata: { first_name: 'Test', last_name: 'User', user_name: 'testuser' }
};

const mockSession = { user: mockUser, access_token: 'mock-token' };

const mockProfile = {
  id: 'abc123-uuid-test',
  first_name: 'Test',
  last_name: 'User',
  user_name: 'testuser',
  bio: 'Exploring the best events Atlanta has to offer!',
  location: 'Atlanta, GA',
  avatar_url: null,
  is_public: true,
  show_attending: true,
  show_connections: true,
  email_recommendations: true,
  notify_connections: false,
};

// ── Utility functions extracted from the app ─────────────────
// These are the functions your frontend would call.
// Place these in a shared auth.js module in your project.

function validateSignUpForm(firstName, lastName, userName, email, password) {
  const errors = [];
  if (!firstName || firstName.trim().length < 2)
    errors.push('First name must be at least 2 characters.');
  if (!lastName || lastName.trim().length < 2)
    errors.push('Last name must be at least 2 characters.');
  if (!userName || userName.trim().length < 3)
    errors.push('Username must be at least 3 characters.');
  if (!/^[a-zA-Z0-9_]+$/.test(userName))
    errors.push('Username can only contain letters, numbers, and underscores.');
  if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email))
    errors.push('A valid email address is required.');
  if (!password || password.length < 8)
    errors.push('Password must be at least 8 characters.');
  return errors;
}

function validateLoginForm(email, password) {
  const errors = [];
  if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email))
    errors.push('A valid email address is required.');
  if (!password || password.trim().length === 0)
    errors.push('Password is required.');
  return errors;
}

function buildProfileUpdatePayload(formData) {
  return {
    first_name:           (formData.firstName   || '').trim(),
    last_name:            (formData.lastName    || '').trim(),
    bio:                  (formData.bio         || '').trim(),
    location:             (formData.location    || '').trim(),
    website_url:          (formData.websiteUrl  || '').trim() || null,
    instagram_url:        (formData.instagram   || '').trim() || null,
    twitter_url:          (formData.twitter     || '').trim() || null,
    tiktok_url:           (formData.tiktok      || '').trim() || null,
    is_public:            Boolean(formData.isPublic),
    show_attending:       Boolean(formData.showAttending),
    show_connections:     Boolean(formData.showConnections),
    email_recommendations:Boolean(formData.emailRecommendations),
    notify_connections:   Boolean(formData.notifyConnections),
    updated_at:           new Date().toISOString(),
  };
}

function getDisplayName(profile) {
  if (!profile) return 'Unknown User';
  return `${profile.first_name} ${profile.last_name}`.trim() || profile.user_name;
}

function getInitials(profile) {
  if (!profile) return '?';
  const first = (profile.first_name || '')[0] || '';
  const last  = (profile.last_name  || '')[0] || '';
  return (first + last).toUpperCase() || (profile.user_name || '?')[0].toUpperCase();
}

function isProfileComplete(profile) {
  return Boolean(
    profile &&
    profile.first_name &&
    profile.last_name &&
    profile.user_name &&
    profile.location &&
    profile.bio
  );
}



//  TEST SUITES


describe('Sign-Up Form Validation', () => {

  test('returns no errors for valid sign-up data', () => {
    const errors = validateSignUpForm('Jane', 'Doe', 'janedoe', 'jane@email.com', 'Password1!');
    expect(errors).toHaveLength(0);
  });

  test('rejects first name shorter than 2 characters', () => {
    const errors = validateSignUpForm('J', 'Doe', 'jdoe', 'j@email.com', 'Password1!');
    expect(errors).toContain('First name must be at least 2 characters.');
  });

  test('rejects username with special characters', () => {
    const errors = validateSignUpForm('Jane', 'Doe', 'jane-doe!', 'jane@email.com', 'Password1!');
    expect(errors).toContain('Username can only contain letters, numbers, and underscores.');
  });

  test('rejects username shorter than 3 characters', () => {
    const errors = validateSignUpForm('Jane', 'Doe', 'jd', 'jane@email.com', 'Password1!');
    expect(errors).toContain('Username must be at least 3 characters.');
  });

  test('rejects invalid email format', () => {
    const errors = validateSignUpForm('Jane', 'Doe', 'janedoe', 'not-an-email', 'Password1!');
    expect(errors).toContain('A valid email address is required.');
  });

  test('rejects password shorter than 8 characters', () => {
    const errors = validateSignUpForm('Jane', 'Doe', 'janedoe', 'jane@email.com', 'pass');
    expect(errors).toContain('Password must be at least 8 characters.');
  });

  test('returns multiple errors when multiple fields are invalid', () => {
    const errors = validateSignUpForm('', '', '', 'bad', '123');
    expect(errors.length).toBeGreaterThan(1);
  });

  test('allows underscores in username', () => {
    const errors = validateSignUpForm('Jane', 'Doe', 'jane_doe_99', 'jane@email.com', 'Password1!');
    expect(errors).toHaveLength(0);
  });

});


describe('Login Form Validation', () => {

  test('returns no errors for valid login credentials', () => {
    const errors = validateLoginForm('jane@email.com', 'mypassword');
    expect(errors).toHaveLength(0);
  });

  test('rejects missing email', () => {
    const errors = validateLoginForm('', 'mypassword');
    expect(errors).toContain('A valid email address is required.');
  });

  test('rejects invalid email format', () => {
    const errors = validateLoginForm('notanemail', 'mypassword');
    expect(errors).toContain('A valid email address is required.');
  });

  test('rejects missing password', () => {
    const errors = validateLoginForm('jane@email.com', '');
    expect(errors).toContain('Password is required.');
  });

  test('rejects whitespace-only password', () => {
    const errors = validateLoginForm('jane@email.com', '   ');
    expect(errors).toContain('Password is required.');
  });

});


describe('Profile Update Payload Builder', () => {

  test('trims whitespace from all string fields', () => {
    const payload = buildProfileUpdatePayload({
      firstName: '  Jane  ', lastName: '  Doe  ', bio: '  ATL fan  ', location: '  Atlanta, GA  '
    });
    expect(payload.first_name).toBe('Jane');
    expect(payload.last_name).toBe('Doe');
    expect(payload.bio).toBe('ATL fan');
    expect(payload.location).toBe('Atlanta, GA');
  });

  test('converts empty optional URLs to null', () => {
    const payload = buildProfileUpdatePayload({ firstName: 'Jane', lastName: 'Doe', websiteUrl: '' });
    expect(payload.website_url).toBeNull();
    expect(payload.instagram_url).toBeNull();
  });

  test('preserves non-empty optional URLs', () => {
    const payload = buildProfileUpdatePayload({
      firstName: 'Jane', lastName: 'Doe', instagram: '@janedoe'
    });
    expect(payload.instagram_url).toBe('@janedoe');
  });

  test('boolean privacy flags default to false when omitted', () => {
    const payload = buildProfileUpdatePayload({ firstName: 'Jane', lastName: 'Doe' });
    expect(payload.is_public).toBe(false);
    expect(payload.show_attending).toBe(false);
  });

  test('boolean privacy flags set correctly when true', () => {
    const payload = buildProfileUpdatePayload({
      firstName: 'Jane', lastName: 'Doe',
      isPublic: true, showAttending: true, showConnections: true
    });
    expect(payload.is_public).toBe(true);
    expect(payload.show_attending).toBe(true);
    expect(payload.show_connections).toBe(true);
  });

  test('includes updated_at timestamp', () => {
    const payload = buildProfileUpdatePayload({ firstName: 'Jane', lastName: 'Doe' });
    expect(payload.updated_at).toBeDefined();
    expect(new Date(payload.updated_at).toString()).not.toBe('Invalid Date');
  });

});


describe('Profile Display Helpers', () => {

  test('getDisplayName returns full name when available', () => {
    expect(getDisplayName(mockProfile)).toBe('Test User');
  });

  test('getDisplayName falls back to username when name is empty', () => {
    const profile = { ...mockProfile, first_name: '', last_name: '', user_name: 'testuser' };
    expect(getDisplayName(profile)).toBe('testuser');
  });

  test('getDisplayName returns Unknown User for null profile', () => {
    expect(getDisplayName(null)).toBe('Unknown User');
  });

  test('getInitials returns correct uppercase initials', () => {
    expect(getInitials(mockProfile)).toBe('TU');
  });

  test('getInitials uses username initial when name is missing', () => {
    const profile = { ...mockProfile, first_name: '', last_name: '', user_name: 'janedoe' };
    expect(getInitials(profile)).toBe('J');
  });

  test('getInitials returns ? for null profile', () => {
    expect(getInitials(null)).toBe('?');
  });

  test('isProfileComplete returns true for fully filled profile', () => {
    expect(isProfileComplete(mockProfile)).toBe(true);
  });

  test('isProfileComplete returns false when location is missing', () => {
    const profile = { ...mockProfile, location: null };
    expect(isProfileComplete(profile)).toBe(false);
  });

  test('isProfileComplete returns false when bio is missing', () => {
    const profile = { ...mockProfile, bio: '' };
    expect(isProfileComplete(profile)).toBe(false);
  });

  test('isProfileComplete returns false for null', () => {
    expect(isProfileComplete(null)).toBe(false);
  });

});
