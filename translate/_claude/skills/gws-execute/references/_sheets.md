# Sheets 참조 문서 (한글 번역본)

> 출처: `gws sheets --help` (gws 0.22.5)

## 스프레드시트 생성

```
gws sheets spreadsheets create --json '{"properties":{"title":"<제목>"}}'
```

- `spreadsheetId`를 반환한다. 링크: `https://docs.google.com/spreadsheets/d/<spreadsheetId>/edit`

## 행 추가

```
gws sheets +append ...
```

## 값 읽기

```
gws sheets +read ...
```

- 명령을 구성하기 전에 `gws sheets +append --help` / `gws sheets +read --help`로 정확한 옵션을 확인한다.
- 데이터가 크면 JSON을 `workspace/outputs/`에 작성하고 경로로 전달한다.
