# Docs 참조 문서 (한글 번역본)

> 출처: `gws docs --help` (gws 0.22.5)

## 문서 생성

```
gws docs documents create --json '{"title":"<제목>"}'
```

- `documentId`를 반환한다. 링크: `https://docs.google.com/document/d/<documentId>/edit`

## 텍스트 추가

```
gws docs +write ...
```

- 명령을 구성하기 전에 `gws docs +write --help`로 정확한 옵션을 확인한다.

## 고급 편집

- `gws docs documents batchUpdate`를 사용하고, `gws schema docs.documents.batchUpdate`로 구조를 확인한다.

## 템플릿

- 보고서: `templates/report/task-report.md`
