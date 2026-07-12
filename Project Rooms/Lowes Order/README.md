# Lowes Order Project Room

## Purpose

This Project Room holds the repeatable workflow for Buy Your Home Lowe's order work.

Use this room when Wes asks Codex to plan, organize, review, or document Lowe's ordering tasks, including source notes, order requirements, follow-up decisions, and review-ready outputs.

## Scope

In scope:

- Lowe's order source notes, product lists, project/property context, and working decisions.
- Workflow rules for preparing order drafts or handoffs.
- Review-ready outputs under `outputs\`.
- Matching wiki-managed skill instructions under `C:\Codex\Wiki Files\skills\lowes-order\SKILL.md`.

Out of scope:

- Placing purchases, spending money, changing payment details, or submitting orders unless Wes explicitly approves the specific order action.
- Creating Teams folders unless Wes explicitly asks for a final deliverable there.
- Moving source files from another Project Room unless Wes authorizes the move.
- Creating automations unless Wes explicitly asks for scheduled or event-triggered behavior.

## Folder Map

- `sources\` - raw order notes, product information, screenshots, emails, or source summaries.
- `working\source-inventory.md` - inventory of source material and authority status.
- `working\duplicate-and-conflict-log.md` - duplicate, outdated, conflicting, or unclear source notes.
- `working\missing-context.md` - open questions and decisions needed before final ordering work.
- `outputs\` - review-ready order drafts, checklists, handoffs, or summaries.

## Current Status

Status: draft.

This room was created as the standard workspace for Lowe's order workflow work. No order-specific sources have been added yet.

## Matching Skill

- Skill source: `C:\Codex\Wiki Files\skills\lowes-order\SKILL.md`

## Dedicated Chat

- Chat name: `Lowes Order`
- Thread id: `019f5845-fb96-7370-baf2-b8f00fddffae`

## Branch And Push Mode

- Project branch: `project/lowes-order`
- Before durable file work, confirm the repo is `C:\Codex\Wiki Files` and switch to this branch when safe.
- If Git processes, lock files, or unrelated dirty files block switching, report the blocker instead of forcing, stashing, resetting, or deleting files.
- Commit only scoped Lowes Order room, matching skill, and directly related registry/index changes.
- Push only when Wes explicitly asks, says the work is finished, or the applicable Admin wiki rules define the deliverable as final and ready to publish.

## Next Actions

1. Add authoritative Lowe's order source material to `sources\` when Wes provides it.
2. Update the source inventory before drafting order outputs.
3. Record any missing item details, property/project assignment, budget, delivery/pickup details, or approval decisions in `working\missing-context.md`.
4. Draft review-ready order outputs in `outputs\` only from authoritative sources.
