# 인증 설정 및 재인증 (한글 번역)

`scripts/check.sh`가 FAIL을 보고하거나 명령이 종료 코드 2로 끝날 때 읽는다.

## 1. 인증정보 흐름

```
.env (CLIENT_ID / CLIENT_SECRET / PROJECT_ID / GWS_SCOPES)
   └─ scripts/gws.sh가 환경변수로 export → gws auth login → 브라우저 동의
        └─ 토큰은 ~/.config/gws/credentials.enc에 암호화 저장 (OS keyring)
```

- `.env`에는 **OAuth client**(어떤 앱이 요청하는지)가 들어 있다. **사용자 토큰**은 로그인으로 생성되며 `.env`가 아니라 `~/.config/gws/`에 저장된다.
- 이미 환경에 설정된 변수가 `.env`보다 우선한다. 다른 .env를 쓰려면 `GWS_ENV_FILE=<경로>`를 설정한다.

## 2. 설치 (check.sh가 없다고 할 때만, 먼저 확인)

```bash
winget install OpenJS.NodeJS.LTS          # Windows, node가 없을 때
npm install -g @googleworkspace/cli@0.22.5
gws --version
```

## 3. OAuth client 만들기 (최초 1회, .env가 비어 있을 때만)

`gws auth setup`은 프로젝트 생성과 API 사용 설정은 할 수 있지만(gcloud 필요) **OAuth client는 만들지 못한다.** Cloud Console에서 진행한다. Playwright로 양식을 채울 수 있지만, 정책 동의 클릭과 모든 로그인은 사용자가 직접 해야 한다.

1. 프로젝트: `gcloud projects create <id>` (처음 쓰는 계정은 먼저 Console에서 Cloud 서비스 약관에 동의해야 한다 — 오류 "Callers must accept Terms of Service").
2. API 사용 설정: `gcloud services enable gmail.googleapis.com calendar-json.googleapis.com docs.googleapis.com sheets.googleapis.com drive.googleapis.com --project <id>`
3. `https://console.cloud.google.com/auth/overview?project=<id>` → **시작하기**: 앱 이름, 지원 이메일 → 대상 **외부** → 연락처 이메일 → *사용자가 사용자 데이터 정책에 동의하고 만들기 클릭* ("OAuth 개요" 페이지가 뜰 때까지 기다린 뒤 이동해야 한다. 그렇지 않으면 설정이 저장되지 않는다).
4. `…/auth/audience` → **Add users** → 사용자 본인의 Gmail 주소 → 저장 (앱이 *테스트 중*인 동안 필요).
5. `…/auth/clients/create` → 애플리케이션 유형 **데스크톱 앱** → 만들기 → **JSON 다운로드**.
6. `.env`에 값을 넣는다:
   `GOOGLE_WORKSPACE_CLI_CLIENT_ID` ← `installed.client_id`, `GOOGLE_WORKSPACE_CLI_CLIENT_SECRET` ← `installed.client_secret`, `GOOGLE_WORKSPACE_PROJECT_ID` ← `installed.project_id`.
   다운로드한 JSON이 repo 안에 저장됐다면 이후 삭제한다.

## 4. 로그인 / 재인증

```bash
bash <skill 폴더>/scripts/login.sh     # 백그라운드로 실행
```

- `Open this URL in your browser to authenticate:` 다음에 `https://accounts.google.com/...` URL을 출력하고 `http://localhost:<port>`로의 리디렉션을 기다린다.
- URL을 **같은 컴퓨터**의 브라우저(Playwright 또는 사용자 브라우저)로 연다. 리디렉션이 localhost로 오기 때문이다. 사용자가 계정을 고르고, "Google에서 확인하지 않은 앱"이 나오면 *고급 → (앱)으로 이동*, 권한을 모두 체크 → 계속.
- 완료되면 스크립트가 0으로 종료한다. `scripts/check.sh`로 확인한다 (`token_valid: true`).
- `--scopes`를 일부러 명시한다. `-s` 선택 화면은 TTY가 필요하며, 없으면 openid/email/profile만 조용히 요청한다.

## 5. 재인증이 반복되는 이유

**테스트 중** 상태인 외부(External) 앱은 refresh token이 약 **7일** 후 만료된다. 대략 매주 종료 코드 2가 나오므로 §4를 다시 실행한다. 이를 없애려면 앱을 게시한다 (대상 → 앱 게시). 개인 용도라면 Google은 경고 화면과 함께 미검증 앱 사용을 허용한다.

## 6. 문제 해결

| 증상 | 원인 → 해결 |
|---|---|
| `access_denied` / "앱 확인 절차를 완료하지 않음" | 테스트 사용자에 계정 없음 → §3 4단계 |
| 로그인 화면에 "이 브라우저 또는 앱이 안전하지 않을 수 있습니다" | Google이 자동화 브라우저를 차단 → 사용자의 일반 Chrome에서 URL 열기 |
| `redirect_uri_mismatch` | client 유형이 **데스크톱 앱**이 아님 → 데스크톱 client 생성 |
| `403 … API has not been used in project` | API 미사용 설정 → §3 2단계 |
| `403 insufficient scopes` | scope 누락 → `GWS_SCOPES`에 추가 후 §4 재실행 |
| 로그인 후에도 `auth_method: none` | localhost 리디렉션 전에 로그인이 중단됨 → §4 재실행 |
