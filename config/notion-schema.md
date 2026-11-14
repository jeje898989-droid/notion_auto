# Notion Schema

> Role: Property mapping definitions for each trigger target DB
> Last verified against Notion: 2026-11-14

## 1. DB List (1:1 with the target DBs in the rules files)

| DB | Database ID | Data Source | Parent Page |
|---|---|---|---|
| My Tasks (내 작업) | `7ab12238-8555-4f74-81aa-f7c8ce98bafc` | _not exposed via MCP_ — use view `view://06c001bd-5f0b-45f6-bced-391bc10acd0a` | 홈 |
| Personal Schedule (개인 일정) | `bdf037d2-af15-4e6a-8944-77524c2fd85e` | `collection://ac86ce0e-5079-4e11-a0c1-b3b8f74b85f8` | 내 일정 관리 (`412ce7a3-ff80-809b-9346-c2cfc3a73039`) |
| Work Schedule (업무 일정) | `82beb145-7f9f-4186-b85b-b619e96cbb02` | `collection://5cb7d5ec-8592-4927-b3cb-a55643cbf7da` | 내 일정 관리 (`412ce7a3-ff80-809b-9346-c2cfc3a73039`) |
| Study Schedule (학습 일정) | `418ce7a3-ff80-81f9-b5ec-cdb4d238bb72` | `collection://418ce7a3-ff80-81b9-b2f2-000b301b899e` | 내 일정 관리 (`412ce7a3-ff80-809b-9346-c2cfc3a73039`) |

- Classification rules for personal / work / study: `.claude/rules/nt-personal.md`, `nt-work.md`, `nt-study.md`.

## 2. Property Mapping by DB

### My Tasks (내 작업)

| Property | Type | Note |
|---|---|---|
| 작업 이름 | title | |
| 상태 | status | groups: To-do / In progress / Complete |
| 마감일 | date | |
| 담당자 | person | |
| 소스 | _unknown_ | Data source schema not exposed via MCP; confirm in Notion UI |

### Personal Schedule (개인 일정)

| Property | Type | Options |
|---|---|---|
| 일정 | title | |
| 날짜 | date | Use datetime when a time is given |
| 분류 | select | 약속 / 운동 / 공부 / 취미 / 기타 |
| 상태 | select | 예정 / 완료 / 취소 |
| 메모 | text | |

### Work Schedule (업무 일정)

| Property | Type | Options |
|---|---|---|
| 업무 | title | |
| 마감일 | date | |
| 상태 | select | 시작 전 / 진행 중 / 완료 |
| 우선순위 | select | 높음 / 보통 / 낮음 |
| 프로젝트 | text | |
| 메모 | text | |

### Study Schedule (학습 일정)

| Property | Type | Options |
|---|---|---|
| 할 일 | title | |
| 날짜 | date | Use datetime when a time is given |
| 과목 | text | |
| 상태 | select | 예정 / 진행 중 / 완료 |
| 메모 | text | |

## 3. Natural Language → Property Extraction Rules

- Convert date/time expressions to absolute values (e.g. "tomorrow" → `2026-11-15`).
- If a time is given, store it as a datetime in the date property (`is_datetime = 1`).
- Personal Schedule has **no time or location property**: time goes into `날짜` (datetime); location and attendees go into `메모`.
- Map category words to `분류` options (e.g. 약속/카페/만남 → 약속, 헬스/러닝 → 운동). If none match → `기타`.

## 4. Defaults / Required Properties on Registration

| DB | Required | Defaults |
|---|---|---|
| Personal Schedule | `일정`, `날짜` | `상태 = 예정`, `분류 = 기타` (when not inferable) |
| Work Schedule | `업무` | `상태 = 시작 전`, `우선순위 = 보통` |
| Study Schedule | `할 일` | `상태 = 예정` |
| My Tasks | `작업 이름` | `상태 = To-do` group, `담당자 = me` |

- If a required date is missing → ask the user (do not guess).

## 5. Standard Queries per DB

`{today}` = today's date (`YYYY-MM-DD`); week = Monday–Sunday.

### Personal Schedule

| Query | SQL condition |
|---|---|
| Today | `date("date:날짜:start") = {today}` |
| Overdue | `date("date:날짜:start") < {today} AND "상태" = '예정'` |
| This week | `date("date:날짜:start") BETWEEN {monday} AND {sunday}` |

### Work Schedule

| Query | SQL condition |
|---|---|
| Today | `date("date:마감일:start") = {today}` |
| Overdue | `date("date:마감일:start") < {today} AND "상태" != '완료'` |
| This week | `date("date:마감일:start") BETWEEN {monday} AND {sunday}` |

### Study Schedule

| Query | SQL condition |
|---|---|
| Today | `date("date:날짜:start") = {today}` |
| Overdue | `date("date:날짜:start") < {today} AND "상태" != '완료'` |
| This week | `date("date:날짜:start") BETWEEN {monday} AND {sunday}` |

### My Tasks

- Data source is not exposed, so SQL is unavailable. Query via view mode on `view://06c001bd-5f0b-45f6-bced-391bc10acd0a` (assigned to me, To-do / In progress, sorted by 마감일) and filter by 마감일 afterwards.

## 6. Adding a New DB

1. Create the DB in Notion.
2. Add a rules file defining its classification criteria and property mapping.
3. Add its mapping to this file.
