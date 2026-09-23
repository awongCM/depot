# Phase 1 — Modern Rails Foundation

This document describes the git worktree workflow, branch naming, test gates, and PR
checklist for Phase 1 of the Depot upgrade.

**Goal:** Rails 7.2+ on PostgreSQL, deployable to Render.

**Delivery note:** The milestone table below describes the original six-PR worktree
plan. [PR #31](https://github.com/awongCM/depot/pull/31) on
`cursor/phase1-modern-foundation-c3a8` intentionally **consolidates** those hops into
one branch for the Cloud Agent upgrade; use the worktree flow for future phases or if
you prefer incremental merges.

See [README.md](../README.md) for the full four-phase roadmap.

---

## Worktree layout

Keep the main clone on stable `master`. Create sibling worktrees under a dedicated
directory (not inside the repo — avoids nested-git confusion):

```text
~/depot/                          # main clone → master (Phase 0 baseline)
~/depot-worktrees/
  01-rails-42/                    → phase1/01-rails-4-2
  02-rails-52-postgres/           → phase1/02-rails-5-2-postgres
  03-rails-61/                    → phase1/03-rails-6-1
  04-rails-72/                    → phase1/04-rails-7-2
  05-modern-stack/                → phase1/05-modern-stack
  06-render-deploy/               → phase1/06-render-deploy
```

### Bootstrap commands

```bash
git clone https://github.com/awongCM/depot.git ~/depot
mkdir -p ~/depot-worktrees

git -C ~/depot worktree add ~/depot-worktrees/01-rails-42 -b phase1/01-rails-4-2
```

After each PR merges:

```bash
git -C ~/depot worktree remove ~/depot-worktrees/01-rails-42
git -C ~/depot pull origin master
git -C ~/depot worktree add ~/depot-worktrees/02-rails-52-postgres -b phase1/02-rails-5-2-postgres master
```

### Rules

| Rule | Rationale |
|------|-----------|
| Only **one active upgrade worktree** at a time | Each hop depends on the previous merge |
| Branch from latest `master` after each merge | Keeps history linear and CI green |
| Spike worktrees allowed for experiments | e.g. `phase1/spike-importmaps` — cherry-pick or close |
| Test gate before every PR | See [Test strategy](#test-strategy) below |
| Cloud Agent branches use `cursor/<name>-c3a8` | Rebase onto `phase1/*` branches when using agents |

---

## Milestone branches

| PR | Branch | Rails | Ruby | Key changes |
|----|--------|-------|------|-------------|
| 1 | `phase1/01-rails-4-2` | 4.2 | 2.5 | Smallest hop; validates workflow |
| 2 | `phase1/02-rails-5-2-postgres` | 5.2 | 2.5+ | PostgreSQL, ApplicationRecord |
| 3 | `phase1/03-rails-6-1` | 6.1 | 2.7 | Zeitwerk autoloading |
| 4 | `phase1/04-rails-7-2` | 7.2 | 3.2+ | Puma, credentials |
| 5 | `phase1/05-modern-stack` | 7.2 | 3.2+ | Hotwire, Propshaft, Solid Queue |
| 6 | `phase1/06-render-deploy` | 7.2 | 3.2+ | render.yaml Blueprint |

---

## PR checklist

Before opening or merging each PR:

- [ ] `bundle exec rake test` — full suite green
- [ ] `.cloud-agent/e2e.sh` — integration E2E flows pass
- [ ] `bundle exec brakeman -q -w2` — no new high-confidence issues
- [ ] `bundle exec bundler-audit check` — no unaddressed critical CVEs
- [ ] `.ruby-version` matches CI workflow
- [ ] `bin/setup` works on a clean checkout
- [ ] README / docs updated if setup steps changed

### PR-specific gates

**PR 2:** No SQLite references in config; tests run against PostgreSQL.

**PR 3:** `bin/rails zeitwerk:check` passes.

**PR 5:** Mail tests updated for `deliver_later` / `perform_enqueued_jobs`.

**PR 6:** `render.yaml` validates; deploy smoke test on Render. Build loads
`db/queue_schema.rb` after migrate; set `SOLID_QUEUE_IN_PUMA=true` so Puma runs Solid
Queue workers (required for `deliver_later` on the free web tier). Do not run
`db:seed` in production (dev-only admin user in seeds).

---

## Test strategy

```bash
# In the active worktree
bundle exec rake test
.cloud-agent/e2e.sh
bundle exec brakeman -q -w2
bundle exec bundler-audit check
```

Primary E2E safety net:

- `test/integration/user_stories_test.rb` — checkout + order email
- `test/integration/admin_workflow_test.rb` — admin login/logout

---

## Local PostgreSQL (PR 2+)

```bash
# With docker-compose.yml in repo root:
docker compose up -d
bin/setup
```

Or install PostgreSQL locally and set:

```bash
export DATABASE_URL=postgres://depot:depot@localhost:5432/depot_development
```

---

## Render deployment (PR 6)

Required environment variables:

| Variable | Purpose |
|----------|---------|
| `DATABASE_URL` | Managed PostgreSQL (auto-wired from Blueprint) |
| `RAILS_MASTER_KEY` | Decrypts `config/credentials.yml.enc` |
| `SECRET_KEY_BASE` | Session signing (can live in credentials) |
| `SMTP_*` | Order confirmation emails (see `.env.example`) |

Never commit `config/master.key`.
