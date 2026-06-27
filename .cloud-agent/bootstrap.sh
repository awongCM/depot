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
    libsqlite3-dev libssl-dev libreadline-dev zlib1g-dev libyaml-dev
fi

if ! command -v rbenv >/dev/null 2>&1; then
  echo "==> [cloud-agent] Installing rbenv..."
  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-installer | bash
fi

export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"
eval "$(rbenv init - bash)"

echo "==> [cloud-agent] Bootstrap complete."
