# Carrying Mode Rules

Use these rules for Carrying worksheet design, repairs, and approved template migrations. Template to Project owns design and preservation of existing project data during migration; operational entry of new invoices belongs to Invoice Entry.

## Current Prototype and Scope

- Prototype under evaluation: Pond, `Property/26_Project Management - 908 Pond St 3.xlsm`, retrieved fresh through the Teams/SharePoint connector.
- The September 30, 2026 grid-only expense repair, mortgage-payment date repair, and seven remaining category date/payment-block repairs are approved and completed on Pond. The complete Carrying redesign and rollout to other projects are not yet approved.
- Follow [[Project Spreadsheet Expense Placement Rules]] for existing category, escrow, and presentation conventions. Locate current tables and outputs by name and label, not historical coordinates.
- A fix approved during prototype review becomes a required check and repair for later authorized Carrying migrations. Apply the repair method independently to each project; never copy Pond's expense values into another project.

## Reconcile the Grid Before Restoring Formulas

1. Obtain the current Teams workbook, confirm closure before replacement, and preserve a timestamped rollback copy.
2. Inventory the visible category grid, `tblCarryingExpenses`, category totals, and downstream Profit/Docs references. Build a full project-specific map of dates, amounts, formulas, overrides, and source records.
3. Identify fixed values entered over calculated grid cells. Do not restore those formulas until the actual bills and any corrected dates are represented in the table.
4. Check for duplicates using available invoice identifiers and source references, plus category/date/amount. An ambiguous match needs review; equal amounts alone do not prove duplication.
5. Create missing table rows from the project's own actual grid bills, preserving dates, amounts, category, inclusion state, and available provenance. Use existing source/notes columns to record the original grid cells and migration date; do not invent vendor or invoice details.
6. Table rows must reflect the bills replacing the grid entries. Reconcile superseded placeholder records so they are not counted in addition to actual bills. Never infer that a small amount is a placeholder without project-specific evidence or Wes's approval. Preserve legitimate dated zero-dollar schedules.
7. Preserve corrected grid dates when mapping a uniquely matched existing bill. Do not overwrite the correction with a stale table date. Flag ambiguous discrepancies.
8. Restore the grid's table-driven date/amount formulas. Keep each date paired with its amount, sort by date ascending, and use anchored row counters. Read typed Excel dates directly; do not apply `DATEVALUE` to already-numeric dates.
9. Confirm every migrated bill appears exactly once and that the grid has sufficient display capacity. Do not silently hide overflow or discard valid schedule rows to make records fit.
10. Reconcile table amounts, displayed entries, category totals, and corresponding Profit totals. Protect downstream references to positional grid cells when sorting changes which bill occupies a row.

When a date conversion is inside the matched array shared by date and amount display formulas, repair both formulas together. A date-only change can leave the amounts in their old order. Verify every date/amount pair against the table, including equal dates and zero/blank schedule amounts, and require unchanged category and Profit totals for a presentation-only repair. Do not infer that a valid date display establishes the accuracy of the source payment records.

## Validation and Delivery

- For an explicitly approved zero-dollar cleanup, distinguish numeric zero from a blank amount, credit, or formula-driven forecast. Delete only the approved table records, using native table-row deletion rather than whole worksheet rows. Preserve blank amounts unless separately authorized. Compare every surviving record, formula, and format to the original sequence and require unchanged category/Profit totals. A blank source amount may still display as $0.00 in the grid; disclose this rather than claiming all displayed zeros were removed. Pond's September 30 cleanup is not blanket authorization to remove schedules in other projects.

