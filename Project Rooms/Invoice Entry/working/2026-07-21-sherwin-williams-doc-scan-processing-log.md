# 2026-07-21 Sherwin-Williams Doc Scan Processing Log

## Source

- Packet: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\sources\doc-scan-packets\doc-scan-sherwin-williams-20260721-20260721-100857.json`
- Intake workflow: Doc Scan
- Records: 2 Sherwin-Williams invoices

## Workbook Resolution

Doc Scan recommended `30 Year Investment.xlsx` files inside the individual property folders. Invoice Entry did not use those as project-management workbook targets because active project-management spreadsheets live at the Teams/SharePoint `Property` root.

- Rose target used: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\28_Project Management - 320 Rose Pl.xlsm`
- Outrigger target reviewed: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27_Project Management - 7001 Outrigger Dr.xlsm`

## Rose Invoice `1780-6`

- Project/property: `28-SYH-320 Rose Pl`
- Filed invoice: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\28-SYH-320 Rose Pl\Owning\26-05-11 - Sherwin-Williams - 1780-6.pdf`
- Destination: `Paint` / `tblPaintInvoices`
- Duplicate check: no workbook hit for invoice `1780-6`, amount `$43.83`, or same Sherwin invoice in `tblPaintInvoices`.
- Inserted row: `Paint!A19:J19`
- Values inserted:
  - Group: `Cabinet Paint`
  - Date: `2026-05-11`
  - Vendor: `Sherwin-Williams`
  - Description: `Inv 1780-6 - Emerald UTE SA HHW custom white cabinet match; product 6511-99556; 25% discount included`
  - Item #: `6511-99556`
  - Qty: `1`
  - Cost/Unit: `$40.87`
  - Sub-Total and Tax: existing table formulas retained.
- Validation:
  - Workbook reopened read-only cleanly after save.
  - `Paint!M13` = `$8,377.04` (`8377.036775` exact formula value).
  - `Gnatt Chart!F19 = Paint!M13` and `Gnatt Chart!G19 = +E19*F19`, both evaluating to `8377.036775`.
  - External link count: `0`.
  - Calculation mode: Automatic.

## Outrigger Invoice `5830-5`

- Project/property: `27-HM- 7001 Outrigger Dr`
- Filed invoice: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27-HM- 7001 Outrigger Dr\Owning\26-01-27 - Sherwin-Williams - 5830-5.pdf`
- Held status: duplicate risk.
- Reason: pre-existing file `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27-HM- 7001 Outrigger Dr\Owning\26-01-27 Sherwin Williams.pdf` extracts to the same invoice text as the newly filed scan: invoice `5830-5`, date `01/27/2026`, subtotal `$35.88`, tax `$2.60`, charge `$38.48`.
- Workbook note: `tblPaintInvoices` did not show a dedicated `5830-5` invoice-number row, but the duplicate source evidence is strong enough to hold insertion for Wes review.

## Rollback

- Rose rollback copy: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\backups\20260721-1015-sherwin-williams-rose-paint\rollback - 28_Project Management - 320 Rose Pl before Sherwin Williams 1780-6.xlsm`

## Connector Note

The SharePoint connector tools visible in this session allowed upload/update but did not expose workbook download/listing. The edit was made to the Teams-synced local `Property` root workbook after workbook identity resolution and rollback creation.
