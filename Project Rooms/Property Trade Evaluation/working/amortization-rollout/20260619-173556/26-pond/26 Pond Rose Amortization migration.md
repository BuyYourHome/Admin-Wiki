# Rose Amortization Migration

- Migration time: 2026-06-19 18:02:31 -04:00
- Source template workbook: C:\Codex\Wiki Files\Project Rooms\Property Trade Evaluation\working\amortization-rollout\20260619-173556\28_Project Management - 320 Rose Pl - SharePoint template.xlsm
- Target project workbook: C:\Codex\Wiki Files\Project Rooms\Property Trade Evaluation\working\amortization-rollout\20260619-173556\26-pond\26_Project Management - 908 Pond St 3 - Amortization swap working.xlsm
- Rollback copy: C:\Codex\Wiki Files\Project Rooms\Property Trade Evaluation\working\amortization-rollout\20260619-173556\26-pond\26_Project Management - 908 Pond St 3 - rollback before amortization swap.xlsm

## Key Values
| Field | Before | After |
| --- | ---: | ---: |
| Selling purchase price | 1051725 | 1,051,725  |
| Down payment | 65625 | 65,625  |
| Loan amount | 986100 | 986,100  |
| Monthly payment 1 | 9112.53 | 9,113  |
| Monthly payment 2 | 2810.15 | 10874.000 |
| Term years | 30 | 30.000 |
| Loan start | 45748 | 4/1/2025 |

## Manual Mapping
- Rose Amortization sheet copied beside old Amortization, then old sheet renamed Amortization - Old.
- Project inputs mapped from old Amortization/Profit/Docs outputs into Rose input cells.
- Docs B7:B21 and B50:B52 retargeted to Rose-layout Amortization outputs.
- Rose template external link broken through Excel before save.

## Unresolved Issues
- Review formula-driven changes where old workbook had text placeholders or external links in Docs payment fields.
- The second monthly payment changed materially from `2810.15` to `10874.000` because the approved Rose layout recalculates the second phase from the migrated loan/rate terms. This should be reviewed if Pond documents depend on the old second-payment value.
