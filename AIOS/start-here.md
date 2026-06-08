# AIOS Start Here

This is the first file an AI assistant should read before working in the Buy Your Home Admin wiki.

## Working Folder

The working wiki, Obsidian vault, and local Git repository are all the same folder:

```text
C:\Codex\Wiki Files
```

Do not switch to a Teams folder, another `Wiki Files` folder, or a project-room source folder unless Wes explicitly gives that instruction for the specific task.

## Source Of Truth

- Local working folder: `C:\Codex\Wiki Files`
- GitHub repository: `BuyYourHome/Admin-Wiki`
- Obsidian vault: `C:\Codex\Wiki Files`
- Teams folders are not the working wiki location.

## Startup Reading Order

1. Read this file.
2. Read `AIOS/me.md`.
3. Read `AIOS/vault-map.md`.
4. Read `AIOS/skills-map.md` when the request involves skills, agents, automations, or repeatable workflows.
5. Read `AIOS/privacy-rules.md` before using sensitive files or external services.
6. Read `Admin Home.md`.
7. Use the routing table in `AIOS/vault-map.md` to choose the workflow file that matches the request.
8. Read that workflow file before acting.

## Current Implementation Rule

This AIOS is an overlay. It does not replace or rename the existing wiki structure.

Do not rename:

- `C:\Codex\Wiki Files`
- `Project Rooms`
- `skills`
- `operations`
- existing SOP or registry files

## Working Rules

- Use Markdown files for durable operating instructions.
- Use `AIOS/vault-map.md` to route requests before guessing from memory.
- Use Project Rooms for substantial drafting, analysis, redesign, or automation work that depends on multiple sources.
- Keep Teams as a final-deliverable destination only when Wes explicitly asks.
- Prefer installed connectors and plugins when they are more reliable than local desktop automation.
- Stage and commit only files that belong to the current body of work.
- Do not push unless Wes explicitly asks, says the work is finished, or the task itself defines a final publishable deliverable.

## Privacy Default

Use the smallest necessary set of files for the task. Follow `AIOS/privacy-rules.md`. Do not upload, summarize, or expose sensitive files outside the local workspace unless Wes explicitly approves that specific source for that specific purpose.

## If The Task Is Unclear

First determine whether the request is:

- durable knowledge or rule maintenance,
- time-based calendar/log work,
- active project/deliverable work,
- email or connector work,
- document/scanning/spreadsheet work,
- or general wiki maintenance.

Then open the relevant workflow rule before acting.

## Version Status

This is the first usable AIOS overlay version as of 2026-06-08. It has passed a local startup-path smoke test. Revise it after a real independent new-chat failure or after a major Admin wiki workflow changes.
