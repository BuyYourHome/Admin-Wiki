# Remote Codex Environment Setup Steps

Generated: 2026-07-21

Status: superseded by `Target Computer Setup Checklist.md` and `Target Computer Verification Report Template.md` after Wes approved the Step 2 classification. Preserve this file as the initial planning draft.

## Purpose

Use this checklist when Wes authorizes Codex to remote into another Windows computer and install the apps, repo, skills, and account prerequisites needed to replicate the WesStudio Codex/Admin wiki environment.

## Required Authorization

Before connecting to a target computer, confirm:

- Target computer name or other specific identifier.
- Authorized user for the remote session.
- Remote access method approved for this setup run.
- Wes or the authorized user is available to enter passwords, MFA codes, license keys, tokens, and other secrets directly.
- The approved install list is known.
- Any paid software, trials, browser extensions, VPNs, credential managers, remote-control tools, or system-level agents are explicitly approved before installation.

Do not store passwords, tokens, recovery codes, payment details, license keys, or other live secrets in the wiki, Project Room, git history, scripts, or chat notes.

## Remote Access Options

Preferred access methods:

- Windows Remote Desktop when the target is on the same LAN, VPN, or another private network path.
- Windows Quick Assist when Wes or the authorized user can start and supervise the session.
- Another approved remote-support tool only after Wes explicitly approves that tool for the target setup.

Do not expose Windows Remote Desktop directly to the public internet. If Remote Desktop is used, confirm the target has Windows Pro or another edition that supports hosting Remote Desktop, Remote Desktop is enabled, the firewall rule is active, and the connecting user has permission to sign in.

## WesStudio Baseline Inventory

Before declaring another computer ready, inventory WesStudio and record:

- Windows version and architecture.
- Codex Desktop installation and sign-in prerequisites.
- OpenAI/Codex account expectations.
- Canonical Admin wiki repo location: `C:\Codex\Wiki Files`.
- Git installation, GitHub authentication method, and repository access.
- Chrome installation and required signed-in browser state.
- Office, Outlook, Teams, SharePoint, and connector prerequisites.
- LibreOffice installation path: `C:\Program Files\LibreOffice\program\soffice.exe`.
- Codex workspace Python/runtime expectations.
- Required installed Codex skills and the sync process from `C:\Codex\Wiki Files\skills`.
- PDF, Word, spreadsheet, browser-control, email, Teams, SharePoint, image, website, and other support tools needed by active Admin wiki workflows.

## Target Computer Setup

On the authorized target computer:

1. Confirm the remote session is connected to the correct computer and user.
2. Confirm local administrator rights or identify the missing-admin blocker.
3. Create or confirm the canonical Admin wiki folder:

   ```text
   C:\Codex\Wiki Files
   ```

4. Install approved prerequisite apps from the baseline inventory.
5. Install and sign into Codex Desktop.
6. Install Git and configure GitHub access as approved.
7. Clone or pull the Admin wiki repository into `C:\Codex\Wiki Files`.
8. Confirm the repo is on `main`.
9. Confirm the Teams-synced wiki folder is not being used as the working Git repository.
10. Install or verify Chrome, Office, Outlook, Teams, SharePoint access, LibreOffice, and other approved support apps.
11. Configure Codex, browser, Office, GitHub, and connector logins with Wes or the authorized user entering credentials directly.
12. Sync wiki-managed Codex skills only after the target Admin wiki repo is current and the skills are ready to install:

   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Codex\Wiki Files\tools\sync-codex-skills.ps1"
   ```

13. Start a fresh Codex session after skill sync so updated skills are loaded.

## Verification Checklist

Before marking the target ready, verify:

- `Get-Location` and all file work use `C:\Codex\Wiki Files`.
- `git status --short --branch` shows the expected branch and no unexpected tracked changes.
- Admin wiki remote is `BuyYourHome/Admin-Wiki`.
- Codex can access the project room and skill instructions.
- The installed local skills match the wiki-managed source after sync.
- Chrome opens and has the required signed-in state for browser-dependent workflows.
- Outlook, Teams, SharePoint, and related connectors are available where required.
- LibreOffice is available at the documented path.
- Routine document, PDF, spreadsheet, browser, email, Teams, SharePoint, image, and website workflows have their required apps or documented blockers.
- No secrets were saved in files, scripts, git history, or chat notes.

## Documentation During Each Run

Record the setup run in:

```text
C:\Codex\Wiki Files\Project Rooms\Codex Environment\working\target-computer-register.md
```

Include:

- Target computer name.
- Authorized user.
- Remote access method.
- Date and time of setup.
- Apps installed.
- Configuration changes made.
- Credentials or MFA handled by user only.
- Verification results.
- Blockers and follow-up decisions.

## What Wes Must Provide

Before Codex can begin a remote setup run, Wes must provide:

- Target computer identifier.
- Confirmation that this specific remote setup session is authorized.
- Remote access method or instructions.
- Confirmation whether the computer is reachable by LAN, VPN, Quick Assist, or another approved path.
- Local administrator access availability.
- Any paid app, trial, VPN, browser extension, credential manager, remote-control tool, or security-setting approval needed for that specific run.

## Safety Stop Conditions

Stop and ask Wes before:

- Installing paid apps or starting trials with billing risk.
- Installing remote-control tools, VPNs, browser extensions, credential managers, or system-level agents.
- Disabling antivirus, firewall, BitLocker, endpoint protection, or other Windows security features.
- Making legal, financial, mailbox, account-ownership, or security-policy changes.
- Using any folder other than `C:\Codex\Wiki Files` as the Admin wiki Git repo.
- Proceeding when the target identity, authorization, or remote session is unclear.
