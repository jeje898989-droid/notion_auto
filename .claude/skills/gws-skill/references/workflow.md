# Cross-service workflows (`gws workflow`, alias `wf`)

| Helper | What it does | Needs | Default scopes |
|---|---|---|---|
| `$GWS workflow +meeting-prep [--calendar <ID>]` | Next meeting: agenda, attendees, linked docs | Calendar, Drive | ✅ |
| `$GWS workflow +weekly-digest [--format table]` | This week's meetings + unread mail count | Calendar, Gmail | ✅ |
| `$GWS workflow +standup-report [--format table]` | Today's meetings + open tasks | Calendar, **Tasks** | ❌ add `tasks` scope |
| `$GWS workflow +email-to-task --message-id <ID> [--tasklist <ID>]` | Turn a Gmail message into a Google Task | Gmail, **Tasks** | ❌ add `tasks` scope |
| `$GWS workflow +file-announce …` | Announce a Drive file in a Chat space | Drive, **Chat** | ❌ add `chat.messages` scope |

All accept `--dry-run` and `--format`.

## Composing your own flows

Chain the single-service commands and summarize for the user. Examples:

- **"내일 회의 준비해줘"**: `calendar +agenda --tomorrow` → for each meeting, `drive files list` with the meeting title in `q` → summary table (time, title, attendees, related docs).
- **"이번 주 받은 메일 중 회의 요청 정리"**: `gmail users messages list q="newer_than:7d (회의 OR 미팅)"` → `+read` each → table → offer `calendar +insert` previews (write steps need approval).
- **"회의록 문서 만들고 참석자에게 공유 메일 초안"**: `docs documents create` → `+write` → `gmail +send … --draft` with the doc link (two writes → one combined preview, one approval).

To add a scope: append it to `GWS_SCOPES` in `.env` (e.g. `https://www.googleapis.com/auth/tasks`) and re-run `scripts/login.sh`.
