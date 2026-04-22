// @ts-check
const { defineConfig, devices } = require('@playwright/test');

/**
 * Playwright configuration for Encore E2E tests.
 *
 * Run all tests:      npx playwright test
 * Run headed:         npx playwright test --headed
 * Run specific file:  npx playwright test tests/e2e/auth.spec.js
 * View report:        npx playwright show-report
 *
 * Set BASE_URL to target a different server:
 *   BASE_URL=http://localhost:3000 npx playwright test
 */
module.exports = defineConfig({
  testDir: './tests/e2e',
  testMatch: '**/*.spec.js',

  // Fail the build on CI if any test is accidentally `.only`
  forbidOnly: !!process.env.CI,

  // Retry on CI to handle flakiness
  retries: process.env.CI ? 1 : 0,

  // Reporter
  reporter: [['html', { open: 'never' }], ['list']],

  use: {
    baseURL: process.env.BASE_URL || 'http://localhost:5500',

    // Capture trace on first retry
    trace: 'on-first-retry',

    // Screenshot on failure
    screenshot: 'only-on-failure',
  },

  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'Mobile Safari',
      use: { ...devices['iPhone 13'] },
    },
  ],

  // Uncomment to spin up a local server before running tests:
  // webServer: {
  //   command: 'npx serve . -l 5500',
  //   url: 'http://localhost:5500',
  //   reuseExistingServer: !process.env.CI,
  // },
});
