# 공통 플래그, 출력, 오류 (한글 번역)

## 명령 형식

```
$GWS <service> <resource> [sub-resource] <method> --params '<JSON>' --json '<JSON>'
$GWS <service> +<helper> [flags]          # 단축 명령
$GWS schema <service.resource.method>     # 파라미터/본문 구조
$GWS <service> [<resource>] --help         # 메서드 / 헬퍼 목록
```

`--params` = URL/쿼리 파라미터(ID, 필터, 페이지). `--json` = 요청 본문(POST/PATCH/PUT).

## 공통 플래그

| 플래그 | 용도 |
|---|---|
| `--format json\|table\|yaml\|csv` | 사용자에게 보여줄 때 `table`, 파싱할 때 `json`(기본값) |
| `--dry-run` | 보내지 않고 요청을 검증·출력 — 쓰기 미리보기에 사용 |
| `--page-all` / `--page-limit N` / `--page-delay MS` | 자동 페이지 처리 (NDJSON, 페이지당 한 줄, 기본 10페이지) |
| `--upload <PATH>` / `--upload-content-type <MIME>` | create/update 호출에 파일 첨부 |
| `--output <PATH>` | 바이너리 응답 저장 (다운로드, 내보내기) |

> `--upload` / `--output` 경로는 **현재 작업 디렉터리 안**이어야 한다. 그 밖의 절대 경로(예: `/tmp`, `C:\Users\…\Downloads`)는 종료 코드 3으로 실패한다. 프로젝트 폴더에서 상대 경로로 실행한다.

| `--api-version <VER>` | API 버전 지정 |
|---|---|

`fields` 파라미터로 응답을 줄인다. 예: `"fields":"files(id,name,webViewLink)"`, `"fields":"items(id,summary,start,end)"`.

## 환경변수 (.env로 설정)

| 변수 | 용도 |
|---|---|
| `GOOGLE_WORKSPACE_CLI_CLIENT_ID` / `_CLIENT_SECRET` | `auth login`이 쓰는 OAuth client |
| `GOOGLE_WORKSPACE_PROJECT_ID` | 할당량/결제용 프로젝트 |
| `GWS_SCOPES` | `scripts/login.sh`가 요청할 scope (skill 전용) |
| `GOOGLE_WORKSPACE_CLI_CONFIG_DIR` | `~/.config/gws` 대신 쓸 경로 |
| `GOOGLE_WORKSPACE_CLI_TOKEN` | 미리 받은 access token (최우선) |
| `GOOGLE_WORKSPACE_CLI_LOG=gws=debug` | stderr 디버그 로그 |

## 종료 코드

| 코드 | 의미 | 대응 |
|---|---|---|
| 0 | 성공 | 결과(ID, 링크) 보고 |
| 1 | API 오류 (Google이 오류 반환) | 메시지 표시; ID, 권한, API 사용 설정 확인 |
| 2 | 인증 오류 | 중단; `references/auth-setup.md` §4로 재인증 |
| 3 | 검증 오류 (잘못된 인자) | `--help` / `schema` 확인 후 수정, 1회 재시도 |
| 4 | Discovery (API 스키마를 못 가져옴) | 네트워크 문제; 나중에 재시도 |
| 5 | 내부 오류 | 중단하고 보고 |

## 셸 따옴표 팁 (Git Bash / bash)

- JSON은 작은따옴표로 감싼다. 안에 작은따옴표가 필요하면(Drive `q`) 닫고-이스케이프-다시 열기: `'"'"'` 또는 `'\''`.
- 터미널이 UTF-8이면 JSON/플래그 안의 한글은 문제없다.
- 긴 본문은 파일로 만들어 `--json "$(cat body.json)"`으로 넘긴다.
