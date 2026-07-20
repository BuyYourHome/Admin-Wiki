---
name: create-pr
description: Use when Wes asks Codex to create, set up, standardize, or continue a Buy Your Home Project Room, PR, matching skill, dedicated chat, startup handoff, branch rule, or registry entry under `Project Rooms\Create PR`.
---

# Create PR

## Source Of Truth

- Project room: `C:\Codex\Wiki Files\Project Rooms\Create PR`
- Skill source: `C:\Codex\Wiki Files\skills\create-pr\SKILL.md`
- Admin wiki source: `C:\Codex\Wiki Files`
- Registry: `C:\Codex\Wiki Files\Agents and Automations Registry.md`
- Chat startup rule: `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`
- Ownership and Git coordination rule: `C:\Codex\Wiki Files\Project Room File Ownership And Git Coordination Rule.md`

Use this skill for creating or maintaining the standard Buy Your Home Project Room package: Project Room, matching wiki-managed skill, registry entry when needed, and dedicated Codex chat.

## Required Startup

Before Create PR file work:

1. Confirm the working folder is `C:\Codex\Wiki Files`.
2. Read `Admin Home.md`, `AGENTS.md`, `Project Room Workflow.md`, `Project Room Chat Startup Rule.md`, `Project Room File Ownership And Git Coordination Rule.md`, `Agent Unit Standard.md`, `Codex Skill Source Rule.md`, and `Git Work Scope Rule.md`.
3. Read `Project Rooms\Create PR\README.md`, `working\source-inventory.md`, `working\duplicate-and-conflict-log.md`, and `working\missing-context.md`.
4. Check `git status --short --branch`.

## Workflow

1. Confirm the requested Project Room name.
2. Normalize the skill name to lower-case hyphen-case.
3. Work from `main` before creating the new PR:
   - Check `git status --short --branch`.
   - If the repo is not on `main`, switch to `main` only when the worktree is clean or the dirty files are clearly part of the current scoped Create PR setup and can safely move with the branch.
   - If unrelated dirty work, Git locks, or branch conflicts block switching to `main`, stop and report the blocker. Do not force, stash, reset, delete, or carry unrelated work into the new PR.
   - Do not create a new Git branch unless Wes explicitly asks for one.
