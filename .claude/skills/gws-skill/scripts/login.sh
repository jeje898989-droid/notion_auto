#!/usr/bin/env bash
# login.sh - (re)authenticate gws with the scopes listed in .env (GWS_SCOPES)
# Prints a Google sign-in URL and waits until the browser redirect to localhost completes.
# Tip for agents: run this in the background, read the URL from its output,
# open it in a browser (e.g. Playwright), and let the user sign in / click Allow.
set -euo pipefail
SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${GWS_ENV_FILE:-$SKILL_DIR/.env}"

scopes="${GWS_SCOPES:-}"
if [[ -z "$scopes" && -f "$ENV_FILE" ]]; then
  scopes="$(grep -E '^[[:space:]]*GWS_SCOPES=' "$ENV_FILE" | tail -1 | cut -d= -f2- | tr -d '"'"'"'\r')"
fi
if [[ -z "$scopes" ]]; then
  echo "login.sh: GWS_SCOPES is empty in $ENV_FILE" >&2; exit 3
fi

# Explicit --scopes on purpose: the interactive -s scope picker needs a TTY and,
# without one, silently falls back to openid/email/profile only.
exec bash "$SKILL_DIR/scripts/gws.sh" auth login --scopes "$scopes"
