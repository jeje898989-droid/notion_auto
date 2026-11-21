# Google Drive

Scope: `drive` (full). File ID = the segment in `/d/<ID>/` or `?id=<ID>`.

## Search & inspect

| Task | Command |
|---|---|
| Search | `$GWS drive files list --params '{"q":"<query>","pageSize":10,"orderBy":"modifiedTime desc","fields":"files(id,name,mimeType,modifiedTime,webViewLink)"}' --format table` |
| File metadata | `$GWS drive files get --params '{"fileId":"<ID>","fields":"id,name,mimeType,size,owners,webViewLink,parents"}'` |
| Who has access | `$GWS drive permissions list --params '{"fileId":"<ID>"}' --format table` |
| Storage / account | `$GWS drive about get --params '{"fields":"user,storageQuota"}'` |

`q` syntax: `name contains '보고서'`, `fullText contains '예산'`, `mimeType='application/vnd.google-apps.spreadsheet'`, `'<FOLDER_ID>' in parents`, `modifiedTime > '2026-11-01T00:00:00'`, `starred=true`, `sharedWithMe`; join with `and` / `or`; add `trashed=false` to hide trash.

Common mimeTypes: Docs `application/vnd.google-apps.document`, Sheets `…spreadsheet`, Slides `…presentation`, Folder `…folder`, PDF `application/pdf`.

## Download / export

| Task | Command |
|---|---|
| Export Google file | `$GWS drive files export --params '{"fileId":"<ID>","mimeType":"application/pdf"}' --output ./out.pdf` (also `text/plain`, `text/csv`, `application/vnd.openxmlformats-officedocument.wordprocessingml.document`) |
| Download binary file | `$GWS drive files get --params '{"fileId":"<ID>","alt":"media"}' --output ./file.ext` |

Save downloads somewhere the user expects (e.g. `outputs/`), and say where.

## Write

| Task | Command |
|---|---|
| Upload | `$GWS drive +upload ./report.pdf [--parent <FOLDER_ID>] [--name "새 이름.pdf"]` |
| Upload & convert to Google Docs | `$GWS drive files create --json '{"name":"문서","mimeType":"application/vnd.google-apps.document"}' --upload ./file.docx` |
| Create folder | `$GWS drive files create --json '{"name":"프로젝트","mimeType":"application/vnd.google-apps.folder"}'` |
| Copy | `$GWS drive files copy --params '{"fileId":"<ID>"}' --json '{"name":"사본"}'` |
| Rename / move | `$GWS drive files update --params '{"fileId":"<ID>","addParents":"<NEW>","removeParents":"<OLD>"}' --json '{"name":"…"}'` |
| Share (one person) | `$GWS drive permissions create --params '{"fileId":"<ID>","sendNotificationEmail":false}' --json '{"role":"reader","type":"user","emailAddress":"a@x.com"}'` |

- Roles: `reader`, `commenter`, `writer`. Sharing with `"type":"anyone"` makes the file public: confirm explicitly.
- One permission per command; no bulk permission changes.
- `files delete`, `emptyTrash` and moving to trash are out of scope for this skill.
