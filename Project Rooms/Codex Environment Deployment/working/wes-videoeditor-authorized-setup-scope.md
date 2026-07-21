# Wes-VideoEditor Authorized Setup Scope

Status: Step 4 complete; awaiting Step 5 connection and initial inspection.

Authorization date: 2026-07-21

## Confirmed Target

| Field | Confirmed value |
| --- | --- |
| Exact Windows computer name | `Wes-VideoEditor` |
| Authorized user | `wesbrowning1@outlook.com` |
| Remote-access method | Windows Remote Desktop |
| Network path | Same private local network as WesStudio |
| Local administrator rights | Confirmed for the authorized account |
| Microsoft 365 Apps for business license | Existing authorized license confirmed |
| Credential handling | Wes will enter passwords, MFA, license information, and any sensitive prompts directly |

Wes confirmed the target identity, private-LAN Remote Desktop path, administrator access, Microsoft 365 licensing, and required-item scope during Step 4. No connection or installation occurred during Step 4. `Start Step 5` is the execution trigger for connecting and performing the initial read-only target inspection.

## Authorized Required Items

Wes authorized installing, updating, and configuring these required items on `Wes-VideoEditor`, subject to the setup checklist and the initial inspection of what is already present:

- Codex Desktop.
- Git for Windows with Git Credential Manager.
- Obsidian.
- LibreOffice.
- Google Chrome.
- Microsoft 365 Apps for business, using the confirmed authorized license.
- Microsoft Teams.
- Microsoft OneDrive, limited to approved Teams/SharePoint-synced deliverable folders.
- Canonical Admin Wiki repository at `C:\Codex\Wiki Files` on `main`.
- Wiki-managed Codex skills synchronized from the current canonical Admin Wiki repo.
- Approved Codex plugins and connectors for GitHub, Chrome/browser control, Outlook Email, Outlook Calendar, SharePoint, Teams, documents, spreadsheets, presentations, and PDF work.

Install or update only what the initial inspection shows is missing or outdated. Do not overwrite or reset existing user work or configuration merely to make it match WesStudio.

## Not Authorized By This Scope

- GitHub Desktop, GitHub CLI, Visual Studio Code, Git LFS, or other optional tools unless separately approved.
- Browser extensions.
- VPN installation or changes.
- Other remote-control tools.
- Credential managers or system-level agents.
- Purchases, new paid plans, or paid trials.
- Disabling or weakening antivirus, firewall, BitLocker, endpoint protection, or Windows security.
- Unapproved Remote Desktop hosting or firewall changes.
- Legal, financial, mailbox ownership, account ownership, or security-policy changes.

## Required Stop Conditions

Stop and report the decision needed if:

- The remote session does not show `Wes-VideoEditor` and the authorized user.
- Remote Desktop cannot connect over the private LAN without a new security or firewall change.
- The existing Admin Wiki folder or another relevant repo contains unclear or uncommitted work.
- A required application needs a purchase, new paid plan, or trial rather than the confirmed existing license.
- A required installation would need an item excluded above.
- A credential, MFA code, license key, token, or recovery code would need to be stored or copied into a project record.
