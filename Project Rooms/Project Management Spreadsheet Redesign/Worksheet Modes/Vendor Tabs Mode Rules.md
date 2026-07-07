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

`C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Redesign\working\profit-mode\full-profit-rerun-outrigger-20260707\27_Project Management - 7001 Outrigger Dr.current.xlsm`

Before editing or uploading an active workbook, follow the project-management spreadsheet rules for confirming the exact target workbook, verifying the current SharePoint/Teams source, making rollback copies, and validating the saved workbook.

## Actual-Invoice Table Pattern

The Outrigger `Flooring` tab now uses the first approved actual-invoice table pattern.

Current pilot table:

- Workbook: `Property/27_Project Management - 7001 Outrigger Dr.xlsm`
- Worksheet: `Flooring`
- Table name: `tblFlooringInvoices`
- Table range: `Flooring!A7:H20`
- Columns: `Date`, `Description`, `Sq Ft`, `Item #`, `Qty`, `Cost/Unit`, `Sub-Total`, `Tax`

Pattern rules:

- The table replaces the loose yellow actual-invoice entry block for the pilot worksheet.
- Keep orange template-estimate rows separate from the table.
- Preserve the worksheet selector behavior. For the pilot, `Flooring!I21` sums the table only when `Flooring!L1` is `No`.
- Formula columns should use structured references rather than row-only formulas.
- Preserve yellow fill for user-entry cells and protected/formula color conventions for calculated cells.
- Do not roll this table pattern to the rest of Vendor Tabs Mode until Wes approves the pilot behavior.
