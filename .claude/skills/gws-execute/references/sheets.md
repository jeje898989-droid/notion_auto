# Sheets Reference

> Source: `gws sheets --help` (gws 0.22.5)

## Create Spreadsheet

```
gws sheets spreadsheets create --json '{"properties":{"title":"<title>"}}'
```

- Returns `spreadsheetId`. Link: `https://docs.google.com/spreadsheets/d/<spreadsheetId>/edit`

## Append Row

```
gws sheets +append ...
```

## Read Values

```
gws sheets +read ...
```

- Check exact options with `gws sheets +append --help` / `gws sheets +read --help` before building the command.
- For large data, write JSON to `workspace/outputs/` and pass by path.
