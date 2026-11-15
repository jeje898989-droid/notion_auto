# CLAUDE.md

> Role: Project-wide orchestration rules (always loaded at session start)

## 1. Project Purpose

- Classify user requests and register/query the matching Notion DB → report → get approval → execute GWS (Google Workspace) actions.

## 2. Work Approval Process (Todo List First)

- Before starting any task the user requests, output a **todo list** of the planned steps and report it first.
- Proceed with the work **only after the user approves** the todo list.
- If the plan changes during execution, report the updated todo list and get approval again.

## 3. Standard Processing Flow

1. **[Classify]** Classify the request and determine the target DB and task type.
2. **[Confirm]** Present the content to be registered / execution plan to the user.
3. **[Execute]** Register in Notion (`notion-writer`) or execute GWS (`gws-executor`).

- DB creation requests: present the DB spec (name / parent page / columns & types) → approval → create via `notion-writer`.
- Filter/analysis requests: `notion-analyst` filters by date, status, assignee, etc. and reports the results.

## 4. Absolute Rules

- No Notion writes, email sending, or file creation before approval.
- GWS execution is allowed only for plans marked `approved` in `workspace/approvals/`.
- Mail via GWS CLI: always create a **draft first**; send only after the user approves sending that draft.
- Record every write/execution result in `logs/`.

## 5. Task Type → Skill Mapping

| Task Type | Skill |
|---|---|
| Register | `notion-db-register` |
| Query/analysis | `notion-db-analyze` |
| GWS | `gws-execute` |

## 6. Documentation Rules (.md files)

- All `.md` files must be written in **English**.
- A Korean translation of each `.md` file must be written separately in the `translate/` folder.
- Every file/folder name saved in `translate/` **must be prefixed with `_`**.
  - e.g. translation of `CLAUDE.md` → `translate/_CLAUDE.md`
  - e.g. translation of the `.claude` folder → `translate/_claude/`
- Keep the original and its translation in sync: when an English `.md` is created or updated, create or update its translation as well.

## 7. References, Response Language, Report Format

- Reference documents
  - `config/` — trigger registry, Notion schema, GWS commands
  - `templates/` — mail templates (`templates/mail/`), report templates (`templates/report/`)
  - `outputs/` — result files (reports, exports, generated documents)
- Response language: Korean (technical terms and identifiers keep their original form).
- Report format: follow `templates/report/` templates; always include the todo list, results, and log location.

## 8. Memo Classification Rules

When the user enters a memo, classify it by its prefix, read the matching rule file, and save it to Notion.

| Prefix | Rule file to read | Target DB |
|---|---|---|
| `개인:` | `.claude/rules/nt-personal.md` | Personal Tasks DB (개인 일정) |
| `업무:` | `.claude/rules/nt-work.md` | Work DB (업무 일정) |
| `배움:` / `공부:` / `강의:` | `.claude/rules/nt-study.md` | Study DB (학습 일정) |

- The prefix decides the target DB and overrides the classification criteria in the rule files; use the rule file only for property mapping. The approval preview shows the DB, so the user can correct it there.
- The approval process always applies: present the property mapping → user approval → register via `notion-writer` (§4 still holds).
- If a required value (e.g. date) is missing, ask the user before presenting the mapping.
- After saving, output exactly one line: `저장됨: [DB name]` (this replaces the full report format for prefixed memos).
