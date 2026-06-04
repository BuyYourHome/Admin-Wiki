# Mode 2 Pinetree Success Notes

## What Worked

The successful Mode 2 pass used the Excel-native empty template:

`template-reference\Project Management - empty template from Pond Excel-native 20260530_150540.xlsm`

and loaded Pinetree source data from:

`sources\17_Project Management - 3413 Pinetree Ln - source.xlsx`

Output:

`Need Verification\17_Project Management - 3413 Pinetree Ln - mode2 from empty template 20260530_155749.xlsm`

The run was successful because it used Excel automation to save and reopen the workbook, rather than rewriting the macro workbook through openpyxl or raw XML. Excel reopened the output read-only without a repair prompt.

## Confirmed Checks

- `Profit!B2 = 3413 Pinetree Ln`
- `Profit!B4 = 287000`
- `Profit!C19` blank; Pond template seller-note residue did not survive.
- `Profit!D19 = -C19`
- `Profit!C20 = 30000`
- `Profit!D20 = -C20`
- `Profit!B6` retained the Outrigger-style formula.
- `Profit!F15` retained the Amortization-aware formula.
- `Gnatt Chart!I2` retained the structured reference to `qryContractsToGnatt`.
- 16 Contract rows loaded from `ProposalUpdate`.
- Table parts remained present: 17.
- External/query-like parts remained present: 7.
- VBA remained present.

## Why This Worked

- The output was created from an Excel-native empty template, not from a real project workbook with residual Pond values.
- Template constants were cleared before the source load.
- Template formulas were preserved and restored after writes.
- Excel COM was used for final save/reopen validation, which preserved table/query metadata and caught repair issues.
- Source-to-target assignments for estimate tabs were precomputed outside Excel, then applied through Excel. This avoided slow cell-by-cell inspection through COM.

## Important Implementation Lessons

- Stop if Excel is open. Do not proceed with workbook edits until it is closed.
- Do not use openpyxl to save `.xlsm` table-driven outputs. It can cause Excel repair that removes external data ranges and table records.
- Do not rewrite full worksheet XML for these workbooks unless absolutely necessary. It can strip Excel extension metadata even when package part counts match.
- Use Excel-native save and reopen validation for every final workbook.
- Write to merged cells through their merge anchor or avoid blank writes to merged cells.
- Assign text through `.Formula` when `.Value`/`.Value2` rejects the value in merged/formatted cells.
- Assign booleans as `TRUE`/`FALSE` formulas when direct boolean writes fail.
- Cast JSON numeric values to doubles before writing through COM.
- Avoid copying old-structure tabs, such as `MISC 2`, into the new table-driven workbook unless there is an explicit destination decision.

## Known Limitations In Current Output

- `MISC 2` was not loaded. It needs a destination decision.
- Carrying remains a review area because the Pinetree source does not have a dated Carrying tab.
- Only 16 Contract rows were loaded from `ProposalUpdate`; row completeness and assignment mapping need user review.
- Estimate-tab mapping copied constants into same-named tabs where safe, but this needs review for category placement and formulas.

## Next Rerun Checklist With Wes Observations

1. Confirm Excel is closed.
2. Start from the Excel-native empty template, not from earlier converted outputs.
3. Apply Wes observations to the mapping rules before running.
4. Load Pinetree source into the template with Excel-native save/reopen validation.
5. Check repair prompt status immediately.
6. Verify the specific cells/tabs Wes identified.
7. Update this note and `current-conversion-rules.md` with any new rules learned.

## Candidate Improvements For Next Run

- Add an explicit `MISC 2` mapping decision.
- Add a richer Contract-row reconciliation report.
- Add a source-to-target Profit mapping table to the summary.
- Add a tab-by-tab count of copied source constants.
- Add a Carrying decision note directly inside the output workbook or summary.

## 2026-05-30 Labels-Safe Mode 1 And Mode 2 Rerun

Reran Mode 1 and Mode 2 from Pond using explicit Profit input clearing instead of broad merged ranges. This preserved Profit column A labels and disabled unmapped refinance assumptions for Pinetree, which cleared the Profit!H22 to Profit!H54 #NUM! path.

Outputs:
- Template: 	emplate-reference\Project Management - empty template from Pond Excel-native labels-safe 20260530_163443.xlsm
- Converted workbook: Need Verification\17_Project Management - 3413 Pinetree Ln - mode2 labels-safe 20260530_163443.xlsm

Independent verification found MissingProfitLabelsFromPondA1A68=0, Profit!H54=, Profit!B6, Profit!F15, Profit!D20, and Gnatt Chart!I2 correct. It also found that Pond, the empty labels-safe template, and the converted Pinetree workbook all contain the same 5,145 formulas with #REF! already present in the base template. Treat these as a template-health blocker for production conversion, not a Pinetree conversion regression.
