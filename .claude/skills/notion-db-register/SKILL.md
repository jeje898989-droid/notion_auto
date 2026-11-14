---
name: notion-db-register
description: Registers a to-do or schedule item in the matching Notion DB (personal / work / study). Classifies the input per the rules files, splits it into the target DB's properties, gets user approval, registers via the notion-writer subagent, and delegates any follow-up GWS work to gws-execute. Use for requests like "친구와 내일 2시 카페약속 등록해줘" or "보고서 금요일까지 업무에 넣어줘".
---

# notion-db-register

Register an item in the Notion DB that matches the request.

> **Never register without user approval.**

## Input

- The user's original request text.

## Step 1 — Classify & Choose Target DB

- Classify the item per the rules files (`nt-personal`, `nt-work`, `nt-study`): each defines its target DB, classification criteria, and property mapping.
- If the item could belong to more than one DB → ask the user. **Do not guess.**

## Step 2 — Split Content into Properties

1. Use the target DB's property mapping from its rules file and `config/notion-schema.md`.
2. Split the content into the DB's properties:
   - Title: the core action/subject (e.g. `친구와 카페약속`).
   - Date/time: convert relative expressions to absolute dates (today = session date). With a time → datetime.
   - Select properties (분류, 상태, 우선순위): map to existing options only; otherwise apply defaults.
   - Location, attendees, or anything without a matching property → `메모`.
3. Apply the DB defaults from `config/notion-schema.md`.
4. If a required property is missing (e.g. date) → ask the user.

## Step 3 — Confirm (Approval Gate)

Show everything in one message and wait:

```
[개인 일정] DB에 다음과 같이 등록할까요?
| 속성 | 값 |
|---|---|
| 일정 | 친구와 카페약속 |
| 날짜 | 2026-11-15 14:00 |
| 분류 | 약속 |
| 상태 | 예정 |
| 메모 | 장소: 강남 |
```

- Approve → Step 4. Edit → revise and confirm again. Cancel → stop, nothing is written.

## Step 4 — Register via notion-writer

- Call the `notion-writer` subagent with: target data source, approved property values, original content.
- Report the created page link to the user.

## Step 5 — Follow-up GWS (if any)

- If the user asked for a follow-up (calendar event, mail, etc.), or one clearly fits (e.g. a timed appointment → calendar), propose it.
- If the user agrees, create a plan file in `workspace/approvals/` (`status: pending`) per `workspace/approvals/README.md`, then delegate to `gws-execute`.

## Prohibited

- Registering without approval.
- Writing to a DB not defined in the rules files.
- Inventing select options or changing DB schema.
