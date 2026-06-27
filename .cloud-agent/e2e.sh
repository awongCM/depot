#!/usr/bin/env bash
# Cloud Agent only — end-to-end test runner.
#
# Runs integration tests that exercise full HTTP flows through the Rails stack
# (storefront checkout, admin login, error notifications). No browser required.
#
# Usage:
#   .cloud-agent/e2e.sh           # integration E2E tests only
#   .cloud-agent/e2e.sh --full    # all unit/controller/integration tests
#   .cloud-agent/e2e.sh --live    # also smoke-test a running dev server on :3000
set -euo pipefail

CLOUD_AGENT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "${CLOUD_AGENT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

activate_ruby() {
  export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"
  command -v rbenv >/dev/null 2>&1 && eval "$(rbenv init - bash)"
}

run_integration_e2e() {
  bundle exec rake test \
    test/integration/user_stories_test.rb \
    test/integration/admin_workflow_test.rb
}

# Ensure Ruby/gems/db are ready (no-op if already set up).
"${CLOUD_AGENT_DIR}/setup.sh"

activate_ruby

MODE="${1:-}"

echo ""
echo "==> [cloud-agent] Running end-to-end tests..."
echo ""

if [[ "${MODE}" == "--full" ]]; then
  echo "==> Full test suite (unit + controller + integration)"
  bundle exec rake test
elif [[ "${MODE}" == "--live" ]]; then
  echo "==> Integration E2E tests"
  run_integration_e2e

  echo ""
  echo "==> Live server smoke test (requires server on port 3000)"
  if ! curl -sf http://127.0.0.1:3000/ >/dev/null; then
    echo "ERROR: No server on http://127.0.0.1:3000"
    echo "Start one in another terminal: .cloud-agent/setup.sh server"
    exit 1
  fi
  bundle exec ruby "${CLOUD_AGENT_DIR}/live_smoke.rb"
else
  echo "==> Integration E2E tests (storefront + admin flows)"
  run_integration_e2e
fi

echo ""
echo "==> [cloud-agent] E2E tests passed."
