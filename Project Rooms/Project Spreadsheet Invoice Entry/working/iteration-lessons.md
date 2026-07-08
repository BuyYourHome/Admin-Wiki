# Iteration Lessons

Use this file to record, refine, or expand lessons learned after each workbook or workflow iteration. Each entry should state what changed or failed, the practical lesson, and how the next iteration should be constrained or validated.

## 2026-07-08 - Outrigger Table Layout Rollout Attempt

Context: Attempted to apply the `Appliances` label/total placement, repair the `Appliances` toggle, standardize table columns, and match table formatting across upgraded Outrigger vendor tabs.

Result: The broad table/style pass was not uploaded. The workbook was restored from rollback after validation showed Excel had changed table headers such as `Item #`, `Qty`, and `Cost/Unit` into generic names like `Column1`, `Column2`, and `Column3`.

Lessons:

- Do not combine table structure changes, style changes, formula relocation, checkbox repair, and Gantt relinking in one workbook pass.
- Do not rely on broad format-paste or table-wide copy/paste operations across Excel tables; they can corrupt table headers or table metadata.
- Break future workbook design iterations into one narrow change at a time, then reopen and validate before continuing.
- Treat table header names as a first-class validation item after every table edit.
- If Excel COM disconnects, assume the workbook may not have saved all intended changes; release orphan Excel processes, reopen the workbook, and verify before uploading.
- If validation fails, restore the rollback copy and do not upload.

Next safer sequence:

1. Repair only `Demo & Trash Haul` totals without changing table structure.
2. Validate totals, Gantt link, table headers, workbook links, and reopen behavior.
3. Upload only if validation passes.
4. In a later separate pass, standardize one table's columns at a time, starting with a copy or non-live test workbook.

## 2026-07-08 - Outrigger Appliances-Pattern Retry

Context: Wes fixed the `Appliances` tab and asked to retry correcting the other upgraded tables using `Appliances` as the layout standard.

Result: Uploaded a safe nonstructural pass. The pass repaired `Demo & Trash Haul` totals, moved other tabs' template/grand/invoice totals to the `Appliances`-style right-side placement, updated affected `Gnatt Chart` links, and applied the table style without changing table widths. Validation passed with no external workbook links or table-header corruption.

Lessons:

- Preserve Wes's manually fixed tab as the source of truth; do not overwrite it while using it as the pattern.
- Split totals/layout work from table-width or column-order work. Totals and Gantt relinking can be safely updated without resizing tables.
- `Demo & Trash Haul` can be repaired safely if its existing 7-column table structure is left intact.
- If `Demo & Trash Haul` is widened to standard invoice columns, totals must move away from the immediately adjacent column; otherwise Excel may auto-expand the table into the total cells.
- Standardizing `Cabinets` columns can change totals if tax formulas are filled into rows that previously had intentionally blank tax cells. Preserve existing tax behavior unless Wes explicitly approves recalculating tax.

Next safer sequence:

1. Standardize only `Demo & Trash Haul` on a non-live copy, with totals placed at least one blank column away from the widened table.
2. Validate that the final table has exactly these headers: `Group`, `Date`, `Vendor`, `Description`, `Sq Ft`, `Item #`, `Qty`, `Cost/Unit`, `Sub-Total`, `Tax`.
3. Preserve the current grand total of `6561.72` and the `Gnatt Chart` row 8 link.
4. Standardize `Cabinets` separately and preserve its current actual total of `5563` unless Wes explicitly changes the tax rule.

## 2026-07-08 - Outrigger Column-Based Invoice Totals

Context: Wes identified that several upgraded tabs were still not summing invoice totals by table column. The affected tabs were `Plumbing Fixtures`, `Windows & Doors`, `Cabinets`, `Paint`, `Flooring`, `HVAC`, `Electrical Fixtures`, and `Landscape`.

Result: Uploaded a focused formula-only fix. Each affected `Invoice Total` formula now sums its table's `Sub-Total` and `Tax` columns by table name, while preserving the existing checkbox condition and grand-total cells. Validation passed: each affected grand total matched the linked `Gnatt Chart` value, table headers stayed intact, and no external workbook links were present.

Lessons:

- For invoice table totals, prefer structured table formulas such as `SUM(tblName[Sub-Total])+SUM(tblName[Tax])` over fixed cell ranges.
- A formula-only pass is safe when it does not resize tables, paste formatting, or alter table headers.
- Validate both the invoice total formula text and the downstream grand-total/Gnatt values after the formula change.
- Do not assume stored total cell locations from prior iterations; inspect the current workbook because Wes may have moved labels and totals manually.

## 2026-07-08 - Outrigger HVAC Tax Formula Repair

Context: Wes identified that `HVAC` was not calculating taxes.

Result: Uploaded a focused HVAC-only formula fix. The `tblHVACInvoices[Tax]` column now uses `=IFERROR([@[Sub-Total]]*0.0725,0)`. The existing HVAC invoice total already summed `tblHVACInvoices[Sub-Total]` and `tblHVACInvoices[Tax]`, so the invoice total, grand total, and `Gnatt Chart` row 19 recalculated after the tax column was repaired.

Lessons:

- When a tab total appears wrong, inspect the table's component columns first; the total formula may already be correct while an input formula column is blank.
- Keep narrow formula repairs limited to the affected table column when the total chain is already structurally correct.
- Validate the changed column formula, invoice total, grand total, and Gantt-linked value after recalculation.

## 2026-07-08 - Statement Mode Handoff Boundary

Context: Document Scan now has Lowes Statement Mode and will send extracted statement data for Project Spreadsheet Invoice Entry to consume.

Lessons:

- Keep statement extraction in Document Scan and statement allocation in Project Spreadsheet Invoice Entry.
- Treat extracted statement lines as source data, not approval for insertion.
- Do not insert Statement Mode lines until the allocation rule for project, worksheet/table, duplicate check, audit trace, and totals validation has been designed, tested, and approved.

## 2026-07-08 - Lowes Statement Allocation Pilot

Context: Processed the Lowes PRO BYH 5997 statement closing 2026-03-17 as the first Statement Mode handoff test for Outrigger.

Lessons:

- For credit-card statement line items, treat the statement amount as the transaction total unless the extracted packet separates pre-tax subtotal and tax. Do not apply the worksheet tax formula again to statement totals.
- Lowes Statement Mode now uses a Review-first rule: insert every extracted Lowes statement line into `Review` before any vendor-tab copy.
- Fill `Review[Destination Worksheet]` only when Invoice Entry has confidence in the destination tab. Leave it blank for Home/non-project, mixed-tab, PO-conflict, accounting-only, and other uncertain lines.
- A filled `Destination Worksheet` is a routing recommendation and does not mean the line has already been inserted into the destination vendor table.
- Record the statement PDF path as source evidence for every inserted or review-routed statement line.
- When writing Excel tables through automation, restore from rollback after any failed COM write attempt before retrying; partial unsaved attempts should not be carried forward.
