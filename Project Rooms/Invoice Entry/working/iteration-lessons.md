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

Context: Doc Scan now has Lowes Statement Mode and will send extracted statement data for Invoice Entry to consume.

Lessons:

- Keep statement extraction in Doc Scan and statement allocation in Invoice Entry.
- Treat extracted statement lines as source data, not approval for insertion.
- Do not insert Statement Mode lines until the allocation rule for project, worksheet/table, duplicate check, audit trace, and totals validation has been designed, tested, and approved.

## 2026-07-08 - Lowes Statement Allocation Pilot

Context: Processed the Lowes PRO BYH 5997 statement closing 2026-03-17 as the first Statement Mode handoff test for Outrigger.

Lessons:

- For credit-card statement line items, treat the statement amount as the transaction total unless the extracted packet separates pre-tax subtotal and tax. Do not apply the worksheet tax formula again to statement totals.
- Lowes Statement Mode uses project-first routing, then Review-first handling inside the matched project workbook. Do not insert all lines from a multi-project statement into the current project's `Review` table.
- Fill `Review[Destination Worksheet]` only when Invoice Entry has confidence in the destination tab for a line that already belongs to that project. Leave it blank for same-project vendor-tab uncertainty.
- Keep Home/non-project, unclear-project, mixed-tab/project-unclear, PO-conflicted, accounting-only, and other non-matched-project lines outside project workbooks until the project/accounting status is resolved.
- A filled `Destination Worksheet` is a routing recommendation and does not mean the line has already been inserted into the destination vendor table.
- Record the statement PDF path as source evidence for every inserted or review-routed statement line.
- When writing Excel tables through automation, restore from rollback after any failed COM write attempt before retrying; partial unsaved attempts should not be carried forward.
- If a Statement Mode rule changes after an upload, rebuild from the pre-statement rollback and reprocess the packet under the new rule instead of patching already-uploaded Review and vendor-table rows in place.
- For multi-project statements, do not use the currently open project workbook as the holding place for every line. Route by project/workbook first; only lines belonging to that project should enter that project's `Review` table, and non-project or unclear-project lines should stay outside project workbooks until resolved.
- For Lowes statement packets, Doc Scan should preserve visible receipt-item detail. A single statement transaction/ref can become multiple Invoice Entry rows when it contains multiple items, delivery/shipping, or separable credits; do not consume broad transaction-summary rows when item-level rows are needed for later vendor-tab placement.

## 2026-07-08 - Lowes Statement Inclusion Rule Amendment

Context: Wes amended the Lowes Statement Mode rule after reviewing rows 13-25 in the item-level packet. The prior project-first rule was too strict for rows that might belong to Outrigger but had PO, project, destination, mixed-tab, or allocation uncertainty.

Lessons:

- Exclude rows that clearly do not belong to the target project.
- Include rows that certainly belong to the target project.
- Also include rows that may belong to the target project but need review before final destination or allocation is known.
- Exclude sales-tax-only and tax-credit-only rows from Review and vendor tabs during initial statement consumption; tax will be calculated or allocated later by an approved spreadsheet tax method.
- For possible-project rows, leave `Destination Worksheet` blank unless the destination is clear and explain the uncertainty in the review/status fields.
- If a Statement Mode inclusion rule changes after upload, rebuild from the clean pre-statement workbook copy and reprocess the packet rather than patching already-uploaded Review rows in place.

## 2026-07-08 - Review Description Column

Context: Wes identified that the `Review` table needs a dedicated item description because reviewed rows will later be copied into vendor tables.

Lessons:

- Keep `Review[Description]` as a separate clean item-description field after `Invoice #` and before `Amount`.
- Do not rely on the narrative `Review` column as the future vendor-table description source.
- For Statement Mode rows, preserve source traceability in `Review`, but put only the item description itself in `Description`.
- Validate the Review header order before upload: `Invoice #`, `Description`, then `Amount`.

## 2026-07-08 - Lowes Item Description Lookup

Context: Wes asked to use Lowe's item numbers to retrieve better product descriptions for the `Review[Description]` column.

Lessons:

- Strip leading zeroes from Lowe's statement item/SKU values when searching for Lowe's product pages.
- Use Lowe's product-page titles when the item number match is reliable.
- Keep statement-derived text for delivery/shipping, payment/credit components, and rows where no reliable Lowe's product match is found.
- Do not overwrite source traceability in the `Review` column; only improve the clean `Description` field.

## 2026-07-13 - Review Request Checkbox Finalization

Context: The first Outrigger Review request test exposed a mismatch between the intended marker cell and the defined name. The workbook had visible request text in `Review!Q2`, while `invoiceEntryReviewRequest` pointed elsewhere.

Lessons:

- Invoice Entry must read the Review request by the defined name `invoiceEntryReviewRequest`, not by a visible text selector or guessed cell address.
- The finalized request design is a checkbox at `Review!B1` labeled `Needs Invoice Entry Review`, with `invoiceEntryReviewRequest` reopening in Excel as the absolute reference `=Review!$B$1`.
- `TRUE` means process the pending Review request; `FALSE` or blank means no request is pending.
- The prior `Review!Q2` text selector is obsolete and must not be used.
- Before processing Review rows, verify the defined name target through Excel. If it is relative or points anywhere other than `=Review!$B$1`, stop and report the workbook design mismatch.
- Do not clear the request checkbox until eligible rows have been processed, excluded rows have been noted, the workbook has passed validation, and the updated workbook is ready to replace the Teams source.

## 2026-07-13 - Outrigger Review Request Processing

Context: Processed the first finalized Outrigger `tblInvoiceReview` request from the checkbox-trigger design and copied approved Review rows into `tblPlumbingFixturesInvoices`.

Lessons:

- Run Review-request processing in two phases: insert approved rows and save first, reopen and validate totals/links, then clear `invoiceEntryReviewRequest` and validate again before upload.
- If an Excel automation write fails after touching a workbook, restore from the rollback copy before retrying. Do not continue from a partially written workbook copy.
- Do not inspect the raw workbook ZIP/package while Excel still has the file open. Close Excel fully before checking for external-link package parts.
- For current Outrigger Plumbing Fixtures rows, use the table's existing `Group` value pattern `PlumbingFixtures` when filling new actual-invoice rows.
- When copying Lowe's Review rows into vendor tables, preserve clean item descriptions from `Review[Description]`, parse item number and quantity from the Review trace when available, and let the table's `Sub-Total` and `Tax` formulas calculate from quantity and cost/unit.
- A Wes-filled `Destination Worksheet` is approval to move a Review row unless the status is an explicit stop such as `Hold`, `Do Not Move`, `Duplicate Risk`, or `Missing Data`. Do not let stale `Needs Review` wording block a row after Wes has supplied the destination; correct the status to `Moved` during the successful move.
