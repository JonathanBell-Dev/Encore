# Encore — ATL Events  |  Test Suite

## Setup (one time)

```bash
npm install
```

## Run all tests

```bash
npm test
```

## Run individual test files

```bash
npm run test:auth      # auth, profile validation, display helpers
npm run test:events    # events, connections, interests, search/filter
```

## Run with detailed output

```bash
npx jest --verbose
```

## Run with coverage report

```bash
npm run test:coverage
```

---

## What's tested

### auth.test.js  (29 tests)
| Suite | What it covers |
|---|---|
| Sign-Up Form Validation | Required fields, email format, username rules, password length |
| Login Form Validation | Email format, missing password, whitespace-only password |
| Profile Update Payload | Trimming, null URLs, boolean privacy flags, timestamp |
| Profile Display Helpers | getDisplayName, getInitials, isProfileComplete |

### events.test.js  (38 tests)
| Suite | What it covers |
|---|---|
| Event Price Formatting | Free events, integer/decimal prices, null/negative values |
| Event Date Formatting | Null, invalid, and valid ISO date strings |
| Upcoming / Past Detection | Future vs past dates, null handling |
| Event Filtering & Search | Category filter, vibe filter, text search, sort by date |
| Event Attendance | Toggle going/interested/none, attendee count labels |
| Connections | Status lookup, messaging permission, pending requests |
| Interests / Profile Chips | Selected state, chip toggling, name extraction |

---

## Adding your functions

The test files import utility functions inline for portability.
In your actual project, extract these into shared modules:

- `src/utils/auth.js`      → sign-up/login validation, profile helpers
- `src/utils/events.js`    → filtering, searching, formatting
- `src/utils/connections.js` → connection status helpers

Then update the test imports:
```javascript
const { validateSignUpForm } = require('../src/utils/auth');
```
