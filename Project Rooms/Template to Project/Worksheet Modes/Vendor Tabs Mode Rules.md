# Vendor Tabs Mode Rules

Use these rules when designing, repairing, or rolling out the vendor-tab group in Buy Your Home project-management spreadsheets.

## Mode Scope

Vendor Tabs mode is a grouped worksheet mode. The included tabs should work exactly the same as one another and should be updated as a coordinated set.

The first workbook for Vendor Tabs mode changes is the Outrigger project workbook. After the Outrigger tabs are complete and approved, migrate the same Vendor Tabs mode changes to the other active project workbooks.

## Included Tabs

Vendor Tabs Mode includes the `Review` intake worksheet and the approved vendor expense worksheets. `Review` is part of the coordinated mode but is not itself a vendor expense tab.

Current Vendor Tabs mode list:

1. `Review`
2. `Demo & Trash Haul`
3. `Appliances`
4. `Plumbing Fixtures`
5. `Windows & Doors`
6. `Cabinets`
7. `Paint`
8. `Flooring`
9. `HVAC`
10. `Electrical Fixtures`
11. `Landscape`
12. `Exterior`

`STR` is not a vendor tab and is outside Vendor Tabs Mode. Do not include `STR`, `Furnishing`, or other tabs outside this list unless Wes explicitly expands the scope.

## Review Intake Worksheet

- `Review` is the intake and exception queue for Vendor Tabs Mode.
- Its table is `tblInvoiceReview`.
- `Review!B1` contains the native `Needs Invoice Entry Review` checkbox.
- Workbook name `invoiceEntryReviewRequest` must refer absolutely to `=Review!$B$1`.
- Template to Project owns the Review layout, columns, validation, checkbox, table structure, formatting, and rollout.
- Invoice Entry owns duplicate checks, movement of approved rows into destination tables, status updates, and clearing the request checkbox.
- The checkbox requests processing; it must not move rows directly.

## Source Note

This initial mode list came from the current local Outrigger working copy reviewed on 2026-07-07:

`C:\Codex\Wiki Files\Project Rooms\Template to Project\working\profit-mode\full-profit-rerun-outrigger-20260707\27_Project Management - 7001 Outrigger Dr.current.xlsm`

Before editing or uploading an active workbook, follow the project-management spreadsheet rules for confirming the exact target workbook, verifying the current SharePoint/Teams source, making rollback copies, and validating the saved workbook.

## Actual-Invoice Table Pattern

The Outrigger `Flooring` tab now uses the first approved actual-invoice table pattern.

Current pilot table:

- Workbook: `Property/27_Project Management - 7001 Outrigger Dr.xlsm`
- Worksheet: `Flooring`
- Table name: `tblFlooringInvoices`
- Table range: `Flooring!A11:H25`
- Columns: `Date`, `Description`, `Sq Ft`, `Item #`, `Qty`, `Cost/Unit`, `Sub-Total`, `Tax`

Pattern rules:

- The table replaces the loose yellow actual-invoice entry block for the pilot worksheet.
- Keep orange template-estimate rows separate from the table.
- Preserve the worksheet selector behavior. For the pilot, `Flooring!K5` carries the downstream total, and `Gnatt Chart!G14` points to that cell.
- Formula columns should use structured references rather than row-only formulas.
- Preserve yellow fill for user-entry cells and protected/formula color conventions for calculated cells.
- When converting existing actual rows, preserve intentionally blank tax cells instead of filling a table tax formula into every row. Some prior actual rows, such as marketplace purchases, are non-taxed and the actual-section total must reconcile to the pre-conversion value.
- Do not roll this table pattern to the rest of Vendor Tabs Mode until Wes approves the pilot behavior.

## Outrigger Vendor-Tab Table Rollout

As of 2026-07-07, Wes approved continuing from the `Flooring` table pilot into the clearly identifiable Outrigger actual-invoice blocks.

