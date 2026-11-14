# nt-study

> Rule: Save **study/learning-related** to-dos to the Notion Study DB.

## Target DB

| Item | Value |
|---|---|
| DB | 학습 일정 (Study) |
| Database ID | `418ce7a3-ff80-81f9-b5ec-cdb4d238bb72` |
| Data source | `collection://418ce7a3-ff80-81b9-b2f2-000b301b899e` |

## What Counts as Study

- Learning to-dos: lectures, courses, reading for learning, assignments, exams, certificates, language study, coding practice.
- **All** study items go here — never to 개인 일정 with `분류 = 공부`.
- **Not** study: hobbies without a learning goal (→ [nt-personal](nt-personal.md)) or work tasks (→ [nt-work](nt-work.md)).

## Property Mapping

| Property | Rule |
|---|---|
| 할 일 (title) | Core task, e.g. `영어 단어 50개 암기` |
| 날짜 | Absolute date; datetime if a time is given (ask if missing) |
| 과목 | Subject, e.g. 영어, 파이썬, 정보처리기사 |
| 상태 | Default `예정` |
| 메모 | Materials, pages, links, other details |

## Procedure

1. Classify as study per the criteria above. If it could also be personal or work → ask the user.
2. Register through `notion-db-register` → user approval → `notion-writer`.
3. Never register without approval.
