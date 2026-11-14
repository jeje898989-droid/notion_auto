# GWS Commands (한글 번역본)

> 역할: GWS CLI 사용 레퍼런스 (실행 에이전트가 따르는 명령 사전)
> CLI: `@googleworkspace/cli` v0.22.5 (`gws`) — 2026-11-14 확인

## 1. 설치·인증

- 설치: `npm install -g @googleworkspace/cli@0.22.5` (Node.js 필요)
- 버전 확인: `gws --version`
- OAuth 클라이언트 설정 (최초 1회, gcloud 필요): `gws auth setup`
  - 또는 OAuth 클라이언트 JSON을 `~/.config/gws/client_secret.json`에 두거나, `GOOGLE_WORKSPACE_CLI_CLIENT_ID` / `GOOGLE_WORKSPACE_CLI_CLIENT_SECRET`을 설정한다.
- 로그인 (브라우저 열림): `gws auth login`
- 인증 상태 확인: `gws auth status` → `auth_method`가 `none`이 아니어야 한다.
- 로그아웃: `gws auth logout`

## 2. 작업별 명령 형식

기본 형식: `gws <service> <resource> [sub-resource] <method> --params '<JSON>' --json '<JSON>'`
헬퍼 명령은 `+`로 시작한다. API 메서드 구조는 `gws schema <service.resource.method>`로 확인한다.

| 서비스 | 작업 | 명령 형식 |
|---|---|---|
| Gmail | 초안 생성 | `gws gmail +send --to <이메일> --subject <제목> --body <본문> --draft` |
| Gmail | 기존 초안 전송 (전송 승인 후) | `gws gmail users drafts send --params '{"userId":"me"}' --json '{"id":"<draftId>"}'` |
| Gmail | 초안 목록 | `gws gmail users drafts list --params '{"userId":"me"}'` |
| Docs | 문서 생성 | `gws docs documents create --json '{"title":"<제목>"}'` |
| Docs | 본문 작성 (추가) | `gws docs +write ...` (`gws docs +write --help` 참고) |
| Sheets | 시트 생성 | `gws sheets spreadsheets create --json '{"properties":{"title":"<제목>"}}'` |
| Sheets | 값 입력 (행 추가) | `gws sheets +append ...` (`gws sheets +append --help` 참고) |
| Drive | 업로드 | `gws drive +upload ...` (`gws drive +upload --help` 참고) |
| Drive | 공유 권한 | `gws drive permissions create --params '{"fileId":"<id>"}' --json '{"role":"reader","type":"user","emailAddress":"<이메일>"}'` |
| Calendar | 일정 생성 | `gws calendar +insert --summary <제목> --start <RFC3339> --end <RFC3339> [--location <장소>] [--description <설명>] [--attendee <이메일>]` |

- 시간은 로컬 오프셋을 포함한 RFC3339 형식을 쓴다. 예: `2026-11-15T14:00:00+09:00`.
- 실행 전 `--dry-run`으로 요청을 검증할 수 있다.

## 3. 입력 파일 규칙

- 큰 JSON 파라미터는 `workspace/outputs/`에 생성한 후 경로로 전달한다.

## 4. 허용·금지 명령

- 허용: 2장에 기재된 명령 형식, `gws auth status`, `--help` / `gws schema`.
- **메일: `--draft` 없이 `gws gmail +send`를 절대 실행하지 않는다.** 전송은 사용자가 전송을 승인한 후 기존 초안을 `drafts send`로만 한다.
- 금지: 삭제(`delete`, `trash`, `emptyTrash`), 권한 일괄 변경, `gws auth export`, 계획에 없는 모든 명령.

## 5. 자주 발생하는 오류와 대응

| 종료 코드 | 의미 | 대응 |
|---|---|---|
| 1 | API 오류 (Google이 오류 반환) | 오류 메시지 보고, ID·권한 확인 |
| 2 | 인증 오류 (자격 증명 없음/유효하지 않음) | 중단, 사용자에게 `gws auth login` 실행 요청 |
| 3 | 검증 오류 (잘못된 인자) | `--help` / `gws schema` 기준으로 인자 수정 후 1회 재시도 |
| 4 | Discovery 오류 (API 스키마 조회 실패) | 네트워크 확인 후 나중에 재시도 |
| 5 | 내부 오류 | 중단 후 보고 |
