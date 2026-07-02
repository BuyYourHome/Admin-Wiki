# Rose Amortization Migration

- Migration time: 2026-06-19 18:04:25 -04:00
- Source template workbook: C:\Codex\Wiki Files\Project Rooms\Property Trade Evaluation\working\amortization-rollout\20260619-173556\28_Project Management - 320 Rose Pl - SharePoint template.xlsm
- Target project workbook: C:\Codex\Wiki Files\Project Rooms\Property Trade Evaluation\working\amortization-rollout\20260619-173556\27-outrigger\27_Project Management - 7001 Outrigger Dr - Amortization swap working.xlsm
- Rollback copy: C:\Codex\Wiki Files\Project Rooms\Property Trade Evaluation\working\amortization-rollout\20260619-173556\27-outrigger\27_Project Management - 7001 Outrigger Dr - rollback before amortization swap.xlsm

## Key Values
| Field | Before | After |
| --- | ---: | ---: |
| Selling purchase price | 341940.6 | 341,941  |
| Down payment | 27016.5 | 27,017  |
| Loan amount | 314924.1 | 314,924  |
| Monthly payment 1 | 1595.67 | 1,596  |
| Monthly payment 2 | 1746.44 | 2029.000 |
| Term years | 30 | 30.000 |
| Loan start | 45748 | 4/1/2025 |

## Manual Mapping
- Rose Amortization sheet copied beside old Amortization, then old sheet renamed Amortization - Old.
- Project inputs mapped from old Amortization/Profit/Docs outputs into Rose input cells.
- Docs B7:B21 and B50:B52 retargeted to Rose-layout Amortization outputs.
- Rose template external link broken through Excel before save.

## Unresolved Issues
- Review formula-driven changes where old workbook had text placeholders or external links in Docs payment fields.
- The second monthly payment changed from `1746.44` to `2029.000` because the approved Rose layout recalculates the second phase from the migrated loan/rate terms. This should be reviewed if Outrigger documents depend on the old second-payment value.