4. Check whether the Project Room, skill, registry entry, or chat already exists. If an existing Project Room or project-specific skill would need to be moved, renamed, deleted, or edited, follow the explicit yes/no authorization rule in `Project Room File Ownership And Git Coordination Rule.md` before making any change.
5. Create the Project Room folders under `Project Rooms\<Project Name>\`: `sources\`, `working\`, and `outputs\`.
6. Create the room README with purpose, scope, folder map, status, matching skill, dedicated chat when any, Start PR pointer, branch rule, and next actions.
7. Create the standard working files:
   - `working\source-inventory.md`
   - `working\duplicate-and-conflict-log.md`
   - `working\missing-context.md`
8. Include this short pointer in the README and matching skill instead of copying the full central rule: `Start PR: Before durable work, follow Start PR Mode in C:\Codex\Wiki Files\Project Room Chat Startup Rule.md. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on main unless Wes explicitly asks for a branch.`
9. Create the matching skill under `skills\<skill-name>\SKILL.md` with source paths, required startup, workflow, boundaries, outputs, and Git rules.
10. Make the new Project Room subject to `Project Room File Ownership And Git Coordination Rule.md`; do not set up a new room so it can edit other PR files by default.
11. Add `skills\<skill-name>\agents\openai.yaml` when practical.
12. Update `Agents and Automations Registry.md` when the room is repeatable, agent-like, has a dedicated chat, or may later have automation.
13. Add `Admin Home.md` links when the room should be visible from the wiki start page.
14. Commit the scoped Project Room, skill, registry, and index changes before attempting dedicated task creation.
15. Create or hand off to a dedicated chat using `Project Room Chat Startup Rule.md` only when Wes explicitly asks or when no existing chat should own the work; follow the Dedicated Chat Connector Rule below.
16. If a dedicated chat is created, record the returned thread id in the README and registry and commit that metadata update separately.
17. Push only under the Admin wiki push rules.

## Dedicated Chat Connector Rule

When creating a new PR requires a dedicated Codex task:

1. Complete and commit the local PR package first.
2. Try the Codex app task-creation connector once.
3. If the connector does not return promptly or does not return a usable thread id, stop waiting on it and leave the README and registry `Thread id` as `pending until the dedicated chat is created`.
4. Report the local PR package as complete and the dedicated task as pending because the connector did not return.
5. Do not let task creation block the whole PR setup, and do not retry indefinitely in the same turn.
6. When the connector later succeeds, record the returned thread id in the PR README and registry, then commit that metadata update separately.

## Project Room Relationship Diagram Mode

Use this mode when Wes asks Create PR to make, refresh, or maintain a relationship diagram of Buy Your Home Project Rooms.

Purpose:

- Produce a readable graphic showing how Project Rooms, skills, automations, and major handoffs relate.
- Keep the diagram grouped enough to fit on one page or screen.
- Prefer a polished SVG output unless Wes asks for another format.

Required sources:

1. `C:\Codex\Wiki Files\Agents and Automations Registry.md`
2. `C:\Codex\Wiki Files\Admin Home.md`
3. `C:\Codex\Wiki Files\Project Room Workflow.md`
4. `C:\Codex\Wiki Files\Project Room File Ownership And Git Coordination Rule.md`
5. Current `README.md` files under `C:\Codex\Wiki Files\Project Rooms\*\README.md` when needed for relationship details.

Workflow:

1. Confirm work is being done from `C:\Codex\Wiki Files`.
2. Read the required sources.
3. Identify all active, draft, planning, and support Project Rooms.
4. Group the rooms by practical function:
   - Intake / Coordination
   - Document Intake
   - Accounting / Project Data
   - Real Estate Transaction Work
   - Legal / Entity Work
   - Publishing / Public Work
   - System Maintenance
5. Show Jean Wright / Admin Operations as the coordination hub.
6. Show Email Monitor as the email intake and routing hub.
7. Show Doc Scan, Invoice Entry, and Template to Project as the document-to-accounting/project-data chain.
8. Show Contract for Deed relationships to Credit Worthiness Evaluator, Amortization, and Template to Project.
9. Show Gracious Millionaire and REI BlackBook as related book/public-website work.
10. Show Entity Relationship and Operating Agreements as related legal/entity-governance work.
11. Keep cross-links limited to the most important handoffs so the diagram remains readable.
12. Mark inferred relationships as inferred if they are not directly supported by the registry or README files.
13. Save the output under `C:\Codex\Wiki Files\Project Rooms\Create PR\outputs\`.
14. Use a filename such as `Project Room Relationship Diagram.svg`.
15. If the diagram is also useful globally, copy or link it from an Admin wiki index only after Wes approves that placement.
16. Review the SVG for readability before reporting completion.
17. Commit only the diagram and directly related Create PR notes unless Wes authorizes broader wiki updates.
18. Push only under normal Admin wiki push rules.

Output standards:

- Use one-page grouped layout.
- Use readable labels, not tiny text.
- Avoid showing every minor edge if it makes the diagram unreadable.
- Prefer solid arrows for primary handoffs and dashed arrows for support/feedback relationships.
- Include a generated date and short source note in the diagram footer.

## Chat Startup Prompt Requirements

When creating a new PR chat, include:

- `C:\Codex\Wiki Files` as the required working repo.
- A warning not to use the Teams-synced wiki folder.
- Required startup reads from `Project Room Chat Startup Rule.md`.
- The Project Room path.
- The matching skill path.
- The working branch, normally `main`.
- Current status, open decisions, and any automation id or thread id.
- A reminder to leave unrelated dirty work alone.

## Start PR Pointer

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.

## Boundaries

- Do not create Teams folders unless Wes explicitly asks.
- Do not move, rename, delete, or edit an existing Project Room folder or project-specific skill folder merely because Wes asks to create, clean up, align, consolidate, reorganize, standardize, or rename Project Rooms or workflows.
- Before any existing PR or project-specific skill move/rename/delete/edit, state the exact old path, proposed new path, known owning chat/workflow, and whether registry entries, automations, installed skills, or chat titles are affected; then ask `Do you authorize moving/renaming <old path> to <new path>?` and wait for a yes to that specific proposal.
- Do not create automations unless Wes asks for scheduled or event-triggered behavior.
- Do not commit unrelated dirty work or generated scratch folders.
- Do not push unless Wes asks, says the setup is finished, or the applicable Admin wiki rules make the deliverable ready to publish.
