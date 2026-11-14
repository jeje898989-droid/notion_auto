# Calendar Reference

> Source: `gws calendar +insert --help` (gws 0.22.5)

## Create Event

```
gws calendar +insert --summary '<title>' --start '<RFC3339>' --end '<RFC3339>'
```

| Option | Description |
|---|---|
| `--summary` | Event title (required) |
| `--start` / `--end` | RFC3339 times, e.g. `2026-11-15T14:00:00+09:00` (required) |
| `--location` | Location |
| `--description` | Description |
| `--attendee <EMAIL>` | Attendee (repeatable) |
| `--meet` | Add a Google Meet link |
| `--calendar <ID>` | Calendar ID (default: `primary`) |
| `--dry-run` | Validate without executing |

## Mapping from Notion (개인 일정)

| Notion | Option |
|---|---|
| 일정 | `--summary` |
| 날짜 (start) | `--start` |
| 날짜 (end), or start + 1h if none | `--end` |
| Location in 메모 | `--location` |

- All-day items (no time): ask the user for a time, or confirm a default.
- Timezone: `+09:00` (KST).

## Show Upcoming Events

```
gws calendar +agenda
```
