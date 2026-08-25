# Source Inventory

| Source | Type | Status | Notes |
| --- | --- | --- | --- |
| `Project Room Workflow.md` | Wiki rule | authoritative | Defines required Project Room structure and workflow. |
| `Project Room Chat Startup Rule.md` | Wiki rule | authoritative | Defines new-chat startup text and handoff requirements. |
| `Project Room File Ownership And Git Coordination Rule.md` | Wiki rule | authoritative | Defines PR file ownership, shared Admin edits, cross-PR edits, fetch/pull safety, and push safety. |
| `Agent Unit Standard.md` | Wiki rule | authoritative | Defines Project Room, skill, registry, chat, and automation package expectations. |
| `Codex Skill Source Rule.md` | Wiki rule | authoritative | Defines canonical skill source and sync expectations. |
| `Git Work Scope Rule.md` | Wiki rule | authoritative | Defines scoped commits and push behavior. |
| `Agents and Automations Registry.md` | Registry | authoritative | Human-readable list of agent-like rooms, skills, chats, and automations. |
| Wes instruction to create new PRs from `main` | User instruction | authoritative | Future Create PR work must use `main` by default and must not create a new branch unless Wes explicitly asks for one. |
| Wes instruction after LD. Evans connector delay | User instruction | authoritative | Future Create PR work must complete and commit local PR setup before trying task creation, try the connector once, then mark thread id pending if the connector does not return promptly. |
| Wes instruction for Diagram mode | User instruction | authoritative | Defines Create PR mode for displaying or refreshing a grouped one-page SVG relationship diagram of Project Rooms, skills, automations, and major handoffs. |
| Wes instruction for mode-documentation standard | User instruction | authoritative | Defines the canonical naming convention for documented Project Room modes: use the invocation name as the heading and keep `Mode` as prose only, while preserving filenames, folder names, automations, task names, historical logs, and external references unless separately authorized. |
| Wes instruction for Durable Outcome Log Pattern | User instruction | authoritative | When creating or updating a Project Room, decide whether repeatable intake/routing/processing/delivery/filing/document/email/spreadsheet/handoff workflows need a durable outcome log under `working\`; commit durable Markdown logs and rules, not scratch artifacts. |
| Wes instruction for Minimum PR Chat Set mode | User instruction | authoritative | Defines a Create PR mode for setting up the minimum matching Codex chat / Project Room combinations on a prepared target computer. |
| Wes instruction to add Sync GetHub to the Minimum PR Chat Set | User instruction | authoritative | Adds the Sync GetHub task to the default set and requires each target computer's daily 5:30 AM automation and first safe run to be verified or recorded as pending. |
| Existing Project Rooms and skills | Examples | background | Used as patterns for README and SKILL structure. |
