# Gmail 참조 문서 (한글 번역본)

> 출처: `gws gmail +send --help` (gws 0.22.5)

## 규칙

- **항상 초안 먼저.** `--draft` 없이 `+send`를 절대 실행하지 않는다. 별도의 전송 승인 후 기존 초안만 전송한다.

## 초안 생성

```
gws gmail +send --to <이메일> --subject '<제목>' --body '<본문>' --draft
```

| 옵션 | 설명 |
|---|---|
| `--to` | 수신자, 쉼표 구분 (필수) |
| `--subject` | 제목 (필수) |
| `--body` | 본문, 일반 텍스트 (필수) |
| `--html` | 본문을 HTML 조각으로 처리 (`<p>`, `<b>`, `<br>`) |
| `--cc` / `--bcc` | 참조 / 숨은참조, 쉼표 구분 |
| `-a, --attach <PATH>` | 첨부 파일 (반복 가능, 합계 25MB 이하) |
| `--from` | 발신 별칭 |
| `--dry-run` | 실행하지 않고 요청만 표시 |

- 반환된 초안 ID를 계획 파일의 `draft_id`에 기록한다.

## 기존 초안 전송 (전송 승인 후에만)

```
gws gmail users drafts send --params '{"userId":"me"}' --json '{"id":"<draftId>"}'
```

## 초안 목록

```
gws gmail users drafts list --params '{"userId":"me"}'
```

## 본문 템플릿

- `templates/mail/deadline-reminder.md`
