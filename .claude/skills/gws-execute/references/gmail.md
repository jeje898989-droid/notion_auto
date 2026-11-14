# Gmail Reference

> Source: `gws gmail +send --help` (gws 0.22.5)

## Rule

- **Draft first, always.** Never run `+send` without `--draft`. Send only an existing draft after separate send approval.

## Create Draft

```
gws gmail +send --to <emails> --subject '<subject>' --body '<body>' --draft
```

| Option | Description |
|---|---|
| `--to` | Recipients, comma-separated (required) |
| `--subject` | Subject (required) |
| `--body` | Body, plain text (required) |
| `--html` | Treat body as HTML fragment (`<p>`, `<b>`, `<br>`) |
| `--cc` / `--bcc` | CC / BCC, comma-separated |
| `-a, --attach <PATH>` | Attachment (repeatable, total ≤ 25MB) |
| `--from` | Send-as alias |
| `--dry-run` | Show the request without executing |

- Record the returned draft ID as `draft_id` in the plan file.

## Send Existing Draft (after send approval only)

```
gws gmail users drafts send --params '{"userId":"me"}' --json '{"id":"<draftId>"}'
```

## List Drafts

```
gws gmail users drafts list --params '{"userId":"me"}'
```

## Body Templates

- `templates/mail/deadline-reminder.md`
