# Rose Amortization Migration

- Migration time: 2026-06-19 17:43:59 -04:00
- Source template workbook: C:\Codex\Wiki Files\Project Rooms\Property Trade Evaluation\working\amortization-rollout\20260619-173556\28_Project Management - 320 Rose Pl - SharePoint template.xlsm
- Target project workbook: C:\Codex\Wiki Files\Project Rooms\Property Trade Evaluation\working\amortization-rollout\20260619-173556\25_Project Management - 612 Britton Ct - Amortization swap working.xlsm
- Rollback copy: C:\Codex\Wiki Files\Project Rooms\Property Trade Evaluation\working\amortization-rollout\20260619-173556\25_Project Management - 612 Britton Ct - rollback before amortization swap.xlsm

## Key Values
| Field | Before | After |
| --- | ---: | ---: |
| Selling purchase price | 487,868  | 487,868  |
| Down payment | 19,900  | 20,000  |
| Loan amount | 467,968.00 | 467,868  |
| Monthly payment 1 |  Cash Flow(60 months); | 2,441  |
| Monthly payment 2 | 1st  Loan Balance(5 years) | 3234.000 |
| Term years | 30 | 30.000 |
| Loan start | April 1, 2025 | 4/1/2025 |

## Manual Mapping
- Rose Amortization sheet copied beside old Amortization, then old sheet renamed Amortization - Old.
- Project inputs mapped from old Amortization/Profit/Docs outputs into Rose input cells.
- Docs B7:B21 and B50:B52 retargeted to Rose-layout Amortization outputs.
- Rose template external link broken through Excel before save.

## Unresolved Issues
- Review formula-driven changes where old workbook had text placeholders or external links in Docs payment fields.
- Pre-existing external workbook link remains: `23_Project Management - 6316 Willowdell Dr 4.xlsm`. It was present in the connector-fetched source before the Amortization migration and was not introduced by the Rose sheet copy.
