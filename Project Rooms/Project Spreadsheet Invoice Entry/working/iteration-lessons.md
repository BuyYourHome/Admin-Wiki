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
