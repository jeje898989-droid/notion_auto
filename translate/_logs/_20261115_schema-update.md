# 2026-11-15 DB 스키마 수정 (개인 / 업무 / 학습)

## 할 일 목록

1. [x] DB 3개의 Notion 스키마 변경 (`notion-writer`에 스키마 도구가 없어 직접 실행)
2. [x] 확인 (각 호출이 돌려준 변경 후 스키마)
3. [x] 문서 수정: rules 3개, `config/notion-schema.md` (+ 번역본)
4. [x] 결과를 `logs/`에 기록 (+ 번역본)
5. [x] 보고

## Notion 결과 (`notion-update-data-source`)

| DB | Data source | 변경 내용 | 상태 |
|---|---|---|---|
| 개인 일정 | `collection://ac86ce0e-5079-4e11-a0c1-b3b8f74b85f8` | 일정 → 일정이름 이름 변경, 사람(텍스트)·중요도(선택 높음/보통/낮음)·위치(텍스트) 추가 | 성공 |
| 업무 일정 | `collection://5cb7d5ec-8592-4927-b3cb-a55643cbf7da` | 업무 → 업무이름, 우선순위 → 중요도 이름 변경, 등록날짜(날짜)·공동작업자(텍스트)·전송메일(이메일) 추가 | 성공 |
| 학습 일정 | `collection://418ce7a3-ff80-81b9-b2f2-000b301b899e` | 할 일 → 학습주제, 날짜 → 마감일 이름 변경, 요약(텍스트) 추가 | 성공 |

- 삭제한 컬럼 없음 (사용자 선택). 남겨 둔 기존 컬럼: 개인 분류/상태/메모, 업무 상태/프로젝트/메모, 학습 과목/상태/메모. 이름 변경은 기존 데이터를 그대로 유지함.

## 수정한 문서

| 파일 | 변경 |
|---|---|
| `.claude/rules/nt-personal.md`, `nt-work.md`, `nt-study.md` | 새 컬럼 기준으로 속성 매핑 재작성, 기존 컬럼은 "채우지 않음" 표시 |
| `config/notion-schema.md` | 속성 표, 추출 규칙, 기본값, 표준 조회 (학습 조회는 마감일 사용, 지연 조회는 빈 상태도 처리) |
| `.claude/skills/notion-db-register/SKILL.md`, `.claude/skills/notion-db-analyze/SKILL.md` | 우선순위 → 중요도 표기 |
| 위 파일들의 `translate/` 번역본 | 동기화 |
