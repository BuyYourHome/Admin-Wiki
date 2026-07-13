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

Use this skill for creating or maintaining the standard Buy Your Home Project Room package: Project Room, matching wiki-managed skill, registry entry when needed, and dedicated Codex chat.

## Required Startup

Before Create PR file work:

1. Confirm the working folder is `C:\Codex\Wiki Files`.
2. Read `Admin Home.md`, `AGENTS.md`, `Project Room Workflow.md`, `Project Room Chat Startup Rule.md`, `Agent Unit Standard.md`, `Codex Skill Source Rule.md`, and `Git Work Scope Rule.md`.
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
4. Check whether the Project Room, skill, registry entry, or chat already exists.
5. Create the Project Room folders under `Project Rooms\<Project Name>\`: `sources\`, `working\`, and `outputs\`.
6. Create the room README with purpose, scope, folder map, status, matching skill, dedicated chat when any, Start PR pointer, branch rule, and next actions.
7. Create the standard working files:
   - `working\source-inventory.md`
   - `working\duplicate-and-conflict-log.md`
   - `working\missing-context.md`
8. Include this short pointer in the README and matching skill instead of copying the full central rule: `Start PR: Before durable work, follow Start PR Mode in C:\Codex\Wiki Files\Project Room Chat Startup Rule.md. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on main unless Wes explicitly asks for a branch.`
9. Create the matching skill under `skills\<skill-name>\SKILL.md` with source paths, required startup, workflow, boundaries, outputs, and Git rules.
10. Add `skills\<skill-name>\agents\openai.yaml` when practical.
11. Update `Agents and Automations Registry.md` when the room is repeatable, agent-like, has a dedicated chat, or may later have automation.
12. Add `Admin Home.md` links when the room should be visible from the wiki start page.
13. Create or hand off to a dedicated chat using `Project Room Chat Startup Rule.md` only when Wes explicitly asks or when no existing chat should own the work.
14. Commit only the scoped Project Room, skill, registry, and index changes. Push only under the Admin wiki push rules.

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
- Do not move source files from another Project Room unless Wes authorizes that move.
- Do not create automations unless Wes asks for scheduled or event-triggered behavior.
- Do not commit unrelated dirty work or generated scratch folders.
- Do not push unless Wes asks, says the setup is finished, or the applicable Admin wiki rules make the deliverable ready to publish.
