# Quickbooks Invoice Skill Deployment Status

A canonical skill correction is not deployed merely because it was edited or committed. Keep each stage explicit and do not report `deployed` until every required stage is verified on the execution machine.

| Change | Canonical commit | Published to `origin/main` | Execution machine | Installed tree matches canonical | New-session activation | Overall status |
| --- | --- | --- | --- | --- | --- | --- |
| `QB-001` retained Intuit credential rule | `04113ca3` | Pending recheck after this deployment-control fix is published | `WES-VIDEOEDITOR` | Pending target-machine check | Pending: a newly started Quickbooks Invoice task must read and acknowledge the installed rule | Not deployed |

## Required Evidence

1. Record the canonical commit containing the skill change.
2. Verify that commit is an ancestor of `origin/main`.
3. On the exact execution machine, run `scripts\Test-QuickbooksInvoiceSkillDeployment.ps1` after `tools\sync-codex-skills.ps1` and require `machine_installation_ready: true`.
4. Start a new Quickbooks Invoice task/session after synchronization and record its task id and acknowledgement that it read the installed rule.
5. Only then change the overall status to `Deployed` and close the matching bug.

Do not store credentials, session data, or copied skill bodies in this ledger.
