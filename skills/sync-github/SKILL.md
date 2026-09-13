---
name: sync-github
description: Keep the Buy Your Home Admin wiki Git repository current across approved computers through daily or on-demand safe fetch and fast-forward checks. Use for Sync Github computer enrollment, repository freshness checks, local-versus-remote status, safe clean pulls, and multi-machine Git blockers. Do not use to auto-commit, discard, merge, rebase, or push local work.
---

# Sync Github

## Source Of Truth

- Project Room: `C:\Codex\Wiki Files\Project Rooms\Sync Github`
- Skill source: `C:\Codex\Wiki Files\skills\sync-github\SKILL.md`
- Registry: `C:\Codex\Wiki Files\Agents and Automations Registry.md`
- Routing map: `C:\Codex\Wiki Files\Project Rooms\Jean Wright\working\dispatcher-routing-map.md`
- Machine register: `C:\Codex\Wiki Files\Project Rooms\Codex Environment\working\target-computer-register.md`

## Dedicated Task

- Task name: `Sync Github`
- Thread id: `01a02a26-6ffa-7e52-a8ce-825ca0bfe3f0`
- Accept Jean-routed Sync Github work only through this registered task under the central delegation contract.

## Required Startup

1. Confirm the computer name and that the repo is exactly `C:\Codex\Wiki Files`.
2. Read `AGENTS.md`, `Project Room Chat Startup Rule.md`, `Project Room File Ownership And Git Coordination Rule.md`, `Git Work Scope Rule.md`, and the Sync Github README.
3. Confirm the current branch is `main` and inspect `git status --short --branch` before any pull.

## Modes

### Daily Sync

This is the default scheduled workflow on each enrolled computer.

1. The non-administrator Windows Scheduled Task runs `C:\Codex\Wiki Files\tools\sync-github\Invoke-SafeAdminWikiSync.ps1` outside the Codex sandbox.
2. The script verifies the computer, canonical repo, exact origin, `main`, and complete worktree cleanliness.
3. It refuses dirty, ahead, or diverged state without changing history or local work.
4. It fetches `origin main` and runs `git pull --ff-only origin main` only when clean and strictly behind.
5. It synchronizes installed skills only after a successful fast-forward that changed the repo.
6. It writes `%LOCALAPPDATA%\BuyYourHome\SyncGithub\status.json` atomically with result, commit ids, ahead/behind counts, blocker, and notification fingerprint.
7. Codex reads that status file rather than executing unattended Git. Report changed blockers and fast-forwards; keep repeated unchanged states and healthy current results quiet.

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

- Windows Scheduled Task: `BuyYourHome-SyncGithub`, running as the normal non-administrator user with limited run level.
- Installer: `C:\Codex\Wiki Files\tools\sync-github\Install-SafeAdminWikiSyncTask.ps1`.
- Triggers: at logon and every 15 minutes.
- Runner: `C:\Codex\Wiki Files\tools\sync-github\Invoke-SafeAdminWikiSync.ps1`.
- Status file: `%LOCALAPPDATA%\BuyYourHome\SyncGithub\status.json`.
- Codex heartbeat id: `sync-gethub-daily`, retained for compatibility and attached to the existing Sync Github task.
- The heartbeat runs daily at 5:30 AM Eastern and reads the status file only; it does not run Git.
- Repeated identical failures are suppressed through the status file's event fingerprint.
- Do not use a detached Codex cron or a separate permanent `Sync Github Daily` task.

## Outputs And Delivery

- Return computer name, repo path, branch, worktree state, ahead/behind counts, action taken, and blocker when any.
- Save review-ready multi-computer status summaries under `Project Rooms\Sync Github\outputs\` only when requested or materially useful.

## Git Rules

- The scheduled workflow must not create commits or push.
- For durable Sync Github rule or enrollment changes, commit only Sync Github files and specifically authorized registry, routing, or index updates.
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
