# 2026-11-21 Notion → Google Calendar 동기화 로그

integration `notion_auto`에 연결된 Notion DB의 모든 일정(지난 일정 포함)을 Google Calendar(`primary`)에 DB별 색상으로 등록.

## 단계

| 단계 | 작업 | 결과 |
|---|---|---|
| 1 | Playwright로 integration 페이지 열기 (`app.notion.com/developers/connections`) → `notion_auto` → 콘텐츠 사용 권한 | 개인 일정 / 업무 일정 / 학습 일정 (+ 휴지통의 "새 페이지" 1개) |
| 2 | GWS 준비 상태 확인 (`check.sh`) | READY |
| 3 | Notion MCP OAuth (미인증 상태였음) | Playwright 브라우저에서 인증 완료 |
| 4 | 전체 행 조회 (`notion-analyst`, 읽기 전용) | 개인 1 / 업무 8 / 학습 9 = 18건, 날짜 빈 행 없음 |
| 5 | `primary` 캘린더와 중복 확인 (2025-01~2027-12) | 완전 중복 없음, 의심 4건 (S10–S13) |
| 6 | 계획서 `workspace/approvals/20261121_notion-to-calendar.json` → 사용자 A안 선택 (S10–S13 제외) | approved |
| 7 | `gws-executor`: `calendar events insert` × 14 | 성공 14 / 실패 0, 계획 상태 `done` |
| 8 | 검증 (`events list q=Notion`) | 14건 존재, colorId 정상 |

## 적용 규칙

- 색상: 개인 일정 = `4` (Flamingo, 분홍), 업무 일정 = `11` (Tomato, 빨강), 학습 일정 = `10` (Basil, 초록).
- Notion UTC 시간 → KST(`+09:00`) 변환, 종료 없음 → 1시간 일정, 날짜만 → 종일 일정.
- 참석자 / `sendUpdates` 없음 (초대 메일 미발송). 설명 = 출처 DB, 공동작업자, Notion URL.

## 생성된 일정

| Key | 제목 | 시작 (KST) | colorId | Event ID |
|---|---|---|---|---|
| P1 | 치과 방문 | 2026-11-16 14:30 | 4 | khmls8hmheq05btvppc7l11jb4 |
| W1 | 예산·홍성 납품 | 2026-11-16 (종일) | 11 | q8ga8n0ikb8beg7lavjr1eg44k |
| W2 | [키트] 구성·견적 확정 (견적 2곳 이상 비교) | 2026-11-18 18:00 | 11 | 3p0cv96l03lpim1mjr4pkdfl1g |
| W3 | [키트] 차기 점검 회의 (시안·구매 진행률 확인) | 2026-11-20 16:00 | 11 | ams0980dtbnciaetatkrgkmv8s |
| W4 | [키트] 디자인 1차 시안 제출 | 2026-11-20 17:00 | 11 | fhqrprrbm2lm31m3qjskg5gnqc |
| W5 | [키트] 시안 최종 승인 회신 | 2026-11-24 15:00 | 11 | 3fjf343ubd2q20j4hff8kq3j3g |
| W6 | [키트] 샘플 검수 | 2026-11-27 17:00 | 11 | kpci91ed2j9t7lfpbfiq3etsn4 |
| W7 | [키트] 본생산·포장 1,000세트 | 2026-12-02 18:00 | 11 | m5h74mteau4h8cag8fpbuvcqho |
| W8 | [키트] 최종 검수·인계 | 2026-12-04 17:00 | 11 | 3mi1pelc99d66v24f2n3234gj0 |
| S14 | 구몬 화상통화 | 2026-12-02 10:00 | 10 | mnsavj6jsnibe3brk1gglq7l30 |
| S15 | 구몬 화상통화 | 2026-12-09 10:00 | 10 | 84aidrcdkfl903urdrl1qitf0k |
| S16 | 구몬 화상통화 | 2026-12-16 10:00 | 10 | r8md7ffn6gqo7d3bu3sq4frrbg |
| S17 | 구몬 화상통화 | 2026-12-23 10:00 | 10 | 3rhint8ln7bk77n7nqppkkkedk |
| S18 | 구몬 화상통화 | 2026-12-30 10:00 | 10 | 1ea2hhnk4mg6ggst0nn6hmgkjo |

## 건너뜀 (중복 의심, A안)

| Key | Notion 항목 | 기존 캘린더 일정 |
|---|---|---|
| S10 / S13 | 구몬 화상통화 11-18 / 11-25 10:00 | `10시 구몬` 21:00–22:00 (시간 오입력으로 보임) |
| S11 / S12 | AI학원 11-21 / 11-22 13:00–16:00 | `Ai 학원 4` 13:00–17:00 |

## 비고

- 요청 본문: `workspace/outputs/cal_<key>.json`.
- Notion 쓰기 없음. Google Calendar 삭제/수정 없음.
