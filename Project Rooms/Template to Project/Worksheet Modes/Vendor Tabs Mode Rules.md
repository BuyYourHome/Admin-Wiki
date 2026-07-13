# Vendor Tabs Mode Rules

Use these rules when designing, repairing, or rolling out the vendor-tab group in Buy Your Home project-management spreadsheets.

## Mode Scope

Vendor Tabs mode is a grouped worksheet mode. The included tabs should work exactly the same as one another and should be updated as a coordinated set.

The first workbook for Vendor Tabs mode changes is the Outrigger project workbook. After the Outrigger tabs are complete and approved, migrate the same Vendor Tabs mode changes to the other active project workbooks.

## Included Tabs

The Vendor Tabs mode group starts with `Demo & Trash Haul` and continues to the right through `Landscape`.

Current Vendor Tabs mode list:

1. `Demo & Trash Haul`
2. `Appliances`
3. `Plumbing Fixtures`
4. `Windows & Doors`
5. `Cabinets`
6. `Paint`
7. `Flooring`
8. `HVAC`
9. `Electrical Fixtures`
10. `STR`
11. `Landscape`

Do not include tabs to the right of `Landscape`, such as `Exterior` or `Furnishing`, in this mode unless Wes explicitly expands the Vendor Tabs mode scope.

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

For upgraded Outrigger vendor tabs, align the actual-invoice table header at row 11, align the orange template-estimate columns to the actual-invoice table where the worksheet schema allows, and freeze panes at `A12` so row 11 remains visible while entering actual-invoice rows.

Held for Wes/design review before table conversion:

- `Appliances`: template and actual rows are blended with subtotals inside the yellow area.
- `Plumbing Fixtures`: actual block is shifted right and has inconsistent date placement.
- `Paint`: materially different column layout with color, square feet, item, quantity, and cost/unit.
- `Electrical Fixtures`: current actual area lacks a date column.
- `Landscape`: no clear Flooring-style actual-invoice yellow block is present yet.
- `STR`: remains a special case until Wes approves its final design.
