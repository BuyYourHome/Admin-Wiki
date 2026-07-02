# Rose Amortization Migration

- Migration time: 2026-06-19 17:56:48 -04:00
- Source template workbook: C:\Codex\Wiki Files\Project Rooms\Property Trade Evaluation\working\amortization-rollout\20260619-173556\28_Project Management - 320 Rose Pl - SharePoint template.xlsm
- Target project workbook: C:\Codex\Wiki Files\Project Rooms\Property Trade Evaluation\working\amortization-rollout\20260619-173556\23-cool-springs\23_Project Management - 2325 Cool Springs Rd 4 - Amortization swap working.xlsm
- Rollback copy: C:\Codex\Wiki Files\Project Rooms\Property Trade Evaluation\working\amortization-rollout\20260619-173556\23-cool-springs\23_Project Management - 2325 Cool Springs Rd 4 - rollback before amortization swap.xlsm

## Key Values
| Field | Before | After |
| --- | ---: | ---: |
| Selling purchase price | 295948.8 | 295,949  |
| Down payment | 20000 | 20,000  |
| Loan amount | 275948.8 | 275,949  |
| Monthly payment 1 | 1216.14 | 1,216  |
| Monthly payment 2 | 1746.44 | 1,745  |
| Term years | 30 | 30.00 |
| Loan start | 45748 | 4/1/2025 |

## Manual Mapping
- Rose Amortization sheet copied beside old Amortization, then old sheet renamed Amortization - Old.
- Project inputs mapped from old Amortization/Profit/Docs outputs into Rose input cells.
- Docs B7:B21 and B50:B52 retargeted to Rose-layout Amortization outputs.
- Rose template external link broken through Excel before save.

## Unresolved Issues
- Review formula-driven changes where old workbook had text placeholders or external links in Docs payment fields.
