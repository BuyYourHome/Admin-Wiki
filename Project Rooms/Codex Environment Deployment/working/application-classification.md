# Application Classification Decisions

Status: Step 2 in progress.

## Approval Scope

Wes approved the Core Group on 2026-07-21 for the standard Codex/Admin wiki target baseline.

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

## Pending Groups

- Business workflow applications: Chrome, Microsoft 365 desktop apps, classic Outlook, Outlook for Windows, Teams, and OneDrive.
- Optional tools: GitHub Desktop, GitHub CLI, Visual Studio Code, Git LFS, and other nonessential utilities.
- Approval-gated remote and system items: Quick Assist, Remote Desktop hosting, VPNs, remote-control tools, browser extensions, credential managers, system-level agents, and security-setting changes.

