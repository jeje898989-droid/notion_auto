# nt-work

> Rule: Save **work-related** to-dos to the Notion Work DB.

## Target DB

| Item | Value |
|---|---|
| DB | 업무 일정 (Work) |
| Database ID | `82beb145-7f9f-4186-b85b-b619e96cbb02` |
| Data source | `collection://5cb7d5ec-8592-4927-b3cb-a55643cbf7da` |

## What Counts as Work

- Job-related to-dos: reports, meetings, deadlines, projects, clients, colleagues, business trips, work emails.
- **Not** work: private life (→ [nt-personal](nt-personal.md)) or self-study (→ [nt-study](nt-study.md)), even if work-adjacent (e.g. studying for a certificate = study).

## Property Mapping

| Property | Rule |
|---|---|
| 업무이름 (title) | Core task, e.g. `주간 보고서 작성` |
| 등록날짜 (date) | Date the item is registered — default today (entered manually, not auto) |
| 마감일 | Absolute due date (ask if missing) |
| 공동작업자 (text) | Collaborators mentioned, e.g. `김대리, 박과장` |
| 전송메일 (email) | Recipient email address if mentioned |
| 중요도 | 높음 / 보통 / 낮음 — default `보통`; "급함/ASAP" → 높음 |

- Legacy columns 상태 / 프로젝트 / 메모 still exist in the DB (kept for old rows) but are **not filled** for new items.

## Procedure

1. Classify as work per the criteria above. If it could also be personal or study → ask the user.
2. Register through `notion-db-register` → user approval → `notion-writer`.
3. Never register without approval.
