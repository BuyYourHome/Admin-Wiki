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

## OfficeAssist Routed Email Response Mode

Use this mode when OfficeAssist routes a Brynda Suit email source into the existing Brynda Suit task or says to `wake up and respond to the email`.

1. Treat the handoff as an active request to review the routed source email and prepare a response.
2. Work in the existing Brynda Suit task. Do not create a new task.
3. Use the routed Markdown email source as the authoritative source for the email request.
4. Read the full routed email before drafting.
5. Identify what response is being requested and preserve the routed source path in the notes or response draft.
6. Keep related source notes, drafts, and review questions under `C:\Codex\Wiki Files\Project Rooms\Brynda Suit`.
7. Produce either a ready-to-review email response draft or a blocker note explaining what information or authorization is needed before a response can be drafted.
8. Do not send the reply directly unless Wes explicitly authorizes sending.
9. If the email requests a legal, financial, filing, settlement, admission, approval, or other high-impact action, draft the response for Wes review and clearly flag any decision or missing context needed before sending.

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
