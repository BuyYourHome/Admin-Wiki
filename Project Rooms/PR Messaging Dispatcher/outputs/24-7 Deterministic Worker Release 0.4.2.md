# 24/7 Deterministic Worker Release 0.4.2

## Purpose

Release `0.4.2` prevents the one-minute dispatcher poll from displaying a PowerShell console or stealing focus from the interactive Windows user.

## Cause

The `0.4.1` scheduled task executed `powershell.exe` directly with `-WindowStyle Hidden`. Windows could create the console before PowerShell processed that option, producing a brief visible window on WES-VIDEOEDITOR and OFFICEASSIST.

## Correction

- Execute the scheduled task through `C:\Windows\System32\wscript.exe`.
- Use the release-pinned `Invoke-LowTokenWorkerHidden.vbs` wrapper with window style `0`.
- Pass only the pinned PowerShell path, worker path, configuration path, mode, and optional validation message id.
- Preserve the worker exit code and wait for each tick to finish.
- Include the launcher in the package integrity hash.

## Upgrade Contract

`UpgradeLive` preserves the existing owner, generation, state directory, journal, task identity, 60-second schedule, destination pins, and transport behavior. It replaces only the installed hash-pinned package, configuration release metadata, and scheduled task action. No synthetic record or transport validation is required because the worker logic and authorization contract are unchanged.

Upgrade one machine at a time. Confirm the task action executes `wscript.exe`, observe at least two natural ticks, verify health remains `TickComplete`, and confirm no console appears or steals focus before proceeding to the next machine.

## Verification

- PowerShell parser: 18 files, 0 errors.
- Windows Script Host launcher: parsed successfully and rejected missing arguments with the expected exit code.
- Isolated worker suite: 63 passed, 0 failed.
- Integrity and administrative-closure suite: 47 passed, 0 failed.
- Real CLI submissions: 0.
- Canonical queue writes: 0.
- Production business actions: 0.
