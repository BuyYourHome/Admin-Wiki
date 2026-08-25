# Sync Github Project Room

## Purpose

Keep the canonical Admin wiki Git repository current across every approved Buy Your Home computer that has `C:\Codex\Wiki Files` configured.

GitHub is the exchange point between computers. Each enrolled computer runs the same local check at least once daily, fetches current remote state, and fast-forwards local `main` only when doing so cannot overwrite or conceal local work.

## Scope

In scope:

- Daily and on-demand Git freshness checks on each enrolled computer.
- Verifying the exact computer, canonical repo path, `main` branch, worktree state, and relationship to `origin/main`.
- Fetching `origin` and using `git pull --ff-only` only when local `main` is clean, only behind, and safe to fast-forward.
- Reporting dirty worktrees, local-only commits, remote-only commits, divergence, authentication failures, locks, and unavailable computers.
- Tracking which approved computers have the local Sync Github automation installed and verified.

Out of scope:

- Automatically committing, stashing, discarding, resetting, rebasing, merging, or force-pushing work.
- Automatically pushing local commits. Completed work remains subject to the owning Project Room and shared-main push rules.
- Resolving conflicts or deciding which machine's work should win.
- Using a Teams-synced Wiki Files folder as the repository.
- Remoting into, configuring, or installing the automation on another computer without the authorization required by Codex Environment.
- Syncing installed Codex skill copies; Codex Environment owns broader machine update and skill-deployment work.

## Folder Map

- `sources\` - Wes instructions and approved machine/source references.
- `working\source-inventory.md` - authoritative rules and machine references.
- `working\duplicate-and-conflict-log.md` - overlap and conflict decisions.
- `working\missing-context.md` - incomplete enrollment or automation deployment details.
- `working\repository-sync-action-log.md` - material deployment, blocker, and recovery outcomes; routine healthy runs stay in automation history so they do not dirty the repo.
- `outputs\` - review-ready multi-machine status summaries when needed.

## Modes

### Daily Sync

This is the default workflow. Run locally on every enrolled computer at least once each day.

1. Confirm the computer name and canonical repo path.
2. Confirm the current branch is `main`.
3. Run `git fetch origin` through an approved execution path that can write Git metadata, including `.git\FETCH_HEAD`.
4. Inspect worktree status and the ahead/behind relationship between `main` and `origin/main`.
5. If the worktree is clean and local `main` is only behind, run `git pull --ff-only origin main`.
6. If already current, finish without changing files.
7. If the managed Codex runner fails with `.git\FETCH_HEAD: Permission denied`, retry only through a Wes-approved unsandboxed/local execution path. If no approved unsandboxed path is available for that machine, report the automation as not viable unattended.
8. If dirty, ahead, diverged, locked, on another branch, unable to authenticate, or unable to write required Git metadata, do not pull or alter local work; return the exact computer-specific blocker.

### Manual Sync Check

Use this mode when Wes asks for an immediate repository status or safe synchronization check on the current computer. Apply the same safety gates as Daily Sync.

## Multi-Computer Enrollment

- Registered computers: `WesStudio`, `Wes-VideoEditor`, and `OfficeAssist`.
- Any future computer added to the authoritative Codex Environment target-computer register must be considered for enrollment.
- Each computer requires its own local scheduled automation because a Codex automation runs on its configured host; a schedule created on one computer does not prove installation on another.
- A computer is not marked enrolled until its canonical repo, GitHub access, local automation, and one safe run are verified on that computer.

## Current Status

Status: active and dispatchable through the registered dedicated task. The local automation is active on `WesStudio`; first-run verification and other-computer enrollment remain pending.

The local Project Room package and `sync-gethub-daily` automation are installed on `WesStudio`. `Wes-VideoEditor` and `OfficeAssist` enrollment each require a separate authorized deployment on that computer.

## Matching Skill

- Skill source: `C:\Codex\Wiki Files\skills\sync-github\SKILL.md`

## Dedicated Chat

- Chat name: `Sync Github`
- Thread id: `01a02a26-6ffa-7e52-a8ce-825ca0bfe3f0`
- Purpose: own daily repository freshness checks, computer enrollment state, blockers, and safe recovery recommendations.

## Automation

- Automation id: `sync-gethub-daily`
- Compatibility: retain this existing automation id across enrolled computers; the workflow, room, skill, and task use `Sync Github`.
- Automation kind: `heartbeat`, attached to the computer's existing `Sync Github` task.
- Required cadence: at least once daily on every enrolled computer.
- Initial schedule: daily at 5:30 AM Eastern on each enrolled computer.
- Deployment state: active on `WesStudio`; pending separate installation and verification on `Wes-VideoEditor` and `OfficeAssist`.
- A machine-local automation is not fully verified until one safe run proves `git fetch origin` can update `.git\FETCH_HEAD`. On OfficeAssist, the normal managed runner could read the repo but could not fetch because `.git\FETCH_HEAD` was permission-denied; the safe run succeeded only through an approved unsandboxed path.
- Do not deploy this workflow as a detached `cron` automation. Detached cron runs create a new `Sync Github Daily` execution chat on every run.
- Do not create a separate permanent chat named `Sync Github Daily`. Keep one `Sync Github` task and one attached heartbeat per enrolled computer.

## Reporting And Logging

- Routine healthy no-change runs should remain quiet.
- Report a fast-forward update with computer name and before/after commit ids.
- Report dirty, ahead, diverged, locked, authentication, wrong-branch, missing-repo, and unreachable-host states as blockers without changing local work.
- Record only material deployment, recurring blocker, recovery, or enrollment outcomes in `working\repository-sync-action-log.md`; do not create a Git change for every healthy daily run.

## Main And Push

- Work on `main`.
- Follow `C:\Codex\Wiki Files\Project Room File Ownership And Git Coordination Rule.md`.
- Commit only Sync Github files and specifically authorized registry, routing, and index updates.
- The scheduled sync workflow must not commit or push work automatically.
- Push setup changes only under the Admin wiki push rules.

## Start PR Pointer

Start PR: Before durable work, follow Start PR in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on main unless Wes explicitly asks for a branch.

## Delegation Contract

Delegation Contract: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Jean may delegate this PR's work only to its registered task; accept and return the same dispatch id under the central contract.

## Action Ownership

Action Ownership: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return accepted, done, blocked, needs Wes, or rejected as wrong room.

## PR Messaging

PR Messaging: Follow `C:\Codex\Wiki Files\Project Room Messaging Rule.md`. The central message record is authoritative; task messages are wake-up signals, not delivery proof.

## Next Actions

1. Run and verify the first scheduled or manual `WesStudio` automation execution.
2. Use authorized Codex Environment deployments to install and verify the same automation on `Wes-VideoEditor`, `OfficeAssist`, and later approved computers.
