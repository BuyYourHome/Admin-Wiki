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
