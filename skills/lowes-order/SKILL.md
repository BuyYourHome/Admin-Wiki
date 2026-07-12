---
name: lowes-order
description: Use for Buy Your Home Lowe's order project-room work, including organizing order sources, preparing order drafts or handoffs, tracking missing order details, and maintaining outputs under `Project Rooms\Lowes Order`.
---

# Lowes Order

## Source Of Truth

- Project room: `C:\Codex\Wiki Files\Project Rooms\Lowes Order`
- Skill source: `C:\Codex\Wiki Files\skills\lowes-order\SKILL.md`
- Admin wiki source: `C:\Codex\Wiki Files`
- Registry: `C:\Codex\Wiki Files\Agents and Automations Registry.md`

Use this skill when Wes asks Codex to work on Lowe's order planning, organization, review, or documentation for Buy Your Home.

## Required Startup

Before Lowes Order file work:

1. Confirm the working folder is `C:\Codex\Wiki Files`.
2. Read `Admin Home.md`, `AGENTS.md`, `Repository Location Rule.md`, `Project Room Workflow.md`, `Project Room Chat Startup Rule.md`, `Agent Unit Standard.md`, `Codex Skill Source Rule.md`, and `Git Work Scope Rule.md`.
3. Read `Project Rooms\Lowes Order\README.md`, `working\source-inventory.md`, `working\duplicate-and-conflict-log.md`, and `working\missing-context.md`.
4. Check `git status --short --branch`.

## Workflow

1. Identify the project, property, or business purpose for the Lowe's order.
2. Put source material, product lists, screenshots, emails, or source summaries in `sources\`.
3. Update `working\source-inventory.md` before drafting order outputs.
4. Record duplicates, outdated product information, conflicting quantities, and unclear instructions in `working\duplicate-and-conflict-log.md`.
5. Record missing item details, quantity, pickup/delivery method, budget, payment, timing, and approval questions in `working\missing-context.md`.
6. Draft order summaries, review checklists, or handoff notes in `outputs\` using authoritative sources only.
7. Mark unsupported order assumptions as `[UNSUPPORTED]` instead of smoothing them into a final recommendation.
8. Commit only scoped Lowes Order room, skill, registry, and index changes.

## Boundaries

- Do not place purchases, spend money, submit orders, change payment details, or approve substitutions unless Wes explicitly approves the specific order action.
- Do not create Teams folders unless Wes explicitly asks.
- Do not move source files from another Project Room unless Wes authorizes that move.
- Do not create automations unless Wes asks for scheduled or event-triggered behavior.
- Do not commit unrelated dirty work or generated scratch folders.
- Do not push unless Wes asks, says the setup is finished, or the applicable Admin wiki rules make the deliverable ready to publish.

## Outputs

Use `C:\Codex\Wiki Files\Project Rooms\Lowes Order\outputs` for review-ready order drafts, item checklists, handoff notes, and final summaries.
