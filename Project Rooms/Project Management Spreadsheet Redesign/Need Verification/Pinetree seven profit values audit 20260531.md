# Pinetree Seven Profit Values Audit - 2026-05-31

Workbook audited: Need Verification\17_Project Management - 3413 Pinetree Ln - mode2 labels-safe 20260530_163443.xlsm

Source workbook: sources\17_Project Management - 3413 Pinetree Ln - source.xlsx

## Result

This conversion should not be called correct yet. Structural checks passed, but the seven Profit-total audit found material mismatches.

## Seven Values

| Value | Converted cell/value | Source reference/value | Status |
|---|---:|---:|---|
| Total CMA | Profit!B4 = 287,000 | Source Profit!B4 = 287,000 | Pass |
| Total Purchase Cost | Profit!K47 = 143,030.99 | Source Profit!K27 = 185,424.13125 | Fail |
| Total Rehab Expense | Profit!D67 = -337,382.463555225 | Source Profit!D51 = -5,676.264 / source rehab line B30 = 5,676.264 | Fail |
| Total Debt | Profit!K44 = 143,024 | Source private-lender debt path Profit!B29/E29 = 0 | Needs mapping decision; likely fail under source reconciliation |
| Monthly Carrying Cost | Profit!K41 = 5,477.261666666668 | Source total carrying B27 = 5,341.68; source monthly base is SUM(B21:B26)=890.28 | Fail/ambiguous label mapping |
| Monthly Income | Profit!I55 = 890.3 | Source cash-flow months/profit path differs: H42 = 12, H39 ~= 0.02, I42 ~= 0.24 | Fail/ambiguous label mapping |
| Total Profit | Profit!I58 = -218,927.833555225 | Source gross profit I43/K43/K45 = 104,394.496 | Fail |

## Main Cause Found

The largest failure is the converted Rehab path. Converted Profit!D67 sums D64:E66; Profit!B64 pulls from Gnatt Chart!I6, cached as 306,711.33050475, then Murphy's cut adds another 30,671.133050475. Source rehab summary is driven by source Gnatt Chart!J5 = 5,160.24 plus Murphy's cut 516.024, for a total rehab summary of -5,676.264.

Because Total Rehab Expense is wrong by more than 331,000, downstream Total Profit is not reliable.

## Process Change

The seven Profit totals are now a required validation gate before any future conversion is reported as correct.
