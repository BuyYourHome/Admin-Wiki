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

Status: verified after ACL repair.

The corrected `Wiki Files` project initially failed before command launch with:

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

The sandbox log showed the specific failure:

```text
write ACE failed on C:\Codex\Wiki Files: SetNamedSecurityInfoW failed: 5
deny ACE failed on C:\Codex\Wiki Files\.git: SetNamedSecurityInfoW failed for C:\Codex\Wiki Files\.git: 5
```

Windows error `5` means access denied. ACL inspection showed `C:\Codex\Wiki Files` and `C:\Codex\Wiki Files\.git` were owned by `OfficeAssist\wesbr`, not `OfficeAssist\OfficeAssistLogin`.

Corrective action:

- The owner for `C:\Codex\Wiki Files` and `C:\Codex\Wiki Files\.git` was changed to `OfficeAssist\OfficeAssistLogin`.
- `OfficeAssist\OfficeAssistLogin` was granted full control on the canonical Admin wiki repo folder.
- The ACL command reported `Successfully processed 4561 files; Failed processing 0 files`.
- Follow-up ACL verification confirmed `OfficeAssist\OfficeAssistLogin` owns both `C:\Codex\Wiki Files` and `C:\Codex\Wiki Files\.git` and has full control.

Conclusion: the root cause was repo folder ownership/ACL mismatch after the repo was created or maintained under the prior `OfficeAssist\wesbr` profile. After correcting ownership and ACLs, the corrected `Wiki Files` project passed managed-runner verification.

## GitHub and Git verification status

Status: verified from the corrected OfficeAssist project.

After ACL repair, the corrected `Wiki Files` project completed recovery verification:

- Working folder: `C:\Codex\Wiki Files`
- Computer name: `OFFICEASSIST`
- Windows profile username: `OfficeAssistLogin`
- Managed runner identity: `officeassist\codexsandboxoffline`
- Wiki folder exists: yes
- Git status: `main...origin/main` clean and synchronized
- Latest commit: `5210539b Record OfficeAssist minimum PR chat set verification`
- Requested incorrect skill path `C:\Users\OfficeAssistLogin.codex\skills\codex-environment\SKILL.md`: does not exist
- Canonical skill path `C:\Users\OfficeAssistLogin\.codex\skills\codex-environment\SKILL.md`: exists
- Normal managed command: successful

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

Min PR Set readiness: ready from the corrected `Wiki Files` project.

Reason: the corrected `Wiki Files` project points to `C:\Codex\Wiki Files`, the repo is clean and synchronized on `main`, the canonical installed skill exists, and a normal Codex managed command now runs successfully after the ACL repair.

Remaining caution before any cleanup of old tasks:

- The old `Admin WIKI` project and tasks remain untouched.
- Inventory the full task list under the old `Admin WIKI` project only if Wes wants cleanup planning.
- Do not delete, archive, move, duplicate, replace, or register those tasks without Wes's specific approval.

## Secrets and external changes

- No passwords, tokens, recovery codes, license keys, or MFA codes were recorded.
- No old-project tasks were changed.
- No external systems were changed from this record.
