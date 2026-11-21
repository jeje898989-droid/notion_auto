# GWS Commands

> Role: GWS CLI usage reference (the command dictionary the execution agent follows)
> CLI: `@googleworkspace/cli` v0.22.5 (`gws`) — verified 2026-11-14

## 1. Installation & Authentication

- Install: `npm install -g @googleworkspace/cli@0.22.5` (requires Node.js)
- Check version: `gws --version`
- OAuth client setup (one-time, requires gcloud): `gws auth setup`
  - Or place an OAuth client JSON at `~/.config/gws/client_secret.json`, or set `GOOGLE_WORKSPACE_CLI_CLIENT_ID` / `GOOGLE_WORKSPACE_CLI_CLIENT_SECRET`.
  - `gws auth setup` cannot create the OAuth client itself: create the consent screen (External, add the owner as a test user) and a **Desktop app** client in Cloud Console, then save its JSON to the path above.
- Login (opens browser) — always pass scopes explicitly; the `-s` scope picker needs an interactive terminal and silently falls back to openid/email/profile only:
  ```
  gws auth login --scopes "https://www.googleapis.com/auth/gmail.compose,https://www.googleapis.com/auth/gmail.readonly,https://www.googleapis.com/auth/calendar,https://www.googleapis.com/auth/documents,https://www.googleapis.com/auth/spreadsheets,https://www.googleapis.com/auth/drive"
  ```
- Check auth status: `gws auth status` → `auth_method` must not be `none`, `token_valid` must be `true`.
- Re-auth: the OAuth app is in **Testing** status, so refresh tokens expire after ~7 days. On exit code 2, re-run the login command above.
- Current setup (2026-11-21): GCP project `notion-auto-gws-11211523`, client `gws CLI` (Desktop). See `logs/20261121_gws-auth-setup.md`.
- Logout: `gws auth logout`

## 2. Command Formats by Task

General form: `gws <service> <resource> [sub-resource] <method> --params '<JSON>' --json '<JSON>'`
Helper commands start with `+`. Inspect any API method with `gws schema <service.resource.method>`.

| Service | Action | Command Format |
|---|---|---|
| Gmail | Create draft | `gws gmail +send --to <emails> --subject <text> --body <text> --draft` |
| Gmail | Send existing draft (after send approval) | `gws gmail users drafts send --params '{"userId":"me"}' --json '{"id":"<draftId>"}'` |
| Gmail | List drafts | `gws gmail users drafts list --params '{"userId":"me"}'` |
| Docs | Create document | `gws docs documents create --json '{"title":"<title>"}'` |
| Docs | Write body (append) | `gws docs +write ...` (see `gws docs +write --help`) |
| Sheets | Create sheet | `gws sheets spreadsheets create --json '{"properties":{"title":"<title>"}}'` |
| Sheets | Enter values (append row) | `gws sheets +append ...` (see `gws sheets +append --help`) |
| Drive | Upload | `gws drive +upload ...` (see `gws drive +upload --help`) |
| Drive | Share permission | `gws drive permissions create --params '{"fileId":"<id>"}' --json '{"role":"reader","type":"user","emailAddress":"<email>"}'` |
| Calendar | Create event | `gws calendar +insert --summary <text> --start <RFC3339> --end <RFC3339> [--location <text>] [--description <text>] [--attendee <email>]` |

- Times use RFC3339 with the local offset, e.g. `2026-11-15T14:00:00+09:00`.
- Use `--dry-run` to validate a request before executing it.

## 3. Input File Rules

- Create large JSON parameters in `workspace/outputs/` and pass them by path.

## 4. Allowed / Prohibited Commands

- Allowed: only the command formats listed in section 2, plus `gws auth status` and `--help` / `gws schema`.
- **Mail: never run `gws gmail +send` without `--draft`.** Send only an existing draft via `drafts send`, and only after the user approves sending.
- Prohibited: deletion (`delete`, `trash`, `emptyTrash`), bulk permission changes, `gws auth export`, and any command not in a plan.

## 5. Common Errors and Responses

| Exit Code | Meaning | Response |
|---|---|---|
| 1 | API error (Google returned an error) | Report the error message; check IDs and permissions |
| 2 | Auth error (credentials missing or invalid) | Stop; ask the user to run `gws auth login` |
| 3 | Validation (bad arguments) | Fix arguments per `--help` / `gws schema` and retry once |
| 4 | Discovery (could not fetch API schema) | Check network; retry later |
| 5 | Internal failure | Stop and report |
