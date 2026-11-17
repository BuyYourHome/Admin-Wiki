# 24/7 Deterministic Worker Release 0.4.12

Date: 2026-11-17

## Scope

Release `0.4.12` changes transport candidate selection from oldest-first to newest-first. Stable ordering is descending `created_at_utc`, then descending `message_id`.

It also removes the repeated full-queue integrity cost that caused OFFICEASSIST release `0.4.11` ticks to spend about 150 seconds and 371 hash checks on the November 1 CLS record before reaching later intake:

- unchanged complex historical records use a machine/SID-bound local integrity cache;
- the cache fingerprint follows manager-updated lifecycle metadata and is a performance hint only;
- destination holds are computed once per tick instead of once per candidate;
- common valid hash formats short-circuit before legacy compatibility calculations;
- `ConditionalClaim` ignores the local cache, rereads under the queue lock, freshly validates immutable content and current destination holds, checks the exact config/version, and grants at most one submission.

Invalid, changed, ambiguous, unacknowledged, or conflicting evidence remains held. Acceptance remains delivery evidence only and never becomes business completion. No retry, replacement handoff, invoice processing, or payment action is authorized.

## Guarded OFFICEASSIST UpgradeLive

From a normal interactive `OFFICEASSIST\OfficeAssistLogin` PowerShell session, safely fast-forward a clean Admin Wiki `main` branch through the published release commit, then run:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Codex\Wiki Files\tools\pr-messaging\low-token\Install-LowTokenWorker.ps1" -Action UpgradeLive -ExpectedMachine OFFICEASSIST -DispatcherTaskId "01a09d84-a309-7591-a790-e770fcb53dee" -LegacyAutomationId "officeassist-morning-email-summary-and-instruction-monitor"
```

Require `LiveUpgraded`, release `0.4.12`, the reviewed normal-user CLI path/hash/package evidence, the prior owner and generation, unchanged state directory and journal, unchanged destination pins, and preserved task identity/hidden launcher/one-minute schedule.

Do not force a worker run. Observe two natural scheduled ticks and require both to reach candidate evaluation without `ManagerReleaseMismatch`, preserve truthful claim/submission counts, and show the integrity-cache diagnostics. Do not retry any record. Installer success does not prove remote SMB reachability; verify a canonical manager read separately under `OfficeAssistLogin`.

## Verification evidence

Windows PowerShell 5.1 isolated verification on WES-VIDEOEDITOR passed 212 tests with zero failures: 69 worker lifecycle/duplicate tests, 8 diagnostic/UTF-8 tests, 26 enrollment tests, 19 destination-enrollment tests, 10 installer/CLI tests, 77 integrity/closure tests, and 3 release-0.4.12 large-queue tests. The large-queue fixture contained 371 records, including 120 accepted historical records; newest selection succeeded, the atomic manager freshly evaluated the destination under lock, the first claim granted one submission permission, and the idempotent repeat granted none. A separate stale-cache fixture proved that a hash-invalid accepted record still holds the destination inside the atomic manager. No production action, central write, real notification, forced worker run, retry, or invoice action occurred.
