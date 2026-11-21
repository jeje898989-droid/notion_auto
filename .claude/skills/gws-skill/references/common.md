# Common flags, output, errors

## Command shape

```
$GWS <service> <resource> [sub-resource] <method> --params '<JSON>' --json '<JSON>'
$GWS <service> +<helper> [flags]          # shortcut commands
$GWS schema <service.resource.method>     # parameter/body structure
$GWS <service> [<resource>] --help         # list methods / helpers
```

`--params` = URL/query parameters (IDs, filters, paging). `--json` = request body (POST/PATCH/PUT).

## Global flags

| Flag | Use |
|---|---|
| `--format json\|table\|yaml\|csv` | `table` for showing the user, `json` for parsing (default) |
| `--dry-run` | Validate and print the request without sending — use for write previews |
| `--page-all` / `--page-limit N` / `--page-delay MS` | Auto-paginate (NDJSON, one line per page; default 10 pages) |
| `--upload <PATH>` / `--upload-content-type <MIME>` | Attach media to a create/update call |
| `--output <PATH>` | Save binary responses (downloads, exports) |

> `--upload` / `--output` paths must resolve **inside the current working directory**; absolute paths elsewhere (e.g. `/tmp`, `C:\Users\…\Downloads`) fail with exit 3. Run from the project folder with relative paths.
| `--api-version <VER>` | Override API version |

Keep responses small with a `fields` param, e.g. `"fields":"files(id,name,webViewLink)"` or `"fields":"items(id,summary,start,end)"`.

## Environment variables (set via .env)

| Variable | Purpose |
|---|---|
| `GOOGLE_WORKSPACE_CLI_CLIENT_ID` / `_CLIENT_SECRET` | OAuth client used by `auth login` |
| `GOOGLE_WORKSPACE_PROJECT_ID` | Project for quota/billing |
| `GWS_SCOPES` | Scopes for `scripts/login.sh` (skill-specific) |
| `GOOGLE_WORKSPACE_CLI_CONFIG_DIR` | Override `~/.config/gws` |
| `GOOGLE_WORKSPACE_CLI_TOKEN` | Pre-obtained access token (highest priority) |
| `GOOGLE_WORKSPACE_CLI_LOG=gws=debug` | Debug logging to stderr |

## Exit codes

| Code | Meaning | Response |
|---|---|---|
| 0 | Success | Report result (IDs, links) |
| 1 | API error (Google returned an error) | Show the message; check IDs, permissions, enabled APIs |
| 2 | Auth error | Stop; re-auth via `references/auth-setup.md` §4 |
| 3 | Validation (bad arguments) | Check `--help` / `schema`, fix, retry once |
| 4 | Discovery (couldn't fetch API schema) | Network issue; retry later |
| 5 | Internal failure | Stop and report |

## Shell quoting tips (Git Bash / bash)

- Wrap JSON in single quotes; for a single quote inside (Drive `q`), close-escape-reopen: `'"'"'` or `'\''`.
- Korean text is fine inside JSON/flags as long as the terminal is UTF-8.
- For long bodies, build a file and pass `--json "$(cat body.json)"`.
