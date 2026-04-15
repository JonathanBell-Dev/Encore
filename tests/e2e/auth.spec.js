// @ts-check
/**
 * auth.spec.js — E2E tests for authentication flows
 *
 * Prerequisites:
 *   npx playwright install
 *   (or: npm install -D @playwright/test)
 *
 * Run:
 *   npx playwright test tests/e2e/auth.spec.js
 *   npx playwright test --headed   (see the browser)
 *
 * Set BASE_URL env var to point at your local server, e.g.:
 *   BASE_URL=http://localhost:5500 npx playwright test
 */

const { test, expect } = require('@playwright/test');

const BASE_URL = process.env.BASE_URL || 'http://localhost:5500';
const LOGIN_PAGE = `${BASE_URL}/login/signup/login.html`;
const PROFILE_PAGE = `${BASE_URL}/profile/profile.html`;

// ── Login page loads ─────────────────────────────────────────────────────────
test('login page loads and shows both tabs', async ({ page }) => {
  await page.goto(LOGIN_PAGE);
  await expect(page.locator('#tab-login')).toBeVisible();
  await expect(page.locator('#tab-signup')).toBeVisible();
  await expect(page.locator('#panel-login')).toBeVisible();
  await expect(page.locator('#panel-signup')).not.toBeVisible();
});

// ── Tab switching ─────────────────────────────────────────────────────────────
test('clicking Sign Up tab shows signup form', async ({ page }) => {
  await page.goto(LOGIN_PAGE);
  await page.click('#tab-signup');
  await expect(page.locator('#panel-signup')).toBeVisible();
  await expect(page.locator('#panel-login')).not.toBeVisible();
  await expect(page.locator('#tab-signup')).toHaveClass(/active/);
});

// ── Login validation ──────────────────────────────────────────────────────────
test('login shows error when fields are empty', async ({ page }) => {
  await page.goto(LOGIN_PAGE);
  await page.click('#btn-login');
  const alert = page.locator('#alert');
  await expect(alert).toBeVisible();
  await expect(alert).toContainText(/fill in all fields/i);
});

test('login shows error for invalid email format', async ({ page }) => {
  await page.goto(LOGIN_PAGE);
  await page.fill('#login-email', 'not-an-email');
  await page.fill('#login-password', 'somepassword');
  await page.click('#btn-login');
  // Supabase will reject; we expect an error alert to appear
  const alert = page.locator('#alert');
  await expect(alert).toBeVisible({ timeout: 5000 });
});

// ── Signup validation ─────────────────────────────────────────────────────────
test('signup shows error when fields are empty', async ({ page }) => {
  await page.goto(LOGIN_PAGE);
  await page.click('#tab-signup');
  await page.click('#btn-signup');
  const alert = page.locator('#alert');
  await expect(alert).toBeVisible();
  await expect(alert).toContainText(/fill in all fields/i);
});

test('signup shows error when passwords do not match', async ({ page }) => {
  await page.goto(LOGIN_PAGE);
  await page.click('#tab-signup');
  await page.fill('#signup-first', 'Jane');
  await page.fill('#signup-last', 'Doe');
  await page.fill('#signup-username', 'janedoe');
  await page.fill('#signup-email', 'jane@example.com');
  await page.fill('#signup-password', 'Password1!');
  await page.fill('#signup-confirm', 'DifferentPass1!');
  await page.click('#btn-signup');
  const alert = page.locator('#alert');
  await expect(alert).toBeVisible();
  await expect(alert).toContainText(/do not match/i);
});

test('signup shows error when password is too short', async ({ page }) => {
  await page.goto(LOGIN_PAGE);
  await page.click('#tab-signup');
  await page.fill('#signup-first', 'Jane');
  await page.fill('#signup-last', 'Doe');
  await page.fill('#signup-username', 'janedoe');
  await page.fill('#signup-email', 'jane@example.com');
  await page.fill('#signup-password', 'short');
  await page.fill('#signup-confirm', 'short');
  await page.click('#btn-signup');
  const alert = page.locator('#alert');
  await expect(alert).toBeVisible();
  await expect(alert).toContainText(/8 characters/i);
});

// ── Protected page redirect ───────────────────────────────────────────────────
test('visiting profile page without auth redirects to login', async ({ page }) => {
  // Clear any existing session
  await page.goto(LOGIN_PAGE);
  await page.evaluate(() => {
    localStorage.clear();
    sessionStorage.clear();
  });

  await page.goto(PROFILE_PAGE);
  // Should redirect to login page
  await page.waitForURL(/login/, { timeout: 5000 });
  expect(page.url()).toContain('login');
});

// ── Forgot password ───────────────────────────────────────────────────────────
test('forgot password shows error when no email entered', async ({ page }) => {
  await page.goto(LOGIN_PAGE);
  await page.click('a.forgot-link');
  const alert = page.locator('#alert');
  await expect(alert).toBeVisible();
  await expect(alert).toContainText(/email/i);
});
