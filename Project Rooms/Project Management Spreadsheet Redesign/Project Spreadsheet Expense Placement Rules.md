# Project Spreadsheet Expense Placement Rules

Authoritative copy for the Project Management Spreadsheet Rewrite project room. Use this file as the source of truth for carrying-expense conversion rules and as the template reference for future project-room conversions.

Use this file to decide where project-related invoice expenses should be inserted in a project management workbook.

These rules apply after an invoice has been identified, classified, and matched to a project/property.

## General Rule

Do not guess the destination inside a project workbook.

If the invoice type clearly maps to a specific project expense area, insert it there. If the invoice type does not clearly map to a known area, route the workbook update for review and document the unresolved placement in the scan log.

## Required Inputs

Before inserting an invoice expense into a project workbook, identify:

- Project/property
- Vendor
- Invoice date
- Invoice number, if present
- Amount due
- Invoice category or work type
- Source invoice file
- Destination project workbook
- Destination worksheet/table/section, if known

## Safe Working Folder

Use this project-room folder as the staging area for invoice-to-project-spreadsheet updates:

`C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Rewrite\working\invoice-project-updates`

## Target Confirmation Rule

Before starting any project spreadsheet action, confirm the exact target workbook with Wes in the thread. This includes connector searches, local synced-file inspection, workbook opening, read-only inspection, backups, edits, migrations, uploads, and validation runs.

The confirmation must name the workbook and project plainly, such as `24_Project Management - 4121 Tensity Dr 2.xlsm` for Tensity. If the target has not already been confirmed in the current turn, pause and wait for Wes to confirm before taking the action. Do not substitute a template workbook, prior source workbook, or another project workbook merely because it is related to the design discussion.

Use the SharePoint/Teams connector as the authoritative discovery, freshness-check, and write-back path for active project workbooks. Locate or verify the workbook through the connector before relying on any local Teams-synced file. Copy the connector-verified workbook into this folder before editing it. After the edited copy is verified, write it back through the connector to the same Teams/SharePoint item unless Wes explicitly asks for a project-room-only review copy.

Project management spreadsheets are stored directly under the SharePoint/Teams `Property` drive root, such as `Property/24_Project Management - 4121 Tensity Dr 2.xlsm`. They are never stored inside the individual property folders. Do not look in property subfolders such as `Property/24-HM-4121 Tensity Dr/Owning`, `Buying`, or `Renting` for the project spreadsheet; use those folders only for supporting property documents.

Local Teams-synced paths, including `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\...`, are working conveniences only. Do not treat them as proof that a workbook is current. If the connector is unavailable, cannot identify the exact workbook item, or cannot safely write back the finished workbook, stop and report the blocker instead of silently using the synced folder.

## Spreadsheet Color Conventions

Use Wes's color conventions when designing or revising project spreadsheet inputs and protected formulas:

- Yellow cells indicate values that need user input or user review.
- Orange cells indicate formulas, controls, or calculated values that should not be changed during ordinary use.
- Preserve existing yellow/orange meaning when copying layouts, converting ranges to tables, or migrating a design across project workbooks.
- If a cell's role changes, update its fill color to match the new role instead of leaving stale color cues.

## Known Placement Rules

| Invoice Type / Work Type | Project Workbook Placement | Notes |
| --- | --- | --- |
| Yard maintenance / lawn mowing / landscaping maintenance | `Carrying` worksheet, `tblCarryingExpenses`, category `Lawn` | The visible Carrying grid should show only the date and amount for Lawn entries. Vendor and invoice detail belong in the right-side table only. |

## Carrying Expense Prototype

The 908 Pond St test workbook in the project-room `sources` folder now demonstrates a normalized carrying expense source table:

`C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Rewrite\sources\26_Project Management - 908 Pond St 3- Test.xlsm`

Current preferred expense-tab interface:

- Keep the existing friendly expense section as the readable/user-friendly view.
- Place the structured expense table to the right of the friendly section on the same worksheet so the table can use useful column widths without disrupting the friendly grid.
- Do not create a separate log sheet unless a specific need appears.
- The structured table should support manual entries and scanned invoice entries.
- The friendly section may read from the structured table when that gives the best scan-entry workflow.
- The subtotal cells used by `Profit` should remain in place as stable output cells where possible. When adding new Carrying categories, expand the matching `Profit` Carrying rows to include them.

For the `Carrying` prototype:

