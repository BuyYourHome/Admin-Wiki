# OfficeAssist Codex Project Correction - 2026-08-25

## Scope

- Target computer: OfficeAssist
- Correct Codex Desktop project name: `Wiki Files`
- Correct source folder: `C:\Codex\Wiki Files`
- Incorrect saved project path to avoid: `C:\Users\OfficeAssistLogin\Documents\ChatGPT\Admin WIKI`
- Canonical Admin wiki repository: `C:\Codex\Wiki Files`

## Verified observations

- OfficeAssist remote session was visible through Remote Desktop.
- Codex Desktop displayed a `Wiki Files` project.
- The selected `Wiki Files` task reported its project path as `C:\Codex\Wiki Files`.
- The old `Admin WIKI` project was still visible in Codex Desktop and had previously created Project Room tasks under it.

## Managed command runner status

Status: blocked.

The corrected `Wiki Files` project still failed before command launch with:

```text
Failed to create unified exec process: helper_unknown_error: setup refresh had errors
```

The task text shown in Codex Desktop reported that starting the Windows Secondary Logon service (`seclogon`) did not resolve the managed-command setup-refresh failure.

Managed Runtime Failure Recovery was attempted on 2026-08-25:

- Codex was fully quit, including the desktop/tray process as reported by Wes.
- The affected OfficeAssist profile cache was renamed from `C:\Users\OfficeAssistLogin\.cache\codex-runtimes` to `C:\Users\OfficeAssistLogin\.cache\codex-runtimes.backup-20260825-130032`.
- Codex was reopened so it could rebuild the runtime.
- A brand-new task was opened under the corrected `Wiki Files` project.
- The brand-new task still failed before launching any command with `setup refresh had errors`.

Conclusion: the failure does not appear limited to the old task. It also occurs in a brand-new task after the runtime cache rename, so this is now recorded as a Codex managed-sandbox/setup-refresh blocker for the OfficeAssist profile.

## GitHub and Git verification status

Status: incomplete from the corrected OfficeAssist project.

Git and repository verification were not completed through the corrected project's managed command runner because the runner failed before launch.

After the cache rename, the brand-new corrected-project task could report its task context as `C:\Codex\Wiki Files` and Windows username as `OfficeAssistLogin`, but could not run `git status --short --branch` or retrieve the latest commit through the managed command runner.

## Old-project task inventory

Do not delete, archive, move, duplicate, replace, or register these tasks without Wes's specific approval.

Visible under the old `Admin WIKI` project:

- Create PR
- Sync GetHub
- Computers
- Marketplace
- Manager

The full old-project task list was not expanded during this correction record.

## Readiness for Create PR

Min PR Set readiness: not ready.

Reason: the corrected `Wiki Files` project exists and appears to point to `C:\Codex\Wiki Files`, but command-runner verification still fails in a brand-new task after Managed Runtime Failure Recovery.

Required before handoff to Create PR `Min PR Set`:

1. Open or create the `Wiki Files` Codex Desktop project with source folder `C:\Codex\Wiki Files`.
2. Start a brand-new task in that project.
3. Confirm the managed command runner can run without elevation.
4. Verify `Get-Location`, `git status --short --branch`, local-versus-`origin/main`, latest commit, and an installed skill read.
5. Inventory the full task list under the old `Admin WIKI` project, if Wes wants cleanup planning.

## Secrets and external changes

- No passwords, tokens, recovery codes, license keys, or MFA codes were recorded.
- No old-project tasks were changed.
- No external systems were changed from this record.
