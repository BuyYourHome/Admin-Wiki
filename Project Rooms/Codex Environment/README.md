# Codex Environment Project Room

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
- Recording setup-run notes, missing prerequisites, blockers, and verification results for authorized target computers.
- Sending setup outcome handoffs to the Computers Project Room when a machine's inventory, role, lifecycle status, or readiness summary changes.

Out of scope:

- Remote access to any computer unless Wes explicitly authorizes that target computer and setup session.
- Storing passwords, tokens, recovery codes, payment details, license keys, or other live secrets in the wiki, Project Room, skill, git history, or chat.
- Installing paid software, accepting paid plans, purchasing licenses, changing security settings, or changing account ownership unless Wes explicitly approves the specific action.
- Copying files from Teams-synced wiki folders as the working repository.
- Maintaining the authoritative computer inventory. `Project Rooms\Computers\working\computer-register.md` is the source of truth for the list of business computers, machine specs, assigned roles, lifecycle status, and overall readiness summary.
- Editing another Project Room's files or matching skill unless Wes explicitly authorizes that specific cross-PR edit.

## Folder Map

- `sources\` - source notes, approved baseline exports, install references, target-computer source summaries, and Wes-provided setup instructions.
- `working\source-inventory.md` - inventory of baseline and target-machine sources.
- `working\duplicate-and-conflict-log.md` - conflicting app lists, outdated setup notes, or unclear machine states.
- `working\missing-context.md` - missing target details, approvals, access blockers, and app decisions.
- `working\target-computer-register.md` - setup-run/status log for Codex Environment work. This is not the authoritative computer inventory.
- `outputs\` - review-ready setup checklists, run summaries, verification reports, and handoffs.

## Modes

Use these modes to keep machine setup, machine updates, role assignment, replacement, retirement, and health checks separate.

### Baseline Machine Setup

Use this mode when Wes authorizes preparing a computer that has never been configured for the Buy Your Home Codex/Admin wiki environment.

This mode may include:

- verifying the exact target computer, signed-in user, admin rights, Windows edition, architecture, RAM, disk capacity, and free space;
- confirming the intended Windows sign-in account, Windows profile, assigned human user, and business Microsoft 365 identity before installing profile-specific tools or configuring Codex;
- installing approved required apps and prerequisites, such as Git, LibreOffice, Obsidian, Chrome, and Codex Desktop when missing;
- configuring the canonical Admin wiki repo at `C:\Codex\Wiki Files`;
- cloning or updating `BuyYourHome/Admin-Wiki` on `main`;
- syncing wiki-managed skills only after the target repo is current;
- verifying Codex Desktop can open a `Wiki Files` project pointed at `C:\Codex\Wiki Files`;
- verifying plugin/cache presence and connector availability;
- running one low-risk Admin wiki workflow before marking the machine ready.

This mode does not authorize paid software, remote-control tools, VPNs, browser extensions, credential managers, security-setting changes, account ownership changes, or secret storage unless Wes explicitly approves the exact item.

Do not default new implementations to `WesBrowning1@Outlook.com`. That account may be used only when Wes explicitly designates it for the specific machine. Otherwise, pause profile-specific setup until Wes confirms the intended login and business identity for that machine.

Before making profile-specific changes, confirm and record:

- computer name;
- signed-in Windows user and profile path;
- assigned human user;
- intended business Microsoft 365 identity.
- designated GitHub identity for this computer and confirmation that it has access to `BuyYourHome/Admin-Wiki`.

Do not continue when the signed-in Windows profile or GitHub identity does not match the implementation plan. Profile-specific setup includes Codex Desktop, Git global identity, `%USERPROFILE%\.codex\skills`, OneDrive, Outlook, Teams, browser sessions, GitHub authentication, and connectors.

Each target computer should have its own designated GitHub account or machine-specific GitHub identity with access to `BuyYourHome/Admin-Wiki`. Do not reuse Wes's personal GitHub identity, another user's GitHub identity, or a prior machine's GitHub credentials unless Wes explicitly approves that exact exception for the target computer. Do not store GitHub passwords, personal access tokens, recovery codes, or credential-manager secrets in the wiki, scripts, Git history, or chat notes.

### Canonical Admin Wiki Project Setup

Use this sequence when configuring the Admin wiki on a target computer:

1. Confirm the canonical Admin wiki Git repository exists at `C:\Codex\Wiki Files`.
2. If it is not present, clone the authorized `BuyYourHome/Admin-Wiki` repository into that exact location.
3. Confirm `C:\Codex\Wiki Files` is a valid Git repository on `main`.
4. Confirm the target computer's designated GitHub identity can access `BuyYourHome/Admin-Wiki` before private fetch, clone, or connector verification.
5. Fetch the remote and update only with fast-forward-only behavior.
6. Do not merge, rebase, reset, discard local work, or push from the target machine during setup unless Wes explicitly authorizes that exact action.
7. Confirm and record:
   - active repository path;
   - current branch;
   - Git status;
   - local-versus-`origin/main` comparison;
   - latest commit.
8. Confirm `C:\Codex\Wiki Files` and `C:\Codex\Wiki Files\.git` are owned by, or grant full control to, the intended Windows profile that will run Codex. This is required when the repo was cloned, copied, repaired, or previously used under another Windows profile.
9. Sync wiki-managed Codex skills only after the repository is current, using `C:\Codex\Wiki Files\tools\sync-codex-skills.ps1`.
10. In Codex Desktop, add or open `C:\Codex\Wiki Files` as a saved local project named `Wiki Files`.
11. Verify the saved Codex project points to `C:\Codex\Wiki Files`, not a Teams- or OneDrive-synced location.
12. Open a new Codex task in that saved project and run normal read-only verification:
    - report the working folder;
    - run `git status --short --branch`;
    - compare local `main` with `origin/main`;
    - read one applicable installed skill.
13. Confirm commands run through Codex's normal managed execution path without elevation.

### Managed Runtime Failure Recovery

If a normal Codex command fails before launch with:

```text
Failed to create unified exec process: helper_unknown_error: setup refresh had errors
```

then:

1. Confirm commands and the repository themselves work through a harmless read-only diagnostic outside the managed sandbox.
2. Do not alter the Admin wiki repository.
3. With Wes's approval, fully quit Codex, including its system-tray process.
4. Rename the affected user's local cache at `C:\Users\<Windows-user>\.cache\codex-runtimes` to a dated backup such as `codex-runtimes.backup-YYYYMMDD`.
5. Reopen Codex and allow it to rebuild the runtime.
6. Open a brand-new task in the saved `Wiki Files` project and repeat the normal managed-command verification.
7. Do not delete the backup until the rebuilt runtime is confirmed healthy.
8. If the failure remains, inspect the affected user's `C:\Users\<Windows-user>\.codex\.sandbox\setup_error.json` and current `sandbox*.log` for the specific setup error.
9. If the sandbox log reports `SetNamedSecurityInfoW failed: 5`, `write ACE failed`, `deny ACE failed`, or access denied on `C:\Codex\Wiki Files` or `C:\Codex\Wiki Files\.git`, verify repo ownership and ACLs. The intended Windows profile that runs Codex must own or have full control of the repo folder and `.git`.
10. With Wes's approval, repair only the canonical repo ACL/ownership for the intended Windows profile, then quit and reopen Codex and retry verification in a brand-new `Wiki Files` task.
11. If the failure remains after cache rebuild and ACL repair, report it as a Codex managed-sandbox/setup-refresh blocker. Include the exact error and state whether the failure follows the existing task or also occurs in a brand-new task.

### Completion Requirements

At completion, report one of:

- `verified`;
- `blocked`;
- `needs Wes`.

The completion report must include:

- computer name;
- Windows profile;
- assigned human user;
- intended business Microsoft 365 identity;
- designated GitHub identity and `BuyYourHome/Admin-Wiki` access result;
- canonical repo path;
- branch;
- Git state and local-versus-`origin/main` comparison;
- latest commit;
- saved Codex project path;
- installed-skill verification;
- managed-command result;
- remaining blockers.

Record the setup and verification result in the Codex Environment Project Room. Hand off authoritative computer inventory or readiness changes to the Computers Project Room. Leave unrelated dirty work untouched, commit only scoped files, and do not push unless Wes explicitly authorizes it or declares the setup finished and ready to publish.

### Update Existing Machine

Use this mode when Wes asks to keep an already prepared target computer current with changes made on WesStudio or another authorized Admin wiki machine.

Follow `outputs\Update Codex Environment Mode.md`.

This mode is limited to:

- verifying the authorized target computer and canonical repo path;
- pulling `BuyYourHome/Admin-Wiki` at `C:\Codex\Wiki Files` with `git pull --ff-only`;
- syncing wiki-managed skills with `C:\Codex\Wiki Files\tools\sync-codex-skills.ps1`;
- restarting or refreshing Codex so updated skills and rules load;
- verifying repo status, latest commit, skill counts, and free space.

This mode does not authorize app installs, paid software, account sign-ins, connector approvals, security-setting changes, deleting files, force-pulls, pushes to GitHub, or use of a Teams-synced wiki folder as the working repo.

### Role Assignment

Use this mode when a target computer is technically ready but needs task-specific Project Room chat assignments.

Codex Environment owns the machine-readiness handoff. Create PR owns the actual `Min PR Set` mode for creating or recording standard PR/chat combinations.

Workflow:

1. Confirm the target computer has passed Baseline Machine Setup or Update Existing Machine verification.
2. Identify the intended role for the machine, such as Wes primary development, Wes secondary/video, Josh admin support, or backup.
3. Recommend the minimum Project Room chat set for that role.
4. Hand off to Create PR `Min PR Set` for chat creation, startup prompts, and thread-id metadata.
5. Record the setup-run handoff result in `working\target-computer-register.md`.
6. Ensure Computers receives or already has the authoritative machine-list update in `Project Rooms\Computers\working\computer-register.md`.

### Replacement Machine

Use this mode when a new or repaired computer will replace another computer for Codex/Admin wiki work.

Workflow:

1. Identify the old computer, new computer, owner/user, and intended replacement date.
2. Confirm whether the old computer remains active, becomes backup, or should be retired.
3. Run Baseline Machine Setup on the replacement computer.
4. Compare assigned roles, Project Room chats, connector needs, OneDrive/data placement, plugin/cache needs, and local-only files from the old computer.
5. Confirm no unpushed commits or unique required local files remain on the old computer before declaring replacement complete.
6. Use Role Assignment and Create PR `Min PR Set` to recreate or record the needed PR/chat surface.
7. Update `working\target-computer-register.md` with setup-run replacement status, blockers, and any remaining old-machine action.
8. Ensure Computers owns the authoritative replacement/lifecycle status in `Project Rooms\Computers\working\computer-register.md`.

This mode does not authorize deleting files, unlinking accounts, removing software, or changing routing away from the old computer until Wes approves the exact action.

### Decommission Machine

Use this mode when a computer should no longer receive Codex/Admin wiki work.

Workflow:

1. Confirm Wes explicitly authorized decommissioning the named computer.
2. Verify no pending PR work, unpushed Git commits, unique local files, or needed local-only notes remain.
3. Record Codex Environment setup/run implications in `working\target-computer-register.md`.
4. Ensure Computers records the authoritative retired, backup-only, or unavailable machine status in `Project Rooms\Computers\working\computer-register.md`.
5. Identify any registered Project Room chats, task/thread ids, automations, or routing references that still point to the machine.
6. Do not remove accounts, delete files, uninstall software, archive chats, or change routing metadata unless Wes explicitly approves the exact change.

### Machine Health Check

Use this mode before assigning new work to a machine or when Wes asks whether a machine is still ready.

Check:

- computer name, user, Windows edition, admin status, RAM, disk health/free space, and major storage caveats;
- `C:\Codex\Wiki Files` exists and is the Admin wiki repo;
- Git branch/status and whether local `main` is behind `origin/main`;
- latest commit;
- installed skill count and required project skill availability;
- Codex Desktop installation and project connection;
- key connector/plugin availability when needed for the assigned role;
- known blockers, unrelated dirty work, and whether the machine can safely receive PR work.

Record material Codex Environment setup/readiness results in `working\target-computer-register.md` or a target-specific output report when the check changes machine readiness. Ensure Computers receives the authoritative machine inventory/readiness update.

## Current Status

Status: `Wes-VideoEditor` core Admin wiki environment and Codex Desktop project connection installed and verified on 2026-07-22; connector sign-ins, plugin cache, and live workflow execution remain unverified.

WesStudio's non-secret hardware, Windows, Codex, repo, runtime, application, skill, plugin, and remote-access baseline was inventoried on 2026-07-21. Wes approved the Step 2 Core, Business, Optional, and Safety Groups on 2026-07-21. Step 3 created the setup/verification package, and Step 4 authorized the exact `Wes-VideoEditor` scope. Step 5 connected over the private LAN, verified the session identity, and completed a read-only inventory in `outputs\Wes-VideoEditor Initial Inventory.md`. Storage initially blocked installation because `C:` had 4.8 GB free. After cleanup, Git, the canonical Admin wiki repo, LibreOffice, Obsidian, wiki-managed skills, and Codex Desktop were installed and verified. The `Wiki Files` Codex project was created against `C:\Codex\Wiki Files` and passed a read-only repo check. Final core verification is recorded in `outputs\Wes-VideoEditor Core Environment Verification.md`. Durable migration lessons are recorded in `working\migration-lessons-learned.md`.

## Remote Access And Install Safety

- Remote into only the specific computer Wes authorizes for that setup run.
- Confirm the remote-control tool and session identity before making changes.
- Confirm the target login/profile and business identity before installing or configuring profile-specific components such as Codex Desktop, Git global identity, `%USERPROFILE%\.codex\skills`, OneDrive, Outlook, Teams, browser sessions, and connectors.
- Do not assume Wes's personal Microsoft account, including `WesBrowning1@Outlook.com`, is the correct implementation login for a target machine.
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

- Skill source: `C:\Codex\Wiki Files\skills\codex-environment\SKILL.md`

## Dedicated Chat

- Chat name: `Codex Environment`
- Thread id: `019f84d0-78d4-7013-8c07-42c01f961be1`

## Start PR

Before durable work, follow Start PR in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.

## Ownership And Git

- Working branch: `main`.
- Before durable file work, confirm the repo is `C:\Codex\Wiki Files` and the current branch is `main`.
- Follow `Project Room File Ownership And Git Coordination Rule.md` for Project Room ownership, shared Admin files, cross-PR edits, fetch/pull safety, commit scope, and push safety.
- Commit only scoped Codex Environment room, matching skill, and directly related registry/index changes.
- Push only when Wes explicitly asks, says the work is finished, or the applicable Admin wiki rules define the deliverable as final and ready to publish.

## Next Actions

1. Verify Codex/GitHub authorization when a private fetch, push, or PR operation is needed.
2. Verify needed Outlook, Teams, SharePoint, Chrome/browser, and GitHub connector/plugin sign-ins.
3. Confirm plugin cache after connector/plugin setup.
4. Run one low-risk Admin wiki workflow from `Wes-VideoEditor` to confirm end-to-end operation.
5. Free more `C:` drive space if practical; 20 GB or more is preferred for stable ongoing use.
## Delegation Contract

Delegation Contract: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Jean may delegate this PR's work only to its registered task in `Project Rooms\Jean Wright\working\dispatcher-routing-map.md`; the PR must accept and return the same `dispatch_id` under the central contract.

## Action Ownership

Action Ownership: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return `accepted`, `done`, `blocked`, `needs Wes`, or `rejected as wrong room`.
