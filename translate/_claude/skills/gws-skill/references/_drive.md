# Google Drive (한글 번역)

Scope: `drive` (전체). 파일 ID = `/d/<ID>/` 또는 `?id=<ID>`의 해당 부분.

## 검색 및 조회

| 작업 | 명령 |
|---|---|
| 검색 | `$GWS drive files list --params '{"q":"<검색식>","pageSize":10,"orderBy":"modifiedTime desc","fields":"files(id,name,mimeType,modifiedTime,webViewLink)"}' --format table` |
| 파일 메타데이터 | `$GWS drive files get --params '{"fileId":"<ID>","fields":"id,name,mimeType,size,owners,webViewLink,parents"}'` |
| 접근 권한 목록 | `$GWS drive permissions list --params '{"fileId":"<ID>"}' --format table` |
| 저장 공간 / 계정 | `$GWS drive about get --params '{"fields":"user,storageQuota"}'` |

`q` 문법: `name contains '보고서'`, `fullText contains '예산'`, `mimeType='application/vnd.google-apps.spreadsheet'`, `'<FOLDER_ID>' in parents`, `modifiedTime > '2026-11-01T00:00:00'`, `starred=true`, `sharedWithMe`; `and` / `or`로 조합; 휴지통 제외는 `trashed=false`.

주요 mimeType: Docs `application/vnd.google-apps.document`, Sheets `…spreadsheet`, Slides `…presentation`, 폴더 `…folder`, PDF `application/pdf`.

## 다운로드 / 내보내기

| 작업 | 명령 |
|---|---|
| Google 파일 내보내기 | `$GWS drive files export --params '{"fileId":"<ID>","mimeType":"application/pdf"}' --output ./out.pdf` (`text/plain`, `text/csv`, `application/vnd.openxmlformats-officedocument.wordprocessingml.document`도 가능) |
| 바이너리 파일 다운로드 | `$GWS drive files get --params '{"fileId":"<ID>","alt":"media"}' --output ./file.ext` |

다운로드는 사용자가 예상하는 위치(예: `outputs/`)에 저장하고 위치를 알려준다.

## 쓰기

| 작업 | 명령 |
|---|---|
| 업로드 | `$GWS drive +upload ./report.pdf [--parent <FOLDER_ID>] [--name "새 이름.pdf"]` |
| 업로드하며 Google 문서로 변환 | `$GWS drive files create --json '{"name":"문서","mimeType":"application/vnd.google-apps.document"}' --upload ./file.docx` |
| 폴더 생성 | `$GWS drive files create --json '{"name":"프로젝트","mimeType":"application/vnd.google-apps.folder"}'` |
| 복사 | `$GWS drive files copy --params '{"fileId":"<ID>"}' --json '{"name":"사본"}'` |
| 이름 변경 / 이동 | `$GWS drive files update --params '{"fileId":"<ID>","addParents":"<NEW>","removeParents":"<OLD>"}' --json '{"name":"…"}'` |
| 공유 (한 명) | `$GWS drive permissions create --params '{"fileId":"<ID>","sendNotificationEmail":false}' --json '{"role":"reader","type":"user","emailAddress":"a@x.com"}'` |

- 역할: `reader`, `commenter`, `writer`. `"type":"anyone"`으로 공유하면 파일이 공개되므로 명시적으로 확인한다.
- 명령 하나에 권한 하나; 일괄 권한 변경 없음.
- `files delete`, `emptyTrash`, 휴지통 이동은 이 skill 범위 밖이다.
