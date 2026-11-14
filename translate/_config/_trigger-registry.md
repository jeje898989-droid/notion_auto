# Trigger Registry (한글 번역본)

> 역할: Notion "트리거 키워드" DB의 위치·규격·해석 규칙 정의.
> 키워드 값 자체는 사용자가 Notion에서 직접 관리 — 이 파일에는 규격만 기재한다.

## 1. 트리거 DB 위치

| 항목 | 값 |
|---|---|
| DB 이름 | 트리거 키워드 |
| Database ID | `418ce7a3-ff80-817f-9dd0-fa7bd45e62ec` |
| Data source | `collection://418ce7a3-ff80-8185-958c-000b0d1780d7` |
| URL | https://app.notion.com/p/418ce7a3ff80817f9dd0fa7bd45e62ec |
| 상위 페이지 | 내 일정 관리 (`412ce7a3-ff80-809b-9346-c2cfc3a73039`) |
| 생성일 | 2026-11-14 |

## 2. 컬럼 규격 (사용자가 Notion에 작성)

| 컬럼 | Notion 유형 | 예시 / 값 |
|---|---|---|
| 키워드 | title | `개인` |
| 별칭 | text, 쉼표 구분 | `사적, private` |
| 대상 DB | URL | 대상 Notion DB의 URL |
| 작업 유형 | select | 등록 / 조회 / GWS |
| 후속 GWS | select, 선택 | 없음 / Calendar / Gmail / Docs |
| 기본 속성값 | text, 선택 | `분류=약속` |
| 사용 여부 | checkbox | |
| 설명 | text | |

- 대상 DB는 **URL**로 저장한다. URL에서 DB ID를 추출해 `config/notion-schema.md`와 대조한다.

## 3. 등록된 예시 행 (2026-11-14 기준)

| 키워드 | 별칭 | 대상 DB | 작업 유형 | 후속 GWS |
|---|---|---|---|---|
| 개인 | 사적, private | 개인 일정 | 등록 | Calendar |
| 업무 | | 업무 일정 | 등록 | 없음 |
| 확인 | | 업무 일정 | 조회 | 없음 |
| 메일 | | - | GWS | Gmail |
| 공부 | 학습, study | 학습 일정 | 등록 | 없음 |

> 이 표는 스냅샷일 뿐이다. 단일 출처는 Notion이므로 항상 실제 DB(캐시 경유)를 읽는다.

## 4. 해석 규칙

- `사용 여부 = false`인 행은 무시한다.
- 키워드·별칭 중복 시 오류를 보고한다.

## 5. 캐시 정책

- 캐시 파일: `workspace/cache/trigger-map.json`
- 갱신 조건:
  - 세션 시작 시,
  - 캐시 미스 발생 시,
  - 사용자가 "트리거 새로고침"을 요청할 때.
