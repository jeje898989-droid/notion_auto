#!/usr/bin/env bash
# check.sh - readiness check for gws-skill (read-only; changes nothing)
# Prints one line per check: OK / WARN / FAIL, then a NEXT hint.
SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${GWS_ENV_FILE:-$SKILL_DIR/.env}"
next=""

if command -v node >/dev/null 2>&1; then echo "OK   node $(node --version)"
else echo "FAIL node not installed"; next="${next:-install Node.js LTS (winget install OpenJS.NodeJS.LTS), then npm install -g @googleworkspace/cli@0.22.5}"; fi

if command -v gws >/dev/null 2>&1; then echo "OK   $(gws --version 2>/dev/null | head -1)"
else echo "FAIL gws not installed"; next="${next:-npm install -g @googleworkspace/cli@0.22.5}"; fi

if [[ -f "$ENV_FILE" ]]; then
  missing=""
  for k in GOOGLE_WORKSPACE_CLI_CLIENT_ID GOOGLE_WORKSPACE_CLI_CLIENT_SECRET GWS_SCOPES; do
    grep -qE "^[[:space:]]*$k=.+" "$ENV_FILE" || missing="$missing $k"
  done
  if [[ -z "$missing" ]]; then echo "OK   .env found ($ENV_FILE), required keys set"
  else echo "FAIL .env missing values:$missing"; next="${next:-fill $ENV_FILE (see .env.example and references/auth-setup.md)}"; fi
else
  echo "FAIL .env not found ($ENV_FILE)"; next="${next:-copy .env.example to .env and fill it (references/auth-setup.md)}"
fi

if command -v gws >/dev/null 2>&1; then
  status="$(bash "$SKILL_DIR/scripts/gws.sh" auth status 2>/dev/null)"
  method="$(printf '%s' "$status" | grep -o '"auth_method": *"[^"]*"' | sed 's/.*"\([^"]*\)"$/\1/')"
  valid="$(printf '%s' "$status" | grep -o '"token_valid": *[a-z]*' | awk '{print $NF}')"
  user="$(printf '%s' "$status" | grep -o '"user": *"[^"]*"' | sed 's/.*"\([^"]*\)"$/\1/')"
  if [[ "$method" == "none" || -z "$method" ]]; then
    echo "FAIL not logged in (auth_method: ${method:-unknown})"; next="${next:-bash $SKILL_DIR/scripts/login.sh}"
  elif [[ "$valid" != "true" ]]; then
    echo "WARN logged in as ${user:-?} but token_valid=${valid:-unknown}"; next="${next:-bash $SKILL_DIR/scripts/login.sh}"
  else
    echo "OK   logged in as ${user:-?} ($method, token valid)"
  fi
fi

if [[ -n "$next" ]]; then echo "NEXT $next"; exit 1; fi
echo "READY"
