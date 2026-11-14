---
name: gws-execute
description: Executes approved follow-up tasks with the GWS (Google Workspace) CLI — Gmail drafts/sending, Calendar events, Docs, Sheets, Drive. Identifies the task type, reads the matching references/ doc to build the command, previews the exact command for user approval, runs it via the gws-executor subagent, and reports result links. Use for user GWS requests (e.g. "이 내용으로 메일 초안 써줘") or approved follow-up plans.
---

# gws-execute

Execute approved follow-up tasks with the GWS CLI.

## Input

- A plan in `workspace/approvals/<plan-id>.json` (from `notion-db-register` or `notion-db-analyze`), or a direct GWS request from the user.

## Step 0 — Pre-checks

1. Run `gws auth status`. If `auth_method` is `none` → stop and tell the user GWS is not connected. (As of 2026-11-14 GWS is intentionally **not connected**.)
2. Confirm the plan exists and its status allows the next step (see `workspace/approvals/README.md`).

## Step 1 — Identify Task Type & Read References

| Task Type | Reference |
|---|---|
| mail | `references/gmail.md` |
| calendar | `references/calendar.md` |
| doc | `references/docs.md` |
| sheet | `references/sheets.md` |
| drive | `references/drive.md` |

- If the matching reference exists, read it and build the command from it.
- If not, fall back to `config/gws-commands.md` and `gws <service> --help` / `gws schema`.
- Fill templates from `templates/` when the task needs body text (e.g. `templates/mail/deadline-reminder.md`).

## Step 2 — Preview (Approval Gate)

Show the exact command(s) before running anything:

```
다음 명령을 실행할까요?
gws calendar +insert --summary '친구와 카페약속' --start '2026-11-15T14:00:00+09:00' --end '2026-11-15T15:00:00+09:00' --location '강남'
```

- Approve → set the plan to `approved` → Step 3. Edit → rebuild and preview again. Cancel → stop.

## Step 3 — Execute via gws-executor

- Call the `gws-executor` subagent with the plan ID and the approved command(s).
- **Mail**: the first run creates a **draft only** (`--draft`) → status `draft_created` → show the draft and ask "이 초안을 그대로 전송할까요?" → only on approval set `send_approved` and send the draft by `draft_id`.

## Step 4 — Report

- Links/IDs of created items (event, draft, document, sheet, file).
- Failed items with cause and next step.
- Log location in `logs/`.

## Prohibited

- Running any command the user has not seen in the preview.
- Sending mail without separate send approval.
- Deletion or bulk permission changes.
