# Target Computer Verification Report

Copy this template for each authorized target-computer setup run. Use `Pass`, `Fail`, `Blocked`, or `N/A` for each result. A target is `Ready` only when every required check passes.

## Run Summary

| Field | Value |
| --- | --- |
| Target computer | |
| Authorized user | |
| Signed-in Windows user | |
| Windows profile path | |
| Assigned human user | |
| Intended business Microsoft 365 identity | |
| Setup date/time | |
| Operator | |
| Remote-access method | |
| Session authorization | |
| Windows edition/version/build | |
| Final status | Ready / Ready with documented optional limitations / Not Ready |
| Recheck required | yes / no |

## Approval And Security

| ID | Check | Result | Non-secret evidence or notes |
| --- | --- | --- | --- |
| SEC-01 | Target computer, user, and session match the authorization. | | |
| SEC-01A | Intended Windows sign-in account, Windows profile, assigned human user, and business Microsoft 365 identity were confirmed before profile-specific setup. | | |
| SEC-01B | `WesBrowning1@Outlook.com` was not used as the implementation login unless Wes explicitly designated it for this machine. | | |
| SEC-02 | Remote-access method and any remote-host/firewall changes were specifically approved. | | |
| SEC-03 | No Remote Desktop service is exposed directly to the public internet. | | |
| SEC-04 | No unapproved remote tool, VPN, extension, credential manager, or system agent was installed. | | |
| SEC-05 | Antivirus, firewall, BitLocker, endpoint protection, and Windows security were preserved unless an exact approved change is documented. | | |
| SEC-06 | All passwords, MFA codes, license keys, tokens, and recovery codes were entered by the authorized user and were not stored. | | |

## Windows And Required Applications

| ID | Check | Result | Version, path, or notes |
| --- | --- | --- | --- |
| APP-01 | Supported 64-bit Windows 11 is installed. | | |
| APP-02 | Codex Desktop opens and the authorized user can sign in. | | |
| APP-03 | Git for Windows and Git Credential Manager are available. | | |
| APP-04 | Obsidian opens the canonical Admin wiki vault. | | |
| APP-05 | LibreOffice exists at `C:\Program Files\LibreOffice\program\soffice.exe`. | | |
| APP-06 | Google Chrome opens successfully. | | |
| APP-07 | Authorized Microsoft 365 Apps for business are installed. | | |
| APP-08 | Word, Excel, PowerPoint, and classic Outlook open successfully. | | |
| APP-09 | Microsoft Teams opens and the authorized user can access the required account. | | |
| APP-10 | Microsoft OneDrive is configured only for approved synced deliverable folders. | | |
| APP-11 | No unnecessary global Python, Node.js, or npm installation was added for routine Codex work. | | |

## Repository And Skills

| ID | Check | Result | Command summary or notes |
| --- | --- | --- | --- |
| REP-01 | Canonical repo path is exactly `C:\Codex\Wiki Files`. | | |
| REP-02 | Remote is `https://github.com/BuyYourHome/Admin-Wiki.git` without embedded credentials. | | |
| REP-03 | Active branch is `main`. | | |
| REP-04 | Local `main` is current with GitHub or any difference is understood and approved. | | |
| REP-05 | `git status --short --branch` has no unexpected tracked changes. | | |
| REP-06 | Teams-/OneDrive-synced wiki folders are not used as the working repo. | | |
| REP-07 | Remote was fetched and any update used fast-forward-only behavior; no merge, rebase, reset, discard, or push occurred without exact authorization. | | |
| REP-08 | Active repository path, branch, Git status, local-versus-`origin/main` comparison, and latest commit were recorded. | | |
| SKL-01 | Wiki skill source is `C:\Codex\Wiki Files\skills`. | | |
| SKL-02 | Skill sync completed from the current repo without an unresolved error. | | |
| SKL-03 | Installed wiki-managed skills match the canonical source. | | |
| SKL-04 | A fresh Codex session was started after skill sync. | | |
| SKL-05 | Codex can read the Admin Home, current Project Room README, and matching skill. | | |
| SKL-06 | Codex Desktop has a saved local project named `Wiki Files` pointing to `C:\Codex\Wiki Files`. | | |
| SKL-07 | A brand-new Codex task in the saved `Wiki Files` project completed read-only verification through normal managed execution without elevation. | | |

## Codex Runtime And Document Tools

| ID | Check | Result | Evidence or notes |
| --- | --- | --- | --- |
| RUN-01 | Codex workspace dependencies load successfully. | | |
| RUN-02 | Bundled Python is available through the workspace dependency path. | | |
| RUN-03 | Bundled Node.js and supporting runtime are available. | | |
| RUN-04 | LibreOffice can perform a test headless DOCX-to-PDF conversion. | | |
| RUN-05 | A PDF can be rendered or inspected with the Codex PDF workflow. | | |
| RUN-06 | A basic Word document workflow completes. | | |
| RUN-07 | A basic spreadsheet workflow completes without requiring global Python. | | |
| RUN-08 | If managed execution failed before launch, runtime recovery was handled by the documented cache-backup procedure or reported as a blocker. | | |

## Plugins, Connectors, And Workflow Checks

Do not record message bodies, account tokens, or other confidential content merely to prove access. Use the least-sensitive functional check available.

| ID | Check | Result | Non-secret evidence or notes |
| --- | --- | --- | --- |
| CON-01 | GitHub capability can access the authorized Admin Wiki repository. | | |
| CON-02 | Chrome/browser-control capability connects to the approved browser session. | | |
| CON-03 | Outlook Email capability can access the authorized mailbox scope. | | |
| CON-04 | Outlook Calendar capability can access the authorized calendar scope. | | |
| CON-05 | SharePoint capability can access an authorized test site/library. | | |
| CON-06 | Teams capability can access an authorized test chat or channel. | | |
| CON-07 | Document, spreadsheet, presentation, and PDF capabilities are available. | | |
| CON-08 | Sites and image/visual workflows are available when required for this target role. | | |

## Optional Components

| Component | Installed? | Approval or reason | Verification result |
| --- | --- | --- | --- |
| GitHub Desktop | | | |
| GitHub CLI | | | |
| Outlook for Windows | | | |
| Git LFS | | | |
| Visual Studio Code | | | |
| Other approved item | | | |

## Changes Made

| Application or configuration | Before | Change made | After/result |
| --- | --- | --- | --- |
| | | | |

## Failures, Blockers, And Follow-Up

| Check ID | Failure or blocker | Required decision/action | Owner | Due/recheck date |
| --- | --- | --- | --- | --- |
| | | | | |

## Final Determination

- Required checks passed:
- Required checks failed:
- Required checks blocked:
- Optional limitations:
- Security or authorization issues:
- Saved Codex project path:
- Installed-skill verification:
- Managed-command result:
- Local-versus-`origin/main` comparison:
- Latest commit:
- Final status: Ready / Ready with documented optional limitations / Not Ready
- Target register updated: yes / no
- Computers Project Room handoff needed/completed:
- Report completed by:
- Completion date/time:

Do not mark the computer `Ready` when a required check is failed or blocked, when target/session authorization is unclear, or when a security or secret-handling issue remains unresolved.
