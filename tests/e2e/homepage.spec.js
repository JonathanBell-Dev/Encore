// @ts-check
/**
 * homepage.spec.js — E2E tests for the public homepage / event discovery
 *
 * Run: npx playwright test tests/e2e/homepage.spec.js
 */

const { test, expect } = require('@playwright/test');

const BASE_URL   = process.env.BASE_URL || 'http://localhost:5500';
const HOME_PAGE  = `${BASE_URL}/homepage/home_page.html`;

// ── Page loads ────────────────────────────────────────────────────────────────
test('homepage loads and shows hero section', async ({ page }) => {
  await page.goto(HOME_PAGE);
  await expect(page.locator('.hero-title')).toBeVisible();
  await expect(page.locator('.hero-title')).toContainText('ATL');
});

test('homepage shows navigation', async ({ page }) => {
  await page.goto(HOME_PAGE);
  await expect(page.locator('nav')).toBeVisible();
});

test('homepage shows events section', async ({ page }) => {
  await page.goto(HOME_PAGE);
  await expect(page.locator('.events-section')).toBeVisible();
  await expect(page.locator('.events-grid')).toBeVisible();
});

test('homepage shows search bar', async ({ page }) => {
  await page.goto(HOME_PAGE);
  await expect(page.locator('.search-section')).toBeVisible();
  await expect(page.locator('.search-bar')).toBeVisible();
});

// ── Filter pills ─────────────────────────────────────────────────────────────
test('clicking a filter pill makes it active', async ({ page }) => {
  await page.goto(HOME_PAGE);
  const chillPill = page.locator('.filter-pill', { hasText: 'Chill' });
  await chillPill.click();
  await expect(chillPill).toHaveClass(/active/);

  const allPill = page.locator('.filter-pill', { hasText: 'All Events' });
  await expect(allPill).not.toHaveClass(/active/);
});

test('all-events pill is active by default', async ({ page }) => {
  await page.goto(HOME_PAGE);
  const allPill = page.locator('.filter-pill', { hasText: 'All Events' });
  await expect(allPill).toHaveClass(/active/);
});

// ── Search bar ────────────────────────────────────────────────────────────────
test('search bar accepts text input', async ({ page }) => {
  await page.goto(HOME_PAGE);
  const input = page.locator('.search-field input');
  await input.fill('jazz');
  await expect(input).toHaveValue('jazz');
});

// ── Ticker banner ─────────────────────────────────────────────────────────────
test('homepage shows the event ticker', async ({ page }) => {
  await page.goto(HOME_PAGE);
  await expect(page.locator('.ticker-wrap')).toBeVisible();
  await expect(page.locator('.ticker-track')).toBeVisible();
});

// ── Footer ────────────────────────────────────────────────────────────────────
test('homepage shows footer with brand name', async ({ page }) => {
  await page.goto(HOME_PAGE);
  await expect(page.locator('footer')).toBeVisible();
  await expect(page.locator('.footer-logo')).toContainText('Encore');
});

// ── Community section ─────────────────────────────────────────────────────────
test('homepage shows the community section', async ({ page }) => {
  await page.goto(HOME_PAGE);
  await expect(page.locator('.community-section')).toBeVisible();
});
