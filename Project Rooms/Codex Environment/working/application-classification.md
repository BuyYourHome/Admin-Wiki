# Application Classification Decisions

Status: Step 2 complete.

## Approval Scope

Wes approved the Core, Business, Optional, and Safety Groups on 2026-07-21 for the standard Codex/Admin wiki target baseline.

This approval classifies the items below as standard requirements. It does not authorize connecting to a target computer, purchasing or activating paid software, starting a paid trial, changing security settings, or installing anything on a specific target. Those actions remain subject to the target-specific authorization and safety rules.

## Approved Core Group

| Component | Classification | Requirement |
| --- | --- | --- |
| Windows | required | Supported 64-bit Windows 11. Windows Pro or another supported host edition is required only when the target must host inbound Windows Remote Desktop. |
| Codex Desktop | required | Install the current supported Codex Desktop release and have Wes or the authorized user complete sign-in and MFA. |
| Git for Windows | required | Install Git for Windows with Git Credential Manager so the authorized user can access `BuyYourHome/Admin-Wiki`. |
| Canonical Admin wiki repo | required configuration | Clone or configure the repo at `C:\Codex\Wiki Files`, use `main`, and do not use a Teams-synced wiki folder as the working repo. |
| Wiki-managed Codex skills | required configuration | After the target repo is current, run `C:\Codex\Wiki Files\tools\sync-codex-skills.ps1`, then start a fresh Codex session. |
| Obsidian | required | Use as the preferred Admin wiki reading and editing interface. |
| LibreOffice | required | Install the current supported release and verify `C:\Program Files\LibreOffice\program\soffice.exe` for document rendering and PDF conversion. |
| Codex bundled runtime | supplied by Codex | Use Codex's bundled Python, Node.js, Git, and document-support dependencies. Do not install global Python or Node merely for routine Admin wiki work. |

## Approved Business Group

| Component | Classification | Requirement |
| --- | --- | --- |
| Google Chrome | required | Install the current supported release for Chrome and browser-control workflows. Browser extensions remain separately approval-gated. |
| Microsoft 365 Apps for business | required, license-gated | Provide Word, Excel, PowerPoint, and classic Outlook. Confirm an existing authorized license or obtain target-specific purchase approval before installation or activation. |
| Microsoft Teams | required | Install the current supported release and verify the authorized user's Teams access and Codex Teams workflow availability. |
| Microsoft OneDrive | required with boundary | Install and configure it for approved Teams/SharePoint-synced deliverable folders. Never use a OneDrive- or Teams-synced wiki folder as the working Admin wiki repository. |
| Outlook Email and Calendar | required Codex configuration | Enable and verify the applicable Codex plugins/connectors. Have the authorized user complete sign-in and consent directly. |
| SharePoint | required Codex configuration | Enable and verify the SharePoint plugin/connector; no separate SharePoint desktop application is required. |
| Teams, GitHub, and Chrome/browser access | required Codex configuration | Enable the applicable Codex capabilities and verify function on the target instead of relying on package presence alone. |
| Outlook for Windows | optional | The newer Outlook app is not required when classic Outlook and the Outlook connectors work correctly. |

## Approved Optional Group

| Component | Classification | Requirement |
| --- | --- | --- |
| GitHub Desktop | optional | Install only when the target user wants a graphical Git interface. Git for Windows remains the required Git installation. |
| GitHub CLI | optional | Install only when an approved workflow specifically needs command-line GitHub operations. It is not part of the inspected WesStudio baseline. |
| Visual Studio Code | do not install by default | It is not part of the inspected WesStudio baseline and is not required for routine Admin wiki work. |
| Git LFS | do not install by default | The Admin Wiki currently has no Git LFS configuration. Add it only if a future approved repository requirement needs it. |
| Outlook for Windows | optional | Retain or install it only when useful; classic Outlook and verified Outlook connectors satisfy the standard requirement. |
| Microsoft Edge | supplied by Windows | No separate installation is required. |
| Global Python, Node.js, and npm | do not install for routine Codex work | Use the Codex bundled workspace runtime unless an approved non-Codex application has a separate requirement. |

## Approved Safety Group

| Component or action | Classification | Requirement |
| --- | --- | --- |
| Quick Assist | target- and session-specific approval required | Use only for a specifically authorized computer and session, with the authorized user initiating or supervising access. |
| Windows Remote Desktop | target- and session-specific approval required | Use only for a specifically authorized computer and session over a LAN, VPN, or another approved private path. Never expose Remote Desktop directly to the public internet. |
| Remote Desktop hosting and firewall changes | exact approval required | Confirm a supported Windows host edition. Obtain target-specific approval before enabling Remote Desktop or changing its firewall rule. |
| Other remote-control tools and VPNs | do not install by default | Install only after Wes approves the exact product, target computer, and setup session. |
| Browser extensions | do not install by default | Install only after Wes approves the exact extension and target computer. |
| Credential managers and system-level agents | do not install by default | Install only after Wes approves the exact item and target computer. |
| Antivirus, firewall, BitLocker, endpoint protection, and Windows security | preserve by default | Do not disable, weaken, or reconfigure these protections without Wes's exact approval for the target and change. |
| Passwords, MFA codes, license keys, tokens, and recovery codes | user-entered secrets | Wes or the authorized user must enter them directly. Do not store them in the wiki, project room, scripts, git history, or handoff notes. |

## Step 2 Completion

The standard application and safety classification is complete. Every target setup still requires confirmation of the specific computer, authorized user, remote-access method, existing licenses, approved installs, and any exact approval-gated items before changes begin.
