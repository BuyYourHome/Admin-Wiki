# Target Computer Setup Checklist

Approved baseline date: 2026-07-21

Use this checklist only after Wes authorizes the specific target computer and setup session. Record results in a copy of `Target Computer Verification Report Template.md` and update `working\target-computer-register.md`.

## Run Identification

- Target computer:
- Authorized user:
- Signed-in Windows user:
- Windows profile path:
- Assigned human user:
- Intended business Microsoft 365 identity:
- Designated GitHub identity for this computer:
- GitHub access to `BuyYourHome/Admin-Wiki` confirmed by:
- Setup date and time:
- Remote-access method:
- Remote session authorized by:
- Operator:
- Local administrator available: yes / no / unknown
- Existing Microsoft 365 license confirmed: yes / no / not applicable
- Approved optional or approval-gated items for this target:

Do not put passwords, MFA codes, license keys, tokens, recovery codes, or other live secrets in this checklist or any project-room record.

## 1. Authorization Gate

- [ ] The exact target computer and authorized user are identified.
- [ ] The intended Windows sign-in account, Windows profile, assigned human user, and business Microsoft 365 identity are confirmed before profile-specific setup.
- [ ] `WesBrowning1@Outlook.com` is not assumed as the implementation login unless Wes explicitly designates it for this machine.
- [ ] The target computer has its own designated GitHub identity with access to `BuyYourHome/Admin-Wiki`.
- [ ] Wes's personal GitHub identity, another user's GitHub identity, and another machine's GitHub credentials are not reused unless Wes explicitly approves that exact exception for this machine.
- [ ] Wes authorized this specific setup session.
- [ ] The remote-access method is approved for this target and session.
- [ ] Wes or the authorized user is available to enter credentials, MFA, and license information directly.
- [ ] Existing licenses and any paid-app installation authority are confirmed.
- [ ] Every optional or approval-gated item requested for this target is listed above.
- [ ] No unapproved VPN, remote-control tool, browser extension, credential manager, system-level agent, or security change is planned.

Stop before connecting if any required authorization is missing or ambiguous.

Stop before profile-specific setup if the signed-in Windows profile or GitHub identity does not match the implementation plan. Profile-specific setup includes Codex Desktop, Git global identity, `%USERPROFILE%\.codex\skills`, OneDrive, Outlook, Teams, browser sessions, GitHub authentication, and connectors.

## 2. Remote Session Safety

- [ ] Confirm the remote session shows the expected computer name and user.
- [ ] If using Quick Assist, the authorized user initiated or is supervising the session.
- [ ] If using Remote Desktop, the connection uses a LAN, VPN, or another approved private path.
- [ ] Remote Desktop is not exposed directly to the public internet.
- [ ] Any Remote Desktop hosting or firewall change has exact target-specific approval.
- [ ] Record any unexpected security prompt or session-identity mismatch and stop until resolved.

## 3. Initial Target Inventory

Record the existing state before installing or changing anything:

- [ ] Windows edition, version, build, and 64-bit architecture.
- [ ] Computer manufacturer/model and available disk space.
- [ ] Current user and local administrator availability.
- [ ] Existing Codex Desktop version and sign-in state.
- [ ] Existing Git, Obsidian, LibreOffice, Chrome, Microsoft 365, Teams, OneDrive, and Outlook installations.
- [ ] Existing `C:\Codex\Wiki Files` folder and Git repository state, if present.
- [ ] Existing Codex skills, plugins, connectors, and known account-access blockers.
- [ ] Antivirus, firewall, BitLocker, endpoint protection, and Windows security state without changing them.

If an existing `C:\Codex\Wiki Files` repo contains uncommitted work, is on an unexpected branch, or is behind/ahead in an unclear way, stop and report it. Do not reset, stash, overwrite, delete, or pull over dirty work without explicit recovery approval.

## 4. Approved Core Installation

- [ ] Confirm supported 64-bit Windows 11.
- [ ] Install or update Codex Desktop to the current supported release.
- [ ] Have the authorized user complete Codex sign-in and MFA directly.
- [ ] Install Git for Windows with Git Credential Manager.
- [ ] Install Obsidian.
- [ ] Install LibreOffice and confirm `C:\Program Files\LibreOffice\program\soffice.exe` exists.
- [ ] Do not install global Python, Node.js, or npm merely for routine Codex work; use the Codex bundled runtime.

