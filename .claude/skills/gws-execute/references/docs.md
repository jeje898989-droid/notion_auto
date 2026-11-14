# Docs Reference

> Source: `gws docs --help` (gws 0.22.5)

## Create Document

```
gws docs documents create --json '{"title":"<title>"}'
```

- Returns `documentId`. Link: `https://docs.google.com/document/d/<documentId>/edit`

## Append Text

```
gws docs +write ...
```

- Check exact options with `gws docs +write --help` before building the command.

## Advanced Edits

- Use `gws docs documents batchUpdate`; inspect with `gws schema docs.documents.batchUpdate`.

## Templates

- Reports: `templates/report/task-report.md`