Converted Outrigger actual-invoice tables:

| Worksheet | Table | Range | Notes |
| --- | --- | --- | --- |
| `Flooring` | `tblFlooringInvoices` | `A11:H25` | Approved pilot pattern. Downstream total is `Flooring!K5`, and `Gnatt Chart!G14` points to that cell. |
| `Demo & Trash Haul` | `tblDemoTrashHaulInvoices` | `A11:F26` | Uses its existing vendor/date/event/iterations/charge/subtotal layout. Downstream total is `'Demo & Trash Haul'!K5`, and `Gnatt Chart!G8` points to that cell. |
| `HVAC` | `tblHVACInvoices` | `A11:G21` | Uses its existing no-tax actual layout. Downstream total is `HVAC!K5`, and `Gnatt Chart!G19` and `Gnatt Chart!G24` point to that cell. |
| `Cabinets` | `tblCabinetsInvoices` | `A11:H43` | Uses one combined actual-invoice table with `Cabinet Group` as the first column. Preserve the intentionally blank tax cell on the marketplace row. The current Outrigger Cabinets downstream total is `Cabinets!K5`, and `Gnatt Chart!G12` points to that cell. |
| `Exterior` | `tblExteriorInvoices` | `A22:J36` | Uses the standard `Group`, `Date`, `Vendor`, `Description`, `Sq Ft`, `Item #`, `Qty`, `Cost/Unit`, `Sub-Total`, and `Tax` columns. The downstream total is `Exterior!M24`, and `Gnatt Chart!G17` points to that cell. The selector is a native checkbox in `Exterior!N2`, with state in `M2`. |
| `Appliances` | `tblAppliancesInvoices` | `A13:J33` | Preserves dated actual records and keeps undated candidate products out of the actual table. Downstream total is `Appliances!M15`, and `Gnatt Chart!G9` points to that cell. |
| `Plumbing Fixtures` | `tblPlumbingFixturesInvoices` | `A14:J36` | Uses the standard ten-column invoice schema. Downstream total is `'Plumbing Fixtures'!L16`, and `Gnatt Chart!G10` points to that cell. |
| `Paint` | `tblPaintInvoices` | `A11:J41` | Uses the standard ten-column invoice schema while retaining paint-specific Group values. Downstream total is `Paint!M13`, and `Gnatt Chart!G13` points to that cell. |
| `Electrical Fixtures` | `tblElectricalFixturesInvoices` | `A10:J36` | Contains blank future-entry rows because Outrigger currently has no actual electrical-fixture invoices. Downstream total is `'Electrical Fixtures'!M12`, and `Gnatt Chart!G15` points to that cell. |
| `Landscape` | `tblLandscapeInvoices` | `A22:J32` | Contains blank future-entry rows because Outrigger currently has no actual landscape invoices. Downstream total is `Landscape!M24`, and `Gnatt Chart!G18` points to that cell. |

For upgraded Outrigger vendor tabs, align the actual-invoice table header at row 11 when the worksheet structure permits, align the orange template-estimate columns to the actual-invoice table where the worksheet schema allows, and freeze panes below the table header. `Exterior` is an approved layout exception: its 12-row template section requires the actual table header at row 22 and freeze panes at `A23`.

As of 2026-07-14, the formerly held `Appliances`, `Plumbing Fixtures`, `Paint`, `Electrical Fixtures`, and `Landscape` layouts are resolved in the Outrigger prototype. `STR` was removed from this mode because it is not a vendor tab.

## Exterior Conversion Lessons

The Outrigger `Exterior` worksheet was converted on 2026-07-14 after Wes explicitly expanded Vendor Tabs Mode to include it.

