#!/usr/bin/env bash
set -euo pipefail

# Sets up the docker-sbx sandbox for Pattern C (agent inside microVM).
# Run this once before using the dashboard's Pattern C.

if ! command -v sbx >/dev/null 2>&1; then
  echo "sbx not installed — Pattern C will not work."
  echo "Install: brew install docker/tap/sbx  (macOS Apple Silicon)"
  echo "         See https://docs.docker.com/ai/sandboxes/ for other OSes."
  exit 0
fi

if ! sbx ls 2>/dev/null | grep -q "pattern-c"; then
  echo "[setup] Creating sbx sandbox 'pattern-c'"
  sbx create --name=pattern-c claude .
fi

# Allow the Anthropic API through the network policy.
sbx policy allow network api.anthropic.com 2>/dev/null || true

echo "[setup] Done. Sandbox 'pattern-c' ready."
echo "        Run: npm run dashboard"
