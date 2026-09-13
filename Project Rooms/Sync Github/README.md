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

This is the default workflow. Git runs outside the Codex sandbox through a pinned, machine-local Windows Scheduled Task.

1. Run `C:\Codex\Wiki Files\tools\sync-github\Invoke-SafeAdminWikiSync.ps1` as the approved non-administrator Windows user.
2. Confirm the script verifies the canonical repo, `main`, and the exact `BuyYourHome/Admin-Wiki` origin before fetching.
3. Refuse a dirty, ahead, or diverged repository without altering local work.
4. Fetch `origin main`; pull with `git pull --ff-only origin main` only when clean and strictly behind.
5. Synchronize installed wiki-managed skills only after a successful fast-forward that changed the repository.
6. Write the result atomically to `%LOCALAPPDATA%\BuyYourHome\SyncGithub\status.json`.
7. Codex reads the status file; it does not run unattended Git commands. Notify only for a changed blocker or completed fast-forward.

### Manual Sync Check

Use this mode when Wes asks for an immediate repository status or safe synchronization check on the current computer. Apply the same safety gates as Daily Sync.

## Multi-Computer Enrollment

- Registered computers: `WesStudio`, `Wes-VideoEditor`, and `OfficeAssist`.
- Any future computer added to the authoritative Codex Environment target-computer register must be considered for enrollment.
- Each computer requires its own local scheduled automation because a Codex automation runs on its configured host; a schedule created on one computer does not prove installation on another.
- A computer is not marked enrolled until its canonical repo, GitHub access, local automation, and one safe run are verified on that computer.

## Current Status

Status: active and dispatchable through the registered dedicated task. OFFICEASSIST installed and validated the machine-local safe-sync Scheduled Task on 2026-09-13; other computers require separate installation and verification.

## Matching Skill

- Skill source: `C:\Codex\Wiki Files\skills\sync-github\SKILL.md`

## Dedicated Chat

- Chat name: `Sync Github`
- Thread id: `01a02a26-6ffa-7e52-a8ce-825ca0bfe3f0`
- Purpose: own daily repository freshness checks, computer enrollment state, blockers, and safe recovery recommendations.

## Automation

- Windows Scheduled Task: `BuyYourHome-SyncGithub`.
- Installer: `C:\Codex\Wiki Files\tools\sync-github\Install-SafeAdminWikiSyncTask.ps1`.
- Runner: `C:\Codex\Wiki Files\tools\sync-github\Invoke-SafeAdminWikiSync.ps1`.
- Principal: the machine's normal non-administrator Windows profile; on OFFICEASSIST this is `OfficeAssistLogin` with limited run level.
- Triggers: at user logon and every 15 minutes.
- Local status: `%LOCALAPPDATA%\BuyYourHome\SyncGithub\status.json`, written atomically.
- Codex heartbeat id: `sync-gethub-daily`; retain this compatibility id and attach it to the existing `Sync Github` task.
- The heartbeat reads the local status file at 5:30 AM Eastern and does not execute Git.
- Do not deploy detached Codex cron execution chats or a separate permanent `Sync Github Daily` task.
- The 24/7 PR messaging worker uses its pinned local release and must not depend on GitHub during routine queue checks.

OFFICEASSIST validation covers normal scheduled execution, dirty-worktree refusal without alteration, already-current behavior, an isolated safe fast-forward, repeated-failure suppression, limited-user execution, and persistent registered logon/repeating triggers. Verification of persistence is structural; it does not require rebooting the active office computer.

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

1. Deploy and validate the same Windows Scheduled Task separately on each approved computer.
2. Keep PR messaging runtime deployment independent from repository synchronization.
