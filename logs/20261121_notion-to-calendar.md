# 2026-11-21 Notion → Google Calendar Sync Log

Register all schedules from the Notion DBs connected to integration `notion_auto` (incl. past items) in Google Calendar (`primary`), color-coded by DB.

## Steps

| Step | Action | Result |
|---|---|---|
| 1 | Open integration page via Playwright (`app.notion.com/developers/connections`) → `notion_auto` → Content access | 개인 일정 / 업무 일정 / 학습 일정 (+1 trashed "새 페이지") |
| 2 | GWS readiness (`check.sh`) | READY |
| 3 | Notion MCP OAuth (was unauthenticated) | Authenticated via Playwright browser |
| 4 | Query all rows (`notion-analyst`, read-only) | 개인 1 / 업무 8 / 학습 9 = 18 rows, no empty dates |
| 5 | Duplicate check vs. `primary` (2025-01..2027-12) | No exact duplicates; 4 suspected (S10–S13) |
| 6 | Plan `workspace/approvals/20261121_notion-to-calendar.json` → user chose option A (skip S10–S13) | approved |
| 7 | `gws-executor`: `calendar events insert` × 14 | 14 succeeded / 0 failed; plan status `done` |
| 8 | Verification (`events list q=Notion`) | 14 events present with correct colorId |

## Rules Applied

- Colors: 개인 일정 = `4` (Flamingo, pink), 업무 일정 = `11` (Tomato, red), 학습 일정 = `10` (Basil, green).
- Notion UTC times converted to KST (`+09:00`); no end → 1-hour event; date-only → all-day.
- No attendees / `sendUpdates` (no invitation emails). Description = source DB, collaborators, Notion URL.

## Created Events

| Key | Summary | Start (KST) | colorId | Event ID |
|---|---|---|---|---|
| P1 | 치과 방문 | 2026-11-16 14:30 | 4 | khmls8hmheq05btvppc7l11jb4 |
| W1 | 예산·홍성 납품 | 2026-11-16 (all day) | 11 | q8ga8n0ikb8beg7lavjr1eg44k |
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

## Skipped (suspected duplicates, option A)

| Key | Notion item | Existing calendar event |
|---|---|---|
| S10 / S13 | 구몬 화상통화 11-18 / 11-25 10:00 | `10시 구몬` at 21:00–22:00 (time looks mis-entered) |
| S11 / S12 | AI학원 11-21 / 11-22 13:00–16:00 | `Ai 학원 4` 13:00–17:00 |

## Notes

- Request bodies: `workspace/outputs/cal_<key>.json`.
- No Notion writes. No deletes/updates in Google Calendar.
