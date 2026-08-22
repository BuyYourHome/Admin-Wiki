# Shared Workflow Health Supervisor Specification

## Purpose

One independent Windows supervisor evaluates multiple Codex workflows without depending on Outlook or another connector it monitors. Email Monitor owns the shared implementation. Each enrolled workflow keeps separate configuration, health, alert state, current-alert file, and diagnostic log.

The supervisor detects failures and performance degradation. It does not perform business work, retry external actions, create replacement tasks, archive tasks, or change Git state.

## Architecture

| Component | Location | Responsibility |
| --- | --- | --- |
| Registry | `config\workflow-health-registry.json` | Defines the assigned machine, shared task, polling interval, mutex, runtime paths, and enabled workflows. |
| Supervisor | `tools\Invoke-CodexWorkflowHealthSupervisor.ps1` | Acquires the registry mutex, evaluates enabled workflows independently, isolates malformed configurations, and writes shared state and diagnostics. |
| Workflow evaluator | `tools\Invoke-CodexWorkflowWatchdog.ps1` | Evaluates heartbeat liveness or Project Room/task health and manages per-workflow alert transitions. |
| Heartbeat updater | `tools\Update-CodexWorkflowHealth.ps1` | Preserves Email Monitor `Started`, `Completed`, and `Failed` lifecycle writes. |
| Installer | `tools\Install-CodexWorkflowWatchdog.ps1` | Installs or refreshes the one shared Windows scheduled task. A legacy workflow config path resolves to the shared registry. |
| Manager | `tools\Manage-CodexWorkflowHealth.ps1` | Provides Options, Status, Enable, Disable, Configure, Test, and TestAlert for one workflow or supported all-workflow scope. |

## Shared Runtime

- Assigned machine: `WESSTUDIO`.
- Scheduled task: `Codex - Workflow Health Supervisor`.
- Polling interval: 10 minutes.
- Mutex: `Global\CodexWorkflowHealthSupervisor`.
- Registry: `C:\Codex\Wiki Files\Project Rooms\Email Monitor\config\workflow-health-registry.json`.
- Supervisor state: `C:\Users\wesbr\.codex\workflow-health-supervisor\supervisor-state.json`.
- Supervisor diagnostics: `C:\Users\wesbr\.codex\workflow-health-supervisor\supervisor.log`.

The supervisor refuses to run on the wrong machine. A second overlapping invocation exits after recording that the registry lock is held. A missing or malformed workflow configuration returns an error for that workflow and does not stop evaluation of the others.

Migration note: Email Monitor moved to `OFFICEASSIST` on 2026-08-22. Its lifecycle configuration is assigned to OfficeAssist, but its enrollment in this WesStudio shared supervisor is disabled to prevent false stale alerts. Invoice Entry remains enrolled on WesStudio. Re-enable Email Monitor liveness evaluation only after a dedicated OfficeAssist or verified multi-machine supervisor design is installed and tested.

## Alert Contract

Each workflow preserves its own previous level. Alerts are emitted only for transitions:

- one warning when entering `WARNING`;
- one critical alert when entering `CRITICAL`;
- one recovery when returning to `HEALTHY` from warning or critical;
- no repeated visible alert while the level is unchanged;
- no visible notification for routine healthy checks.

Every evaluation may write diagnostics. Repeated diagnostic lines are not repeated visible alerts. The current-alert file represents an active warning or critical condition and is removed after recovery.

Alerts attempt a Windows toast and an Application event-log entry. Email and SMS are excluded until an independent delivery path is configured and verified.

## Email Monitor Enrollment

- Workflow id: `officeassist-morning-email-summary-and-instruction-monitor`.
- Config: `config\email-monitor-health.json`.
- Check type: `heartbeat_liveness`.
- Active window: 7:45 AM through 11:00 PM Eastern.
- Expected heartbeat: 15 minutes.
- Warning: 35 minutes.
- Critical: 60 minutes.
- Health: `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\health.json`.
- State: `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\watchdog-state.json`.
- Alert: `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\current-alert.txt`.
- Diagnostics: `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\watchdog.log`.

Email Monitor continues calling the updater at heartbeat start and completion or failure. Migration must preserve its machine-local history where practical.

## Invoice Entry Enrollment

- Workflow id: `invoice-entry`.
- Config: `config\invoice-entry-health.json`.
- Check type: `project_room_task_health`.
- Project Room: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry`.
- Task id: `019fbf4f-c629-7dd1-a3f6-0de33de0ed8f`.
- Canonical status: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\work-status.md`.
- Substantive evaluation interval: 1,440 minutes.
- Status warning age: 2,880 minutes.
- Status critical age: 10,080 minutes.
- In-flight warning: 120 minutes.
- In-flight critical: 240 minutes.
- Runtime: `C:\Users\wesbr\.codex\workflow-health-supervisor\invoice-entry`.

The 10-minute supervisor run checks whether Invoice Entry evaluation is due. It skips substantive inspection until due unless the previous level requires follow-up. The separate noon and 4:00 PM Invoice Entry packet-backup automation remains a detached cron job, so each scheduled run creates a separate execution task rather than adding a turn to the active Invoice Entry operational task.

