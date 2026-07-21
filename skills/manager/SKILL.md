---
name: manager
description: Use for Buy Your Home Manager project-room work, including defining scope, organizing sources, tracking missing context, drafting review-ready outputs, and maintaining materials under `Project Rooms\Manager`.
---

# Manager

## Source Of Truth

- Project room: `C:\Codex\Wiki Files\Project Rooms\Manager`
- Skill source: `C:\Codex\Wiki Files\skills\manager\SKILL.md`
- Admin wiki source: `C:\Codex\Wiki Files`
- Registry: `C:\Codex\Wiki Files\Agents and Automations Registry.md`

Use this skill when Wes asks Codex to work on Manager source organization, scope definition, review, drafting, documentation, or project-room maintenance for Buy Your Home.

## Manager Attributes

User-reported facts from Wes:

- Josh Kennedy is the Manager of Sell Your Home, LLC and Investment Services.
- Josh signs on behalf of legal documents through his Investment Services role.
- Josh's annual salary is `$65,000`.
- Josh's email address is `IRAManager@SellYourHomeRaleigh.com`.
- Josh's phone number is `919-961-5574`.
- A MoU in the Sell Your Home channel gives the specifics of Josh's contract.

Treat the MoU as the controlling source for contract-specific details after it is retrieved or preserved in the Project Room.

## Start PR

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.

## Required Startup

Before Manager file work:

1. Confirm the working folder is `C:\Codex\Wiki Files`.
2. Confirm the current branch is `main`.
3. Read `Project Room Chat Startup Rule.md`, `Project Room File Ownership And Git Coordination Rule.md`, `Project Rooms\Manager\README.md`, and this skill source.
4. Read root rules needed for the request, including `AGENTS.md`, `Repository Location Rule.md`, `Project Room Workflow.md`, `Agent Unit Standard.md`, and `Git Work Scope Rule.md`.
5. Check `git status --short --branch`.

## Workflow

1. Identify the Manager task, intended output, controlling sources, and any privacy, sharing, deadline, or external-action limit.
2. If contract-specific Manager details are needed, retrieve or use the MoU from the Sell Your Home channel before treating those details as source-verified.
3. Preserve source notes, exported messages, references, or source summaries in `sources\` when they are part of the durable source set.
4. Update `working\source-inventory.md` before drafting outputs.
5. Record duplicate, outdated, conflicting, or unclear source material in `working\duplicate-and-conflict-log.md`.
6. Record missing source files, workflow decisions, intended audience, deadlines, and approval points in `working\missing-context.md`.
7. Draft outputs in `outputs\` using authoritative sources only.
8. Mark unsupported assumptions as `[UNSUPPORTED]` instead of smoothing them into a final recommendation.
9. Commit only scoped Manager room, matching skill, registry, and index changes.

## Boundaries

- Do not edit another Project Room's files or matching skill unless Wes explicitly authorizes that specific cross-PR edit.
- Do not create Teams folders unless Wes explicitly asks.
- Do not create automations unless Wes asks for scheduled or event-triggered behavior.
- Do not send email, external messages, make purchases, change legal/financial documents, or perform live operational actions unless Wes explicitly authorizes the specific action and the applicable Admin wiki rules allow it.
- If Manager work requires sending email, use the Admin wiki Email Delivery workflow used by Email Monitor by following `C:\Codex\Wiki Files\skills\email-delivery\SKILL.md` for sender safety, attachment handling, Sent Items verification, local Outlook fallback rules, and failure reporting.
- Do not commit unrelated dirty work or generated scratch folders.
- Do not push unless Wes asks, says the setup is finished, or the applicable Admin wiki rules make the deliverable ready to publish.

## Outputs

Use `C:\Codex\Wiki Files\Project Rooms\Manager\outputs` for review-ready drafts, summaries, checklists, handoff notes, and final deliverables.
