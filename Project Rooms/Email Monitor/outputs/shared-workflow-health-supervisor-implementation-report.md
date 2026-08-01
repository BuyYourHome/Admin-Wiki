# Shared Workflow Health Supervisor Implementation Report

Date: 2026-08-01
Machine: `WESSTUDIO`

## Migration Status

- Shared task `Codex - Workflow Health Supervisor`: installed, enabled, and verified with task result `0`.
- Shared polling interval: 10 minutes (`PT10M`).
- Prior task `Codex - Email Monitor Health Check`: disabled and retained for rollback.
- Active scheduled supervisors: one.
- Invoice Entry's canonical skill contains the concise task-health, status-maintenance, and Wes-approved rollover contract; shared supervisor implementation details remain owned by Email Monitor.
- Task Health Mode is defined for both Email Monitor and Invoice Entry, with separate Health Review and Approved Rollover stages and dependency-retargeting safeguards.
- Nothing was pushed during implementation.

## Enrolled Workflows

| Workflow | Check | Active window | Evaluation | Warning | Critical |
| --- | --- | --- | --- | --- | --- |
| Email Monitor | Heartbeat liveness | 7:45 AM-11:00 PM Eastern | Every 10-minute poll | 35 minutes | 60 minutes |
| Invoice Entry | Project Room/task health | All day | Daily substantive review; cheap due check every 10 minutes | Status 48 hours; in-flight operation 120 minutes | Status 7 days; in-flight operation 240 minutes |

Invoice Entry task-growth review triggers are 150 observable turns and five observable context compactions. They do not authorize automatic rollover.

## Paths

- Registry: `C:\Codex\Wiki Files\Project Rooms\Email Monitor\config\workflow-health-registry.json`.
- Email Monitor config: `C:\Codex\Wiki Files\Project Rooms\Email Monitor\config\email-monitor-health.json`.
- Invoice Entry config: `C:\Codex\Wiki Files\Project Rooms\Email Monitor\config\invoice-entry-health.json`.
- Supervisor state: `C:\Users\wesbr\.codex\workflow-health-supervisor\supervisor-state.json`.
- Supervisor log: `C:\Users\wesbr\.codex\workflow-health-supervisor\supervisor.log`.
- Invoice Entry runtime: `C:\Users\wesbr\.codex\workflow-health-supervisor\invoice-entry`.
- Email Monitor runtime remains under `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor`.

## Test Results

- PowerShell syntax: passed for all five workflow-health scripts.
- JSON parsing: passed for registry and both workflow configs.
- Quiet all-workflow diagnostic: passed; Email Monitor healthy with no notification.
- Invoice Entry forced diagnostic: passed; warning reported from 562 turns, 30 compactions, and one stalled final response; rollover remained Wes-gated.
- Invoice Entry due check: passed; second check skipped substantive evaluation because daily evaluation was not due.
- Warning transition: passed in isolated runtime.
- Unchanged warning: passed; no second notification transition.
- Recovery transition: passed; active current-alert file removed.
- Malformed workflow isolation: passed; valid workflow remained healthy while missing test configuration returned a workflow-specific error.
- Overlap protection: passed; a second hidden run exited `0` and logged that the registry mutex was held.
- Wrong-machine refusal: passed with `SKIPPED / WRONG_MACHINE`.
- Email Monitor TestAlert: passed without changing workflow health.
- Legacy Email Monitor `-ConfigPath` management command: passed and resolved to the shared task.
- Shared scheduled-task run: passed with result `0`.
- Scheduled-task action: hidden PowerShell supervisor using the canonical registry.

## Existing Alert Behavior

The prior watchdog already gated visible notifications on state changes. Its diagnostic log contained repeated critical evaluation lines every 10 minutes while Email Monitor remained unhealthy, but the code did not republish a visible alert for an unchanged level. The shared implementation makes that distinction explicit and logs alert transitions separately from routine evaluations.

## Observable Metrics

The Windows supervisor can inspect status-file age, structured task-health fields, Project Room Git status, and machine-local workflow state. It cannot directly query Codex task turns or context compactions. Those values remain unavailable unless an authorized Codex task-history inspection records the measured values and observation time in `working\work-status.md`.

## Rollback

For immediate rollback, disable `Codex - Workflow Health Supervisor` and re-enable `Codex - Email Monitor Health Check`. Then revert the focused Git commit if the canonical implementation must also be reversed. Do not enable both tasks simultaneously.
