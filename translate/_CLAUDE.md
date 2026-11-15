# CLAUDE.md (한글 번역본)

> 역할: 프로젝트 전체 오케스트레이션 규칙 (세션 시작 시 항상 로드)

## 1. 프로젝트 목적

- 사용자 요청을 분류하여 해당 Notion DB에 등록/조회 → 보고 → 승인 → GWS(Google Workspace) 실행.

## 2. 작업 승인 절차 (Todo List 선보고)

- 사용자가 요청한 작업을 시작하기 전, 진행할 단계의 **todo list**를 출력하여 먼저 보고한다.
- todo list가 **사용자에게 승인된 후에만** 작업을 진행한다.
- 실행 중 계획이 변경되면 수정된 todo list를 다시 보고하고 재승인을 받는다.

## 3. 표준 처리 흐름

1. **[분류]** 요청을 분류하여 대상 DB·작업 유형 결정
2. **[확인]** 등록할 내용 / 실행 계획을 사용자에게 제시
3. **[실행]** Notion 등록(`notion-writer`) 또는 GWS 실행(`gws-executor`)

- DB 생성 요청: DB 명세(이름 / 상위 페이지 / 컬럼·유형) 제시 → 승인 → `notion-writer`로 생성.
- 필터링·분석 요청: `notion-analyst`가 날짜·상태·담당자 등으로 필터링하고 결과를 보고.

## 4. 절대 규칙

- 승인 전 Notion 쓰기·메일 발송·파일 생성 금지.
- GWS 실행은 `workspace/approvals/`의 `approved` 계획만 허용.
- GWS CLI 메일: 항상 **초안을 먼저 작성**하고, 사용자가 해당 초안의 전송을 승인한 후에만 전송.
- 모든 쓰기·실행 결과는 `logs/`에 기록.

## 5. 작업 유형 → 스킬 매핑

| 작업 유형 | 스킬 |
|---|---|
| 등록 | `notion-db-register` |
| 조회·분석 | `notion-db-analyze` |
| GWS | `gws-execute` |

## 6. 문서 작성 규칙 (.md 파일)

- 모든 `.md` 파일은 **영어**로 작성한다.
- 각 `.md` 파일의 한글 번역본은 `translate/` 폴더에 별도로 작성한다.
- `translate/`에 저장되는 모든 파일/폴더 이름 앞에는 **반드시 `_`를 붙인다**.
  - 예) `CLAUDE.md`의 번역본 → `translate/_CLAUDE.md`
  - 예) `.claude` 폴더의 번역본 → `translate/_claude/`
- 원본과 번역본은 동기화를 유지한다: 영어 `.md`를 생성·수정하면 번역본도 함께 생성·수정한다.

## 7. 참조 문서 위치, 응답 언어, 보고 형식

- 참조 문서
  - `config/` — 트리거 레지스트리, Notion 스키마, GWS 명령어
  - `templates/` — 메일 템플릿(`templates/mail/`), 보고서 템플릿(`templates/report/`)
  - `outputs/` — 결과 파일 (보고서, 내보내기 파일, 생성 문서)
- 응답 언어: 한글 (기술 용어와 식별자는 원문 유지)
- 보고 형식: `templates/report/` 템플릿을 따르며, todo list·실행 결과·로그 위치를 항상 포함한다.

## 8. 메모 분류 규칙

사용자가 메모를 입력하면 prefix로 분류하고, 해당 rules 파일을 읽은 뒤 Notion에 저장한다.

| Prefix | 읽을 rules 파일 | 대상 DB |
|---|---|---|
| `개인:` | `.claude/rules/nt-personal.md` | Personal Tasks DB (개인 일정) |
| `업무:` | `.claude/rules/nt-work.md` | Work DB (업무 일정) |
| `배움:` / `공부:` / `강의:` | `.claude/rules/nt-study.md` | Study DB (학습 일정) |

- prefix가 대상 DB를 결정하며 rules 파일의 분류 기준보다 우선한다. rules 파일은 속성 매핑에만 사용한다. 승인 미리보기에 DB가 표시되므로 사용자가 그 단계에서 바로잡을 수 있다.
- 승인 절차는 항상 적용한다: 속성 매핑 제시 → 사용자 승인 → `notion-writer`로 등록 (§4 유지).
- 필수 값(예: 날짜)이 빠져 있으면 매핑을 제시하기 전에 사용자에게 되묻는다.
- 저장 완료 후 정확히 한 줄만 출력한다: `저장됨: [DB명]` (prefix 메모에 한해 전체 보고 형식을 대체한다).
