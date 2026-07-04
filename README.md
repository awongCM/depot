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

### Phase 0 — Stabilize and secure ✅

**Goal:** Safe baseline on Rails 4.1, ready for incremental upgrade.

Completed on the `master` branch before Phase 1.

---

### Phase 1 — Modern Rails foundation ✅ (current branch)

**Implementation guide:** [docs/PHASE1.md](docs/PHASE1.md) — worktree workflow, branch naming, PR checklist.

**Goal:** Rails 7.2+ on PostgreSQL, deployable to Render or similar.

| Area | What was done |
|------|----------------|
| Rails / Ruby | **7.2** on **Ruby 3.2.6** |
| Database | **PostgreSQL** (dev/test/prod); `docker-compose.yml` for local |
| Assets | **Propshaft** + **importmaps**; CoffeeScript removed |
| Frontend | **Hotwire** (Turbo + Stimulus); jQuery via importmap for legacy AJAX |
| Jobs | `deliver_later` with **Solid Queue** in production |
| Security | `force_ssl`, CSP initializer, credentials |
| Deploy | [`render.yaml`](render.yaml) Blueprint |

**You are here.** Ruby **3.2.6** and PostgreSQL are required.

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

- **Ruby 3.2.6** (see `.ruby-version`)
- **PostgreSQL 16+** (local via Docker or native install)
- Bundler **2.x**

### Local setup (Mac / Linux)

```bash
# Start PostgreSQL (Docker)
docker compose up -d

# Install Ruby 3.2.6 via rbenv or RVM
rbenv install 3.2.6 && rbenv local 3.2.6

cp .env.example .env   # optional: SMTP and database settings
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

Security scans:

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
  schema.rb      PostgreSQL schema (products, carts, orders, …)
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
