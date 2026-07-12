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
- Moving source files from another Project Room unless Wes explicitly authorizes the move.
- Creating automations unless Wes explicitly asks for a scheduled or event-triggered runner.
- Publishing or pushing unrelated dirty work.

## Folder Map

- `sources\` - examples, source notes, or prior room-creation instructions.
- `working\source-inventory.md` - inventory of source rules and examples used to build PR setup instructions.
- `working\duplicate-and-conflict-log.md` - conflicting or superseded room-creation rules.
- `working\missing-context.md` - open decisions about room, skill, chat, branch, or automation setup.
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

## Branch And Push Mode

- Project branch: `project/create-pr`
- Before durable file work, confirm the repo is `C:\Codex\Wiki Files` and switch to this branch when safe.
- If Git processes, lock files, or unrelated dirty files block switching, report the blocker instead of forcing, stashing, resetting, or deleting files.
- When Wes says `Push` in this PR, commit only the Create PR room, matching skill, and directly related registry/index changes.

## Main Branch Rule

When creating a new PR, start from `main`.

1. Check `git status --short --branch`.
2. If the repo is not on `main`, switch to `main` only when the worktree is clean or the dirty files are clearly part of the current scoped Create PR setup and can safely move with the branch.
3. If unrelated dirty work, Git locks, or branch conflicts block switching to `main`, stop and report the blocker. Do not force, stash, reset, delete, or carry unrelated work into the new PR.
4. Create the new project branch from `main`, using `project/<project-room-slug>` unless Wes gives another branch name.
5. Create the Project Room, skill, registry, index, and startup chat from that new branch.

## Standard Create PR Workflow

1. Confirm the requested PR name and normalize the matching skill name to lower-case hyphen-case.
2. Verify the canonical repo is `C:\Codex\Wiki Files`.
3. Start from `main` under the Main Branch Rule, then create or switch to the scoped project branch for the new PR.
4. Check whether the Project Room, skill, registry entry, or chat already exists.
5. Create the Project Room folders: `sources\`, `working\`, and `outputs\`.
6. Create `README.md`, `working\source-inventory.md`, `working\duplicate-and-conflict-log.md`, and `working\missing-context.md`.
7. Create the matching wiki-managed skill under `skills\<skill-name>\SKILL.md`.
8. Add an `agents\openai.yaml` file for the skill when practical.
9. Update `Agents and Automations Registry.md` when the workflow is agent-like, repeatable, or expected to have a dedicated chat.
10. Add an `Admin Home.md` link when the room should be easy to find from the wiki start page.
11. Create the new Codex chat using the Project Room Chat Startup Rule startup text.
12. Commit the scoped durable files locally.
13. Push only when Wes explicitly asks, says the work is finished, or the applicable rule defines the deliverable as ready to publish.

## New Chat Startup Requirements

Every new PR chat created by this workflow should include:

- canonical repo path,
- warning not to use the Teams-synced wiki folder,
- required startup reads,
- Project Room path,
- matching skill path,
- project branch when known,
- current status and open decisions,
- instruction to leave unrelated dirty work alone.