- Preserve formulas outside the approved scope, formatting, widths, heights, merged cells, print settings, tables, defined names, macros, controls, and links.
- Native Excel saves can modify unrelated styles and macro-package metadata. Compare before/after and remove unintended changes before delivery; never assume that a successful save proves preservation.
- Verify saved formula caches as well as formulas. Reopen normally in hidden Excel, verify Automatic calculation, and test a reversible, unsaved table edit to confirm dependent totals respond.
- Recheck the live Teams version immediately before replacement. If it changed, fetch the newer version, reconcile differences, and revalidate instead of overwriting it.
- Upload through the Teams/SharePoint connector and verify the downloaded replacement matches the validated file.
- For missing-date complaints, verify Excel's displayed cell text as well as values, formulas, and formatting; dates must be nonblank and not overflow markers. After upload, identify the verified Teams version and direct reopening from the authoritative Teams link. A later save can restore old formulas even after a successful upload. If the defect recurs, fetch current Teams content and compare the formulas before blaming formatting or identifying a saving session without evidence.
- If repeated file replacements are later overwritten, do not continue uploading the same repair. With Wes's explicit approval, repair the confirmed open workbook through connected Excel tools, preserving a fresh Teams rollback first. Verify the signed-in add-in, exact workbook session, displayed date/amount pairs, and a new connector download after AutoSave. Do not substitute UI cell typing or COM for a missing live capability.
- A timed-out live write has an uncertain outcome. Read the target cells before retrying; the edit may already have applied. Verify the complete authorized range, not only the first cell. Native AutoSave can change package metadata and the VBA binary without a requested macro edit; distinguish cell/formula preservation from binary identity and do not claim unverified macro equivalence.
- AutoSave can publish an intermediate version containing only part of a multi-block edit. Verify every approved formula and saved result in the connector-downloaded version. If the live workbook is correct but Teams has an earlier partial save, wait for the newer version and recheck rather than repeating edits or replacing the whole workbook.
- Check equivalent date/payment blocks together when assessing a shared defect, then obtain approval for the expanded repair scope. Preserve dated zero-dollar schedules and keep categories with no source records blank. A date-display repair does not authorize changing source schedule dates, escrow offsets, or payment assumptions.
- Keep workbook backups and binary validation artifacts in Teams, not Git. Remove superseded temporary workbook copies after verification.
- After every completed repair or migration, record new lessons in this mode file and a project-specific mapping/validation log before treating the iteration as complete.

## Labor Prototype

- Wes authorized a new Labor display section in Pond at `AH:AJ` on September 30, 2026. Use the existing three-column date/payment presentation, with the category label at `AH1`, table-driven dates and amounts at `AH4:AI24`, and the full-category subtotal at `AI25`. The spacer `AK` and source table at `AL:AV` stay in place. Locate by labels and table name during later migrations rather than assuming these coordinates are universal.
- The display reads included `tblCarryingExpenses` rows with `Category = Labor`. No separate Labor source table or placeholder invoice rows are required. Preserve the existing typed-date, chronological-sort and anchored-counter formula pattern, and verify structured references after copying a neighboring block.
- Intended workflow under consultation: laborer invoices enter Review for Wes's destination decision; appropriate vendor tabs are preferred, and approved labor that does not fit them may go to Carrying. Invoice Entry owns record transfer, duplicate checks, provenance and audit status. Template to Project does not perform those operational actions.
- The original iteration added the Carrying display only. Wes subsequently added the Profit Labor row; its subtotal and carrying-cost links were verified read-only on September 30, 2026 (see [[Profit Mode Rules]]). Review's destination dropdown now includes Carrying. End-to-end Invoice Entry posting remains untested, and no rollout was authorized.
- The 21-row display capacity must be checked before later entry/rollout; its subtotal intentionally reads the whole included category, not only displayed rows. A zero subtotal with no source records does not constitute an end-to-end posting test.

## Pond Repair Reference

See [[pond-carrying-repair-20260930]] for the 13 recovered bills, replacement of ten approved Natural Gas placeholders, corrected electric date, downstream Docs change, subsequent mortgage date/amount pairing repair, rollback references, and verified totals. These values are evidence for Pond only, not default values for other projects.

Remaining prototype discussions: property-tax escrow offsets, source schedule assumptions if questioned, and the remaining design extensions. The shared `DATEVALUE` defect is repaired across Pond's current Carrying grid. Do not roll these changes out to other projects without approval.
