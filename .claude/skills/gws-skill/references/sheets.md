# Google Sheets

Scope: `spreadsheets`. Spreadsheet ID = the segment in `docs.google.com/spreadsheets/d/<ID>/edit`. Ranges use A1 notation: `Sheet1!A1:D20`, `'시트 1'!A:A` (quote names with spaces).

## Read

| Task | Command |
|---|---|
| Read a range | `$GWS sheets +read --spreadsheet <ID> --range 'Sheet1!A1:D20'` |
| Several ranges | `$GWS sheets spreadsheets values batchGet --params '{"spreadsheetId":"<ID>","ranges":["A1:B5","Sheet2!A:A"]}'` |
| Sheet (tab) names | `$GWS sheets spreadsheets get --params '{"spreadsheetId":"<ID>","fields":"sheets.properties(title,sheetId)"}'` |

## Write

| Task | Command |
|---|---|
| Create | `$GWS sheets spreadsheets create --json '{"properties":{"title":"…"},"sheets":[{"properties":{"title":"Data"}}]}'` |
| Append one row | `$GWS sheets +append --spreadsheet <ID> --values '홍길동,100,2026-11-21'` |
| Append many rows | `$GWS sheets +append --spreadsheet <ID> --json-values '[["a","b"],["c","d"]]'` |
| Overwrite a range | `$GWS sheets spreadsheets values update --params '{"spreadsheetId":"<ID>","range":"Sheet1!A1:C1","valueInputOption":"USER_ENTERED"}' --json '{"values":[["이름","점수","날짜"]]}'` |
| Add a tab / formatting | `$GWS sheets spreadsheets batchUpdate --params '{"spreadsheetId":"<ID>"}' --json '{"requests":[{"addSheet":{"properties":{"title":"요약"}}}]}'` |

- `+append` writes after the last row of the first table on the first sheet; use `values append` with a `range` param to target another tab.
- `USER_ENTERED` parses numbers, dates and formulas (`=SUM(B2:B10)`); `RAW` stores text as is.
- `--values` splits on commas — use `--json-values` when a cell contains a comma.
- Overwrites (`values update`) replace existing data: show the target range in the preview.
- `values clear` / `batchClear` are out of scope for this skill.
