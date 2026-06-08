# AIOS Vault Map

This file is the navigation manual for AI assistants working in the Buy Your Home Admin wiki.

## Root

The working vault, local Git repository, and Obsidian vault are:

```text
C:\Codex\Wiki Files
```

Do not rename this folder. Do not move existing root folders as part of AIOS setup.

## Source-Of-Truth Rules

| Area | Source |
| --- | --- |
| Starting map | `Admin Home.md` |
| Repository and location policy | `Repository Location Rule.md` |
| Git scope, commit, and push rules | `Git Work Scope Rule.md` |
| Plugin and connector priority | `Connector and Plugin Usage Rules.md` |
| Project-room workflow | `Project Room Workflow.md` |
| Skill source-control policy | `Codex Skill Source Rule.md` |
| Agent and automation registry | `Agents and Automations Registry.md` |
| Privacy and AI access | `AIOS/privacy-rules.md` |

## Root-Level Structure

| Path | Role |
| --- | --- |
| `AIOS/` | Portable AI operating layer for the Admin wiki. |
| `AIOS/tool-startup/` | Thin startup pointers for specific AI tools. These point back to `AIOS/start-here.md`; they are not separate sources of truth. |
| `Project Rooms/` | Active and historical multi-source work rooms with `sources`, `working`, and `outputs`. |
| `skills/` | Canonical source for Buy Your Home Codex skills. |
| `operations/` | Durable operational data and rules such as grocery-list handling. |
| `tools/` | Utility scripts for maintaining the wiki or installed skill copies. |
| `templates/` | Reusable wiki templates. |
| `prompts/` | Durable prompts for repeatable wiki workflows. |
| `wiki/` | General reference index and log pages. |

## Important Root Files

| File | Use |
| --- | --- |
| `Admin Home.md` | First human/wiki map after AIOS startup. |
| `Agents and Automations Registry.md` | Current list of named agent-like roles, automations, schedules, and definitions. |
| `Connector and Plugin Usage Rules.md` | Decides when to prefer installed connectors/plugins over desktop automation. |
| `Project Room Workflow.md` | Required workflow for substantial multi-source drafting, analysis, redesign, or automation work. |
| `Repository Location Rule.md` | Confirms `C:\Codex\Wiki Files` as the working repo and warns against Teams as the wiki source. |
| `Git Work Scope Rule.md` | Tells AI how to keep commits scoped and avoid unrelated local changes. |
| `Codex Skill Source Rule.md` | Explains canonical skill source under `skills/` and installed copies under `%USERPROFILE%\.codex\skills`. |
| `Document Scanning SOP.md` | Human-facing scanned-document workflow. |
| `Document Scanning Skill Spec.md` | Detailed behavior for the document-scanning skill and automation. |
| `Document Scanning Folder Map.md` | Routing authority for scanned documents. |
| `Invoice and Receipt Processing Notes.md` | Invoice and receipt classification, naming, routing, and review rules. |
| `Invoice Project List.md` | Project/property routing reference for invoice workflows. |
| `SOP Spreadsheet Maintenance Rule.md` | Rules for SOP workbook and project-management workbook changes. |
| `AIOS/maintenance-log.md` | Material AIOS changes, tests, and revision decisions. |

## ACE Overlay

ACE is a navigation lens, not a folder migration. Keep current paths intact.

| ACE Area | Thinking Mode | Existing Wiki Areas |
| --- | --- | --- |
| Atlas-like | Durable knowledge and reference | SOPs, rules, registries, folder maps, `skills/`, `wiki/`, `templates/`, `prompts/`, and AIOS maps. |
| Calendar-like | Time-based context | Automation schedules, summary cutoff records, dated logs, meeting notes, scan logs, request logs, and recurring review records. |
| Efforts-like | Active work and deliverables | `Project Rooms/`, active document packages, spreadsheet rewrites, property reports, contract packages, and workflow redesigns. |

When deciding where to look:

- If the request asks what the rule is, look in Atlas-like files first.
- If the request asks what happened, what ran, or what changed by date, look in Calendar-like logs and automation records.
- If the request asks to build, analyze, draft, or implement something with multiple sources, use an Efforts-like project room.

## Project Rooms

Project rooms live under:

```text
C:\Codex\Wiki Files\Project Rooms
```

Current rooms include:

| Project Room | Use |
| --- | --- |
| `AIOS` | Planning and source notes for this portable AI operating layer. |
| `CMA Report` | Property report and CMA work. |
| `Contract for Deed` | Contract-for-deed seller document packages. |
| `Credit Worthiness Evaluator` | Tenant-buyer creditworthiness and ability-to-repay reports. |
| `Estate Documents` | Estate document review and related drafts. |
| `Operating Agreements` | Operating agreement source review and drafts. |
| `Pinetree Project Management Conversion` | Pinetree project-management conversion work. |
| `Project Management Spreadsheet Rewrite` | Project-management spreadsheet redesign planning. |

Before drafting from multiple sources, create or use a project room and update:

- `working/source-inventory.md`
- `working/duplicate-and-conflict-log.md`
- `working/missing-context.md`

## Operations

| Path | Use |
| --- | --- |
| `operations/grocery-list/README.md` | Grocery-list workflow overview. |
| `operations/grocery-list/wiki/Grocery List Rules.md` | Durable grocery-list operating rules. |
| `operations/grocery-list/data/current-grocery-list.md` | Current active grocery list. |
| `operations/grocery-list/data/request-log.md` | Dated request history. |
| `operations/grocery-list/data/always-order.md` | Recurring staples. |
| `operations/grocery-list/data/purchase-history.md` | Purchased or cleared grocery history. |

## Routing Rules For Common Requests

| Request Type | First Files To Read |
| --- | --- |
| New Admin wiki work | `AIOS/start-here.md`, `AIOS/me.md`, this file, then `Admin Home.md` |
| Multi-source drafting or analysis | `Project Room Workflow.md`, then the matching project room |
| AIOS work | `Project Rooms/AIOS/README.md`, `Project Rooms/AIOS/working/implementation-outline.md`, and this file |
| Skill creation or updates | `Codex Skill Source Rule.md`, then `AIOS/skills-map.md` |
| Agent or automation changes | `Agents and Automations Registry.md` |
| Email or calendar work | `Connector and Plugin Usage Rules.md`, then the durable email/calendar safety rules in `AIOS/me.md` and `AGENTS.md` |
| Document scanning | `Document Scanning SOP.md`, `Document Scanning Skill Spec.md`, `Document Scanning Folder Map.md` |
| Invoice or receipt routing | `Invoice and Receipt Processing Notes.md`, `Invoice Project List.md` |
| SOP workbook or spreadsheet edits | `SOP Spreadsheet Maintenance Rule.md` |
| Grocery-list work | `operations/grocery-list/README.md`, `operations/grocery-list/wiki/Grocery List Rules.md` |
| Git commit or push | `Git Work Scope Rule.md` |

## File Creation Rules

- Durable operating instructions belong in Markdown.
- Multi-source work belongs in a project room.
- Final outputs from project rooms belong in that room's `outputs/` folder unless the workflow says to copy final deliverables elsewhere.
- Raw source files belong in `sources/`; do not edit raw sources directly.
- Working inventories, audits, and drafts belong in `working/`.
- Do not copy files to Teams unless Wes asks or a workflow explicitly defines a final Teams deliverable.

## Maintenance

Update this file when:

- a new root folder becomes part of the Admin wiki operating structure,
- a major project room is added,
- a source-of-truth workflow file changes materially,
- AIOS startup behavior changes,
- or the ACE overlay no longer describes the wiki accurately.
