# nt-personal

> Rule: Save **personal** to-dos to the Notion Personal Tasks DB.

## Target DB

| Item | Value |
|---|---|
| DB | 개인 일정 (Personal Tasks) |
| Database ID | `bdf037d2-af15-4e6a-8944-77524c2fd85e` |
| Data source | `collection://ac86ce0e-5079-4e11-a0c1-b3b8f74b85f8` |

## What Counts as Personal

- Private life to-dos and appointments: meeting friends/family, hobbies, exercise, errands, chores, health, shopping.
- **Not** personal: anything for work/job/clients (→ [nt-work](nt-work.md)) or learning/studying (→ [nt-study](nt-study.md)).

## Property Mapping

| Property | Rule |
|---|---|
| 일정이름 (title) | Core action, e.g. `친구와 카페약속` |
| 날짜 | Absolute date; datetime if a time is given (**required** — ask if missing) |
| 사람 (text) | People involved, e.g. `민수, 엄마` |
| 중요도 | 높음 / 보통 / 낮음 — default `보통`; "중요/꼭" → 높음 |
| 위치 (text) | Place, e.g. `강남역 스타벅스` |

- Legacy columns 분류 / 상태 / 메모 still exist in the DB (kept for old rows) but are **not filled** for new items.

## Procedure

1. Classify as personal per the criteria above. If it could also be work or study → ask the user.
2. Register through `notion-db-register` → user approval → `notion-writer`.
3. Never register without approval.
