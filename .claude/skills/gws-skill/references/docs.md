# Google Docs

Scope: `documents`. Document ID = the segment in `docs.google.com/document/d/<ID>/edit`.

| Task | Command |
|---|---|
| Create | `$GWS docs documents create --json '{"title":"회의록 2026-11-21"}'` → returns `documentId`; link `https://docs.google.com/document/d/<ID>/edit` |
| Append text | `$GWS docs +write --document <ID> --text "…"` (plain text, appended at the end) |
| Read | `$GWS docs documents get --params '{"documentId":"<ID>"}'` — JSON structure; extract `body.content[].paragraph.elements[].textRun.content` for plain text |
| Plain-text export | `$GWS drive files export --params '{"fileId":"<ID>","mimeType":"text/plain"}' --output doc.txt` (simpler than parsing `get`) |
| Batch edit | `$GWS docs documents batchUpdate --params '{"documentId":"<ID>"}' --json '{"requests":[ … ]}'` |

## batchUpdate request examples

```json
{"requests":[
  {"replaceAllText":{"containsText":{"text":"{{name}}","matchCase":true},"replaceText":"김민수"}},
  {"insertText":{"location":{"index":1},"text":"제목\n"}},
  {"updateParagraphStyle":{"range":{"startIndex":1,"endIndex":3},"paragraphStyle":{"namedStyleType":"HEADING_1"},"fields":"namedStyleType"}}
]}
```

- Index 1 is the start of the body; inserting shifts later indexes, so order requests from the end backwards when doing several inserts.
- For a new document with content: `create` → `+write` (simple) or `batchUpdate` (headings/formatting).
- Check request shapes with `$GWS schema docs.documents.batchUpdate`.
