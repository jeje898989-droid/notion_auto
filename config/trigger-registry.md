# Trigger Registry

> Role: Defines the location, specification, and interpretation rules of the Notion "Trigger Keyword" DB.
> Keyword values themselves are managed by the user directly in Notion — this file holds the specification only.

## 1. Trigger DB Location

| Item | Value |
|---|---|
| DB name | 트리거 키워드 |
| Database ID | `418ce7a3-ff80-817f-9dd0-fa7bd45e62ec` |
| Data source | `collection://418ce7a3-ff80-8185-958c-000b0d1780d7` |
| URL | https://app.notion.com/p/418ce7a3ff80817f9dd0fa7bd45e62ec |
| Parent page | 내 일정 관리 (`412ce7a3-ff80-809b-9346-c2cfc3a73039`) |
| Created | 2026-11-14 |

## 2. Column Specification (written by the user in Notion)

| Column | Notion Type | Example / Values |
|---|---|---|
| 키워드 (Keyword) | title | `개인` |
| 별칭 (Aliases) | text, comma-separated | `사적, private` |
| 대상 DB (Target DB) | URL | URL of the target Notion DB |
| 작업 유형 (Task Type) | select | 등록 (Register) / 조회 (Query) / GWS |
| 후속 GWS (Follow-up GWS) | select, optional | 없음 (None) / Calendar / Gmail / Docs |
| 기본 속성값 (Default Property Values) | text, optional | `분류=약속` |
| 사용 여부 (Enabled) | checkbox | |
| 설명 (Description) | text | |

- Target DB is stored as a **URL**; extract the DB ID from it and match it against `config/notion-schema.md`.

## 3. Registered Example Rows (as of 2026-11-14)

| Keyword | Aliases | Target DB | Task Type | Follow-up GWS |
|---|---|---|---|---|
| 개인 | 사적, private | 개인 일정 | 등록 | Calendar |
| 업무 | | 업무 일정 | 등록 | 없음 |
| 확인 | | 업무 일정 | 조회 | 없음 |
| 메일 | | - | GWS | Gmail |
| 공부 | 학습, study | 학습 일정 | 등록 | 없음 |

> This table is only a snapshot. Notion is the source of truth — always read the live DB (via cache).

## 4. Interpretation Rules

- Ignore rows with `사용 여부 = false`.
- Report an error on duplicate keywords or aliases.

## 5. Cache Policy

- Cache file: `workspace/cache/trigger-map.json`
- Refreshed when:
  - a session starts,
  - a cache miss occurs,
  - the user requests "트리거 새로고침" (refresh triggers).
