---
name: notion-db-analyze
description: Notion 조회·분석 요청 처리 — 예) "이번 주 마감 뭐 있어?", "지연된 업무 정리해줘", "11월 개인 일정 보여줘", "오늘 공부할 거 알려줘". 대상 DB와 조건을 해석하고 notion-analyst 서브에이전트로 필터링한 뒤 결과를 보고. 읽기 전용 — Notion에 절대 쓰지 않음.
allowed-tools: Read, Write, Agent, mcp__notion__notion-search, mcp__notion__notion-fetch, mcp__notion__notion-query-data-sources, mcp__notion__notion-query-multiple-data-sources
---

# notion-db-analyze

Notion DB에 대한 조회·분석 요청을 처리한다.

> **읽기 전용: 이 스킬에서는 Notion 작성 금지.** (`Write`는 `workspace/reports/`의 보고서용으로만 사용.)

## 1단계 — 대상 DB 결정

- rules 파일(`nt-personal`, `nt-work`, `nt-study`)을 기준으로 요청 표현에서 대상을 추론한다:
  - 일정, 약속, 개인 → 개인 일정
  - 업무, 마감, 프로젝트, 우선순위 → 업무 일정
  - 공부, 학습, 강의, 시험, 과목 → 학습 일정
  - 내 작업, 할 일 → 내 작업
- 불분명하면 → rules 파일에 정의된 DB 3개 전체를 조회한다.
- 결과가 달라질 만큼 모호하면 → 한 번 질문한다.

## 2단계 — 조건 파싱

| 조건 | 예시 | 매핑 |
|---|---|---|
| 날짜 | 오늘, 내일, 이번 주, 이번 달, 지연, 11월 | 절대 날짜 범위 (한 주 = 월~일) |
| 상태 | 진행 중, 완료 안 된, 예정 | DB의 실제 상태 옵션 |
| 담당자 | 내 것, 나에게 할당된 | `담당자` (내 작업) |
| 기타 | 중요도 높음, 프로젝트 X, 과목 영어, 분류 운동 | 해당 속성 |

- 가능하면 `config/notion-schema.md` 5장의 표준 쿼리를 사용한다.
- 맞는 속성이 없는 조건 → 사용자에게 알리고 질문, 추측 금지.

## 3단계 — notion-analyst로 필터링

- `notion-analyst` 서브에이전트에 전달: 대상 DB, 파싱된 조건, 요청 원문.

## 4단계 — 보고

`templates/report/task-report.md` 형식으로 보고한다:
1. 적용 조건
2. 요약 (총 건수 / 상태별 / 지연)
3. 결과 표
4. 주의 항목 (지연, 마감 임박)
5. 선택적 후속 제안 — **제안만**; Notion 변경은 승인을 거쳐 `notion-db-register`로, GWS 작업은 `gws-execute`로.

- 결과가 없으면 → 그 사실과 사용한 조건을 보여준다.

## 금지

- Notion 페이지·DB 생성, 수정, 삭제.
- GWS 명령 실행.
