# AIOS Privacy Rules

This file defines privacy and AI-access boundaries for the Buy Your Home Admin wiki AIOS.

## Default Rule

Use the smallest necessary context. Do not expose, upload, summarize, or transmit sensitive source files outside the local workspace unless Wes explicitly approves the specific source and purpose.

## Allowed By Default

AI may read and use these local wiki files for Admin wiki work:

- `AIOS/`
- root workflow and rule Markdown files,
- `Project Rooms/<Project>/README.md`,
- project-room `working/` inventories and notes,
- canonical skill instructions under `skills/`,
- `operations/grocery-list/` workflow and data files when the request is grocery-related.

Allowed by default does not mean "send to an external service." It means local reading inside the current workspace is acceptable for the task.

## Ask First

Ask Wes before using, summarizing, uploading, or transmitting:

- raw source files in any `sources/` folder when they include legal, financial, medical, identity, tax, payroll, bank, credit, or personal details,
- scanned statements and invoices,
- Teams/SharePoint-synced source folders,
- mailbox contents beyond the specific mailbox task,
- calendar details beyond the specific scheduling task,
- files outside `C:\Codex\Wiki Files`,
- credentials, security codes, verification messages, or password-related material,
- personal journal-like notes or private family notes.

## Never Do Without Explicit Approval

- Do not publish private source material to public GitHub, public links, or public websites.
- Do not paste raw sensitive documents into internet tools.
- Do not send entire folders or the whole vault to an AI service by default.
- Do not expose passwords, verification codes, account login details, or security answers.
- Do not use a similar mailbox, folder, or service as a substitute when the required one is unavailable.
- Do not move money, pay invoices, submit forms, contact vendors, or send external customer/lead texts unless the applicable workflow and Wes's explicit instruction authorize it.

## Git And Repository Privacy

- Keep the Admin wiki repository private unless Wes explicitly changes that policy.
- Do not commit Obsidian local settings, temporary scan previews, logs, generated scratch files, raw sensitive scans, or credentials.
- Commit only the scoped durable wiki changes that belong to the current request.
- Push only when Wes explicitly asks, says the work is finished, or the task already defines the deliverable as final and ready to publish.

## Project Room Privacy

- Raw source files belong in `sources/` and should be treated as potentially sensitive.
- Working notes should paraphrase or cite sensitive sources only as much as needed.
- Mark unsupported claims instead of filling gaps from memory.
- Outputs should avoid unnecessary personal, account, credential, or private detail.

## AI-Assisted Content Marker

Until Wes chooses a different marker, use this note when a durable output was materially drafted or rewritten by AI:

```text
AI-assisted draft. Review before relying on it as final.
```

Do not put this marker on every routine wiki edit. Use it for substantive drafts, reports, analyses, SOP rewrites, and external-facing text.

## Local-First Preference

When privacy matters, prefer local files, local processing, and narrow context. Use internet-connected or cloud AI tools only with the minimum source material required for the task.

## If Unsure

If a source might be sensitive and the task can wait, ask Wes before using it. If the task is urgent but the source is sensitive, summarize the blocker and request approval rather than guessing.
