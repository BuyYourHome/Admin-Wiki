# Target Computer Setup Checklist

Approved baseline date: 2026-07-21

Use this checklist only after Wes authorizes the specific target computer and setup session. Record results in a copy of `Target Computer Verification Report Template.md` and update `working\target-computer-register.md`.

## Run Identification

- Target computer:
- Authorized user:
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
- [ ] Wes authorized this specific setup session.
- [ ] The remote-access method is approved for this target and session.
- [ ] Wes or the authorized user is available to enter credentials, MFA, and license information directly.
- [ ] Existing licenses and any paid-app installation authority are confirmed.
- [ ] Every optional or approval-gated item requested for this target is listed above.
- [ ] No unapproved VPN, remote-control tool, browser extension, credential manager, system-level agent, or security change is planned.

Stop before connecting if any required authorization is missing or ambiguous.

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
- [ ] Confirm the active branch is `main`.
- [ ] Fetch GitHub and confirm local `main` is not unexpectedly behind or diverged.
- [ ] Run `git status --short --branch` and document any unexpected tracked or untracked work.
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
- [ ] Start a fresh Codex session after skill sync.
- [ ] Confirm Codex can open the Admin wiki and read the current project-room and matching skill instructions.
- [ ] Enable and verify the approved Codex capabilities for GitHub, Chrome/browser control, Outlook Email, Outlook Calendar, SharePoint, Teams, documents, spreadsheets, presentations, and PDF work.
- [ ] Have the authorized user complete connector sign-in or consent directly.

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
- [ ] Mark the target `ready` only when every required check passes and no unresolved security or authorization issue remains.

## Stop Conditions

Stop and report the decision needed before:

- Accessing an unidentified or unauthorized computer or user session.
- Purchasing software, activating an unconfirmed paid license, or starting a paid trial.
- Installing an unapproved remote-control tool, VPN, browser extension, credential manager, or system-level agent.
- Enabling Remote Desktop hosting or changing firewall rules without exact approval.
- Disabling or weakening Windows security protections.
- Overwriting, deleting, resetting, stashing, or pulling over unclear existing work.
- Saving or copying passwords, MFA codes, license keys, tokens, or recovery codes.