- Worksheet: `Carrying`
- Right-side structured table: `tblCarryingExpenses`
- Table starts to the right of the multi-category friendly carrying-cost grid.
- Keep a spacer column between the friendly grid and the table.
- In the current Carrying conversion pattern, the table starts at `AI2`, leaving `AH` as spacer.
- Keep the table formatting restrained so it does not visually compete with the friendly grid.
- Manual-entry convenience: sorting the table by `Include` to bring `No` rows to the top is allowed and expected.
- The right-side table is the current prototype source for the friendly grid and totals.
- A `Lawn` carrying category was added to the friendly grid for the Greenview Works invoice test.
- The scan-process test inserts a new row into `tblCarryingExpenses`; it does not rely on pre-existing blank rows.
- Preserve Wes's current friendly-grid formatting when using the Pond workbook as the conversion pattern for other projects.
- The friendly Carrying grid is a readable summary, not the detailed entry log.
- Each visible Carrying category block should show only the two user-facing values needed for the friendly view: date and amount.
- Do not place vendor names, invoice numbers, source file names, status text, or notes in the visible Carrying grid.
- Vendor and other invoice details belong in `tblCarryingExpenses`.
- Date and amount display formulas in the friendly Carrying grid must reference `tblCarryingExpenses` directly. Do not leave formulas pointing to temporary helper ranges or deleted ranges.
- Date and amount display formulas in the friendly Carrying grid should sort matching rows by `tblCarryingExpenses[Date]` ascending before displaying them.
- Date and amount display formulas must use an anchored row counter, such as `ROWS(A$4:A5)`, so each visible row returns the next matching table entry. Do not use same-row-only counters such as `ROWS(A5:A5)`, because that repeats the first matching table row down the whole grid.
- The right-side table may be sorted for manual entry convenience; the friendly grid should not depend on the table's current sort order.
- Before saving a conversion, scan the friendly Carrying grid formulas for `#REF!`. A `#REF!` in the date-side display formula can make the amount appear while the date stays blank.
- Table columns:
  - `Include`
  - `Category`
  - `Date`
  - `Vendor`
  - `Description`
  - `Amount`
  - `Source`
  - `Invoice #`
  - `Source File`
  - `Status`
  - `Notes`

Manual carrying expenses can be entered as new rows in `tblCarryingExpenses`. Scanned invoice processing should also add rows to `tblCarryingExpenses` after the invoice is matched to the project and category. Set `Include` to `Yes` only when the row should affect the model.

Scan-process test entry:

- Category: `Lawn`
- Vendor: `Greenview Works`
- Invoice #: `000373`
- Date: `2026-05-26`
- Amount: `$60.00`
- Source: `Scanned Invoice`
- Source file: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\26-BYH -908 Pond St\Owning\26-05-26 - Greenview Works.pdf`

Formatting and data-entry notes from prototype review:

- The current Pond Need Verification workbook is the formatting reference for the Carrying conversion until Wes approves a later pattern.
- Table columns should be wide enough for human use even if that makes the right-side area wider.
- Do not force the right-side table to match the narrow category-grid column widths.
- Use a spacer column before the right-side table.
- Keep blank/manual rows available and sortable to the top.
- `Invoice #` should be formatted/stored as text so leading zeroes are preserved.
- For scanned entries, insert a new table row directly rather than consuming a pre-made blank row.

## Known-Good Pond Carrying Conversion Pass

Use the final approved Pond pass as the model for the next Carrying conversion. The key lesson from the Pond rebuild is that the table must be rebuilt from the current source workbook, not patched from a previous bad converted table.

Reference files from the approved pass:

- Updated source/original reviewed by Wes: `C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Rewrite\sources\26_Project Management - 908 Pond St 3- Test before fresh copy 20260528_094224.xlsm`
- Converted review workbook: `C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Rewrite\Need Verification\26_Project Management - 908 Pond St 3.xlsm`
- Backups: `C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Rewrite\working\invoice-project-updates`

Repeat this sequence for the next workbook:

1. Confirm the Need Verification workbook is closed and has no `~$` lock file.
2. Create a timestamped backup in the working backup folder before each structural edit.
3. Open the current source/original workbook read-only and read the old Carrying grid.
4. Ignore any source block that is no longer a standard Carrying category, especially `Town Cary Solid Waste`.
5. If Wes has already moved old Town Cary rows into `Water Utility`, migrate only the `Water Utility` rows as standard category `Water`.
6. Rebuild `tblCarryingExpenses` completely from the source/original grid; do not reuse rows from the previous converted table except for separately approved scanned invoice rows.
7. Use standard category names in the table even when the visible grid header is more descriptive.
8. Preserve dated zero-dollar schedule rows when the source grid uses them as part of the visible model.
9. Skip blank placeholder rows and leftover invalid placeholders, such as zero-dollar 1900 dates left in a removed Town Cary block.
10. Remove the visible `Town Cary Solid Waste` block from the converted Carrying grid.
11. Keep all standard visible blocks, including a blank `Lawn` block, so the `Profit` sheet has stable source cells.
12. Rebuild the visible grid formulas from `tblCarryingExpenses` using date-ascending formulas and anchored row counters.
13. Restore the escrowed Property Taxes layout: Date, payment, and `Paid in Escrow`, with the total cell using the net of payment plus escrow offset.
14. Update `Profit` Carrying rows to point to the shifted Carrying total cells and remove any `Town Cary Solid Waste` Profit row.
15. Reopen read-only and verify row counts, category totals, no visible `Town Cary Solid Waste`, no formula errors, and correct `Profit` formulas.

For the approved Pond pass, the final visible Carrying totals were:

