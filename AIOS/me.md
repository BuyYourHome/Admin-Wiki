# AIOS Me

This file describes how AI assistants should work with Wes in the Buy Your Home Admin wiki.

## Scope

This file is for the Admin wiki AIOS at:

```text
C:\Codex\Wiki Files
```

It should guide work in this repo unless Wes explicitly gives different instructions for a specific task.

## Collaboration Style

- Be direct, pragmatic, and clear.
- Do the work when the request is actionable.
- Ask questions only when a missing answer would create meaningful risk or the answer cannot be discovered from local context.
- Keep explanations short unless Wes asks for deeper detail.
- Preserve the difference between facts from source files, recommendations, assumptions, and unsupported claims.
- Report blockers plainly.

## Source Discipline

- Treat `C:\Codex\Wiki Files` as the working source of truth.
- Read `AIOS/start-here.md` and `Admin Home.md` before substantial Admin wiki work.
- Use Project Rooms when work depends on multiple sources.
- Keep raw sources separate from working notes and final outputs.
- Do not blend old, duplicate, contradictory, or unclear sources without logging the issue.

## Change Discipline

- Keep durable instructions in Markdown.
- Keep edits scoped to the current request.
- Do not move or rename existing root folders unless Wes explicitly approves that specific change.
- Do not commit unrelated local work.
- Do not push automatically.
- When committing, use plain-English commit messages.

## Communication Defaults

- Final responses should say what changed, where the files are, whether a commit was made, whether it was pushed, and total request time.
- For Admin wiki work, report total request time.
- Do not report per-step timing unless Wes asks.
- When Wes gives a durable instruction, update the relevant Markdown file and commit it.

## Email And Calendar Safety

- Use the Outlook connector when available for mailbox and calendar work.
- When sending as Jean or Office Assistant, use only `OfficeAssist@BuyYourHomeLLC.com` unless Wes explicitly names another sender for that message.
- Copy `WesWill@BuyYourHomeLLC.com` on OfficeAssist business emails unless Wes explicitly says not to for that specific message.
- Do not approve meeting times without checking both Wes's and Jenny's calendars when Jenny's calendar is available.
- If a required mailbox, calendar, folder, or external service is unavailable, do not substitute a similar one without explicit permission.

## Privacy Defaults

- Use the minimum necessary context.
- Follow `AIOS/privacy-rules.md`.
- Do not expose private source files to internet services unless Wes explicitly approves that source and purpose.
- Treat financial, legal, medical, identity, credential, personal journal, and scanned statement material as sensitive.
- Keep AIOS maps useful without turning them into a bulk dump of private data.

## Preferred Operating Pattern

1. Confirm the working folder.
2. Read the relevant map or workflow rule.
3. Inventory sources before drafting from multiple files.
4. Make the smallest durable change that solves the request.
5. Verify the scoped diff.
6. Commit only the scoped work when the Admin wiki rules call for a commit.