- A legacy mixed worksheet may require classifying rows before conversion. In Outrigger Exterior, dated rows were existing actual expenses and undated rows were template estimates. Perform this classification independently for every project and validate it against the project values before migrating data.
- Preserve intentionally blank migrated `Tax` cells when that is required to reconcile the converted actual total to the pre-conversion total.
- Verify the selector's gating cell instead of preserving a stale reference. Outrigger Exterior formerly used blank `Profit!Q6`; the current Vendor Tabs selector standard uses `Profit!W6`.
- A native in-cell checkbox must remain an editable `TRUE`/`FALSE` value, not a formula. Verify the checkbox control type and test both selector states after saving and after replacing the Teams file.
- Keep helper inputs, such as the hourly rate, in the worksheet summary area when possible so the vendor worksheet remains a coherent one-page print layout.
- Reconcile every downstream total before and after conversion. For Outrigger Exterior, the unchecked actual total and `Gnatt Chart!G17` both remained `$3,232.04`.

## Iteration Lessons

- Before reporting a duplicate checkbox, check the cell's full merged area. A single native checkbox in a merged range may appear through more than one cell address during automation inspection.
- Keep undated zero-quantity product candidates out of actual-invoice tables. Preserve dated zero-dollar records when they document real reused materials or other actual activity.
- Do not move structured-table records between workbooks with direct Excel copy operations. That can shift structured formulas or introduce an external workbook link. Transfer source values, then rebuild the destination table's structured formulas and reconcile the exact pre-change total.
- When listing proposed worksheet changes for Wes, include a clickable link to the current local project workbook so he can inspect the worksheet before approval.
- Preserve the selector state saved by Wes in the current working copy. Reconcile both the selected total and its `Gnatt Chart` result immediately before upload.

## 3325 Banks Rd Pilot Lessons

The first side-by-side project rollout was completed for `07_Project Management - 3325 Banks Rd.xlsm` on 2026-07-14.

- For every vendor worksheet, keep the legacy worksheet immediately beside the replacement as `<Worksheet> - Old` until Wes approves removal. The replacement must assume the canonical worksheet name so downstream references can use the stable name.
- Copying a worksheet from the prototype can copy sheet-scoped names that still refer to the prototype workbook. Localizing visible cell formulas is not enough. Inspect and localize workbook-scoped and sheet-scoped names, then require `LinkSources` to be empty before upload.
- Map each legacy worksheet independently. Banks `Electrical Fixtures` used `Description`, `ITEM`, `Quantity`, and `Cost/Unit` in columns A:D, while Banks `Landscape` used a different eight-column layout. Never reuse a positional map from another vendor tab or project without confirming its headers and totals.
- When the legacy total already includes accumulated tax as an expense line, preserve that line in the actual-invoice table and leave the table `Tax` field blank so the migrated total does not add tax twice.
- Preserve unusual legacy accounting until Wes approves normalization. Banks `Paint` contains two `$97.13` tax-related lines; both were retained so the selected total remained `$1,332.94`, and the duplicate was labeled for review.
- Clear prototype-specific option rows from the orange area after copying the design. A visual render is required because stale option rows, misplaced values, and clipped totals can remain even when the actual-invoice total reconciles.
- Set the replacement selector explicitly from the target project's intended state. Banks replacements were set to `No` so Gantt Chart continued to read actual-invoice totals.
- Adding `Review` is separate from the side-by-side vendor-sheet pattern. When the target has no `Review` worksheet, add the canonical sheet once, keep `Review!B1` unchecked, clear `tblInvoiceReview`, and set `invoiceEntryReviewRequest` to `=Review!$B$1`.
- Compare formula errors to the fresh target baseline. Do not treat pre-existing errors elsewhere in the workbook as migration-created errors, but record them in the migration log.

## Project Approval Gate

- After completing and validating one project workbook, replace the approved target file in Teams, verify the new Teams version, and provide Wes a direct clickable Teams link to that workbook.
- Stop after providing the link. Do not begin the next project until Wes has had the opportunity to inspect and approve the completed project.

## 3413 Pinetree Ln Lessons

