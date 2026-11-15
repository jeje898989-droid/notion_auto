# 2026-11-15 Notion API Integration Log

Created via Playwright MCP at `notion.so/my-integrations` (redirects to `app.notion.com/developers/connections`).

## Steps

| Step | Action | Result |
|---|---|---|
| 1 | Open `notion.so/my-integrations` | Done (redirected to login) |
| 2 | Log in | Done (by the user, manually) |
| 3 | Create connection `notion_auto` (auth: API token / internal, workspace: personal workspace) | Done |
| 4 | Capabilities | Read / Update / Insert content ON; comments OFF; user info: none (defaults kept) |
| 5 | API token | Generated; shown only in the browser (masked). **Not** stored in files or logs |
| 6 | Content permissions | 개인 일정, 업무 일정, 학습 일정 DBs added and saved |

## Notes

- Connection ID: `419ce7a3-ff80-81ec-ad90-002711abeec7`
- Token: `ntn_****` (masked). Copy it from the connection page (Configuration tab → API token → Copy) when needed.
- An earlier connection `agent_09` (created 2026-11-08) also exists in the workspace.
- Playwright snapshots are in `.playwright-mcp/`; checked, no token in them.

## Token authentication test (2026-11-15)

| Step | Action | Result |
|---|---|---|
| 1 | Copy token (clipboard) → `.env` as `NOTION_TOKEN` (never printed; clipboard cleared) | Done (`ntn_****`, 50 chars) |
| 2 | Add `.env`, `.playwright-mcp/` to `.gitignore` | Done (verified with `git check-ignore`) |
| 3 | `GET /v1/users/me` | HTTP 200 — bot `notion_auto` |
| 3 | `GET /v1/databases/{id}` × 3 | HTTP 200 — 개인 일정 / 업무 일정 / 학습 일정 |

- Read-only calls; no Notion writes.

## Accessible pages check (2026-11-15)

`POST /v1/search` (read-only) → 4 results, `has_more: false`.

| Type | Title | Parent | ID |
|---|---|---|---|
| database | 개인 일정 | page `412ce7a3-…3039` (내 일정 관리, not shared) | `bdf037d2-af15-4e6a-8944-77524c2fd85e` |
| database | 업무 일정 | same | `82beb145-7f9f-4186-b85b-b619e96cbb02` |
| database | 학습 일정 | same | `418ce7a3-ff80-81f9-b5ec-cdb4d238bb72` |
| page | (untitled, empty) | workspace root | `419ce7a3-ff80-8083-9c85-ff529abf5dc9` |

- The untitled page was created 2026-11-15 07:18 UTC by a workspace user (source unconfirmed; this session did not click "New page"); left untouched, pending user decision.
