# Depot

A Ruby on Rails e-commerce application — originally built as a learning project and
now being upgraded toward a proper, production-capable storefront.

---

## Legacy and history

### Origins

**Depot** comes from [*Agile Web Development with Rails* (4th edition)](https://pragprog.com/titles/rails4/agile-web-development-with-rails-4th-edition/), the classic Pragmatic Programmers tutorial (~2014). It was a **pet project** scaffold: enough to demonstrate catalog → cart → checkout → admin, but not designed as a real-world commerce platform.

The app name, mailer defaults (`depot@example.com`), and sample products (CoffeeScript, Programming Ruby, etc.) all trace back to that book.

### Stack at legacy baseline (pre–Phase 0)

| Layer | Version / choice |
|-------|------------------|
| Rails | **4.1.1** |
| Ruby | **~2.2** (unpinned in repo) |
| Database | **SQLite3** (including production config) |
| Frontend | jQuery, Turbolinks 2, CoffeeScript, Sprockets |
| Auth | `has_secure_password` (admin users only) |
| Payments | Dropdown only (Check / Credit Card / PO) — **no payment gateway** |
| Tests | Minitest; one meaningful integration test |
| CI / deploy | None |
| Docs | Default Rails boilerplate `README.rdoc` |

### What the legacy app could do

- Public storefront with product listing
- Session-based shopping cart (AJAX add / decrement)
- Checkout (name, address, email, payment type)
- Order confirmation and shipped emails
- Admin login and CRUD for products, orders, and users
- Partial i18n (English / Spanish)

### What it lacked for real e-commerce

- Real payments (Stripe, PayPal, etc.)
- Customer accounts (users were admin-only)
- Inventory / stock tracking
- Order state machine (pending → paid → shipped → refunded)
- Tax, shipping, coupons, search, categories
- Product image uploads (URL strings only)
- PostgreSQL for production
- Security hardening, CI, or modern deployment config

### Known legacy issues (addressed in Phase 0)

Before stabilization, the codebase had several bugs and risks:

- Hardcoded Gmail SMTP credentials in `config/environments/development.rb`
- End-of-life Rails 4.1 / ancient gem set (known CVEs)
- Mass-assignment bug in `OrdersController#update`
- Broken `Order` / `PaymentType` associations
- Cart session not cleared on destroy (`==` vs `=`)
- Line item totals using live product price instead of snapshotted price
- `LineItemsController` callback shadowing Rails `reset_session`, wiping carts
- Seeds and fixtures missing required `locale` on products
- Minimal test coverage and no CI

**The legacy app was a solid tutorial skeleton, but not safe to deploy publicly as-is.**

---

## Upgrade roadmap

Work is planned in four phases. Each phase should leave the app runnable and tested.

### Phase 0 — Stabilize and secure ✅ (current branch)

**Goal:** Safe baseline on Rails 4.1, ready for incremental upgrade.

| Area | What was done |
|------|----------------|
| Security | Removed hardcoded SMTP credentials; `.env.example`; rotate exposed passwords |
| Bugs | Strong params, associations, cart session, line item pricing, layout nil checks |
| Tests | Expanded model/integration tests; admin workflow; 65 tests passing |
| CI | GitHub Actions with Brakeman and bundler-audit |
| Tooling | `.ruby-version` (2.2.10), `bin/setup`, `.cloud-agent/` for ephemeral VMs |
| E2E | `.cloud-agent/e2e.sh` integration + live HTTP smoke tests |
| Gems | Pinned `json` and `bcrypt` for modern compiler compatibility |

**You are here.** Ruby **2.2.10** is required — do not use Ruby 3.x until Phase 1 completes.

---

### Phase 1 — Modern Rails foundation

**Goal:** Rails 7.2+ on PostgreSQL, deployable to Render or similar.

Upgrade path (incremental — run tests at each step):

```
Rails 4.1 → 4.2 → 5.2 → 6.1 → 7.2
Ruby    2.2  → 2.5  → 2.7  → 3.2+
```

Along the way:

- Switch database to **PostgreSQL**
- Replace `secrets.yml` with `credentials.yml.enc`
- CoffeeScript → plain JavaScript; Turbolinks → **Hotwire** (Turbo + Stimulus)
- Sprockets → **Propshaft** + importmaps (or jsbundling-rails)
- `deliver` → `deliver_later` with **Solid Queue** or Sidekiq
- Enable `force_ssl`, security headers, CSP
- Address Brakeman / bundler-audit findings as versions move forward
- Add `render.yaml` Blueprint for deployment

---

### Phase 2 — Proper e-commerce domain

**Goal:** Real commerce flows — payments and customer accounts.

| Feature | Suggested approach |
|---------|-------------------|
| Payments | Stripe Checkout or Payment Intents + webhooks |
| Customer accounts | Devise or Rodauth (separate from admin) |
| Admin authorization | `namespace :admin` + Pundit or Action Policy |
| Inventory | `stock_quantity` on products; decrement on paid orders |
| Order states | AASM or enum: pending → paid → processing → shipped → cancelled |
| Pricing | Store cents as integers (`price_cents`), not decimals |
| Images | Active Storage + S3 / Cloudflare R2 |
| Search | pg_search or Meilisearch |
| Categories | `Category` model with `has_many :products` |

---

### Phase 3 — Production polish

**Goal:** Something you'd run as a real store.

- Responsive UI (e.g. Tailwind CSS)
- Guest checkout + optional account creation
- Tax (Stripe Tax or manual rules) and shipping rates
- Coupons, promotions, order history, reviews
- Monitoring (Sentry), structured logging
- GDPR basics: data export, account deletion

---

### Alternative: adopt an engine

If the priority is a working store quickly rather than owning every layer:

| Engine | Notes |
|--------|-------|
| [Solidus](https://solidus.io/) | Spree fork; mature, actively maintained |
| [Spree](https://spreecommerce.org/) | Full-featured; steeper learning curve |
| [Pay](https://github.com/pay-rails/pay) | Payments abstraction; pair with your own models |

You could migrate product data into Solidus/Spree and customize from there.

---

## Getting started

### Requirements

- **Ruby 2.2.10** (see `.ruby-version`) — not Ruby 3.x on this branch
- Bundler **1.17.x**
- SQLite3 (development/test)

### Local setup (Mac / Linux)

```bash
# Install Ruby 2.2.10 via RVM or rbenv first
rvm install 2.2.10 && rvm use 2.2.10   # or: rbenv install 2.2.10

cp .env.example .env   # optional: SMTP settings for real email in development
bin/setup
bin/setup test         # run full test suite
bin/setup server       # http://localhost:3000
```

**Default admin login** (from fixtures/seeds): user `dave`, password `secret`

### Cloud Agent (Cursor)

Ephemeral VMs reset each session. Use the `.cloud-agent/` folder — see
[`.cloud-agent/README.md`](.cloud-agent/README.md).

```bash
.cloud-agent/setup.sh          # bootstrap Ruby, gems, database
.cloud-agent/e2e.sh            # end-to-end integration tests
.cloud-agent/setup.sh server   # start dev server
.cloud-agent/e2e.sh --live     # E2E + live HTTP smoke test
```

---

## Testing

```bash
bundle exec rake test                    # full suite (~65 tests)
bundle exec rake test TEST=test/integration/user_stories_test.rb
```

Security scans (expect findings on Rails 4.1 until Phase 1):

```bash
bundle exec brakeman -q -w2 --no-exit-on-warn
bundle exec bundler-audit check --update
```

---

## Project structure (high level)

```
app/
  controllers/   store, carts, line_items, orders, products, sessions, admin
  models/        Product, Cart, LineItem, Order, PaymentType, User
  mailers/       OrderNotifier (order emails), Notifier (admin errors)
config/
  routes.rb      storefront at /, admin at /admin, localized routes
db/
  schema.rb      SQLite schema (products, carts, orders, …)
test/
  integration/   E2E flows (checkout, admin login)
.cloud-agent/    Cloud Agent–only bootstrap and E2E scripts
bin/setup        Shared local + cloud Ruby/gem/database setup
```

---

## License and attribution

Derived from tutorial material in *Agile Web Development with Rails*, 4th Edition,
The Pragmatic Programmers. Copyright and usage terms apply to the original
tutorial code.
