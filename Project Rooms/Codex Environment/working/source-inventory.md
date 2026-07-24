# Source Inventory

| Source | Type | Status | Notes |
| --- | --- | --- | --- |
| Wes instruction to create Codex environment deployment PR | User instruction | authoritative | Creates a Project Room whose job is to remote into other authorized computers and install apps needed to replicate the Codex environment from WesStudio. |
| `outputs/WesStudio Baseline Inventory.md` | Local machine inspection | authoritative | Non-secret WesStudio hardware, Windows, Codex, repo, runtime, application, skill, plugin, and remote-access baseline recorded on 2026-07-21. |
| `working/application-classification.md` | Wes approval record | authoritative | Records the Step 2 Core, Business, Optional, and Safety Groups approved on 2026-07-21. |
| `outputs/Target Computer Setup Checklist.md` | Deployment checklist | authoritative | Canonical ordered checklist derived from the approved application and safety classification. |
| `outputs/Target Computer Verification Report Template.md` | Verification template | authoritative | Canonical pass/fail report template for each authorized target-computer setup. |
| `outputs/Update Codex Environment Mode.md` | Update checklist | authoritative | Mode for keeping an already prepared target computer current with GitHub Admin wiki changes and wiki-managed skill sync. |
| `working/wes-videoeditor-authorized-setup-scope.md` | Target-specific authorization record | authoritative | Records the Step 4 target identity, private-LAN Remote Desktop method, administrator and license confirmations, approved required items, exclusions, and stop conditions. |
| `outputs/Wes-VideoEditor Initial Inventory.md` | Target-computer inspection | authoritative | Step 5 read-only inventory of identity, Windows, disk space, required apps, repo/skill state, and observed security state. |
| `outputs/Wes-VideoEditor Core Environment Verification.md` | Target-computer verification | authoritative | Records the Git, Admin wiki, LibreOffice, Obsidian, skill sync, Codex Desktop, and Codex project verification work completed on `WES-VIDEOEDITOR`. |
| `working/configure-wesstudio-winrm-client.ps1` | Local helper script | reference | Helper used to configure/check WesStudio WinRM client TrustedHosts for `Wes-VideoEditor`. This records the attempted client-side setup; it does not prove WinRM connectivity or authorize security-setting changes on other machines. |
| `working/migration-lessons-learned.md` | Deployment lessons | authoritative | Durable lessons from the first target migration, including storage thresholds, OneDrive cleanup, Windows edition verification, remote execution fallback, Codex Desktop naming, and project setup. |
| `outputs/Remote Codex Environment Setup Steps.md` | Initial deployment draft | outdated, preserved | Superseded by the canonical setup checklist and verification template after Step 2 approval. |
| `Project Room Workflow.md` | Wiki rule | authoritative | Defines required Project Room structure and workflow. |
| `Project Room Chat Startup Rule.md` | Wiki rule | authoritative | Defines Start PR and chat startup requirements. |
| `Project Room File Ownership And Git Coordination Rule.md` | Wiki rule | authoritative | Defines file ownership, commit scope, and push safety. |
| `Agent Unit Standard.md` | Wiki rule | authoritative | Defines standard package expectations for Project Room, skill, registry, chat, and automation. |
| `Codex Skill Source Rule.md` | Wiki rule | authoritative | Defines canonical Admin wiki skill source and sync expectations. |
| `Codex Python Runtime Rule.md` | Wiki rule | authoritative | Defines the expected Codex workspace Python runtime for Admin wiki work. |
| `LibreOffice Location Rule.md` | Wiki rule | authoritative | Defines LibreOffice path and fallback rules for document rendering. |
