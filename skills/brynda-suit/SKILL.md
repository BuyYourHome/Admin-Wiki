---
name: brynda-suit
description: Use for Buy Your Home Brynda Suit project-room work, including organizing sources, tracking missing context, drafting review-ready outputs, and maintaining materials under `Project Rooms\Brynda Suit`.
---

# Brynda Suit

## Source Of Truth

- Project room: `C:\Codex\Wiki Files\Project Rooms\Brynda Suit`
- Skill source: `C:\Codex\Wiki Files\skills\brynda-suit\SKILL.md`
- Admin wiki source: `C:\Codex\Wiki Files`
- Registry: `C:\Codex\Wiki Files\Agents and Automations Registry.md`

Use this skill when Wes asks Codex to work on Brynda Suit source organization, analysis, drafting, review, or documentation for Buy Your Home.

## Start PR

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.

## Required Startup

Before Brynda Suit file work:

1. Confirm the working folder is `C:\Codex\Wiki Files`.
2. Confirm the current branch is `main`.
3. Read `Project Room Chat Startup Rule.md`, `Project Room File Ownership And Git Coordination Rule.md`, `Project Rooms\Brynda Suit\README.md`, and this skill source.
4. Read root rules needed for the request, including `AGENTS.md`, `Repository Location Rule.md`, `Project Room Workflow.md`, `Agent Unit Standard.md`, and `Git Work Scope Rule.md`.
5. Check `git status --short --branch`.

## Workflow

1. Identify the Brynda Suit task, intended output, and any deadline or external-action limit.
2. Put source material, exports, notes, screenshots, or source summaries in `sources\`.
3. Update `working\source-inventory.md` before drafting outputs.
4. Record duplicate, outdated, conflicting, or unclear source material in `working\duplicate-and-conflict-log.md`.
5. Record missing facts, documents, deadlines, and decision points in `working\missing-context.md`.
6. Draft outputs in `outputs\` using authoritative sources only.
7. Mark unsupported assumptions as `[UNSUPPORTED]` instead of smoothing them into a final recommendation.
8. Commit only scoped Brynda Suit room, matching skill, registry, and index changes.

## Boundaries

- Do not edit another Project Room's files or matching skill unless Wes explicitly authorizes that specific cross-PR edit.
- Do not create Teams folders unless Wes explicitly asks.
- Do not move source files from another Project Room unless Wes authorizes that move.
- Do not create automations unless Wes asks for scheduled or event-triggered behavior.
- Do not send emails, file external documents, approve legal or financial decisions, or take external workflow action unless Wes explicitly authorizes that specific action and the applicable Admin wiki rules allow it.
- Do not commit unrelated dirty work or generated scratch folders.
- Do not push unless Wes asks, says the setup is finished, or the applicable Admin wiki rules make the deliverable ready to publish.

## Outputs

Use `C:\Codex\Wiki Files\Project Rooms\Brynda Suit\outputs` for review-ready drafts, summaries, checklists, handoff notes, and final deliverables.
