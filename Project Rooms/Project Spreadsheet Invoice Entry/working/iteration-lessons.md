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
