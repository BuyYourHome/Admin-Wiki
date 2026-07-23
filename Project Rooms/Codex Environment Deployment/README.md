# Codex Environment Deployment Project Room

## Purpose

This Project Room owns the workflow for preparing other authorized computers to replicate the Codex working environment from WesStudio.

Use this room when Wes asks Codex to remote into a computer, inspect what is missing, install required apps, configure the Admin wiki/Codex working environment, or verify that the target computer can run the same Admin wiki workflows as WesStudio.

## Scope

In scope:

- Building and maintaining a WesStudio baseline inventory of required applications, runtimes, credentials prerequisites, repo locations, Codex app settings, connectors, plugins, skills, and verification checks.
- Remoting into computers that Wes explicitly authorizes for the specific setup session.
- Installing or configuring approved applications needed to replicate the Codex environment.
- Cloning or configuring the canonical Admin wiki repository at `C:\Codex\Wiki Files` on the target computer.
- Syncing wiki-managed Codex skills from the canonical Admin wiki source after the target repo is current.
- Recording per-computer setup notes, missing prerequisites, blockers, and verification results.

Out of scope:

- Remote access to any computer unless Wes explicitly authorizes that target computer and setup session.
- Storing passwords, tokens, recovery codes, payment details, license keys, or other live secrets in the wiki, Project Room, skill, git history, or chat.
- Installing paid software, accepting paid plans, purchasing licenses, changing security settings, or changing account ownership unless Wes explicitly approves the specific action.
- Copying files from Teams-synced wiki folders as the working repository.
- Editing another Project Room's files or matching skill unless Wes explicitly authorizes that specific cross-PR edit.

## Folder Map

- `sources\` - source notes, approved baseline exports, install references, target-computer source summaries, and Wes-provided setup instructions.
- `working\source-inventory.md` - inventory of baseline and target-machine sources.
- `working\duplicate-and-conflict-log.md` - conflicting app lists, outdated setup notes, or unclear machine states.
- `working\missing-context.md` - missing target details, approvals, access blockers, and app decisions.
- `working\target-computer-register.md` - durable status table for computers being prepared.
- `outputs\` - review-ready setup checklists, run summaries, verification reports, and handoffs.

## Modes

- Update Codex Environment Mode: use `outputs\Update Codex Environment Mode.md` when Wes asks to keep an already prepared target computer current with changes from WesStudio. This mode pulls the target repo, syncs wiki-managed skills, restarts or refreshes Codex, and verifies repo/skill state without installing apps or changing accounts.

## Current Status

Status: `Wes-VideoEditor` core Admin wiki environment and Codex Desktop project connection installed and verified on 2026-07-22; connector sign-ins, plugin cache, and live workflow execution remain unverified.

WesStudio's non-secret hardware, Windows, Codex, repo, runtime, application, skill, plugin, and remote-access baseline was inventoried on 2026-07-21. Wes approved the Step 2 Core, Business, Optional, and Safety Groups on 2026-07-21. Step 3 created the setup/verification package, and Step 4 authorized the exact `Wes-VideoEditor` scope. Step 5 connected over the private LAN, verified the session identity, and completed a read-only inventory in `outputs\Wes-VideoEditor Initial Inventory.md`. Storage initially blocked installation because `C:` had 4.8 GB free. After cleanup, Git, the canonical Admin wiki repo, LibreOffice, Obsidian, wiki-managed skills, and Codex Desktop were installed and verified. The `Admin Wiki` Codex project was created against `C:\Codex\Wiki Files` and passed a read-only repo check. Final core verification is recorded in `outputs\Wes-VideoEditor Core Environment Verification.md`. Durable migration lessons are recorded in `working\migration-lessons-learned.md`.

## Remote Access And Install Safety

- Remote into only the specific computer Wes authorizes for that setup run.
- Confirm the remote-control tool and session identity before making changes.
- Do not save credentials or authentication tokens. If sign-in is required, have Wes or the authorized user enter credentials directly.
- Do not disable antivirus, firewall, BitLocker, Windows security features, or endpoint protection unless Wes explicitly approves that exact change.
- Do not install paid apps, trials that create billing risk, browser extensions, remote-control tools, VPNs, credential managers, or system-level agents unless Wes explicitly approves that exact item.
- Keep a target-computer run note with machine name, user, date, apps installed, configuration changed, verification result, and blockers.

## WesStudio Baseline

Before declaring another computer ready, identify and document the WesStudio baseline:

- Windows version and architecture.
- Codex app installation and sign-in prerequisites.
- Canonical Admin wiki repo path: `C:\Codex\Wiki Files`.
- Git/GitHub setup and repository access.
- Codex workspace Python/runtime expectations.
- LibreOffice path and document/PDF render tools.
- Browser and Chrome/Outlook/Teams/SharePoint connector prerequisites.
- Required installed Codex skills and sync process.
- Any additional apps needed for document, spreadsheet, PDF, browser, email, Teams, SharePoint, image, or website workflows.

## Matching Skill

- Skill source: `C:\Codex\Wiki Files\skills\codex-environment-deployment\SKILL.md`

## Dedicated Chat

- Chat name: `Codex Environment Deployment`
- Thread id: `019f84d0-78d4-7013-8c07-42c01f961be1`

## Start PR

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.

## Ownership And Git Mode

- Working branch: `main`.
- Before durable file work, confirm the repo is `C:\Codex\Wiki Files` and the current branch is `main`.
- Follow `Project Room File Ownership And Git Coordination Rule.md` for Project Room ownership, shared Admin files, cross-PR edits, fetch/pull safety, commit scope, and push safety.
- Commit only scoped Codex Environment Deployment room, matching skill, and directly related registry/index changes.
- Push only when Wes explicitly asks, says the work is finished, or the applicable Admin wiki rules define the deliverable as final and ready to publish.

## Next Actions

1. Verify Codex/GitHub authorization when a private fetch, push, or PR operation is needed.
2. Verify needed Outlook, Teams, SharePoint, Chrome/browser, and GitHub connector/plugin sign-ins.
3. Confirm plugin cache after connector/plugin setup.
4. Run one low-risk Admin wiki workflow from `Wes-VideoEditor` to confirm end-to-end operation.
5. Free more `C:` drive space if practical; 20 GB or more is preferred for stable ongoing use.
