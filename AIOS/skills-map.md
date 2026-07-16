# AIOS Skills Map

This file indexes Buy Your Home Admin workflow skills and related agent-like roles.

## Skill Source Rule

Canonical skill source lives here:

```text
C:\Codex\Wiki Files\skills
```

Installed runtime copies live here:

```text
%USERPROFILE%\.codex\skills
```

Do not author or version skills from the installed runtime copy. Edit the canonical wiki source, commit the wiki update, and sync installed copies only when the update is ready.

## Canonical Wiki-Managed Skills

| Skill | Canonical Source | Use When | Related Context |
| --- | --- | --- | --- |
| `admin-request-wrapup` | `skills/admin-request-wrapup/SKILL.md` | Finishing Admin wiki requests; reporting elapsed time; deciding commit/push reporting. | `Git Work Scope Rule.md`, `AGENTS.md` |
| `doc-scan` | `skills/doc-scan/SKILL.md` | Processing scanned financial/admin PDFs or JPG/JPEG scans, splitting documents, naming, routing, and logging. | `Document Scanning SOP.md`, `Document Scanning Skill Spec.md`, `Document Scanning Folder Map.md`, `Invoice and Receipt Processing Notes.md` |
| `credit-worthiness-evaluator` | `skills/credit-worthiness-evaluator/SKILL.md` | Evaluating tenant-buyer creditworthiness and ability to repay for seller-financed or Contract for Deed transactions. | `Project Rooms/Credit Worthiness Evaluator/README.md` |
| `contract-for-deed` | `skills/contract-for-deed/SKILL.md` | Refreshing and regenerating contract-for-deed seller document packages from project spreadsheets. | `Project Rooms/Contract for Deed/README.md` |
| `cma-report` | `skills/cma-report/SKILL.md` | Creating CMA/property reports and copying completed reports to the matching Teams property `Owning` folder. | `Project Rooms/CMA Report/`, property folders under Teams sync |

## Agent-Like Roles And Automations

Use `Agents and Automations Registry.md` as the controlling registry. Current important entries include:

| Name | Type | Use |
| --- | --- | --- |
| Jean Wright / Office Assistant | Assistant profile and operating role | Office assistant work, email drafting/sending under safety rules, grocery updates, and admin coordination. |
| Email Monitor | Heartbeat automation plus wiki-managed skill | Daily Wes email summary from the full mailbox store, including rule-routed folders, plus OfficeAssist instruction-email monitoring. |
| Doc Scan | Wiki-managed skill plus cron automation | Scheduled scan intake processing and routing. |
| REI Text Message Watcher | Heartbeat automation | Watch approved Boss/Jenny texts in REI BlackBook / Profit Dial. |
| Grocery List Handler | Wiki rule and data workflow | Maintain current grocery list, request log, staples, and purchase history. |
| AI Project Room Workflow | Wiki workflow | Prepare source sets and drafts for complex work. |

## Plugin And Connector Skills

Installed plugins may expose additional skills for Outlook Email, Outlook Calendar, GitHub, Browser, Documents, Presentations, and Spreadsheets. Use them when their plugin-specific skill description matches the task.

Local Admin wiki source still controls durable operating rules. If a plugin can act more reliably than desktop automation, prefer the plugin, but follow `Connector and Plugin Usage Rules.md` and any applicable safety rule.

## When To Use A Skill

Use a skill when:

- Wes names it,
- the request clearly matches the skill description,
- or the workflow file says that skill is required.

Before changing a wiki-managed skill:

1. Read `Codex Skill Source Rule.md`.
2. Edit the canonical folder under `skills/`.
3. Update any related project room or registry entry if behavior changes.
4. Commit the scoped wiki changes.
5. Sync installed copies only when Wes says the updated skill is ready or the change is a finished product.

## Skill Maintenance

Update this file when:

- a wiki-managed skill is added, renamed, paused, deleted, or materially changed,
- a project room becomes the required context for a skill,
- or the installed connector/plugin priority changes.
