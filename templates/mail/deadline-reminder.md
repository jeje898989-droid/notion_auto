# Deadline Reminder Mail Template

> Role: Mail body template for deadline-related emails

## 1. Variables

| Variable | Meaning |
|---|---|
| `{recipient}` | Recipient name |
| `{task_list}` | List of tasks with deadlines |
| `{due_date}` | Due date |
| `{sender}` | Sender name |

## 2. Subject Format

```
[Deadline Reminder] {due_date} — tasks due
```

## 3. Body Structure

```
Hello {recipient},

The following tasks are due on {due_date}:

{task_list}

Please check the status and let me know if anything needs adjustment.

Best regards,
{sender}
```

Order: greeting → list of due tasks → request → closing.

## 4. Tone Options

- **Internal**: concise, informal-polite.
- **External**: formal, includes full context and courtesy phrases.

## 5. Adding Other Mail Templates

- Save to `templates/mail/` as `<purpose>-<type>.md` in kebab-case (e.g. `meeting-invite.md`).
- Add the Korean translation to `translate/_templates/mail/_<file-name>.md`.
