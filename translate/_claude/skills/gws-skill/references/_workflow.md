# 서비스 간 워크플로 (`gws workflow`, 별칭 `wf`) (한글 번역)

| 헬퍼 | 기능 | 필요 서비스 | 기본 scope |
|---|---|---|---|
| `$GWS workflow +meeting-prep [--calendar <ID>]` | 다음 회의: 안건, 참석자, 연결 문서 | Calendar, Drive | ✅ |
| `$GWS workflow +weekly-digest [--format table]` | 이번 주 회의 + 안 읽은 메일 수 | Calendar, Gmail | ✅ |
| `$GWS workflow +standup-report [--format table]` | 오늘 회의 + 미완료 할 일 | Calendar, **Tasks** | ❌ `tasks` scope 추가 필요 |
| `$GWS workflow +email-to-task --message-id <ID> [--tasklist <ID>]` | Gmail 메일을 Google Tasks 할 일로 변환 | Gmail, **Tasks** | ❌ `tasks` scope 추가 필요 |
| `$GWS workflow +file-announce …` | Drive 파일을 Chat 스페이스에 공지 | Drive, **Chat** | ❌ `chat.messages` scope 추가 필요 |

모두 `--dry-run`과 `--format`을 지원한다.

## 직접 흐름 구성하기

단일 서비스 명령을 이어 붙이고 사용자에게 요약한다. 예:

- **"내일 회의 준비해줘"**: `calendar +agenda --tomorrow` → 회의마다 제목을 `q`에 넣어 `drive files list` → 요약 표(시간, 제목, 참석자, 관련 문서).
- **"이번 주 받은 메일 중 회의 요청 정리"**: `gmail users messages list q="newer_than:7d (회의 OR 미팅)"` → 각각 `+read` → 표 → `calendar +insert` 미리보기 제안 (쓰기 단계는 승인 필요).
- **"회의록 문서 만들고 참석자에게 공유 메일 초안"**: `docs documents create` → `+write` → 문서 링크를 넣어 `gmail +send … --draft` (쓰기 2건 → 미리보기 1번에 묶어 승인 1번).

scope 추가: `.env`의 `GWS_SCOPES`에 추가하고(예: `https://www.googleapis.com/auth/tasks`) `scripts/login.sh`를 다시 실행한다.
