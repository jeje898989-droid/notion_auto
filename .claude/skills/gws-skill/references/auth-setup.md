# Auth setup & re-auth

Read this when `scripts/check.sh` reports a FAIL, or a command exits with code 2.

## 1. How credentials flow

```
.env (CLIENT_ID / CLIENT_SECRET / PROJECT_ID / GWS_SCOPES)
   └─ scripts/gws.sh exports them → gws auth login → browser consent
        └─ tokens stored encrypted in ~/.config/gws/credentials.enc (OS keyring)
```

- `.env` holds the **OAuth client** (which app is asking). The **user tokens** are created by login and live in `~/.config/gws/`, not in `.env`.
- Variables already set in the environment take priority over `.env`. Set `GWS_ENV_FILE=<path>` to use a different .env.

## 2. Install (only if check.sh says it's missing; ask first)

```bash
winget install OpenJS.NodeJS.LTS          # Windows, if node is missing
npm install -g @googleworkspace/cli@0.22.5
gws --version
```

## 3. Create an OAuth client (one-time, only if .env is empty)

`gws auth setup` can create a project and enable APIs (it needs gcloud), but it **cannot create the OAuth client**. Do that in Cloud Console; Playwright can fill the forms, but the user must click the policy agreements and do every sign-in.

1. Project: `gcloud projects create <id>` (first-time accounts must accept the Cloud Terms of Service in the Console first — error "Callers must accept Terms of Service").
2. Enable APIs: `gcloud services enable gmail.googleapis.com calendar-json.googleapis.com docs.googleapis.com sheets.googleapis.com drive.googleapis.com --project <id>`
3. `https://console.cloud.google.com/auth/overview?project=<id>` → **시작하기 / Get started**: app name, support email → Audience **External** → contact email → *user agrees to the User Data Policy and clicks Create* (wait for the "OAuth 개요" page before navigating away, or the config is not saved).
4. `…/auth/audience` → **Add users** → the user's own Gmail address → Save (needed while the app is in *Testing*).
5. `…/auth/clients/create` → Application type **Desktop app** → Create → **Download JSON**.
6. Put the values into `.env`:
   `GOOGLE_WORKSPACE_CLI_CLIENT_ID` ← `installed.client_id`, `GOOGLE_WORKSPACE_CLI_CLIENT_SECRET` ← `installed.client_secret`, `GOOGLE_WORKSPACE_PROJECT_ID` ← `installed.project_id`.
   Delete the downloaded JSON afterwards if it landed inside a repo.

## 4. Log in / re-auth

```bash
bash <skill-dir>/scripts/login.sh     # run in the background
```

- It prints `Open this URL in your browser to authenticate:` followed by an `https://accounts.google.com/...` URL and waits for the redirect to `http://localhost:<port>`.
- Open the URL (Playwright or the user's browser on the **same machine**, because the redirect goes to localhost). The user picks the account; on "Google hasn't verified this app" → *Advanced → Go to (app)*; tick all permissions → Continue.
- The script exits 0 when done. Confirm with `scripts/check.sh` (`token_valid: true`).
- `--scopes` is passed explicitly on purpose: the `-s` picker needs a TTY and otherwise silently requests only openid/email/profile.

## 5. Why re-auth keeps coming back

An External app in **Testing** status issues refresh tokens that expire after about **7 days**. Expect exit code 2 roughly weekly; re-run §4. To stop this, publish the app (Audience → Publish) — for personal use Google lets unverified apps run with the warning screen.

## 6. Troubleshooting

| Symptom | Cause → fix |
|---|---|
| `access_denied` / "app not completed verification" | Account not in test users → §3 step 4 |
| Login page says "This browser or app may not be secure" | Google blocked the automated browser → open the URL in the user's normal Chrome |
| `redirect_uri_mismatch` | Client type isn't **Desktop app** → create a Desktop client |
| `403 … API has not been used in project` | API not enabled → §3 step 2 |
| `403 insufficient scopes` | Scope missing → add to `GWS_SCOPES`, re-run §4 |
| `auth_method: none` after login | Login was interrupted before the localhost redirect → re-run §4 |
