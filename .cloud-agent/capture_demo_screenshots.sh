#!/usr/bin/env bash
# Capture Depot walkthrough screenshots (storefront, cart, admin, checkout).
# Requires: dev server on http://127.0.0.1:3000, Node.js, and puppeteer in scripts/node_modules.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SCRIPT_DIR="${REPO_ROOT}/.cloud-agent/demo-screenshots"
ARTIFACTS_DIR="${CURSOR_ARTIFACTS_DIR:-/opt/cursor/artifacts}"

mkdir -p "${SCRIPT_DIR}" "${ARTIFACTS_DIR}"

if [[ ! -d "${SCRIPT_DIR}/node_modules/puppeteer" ]]; then
  echo "==> Installing puppeteer for demo screenshots..."
  (cd "${SCRIPT_DIR}" && npm init -y >/dev/null 2>&1 && npm install puppeteer@23 --silent)
fi

export CURSOR_ARTIFACTS_DIR="${ARTIFACTS_DIR}"
node "${SCRIPT_DIR}/capture_depot_demo.mjs"

echo "==> Screenshots saved to ${ARTIFACTS_DIR}"
