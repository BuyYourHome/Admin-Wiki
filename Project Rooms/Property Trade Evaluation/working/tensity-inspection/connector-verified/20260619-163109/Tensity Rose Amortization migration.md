# Tensity Rose Amortization Migration

- Migration time: 2026-06-19 16:59:22 -04:00
- Source template workbook: C:\Codex\Wiki Files\Project Rooms\Property Trade Evaluation\working\tensity-inspection\connector-verified\20260619-163109\28_Project Management - 320 Rose Pl - SharePoint template.xlsm
- Source template SharePoint URL: https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7BD39E03A5-035A-4BBF-9346-ADD40A7758EE%7D&file=28_Project+Management+-+320+Rose+Pl.xlsm&action=default&mobileredirect=true&web=1
- Target project workbook: C:\Codex\Wiki Files\Project Rooms\Property Trade Evaluation\working\tensity-inspection\connector-verified\20260619-163109\24_Project Management - 4121 Tensity Dr 2 - Amortization swap working.xlsm
- Target project SharePoint URL: https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7BFB8825B0-06EF-4B3E-8015-A106EEEA5C7C%7D&file=24_Project+Management+-+4121+Tensity+Dr+2.xlsm&action=default&mobileredirect=true&web=1
- Rollback copy: C:\Codex\Wiki Files\Project Rooms\Property Trade Evaluation\working\tensity-inspection\connector-verified\20260619-163109\24_Project Management - 4121 Tensity Dr 2 - rollback before amortization swap.xlsm

## Key Values

| Field | Before | After |
| --- | ---: | ---: |
| docs_b7_purchase_price | 331,193  | 331,193  |
| docs_b8_earnest_money | 0  | 0  |
| docs_b9_down_payment | 28,964  | 29,064  |
| docs_b10_loan_amount | 323,403.81 | 261,576.00 |
| docs_b11_monthly_payment_reduced_total | $1,533.81  | $1,534.00  |
| docs_b12_monthly_payment_reduced_pi | 1533.810 | 1534.000 |
| docs_b13_monthly_payment_full_pi | 1630.040 | 1630.000 |
| docs_b14_monthly_payment_full_total | $1,630.04  | $1,630.00  |
| docs_b15_term_years | 30.00 | 30.00 |
| docs_b18_loan_start | April 1, 2025 | April 1, 2025 |
| docs_b19_loan_end_first | March 1, 2030 | March 1, 2055 |
| docs_b20_loan_start_second | April 1, 2030 | April 1, 2025 |
| docs_b21_loan_end_final | March 1, 2055 | March 1, 2055 |
| docs_b50_base_rate | 3.750% | 3.750% |
| docs_b51_reduced_rate | 3.750% | 3.750% |
| docs_b52_full_rate | 6.250% | 6.250% |

## Manual Mapping
- Amortization!K2 from old Docs!B8 earnest money.
- Amortization!K3 from old Amortization!O2 down-payment percentage.
- Amortization!P2:R2 from old Amortization!M4 above-ARV setting.
- Amortization!P6:R6 from old Amortization!P1:R1 point settings.
- Amortization!O9 from old Amortization!O7 term years.
- Amortization!O11 from Docs!B18 loan start date.
- Amortization!T9:T10 from old insurance/tax escrow cells T8:T9.
- Amortization!AA9:AC10 from old reduced/full payment scenario table AA8:AC9.
- Amortization!X5 adjusted so Docs selling purchase price remains tied to the project sale value.
- Docs B7:B21/B49:B52 and Profit B5/B7/I9/G13/F15 retargeted to the new Rose-layout Amortization sheet.

## Unresolved Issues
- The old Tensity `Docs!B10` loan amount was hardcoded at 323,403.81. The approved Rose layout computes `Docs!B10` from `Amortization!O5`, so the migrated value is 261,576.00.
- The old Tensity `Docs!B19:B20` split the loan into a first end date and second start date. The approved Rose layout points both loan-start fields to `Amortization!O11` and final end-date formulas, so those date outputs follow the Rose layout after migration.
