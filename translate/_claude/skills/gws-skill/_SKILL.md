---
name: gws-skill
description: (한글 번역) `gws` CLI로 터미널에서 사용자의 Google Workspace를 다룬다 — Gmail(안 읽은 메일 요약, 읽기, 검색, 초안/답장/전달을 초안으로), Google Calendar(일정 조회, 일정 생성·수정, 빈 시간 조회), Docs(생성, 본문 추가, 읽기, 일괄 편집), Sheets(생성, 범위 읽기, 행 추가·수정), Drive(검색, 업로드, 내보내기/다운로드, 공유)와 서비스 간 워크플로(회의 준비, 주간 요약). 인증정보는 skill 자체의 .env에서 자동으로 불러오므로 단독으로 동작한다. 사용자가 Gmail, Google Calendar, Google Docs/Sheets/Drive에서 무언가를 조회·검색·생성·변경하려 할 때 — 예: "오늘 일정 보여줘", "안 읽은 메일 요약", "드라이브에서 보고서 찾아줘", "이 내용으로 메일 초안", "시트에 한 줄 추가" — 또는 gws 명령 사용법이나 gws 인증 문제를 물을 때, "gws"라는 말이 없어도 이 skill을 사용한다. 프로젝트에 승인 플랜 실행기(예: workspace/approvals/를 쓰는 gws-execute skill)가 있으면 승인된 플랜 실행은 그쪽이 맡고, 이 skill은 명령 레퍼런스 역할을 한다.
---

# gws-skill

Google Workspace CLI(`@googleworkspace/cli`, 명령어 `gws`, v0.22.5에서 확인)용 독립형 도구 모음.
모든 명령은 `scripts/gws.sh`를 거쳐 실행된다. 이 스크립트가 skill의 `.env`에서 OAuth client 인증정보를 불러온 뒤 `gws`를 호출하므로, skill 폴더를 다른 프로젝트에 복사해도 그대로 쓸 수 있다.

아래에서 `$GWS`는 `bash <이 skill 폴더>/scripts/gws.sh`를 뜻한다 (절대 경로 사용).

## 1. 첫 명령 전에: 준비 상태 점검

세션마다 한 번 `bash <skill 폴더>/scripts/check.sh`를 실행한다. 읽기 전용이며 `OK / WARN / FAIL` 줄과 `NEXT` 안내를 출력한다.

| 결과 | 조치 |
|---|---|
| `READY` | 그대로 진행. |
| node / gws 없음 | (먼저 사용자에게 확인 후) 설치: `npm install -g @googleworkspace/cli@0.22.5` (Node.js LTS 필요). |
| `.env` 없음 또는 비어 있음 | `.env.example` → `.env` 복사 후 OAuth client JSON 값으로 채운다. `references/auth-setup.md` 참고. |
| 로그인 안 됨 / 토큰 무효 | `scripts/login.sh`를 백그라운드로 실행하고, 출력된 URL을 사용자에게 열어 로그인하게 한다. `references/auth-setup.md` §4 참고. |

세션 중 명령이 종료 코드 **2**로 끝나면 "토큰 무효"와 같은 뜻이다. 명령을 재시도하지 말고 로그인 절차를 다시 실행한다.

## 2. 작업 흐름

1. **서비스를 정하고 해당 레퍼런스만 읽는다**:
   `references/gmail.md`, `calendar.md`, `docs.md`, `sheets.md`, `drive.md`, `workflow.md`. 플래그, 출력 형식, 종료 코드, 문제 해결은 `references/common.md`.
2. **읽기 전용 요청**(일정, 메일 요약, 검색, 읽기): 바로 실행하고, 원시 JSON이 아니라 읽기 쉬운 표/요약으로 보여준다. `--format table`이나 `fields`로 출력을 줄인다.
3. **쓰기 작업**(생성, 추가, 수정, 공유, 초안): 실행할 정확한 명령(필요하면 `--dry-run` 결과도)을 보여주고 승인을 받은 뒤 실행한다. 생성된 항목의 ID와 링크를 보고한다.
4. **모르는 메서드나 파라미터**: 추측하기 전에 `$GWS schema <service.resource.method>` 또는 `$GWS <service> <resource> --help`로 확인한다. JSON 본문을 추측하는 것이 종료 코드 3의 주된 원인이다.

## 3. 안전 규칙 (그리고 이유)

