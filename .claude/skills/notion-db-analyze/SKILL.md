---
name: notion-db-analyze
description: Handles Notion query/analysis requests — e.g. "이번 주 마감 뭐 있어?", "지연된 업무 정리해줘", "11월 개인 일정 보여줘", "오늘 공부할 거 알려줘". Interprets target DBs and conditions, filters via the notion-analyst subagent, and reports results. Read-only — never writes to Notion.
allowed-tools: Read, Write, Agent, mcp__notion__notion-search, mcp__notion__notion-fetch, mcp__notion__notion-query-data-sources, mcp__notion__notion-query-multiple-data-sources
---

# notion-db-analyze

Handle query/analysis requests on the Notion DBs.

> **Read-only: no Notion writes in this skill.** (`Write` is only for reports in `workspace/reports/`.)

## Step 1 — Resolve Target DBs

- Infer the target from the request wording, using the rules files (`nt-personal`, `nt-work`, `nt-study`):
  - 일정, 약속, 개인 → 개인 일정
  - 업무, 마감, 프로젝트, 우선순위 → 업무 일정
  - 공부, 학습, 강의, 시험, 과목 → 학습 일정
  - 내 작업, 할 일 → 내 작업
- If unclear → query all three DBs defined in the rules files.
- If the request is ambiguous enough to change the result → ask once.

## Step 2 — Parse Conditions

| Condition | Examples | Mapping |
|---|---|---|
| Date | 오늘, 내일, 이번 주, 이번 달, 지연, 11월 | absolute date range (week = Mon–Sun) |
| Status | 진행 중, 완료 안 된, 예정 | DB's actual status options |
| Assignee | 내 것, 나에게 할당된 | `담당자` (My Tasks) |
| Others | 중요도 높음, 프로젝트 X, 과목 영어, 분류 운동 | matching property |

- Use the standard queries in `config/notion-schema.md` section 5 where possible.
- A condition with no matching property → tell the user and ask; never guess.

## Step 3 — Filter via notion-analyst

- Call the `notion-analyst` subagent with: target DBs, parsed conditions, original request.

## Step 4 — Report

Report in the `templates/report/task-report.md` format:
1. Conditions applied
2. Summary (total / by status / overdue)
3. Result table
4. Attention items (overdue, due soon)
5. Optional follow-up suggestions — **suggestions only**; any Notion change goes through `notion-db-register` with approval, any GWS work through `gws-execute`.

- No results → say so and show the conditions used.

## Prohibited

- Creating, updating, or deleting Notion pages or DBs.
- Running GWS commands.