| Category | Carrying Total |
| --- | ---: |
| `Duke Electric` | `$608.30` |
| `Mortgage Payment` | `$14,421.92` |
| `Private Money` | `$5,500.00` |
| `Casa Lending` | `$5,921.56` |
| `Insurance Payments` | `$0.00` |
| `Water` | `$401.79` |
| `Natural Gas` | `$10.00` |
| `HOA` | `$0.00` |
| `Property Taxes` | `$0.00` net after escrow offset |
| `Excavator Rental` | `$6,000.00` |
| `Lawn` | `$0.00` unless scanned lawn invoices have been added |

The approved Pond `Profit` Carrying rows use these source cells after removing Town Cary:

| Profit Row Label | Carrying Source Cell |
| --- | --- |
| `Duke Electric` | `Carrying!B25` |
| `Mortgage Payment` | `Carrying!E25` |
| `Private Money` | `Carrying!H25` |
| `Casa Lending` | `Carrying!K25` |
| `Insurance Payments` | `Carrying!N25` |
| `Water` | `Carrying!Q25` |
| `Natural Gas` | `Carrying!T25` |
| `HOA` | `Carrying!W25` |
| `Property Taxes` | `Carrying!Z25` |
| `Excavator Rental` | `Carrying!AC25` |
| `Lawn` | `Carrying!AF25` |

The approved Pond `Carrying Cost` row is `Profit!B42 = +B28*SUM(B31:B41)`.

## Standard Carrying Categories

Converted project workbooks should use a consistent Carrying category set. If a workbook does not already have one of these categories, add it during conversion.

Standard Carrying categories:

- `Duke Electric`
- `Mortgage Payment`
- `Private Money`
- `Casa Lending`
- `Insurance Payments`
- `Water`
- `Natural Gas`
- `HOA`
- `Property Taxes`
- `Excavator Rental`
- `Lawn`

Notes:

- Keep existing category data when a workbook already has one of these categories under a slightly different compatible label.
- The visible friendly-grid header may remain more descriptive than the table category. For example, keep the visible grid header `Mortgage Payment paid after Reinstatement` if useful, but use standard table category `Mortgage Payment` in `tblCarryingExpenses` and in the formulas behind that group.
- If a workbook has a local utility label such as `City of Raleigh Water` or `Water Utility`, map it to the standard `Water` category unless Wes gives a project-specific reason not to.
- If a workbook has `Enbridge`, map it to the standard `Natural Gas` category.
- Normalize source Carrying labels before mapping them: trim spaces and compare case-insensitively. Examples that should map cleanly include `Electric`, `Duke Electric`, `DUKE Electric`, `city water`, `Aqua Water `, and `Garbage Utility`.
- Additional source labels observed in 19 Pleasant Garden: map `Duke Energy` to `Duke Electric`, `Mortgage Payments` to `Mortgage Payment`, `City of Raleigh(Water)` to `Water`, `Dominion Energy (gas)` to `Natural Gas`, and `Taxes` to `Property Taxes`.
- In 19 Pleasant Garden, migrate evaluated Carrying rows with real evaluated dates on or before the conversion date, even when the original row uses formulas to carry the schedule forward. Do not migrate future rows after the conversion date.
- For 19 Pleasant Garden, distinguish formula schedule rows from future projections by evaluated date. Formula rows through the conversion date are part of the carrying history and should be included; formula rows after the conversion date should be excluded.
- For 19 Pleasant Garden and similar old layouts, never migrate source subtotal rows such as row 47. A source row with a total formula or no source date is not an expense-table entry.
- When detecting row types with Excel automation, use evaluated values for date and amount. Use `HasFormula` only as metadata for notes, not as an exclusion rule by itself.
- If an original workbook's source totals include projected/formula continuation rows, call that out in the reconciliation report. Do not silently switch the baseline from original displayed totals to manual-detail totals; get a decision on which baseline is intended.
- Do not include `Town Cary Solid Waste` as a standard Carrying category. Remove its visible Carrying grid columns and its `Profit` row during conversion unless Wes gives a project-specific exception.
- If Town Cary Solid Waste entries have already been moved into `Water Utility` in the source workbook, rebuild from `Water Utility` and do not migrate any leftover Town Cary placeholder rows such as zero-dollar 1900 dates.
- Categories that have no current data should still be present in the friendly Carrying grid and in table validation lists.
- Preserve dated zero-dollar rows when they are part of the existing schedule or visible carrying model. This applies especially to scheduled insurance and tax rows; do not treat all zero rows as disposable placeholders.
- For 7001-style escrowed property taxes, store the property-tax payment rows in `tblCarryingExpenses` as `Category=Property Taxes` and display the escrow offset in the third visible grid column, `Paid in Escrow`. Do not store separate zero-dollar `Paid in Escrow` rows in the table.
- Do not assume source Carrying data starts on row 5. Some workbooks have a real dated entry on row 4, such as 24 Tensity's `city water` block. Include row 4 when it contains a real date or amount.
- Do not assume source Carrying data starts on row 4. Pleasant Garden has real Carrying entries beginning on row 3.
- When multiple source blocks map to one standard category, such as 28 Rose's `Aqua Water` and `Garbage Utility` both mapping to `Water`, the table and total should include all rows. The visible grid may only display the first rows that fit in the friendly block; flag this for Wes if the source row count exceeds the visible grid capacity.

