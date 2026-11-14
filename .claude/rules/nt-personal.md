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
| 일정 (title) | Core action, e.g. `친구와 카페약속` |
| 날짜 | Absolute date; datetime if a time is given (**required** — ask if missing) |
| 분류 | 약속 / 운동 / 취미 / 기타 (do **not** use 공부 — study goes to the Study DB) |
| 상태 | Default `예정` |
| 메모 | Location, attendees, other details |

## Procedure

1. Classify as personal per the criteria above. If it could also be work or study → ask the user.
2. Register through `notion-db-register` → user approval → `notion-writer`.
3. Never register without approval.
