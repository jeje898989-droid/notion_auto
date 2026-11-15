# 2026-11-15 Add Study Section to Parent Page

## Todo List

1. [x] Restructure page content via `notion-writer` (add `## 공부` heading, show 학습 일정 inline, move 트리거 키워드 to the end)
2. [x] Verify by re-fetching the page
3. [x] Record the result in `logs/` (+ translation)
4. [x] Report

## Result

| Action | Target | Change | Status |
|---|---|---|---|
| Replace page content | 개인 일정 관리 `412ce7a3-ff80-809b-9346-c2cfc3a73039` — https://app.notion.com/p/412ce7a3ff80809b9346c2cfc3a73039 | Added `## 공부` heading; 학습 일정 (`418ce7a3-ff80-81f9-b5ec-cdb4d238bb72`) moved under it and set to inline; 트리거 키워드 moved to the end | Success (verified by re-fetch) |

- No database was created or deleted; DB IDs and rows are unchanged.
- Final layout: `## 개인` → 개인 일정 (inline) / `## 업무` → 업무 일정 (inline) / `## 공부` → 학습 일정 (inline) / 트리거 키워드 (link).
