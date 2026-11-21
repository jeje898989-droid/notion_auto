---
name: gws-skill
description: Work with the user's Google Workspace from the terminal through the `gws` CLI — Gmail (triage unread mail, read, search, draft/reply/forward as drafts), Google Calendar (agenda, create/update events, free/busy), Docs (create, append, read, batch edit), Sheets (create, read ranges, append/update rows), Drive (search, upload, export/download, share), plus cross-service workflows (meeting prep, weekly digest). Credentials load automatically from the skill's own .env, so it works on its own. Use this skill whenever the user wants to look up, find, create or change anything in Gmail, Google Calendar, Google Docs/Sheets/Drive — e.g. "오늘 일정 보여줘", "안 읽은 메일 요약", "드라이브에서 보고서 찾아줘", "이 내용으로 메일 초안", "시트에 한 줄 추가" — or asks how to use gws commands or fix gws auth, even if they never say "gws". If the project has an approval-plan executor (e.g. a gws-execute skill with workspace/approvals/), executing an approved plan belongs there; this skill still serves as its command reference.
---

# gws-skill

Self-contained toolkit for the Google Workspace CLI (`@googleworkspace/cli`, command `gws`, verified on v0.22.5).
Everything runs through `scripts/gws.sh`, which loads OAuth client credentials from this skill's `.env` and then calls `gws` — so the skill folder can be copied to another project and used as is.

Below, `$GWS` means `bash <this-skill-dir>/scripts/gws.sh` (use the absolute path).

## 1. Before the first command: readiness check

Run `bash <skill-dir>/scripts/check.sh` once per session. It is read-only and prints `OK / WARN / FAIL` lines plus a `NEXT` hint.

| Result | What to do |
|---|---|
| `READY` | Go ahead. |
| node / gws missing | Install (ask first): `npm install -g @googleworkspace/cli@0.22.5` (Node.js LTS required). |
| `.env` missing or empty | Copy `.env.example` → `.env`; fill it from the OAuth client JSON. See `references/auth-setup.md`. |
| not logged in / token invalid | Run `scripts/login.sh` in the background, open the printed URL for the user, let them sign in. See `references/auth-setup.md` §4. |

A command that exits with code **2** later in the session means the same thing as "token invalid" — re-run the login flow rather than retrying the command.

## 2. Working loop

1. **Pick the service and read its reference** (only the one you need):
   `references/gmail.md`, `calendar.md`, `docs.md`, `sheets.md`, `drive.md`, `workflow.md`; flags, output formats, exit codes and troubleshooting are in `references/common.md`.
2. **Read-only requests** (agenda, triage, search, read): just run them and present the result as a readable table/summary — not raw JSON. Use `--format table` or `fields` to keep output small.
3. **Anything that writes** (create, append, update, share, draft): show the user the exact command (and `--dry-run` output when helpful), get a yes, then run it. Report what was created with its ID and link.
4. **Unknown method or parameters**: `$GWS schema <service.resource.method>` or `$GWS <service> <resource> --help` before guessing — guessing JSON bodies is the main source of exit code 3.

## 3. Safety rules (and why)

- **Mail is draft-first.** Use `--draft` on `+send / +reply / +reply-all / +forward`. Sending a saved draft (`users drafts send`) happens only after the user explicitly approves sending *that* draft. A sent email can't be recalled; a draft costs nothing.
- **No destructive commands**: `delete`, `trash`, `emptyTrash`, `batchDelete`, `values clear/batchClear`, `events delete`. If the user asks for one, explain it's outside this skill and let them do it in the Google UI. Deleted Workspace data is often unrecoverable.
- **Sharing is one permission at a time**, with the role and email confirmed. Bulk permission changes can expose files widely.
- **Double-check recipients, attendees and dates** in the preview — wrong addresses and wrong time zones are the most common real-world mistakes.
- **Never print `.env` contents or tokens.** Don't run `gws auth export`.

## 4. Command cheat sheet

| Service | Task | Command |
|---|---|---|
| Gmail | Unread summary | `$GWS gmail +triage --max 10 --format table` |
| Gmail | Read a message | `$GWS gmail +read --id <MSG_ID> --headers` |
| Gmail | Search | `$GWS gmail users messages list --params '{"userId":"me","q":"from:kim newer_than:7d","maxResults":10}'` |
| Gmail | Draft new mail | `$GWS gmail +send --to a@x.com --subject "…" --body "…" --draft` |
| Gmail | Draft reply / forward | `$GWS gmail +reply --message-id <ID> --body "…" --draft` · `+forward --message-id <ID> --to b@x.com --draft` |
| Gmail | Send an approved draft | `$GWS gmail users drafts send --params '{"userId":"me"}' --json '{"id":"<DRAFT_ID>"}'` |
| Calendar | Agenda | `$GWS calendar +agenda --today` / `--tomorrow` / `--week` / `--days 3` |
| Calendar | Create event | `$GWS calendar +insert --summary "…" --start 2026-11-25T14:00:00+09:00 --end 2026-11-25T15:00:00+09:00 [--location …] [--attendee …] [--meet]` |
| Calendar | Free/busy | `$GWS calendar freebusy query --json '{…}'` |
| Docs | Create / append | `$GWS docs documents create --json '{"title":"…"}'` · `$GWS docs +write --document <ID> --text "…"` |
| Sheets | Create / read / append | `$GWS sheets spreadsheets create --json '{"properties":{"title":"…"}}'` · `+read --spreadsheet <ID> --range 'Sheet1!A1:D20'` · `+append --spreadsheet <ID> --values 'a,b,c'` |
| Drive | Search | `$GWS drive files list --params '{"q":"name contains '\''보고서'\'' and trashed=false","pageSize":10,"fields":"files(id,name,mimeType,modifiedTime,webViewLink)"}' --format table` |
| Drive | Upload / share | `$GWS drive +upload ./file.pdf [--parent <FOLDER_ID>]` · `$GWS drive permissions create --params '{"fileId":"<ID>"}' --json '{"role":"reader","type":"user","emailAddress":"…"}'` |
| Workflow | Meeting prep / weekly digest | `$GWS workflow +meeting-prep` · `$GWS workflow +weekly-digest --format table` |

## 5. Conventions

- **Times**: RFC 3339 with the user's offset, e.g. `2026-11-25T14:00:00+09:00` for Korea. Turn relative dates ("내일 2시") into absolute ones using today's date, and show the absolute value in the preview.
- **IDs from URLs**: Docs/Sheets/Drive IDs are the long segment in `/d/<ID>/`; Gmail message IDs come from `+triage` or `messages list`.
- **File paths must be inside the current directory.** `--upload`, `--output` and `+upload <file>` reject paths outside the working directory (exit 3, "outside the current directory"). `cd` to the project folder (or copy the file into it) and use a relative path such as `outputs/report.pdf`.
- **Large JSON**: write it to a file and pass `--json "$(cat body.json)"` instead of escaping inline.
- **Stderr noise**: the line `Using keyring backend: keyring` is informational; ignore it.

## 6. Scope limits

The default `.env` grants Gmail (compose + readonly), Calendar, Docs, Sheets and Drive. Tasks, Slides, Chat, Forms, Keep, People, Meet and `gmail +watch` (Pub/Sub) need extra scopes: add them to `GWS_SCOPES` in `.env` and re-run `scripts/login.sh`. A `403 insufficient scopes` / `ACCESS_TOKEN_SCOPE_INSUFFICIENT` error means exactly this.
