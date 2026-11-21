# Google Sheets (한글 번역)

Scope: `spreadsheets`. 스프레드시트 ID = `docs.google.com/spreadsheets/d/<ID>/edit`의 해당 부분. 범위는 A1 표기법: `Sheet1!A1:D20`, `'시트 1'!A:A` (공백 있는 이름은 따옴표).

## 읽기

| 작업 | 명령 |
|---|---|
| 범위 읽기 | `$GWS sheets +read --spreadsheet <ID> --range 'Sheet1!A1:D20'` |
| 여러 범위 | `$GWS sheets spreadsheets values batchGet --params '{"spreadsheetId":"<ID>","ranges":["A1:B5","Sheet2!A:A"]}'` |
| 시트(탭) 이름 | `$GWS sheets spreadsheets get --params '{"spreadsheetId":"<ID>","fields":"sheets.properties(title,sheetId)"}'` |

## 쓰기

| 작업 | 명령 |
|---|---|
| 생성 | `$GWS sheets spreadsheets create --json '{"properties":{"title":"…"},"sheets":[{"properties":{"title":"Data"}}]}'` |
| 한 행 추가 | `$GWS sheets +append --spreadsheet <ID> --values '홍길동,100,2026-11-21'` |
| 여러 행 추가 | `$GWS sheets +append --spreadsheet <ID> --json-values '[["a","b"],["c","d"]]'` |
| 범위 덮어쓰기 | `$GWS sheets spreadsheets values update --params '{"spreadsheetId":"<ID>","range":"Sheet1!A1:C1","valueInputOption":"USER_ENTERED"}' --json '{"values":[["이름","점수","날짜"]]}'` |
| 탭 추가 / 서식 | `$GWS sheets spreadsheets batchUpdate --params '{"spreadsheetId":"<ID>"}' --json '{"requests":[{"addSheet":{"properties":{"title":"요약"}}}]}'` |

- `+append`는 첫 번째 시트의 첫 표 마지막 행 뒤에 쓴다. 다른 탭에 쓰려면 `range` param과 함께 `values append`를 쓴다.
- `USER_ENTERED`는 숫자, 날짜, 수식(`=SUM(B2:B10)`)을 해석하고, `RAW`는 텍스트 그대로 저장한다.
- `--values`는 쉼표로 나눈다. 셀에 쉼표가 있으면 `--json-values`를 쓴다.
- 덮어쓰기(`values update`)는 기존 데이터를 바꾸므로 미리보기에 대상 범위를 보여준다.
- `values clear` / `batchClear`는 이 skill 범위 밖이다.
