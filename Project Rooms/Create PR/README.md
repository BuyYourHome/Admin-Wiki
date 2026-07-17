# Create PR Project Room

## Purpose

This Project Room defines the repeatable workflow for creating a new Buy Your Home Project Room, matching Codex skill, and dedicated startup chat.

Use this room when Wes asks to create a new PR, Project Room, room-specific skill, or room-specific chat for a recurring body of work.

## Scope

In scope:

- New Project Room setup under `C:\Codex\Wiki Files\Project Rooms\<Project Name>`.
- Matching wiki-managed skill setup under `C:\Codex\Wiki Files\skills\<skill-name>`.
- Startup prompt or handoff text for a new Codex chat.
- Registry updates in `Agents and Automations Registry.md` when the new room is agent-like or repeatable.
- Links from `Admin Home.md` when the room should be visible from the Admin wiki start page.

Out of scope:

- Creating Teams folders unless Wes explicitly asks for a final deliverable there.
- Moving, renaming, deleting, or editing any existing Project Room folder or project-specific skill folder unless Wes answers yes to the exact proposed change under `Project Room File Ownership And Git Coordination Rule.md`.
- Creating automations unless Wes explicitly asks for a scheduled or event-triggered runner.
- Publishing or pushing unrelated dirty work.

## Folder Map

- `sources\` - examples, source notes, or prior room-creation instructions.
- `working\source-inventory.md` - inventory of source rules and examples used to build PR setup instructions.
- `working\duplicate-and-conflict-log.md` - conflicting or superseded room-creation rules.
- `working\missing-context.md` - open decisions about room, skill, chat, Git handling, or automation setup.
- `outputs\` - review-ready startup prompts, checklists, or templates for future PR creation.

## Current Status

Status: active.

This room was created to hold the standard Create PR process.

## Matching Skill

- Skill source: `C:\Codex\Wiki Files\skills\create-pr\SKILL.md`

## Dedicated Chat

- Chat name: `Create PR`
- Thread id: `019f583e-7f14-7ae2-aa24-4e991544e306`
- Purpose: continue developing and using this Project Room creation workflow.

## Main And Push Mode

- Working branch: `main`
- Before durable file work, confirm the repo is `C:\Codex\Wiki Files` and switch to `main` when safe.
- Do not create a new Git branch for a new PR unless Wes explicitly asks for a branch.
- If Git processes, lock files, or unrelated dirty files block switching to `main`, report the blocker instead of forcing, stashing, resetting, or deleting files.
- Follow `Project Room File Ownership And Git Coordination Rule.md` for PR file ownership, shared Admin file edits, cross-PR edits, fetch/pull safety, and push safety.
- When Wes says `Push` in this PR, commit only the Create PR room, matching skill, and directly related registry/index changes.

## Start PR Pointer

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.

## Main Branch Rule

When creating a new PR, work from `main`.

1. Check `git status --short --branch`.
2. If the repo is not on `main`, switch to `main` only when the worktree is clean or the dirty files are clearly part of the current scoped setup and can safely move with the branch.
3. If unrelated dirty work, Git locks, or branch conflicts block switching to `main`, stop and report the blocker. Do not force, stash, reset, delete, or carry unrelated work into the new PR.
4. Create the Project Room, skill, registry, and index files on `main`.
5. Create a new chat only when Wes explicitly asks or when there is no existing chat that should own the work.

## Dedicated Chat Connector Rule

When creating a new PR requires a dedicated Codex task:

1. Create and commit the Project Room files, matching skill, registry entry, and Admin Home link first.
2. Try the Codex app task-creation connector once.
3. If the connector does not return promptly or does not return a usable thread id, stop waiting on the connector.
4. Leave the README and registry `Thread id` as `pending until the dedicated chat is created`.
5. Report that the local PR package is complete and the dedicated task creation is pending because the connector did not return.
6. Do not let task creation block the whole PR setup, and do not retry indefinitely in the same turn.
7. When the connector later succeeds, record the returned thread id in the PR README and registry, then commit that small metadata update separately.

## Standard Create PR Workflow

1. Confirm the requested PR name and normalize the matching skill name to lower-case hyphen-case.
2. Verify the canonical repo is `C:\Codex\Wiki Files`.
3. Work from `main` under the Main Branch Rule.
4. Check whether the Project Room, skill, registry entry, or chat already exists.
5. Create the Project Room folders: `sources\`, `working\`, and `outputs\`.
6. Create `README.md`, `working\source-inventory.md`, `working\duplicate-and-conflict-log.md`, and `working\missing-context.md`.
7. In the new README, include the short Start PR pointer from `Project Room Chat Startup Rule.md`, not the full central rule text.
8. Create the matching wiki-managed skill under `skills\<skill-name>\SKILL.md`.
9. In the new skill, include the same short Start PR pointer.
10. Include the new PR under the ownership and Git coordination rule; do not set up a new room so that it can edit other PR files by default.
11. Add an `agents\openai.yaml` file for the skill when practical.
12. Update `Agents and Automations Registry.md` when the workflow is agent-like, repeatable, or expected to have a dedicated chat.
13. Add an `Admin Home.md` link when the room should be easy to find from the wiki start page.
14. Create and commit the scoped durable files locally before attempting a dedicated Codex task.
15. Create a new Codex chat using the Project Room Chat Startup Rule startup text only when Wes explicitly asks or when no existing chat should own the work; follow the Dedicated Chat Connector Rule so connector delays do not block setup.
16. If a dedicated chat is created, record the returned thread id in the README and registry and commit that metadata update separately.
17. Push only when Wes explicitly asks, says the work is finished, or the applicable rule defines the deliverable as ready to publish.

## Existing PR Rename Or Move Rule

A broad request to clean up, standardize, align, consolidate, or reorganize Project Rooms is not enough to move, rename, delete, or edit an existing Project Room or project-specific skill.

Before any existing PR or project-specific skill move/rename/delete/edit, state the exact old path, proposed new path, known owning chat/workflow, and whether registry entries, automations, installed skills, or chat titles are affected. Then ask:

```text
Do you authorize moving/renaming <old path> to <new path>?
```

Do not make the change until Wes answers yes to that specific proposal.

## New Chat Startup Requirements

Every new PR chat created by this workflow should include:

- canonical repo path,
- warning not to use the Teams-synced wiki folder,
- required startup reads,
- Project Room path,
- matching skill path,
- working branch, normally `main`,
- current status and open decisions,
- instruction to leave unrelated dirty work alone.
