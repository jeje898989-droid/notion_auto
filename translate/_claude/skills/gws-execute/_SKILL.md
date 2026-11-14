---
name: gws-execute
description: 승인된 후속 작업을 GWS(Google Workspace) CLI로 실행 — Gmail 초안/전송, Calendar 일정, Docs, Sheets, Drive. 작업 종류를 확인하고 해당 references/ 문서를 읽어 명령을 구성한 뒤, 정확한 명령을 미리 보여주고 사용자 승인을 받으면 gws-executor 서브에이전트로 실행하고 결과 링크를 보고. 사용자의 GWS 요청(예: "이 내용으로 메일 초안 써줘") 또는 승인된 후속 계획에 사용.
---

# gws-execute

승인된 후속 작업을 GWS CLI로 실행한다.

## 입력

- `workspace/approvals/<계획ID>.json`의 계획 (`notion-db-register` 또는 `notion-db-analyze`에서 생성), 또는 사용자의 직접 GWS 요청.

## 0단계 — 사전 체크

1. `gws auth status` 실행. `auth_method`가 `none`이면 → 중단하고 GWS 미연결 상태임을 사용자에게 알린다. (2026-11-14 기준 GWS는 의도적으로 **미연결** 상태.)
2. 계획이 존재하고 상태가 다음 단계를 허용하는지 확인한다 (`workspace/approvals/README.md` 참고).

## 1단계 — 작업 종류 확인 및 참조 문서 읽기

| 작업 종류 | 참조 문서 |
|---|---|
| mail | `references/gmail.md` |
| calendar | `references/calendar.md` |
| doc | `references/docs.md` |
| sheet | `references/sheets.md` |
| drive | `references/drive.md` |

- 해당 참조 문서가 있으면 읽고 그 내용으로 명령을 구성한다.
- 없으면 `config/gws-commands.md`와 `gws <service> --help` / `gws schema`를 사용한다.
- 본문이 필요한 작업은 `templates/`의 템플릿을 채운다 (예: `templates/mail/deadline-reminder.md`).

## 2단계 — 미리보기 (승인 관문)

실행 전에 정확한 명령을 보여준다:

```
다음 명령을 실행할까요?
gws calendar +insert --summary '친구와 카페약속' --start '2026-11-15T14:00:00+09:00' --end '2026-11-15T15:00:00+09:00' --location '강남'
```

- 승인 → 계획을 `approved`로 변경 → 3단계. 수정 → 다시 구성해 미리보기. 취소 → 중단.

## 3단계 — gws-executor로 실행

- `gws-executor` 서브에이전트에 계획 ID와 승인된 명령을 전달한다.
- **메일**: 첫 실행은 **초안만** 작성 (`--draft`) → 상태 `draft_created` → 초안을 보여주고 "이 초안을 그대로 전송할까요?" 질문 → 승인 시에만 `send_approved`로 바꾸고 `draft_id`로 초안 전송.

## 4단계 — 보고

- 생성물 링크/ID (일정, 초안, 문서, 시트, 파일).
- 실패 항목의 원인과 다음 조치.
- `logs/`의 로그 위치.

## 금지

- 미리보기로 보여주지 않은 명령 실행.
- 별도의 전송 승인 없는 메일 전송.
- 삭제 또는 권한 일괄 변경.
