#!/usr/bin/env bash
# Cloud Agent only — bootstrap a fresh ephemeral Linux VM.
# Installs system packages and rbenv. Not used for local Mac development.
set -euo pipefail

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "ERROR: .cloud-agent/bootstrap.sh is for Cloud Agent Linux VMs only."
  exit 1
fi

echo "==> [cloud-agent] Bootstrapping fresh VM..."

if command -v apt-get >/dev/null 2>&1; then
  echo "==> [cloud-agent] Installing Linux build dependencies..."
  sudo apt-get update -qq
  sudo apt-get install -y -qq \
    build-essential curl git \
    libpq-dev libssl-dev libreadline-dev zlib1g-dev libyaml-dev \
    postgresql postgresql-contrib

  if ! pg_isready -h 127.0.0.1 -p 5432 >/dev/null 2>&1; then
    echo "==> [cloud-agent] Starting PostgreSQL..."
    sudo service postgresql start || true
  fi

  if ! sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='depot'" | grep -q 1; then
    sudo -u postgres psql -c "CREATE USER depot WITH PASSWORD 'depot' CREATEDB SUPERUSER"
  fi
  sudo -u postgres psql -tc "SELECT 1 FROM pg_database WHERE datname='depot_development'" | grep -q 1 \
    || sudo -u postgres psql -c "CREATE DATABASE depot_development OWNER depot"
  sudo -u postgres psql -tc "SELECT 1 FROM pg_database WHERE datname='depot_test'" | grep -q 1 \
    || sudo -u postgres psql -c "CREATE DATABASE depot_test OWNER depot"
fi

if ! command -v rbenv >/dev/null 2>&1; then
  echo "==> [cloud-agent] Installing rbenv..."
  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-installer | bash
fi

export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"
eval "$(rbenv init - bash)"

echo "==> [cloud-agent] Bootstrap complete."