- **메일은 초안부터.** `+send / +reply / +reply-all / +forward`에는 `--draft`를 붙인다. 저장된 초안 발송(`users drafts send`)은 사용자가 *그 초안*의 발송을 명시적으로 승인한 뒤에만 한다. 보낸 메일은 되돌릴 수 없지만 초안은 부담이 없다.
- **파괴적 명령 금지**: `delete`, `trash`, `emptyTrash`, `batchDelete`, `values clear/batchClear`, `events delete`. 요청받으면 이 skill의 범위 밖임을 설명하고 Google 화면에서 직접 하도록 안내한다. 삭제된 Workspace 데이터는 복구가 안 되는 경우가 많다.
- **공유는 한 번에 한 건**, 역할과 이메일을 확인한 뒤 진행한다. 일괄 권한 변경은 파일이 넓게 노출될 수 있다.
- **수신자, 참석자, 날짜를 미리보기에서 다시 확인한다.** 잘못된 주소와 잘못된 시간대가 실제로 가장 흔한 실수다.
- **`.env` 내용이나 토큰을 출력하지 않는다.** `gws auth export`를 실행하지 않는다.

## 4. 명령 요약표

| 서비스 | 작업 | 명령 |
|---|---|---|
| Gmail | 안 읽은 메일 요약 | `$GWS gmail +triage --max 10 --format table` |
| Gmail | 메일 읽기 | `$GWS gmail +read --id <MSG_ID> --headers` |
| Gmail | 검색 | `$GWS gmail users messages list --params '{"userId":"me","q":"from:kim newer_than:7d","maxResults":10}'` |
| Gmail | 새 메일 초안 | `$GWS gmail +send --to a@x.com --subject "…" --body "…" --draft` |
| Gmail | 답장 / 전달 초안 | `$GWS gmail +reply --message-id <ID> --body "…" --draft` · `+forward --message-id <ID> --to b@x.com --draft` |
| Gmail | 승인된 초안 발송 | `$GWS gmail users drafts send --params '{"userId":"me"}' --json '{"id":"<DRAFT_ID>"}'` |
| Calendar | 일정 조회 | `$GWS calendar +agenda --today` / `--tomorrow` / `--week` / `--days 3` |
| Calendar | 일정 생성 | `$GWS calendar +insert --summary "…" --start 2026-11-25T14:00:00+09:00 --end 2026-11-25T15:00:00+09:00 [--location …] [--attendee …] [--meet]` |
| Calendar | 빈 시간 조회 | `$GWS calendar freebusy query --json '{…}'` |
| Docs | 생성 / 본문 추가 | `$GWS docs documents create --json '{"title":"…"}'` · `$GWS docs +write --document <ID> --text "…"` |
| Sheets | 생성 / 읽기 / 행 추가 | `$GWS sheets spreadsheets create --json '{"properties":{"title":"…"}}'` · `+read --spreadsheet <ID> --range 'Sheet1!A1:D20'` · `+append --spreadsheet <ID> --values 'a,b,c'` |
| Drive | 검색 | `$GWS drive files list --params '{"q":"name contains '\''보고서'\'' and trashed=false","pageSize":10,"fields":"files(id,name,mimeType,modifiedTime,webViewLink)"}' --format table` |
| Drive | 업로드 / 공유 | `$GWS drive +upload ./file.pdf [--parent <FOLDER_ID>]` · `$GWS drive permissions create --params '{"fileId":"<ID>"}' --json '{"role":"reader","type":"user","emailAddress":"…"}'` |
| Workflow | 회의 준비 / 주간 요약 | `$GWS workflow +meeting-prep` · `$GWS workflow +weekly-digest --format table` |

## 5. 규칙

- **시간**: 사용자 오프셋을 붙인 RFC 3339. 예: 한국은 `2026-11-25T14:00:00+09:00`. "내일 2시" 같은 상대 날짜는 오늘 날짜 기준으로 절대 날짜로 바꾸고, 미리보기에 절대값을 보여준다.
- **URL에서 ID 추출**: Docs/Sheets/Drive ID는 `/d/<ID>/`의 긴 부분. Gmail 메시지 ID는 `+triage`나 `messages list`에서 얻는다.
- **파일 경로는 현재 디렉터리 안이어야 한다.** `--upload`, `--output`, `+upload <file>`은 작업 디렉터리 밖 경로를 거부한다 (종료 코드 3, "outside the current directory"). 프로젝트 폴더로 `cd`하거나 파일을 그 안으로 복사한 뒤 `outputs/report.pdf` 같은 상대 경로를 쓴다.
- **큰 JSON**: 인라인으로 이스케이프하지 말고 파일로 만든 뒤 `--json "$(cat body.json)"`으로 넘긴다.
- **stderr 메시지**: `Using keyring backend: keyring` 줄은 안내 메시지이므로 무시한다.

## 6. 권한 범위

기본 `.env`는 Gmail(작성 + 읽기), Calendar, Docs, Sheets, Drive 권한을 요청한다. Tasks, Slides, Chat, Forms, Keep, People, Meet와 `gmail +watch`(Pub/Sub)는 추가 scope가 필요하다. `.env`의 `GWS_SCOPES`에 추가하고 `scripts/login.sh`를 다시 실행한다. `403 insufficient scopes` / `ACCESS_TOKEN_SCOPE_INSUFFICIENT` 오류가 바로 이 경우다.
