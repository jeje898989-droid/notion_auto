# Calendar 참조 문서 (한글 번역본)

> 출처: `gws calendar +insert --help` (gws 0.22.5)

## 일정 생성

```
gws calendar +insert --summary '<제목>' --start '<RFC3339>' --end '<RFC3339>'
```

| 옵션 | 설명 |
|---|---|
| `--summary` | 일정 제목 (필수) |
| `--start` / `--end` | RFC3339 시간, 예: `2026-11-15T14:00:00+09:00` (필수) |
| `--location` | 장소 |
| `--description` | 설명 |
| `--attendee <EMAIL>` | 참석자 (반복 가능) |
| `--meet` | Google Meet 링크 추가 |
| `--calendar <ID>` | 캘린더 ID (기본값: `primary`) |
| `--dry-run` | 실행하지 않고 검증만 |

## Notion(개인 일정)에서의 매핑

| Notion | 옵션 |
|---|---|
| 일정 | `--summary` |
| 날짜 (시작) | `--start` |
| 날짜 (종료), 없으면 시작 + 1시간 | `--end` |
| 메모의 장소 | `--location` |

- 종일 항목(시간 없음): 사용자에게 시간을 묻거나 기본값을 확인받는다.
- 시간대: `+09:00` (KST).

## 다가오는 일정 보기

```
gws calendar +agenda
```
