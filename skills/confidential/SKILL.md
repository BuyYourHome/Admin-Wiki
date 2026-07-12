---
name: confidential
description: Use for Buy Your Home Confidential project-room work, including sensitive Admin wiki notes, source inventories, open questions, private planning, and review-ready outputs under `Project Rooms\Confidential`. Trigger when Wes asks to use the Confidential room, Confidential skill, or this chat for private or sensitive admin work.
---

# Confidential

Use this skill to organize and maintain the `Confidential` project room.

## Required Context

Read these files first:

- `C:\Codex\Wiki Files\Admin Home.md`
- `C:\Codex\Wiki Files\AGENTS.md`
- `C:\Codex\Wiki Files\Repository Location Rule.md`
- `C:\Codex\Wiki Files\Project Room Workflow.md`
- `C:\Codex\Wiki Files\Agent Unit Standard.md`
- `C:\Codex\Wiki Files\Git Work Scope Rule.md`
- `C:\Codex\Wiki Files\Codex Skill Source Rule.md`
- `C:\Codex\Wiki Files\Project Rooms\Confidential\README.md`
- `C:\Codex\Wiki Files\Project Rooms\Confidential\working\source-inventory.md`
- `C:\Codex\Wiki Files\Project Rooms\Confidential\working\duplicate-and-conflict-log.md`
- `C:\Codex\Wiki Files\Project Rooms\Confidential\working\missing-context.md`

## Workflow

1. Work only from `C:\Codex\Wiki Files`.
2. Keep Confidential materials under `C:\Codex\Wiki Files\Project Rooms\Confidential`.
3. Use the room only when Wes explicitly refers to Confidential work, the Confidential room, the Confidential skill, or this Confidential chat.
4. Put raw source files or source notes in `sources\`.
5. Update `working\source-inventory.md` before drafting from sources.
6. Record duplicate, outdated, conflicting, or unclear sources in `working\duplicate-and-conflict-log.md`.
7. Record missing decisions, unsupported facts, and privacy concerns in `working\missing-context.md`.
8. Keep analysis, experiments, and drafts in `working\`.
9. Put review-ready drafts and final deliverables in `outputs\`.
10. Mark unsupported factual claims instead of smoothing over gaps.
11. Commit durable wiki changes locally when they belong in the Admin wiki. Push only under the Admin wiki push rules.

## Confidentiality Rules

- Treat source material in this room as sensitive by default.
- Do not copy Confidential files to Teams, SharePoint, email, another project room, or an external service unless Wes explicitly asks for that specific transfer or an existing rule clearly requires it.
- Do not store passwords, authentication tokens, payment card numbers, bank login credentials, seed phrases, or other live secrets in the project room, skill, git history, or chat handoff notes.
- If a source contains unnecessary sensitive personal or financial data, summarize only the minimum needed facts and note where the original source is controlled outside the repo.
- If a requested action would expose Confidential material outside the Admin wiki, pause and report the specific exposure before proceeding.

## Boundaries

- Do not use Confidential as a substitute for a specialized room when Wes names a more specific workflow such as Doc Scan, Email Summary, Gracious Millionaire, Contract for Deed, or Credit Worthiness Evaluator.
- Do not create final deliverables from unclear or missing source context.
- Do not delete, overwrite, publish, email, or push Confidential materials without the applicable Admin wiki approval rule.
- Preserve original source files.
