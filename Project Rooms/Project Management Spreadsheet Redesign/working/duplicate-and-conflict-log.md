# Duplicate And Conflict Log

No conflicts reviewed yet.

Expected risk areas:

- Pinetree may have old workbook structure that does not match Pond's tabs, categories, or formulas.
- Carrying source rows may include totals, projected rows, or formula-generated rows that must be classified carefully.
- Expense tabs may have different names or combined categories.
- Profit formulas may need row and source-cell mapping after the new structure is applied.

## 2026-05-30 Conversion Notes

- Pinetree has no dedicated Carrying source tab. Do not fabricate dated Carrying rows; preserve source monthly carrying values in Profit and add an excluded Carrying review marker row unless Wes provides a dated ledger.
- Pinetree MISC 2 has no exact Pond destination. Copied to MISC 2 Review for review instead of forcing rows into Smart/Lumber/Furnishing.
- Pond template formula-error scan already contains Gantt/query #REF formulas; compare converted output against the untouched template before treating these as conversion regressions.


## 2026-05-30 Reconversion Notes

- Redid the Pinetree conversion from a fresh Pond template copy after Profit-sheet review observations.
- Restored `Profit!F15` to the modern Amortization-aware formula: `=IF(OR($R$3=1,$R$3=2,$R$3=3),IF(OR($R$3=1,$R$3=2),-C15,Amortization!AI9),0)`.
- Preserved `Profit!B5`, `Profit!B6`, and `Profit!B7` as Amortization-linked formulas and seeded `Amortization!M4` with Pinetree's 10% assumption.
- Reviewed available current Pond/Tensity/Cool Springs/Britton/Outrigger references and did not find a known-good `Profit!B4` formula; all available references treat `B4` as the CMA input while Amortization derives related values from it.

## 2026-05-30 Formula-Safe Reconversion Rule

Root cause: the earlier conversion mixed source evaluated values with the Pond target structure on the Profit sheet. Some target formula cells were overwritten with source-calculated values, so formulas were preserved inconsistently. One-off fixes, like restoring `F15`, were not enough because no final Profit formula-preservation audit was run.

Rule going forward: migrate source values only into true input cells. After all source inputs are placed, restore the target/current Profit formula map and then audit formula drift. Use the newer Outrigger formula for `Profit!B6` and the modern Amortization-aware formula for `Profit!F15` where the Pond template is stale or incomplete.

## 2026-05-30 Strict Profit Input Rule

The strict reconversion cleared template constants in mapped Profit input areas unless explicitly mapped from Pinetree. This fixed the seller-note residue problem: `Profit!C19` is blank, `Profit!D19` is formula-driven as `=-C19`, Pinetree seller payout maps to `Profit!C20`, and `Profit!D20` is formula-driven as `=-C20`.

Use two audits after future conversions: formula drift audit and template-residue audit for target input cells.

## 2026-05-30 Package-Safe Table Preservation Pass

Excel repair logs showed removed external data ranges and table records after workbook-library saves. Next table-driven conversions should not save the macro workbook through openpyxl. Use a package-preserving approach: copy the `.xlsm` package and patch only targeted worksheet XML, leaving `xl/tables/*`, query/external data range parts, relationships, and `vbaProject.bin` untouched.

Package-safe Pinetree diagnostic output preserved 255 package parts, 17 table parts, 7 external/query-like parts, and `xl/vbaProject.bin`. `Gnatt Chart!I2` remained `=SUMIF(qryContractsToGnatt[Assigned],$D2,qryContractsToGnatt[Price])` in the raw package.

## 2026-05-30 Empty Template From Pond

Created `template-reference\Project Management - empty template from Pond 20260530_145858.xlsm` as a first clean-template candidate. It was made package-safely from the Pond workbook: formulas, formatting, table/query/external-data relationships, and VBA were preserved; project-specific constants were cleared from known input/data/table body areas.

Validation: package part count 255, table parts 17, external/query-like parts 7, VBA present. Key formulas retained: `Profit!B6`, `Profit!F15`, `Profit!D19`, `Profit!D20`, and `Gnatt Chart!I2`.

Review this template once in Excel before making it the production base for future conversions.

## 2026-05-30 Excel-Native Empty Template

The package-XML cleaned template still triggered Excel repair, likely because full worksheet XML reserialization removed Excel extension metadata. Created a new Excel-native empty template instead by opening the Pond copy in Excel, clearing constants in known project-data ranges, saving through Excel, and reopening read-only for validation.

