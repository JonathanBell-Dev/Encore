/**
 * auth.js — shared authentication and profile utilities
 * Import via ES module in any page:
 *   import { validateSignUpForm, getDisplayName } from '../../src/utils/auth.js';
 */

// ── Form validation ───────────────────────────────────────────────────────────

export function validateSignUpForm(firstName, lastName, userName, email, password) {
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

export function validateLoginForm(email, password) {
  const errors = [];
  if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email))
    errors.push('A valid email address is required.');
  if (!password || password.trim().length === 0)
    errors.push('Password is required.');
  return errors;
}

// ── Profile helpers ───────────────────────────────────────────────────────────

export function getDisplayName(profile) {
  if (!profile) return 'Unknown User';
  return `${profile.first_name} ${profile.last_name}`.trim() || profile.user_name;
}

export function getInitials(profile) {
  if (!profile) return '?';
  const first = (profile.first_name || '')[0] || '';
  const last  = (profile.last_name  || '')[0] || '';
  return (first + last).toUpperCase() || (profile.user_name || '?')[0].toUpperCase();
}

export function isProfileComplete(profile) {
  return Boolean(
    profile &&
    profile.first_name &&
    profile.last_name &&
    profile.user_name &&
    profile.location &&
    profile.bio
  );
}

export function buildProfileUpdatePayload(formData) {
  return {
    first_name:            (formData.firstName  || '').trim(),
    last_name:             (formData.lastName   || '').trim(),
    bio:                   (formData.bio        || '').trim(),
    location:              (formData.location   || '').trim(),
    website_url:           (formData.websiteUrl || '').trim() || null,
    instagram_url:         (formData.instagram  || '').trim() || null,
    twitter_url:           (formData.twitter    || '').trim() || null,
    tiktok_url:            (formData.tiktok     || '').trim() || null,
    is_public:             Boolean(formData.isPublic),
    show_attending:        Boolean(formData.showAttending),
    show_connections:      Boolean(formData.showConnections),
    email_recommendations: Boolean(formData.emailRecommendations),
    notify_connections:    Boolean(formData.notifyConnections),
    updated_at:            new Date().toISOString(),
  };
}