For the packet-backup cron, a clean completed run records any required automation-memory outcome, emits no routine inbox item or final user-facing status, obtains its actual current execution task id from runtime metadata, and archives only that task with `set_thread_archived({ threadId: currentExecutionThreadId, archived: true })`. The archive call requires the explicit id. Never omit it, infer it from title or timing, or use the Invoice Entry operational task id. If runtime metadata does not expose an unambiguous current execution id, do not guess or archive another task; report the limitation and leave the execution visible.

After an otherwise clean scan, the cron may inspect at most the five most recent unarchived predecessor executions from the prior 14 days. Confirm each candidate from task history containing the exact automation id `invoice-entry-to-projects-backup-heartbeat`; title or timestamp matching alone is not authoritative. Exclude the current execution and the active Invoice Entry operational task. Archive a predecessor only when it is a verified completed clean run, or an interrupted clean run conclusively superseded by a later successful run with no unique packet, unresolved blocker, decision, meaningful failure, or uncertain side effect. Leave uncertain and attention-bearing tasks visible. Store reviewed task ids, classifications, and archive outcomes compactly in automation memory. If authoritative task-history or archive tools are unavailable, skip cleanup rather than guess, report the limitation on its first occurrence or material change, and avoid repeated visible reports for the unchanged condition.

Invoice Entry health uses only observable evidence:

- missing or stale `work-status.md`;
- an explicitly recorded in-flight operation that has exceeded its threshold;
- recorded recent task timeouts, stalled final responses, or duplicate external-action attempts;
- Project Room Git paths that are uncommitted and not classified in current status;
- observable turn and compaction counts recorded with their source and observation time;
- rollover-readiness fields for durable work, delivery evidence, packets/blockers, and Git classification.

An independent Windows process cannot directly query Codex task history. If turn or compaction counts have not been recorded by an authorized Codex inspection, they remain unavailable. The evaluator does not invent them.

## Context Prevention

- Keep detailed processing history in packet files, logs, or approved Teams locations instead of operational-task messages.
- Use concise handoffs containing source identifiers, external references and paths, a short summary, the requested operation, and source-specific warnings.
- Update each enrolled PR's `working\work-status.md` after meaningful state changes and before substantial work ends.
- Do not route quiet health or backup checks into the operational PR task.
- Notify an operational task only for actionable work, a health transition, a failure, or a decision.
- Treat 150 observable turns and five observable context compactions as review triggers, not rollover commands.

## Controlled Rollover

The supervisor may recommend a controlled rollover only when multiple measured signals support review. It must report whether:

- no operation is in flight;
- current work is durably recorded;
- external delivery evidence is recorded;
- open packets and blockers are current;
- Git and working-file state are classified.

Actual rollover requires Wes's separate approval. It keeps the same Project Room and skill, creates one replacement operational task from a concise durable handoff, verifies the replacement, and archives the predecessor only after verification. Maintain exactly one active operational task. Do not create a Project Room or Git branch for rollover.

## Management Commands

Default registry command:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Codex\Wiki Files\Project Rooms\Email Monitor\tools\Manage-CodexWorkflowHealth.ps1" -Action Status -WorkflowId All
```

The prior Email Monitor command using `-ConfigPath ...\email-monitor-health.json` remains valid and targets Email Monitor through the shared registry.

- `Options`: show commands and safeguards.
- `Status`: report one workflow or all registered workflows.
- `Enable`: enable one or all registry entries and ensure the shared task is installed.
- `Disable`: disable one or all entries; the shared task remains active while any workflow is enabled.
- `Configure`: target one workflow and change only requested values.
- `Test`: run a non-notifying forced diagnostic for one or all workflows.
- `TestAlert`: target one workflow and issue a visible test alert without changing workflow health.

## Migration And Rollback

Install and test `Codex - Workflow Health Supervisor` while the prior `Codex - Email Monitor Health Check` task remains available. After shared evaluation passes, disable the prior task so both tasks cannot evaluate Email Monitor simultaneously. Retain the disabled prior task temporarily as the quickest machine-local rollback path.

For immediate machine-local rollback, disable `Codex - Workflow Health Supervisor` and re-enable `Codex - Email Monitor Health Check`. Durable rollback is a normal focused Git revert. Do not use `git reset --hard` or force-push.

## Required Verification

1. Parse all PowerShell files and JSON configurations.
2. Run a quiet all-workflow diagnostic and confirm healthy checks do not notify.
3. Exercise warning, unchanged warning, and recovery transitions in isolated runtime paths.
4. Confirm a malformed test workflow does not stop valid workflow checks.
5. Run Invoice Entry evaluation without changing its operational task, queue, or automations.
6. Confirm the shared task runs every 10 minutes with the hidden PowerShell action.
7. Confirm only the shared supervisor task remains active after migration.
8. Record exact paths, thresholds, and test results in the implementation report.
