# 2026-07-15 - Lowe's Sweep Backout Log

## Reason

Wes reviewed the latest Lowe's `6140` statement and identified that the direct Invoice Entry OCR sweep missed substantial item detail. Invoice Entry should not have relied on its own OCR for dense scanned Lowe's statements. Wes will resubmit the statements through Doc Scan Lowes Statement Mode.

## Action Taken

Invoice Entry backed out the partial Review rows that were added during the requested multi-account sweep documented in:

`C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\2026-07-15-lowes-remaining-statements-processing-log.md`

The rollback removed only the rows with the following `Review Row ID` values:

| Workbook | Review Row ID removed |
| --- | --- |
| `Property/25_Project Management - 612 Britton Ct.xlsm` | `BRITTON-LOWES-6140-20260202-85635` |
| `Property/26_Project Management - 908 Pond St 3.xlsm` | `POND-LOWES-5997-20260117-93783` |
| `Property/26_Project Management - 908 Pond St 3.xlsm` | `POND-LOWES-5997-20260217-85657` |
| `Property/26_Project Management - 908 Pond St 3.xlsm` | `POND-LOWES-6140-20260202-83033` |
| `Property/27_Project Management - 7001 Outrigger Dr.xlsm` | `OUTRIGGER-LOWES-6140-20260502-85288` |
| `Property/27_Project Management - 7001 Outrigger Dr.xlsm` | `OUTRIGGER-LOWES-6140-20260602-89689` |
| `Property/28_Project Management - 320 Rose Pl.xlsm` | `ROSE-LOWES-6140-20260602-91899` |
| `Property/28_Project Management - 320 Rose Pl.xlsm` | `ROSE-LOWES-6140-20260602-90796` |
| `Property/28_Project Management - 320 Rose Pl.xlsm` | `ROSE-LOWES-6140-20260602-75497` |

No vendor-tab rows were involved in this backout because the sweep had inserted only Review rows.

## Validation

After deletion and Excel reopen:

- all nine backout `Review Row ID` values were absent,
- `tblInvoiceReview` still existed in each workbook,
- `invoiceEntryReviewRequest` still reopened as `=Review!$B$1`,
- Excel reported zero external workbook links in each workbook.

The cleaned workbooks were uploaded back to the same SharePoint targets.

## Current Status

The direct OCR sweep is superseded. The source statements should be reprocessed through Doc Scan Lowes Statement Mode, which owns statement OCR and item-level extraction.