## 5. Approved Business Applications

- [ ] Install or update Google Chrome.
- [ ] Install or verify an authorized Microsoft 365 Apps for business license.
- [ ] Confirm Word, Excel, PowerPoint, and classic Outlook are available.
- [ ] Install or update Microsoft Teams.
- [ ] Install or update Microsoft OneDrive.
- [ ] Configure OneDrive only for approved Teams/SharePoint-synced deliverable folders.
- [ ] Do not use a OneDrive- or Teams-synced wiki folder as the working Admin wiki repository.
- [ ] Treat Outlook for Windows as optional when classic Outlook and the Outlook connectors work.

## 6. Canonical Admin Wiki Repository

- [ ] Create or confirm `C:\Codex\Wiki Files`.
- [ ] Clone `https://github.com/BuyYourHome/Admin-Wiki.git` into that exact folder, or safely update an existing clean repo.
- [ ] Confirm the remote is `BuyYourHome/Admin-Wiki` and contains no embedded credentials.
- [ ] Confirm the designated GitHub identity can access `BuyYourHome/Admin-Wiki` before private fetch, clone, or connector verification.
- [ ] Confirm the active branch is `main`.
- [ ] Fetch GitHub and update only with fast-forward-only behavior.
- [ ] Do not merge, rebase, reset, discard local work, or push during setup unless Wes explicitly authorizes that exact action.
- [ ] Confirm local `main` is not unexpectedly behind, ahead, or diverged from `origin/main`.
- [ ] Run `git status --short --branch` and document any unexpected tracked or untracked work.
- [ ] Record the active repository path, current branch, Git status, local-versus-`origin/main` comparison, and latest commit.
- [ ] Confirm `C:\Codex\Wiki Files` and `C:\Codex\Wiki Files\.git` are owned by, or grant full control to, the intended Windows profile that will run Codex.
- [ ] If the repo was cloned, copied, repaired, or previously used under another Windows profile, verify the active profile can change ACLs on both `C:\Codex\Wiki Files` and `.git` before Codex managed-runner verification.
- [ ] Confirm Codex and Obsidian both use `C:\Codex\Wiki Files` as the Admin wiki workspace/vault.
- [ ] Confirm the Teams-synced wiki folder is not configured as the working repository.

## 7. Skills And Codex Configuration

- [ ] Confirm the target repo is current before syncing skills.
- [ ] Run:

  ```powershell
  powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Codex\Wiki Files\tools\sync-codex-skills.ps1"
  ```

- [ ] Confirm the wiki-managed skill source is `C:\Codex\Wiki Files\skills`.
- [ ] Confirm the installed runtime copies are under the authorized user's `.codex\skills` folder.
- [ ] Confirm the installed Sync Github skill is `C:\Users\<Windows-user>\.codex\skills\sync-github\SKILL.md` and matches the canonical repo source; do not leave only the old `sync-gethub` skill installed.
- [ ] Start a fresh Codex session after skill sync.
- [ ] Confirm Codex can open the Admin wiki and read the current project-room and matching skill instructions.
- [ ] In Codex Desktop, add or open `C:\Codex\Wiki Files` as a saved local project named `Wiki Files`.
- [ ] Verify the saved Codex project points to `C:\Codex\Wiki Files`, not a Teams- or OneDrive-synced location.
- [ ] Open a new Codex task in the saved `Wiki Files` project and run normal read-only verification: report working folder, run `git status --short --branch`, compare local `main` with `origin/main`, and read one applicable installed skill.
- [ ] Confirm commands run through Codex's normal managed execution path without elevation.
- [ ] For enrolled Sync Github targets, verify the `sync-gethub-daily` heartbeat can perform one safe live `git fetch origin`. If the managed runner is permission-denied on `.git\FETCH_HEAD`, verify the Wes-approved unsandboxed/local fetch path or keep unattended daily sync marked pending.
- [ ] Enable and verify the approved Codex capabilities for GitHub, Chrome/browser control, Outlook Email, Outlook Calendar, SharePoint, Teams, documents, spreadsheets, presentations, and PDF work.
- [ ] Have the authorized user complete connector sign-in or consent directly.
- [ ] Verify the GitHub capability is using the designated target-computer GitHub identity or a Wes-approved exception.

