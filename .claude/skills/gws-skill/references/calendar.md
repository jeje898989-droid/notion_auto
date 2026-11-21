# Google Calendar

Scope: `calendar` (full read/write). `calendarId` is `primary` for the user's main calendar.

## Read

| Task | Command |
|---|---|
| Agenda | `$GWS calendar +agenda --today` · `--tomorrow` · `--week` · `--days 3` · `[--calendar <name/ID>] [--timezone Asia/Seoul] --format table` |
| Events in a range | `$GWS calendar events list --params '{"calendarId":"primary","timeMin":"2026-11-24T00:00:00+09:00","timeMax":"2026-11-29T00:00:00+09:00","singleEvents":true,"orderBy":"startTime","fields":"items(id,summary,start,end,location,htmlLink)"}' --format table` |
| Keyword search | add `"q":"회의"` to the `events list` params |
| One event | `$GWS calendar events get --params '{"calendarId":"primary","eventId":"<ID>"}'` |
| Calendars | `$GWS calendar calendarList list --format table` |
| Free/busy | `$GWS calendar freebusy query --json '{"timeMin":"…","timeMax":"…","items":[{"id":"primary"}]}'` |

`+agenda` covers all calendars and is the quickest answer to "오늘/이번 주 일정". Use `events list` when you need IDs (for updates) or a custom range.

## Write

| Task | Command |
|---|---|
| Create | `$GWS calendar +insert --summary "…" --start <RFC3339> --end <RFC3339> [--location "…"] [--description "…"] [--attendee a@x.com …] [--meet] [--calendar <ID>]` |
| Natural-language create | `$GWS calendar events quickAdd --params '{"calendarId":"primary","text":"내일 오후 3시 치과"}'` (parsing of Korean is unreliable; prefer `+insert`) |
| All-day event | `$GWS calendar events insert --params '{"calendarId":"primary"}' --json '{"summary":"…","start":{"date":"2026-11-25"},"end":{"date":"2026-11-26"}}'` (end date is exclusive) |
| Update fields | `$GWS calendar events patch --params '{"calendarId":"primary","eventId":"<ID>"}' --json '{"location":"…"}'` |
| Invite emails | add `"sendUpdates":"all"` to params — this emails attendees, so confirm first |

- Default duration when the user gives only a start time: 1 hour, and say so in the preview.
- Always include the offset (`+09:00`); a bare time or `Z` shifts the event.
- Report the created event's `htmlLink`.
- `events delete` is out of scope for this skill.
