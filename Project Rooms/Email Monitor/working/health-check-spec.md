# Email Monitor Health Check Specification

## Purpose

Health Check detects when the Email Monitor heartbeat stops completing even though other Codex tasks may still work. It also provides a reusable watchdog pattern for other Project Rooms without treating one workflow's failure as a global Codex outage.

## Components

| Component | Location | Responsibility |
| --- | --- | --- |
| Health updater | `tools\Update-CodexWorkflowHealth.ps1` | Atomically records run start, completion, failure, mode, machine, and consecutive failures. |
| Watchdog | `tools\Invoke-CodexWorkflowWatchdog.ps1` | Independently evaluates health age, writes diagnostics, deduplicates alerts, and sends local Windows notifications. |
| Installer | `tools\Install-CodexWorkflowWatchdog.ps1` | Creates or updates the Windows scheduled task from a workflow config. |
| Email Monitor config | `config\email-monitor-health.json` | Assigns the workflow to `WESSTUDIO` and defines paths, active window, thresholds, and scheduled-task identity. |
| Runtime health | `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\health.json` | Machine-local current health state. |
| Watchdog state | `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\watchdog-state.json` | Machine-local alert transition and recovery state. |
| Diagnostic log | `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\watchdog.log` | Append-only watchdog evaluations and alert outcomes. |

## Email Monitor Contract

At the beginning of every heartbeat, before mailbox or Project Room work, call the updater with `Started` and the intended mode. Before the heartbeat returns, call it with `Completed`. If the run fails or cannot finish normally, call it with `Failed`, including a concise failure stage and message.

Health updates do not replace Email Monitor memory, send verification, failure reporting, or routing ledgers.

## Watchdog Rules

- Run every 10 minutes through Windows Task Scheduler.
- Evaluate only during the configured 7:45 AM through 11:00 PM Eastern active window.
- Healthy: last completed heartbeat is no more than 35 minutes old.
- Warning: no completed heartbeat for more than 35 minutes.
- Critical: no completed heartbeat for more than 60 minutes, or a run remains `running` beyond 60 minutes.
- Recovery: emit one recovery notice after a warning or critical condition returns to healthy.
- Deduplicate alerts by state transition; do not notify every 10 minutes for the same unchanged condition.
- Refuse to supervise the workflow when the current computer does not match `assigned_machine`.

## Alerts

The watchdog always writes its diagnostic log and current alert state. On warning, critical, and recovery transitions, it attempts:

1. a Windows toast notification for the signed-in user;
2. an Application event-log entry using the existing `Windows PowerShell` source;
3. a durable `current-alert.txt` file beside the runtime health file.

Email and SMS are intentionally excluded until an independent, verified delivery path is configured. The watchdog must not depend on the same Codex Outlook connector it is supervising.

## Reuse Pattern

To use this pattern for another Project Room:

1. Copy `config\email-monitor-health.json` to a new workflow-specific config.
2. Give it a unique `workflow_id`, scheduled-task name, runtime directory, and assigned machine.
3. Set the expected interval, active window, warning, and critical thresholds.
4. Add updater calls to that workflow's automation.
5. Run the installer with the new config.
6. Test healthy, warning, critical, recovery, wrong-machine, and missing-state behavior.

Each workflow keeps independent health, watchdog, and alert state. A future central supervisor may consume those states, but this mode does not create a cross-machine supervisor.

## Installed Instance

- Machine: `WESSTUDIO`
- Windows scheduled task: `Codex - Email Monitor Health Check`
- Repetition interval: `PT10M`
- First verified task result: `0` on 2026-07-24
- Isolated tests passed: healthy, warning at 40 minutes, critical at 70 minutes, recovery from critical, one-failure warning, three-failure critical, and wrong-machine refusal
