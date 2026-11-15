# 2026-11-15 Notion API Integration 로그

Playwright MCP로 `notion.so/my-integrations`에서 생성 (`app.notion.com/developers/connections`로 리다이렉트됨).

## 단계

| 단계 | 작업 | 결과 |
|---|---|---|
| 1 | `notion.so/my-integrations` 접속 | 완료 (로그인 페이지로 이동) |
| 2 | 로그인 | 완료 (사용자가 직접 진행) |
| 3 | 연결 `notion_auto` 생성 (인증: API 토큰 / 내부, 워크스페이스: 개인 워크스페이스) | 완료 |
| 4 | 기능(Capabilities) | 콘텐츠 읽기 / 업데이트 / 삽입 ON; 댓글 OFF; 사용자 정보: 없음 (기본값 유지) |
| 5 | API 토큰 | 생성됨; 브라우저에만 표시(마스킹). 파일·로그에 **저장하지 않음** |
| 6 | 콘텐츠 사용 권한 | 개인 일정, 업무 일정, 학습 일정 DB 추가 및 저장 |

## 참고

- 연결 ID: `419ce7a3-ff80-81ec-ad90-002711abeec7`
- 토큰: `ntn_****` (마스킹). 필요 시 연결 페이지(구성 탭 → API 토큰 → 복사하기)에서 복사.
- 워크스페이스에는 이전 연결 `agent_09` (2026-11-08 생성)도 있음.
- Playwright 스냅샷은 `.playwright-mcp/`에 있음; 토큰 미포함 확인.

## 토큰 인증 테스트 (2026-11-15)

| 단계 | 작업 | 결과 |
|---|---|---|
| 1 | 토큰 복사(클립보드) → `.env`에 `NOTION_TOKEN`으로 저장 (출력 안 함; 클립보드 비움) | 완료 (`ntn_****`, 50자) |
| 2 | `.gitignore`에 `.env`, `.playwright-mcp/` 추가 | 완료 (`git check-ignore`로 확인) |
| 3 | `GET /v1/users/me` | HTTP 200 — 봇 `notion_auto` |
| 3 | `GET /v1/databases/{id}` × 3 | HTTP 200 — 개인 일정 / 업무 일정 / 학습 일정 |

- 읽기 전용 호출; Notion 쓰기 없음.

## 접근 가능 페이지 확인 (2026-11-15)

`POST /v1/search` (읽기 전용) → 결과 4건, `has_more: false`.

| 종류 | 제목 | 상위 | ID |
|---|---|---|---|
| database | 개인 일정 | 페이지 `412ce7a3-…3039` (내 일정 관리, 미공유) | `bdf037d2-af15-4e6a-8944-77524c2fd85e` |
| database | 업무 일정 | 동일 | `82beb145-7f9f-4186-b85b-b619e96cbb02` |
| database | 학습 일정 | 동일 | `418ce7a3-ff80-81f9-b5ec-cdb4d238bb72` |
| page | (제목 없음, 빈 페이지) | 워크스페이스 최상위 | `419ce7a3-ff80-8083-9c85-ff529abf5dc9` |

- 제목 없는 페이지는 2026-11-15 07:18 UTC에 워크스페이스 사용자가 생성 (출처 미확인; 이 세션은 "새 페이지"를 누르지 않음); 사용자 결정 전까지 그대로 둠.