## Profit Carrying Rows

The `Profit` sheet should have one Carrying row for each standard Carrying category, followed by the `Carrying Cost` total row. In the Pond prototype this section starts at `Profit!A31`.

Use these row labels and source cells for converted workbooks unless a workbook has a documented project-specific layout difference:

| Profit Row Label | Carrying Source Cell | Formula Pattern |
| --- | --- | --- |
| `Duke Electric` | `Carrying!B25` | `=+Carrying!B25/Profit!$B$28` |
| `Mortgage Payment` | `Carrying!E25` | `=+Carrying!E25/Profit!$B$28` |
| `Private Money` | `Carrying!H25` | `=+Carrying!H25/Profit!$B$28` |
| `Casa Lending` | `Carrying!K25` | `=+Carrying!K25/Profit!$B$28` |
| `Insurance Payments` | `Carrying!N25` | `=+Carrying!N25/Profit!$B$28` |
| `Water` | `Carrying!Q25` | `=+Carrying!Q25/Profit!$B$28` |
| `Natural Gas` | `Carrying!T25` | `=+Carrying!T25/Profit!$B$28` |
| `HOA` | `Carrying!W25` | `=+Carrying!W25/Profit!$B$28` |
| `Property Taxes` | `Carrying!Z25` | `=+Carrying!Z25/Profit!$B$28` |
| `Excavator Rental` | `Carrying!AC25` | `=+Carrying!AC25/Profit!$B$28` |
| `Lawn` | `Carrying!AF25` | `=+Carrying!AF25/Profit!$B$28` |

After the category rows, set `Carrying Cost` to multiply months carried by the sum of the Carrying rows. After removing `Town Cary Solid Waste`, the current Pond/7001 prototype uses `Profit!B42` as `=+B28*SUM(B31:B41)` and `Profit!D42` as `=-B42`.

When adding Profit rows, verify that rows below `Carrying Cost` shifted cleanly and still point to the intended cells.

For escrowed Property Taxes, `Carrying!Z25` may be the merged/anchor total cell for the three-column Property Taxes block. The formula should use the net of the payment column and `Paid in Escrow` column, so escrowed tax payments show in Carrying but net to zero in Profit.

For single-category expense tabs such as plumbing, electrical, HVAC, cabinets, paint, flooring, and similar tabs, use a consistent version of this pattern:

- Keep the category-specific friendly area as the readable view.
- Put the structured table to the right.
- The category can usually be implied from the worksheet name, so the table may omit a visible category column if doing so makes the tab cleaner.
- Use consistent columns across single-category tabs whenever possible so scan automation can insert rows the same way across projects.

Repeatable conversion process for an expense tab:

1. Back up the workbook before editing.
2. Preserve the friendly expense section and the subtotal cells that feed `Profit`.
3. Extract the existing friendly-section entries into a structured table placed to the right of the friendly section.
4. Add blank table rows for future manual/scanned entries.
5. Use formulas in the friendly section to display matching rows from the structured table by category.
6. Use subtotal formulas against the structured table's `Amount`, `Category`, and `Include` fields.
7. Expand the `Profit` Carrying section to include every standard Carrying category.
8. Remove temporary helper sheets after the right-side table is verified.
9. Reopen the workbook and verify:
   - The workbook opens cleanly.
   - Only the intended expense worksheet/table remains.
   - The friendly section displays normal dates and currency.
   - The friendly Carrying grid shows date and amount only; detailed fields stay in the right-side table.
   - The friendly Carrying grid displays matching rows in date-ascending order even if the right-side table is sorted differently.
   - The friendly Carrying grid does not repeat the same first date/amount down each category block.
   - The friendly Carrying grid has no `#REF!` formulas, especially in the date-side cells for newly added categories.
   - Category totals match the pre-conversion values.
   - `Profit` still pulls the expected values from the expense-tab subtotal cells.
   - The right-side table contains the expected rows and blank entry capacity.
   - The `Profit` Carrying rows include every standard Carrying category and the first row below `Carrying Cost` was shifted down without being overwritten.
   - `Natural Gas` uses the same monthly carrying formula pattern as the other standard carrying categories unless Wes explicitly approves a project-specific exception.

Project-wide Carrying conversion process:

