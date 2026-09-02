# Quickbooks Skill Deployment Status

A canonical skill correction is not deployed merely because it was edited or committed. Keep each stage explicit and do not report `deployed` until every required stage is verified on the execution machine.

| Change | Canonical commit | Published to `origin/main` | Execution machine | Installed tree matches canonical | New-session activation | Overall status |
| --- | --- | --- | --- | --- | --- | --- |
| `QB-001` retained Intuit credential rule | `04113ca3` | Yes | `WES-VIDEOEDITOR` | Yes; tree SHA-256 `1ABABFE3C929ACC8A51E1F5E4CC79DC0EA54205C0789B0AF2156C2D5A5010F06` | Verified in task `01a05967-9a05-7081-a62e-616b2d8e61fd` through new-turn message `prmsg-quickbooks-skill-activation-wve-20260901-001` | Deployed |
| `QB-003` deployment gate and checker | `b8f99453`; Windows PowerShell compatibility `66e46f09` | Yes | `WES-VIDEOEDITOR` | Yes; `machine_installation_ready: true` under Windows PowerShell 5.1 | Verified in the same separate dispatcher-triggered turn; installed retained-account and deployment-gate rules were read and acknowledged | Deployed |
| `QB-004` rename to Quickbooks with `Invoice` mode | `69050252`; correction basis `de015d80`; final readiness publication recorded by `prmsg-quickbooks-readiness-finalization-20260902-001` | Yes | `WES-VIDEOEDITOR` | Linked correction verified matching canonical and installed tree SHA-256 `357291A76940CBFD1386F234B4E79C841B4941EFF752EC17C9FEF1D7DEC2773A`; final metadata tree is synchronized and rechecked during the finalization record | Verified in the dispatcher-triggered linked correction with exact task, title, Project Room, skill, and `Invoice` mode | Deployed |

## Required Evidence

1. Record the canonical commit containing the skill change.
2. Verify that commit is an ancestor of `origin/main`.
3. On the exact execution machine, run `scripts\Test-QuickbooksSkillDeployment.ps1` after `tools\sync-codex-skills.ps1` and require `machine_installation_ready: true`.
4. Start a new Quickbooks task/session after synchronization and record its task id and acknowledgement that it read the installed rule.
5. Only then change the overall status to `Deployed` and close the matching change.

Do not store credentials, session data, or copied skill bodies in this ledger.

## Verification Records

- Installation verification: `prmsg-quickbooks-skill-deployment-wve-20260901-001`, completed `2026-09-02T01:23:23Z` with no QuickBooks or Chrome action.
- New-turn activation verification: `prmsg-quickbooks-skill-activation-wve-20260901-001`, completed `2026-09-02T01:32:55Z` with `machine_installation_ready: true` and `new_turn_activation_verified: true`.
- Renamed-skill installation verification: `prmsg-quickbooks-identity-rename-wve-20260902-001`, completed `2026-09-02T02:09:34.4351815Z` with task title and registration `Quickbooks`, installed-tree match, old-copy removal, and no QuickBooks or Chrome action.
- Renamed-identity parent validation: `prmsg-quickbooks-renamed-identity-validation-20260902-001`, blocked `2026-09-02T02:52:02.2810392Z` after two notification attempts and a canonical/installed tree mismatch; identity and `Invoice` mode checks passed and no QuickBooks or Chrome action occurred.
- Linked correction: `prmsg-quickbooks-renamed-identity-validation-20260902-correction-001`, completed `2026-09-02T09:40:19.2516703Z` after exactly one delivered notification with canonical/installed tree SHA-256 `357291A76940CBFD1386F234B4E79C841B4941EFF752EC17C9FEF1D7DEC2773A`, `machine_installation_ready: true`, `new_turn_activation_verified: true`, `manual_intervention: false`, and no QuickBooks or Chrome action.
- Readiness finalization: `prmsg-quickbooks-readiness-finalization-20260902-001` owns the final manifest, publication, installed-skill synchronization, and post-publication deployment check.
