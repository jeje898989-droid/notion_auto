#!/usr/bin/env bash
# gws.sh - run the gws CLI with credentials loaded from the skill's .env
# Usage: bash <skill-dir>/scripts/gws.sh <service> <resource> <method> [flags]
#        bash <skill-dir>/scripts/gws.sh calendar +agenda --today --format table
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${GWS_ENV_FILE:-$SKILL_DIR/.env}"

# Load KEY=VALUE lines only (comments/blank lines skipped, surrounding quotes stripped).
# Values are exported, never echoed.
if [[ -f "$ENV_FILE" ]]; then
  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%$'\r'}"
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
    [[ "$line" =~ ^[[:space:]]*([A-Za-z_][A-Za-z0-9_]*)=(.*)$ ]] || continue
    key="${BASH_REMATCH[1]}"; val="${BASH_REMATCH[2]}"
    val="${val%\"}"; val="${val#\"}"; val="${val%\'}"; val="${val#\'}"
    # An already-set environment variable wins over .env
    [[ -n "${!key:-}" ]] || export "$key=$val"
  done < "$ENV_FILE"
fi

if ! command -v gws >/dev/null 2>&1; then
  echo "gws.sh: 'gws' not found. Install with: npm install -g @googleworkspace/cli@0.22.5" >&2
  exit 127
fi

exec gws "$@"
