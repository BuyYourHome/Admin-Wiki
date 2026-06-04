# Current Conversion Rules

## Template Rules

- A clean template must be created and validated before converting active project files.
- A real project workbook can be used as a base only after template-cleaning removes project constants.
- The template provides formulas, formatting, tables, queries, external data ranges, relationships, VBA, and sheet structure.
- Source workbooks provide values and project-specific rows.

## Profit Sheet Rules Learned From Pinetree

- Do not overwrite formula cells with evaluated source values.
- `Profit!B6` should use the Outrigger-style formula:
  `=IF(B1="Flip",B4,IF(C1="hold",B4*(1+C5),+Amortization!O3))`
- `Profit!F15` should use the modern Amortization-aware formula:
  `=IF(OR($R$3=1,$R$3=2,$R$3=3),IF(OR($R$3=1,$R$3=2),-C15,Amortization!AI9),0)`
- Template residue like `Profit!C19 = 25000` must be cleared unless mapped from the source.
- Pinetree seller payout source value maps to the newer target seller payout cell, currently `Profit!C20`; related debit cell should be formula-driven.

## Excel Safety Rules

- If Excel is running, stop and close it before workbook edits.
- If Excel repairs a generated workbook, that workbook is diagnostic only and must not be used as a review copy.
- Prefer Excel-native save/reopen validation for `.xlsm` outputs.

## Mode 2 Pinetree Success Rule Update - 2026-05-30

The first successful Mode 2 output was `Need Verification\17_Project Management - 3413 Pinetree Ln - mode2 from empty template 20260530_155749.xlsm`. Use the Excel-native empty template and Excel COM save/reopen validation for future runs. Do not use prior openpyxl/XML-generated workbooks as bases. Keep old-structure tabs like `MISC 2` out of the core pass until a destination is explicitly chosen.

## Template Health Gate - 2026-05-30

- Before using a workbook as a production template, scan the untouched candidate template for existing #REF! formulas and visible formula errors.
- Compare converted outputs to the untouched template baseline. Do not report inherited template defects as conversion regressions, but do report them as template-health blockers.
- The Pond base used for Pinetree currently contains 5,145 formulas with #REF! in the untouched workbook, concentrated in Gnatt Chart, Others, Lumber, Paint, Smart, and Draws.
- A labels-safe template-cleaning pass must clear only explicit project input cells. Do not clear broad ranges that cross merged label anchors in Profit column A.
- For Pinetree, leave refinance disabled (Profit!Q1=FALSE, Profit!Q2=FALSE) unless a source refinance setup is explicitly mapped.

## Seven Profit Totals Audit Gate - 2026-05-31

Before reporting that a project conversion is correct, audit these seven values on the Profit tab and reconcile them against the source and formula path: Total CMA, Total Purchase Cost, Total Rehab Expense, Total Debt, Monthly Carrying Cost, Monthly Income, and Total Profit. If any fail, report the workbook as not conversion-correct even if structural formula checks pass.

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