1. Use the SharePoint/Teams connector to locate and fetch or verify the active source/original workbook. Do not start from a stale project-room or synced-folder copy.
2. Work from the project-room source copy after connector verification, not directly in Teams, unless Wes explicitly approves a live invoice insertion.
3. Save converted workbooks to `C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Rewrite\Need Verification`.
4. Put timestamped pre-conversion backups in `C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Rewrite\working\invoice-project-updates`.
5. Skip locked/open workbooks and ask Wes to close them before retrying.
6. Do not run conversions while any project management workbook is open in Excel. Even if the target file is not locked, a running Excel instance with another project workbook open can confuse the user's view and increase automation risk.
7. When processing multiple project workbooks, convert and verify one workbook at a time.
8. If a conversion reveals a reusable rule or failure mode, document it in this file before starting the next workbook.
9. Confirm the connector item and source/original workbook path before opening the target. Source files may have nonstandard names, such as `28_Project Management - 320 Rose P-originall.xlsm`.
10. Rebuild `tblCarryingExpenses` from the current source/original Carrying grid each time. Do not assume an earlier converted table is trustworthy.
11. Migrate real existing Carrying entries from the old grid. Keep dated nonzero amounts, and also keep dated zero-dollar schedule rows when the old workbook used them as part of a visible schedule. Skip blank placeholder rows.
12. Map old labels into the standard category list before loading `tblCarryingExpenses`.
13. Put migrated rows into `tblCarryingExpenses` with `Include=Yes`, `Source=Existing Workbook`, and `Status=Migrated`.
14. Add or preserve blank standard category blocks in the visible grid, such as `Lawn`, even when the table has no rows for that category yet.
15. Rebuild the visible Carrying grid with date-ascending formulas against `tblCarryingExpenses`.
16. Rebuild visible Carrying grid totals with the Tensity pattern: each category total cell must use `SUMIFS(tblCarryingExpenses[Amount],tblCarryingExpenses[Category],...,tblCarryingExpenses[Include],"Yes")`, except escrowed Property Taxes where Wes has approved a separate escrow-offset display. Do not use a separate formula system that bypasses table totals.
17. Rebuild the `Profit` Carrying rows to match the standard Carrying categories and remove `Town Cary Solid Waste`.
18. Reopen each converted workbook read-only and verify `tblCarryingExpenses`, `Profit!A42=Carrying Cost`, no visible `Town Cary Solid Waste`, and no `#REF!` formulas in the Carrying grid.
19. Verify workbook identity before releasing the converted file. Check that project-specific worksheets from the source are still present and unrelated project shell markers are not present. Example: Pond should contain sheets such as `Depends`, `Glasgow`, `Tim`, `Others`, `Draws`, `Lumber`, `Smart`, and `2024`; it should not contain Outrigger-only shell markers such as `Past`, `UpdateContract`, `Recap`, or `MISC`.
20. Reconcile original-vs-converted Carrying totals before release. Read the original source workbook's Carrying totals for every mapped source category, compare them with the rebuilt `tblCarryingExpenses` totals and visible Carrying subtotal cells, and stop if any category differs except for documented intentional changes such as removed obsolete categories or escrow netting for Property Taxes.
21. Write the verified workbook back through the SharePoint/Teams connector when the request is to update the live Teams workbook.

Implementation note:

