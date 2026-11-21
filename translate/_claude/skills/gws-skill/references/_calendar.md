# Google Calendar (한글 번역)

Scope: `calendar` (전체 읽기/쓰기). 사용자 기본 캘린더의 `calendarId`는 `primary`.

## 읽기

| 작업 | 명령 |
|---|---|
| 일정 조회 | `$GWS calendar +agenda --today` · `--tomorrow` · `--week` · `--days 3` · `[--calendar <이름/ID>] [--timezone Asia/Seoul] --format table` |
| 기간 내 일정 | `$GWS calendar events list --params '{"calendarId":"primary","timeMin":"2026-11-24T00:00:00+09:00","timeMax":"2026-11-29T00:00:00+09:00","singleEvents":true,"orderBy":"startTime","fields":"items(id,summary,start,end,location,htmlLink)"}' --format table` |
| 키워드 검색 | `events list` params에 `"q":"회의"` 추가 |
| 일정 하나 | `$GWS calendar events get --params '{"calendarId":"primary","eventId":"<ID>"}'` |
| 캘린더 목록 | `$GWS calendar calendarList list --format table` |
| 빈 시간 조회 | `$GWS calendar freebusy query --json '{"timeMin":"…","timeMax":"…","items":[{"id":"primary"}]}'` |

`+agenda`는 모든 캘린더를 포함하며 "오늘/이번 주 일정"에 가장 빠른 답이다. ID가 필요하거나(수정용) 기간을 직접 지정할 때는 `events list`를 쓴다.

## 쓰기

| 작업 | 명령 |
|---|---|
| 생성 | `$GWS calendar +insert --summary "…" --start <RFC3339> --end <RFC3339> [--location "…"] [--description "…"] [--attendee a@x.com …] [--meet] [--calendar <ID>]` |
| 자연어 생성 | `$GWS calendar events quickAdd --params '{"calendarId":"primary","text":"내일 오후 3시 치과"}'` (한국어 해석이 불안정하므로 `+insert` 권장) |
| 종일 일정 | `$GWS calendar events insert --params '{"calendarId":"primary"}' --json '{"summary":"…","start":{"date":"2026-11-25"},"end":{"date":"2026-11-26"}}'` (종료일은 포함되지 않음) |
| 필드 수정 | `$GWS calendar events patch --params '{"calendarId":"primary","eventId":"<ID>"}' --json '{"location":"…"}'` |
| 초대 메일 | params에 `"sendUpdates":"all"` 추가 — 참석자에게 메일이 가므로 먼저 확인 |

- 사용자가 시작 시간만 말하면 기본 1시간으로 하고 미리보기에 그렇게 적는다.
- 항상 오프셋(`+09:00`)을 붙인다. 오프셋 없는 시간이나 `Z`는 일정이 밀린다.
- 생성된 일정의 `htmlLink`를 보고한다.
- `events delete`는 이 skill 범위 밖이다.