Plugin presence alone is not a passing result. Each required workflow must complete a functional check in the verification report.

## 8. Optional And Approval-Gated Items

Install only when listed in the Run Identification section with the required approval:

- GitHub Desktop.
- GitHub CLI.
- Outlook for Windows.
- Git LFS when an approved repository requirement exists.
- Visual Studio Code when separately requested.
- Quick Assist or another approved remote-support tool.
- VPNs, browser extensions, credential managers, or system-level agents.

Do not disable, weaken, or reconfigure antivirus, firewall, BitLocker, endpoint protection, or Windows security without exact approval for the target and change.

## 9. Verification And Handoff

- [ ] Create a target-specific copy of `Target Computer Verification Report Template.md`.
- [ ] Complete every required check as Pass, Fail, Blocked, or Not Applicable.
- [ ] Record versions, paths, command summaries, and non-secret evidence.
- [ ] Record failed checks and the precise corrective action or decision needed.
- [ ] Confirm no secrets were stored in files, scripts, Git history, screenshots, or handoff notes.
- [ ] Update `working\target-computer-register.md` with the run result.
- [ ] Hand off any authoritative computer inventory or readiness change to the Computers Project Room.
- [ ] Final report states `verified`, `blocked`, or `needs Wes`.
- [ ] Final report includes computer name, Windows profile, assigned human user, intended business Microsoft 365 identity, designated GitHub identity and repo-access result, canonical repo path, branch, Git state, local-versus-`origin/main` comparison, latest commit, saved Codex project path, installed-skill verification, managed-command result, and remaining blockers.
- [ ] Mark the target `ready` only when every required check passes and no unresolved security or authorization issue remains.

## 10. Managed Runtime Failure Recovery

If a normal Codex command fails before launch with:

```text
Failed to create unified exec process: helper_unknown_error: setup refresh had errors
```

then:

- [ ] Confirm commands and the repository themselves work through a harmless read-only diagnostic outside the managed sandbox.
- [ ] Do not alter the Admin wiki repository.
- [ ] With Wes's approval, fully quit Codex, including its system-tray process.
- [ ] Rename the affected user's local cache at `C:\Users\<Windows-user>\.cache\codex-runtimes` to a dated backup such as `codex-runtimes.backup-YYYYMMDD`.
- [ ] Reopen Codex and allow it to rebuild the runtime.
- [ ] Open a brand-new task in the saved `Wiki Files` project and repeat the normal managed-command verification.
- [ ] Do not delete the backup until the rebuilt runtime is confirmed healthy.
- [ ] If the failure remains, inspect `C:\Users\<Windows-user>\.codex\.sandbox\setup_error.json` and the current `sandbox*.log`.
- [ ] If the sandbox log reports `SetNamedSecurityInfoW failed: 5`, `write ACE failed`, `deny ACE failed`, or access denied on `C:\Codex\Wiki Files` or `.git`, verify and repair repo ownership/ACLs for the intended Windows profile with Wes's approval.
- [ ] After ACL repair, quit and reopen Codex and repeat the normal managed-command verification in a brand-new `Wiki Files` task.
- [ ] If the failure remains after cache rebuild and ACL repair, report it as a Codex managed-sandbox/setup-refresh blocker with the exact error and whether it follows the existing task or also occurs in a brand-new task.

## Stop Conditions

Stop and report the decision needed before:

- Accessing an unidentified or unauthorized computer or user session.
- Purchasing software, activating an unconfirmed paid license, or starting a paid trial.
- Installing an unapproved remote-control tool, VPN, browser extension, credential manager, or system-level agent.
- Enabling Remote Desktop hosting or changing firewall rules without exact approval.
- Disabling or weakening Windows security protections.
- Overwriting, deleting, resetting, stashing, or pulling over unclear existing work.
- Saving or copying passwords, MFA codes, license keys, tokens, or recovery codes.
- Continuing profile-specific setup when the signed-in Windows profile, assigned human, or business identity is unclear or mismatched.
- Continuing setup when the designated GitHub identity for this computer is unclear, lacks `BuyYourHome/Admin-Wiki` access, or appears to be an unauthorized reused account.
- Using a Teams- or OneDrive-synced Admin wiki folder as the working repository.
