---
name: sync-gethub
description: Keep the Buy Your Home Admin wiki Git repository current across approved computers through daily or on-demand safe fetch and fast-forward checks. Use for Sync GetHub computer enrollment, repository freshness checks, local-versus-remote status, safe clean pulls, and multi-machine Git blockers. Do not use to auto-commit, discard, merge, rebase, or push local work.
---

# Sync GetHub

## Source Of Truth

- Project Room: `C:\Codex\Wiki Files\Project Rooms\Sync GetHub`
- Skill source: `C:\Codex\Wiki Files\skills\sync-gethub\SKILL.md`
- Registry: `C:\Codex\Wiki Files\Agents and Automations Registry.md`
- Routing map: `C:\Codex\Wiki Files\Project Rooms\Jean Wright\working\dispatcher-routing-map.md`
- Machine register: `C:\Codex\Wiki Files\Project Rooms\Codex Environment\working\target-computer-register.md`

## Required Startup

1. Confirm the computer name and that the repo is exactly `C:\Codex\Wiki Files`.
2. Read `AGENTS.md`, `Project Room Chat Startup Rule.md`, `Project Room File Ownership And Git Coordination Rule.md`, `Git Work Scope Rule.md`, and the Sync GetHub README.
3. Confirm the current branch is `main` and inspect `git status --short --branch` before any pull.

## Modes

### Daily Sync

This is the default scheduled workflow on each enrolled computer.

1. Identify the computer and verify the canonical repo and `origin`.
2. Run `git fetch origin`.
3. Determine whether local `main` is clean, ahead, behind, diverged, or on the wrong branch.
4. Pull with `git pull --ff-only origin main` only when the worktree is clean and local `main` is only behind.
5. If already current, finish quietly without file changes.
6. If dirty, ahead, diverged, locked, on another branch, missing, or unable to authenticate, do not alter local work. Return the exact computer-specific blocker.
7. For a successful fast-forward, report the computer name and before/after commit ids.

### Manual Sync Check

Use when Wes asks for an immediate repository status or safe synchronization check. Apply the same safety gates as Daily Sync.

## Multi-Computer Rules

- GitHub is the shared exchange point; do not synchronize through a Teams-synced Wiki Files folder.
- Every approved computer needs its own local automation and one verified safe run.
- Use the Codex Environment target-computer register as the enrollment source.
- A local automation record does not prove another computer is enrolled.
- Remote setup and installation belong to Codex Environment and require the authorization documented there.
- Uncommitted or unpushed work on another computer cannot be incorporated from the current computer. Report the owning computer as unresolved.

## Boundaries

- Never auto-commit, stash, discard, reset, clean, rebase, merge, checkout over changes, or force-push.
- Never pull over a dirty worktree.
- Never automatically push local commits.
- Never decide which side of a divergence should win.
- Do not edit another Project Room's files while checking repository state.
- Do not sync installed skill copies; route broader environment update work to Codex Environment.

## Automation

- Automation id: `sync-gethub-daily`.
- Schedule: daily at 5:30 AM Eastern on each enrolled computer.
- Routine healthy no-change runs remain quiet.
- Any blocker or fast-forward update should be reported with the computer identity.
- Record only material deployment, recurring blocker, recovery, or enrollment outcomes in `working\repository-sync-action-log.md` so normal runs do not make the repo dirty.

## Outputs And Delivery

- Return computer name, repo path, branch, worktree state, ahead/behind counts, action taken, and blocker when any.
- Save review-ready multi-computer status summaries under `Project Rooms\Sync GetHub\outputs\` only when requested or materially useful.

## Git Rules

- The scheduled workflow must not create commits or push.
- For durable Sync GetHub rule or enrollment changes, commit only Sync GetHub files and specifically authorized registry, routing, or index updates.
- Leave unrelated dirty work untouched.
- Push only under the Admin wiki push rules.

## Start PR Pointer

Start PR: Before durable work, follow Start PR in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on main unless Wes explicitly asks for a branch.

## Delegation Contract

Delegation Contract: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Jean may delegate this PR's work only to its registered task; accept and return the same dispatch id under the central contract.

## Action Ownership

Action Ownership: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return accepted, done, blocked, needs Wes, or rejected as wrong room.

## PR Messaging

PR Messaging: Follow `C:\Codex\Wiki Files\Project Room Messaging Rule.md`. The central message record is authoritative; task messages are wake-up signals, not delivery proof.
