---
name: jennys-drawings
description: Use for Buy Your Home Jennys Drawings project-room work, including organizing drawing sources, tracking missing context, drafting review-ready outputs, and maintaining materials under `Project Rooms\Jennys Drawings`.
---

# Jennys Drawings

## Source Of Truth

- Project room: `C:\Codex\Wiki Files\Project Rooms\Jennys Drawings`
- Skill source: `C:\Codex\Wiki Files\skills\jennys-drawings\SKILL.md`
- Admin wiki source: `C:\Codex\Wiki Files`
- Registry: `C:\Codex\Wiki Files\Agents and Automations Registry.md`

Use this skill when Wes asks Codex to work on Jennys Drawings source organization, review, drafting, description, or documentation for Buy Your Home.

## Start PR

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.

## Required Startup

Before Jennys Drawings file work:

1. Confirm the working folder is `C:\Codex\Wiki Files`.
2. Confirm the current branch is `main`.
3. Read `Project Room Chat Startup Rule.md`, `Project Room File Ownership And Git Coordination Rule.md`, `Project Rooms\Jennys Drawings\README.md`, and this skill source.
4. Read root rules needed for the request, including `AGENTS.md`, `Repository Location Rule.md`, `Project Room Workflow.md`, `Agent Unit Standard.md`, and `Git Work Scope Rule.md`.
5. Check `git status --short --branch`.

## Workflow

1. Identify the Jennys Drawings task, intended output, and any privacy, sharing, usage, deadline, or external-action limit.
2. Keep Jenny's original drawing files in the Teams Marketing folder `Gracious Millionaire - Drawn by Grace`. Do not copy them into the repository.
3. Update `working\source-inventory.md` before drafting outputs.
4. Record duplicate, outdated, conflicting, or unclear source material in `working\duplicate-and-conflict-log.md`.
5. Record missing source files, drawing context, intended audience, usage permissions, deadlines, and decision points in `working\missing-context.md`.
6. Draft outputs in `outputs\` using authoritative sources only.
7. Mark unsupported assumptions as `[UNSUPPORTED]` instead of smoothing them into a final recommendation.
8. Commit only scoped Jennys Drawings room, matching skill, registry, and index changes.

## Teams-Only Drawing Storage

- Teams is the authoritative storage location for Jenny's original drawing files.
- Do not save drawing copies under `sources\`, `working\`, `outputs\`, or any other path in `C:\Codex\Wiki Files`.
- Use the stable filenames, organization-only view links, and metadata recorded in the Project Room inventories.
- When direct visual inspection is required, retrieve only the needed drawing to a temporary location outside the repository, then delete the temporary copy when the task is complete.
- Current manuscripts should display or link to the Teams-hosted drawings. Do not create repository outputs that embed the original drawings.
- Keep working files and versions to the minimum needed to regenerate the current deliverables. Update current files in place instead of creating version-suffixed copies.

## Boundaries

- Do not edit another Project Room's files or matching skill unless Wes explicitly authorizes that specific cross-PR edit.
- Do not create Teams folders unless Wes explicitly asks.
- Do not move source files from another Project Room unless Wes authorizes that move.
- Do not create automations unless Wes asks for scheduled or event-triggered behavior.
- Do not publish, share, send, or externally post drawings unless Wes explicitly authorizes that specific action and the applicable Admin wiki rules allow it.
- Do not commit unrelated dirty work or generated scratch folders.
- Do not push unless Wes asks, says the setup is finished, or the applicable Admin wiki rules make the deliverable ready to publish.

- Do not retain a downloaded Jenny drawing after the immediate task is complete.

## Outputs

Use `C:\Codex\Wiki Files\Project Rooms\Jennys Drawings\outputs` for review-ready drafts, summaries, captions, checklists, handoff notes, and final deliverables.
