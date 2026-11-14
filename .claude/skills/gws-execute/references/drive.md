# Drive Reference

> Source: `gws drive --help` (gws 0.22.5)

## Upload

```
gws drive +upload ...
```

- Check exact options with `gws drive +upload --help` before building the command.

## Share Permission

```
gws drive permissions create --params '{"fileId":"<id>"}' --json '{"role":"reader","type":"user","emailAddress":"<email>"}'
```

| Field | Values |
|---|---|
| `role` | `reader` / `commenter` / `writer` |
| `type` | `user` / `group` / `domain` / `anyone` |

- Share only with recipients listed in the plan. Never use `type: anyone` unless the plan explicitly says so.

## List Files

```
gws drive files list --params '{"pageSize": 10}'
```

## Prohibited

- `delete`, `trash`, `emptyTrash`, bulk permission changes.