The side-by-side Vendor Tabs and Review rollout was completed for `17_Project Management - 3413 Pinetree Ln.xlsm` on 2026-07-14.

- A legacy tab may contain a saved total that does not equal the visible contributing detail. Do not silently change the project total. Preserve the approved total with an explicitly labeled reconciliation row, record the reason, and leave the old worksheet beside the replacement for Wes's review. Pinetree `Windows & Doors` retained `$235.81` by mapping the two visible contributing rows and a labeled `$15.43` legacy tax/total adjustment.
- When a target has no dated or contributing rows for a vendor category, keep the actual-invoice table blank. Move only representative undated zero-quantity candidates into the limited orange option area; the adjacent old sheet remains the complete legacy reference until approval.
- Treat misaligned legacy data by meaning, not position. Pinetree `Exterior` stored the mailbox-post item number in the old quantity column; it was mapped to `Item #`, with quantity `1` and cost `$32.98` in the replacement table.
- Preserve intentional non-taxed actual rows by clearing migrated `Tax` cells after rebuilding the table formula columns. Pinetree Flooring and Exterior totals reconcile without adding tax.
- Visual QA must check for prototype labels and column alignment, not only values. Pinetree required removal of a stale `Plumbing` label from `Windows & Doors`, readable description widths, and correction of the Flooring square-foot formula and quantity number format.
- Compare formula-error addresses and formulas to the fresh target baseline. Pinetree's `Docs!E39` `#REF!` and `Profit!L82` `#VALUE!` were identical before and after the Vendor Tabs migration and were not introduced by this mode.

## 1426 Pleasant Garden Ln Lessons

The side-by-side Vendor Tabs and Review rollout was completed for `18_Project Management - 1426 Pleasant Garden Ln.xlsm` on 2026-07-14.

- A project's saved selected total may intentionally differ from its visible quantity-driven detail. Migrate the visible contributing rows, preserve the selected total with a clearly labeled reconciliation row, and flag the difference for Wes rather than silently choosing one interpretation. Pleasant Garden required this treatment for Demo & Trash Haul and Paint.
- Saved vendor quotes may be the project's selected value even when the legacy detail calculates to zero. Preserve the named quote transparently and keep the adjacent old worksheet for review. Pleasant Garden Cabinets used a $4,165.00 AvilaCRI quote, and Flooring used $3,790.00 LVP plus $2,815.00 carpet quote components.
- Do not blindly restore the prototype Tax calculated-column formula after clearing a copied table. If the target's legacy total excludes tax, or if the migrated row already contains the complete intended amount, leave Tax blank. Otherwise the replacement can add 7.25% to a previously reconciled value.
- Do not assume every standard table copied from the prototype has the same Sub-Total formula. Pleasant Garden exposed a Flooring prototype formula that multiplied blank `Sq Ft` by cost and returned zero. Require the standard blank-square-foot fallback where appropriate: quantity times cost when `Sq Ft` is blank, otherwise square feet times quantity times cost.
- Search the entire saved workbook for formulas that reference `<Worksheet> - Old`. Excel automatically follows a renamed source worksheet, so correcting only the first visible Gantt rows can miss shifted project-specific rows. Pleasant Garden also required repointing Landscape, Drainage/Exterior, and HVAC references.
- Reconnect Gantt Chart by its project-specific row labels and business meaning, not by the Outrigger row numbers. Pleasant Garden's HVAC contractor row was lower than Outrigger's because the contractor section contains different rows.

## 115 Rosebrooks Dr Lessons

The side-by-side Vendor Tabs and Review rollout was completed for `20_Project Management - 115 Rosebrooks Dr.xlsm` on 2026-07-14.

