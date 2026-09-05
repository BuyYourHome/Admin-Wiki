# Source Inventory

| Source | Location | Status | Notes |
|---|---|---|---|
| Email Monitor skill | `C:\Codex\Wiki Files\skills\email-monitor\SKILL.md` | authoritative | Primary workflow definition for mailbox scan, cutoff, prioritization, summary body, and state update. |
| Email Delivery skill | `C:\Codex\Wiki Files\skills\email-delivery\SKILL.md` | authoritative | Governs the Email Delivery mode: OfficeAssist sender safety, shared/delegated connector sends, attachment-path validation and schema-correct retry, Sent Items verification, delivery logging, fallback, and failure reporting. |
| Manager skill | `C:\Codex\Wiki Files\skills\manager\SKILL.md` | authoritative read-only dependency | Defines Task mode statuses, priorities, and task-list interpretation used in Josh's summary. Email Monitor does not edit this skill. |
| Manager task register | `C:\Codex\Wiki Files\Project Rooms\Manager\working\task-register.md` | authoritative read-only dependency | Supplies the current task list included in Josh's summary. Email Monitor does not update task status or add tasks here. |
| Admin rules | `C:\Codex\Wiki Files\AGENTS.md` | authoritative | Email sender safety and Email Monitor scope rules. |
| Agents and Automations Registry | `C:\Codex\Wiki Files\Agents and Automations Registry.md` | authoritative | Human-readable registry entry for the automation and skill. |
| Live automation config | `C:\Users\OfficeAssistLogin\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\automation.toml` | authoritative destination config after activation | Defines live automation id, kind, schedule, prompt, status, and target task. Exact source snapshots are preserved in `working\migrations\2026-09-04-wesstudio-to-officeassist`. |
| Automation run memory | `C:\Users\OfficeAssistLogin\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\memory.md` | authoritative destination state after activation | Starts from the verified source snapshot and preserves summary cutoffs, weekly subjects, duplicate prevention, unresolved requests, and routing holds. |
| Health Check specification | `Project Rooms\Email Monitor\working\health-check-spec.md` | authoritative | Defines workflow-specific health state, watchdog thresholds, alerts, machine assignment, and reuse rules. |
| Health Check config | `Project Rooms\Email Monitor\config\email-monitor-health.json` | authoritative | Assigns Email Monitor to `OFFICEASSIST` under `OfficeAssistLogin`; watchdog activation remains a destination verification step. |
| Health Check tools | `Project Rooms\Email Monitor\tools\*.ps1` | authoritative mechanism | Manage conversational options and configuration, update health state, evaluate and alert on stale state, and install the Windows scheduled watchdog. |
| Routing Action Log | `Project Rooms\Email Monitor\working\routing-action-log.md` | authoritative outcome log | Durable Admin wiki summary of important routed-email and Email Delivery outcomes, including preserved source path, handoff target, status, and blockers. |
| Automation config source note | `Project Rooms\Email Monitor\sources\automation-config-source-note.md` | background | Snapshot summary of the live local automation config. |
| Skill source note | `Project Rooms\Email Monitor\sources\skill-source-note.md` | background | Summary of skill ownership and boundaries. |

## Inventory Notes

- Keep raw source paths in this inventory. Do not copy the live automation TOML into the repo unless Wes asks.
- Keep the live automation memory outside the repo with the automation config. Document its path here and in the skill rather than copying run-state contents into the wiki.
- If the automation config changes, update the source note and registry in the same work group.
