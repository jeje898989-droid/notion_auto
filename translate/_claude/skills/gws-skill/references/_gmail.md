# Gmail (한글 번역)

기본 .env의 scope: `gmail.compose`(초안 + 초안 발송)와 `gmail.readonly`(읽기/검색). 수정/삭제 권한 없음.

## 읽기

| 작업 | 명령 |
|---|---|
| 안 읽은 메일 요약 | `$GWS gmail +triage [--max 20] [--query 'is:unread category:primary'] [--labels] --format table` |
| 메일 한 통 읽기 | `$GWS gmail +read --id <MSG_ID> [--headers] [--html]` |
| 검색 | `$GWS gmail users messages list --params '{"userId":"me","q":"<검색어>","maxResults":10}'` → 각 id를 `+read` |
| 메일 메타데이터 | `$GWS gmail users messages get --params '{"userId":"me","id":"<ID>","format":"metadata"}'` |
| 초안 목록 | `$GWS gmail users drafts list --params '{"userId":"me"}'` |
| 라벨 | `$GWS gmail users labels list --params '{"userId":"me"}'` |

검색어(`q` / `--query`) 예: `from:kim@x.com`, `to:me`, `subject:보고서`, `is:unread`, `has:attachment`, `newer_than:7d`, `after:2026/11/01 before:2026/11/15`, `label:work`. 공백(AND)이나 `OR`로 조합한다.

`messages list`는 ID만 돌려준다. 상세는 `+read`(본문)나 `messages get … format=metadata`(헤더, 더 가벼움)로 가져온다.

## 쓰기 (초안부터)

| 작업 | 명령 |
|---|---|
| 새 초안 | `$GWS gmail +send --to a@x.com[,b@x.com] --subject "…" --body "…" [--cc …] [--bcc …] [-a ./file.pdf] [--html] --draft` |
| 답장 초안 | `$GWS gmail +reply --message-id <ID> --body "…" [--to extra@x.com] --draft` (스레드 자동 처리) |
| 전체답장 초안 | `$GWS gmail +reply-all --message-id <ID> --body "…" [--remove x@y.com] --draft` |
| 전달 초안 | `$GWS gmail +forward --message-id <ID> --to b@x.com [--body "메모"] [--no-original-attachments] --draft` |
| 기존 초안 발송 (명시적 승인 후) | `$GWS gmail users drafts send --params '{"userId":"me"}' --json '{"id":"<DRAFT_ID>"}'` |

- 사용자가 요청 내용을 보고 싶어 하면 만들기 전에 `--dry-run`으로 미리보기한다.
- 초안을 만든 뒤 draft id를 보고하고 Gmail → 임시보관함(`https://mail.google.com/mail/u/0/#drafts`)에 있다고 안내한다.
- 여러 줄 본문: 따옴표 안에 실제 줄바꿈을 넣거나 `--html`과 `<br>`을 쓴다.
- `--draft`를 빼지 않는다. 발송은 사용자가 해당 초안을 승인한 뒤 `drafts send`로만 한다.

## 기본 scope로는 불가

`+watch`(Pub/Sub와 `--project` 필요), 라벨 변경 / 보관 / 읽음 표시(`messages modify`는 `gmail.modify` 필요), 삭제/휴지통(이 skill 범위 밖).
