# 2026-11-21 GWS CLI 설치 및 인증 로그

## 로컬 설치

| 작업 | 결과 |
|---|---|
| `npm install -g @googleworkspace/cli@0.22.5` | 재설치, `gws 0.22.5` |
| `winget install Google.CloudSDK` | Google Cloud SDK 594.0.0 설치 (`C:\Program Files (x86)\Google\Cloud SDK\`, 시스템 PATH 등록) |
| `gcloud auth login` | 로그인 완료 (Playwright로 URL 열기, 사용자 직접 로그인) |

## Google Cloud 설정

| 작업 | 결과 |
|---|---|
| Cloud 서비스 약관 동의 | 사용자가 Console에서 동의 (첫 `projects create`가 "Callers must accept Terms of Service"로 실패) |
| `gcloud projects create notion-auto-gws-11211523` | 생성, gcloud 기본 프로젝트로 설정 |
| `gcloud services enable` | gmail, calendar-json, docs, sheets, drive API 사용 설정 |
| `gws auth setup` | 3단계에서 중단: OAuth client는 Console에서 수동 생성 필요 |
| OAuth 동의 화면 (Playwright) | 앱 `gws CLI`, 외부, 테스트 중. 사용자 데이터 정책 동의 체크와 만들기는 사용자가 직접 클릭 (첫 시도는 저장되지 않아 재진행) |
| 테스트 사용자 (Playwright) | 본인 계정 추가 (1/100) |
| OAuth client (Playwright) | 데스크톱 앱 `gws CLI` 생성, JSON을 `~/.config/gws/client_secret.json`으로 이동 (repo에 남기지 않음) |

## GWS 로그인

| 작업 | 결과 |
|---|---|
| `gws auth login -s gmail,calendar,docs,sheets,drive` | 중단: TTY가 없어 scope 선택 화면이 건너뛰어지고 openid/email/profile만 요청됨 |
| `gws auth login --scopes <6개 scope>` | 성공 (사용자가 Playwright 브라우저에서 권한 동의) |
| `gws auth status` | `auth_method: oauth2`, `token_valid: true`, `has_refresh_token: true`, `storage: encrypted` |

부여된 scope: `gmail.compose`, `gmail.readonly`, `calendar`, `documents`, `spreadsheets`, `drive` (+ openid/email/profile).

## 참고

- 다시 로그인할 때는 `--scopes`를 명시하세요 (`-s` 선택 화면은 대화형 터미널이 필요함).
- 앱이 "테스트 중" 상태입니다. 외부(External) 앱이 테스트 상태이면 refresh token이 7일 후 만료되므로, exit code 2가 나오면 `gws auth login`을 다시 실행하세요.

## 문서 수정

- `config/gws-commands.md` §1 수정 (번역본 포함): `--scopes` 명시 로그인, Console OAuth client 절차, 7일 재인증 안내.
