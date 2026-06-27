# Cloud Agent only

**This folder is for Cursor Cloud Agent sessions only.** Do not rely on it for
local development on your Mac or a long-lived Linux machine.

## Why this folder exists

Cloud Agent VMs are **ephemeral**: each session starts without Ruby, Bundler, or
installed gems. Nothing persists after the session ends.

Local development uses your own Ruby version manager (RVM, rbenv, asdf) and does
not need the bootstrap steps in this folder.

## What to run (Cloud Agent)

From the repo root, at the start of every Cloud Agent session:

```bash
.cloud-agent/setup.sh
```

Or with tests / server:

```bash
.cloud-agent/setup.sh test
.cloud-agent/setup.sh server
```

First run takes a few minutes (Ruby 2.2.10 is compiled from source). Later
commands in the same session are fast.

## End-to-end testing (Cloud Agent)

This Rails 4.1 app uses **integration tests** for E2E coverage — they boot the
full app and exercise real HTTP flows (no browser needed).

### Quick E2E (recommended)

```bash
.cloud-agent/e2e.sh
```

Covers:
- Storefront browse → add to cart → checkout → order email
- Invalid cart error notification
- Admin login → view orders → logout
- Invalid login rejection

### Full test suite

```bash
.cloud-agent/e2e.sh --full
```

Runs all unit, controller, and integration tests (~65 tests).

### Live server smoke test

Tests against a **running dev server** (development DB, real CSRF):

```bash
# Terminal 1 — start the server
.cloud-agent/setup.sh server

# Terminal 2 — run E2E + live HTTP smoke
.cloud-agent/e2e.sh --live
```

Or ask the Cloud Agent: *"Run `.cloud-agent/e2e.sh --live` with the server
running."*

### Manual browser testing

Cloud Agent VMs do not expose a public URL by default. For clicking through the
UI yourself, run locally with `bin/setup` and open http://localhost:3000.

## Files in this folder

| File | Purpose |
|------|---------|
| `README.md` | This file — Cloud Agent documentation |
| `setup.sh` | Bootstrap Ruby/gems/database |
| `bootstrap.sh` | Installs Linux packages and rbenv on a fresh VM |
| `e2e.sh` | End-to-end test runner |
| `live_smoke.rb` | HTTP smoke test against a running dev server |

## Local development (not Cloud Agent)

Use `bin/setup` instead, after installing Ruby 2.2.10 via RVM or rbenv:

```bash
rvm install 2.2.10 && rvm use 2.2.10   # or: rbenv install 2.2.10
bin/setup
bin/setup test                         # or: .cloud-agent/e2e.sh (also works)
```

See `.ruby-version` for the required Ruby version.