Output: `template-reference\Project Management - empty template from Pond Excel-native 20260530_150540.xlsm`. Validation checks retained `Profit!B6`, `Profit!F15`, `Profit!D19`, `Profit!D20`, and `Gnatt Chart!I2`; `Profit!B2`, `Profit!B4`, and `Profit!C19` are blank.

## 2026-05-30 Mode 2 Pinetree Load From Empty Template

Created `Need Verification\17_Project Management - 3413 Pinetree Ln - mode2 from empty template 20260530_155749.xlsm` by loading the Pinetree source into the Excel-native empty template. Excel saved and reopened the output read-only for validation without a repair prompt.

Key checks: `Profit!B2=3413 Pinetree Ln`, `Profit!B4=287000`, `Profit!C19` blank, `Profit!D19=-C19`, `Profit!C20=30000`, `Profit!D20=-C20`, `Profit!B6` and `Profit!F15` formulas retained, `Gnatt Chart!I2` structured reference retained, 16 Contract rows loaded. `MISC 2` was not loaded in this core pass because it needs an explicit destination decision.

## 2026-05-30 Mode 2 Working Baseline

Documented the successful Mode 2 Pinetree load in `working\project-ss-conversion-process\mode2-pinetree-success-notes.md`. Treat `Need Verification\17_Project Management - 3413 Pinetree Ln - mode2 from empty template 20260530_155749.xlsm` as the current working baseline for review observations.

## 2026-05-30 Labels-Safe Mode 1 And Mode 2 Rerun

Reran Mode 1 and Mode 2 from Pond using explicit Profit input clearing instead of broad merged ranges. This preserved Profit column A labels and disabled unmapped refinance assumptions for Pinetree, which cleared the Profit!H22 to Profit!H54 #NUM! path.

Outputs:
- Template: 	emplate-reference\Project Management - empty template from Pond Excel-native labels-safe 20260530_163443.xlsm
- Converted workbook: Need Verification\17_Project Management - 3413 Pinetree Ln - mode2 labels-safe 20260530_163443.xlsm

Independent verification found MissingProfitLabelsFromPondA1A68=0, Profit!H54=, Profit!B6, Profit!F15, Profit!D20, and Gnatt Chart!I2 correct. It also found that Pond, the empty labels-safe template, and the converted Pinetree workbook all contain the same 5,145 formulas with #REF! already present in the base template. Treat these as a template-health blocker for production conversion, not a Pinetree conversion regression.

## 2026-05-31 Contract-To-Gantt Refresh Finding

Wes pointed out that the modern workbook tables are hierarchical: after replacing Contract table values, dependent query/table data must be refreshed before Gnatt Chart reflects the contract rows. Confirmed. The retry workbook still had stale Gnatt Chart!I6 = 306,711.33050475 after contract rows were replaced, even though Profit rehab was source-mapped.

Automation finding: broad RefreshAll and a targeted Contract-to-Gantt connection refresh chain both hung Excel during automated runs. Treat Gantt refresh as an unresolved automation blocker. Do not report a conversion as correct until either (1) the query refresh can be completed and verified, or (2) the source-to-target mapping intentionally bypasses Gantt for the affected Profit totals and the bypass is documented as review-only, not production-correct.

Improved retry results before blocker: Purchase Cost, Rehab Expense, Monthly Carrying Cost, and Monthly Income were materially improved by skipping old vendor-tab copy, source-mapping old rehab summary, and feeding the modern Carrying sheet from source monthly carrying. Total Profit still did not reconcile cleanly, and Gantt remained stale.

## 2026-05-31 Current Review Retry With Closing Costs

Created fixed overwrite review workbook: Need Verification\17_Project Management - 3413 Pinetree Ln - current conversion review.xlsm.

Rules applied:
- Use a single current review workbook instead of timestamping every retry.
- Preserve Profit!B64 as ='Gnatt Chart'!I6; do not hardcode source rehab into B64.
- Map source buying closing costs Profit!B53:B70 to target Profit!B69:B86.
- Map source selling closing costs Profit!B74:B81 to target Profit!B90:B97.
- Feed source monthly carrying total into the modern Carrying sheet because the old source lacks a modern Carrying tab.
- Skip old vendor-tab copy because old and modern vendor columns do not align.

Audit result: buying closing costs now equal 5998; selling closing costs now equal 290; Profit!B64 correctly points to Gantt. Seven-total gate still fails because Gnatt Chart!I6 remains stale at 306711.33050475, driving Rehab Expense and Total Profit wrong. Gantt refresh/prototype remains the next blocker.
