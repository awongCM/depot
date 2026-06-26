#!/usr/bin/env bash
# Cloud Agent only — run this at the start of each Cloud Agent session.
# For local development, use bin/setup instead (see .cloud-agent/README.md).
set -euo pipefail

CLOUD_AGENT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "${CLOUD_AGENT_DIR}/.." && pwd)"

cd "${REPO_ROOT}"

# Bootstrap the ephemeral VM (Linux packages + rbenv).
source "${CLOUD_AGENT_DIR}/bootstrap.sh"

# Shared setup: Ruby, gems, database (also used by bin/setup locally).
exec "${REPO_ROOT}/bin/setup" "$@"
