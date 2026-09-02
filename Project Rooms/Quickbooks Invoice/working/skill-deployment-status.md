# Quickbooks Invoice Skill Deployment Status

A canonical skill correction is not deployed merely because it was edited or committed. Keep each stage explicit and do not report `deployed` until every required stage is verified on the execution machine.

| Change | Canonical commit | Published to `origin/main` | Execution machine | Installed tree matches canonical | New-session activation | Overall status |
| --- | --- | --- | --- | --- | --- | --- |
| `QB-001` retained Intuit credential rule | `04113ca3` | Yes | `WES-VIDEOEDITOR` | Yes; tree SHA-256 `1ABABFE3C929ACC8A51E1F5E4CC79DC0EA54205C0789B0AF2156C2D5A5010F06` | Verified in task `01a05967-9a05-7081-a62e-616b2d8e61fd` through new-turn message `prmsg-quickbooks-skill-activation-wve-20260901-001` | Deployed |
| `QB-003` deployment gate and checker | `b8f99453`; Windows PowerShell compatibility `66e46f09` | Yes | `WES-VIDEOEDITOR` | Yes; `machine_installation_ready: true` under Windows PowerShell 5.1 | Verified in the same separate dispatcher-triggered turn; installed retained-account and deployment-gate rules were read and acknowledged | Deployed |

## Required Evidence

1. Record the canonical commit containing the skill change.
2. Verify that commit is an ancestor of `origin/main`.
3. On the exact execution machine, run `scripts\Test-QuickbooksInvoiceSkillDeployment.ps1` after `tools\sync-codex-skills.ps1` and require `machine_installation_ready: true`.
4. Start a new Quickbooks Invoice task/session after synchronization and record its task id and acknowledgement that it read the installed rule.
5. Only then change the overall status to `Deployed` and close the matching bug.

Do not store credentials, session data, or copied skill bodies in this ledger.

## Verification Records

- Installation verification: `prmsg-quickbooks-skill-deployment-wve-20260901-001`, completed `2026-09-02T01:23:23Z` with no QuickBooks or Chrome action.
- New-turn activation verification: `prmsg-quickbooks-skill-activation-wve-20260901-001`, completed `2026-09-02T01:32:55Z` with `machine_installation_ready: true` and `new_turn_activation_verified: true`.
