# WesStudio Baseline Inventory

Inventory date: 2026-07-21

## Purpose

This report records the non-secret WesStudio baseline used to decide what another authorized Windows computer needs before it can run the same Codex and Admin wiki workflows.

Presence on WesStudio does not automatically authorize installation on another computer. Step 2 must classify each item as required, optional, already supplied by Codex, or separately approval-gated.

Recorded version numbers describe the inspected baseline. Target computers should normally receive current supported releases rather than being downgraded to these exact versions, unless a tested workflow requires a specific version.

## Computer And Windows

| Item | WesStudio baseline |
| --- | --- |
| Computer | `WESSTUDIO` |
| Model | Microsoft Surface Laptop Studio |
| Processor | 11th Gen Intel Core i7-11370H |
| Memory | 15.8 GB |
| Windows | Windows 11 Home, 64-bit |
| OS version/build | 10.0.26200 / 26200 |
| Windows PowerShell | 5.1.26100.8894 |

Windows 11 Home can run the Remote Desktop client but cannot host an inbound Windows Remote Desktop session. Microsoft states that the remote PC must run Windows Pro, while the client may run Home or Pro: [How to use Remote Desktop](https://support.microsoft.com/en-us/windows/experience/connectivity-networking/how-to-use-remote-desktop). Quick Assist is installed and may be used only when Wes authorizes it for the specific target session.

## Codex And Admin Wiki

| Item | WesStudio baseline |
| --- | --- |
| Codex Desktop | `OpenAI.Codex` 26.715.4045.0 |
| Canonical Admin wiki | `C:\Codex\Wiki Files` |
| GitHub repository | `https://github.com/BuyYourHome/Admin-Wiki.git` |
| Default branch | `main` |
| Canonical skill source | `C:\Codex\Wiki Files\skills` |
| Installed skill location | `C:\Users\wesbr\.codex\skills` |
| Skill sync script | `C:\Codex\Wiki Files\tools\sync-codex-skills.ps1` |

Codex configuration contains both the canonical Admin wiki project and a historical Teams-synced wiki project entry. Do not reproduce or use the Teams-synced entry as the working repository on a target computer.

Account authentication, tokens, connector credentials, and sign-in state were not inspected or recorded. Wes or the authorized user must enter credentials and MFA directly on each target computer.

## Git And Repository Access

| Item | WesStudio baseline |
| --- | --- |
| System Git | 2.54.0.windows.1 |
| Git LFS | 3.7.1 |
| Credential helper | Git Credential Manager from the system Git configuration |
| GitHub Desktop | 3.5.10 |
| GitHub CLI (`gh`) | Not installed |
| OpenSSH client | OpenSSH 9.5p2 for Windows |

GitHub Desktop is present, but the Admin wiki workflow uses Git and Git Credential Manager. Step 2 must decide whether GitHub Desktop is required or optional on targets.

## Codex Bundled Runtime

Bundle version: `26.715.12143`.

| Runtime | WesStudio baseline |
| --- | --- |
| Bundled Python | 3.12.13 at `C:\Users\wesbr\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe` |
| Bundled Node.js | 24.14.0 at `C:\Users\wesbr\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe` |
| Bundled Git | 2.53.0.windows.3 |

System `python`, `node`, and `npm` commands are not required for routine Admin wiki work. Use the Codex bundled workspace runtime and do not ask Wes to install Python or Node globally merely to support Codex workflows.

## Desktop Applications

| Application | WesStudio version or status | Initial deployment classification |
| --- | --- | --- |
| Google Chrome | 150.0.7871.129 | Review as required for Chrome/browser workflows |
| Microsoft Edge | 150.0.4078.83 | Included with Windows; browser fallback |
| Microsoft 365 Apps for business | 16.0.20131.20152 | Review as required for Word, Excel, PowerPoint, and classic Outlook workflows |
| Microsoft Word | 16.0.20131.20152 | Installed with Microsoft 365 |
| Microsoft Excel | 16.0.20131.20152 | Installed with Microsoft 365 |
| Microsoft PowerPoint | 16.0.20131.20152 | Installed with Microsoft 365 |
| Microsoft Outlook, classic | 16.0.20131.20152 | Installed with Microsoft 365 |
| Outlook for Windows | 1.2026.407.100 | Present; connector and mailbox access still require sign-in verification |
| Microsoft Teams | 26163.405.4842.717 | Present; workflow access must be verified |
| Microsoft OneDrive | 26.119.0622.0003 | Present; not the Admin wiki working repo |
| LibreOffice | 26.2.3.2 at `C:\Program Files\LibreOffice\program\soffice.exe` | Required document-rendering fallback under current wiki rules |
| Obsidian | 1.12.7 | Review as the preferred Admin wiki reading/editing interface |
| Quick Assist | 2.0.47.0 | Approval-gated remote-session option |
| Remote Desktop client | Present | Approval-gated remote-session option |
| Visual Studio Code | Not installed | Not part of the current baseline |

## Wiki-Managed Skills

- Canonical skill folders: 29.
- Installed workflow skill folders: 29, plus Codex's `.system` skills.
- Canonical files compared: 65.
- Installed files compared: 65.
- Hash differences: 0.

The installed wiki-managed skills match the canonical Admin wiki source as of this inventory.

Installed workflow skills:

`admin-request-wrapup`, `aios`, `amortization`, `brynda-suit`, `cma-report`, `codex-environment-deployment`, `confidential`, `contract-for-deed`, `create-pr`, `credit-worthiness-evaluator`, `doc-scan`, `email-delivery`, `email-monitor`, `entity-relationship`, `gracious-millionaire`, `investigate-computer`, `invoice-entry`, `jean-wright`, `jennys-drawings`, `ld-evans`, `lowes-order`, `manager`, `new-project`, `operating-agreement`, `property-trade-evaluation`, `rei-blackbook`, `sops`, `template-to-project`, and `wes-voice`.

## Enabled Codex Plugins

The local Codex configuration explicitly enables:

- Browser Use, Chrome, and Computer Use.
- Documents, spreadsheets, presentations, PDF, and template creation.
- GitHub.
- Outlook Email and Outlook Calendar.
- SharePoint.
- Sites and Visualize.

The Teams plugin package is cached and Teams capabilities are available in the current Codex environment, but Teams is not listed among the explicitly enabled plugin sections in the local configuration. Treat Teams setup as requiring a functional verification on each target.

Plugin installation or presence does not prove that an account is signed in or that delegated mailbox, SharePoint, Teams, GitHub, or browser access works. Those checks belong in target verification and require the authorized user's account access.

## Remote Access Baseline

- Quick Assist is installed.
- The Windows Remote Desktop client is installed.
- OpenSSH client is installed.
- No remote-control tool, VPN, browser extension, system-level agent, or security-setting change is authorized merely because it exists on WesStudio.
- Confirm the target computer, remote-access method, session identity, and authorization before connecting.

## Step 1 Conclusions

1. The core WesStudio Codex/Admin wiki baseline is now documented.
2. The canonical repo and all wiki-managed installed skill files are aligned.
3. Codex supplies Python, Node.js, Git, and document-support runtimes; global Python or Node installation is not part of the baseline.
4. Step 2 must classify desktop applications and remote-access components before any target installation.
5. Authentication and connector functionality remain per-target verification items; no secrets were inspected or stored.
