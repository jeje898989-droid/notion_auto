# Gmail

Scopes in the default .env: `gmail.compose` (drafts + sending drafts) and `gmail.readonly` (read/search). No modify/delete.

## Read

| Task | Command |
|---|---|
| Unread summary | `$GWS gmail +triage [--max 20] [--query 'is:unread category:primary'] [--labels] --format table` |
| Read one message | `$GWS gmail +read --id <MSG_ID> [--headers] [--html]` |
| Search | `$GWS gmail users messages list --params '{"userId":"me","q":"<query>","maxResults":10}'` → then `+read` each id |
| Message metadata | `$GWS gmail users messages get --params '{"userId":"me","id":"<ID>","format":"metadata"}'` |
| List drafts | `$GWS gmail users drafts list --params '{"userId":"me"}'` |
| Labels | `$GWS gmail users labels list --params '{"userId":"me"}'` |

Search query (`q` / `--query`) examples: `from:kim@x.com`, `to:me`, `subject:보고서`, `is:unread`, `has:attachment`, `newer_than:7d`, `after:2026/11/01 before:2026/11/15`, `label:work`, combine with spaces (AND) or `OR`.

`messages list` returns only IDs; fetch details with `+read` (body) or `messages get … format=metadata` (headers, cheaper).

## Write (draft-first)

| Task | Command |
|---|---|
| New draft | `$GWS gmail +send --to a@x.com[,b@x.com] --subject "…" --body "…" [--cc …] [--bcc …] [-a ./file.pdf] [--html] --draft` |
| Reply draft | `$GWS gmail +reply --message-id <ID> --body "…" [--to extra@x.com] --draft` (threading handled automatically) |
| Reply-all draft | `$GWS gmail +reply-all --message-id <ID> --body "…" [--remove x@y.com] --draft` |
| Forward draft | `$GWS gmail +forward --message-id <ID> --to b@x.com [--body "note"] [--no-original-attachments] --draft` |
| Send an existing draft (after explicit approval) | `$GWS gmail users drafts send --params '{"userId":"me"}' --json '{"id":"<DRAFT_ID>"}'` |

- Preview with `--dry-run` before creating if the user wants to see the request.
- After creating a draft, report the draft id and tell the user it is in Gmail → Drafts (`https://mail.google.com/mail/u/0/#drafts`).
- Multi-line body: use a real newline inside the quoted string, or `--html` with `<br>`.
- Never drop `--draft`. Sending happens only through `drafts send` after the user approves that specific draft.

## Not available with default scopes

`+watch` (needs Pub/Sub + `--project`), label changes / archive / mark read (`messages modify` needs `gmail.modify`), delete/trash (out of scope for this skill).