- When removing temporary helper sheets through Excel automation, disable events before deletion. In testing, direct sheet deletion with events enabled reported success but did not persist reliably.
- If a newly added category such as `Lawn` shows the amount but not the date, inspect the date-side formula first. The correct formula pattern should filter `tblCarryingExpenses[Date]` and `tblCarryingExpenses[Amount]` by `Include="Yes"` and the category header, then return the first column from that filtered pair.
- When removing a visible Carrying block that sits before the right-side table, delete the full worksheet columns for that block rather than deleting only the visible grid cells. Cell-only deletion can fail or distort the table because Excel will not shift cells through a table.
- After deleting full columns, re-check the table location and all `Profit` source-cell references because every block to the right shifts left.
- If Excel automation fails midway, check for an orphaned hidden Excel process before retrying. Do not leave the workbook open in a failed automation instance.
- When rebuilding `tblCarryingExpenses`, do not delete or add table rows one at a time. Row-by-row table operations can hang Excel automation. Resize the table to the required row count and write the full data body as one rectangular range. Disable events, screen updating, and automatic calculation during the rebuild, then perform one final recalculation before saving.
- If another Excel workbook is open, setting `Application.Calculation` to manual may fail. Treat that as a non-fatal warning, continue with events/screen updating disabled where possible, and rely on the final verification pass to catch formula issues.
- If Excel automation hangs or repeatedly opens the wrong workbook shell, stop the hidden Excel process if it has no visible workbook window, replace the target from the correct source workbook again, and rerun from the clean source. Record the source path and workbook identity markers in the verification output.
- When a target was created from the wrong workbook base, do not attempt to repair the shell in place. Back up the wrong-base target, copy the correct source/original to the target path, and rerun the full conversion from that clean copy.
- If Excel reports repairs that remove `/xl/tables/table*.xml`, the formal Excel table metadata is damaged. Do not create or modify the table with file-level table XML writers. Rebuild from the clean source and have Excel itself create `tblCarryingExpenses`, then verify the file reopens cleanly and the formulas still use structured references.
- For Amortization sheet swaps, do not assume every workbook uses the same Docs row layout. Some old layouts use selling fields around `Docs!B10:B23`, while others use property/document fields around `Docs!B7:B36`. Prefer labeled rows and Amortization output cells, such as `AA3:AA5`, `T4:T6`, `O3:O5`, and payment cells `Z8:Z10`, over fixed Docs cell positions when mapping source values.
- When mapping loan start dates, reject small percentage/rate values even if they are numeric. Prefer real Excel date serials from labeled loan-start rows, such as `Docs!B33`, `Docs!B20`, or `Docs!B18`, and require the numeric value to look like a date serial rather than an interest rate.
- When mapping interest rates, only accept percentage-like numeric values between 0 and 1. Old layouts may have loan-balance amounts near the rate/payment table; treating those as rates can produce `#NUM!` payment results.
- If the old workbook's loan amount equals selling purchase price minus down payment, preserve that relationship in the Rose layout by mapping the appreciation/price input so `Amortization!O3` equals the selling purchase price and leaving `X5` at zero. Use `X5` only when the old workbook intentionally carried a separate selling-price adjustment outside the financing base.
- If the approved Rose layout recalculates a payment materially differently from the old workbook, log the old and new values as a formula-driven change before upload. Do not hide the change by forcing the old payment into the new template.
- When designing an Amortization replacement sheet, copy the current `Amortization` worksheet to a new replacement worksheet and make all design changes only in the replacement. Do not rename, overwrite, or reconnect dependent formulas to the replacement until Wes approves the design. Verify after saving that the original `Amortization` sheet is still present and its key formulas remain unchanged.
- During rollout of the redesigned Amortization pattern to active projects, do not replace the Amortization sheet on Cool Springs as a standard batch item. Cool Springs has an actively used amortization table; skip it by default and handle it only with explicit Wes approval, a separate review plan, an extra rollback copy, and extreme caution around any dependent formulas or document outputs.
- For Amortization rate-change redesigns, keep the subject-to loan schedule separate from the buyer Contract for Deed schedule. Prefer one buyer schedule with explicit rate-change inputs, such as first-rate period in years/months, Rate 1, Rate 2, and payment formulas that reference the buyer schedule's own period counter rather than the subject-to loan year column.
- Before clearing a legacy Amortization buyer table such as `N14:W830`, scan for formulas outside that range that still depend on those cells. In the Tensity replacement pass, helper columns and the `M` period/year logic also depended on the legacy table; rewrite those formulas to use the replacement buyer schedule (`Y:AL` and `AM`) before clearing or hiding the legacy table.
- During iterative Amortization redesign, do not rely on old address labels such as "legacy table" after Wes manually moves the design. Re-identify the active schedule by function and formulas before deleting or rewriting ranges. In the Tensity replacement pass, `N:W` became the active Contract for Deed schedule, so it had to be preserved and extended to `N:X` with `X` as ending balance, while `Y:AL` became supporting outputs. Also verify rate-term inputs do not create circular formulas; use separate total-term and remaining-term cells for Rate 1 and Rate 2 payments.
- When clearing or rewriting Amortization helper headers, check for merged cells before targeting individual cells. In the Tensity helper-output cleanup, direct `ClearContents` against a merged header cell failed; unmerge the exact small header range first or clear the whole intended merged range through Excel automation, then verify formulas and visible labels.
- When reconnecting other worksheets from old `Amortization` to a redesigned replacement sheet, do not use a blind address-level sheet-name replacement as the final mapping. First replace the references, then inspect affected formulas by label and value because replacement layouts may have moved fields such as term years, contract dates, payments, taxes, insurance, interest rates, and five-year balance summaries. In the Tensity reconnect pass, same-address replacement initially sent several `Docs` and `Profit` formulas to blank or wrong cells; the correct final mapping used replacement labels such as `V8/V10` for Rate 1/Rate 2 payments, `W2/W3` for insurance/taxes, `S12/U12` for contract start/end, `O8/O10` for Rate 1/Rate 2 rates, and schedule lookups for five-year balances.
- When evaluating whether Amortization ranges should become real Excel tables, create a copied test worksheet first and keep the live `Amortization` sheet unchanged. In the Tensity table trial, the copied sheet `Amortization - Table Test` used separate tables for the subject-to loan schedule, schedule index/helper columns, Contract for Deed schedule, and buyer output block. Verify that no outside formulas point to the test sheet, key values match the live sheet, and the test tables do not visually override Wes's layout before deciding whether to convert the live sheet.
- For Contract for Deed amortization schedules, do not use the subject-to mortgage period counter as the buyer payment period. Create or use a buyer-period counter that starts at the contract date, and use that buyer period for rate selection, payment gating, and summary lookups. When there is no second-rate period, the final scheduled buyer payment should equal remaining principal plus final interest so the ending balance reaches true zero rather than leaving a rounding residual or an unpaid balance. In the Tensity fix, the old subject-to period logic left about `$16,984` unpaid; after switching to the buyer period and adjusting the final payment, period 59 paid the balance to zero.
- When adding structured references to an Amortization table-test sheet, start with summary lookup formulas before rewriting body formulas. Check for copied merged cells in the summary block because merged ranges can block formulas in cells such as `AA8` and `AA10`; restore or unmerge the summary area before applying formulas. Also verify cumulative formulas at the payoff row: if cumulative cash flow is written as `IF(End Bal<=0,0,...)`, the final payoff can incorrectly reset the cumulative total to zero. Use the payment activity, not ending balance alone, to decide whether to add the current row or carry the prior cumulative total forward.
- After copying or table-testing an Amortization summary block, verify the visible block did not shift because of merged cells or copied formulas. In the Tensity table test, a duplicate Contract for Deed Summary appeared offset into `Y2:AB10` while the intended block was `X5:AA13`; the fix was to clear the shifted duplicate, restore the intended summary block from the live sheet, preserve the expected merges, and then reapply any structured-reference summary formulas. When matching date formats across Amortization schedules, copy the approved date format from the selected source cell, such as `N20`, to the relevant schedule date columns only after the target ranges are confirmed.
- After Wes manually moves an Amortization Summary block, locate it by the visible title and row labels before changing formulas; do not assume the previous address is still authoritative. Do the same for Amortization term inputs: find `Contract Date`, `First Rate Period Years/Months`, `Contract Period Years/Months`, `Rate Change Date`, and `End Date` by label, then use the adjacent value cells from the current layout. Convert any remaining whole-column Summary lookups, such as month-12 cash-flow lookups, to the corresponding table columns during the same pass, then verify the visible summary values, payoff row, and no-error status in both the working copy and the uploaded Teams workbook.
- When finding Amortization values by label, account for merged label cells. Use the cell immediately to the right of the label's merged area as the first value cell; do not use a fixed offset from the label cell. In the Tensity layout, `First Rate Period Years/Months:` is merged across `K:N`, so the value starts at `O`, and a fixed offset can incorrectly target `R` or `S`.
- For Tensity-style Amortization term inputs, treat the labeled `Contract Date`, first-rate years, and total contract years cells as the user-facing input fields, wherever Wes has moved them in the current layout. Calculate first-rate months, Rate Change Date, total contract months, and End Date from those labeled inputs; do not turn the calculated date cells into manual inputs unless Wes explicitly changes the design. The table formulas may use the calculated dates for rate switching and cutoff logic, but the input surface should remain the contract date plus year counts. Verify the rate transition row, final payoff row, summary block, and no-error status after upload.
- When a Contract for Deed has a first-rate period followed by a second-rate period, do not calculate the Rate 1 payment as though the first-rate period is the full payoff term unless Wes explicitly wants a balloon-free first-period payoff. For the standard two-period design, calculate Rate 1 payment over the full contract months (`P13`), calculate the Rate 2 payment from the balance at the rate-change period over the remaining months (`P13-P12`), and force the final payoff using the buyer period (`P13-1`) rather than an exact date match because schedule dates may not land exactly on the contract end date.
- In the Amortization table design, the buyer payment `Period` belongs in `tblContractForDeed`, not in the buyer-output table. Payment, rate-change, final-payoff, and summary formulas should use `tblContractForDeed[Period]`; `tblBuyerOutputs` should consume Contract for Deed results such as payment and ending balance rather than owning the period counter.
- For subject-to loan schedules, confirm whether the available balance/date are the original loan start point or only a known current balance point. When only a known balance and known balance date are available, model the table as a remaining-balance schedule: use the known balance as the starting principal, calculate the remaining months inclusively through the mortgage end date, derive the payment from that remaining term, advance rows with `EDATE`, and force the final scheduled row to pay off on the mortgage end date. Do not let a table run to zero early simply because a hard-coded payment or assumed original amortization term happens to exhaust the balance before the stated mortgage end date.
- When table-converting Amortization output columns, audit any formulas that still point to old helper cells outside the visible input block. Repoint them to the current labeled input or a named range before validation. In the Tensity table test, `tblBuyerOutputs[Monthly Appr]` still used stale helper cell `AL2`; after Wes moved the layout, the active appreciation input was the visible `above ARV` selector at `O2`, so Monthly Appreciation and Cumulative Appreciation returned zero until the table formulas were repointed.
- Do not use direct ZIP/XML workbook rewrites as the upload path for active `.xlsm` project-management workbooks unless there is a separate successful open/repair verification in Excel before upload. Macro-enabled project workbooks can become unreadable even when the XML edit appears narrow. Prefer Excel-controlled edits and saves for formula changes, then verify by reopening the saved workbook before uploading to Teams; if Excel automation hangs or cannot verify the saved file, restore from rollback and stop for review rather than uploading an unverified file.
- When reconnecting `Docs` and `Profit` to a redesigned two-period Amortization sheet, update both direct Amortization links and dependent fields that derive from those links. In the Tensity reconnect, `Docs` needed Rate 2 payment mapped to `cfdRate2Payment`, first-period years/months mapped to `cfdFirstRateYears`/`cfdFirstRateMonths`, second-period months calculated as `cfdContractMonths-cfdFirstRateMonths`, and the loan date fields split into contract date, first-period end date, rate-change date, and full contract end date. Do not stop after replacing old sheet names; verify no outside formulas still point to the old `Amortization` sheet and check key `Docs` and `Profit` values after upload.
- For `Profit` formulas that need the five-year subject-to payoff balance in option 3 / Slow Flip, align the subject-to loan schedule to the Contract for Deed timeline before looking up the balance. Do not use subject-to period `60` directly; first find the subject-to period containing `cfdContractDate`, add `cfdFirstRateMonths`, then return `tblSubjectToLoan[Balance]` for that aligned period. The Year helper can represent presentation groupings and may not be the correct key for a specific Contract-for-Deed period.
- When formulas outside a source sheet depend on summary/document-output cells in that source sheet, prefer workbook-level names over direct cell addresses once the business meaning is stable. In the Tensity trade-property cleanup, formulas were changed from direct `Trade Properties` cell references to names such as `tradeNetCreditIncluded`, `tradeMonthlyGrossSpread`, `tradePropertyListForDocs`, and `tradePropertyConditionsForDocs`, then verified by scanning for zero remaining direct `Trade Properties` formula references.
- In the Teams/SharePoint connector, active project-management workbooks live directly under the `Property` drive root, while each named property folder contains supporting subfolders such as `Buying`, `Owning`, and `Renting`. Do not assume, search, or browse for the project workbook inside an individual property folder; fetch the exact root-level `Property/<project workbook name>` item before using any local working copy.
- When writing an updated project-management workbook back through the Teams/SharePoint connector, use the drive-root-relative path `Property/<project workbook name>`. Do not include the document library prefix such as `Shared Documents/Property/...` in `update_file`; that path can produce an `itemNotFound` error even when the workbook exists and was fetched successfully.
- When rewiring `Profit` mode logic to a numeric selector such as `Profit!E1`, change only formulas that actually depend on mode labels like `B1`, `C1`, or `D1`. Do not blindly replace nearby cells such as `B2` property address, and do not treat substring matches such as `C15` as `C1`; verify exact cell references and business meaning before editing.
- For Trade Properties cash-flow analysis, itemize recurring property-level expenses in the support/detail table and aggregate them in the top contract-facing table. In the Tensity pattern, the detail table keeps `Lot Rent / Mo` plus user-input columns for `Property Tax / Mo` and `Insurance / Mo`; the top table shows one `Monthly Expenses` rollup, and all spread, annual spread, yield, and cap-based value formulas use net spread after those expenses.
- When rolling out a redesigned workbook structure one worksheet at a time, keep a per-target status list for uploaded, staged-not-uploaded, skipped, and failed workbooks. If Wes pauses after a partial batch, resume only the remaining targets for that same worksheet and do not start the next worksheet until Wes has reviewed the current status and explicitly approves continuing.
- For every worksheet update, worksheet copy, worksheet replacement, or worksheet migration, scan both workbook-level and sheet-scoped defined names for unintended external references before upload. Copied worksheets can carry source-workbook names even when the copied cells look clean; examples include Amortization names such as `cfdContractDate` and sheet-scoped Gantt names. Excel may also retain cached workbook links after bad defined names are deleted, so verify with Excel's workbook-link list and break unintended project-workbook links before uploading the cleaned workbook.

