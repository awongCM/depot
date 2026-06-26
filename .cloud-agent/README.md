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

## Files in this folder

| File | Purpose |
|------|---------|
| `README.md` | This file — Cloud Agent documentation |
| `setup.sh` | Entry point for Cloud Agent (run this) |
| `bootstrap.sh` | Installs Linux packages and rbenv on a fresh VM |

## Local development (not Cloud Agent)

Use `bin/setup` instead, after installing Ruby 2.2.10 via RVM or rbenv:

```bash
rvm install 2.2.10 && rvm use 2.2.10   # or: rbenv install 2.2.10
bin/setup
```

See `.ruby-version` for the required Ruby version.
