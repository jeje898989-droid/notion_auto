# 2026-11-21 GWS CLI Install & Auth Log

## Local install

| Action | Result |
|---|---|
| `npm install -g @googleworkspace/cli@0.22.5` | Reinstalled, `gws 0.22.5` |
| `winget install Google.CloudSDK` | Installed Google Cloud SDK 594.0.0 at `C:\Program Files (x86)\Google\Cloud SDK\` (added to system PATH) |
| `gcloud auth login` | Logged in (URL opened via Playwright; user signed in) |

## Google Cloud setup

| Action | Result |
|---|---|
| Accept Cloud Terms of Service | Done by user in Console (first `projects create` failed with "Callers must accept Terms of Service") |
| `gcloud projects create notion-auto-gws-11211523` | Created; set as gcloud default project |
| `gcloud services enable` | Enabled gmail, calendar-json, docs, sheets, drive APIs |
| `gws auth setup` | Stopped at step 3: OAuth client must be created manually in Console |
| OAuth consent screen (Playwright) | App `gws CLI`, External, Testing. User checked the User Data Policy box and clicked Create (first attempt did not save; redone) |
| Test users (Playwright) | Added the owner account (1/100) |
| OAuth client (Playwright) | Desktop app `gws CLI` created; JSON moved to `~/.config/gws/client_secret.json` (not kept in repo) |

## GWS login

| Action | Result |
|---|---|
| `gws auth login -s gmail,calendar,docs,sheets,drive` | Aborted: no TTY, scope picker skipped, only openid/email/profile requested |
| `gws auth login --scopes <6 scopes>` | Success (user approved consent in Playwright browser) |
| `gws auth status` | `auth_method: oauth2`, `token_valid: true`, `has_refresh_token: true`, `storage: encrypted` |

Granted scopes: `gmail.compose`, `gmail.readonly`, `calendar`, `documents`, `spreadsheets`, `drive` (+ openid/email/profile).

## Notes

- To re-login later, use explicit `--scopes` (the `-s` picker needs an interactive terminal).
- The app is in "Testing" status: refresh tokens for External apps in Testing expire after 7 days, so re-run `gws auth login` when exit code 2 appears.

## Docs update

- Updated `config/gws-commands.md` §1 (+ translation): explicit `--scopes` login, Console OAuth client steps, 7-day re-auth note.
