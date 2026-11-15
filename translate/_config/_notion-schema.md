# Notion Schema (한글 번역본)

> 역할: 트리거 대상 DB별 속성 매핑 정의
> Notion 기준 최종 확인일: 2026-11-15

## 1. DB 목록 (rules 파일의 대상 DB와 1:1 대응)

| DB | Database ID | Data Source | 상위 페이지 |
|---|---|---|---|
| 내 작업 | `7ab12238-8555-4f74-81aa-f7c8ce98bafc` | _MCP로 노출되지 않음_ — 뷰 `view://06c001bd-5f0b-45f6-bced-391bc10acd0a` 사용 | 홈 |
| 개인 일정 | `bdf037d2-af15-4e6a-8944-77524c2fd85e` | `collection://ac86ce0e-5079-4e11-a0c1-b3b8f74b85f8` | 내 일정 관리 (`412ce7a3-ff80-809b-9346-c2cfc3a73039`) |
| 업무 일정 | `82beb145-7f9f-4186-b85b-b619e96cbb02` | `collection://5cb7d5ec-8592-4927-b3cb-a55643cbf7da` | 내 일정 관리 (`412ce7a3-ff80-809b-9346-c2cfc3a73039`) |
| 학습 일정 | `418ce7a3-ff80-81f9-b5ec-cdb4d238bb72` | `collection://418ce7a3-ff80-81b9-b2f2-000b301b899e` | 내 일정 관리 (`412ce7a3-ff80-809b-9346-c2cfc3a73039`) |

- 개인 / 업무 / 학습 분류 규칙: `.claude/rules/nt-personal.md`, `nt-work.md`, `nt-study.md`.

## 2. DB별 속성 매핑

### 내 작업

| 속성 | 유형 | 비고 |
|---|---|---|
| 작업 이름 | title | |
| 상태 | status | 그룹: To-do / In progress / Complete |
| 마감일 | date | |
| 담당자 | person | |
| 소스 | _미확인_ | data source 스키마가 MCP로 노출되지 않음, Notion 화면에서 확인 필요 |

### 개인 일정

| 속성 | 유형 | 옵션 |
|---|---|---|
| 일정이름 | title | |
| 날짜 | date | 시간이 있으면 datetime으로 저장 |
| 사람 | text | |
| 중요도 | select | 높음 / 보통 / 낮음 |
| 위치 | text | |
| 분류 / 상태 / 메모 | select / select / text | 기존 컬럼 — 이전 항목 보존용, 새 항목에는 채우지 않음 |

### 업무 일정

| 속성 | 유형 | 옵션 |
|---|---|---|
| 업무이름 | title | |
| 등록날짜 | date | 직접 입력 (기본값 오늘) |
| 마감일 | date | |
| 공동작업자 | text | |
| 전송메일 | email | 받는 사람 주소 |
| 중요도 | select | 높음 / 보통 / 낮음 (우선순위에서 이름 변경) |
| 상태 / 프로젝트 / 메모 | select / text / text | 기존 컬럼 — 이전 항목 보존용, 새 항목에는 채우지 않음 |

### 학습 일정

| 속성 | 유형 | 옵션 |
|---|---|---|
| 학습주제 | title | |
| 마감일 | date | 날짜에서 이름 변경, 시간이 있으면 datetime으로 저장 |
| 요약 | text | |
| 과목 / 상태 / 메모 | text / select / text | 기존 컬럼 — 이전 항목 보존용, 새 항목에는 채우지 않음 |

## 3. 자연어 → 속성 추출 규칙

- 날짜·시간 표현을 절대값으로 변환한다 (예: "내일" → `2026-11-15`).
- 시간이 있으면 날짜 속성에 datetime으로 저장한다 (`is_datetime = 1`).
- 개인 일정: 시간은 `날짜`(datetime)에, 장소는 `위치`에, 함께하는 사람은 `사람`에 기록한다.
- 업무 일정: 공동작업자는 `공동작업자`에, 받는 사람 메일 주소는 `전송메일`에 기록한다.

## 4. 등록 시 기본값 / 필수 속성

| DB | 필수 | 기본값 |
|---|---|---|
| 개인 일정 | `일정이름`, `날짜` | `중요도 = 보통` |
| 업무 일정 | `업무이름`, `마감일` | `등록날짜 = 오늘`, `중요도 = 보통` |
| 학습 일정 | `학습주제`, `마감일` | — |
| 내 작업 | `작업 이름` | `상태 = To-do` 그룹, `담당자 = me` |

- 필수 날짜가 없으면 → 사용자에게 질문한다 (추측 금지).

## 5. DB별 표준 조회 쿼리

`{today}` = 오늘 날짜 (`YYYY-MM-DD`), 한 주 = 월요일~일요일.

### 개인 일정

| 조회 | SQL 조건 |
|---|---|
| 오늘 | `date("date:날짜:start") = {today}` |
| 지연 | `date("date:날짜:start") < {today} AND ("상태" IS NULL OR "상태" = '예정')` |
| 이번 주 | `date("date:날짜:start") BETWEEN {monday} AND {sunday}` |

### 업무 일정

| 조회 | SQL 조건 |
|---|---|
| 오늘 | `date("date:마감일:start") = {today}` |
| 지연 | `date("date:마감일:start") < {today} AND ("상태" IS NULL OR "상태" != '완료')` |
| 이번 주 | `date("date:마감일:start") BETWEEN {monday} AND {sunday}` |

### 학습 일정

| 조회 | SQL 조건 |
|---|---|
| 오늘 | `date("date:마감일:start") = {today}` |
| 지연 | `date("date:마감일:start") < {today} AND ("상태" IS NULL OR "상태" != '완료')` |
| 이번 주 | `date("date:마감일:start") BETWEEN {monday} AND {sunday}` |

- 새 항목은 상태를 비워 두므로, "지연" 조회에는 마감이 지난 새 항목이 모두 포함된다 (새 항목에는 완료 표시가 없음).

### 내 작업

- data source가 노출되지 않아 SQL을 쓸 수 없다. 뷰 `view://06c001bd-5f0b-45f6-bced-391bc10acd0a`(나에게 할당, To-do / In progress, 마감일순)를 view 모드로 조회한 뒤 마감일로 다시 거른다.

## 6. 새 DB 추가 절차

1. Notion에서 DB 생성.
2. 분류 기준과 속성 매핑을 정의하는 rules 파일 추가.
3. 이 파일에 매핑 추가.