- Treat numeric zero as a real mapped value, not as blank. Migration helpers must write `0` into target inputs when the project source explicitly uses zero. Skipping zero can leave a prototype formula active and change the project's behavior.
- Prototype option formulas can assume a model input that is blank for another project type. Rosebrooks is a Flip model, so Paint's square-foot source returned blank text. Outrigger quantity formulas that divided that value produced `#VALUE!` until Rosebrooks zero inputs were written explicitly.
- When a low-activity project has many zero-quantity legacy candidates, move representative choices into the limited orange option area and leave the complete old worksheet adjacent for review. Do not overfill or resize the approved prototype option block merely to duplicate every dormant candidate.
- A zero selected total can still conceal visible legacy detail. Rosebrooks Demo & Trash Haul contained a $1,200.00 removal row while the saved selected total was $0.00. Preserve both facts with an explicit reconciliation row and flag the difference for Wes.
- Validate the actual selected table total at full precision even when the user-facing log rounds to cents. Rosebrooks Appliances reconciled at `$1,646.555625`.

## Native Checkbox Repair Lesson

Rosebrooks required a follow-up repair on 2026-07-14 after the copied Vendor Tab checkboxes did not behave reliably during direct user interaction.

- A copied in-cell checkbox can still report `CellControl.Type = xlTypeCheckbox` and respond to automation while remaining unreliable for the user. Do not treat control-type inspection alone as proof that a copied checkbox works.
- After copying a Vendor Tab into another workbook, rebuild the checkbox formatting in place with Excel's native `CellControl.SetCheckbox`, explicitly unlock the checkbox's full merged area, and restore the project's saved Boolean value.
- Validate after save/reopen and again from the exact Teams-uploaded copy. Test both Boolean states and confirm the visible selector changes between `No` and `Yes`.
- A working checkbox may not change the selected dollar total when both the template and actual branches are zero. Validate the selector text separately from the dollar result so a zero-dollar project does not produce a false failure or false success.
- Do not call `Calculate`, `CalculateFull`, or `CalculateFullRebuild` between checkbox changes during the interaction test. A forced calculation can hide a workbook saved in Manual Calculation mode. Open the saved workbook in a fresh Excel instance, confirm calculation mode is Automatic, change the checkbox, and require the dependent selector to update immediately without `F9`.
- Preserve iterative-calculation settings when changing the workbook from Manual to Automatic calculation. Verify the saved package and the Teams-downloaded copy both retain iteration while no longer declaring `calcMode="manual"`.

## 2325 Cool Springs Rd Lessons

The side-by-side Vendor Tabs and Review rollout was completed for `22_Project Management - 2325 Cool Springs Rd 4.xlsm` on 2026-07-14.

- Protect project-critical worksheets outside the active mode with a before-and-after fingerprint of formulas, constants, used range, and table ranges. Cool Springs `Amortization` remained unchanged throughout this Vendor Tabs migration.
- Reconcile both the selected downstream total and the visible orange template-option detail. A zero selected total does not prove that legacy option values were mapped; visual rendering exposed blank orange rows that numeric total checks could not detect.
- Map compact legacy template rows by field meaning, not by same-column position. Cool Springs legacy tabs placed descriptions, item numbers, quantities, and costs in different columns on Demo, Appliances, Plumbing, Windows, Cabinets, Electrical, Landscape, and Exterior.
- Distinguish item numbers from prices before migration. Cool Springs Exterior stored the Masking Tape and Drop Cloth item numbers in a column otherwise used for cost; those values belong in `Item #`, not `Cost/Unit`.
- When using Excel automation to copy mixed text and numeric values, assign through an explicitly typed intermediate value. Direct chained COM assignments can reject numbers as strings or silently leave fields blank.
- Perform one full rebuild before the final save when needed, then turn off `ForceFullCalculation` and save in Automatic mode. The Teams-downloaded copy must open normally and update selectors without `F9` or an automation calculation command.
- Validate the exact Teams-downloaded replacement, not only the local output. For Cool Springs this included all 11 two-state selector tests, 12 Gantt totals, zero external links, zero canonical formulas pointing to `- Old`, zero migrated-range formula errors, and the unchanged Amortization fingerprint.
