# 24/7 Deterministic Worker Release 0.4.9

Date: 2026-10-23

## Repair

Release `0.4.9` explicitly reads canonical message records as UTF-8. This corrects the Windows PowerShell 5.1 default-decoding path that changed BOM-less non-ASCII JSON in memory and then caused `JournalHashOrDestinationMismatch` even though the unchanged stored record and journal identity fields matched.

The correction is read-only. It never normalizes or rewrites the stored payload or stored hash. Immutable verification, exact destination identity, receipt validation, duplicate prevention, attempt limits, journal retention, and ambiguity holds remain unchanged.

## Guarded recovery

For the reproduced October 8 condition—terminal recipient lifecycle, one local `planned` journal entry, no matching central attempt, no submission evidence, and no permanent marker—the worker:

1. reads the unchanged record as UTF-8;
2. verifies exact message, dispatch, payload hash, destination task, and destination machine;
3. retains the journal entry and closes it as `NotClaimed`;
4. leaves the central record, receipt, result, state, events, and zero attempts unchanged; and
5. performs no claim, CLI request, notification, retry, replacement, or business action.

The affected production record remains `prmsg-invoice-entry-email-delivery-tim-pond-approved-20261008-001`; its reproduced journal attempt is `lt-8be621d704e74884a01c8085669c7a87`. This release does not authorize changing either item manually.

## Diagnostics and bounds

Health retains the existing phase, manager-call, hash, checkpoint, and elapsed-time diagnostics. It adds:

- `claim_attempts`: number of atomic claim calls initiated during the tick;
- `failure_before_claim`: true only when the tick failed before any atomic claim call; and
- `failure_phase`: the phase active when the failure occurred.

The production tick remains bounded to 180 seconds. Manager List calls remain bounded to 60 seconds and other manager calls to 120 seconds, always capped by the remaining tick budget. Diagnostics contain safe codes and counts, not payloads or command output.

## OFFICEASSIST guarded deployment

After this release commit is on GitHub, use the existing OFFICEASSIST dispatcher task and normal Windows identity to preserve unrelated local work and first reconcile its local evidence commit `edb32855`. Do not reset, stash, overwrite, or push unrelated commits. Fetch GitHub and integrate only when the local repository can safely fast-forward or the exact evidence commit has been transferred as a scoped patch/commit through the approved coordination path.

Run only:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Codex\Wiki Files\tools\pr-messaging\low-token\Install-LowTokenWorker.ps1" -Action UpgradeLive -ExpectedMachine OFFICEASSIST -DispatcherTaskId "01a09d84-a309-7591-a790-e770fcb53dee" -LegacyAutomationId "officeassist-morning-email-summary-and-instruction-monitor"
```

The installer must review and pin the current normal-user `codex.exe` path and SHA-256. Preserve owner generation, production state, journal, task identity, hidden launcher, Live mode, one-minute schedule, and all destination pins. Do not force a worker run. Observe two natural ticks and require both to reach candidate evaluation. Report each tick's status, error, `failure_before_claim`, `failure_phase`, claims, submissions, model requests, and attention items.

Do not retry or replace the Tim approval, manually clear or edit the journal, create a test production record, change central lifecycle, or perform email, invoice, payment, workbook, or other business work.

## Isolated verification

- Worker suite: 69 passed, 0 failed.
- UTF-8 and diagnostics suite: 8 passed, 0 failed.
- Guarded enrollment suite: 24 passed, 0 failed.
- Destination-enrollment suite: 17 passed, 0 failed.
- Production actions: 0.
- Real CLI submissions/notifications: 0.
