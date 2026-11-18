# 24/7 Deterministic Worker Release 0.4.13

## Scope

Release `0.4.13` is a guarded installer/preflight correction. It retains release `0.4.12` newest-first candidate evaluation, bounded historical-integrity work, destination holds, duplicate and ambiguous-delivery protections, and fresh authoritative validation inside the atomic claim.

On OFFICEASSIST, `UpgradeLive` stopped before disabling or changing the installed worker with `CliExecutableMissing` because the normal-user PowerShell session did not expose the registered Microsoft Store `codex.exe` through `Get-Command`.

The corrected preflight first uses the existing command lookup. If that lookup is empty, it accepts only one exact normal-user AppX registration with all of these properties:

- package name `OpenAI.Codex`;
- publisher `CN=50BDFD77-8903-4850-9FFE-6E8522F64D5B`;
- family `OpenAI.Codex_2p2nqsd0c76g0`;
- x64 architecture and the exact reviewed full-name form;
- an install location whose WindowsApps leaf exactly equals the registered package full name; and
- executable path exactly `app\resources\codex.exe` beneath that install location.

The fallback does not by itself trust or pin the executable. The existing manifest identity, valid OpenAI Authenticode signer, non-reparse file, `codex-cli <version>` behavior, and stable before/after SHA-256 checks must all pass. Missing, ambiguous, changed, incorrectly located, or differently identified packages remain fail-closed.

## OFFICEASSIST guarded upgrade

After safely fast-forwarding `C:\Codex\Wiki Files` to the published release commit, run under the normal `OfficeAssistLogin` identity:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Codex\Wiki Files\tools\pr-messaging\low-token\Install-LowTokenWorker.ps1" -Action UpgradeLive -ExpectedMachine OFFICEASSIST -DispatcherTaskId "01a09d84-a309-7591-a790-e770fcb53dee" -LegacyAutomationId "officeassist-morning-email-summary-and-instruction-monitor"
```

Require `LiveUpgraded`, release `0.4.13`, the exact reviewed CLI path/hash/package evidence, preserved owner and generation, unchanged state directory/journal/destination pins, and preserved scheduled-task identity, hidden launcher, Live mode, and one-minute schedule. Then separately verify one successful canonical-manager SMB read and observe two natural scheduled ticks reaching candidate evaluation.

Do not force a worker run, retry or replace a record, reset attempts, alter central records, or perform invoice work.

## Verification

Windows PowerShell 5.1 isolated verification passed 218 tests with zero failures: 69 worker lifecycle and duplicate tests, 8 diagnostic/UTF-8 tests, 26 enrollment tests, 19 destination-enrollment tests, 16 installer/CLI tests, 77 integrity and closure tests, and 3 newest-first large-queue tests. The tests performed no production queue mutation, real notification, forced worker run, retry, or invoice action.
