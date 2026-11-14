# Drive 참조 문서 (한글 번역본)

> 출처: `gws drive --help` (gws 0.22.5)

## 업로드

```
gws drive +upload ...
```

- 명령을 구성하기 전에 `gws drive +upload --help`로 정확한 옵션을 확인한다.

## 공유 권한

```
gws drive permissions create --params '{"fileId":"<id>"}' --json '{"role":"reader","type":"user","emailAddress":"<이메일>"}'
```

| 필드 | 값 |
|---|---|
| `role` | `reader` / `commenter` / `writer` |
| `type` | `user` / `group` / `domain` / `anyone` |

- 계획에 기재된 수신자에게만 공유한다. 계획에 명시되지 않은 한 `type: anyone`은 절대 사용하지 않는다.

## 파일 목록

```
gws drive files list --params '{"pageSize": 10}'
```

## 금지

- `delete`, `trash`, `emptyTrash`, 권한 일괄 변경.