## Completion Lesson Capture Rule

At completion of every project workbook conversion, migration, sheet swap, or similar spreadsheet update, record any new reusable lesson in the appropriate durable rule file before treating the work as complete.

Capture lessons such as connector discovery, freshness, upload, or permission behavior; workbook-open, Excel automation, link-breaking, or macro-enabled save behavior; template formula/layout differences from prior assumptions; validation checks that caught an issue or should be repeated next time; formula-driven value changes that need to be logged for Wes; and rollback, migration-log, or post-upload verification issues.

If a run produced no new reusable lesson, state that in the final response. Do not leave a reusable lesson only in a chat message or one-off migration log.

## Review Rules

Route the project workbook update for review when:

- The invoice category cannot be determined confidently.
- The project workbook cannot be found.
- The project workbook is open or locked.
- The correct worksheet/table/section is not defined in this rules file.
- Multiple possible expense sections could apply.

## Workbook Edit Workflow

Follow `SOP Spreadsheet Maintenance Rule.md` before editing any project management workbook:

1. Confirm the original project workbook is closed.
2. Locate or verify the active workbook through the SharePoint/Teams connector.
3. Copy the connector-verified workbook into the safe working folder above.
4. Edit the project-room copy.
5. Verify the workbook opens cleanly.
6. Write the verified workbook back through the SharePoint/Teams connector to the original Teams/SharePoint item, unless Wes asked for a project-room-only review copy.

### Pleasant Garden clean rebuild rule added 2026-05-30

For Pleasant Garden and similar conversions, the friendly Carrying grid must be rebuilt as a full replacement of the old grid, not patched into the fixed Pond/Tensity 21-row display area. Keep the original total-row shape where practical: Pleasant Garden uses detail-display rows 3 through 45, row 46 as spacer, and row 47 as the totals row. `tblCarryingExpenses` is rebuilt only from valid dated source entries on or before the conversion date. Source total/subtotal rows, especially row 47, are never migrated to the table. After rebuilding, clear the replaced grid area so no old-structure rows remain below the new formula-driven grid. Profit formulas for this file must point to the rebuilt row-47 Carrying totals.

### Pleasant Garden negative escrow offsets

When a source Property Taxes row is a negative amount with an escrow note, keep it as a negative table amount and display it in the friendly grid's `Paid in Escrow` column. Do not convert that row into a positive payment plus a second offset, because that changes the source total. The rebuilt grid total should match the original source net total while still making the escrow offset visible.


