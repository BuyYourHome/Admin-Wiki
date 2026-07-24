# Property Trade Evaluation Project Room

## Purpose

Maintain analyses, term sheets, valuation notes, and supporting materials for property trade and transaction-structure evaluations.

## Scope

Use this room when Wes asks to evaluate a property trade, compare structures, draft trade/equity term sheets, prepare related Spanish/English review drafts, or analyze inspection/financing notes tied to a trade proposal.

This room may reference property folders and project spreadsheets, but it is not the source of truth for live property files. Preserve original source documents and keep review-ready outputs in `outputs\`.

## Current Status

Status: active.

Historical working materials and rendered outputs already exist. The room now has a standard README, source inventory, conflict log, missing-context file, and `sources\` folder for future source-controlled intake.

Local cleanup note: ignored generated dependency cache `working\node_modules\` was removed on 2026-07-24 to reduce local repo scan weight. Recreate dependencies only when a future tool run requires them; do not commit dependency folders as durable source.

## Matching Skill

- Skill source: `C:\Codex\Wiki Files\skills\property-trade-evaluation\SKILL.md`

## Folder Map

- `sources\` - raw source documents, source notes, emails, spreadsheet references, inspection notes, and user-provided facts.
- `working\` - analyses, drafts, run notes, rendered checks, source inventory, and open questions.
- `outputs\` - review-ready term sheets, reports, translated drafts, or final deliverables.
- `working\local-cleanup-log.md` - record of local generated/dependency cleanup.

## Next Actions

1. Inventory the controlling source files for any active trade evaluation before drafting.
2. Keep unsupported transaction facts in `working\missing-context.md`.
3. Use `outputs\` only for review-ready deliverables.
4. Avoid committing generated render folders or dependency folders unless explicitly needed as durable source.
## Start PR Pointer

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.
