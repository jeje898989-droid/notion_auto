# 2026-11-15 DB Schema Update (Personal / Work / Study)

## Todo List

1. [x] Change Notion schemas of the 3 DBs (run directly — `notion-writer` has no schema tool)
2. [x] Verify (updated schemas returned by each call)
3. [x] Update docs: rules (3), `config/notion-schema.md` (+ translations)
4. [x] Record the result in `logs/` (+ translation)
5. [x] Report

## Notion Results (`notion-update-data-source`)

| DB | Data source | Changes | Status |
|---|---|---|---|
| 개인 일정 | `collection://ac86ce0e-5079-4e11-a0c1-b3b8f74b85f8` | Renamed 일정 → 일정이름; added 사람 (text), 중요도 (select 높음/보통/낮음), 위치 (text) | Success |
| 업무 일정 | `collection://5cb7d5ec-8592-4927-b3cb-a55643cbf7da` | Renamed 업무 → 업무이름, 우선순위 → 중요도; added 등록날짜 (date), 공동작업자 (text), 전송메일 (email) | Success |
| 학습 일정 | `collection://418ce7a3-ff80-81b9-b2f2-000b301b899e` | Renamed 할 일 → 학습주제, 날짜 → 마감일; added 요약 (text) | Success |

- No columns deleted (user choice). Legacy columns kept: 개인 분류/상태/메모, 업무 상태/프로젝트/메모, 학습 과목/상태/메모. Renames preserve existing data.

## Documentation Updated

| File | Change |
|---|---|
| `.claude/rules/nt-personal.md`, `nt-work.md`, `nt-study.md` | Property mapping rewritten for new columns; legacy columns marked "not filled" |
| `config/notion-schema.md` | Property tables, extraction rules, defaults, standard queries (study queries now use 마감일; overdue queries handle empty 상태) |
| `.claude/skills/notion-db-register/SKILL.md`, `.claude/skills/notion-db-analyze/SKILL.md` | 우선순위 → 중요도 references |
| `translate/` counterparts of all the above | Synced |
