# Google Docs (한글 번역)

Scope: `documents`. 문서 ID = `docs.google.com/document/d/<ID>/edit`의 해당 부분.

| 작업 | 명령 |
|---|---|
| 생성 | `$GWS docs documents create --json '{"title":"회의록 2026-11-21"}'` → `documentId` 반환; 링크 `https://docs.google.com/document/d/<ID>/edit` |
| 본문 추가 | `$GWS docs +write --document <ID> --text "…"` (일반 텍스트, 끝에 추가) |
| 읽기 | `$GWS docs documents get --params '{"documentId":"<ID>"}'` — JSON 구조; 일반 텍스트는 `body.content[].paragraph.elements[].textRun.content`에서 추출 |
| 텍스트로 내보내기 | `$GWS drive files export --params '{"fileId":"<ID>","mimeType":"text/plain"}' --output doc.txt` (`get` 파싱보다 간단) |
| 일괄 편집 | `$GWS docs documents batchUpdate --params '{"documentId":"<ID>"}' --json '{"requests":[ … ]}'` |

## batchUpdate 요청 예시

```json
{"requests":[
  {"replaceAllText":{"containsText":{"text":"{{name}}","matchCase":true},"replaceText":"김민수"}},
  {"insertText":{"location":{"index":1},"text":"제목\n"}},
  {"updateParagraphStyle":{"range":{"startIndex":1,"endIndex":3},"paragraphStyle":{"namedStyleType":"HEADING_1"},"fields":"namedStyleType"}}
]}
```

- 인덱스 1이 본문 시작이다. 삽입하면 뒤 인덱스가 밀리므로, 여러 곳에 삽입할 때는 뒤에서부터 앞으로 순서를 잡는다.
- 내용이 있는 새 문서: `create` → `+write`(단순) 또는 `batchUpdate`(제목/서식).
- 요청 구조는 `$GWS schema docs.documents.batchUpdate`로 확인한다.
