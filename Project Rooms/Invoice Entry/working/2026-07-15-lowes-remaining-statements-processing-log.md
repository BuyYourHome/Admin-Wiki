# 2026-07-15 - Lowe's Remaining 2026 Statements Processing Log

## Request

Wes asked Invoice Entry to process the remaining 2026 Lowe's statements from both Lowe's accounts now that all projects are ready for Lowe's mode.

## Source Statements Reviewed

- `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Credit Cards\Lowe's PRO BYH 5997\26-01-17 .pdf`
- `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Credit Cards\Lowe's PRO BYH 5997\26-02-17 .pdf`
- `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Credit Cards\Lowe's PRO BYH 5997\26-03-17 .pdf`
- `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Credit Cards\Lowe's PRO BYH 5997\26-04-17 .pdf`
- `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Credit Cards\Lowe's Pro-SYH-6140\26-01-02.pdf`
- `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Credit Cards\Lowe's Pro-SYH-6140\26-02-02 .pdf`
- `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Credit Cards\Lowe's Pro-SYH-6140\26-03-02 .pdf`
- `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Credit Cards\Lowe's Pro-SYH-6140\26-04-02.pdf`
- `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Credit Cards\Lowe's Pro-SYH-6140\26-05-02 - Lowe's Pro.pdf`
- `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Credit Cards\Lowe's Pro-SYH-6140\26-06-02 - Lowe's Pro - 6140.pdf`

The March 2026 statement for account `5997` had already been processed earlier and was not re-imported.

## Teams Workbooks Updated

Invoice Entry retrieved fresh copies through the SharePoint connector, created rollback copies, edited the `tblInvoiceReview` Review table through Excel, validated the files, and uploaded the validated copies back to the same SharePoint targets.

| Workbook | Rows added to Review |
| --- | ---: |
| `Property/25_Project Management - 612 Britton Ct.xlsm` | 1 |
| `Property/26_Project Management - 908 Pond St 3.xlsm` | 3 |
| `Property/27_Project Management - 7001 Outrigger Dr.xlsm` | 2 |
| `Property/28_Project Management - 320 Rose Pl.xlsm` | 3 |

## Review Rows Added

All rows were placed in the project `Review` table first. No Lowe's statement row was inserted directly into a vendor tab during this pass.

| Project | Review Row ID | Statement | Invoice/ref # | Date | Amount | Destination Worksheet | Status |
| --- | --- | --- | --- | --- | ---: | --- | --- |
| 25-401K- 612 Britton Ct | `BRITTON-LOWES-6140-20260202-85635` | 6140 closing 2026-02-02 | `85635` | 2026-01-21 | 669.38 | blank | Needs Review - Lowes Statement |
| 26-BYH -908 Pond St | `POND-LOWES-5997-20260117-93783` | 5997 closing 2026-01-17 | `93783` | 2026-01-09 | 64.94 | blank | Needs Review - Lowes Statement |
| 26-BYH -908 Pond St | `POND-LOWES-5997-20260217-85657` | 5997 closing 2026-02-17 | `85657` | 2026-01-21 | 669.38 | blank | Needs Review - Lowes Statement |
| 26-BYH -908 Pond St | `POND-LOWES-6140-20260202-83033` | 6140 closing 2026-02-02 | `83033` | 2026-01-20 | 55.33 | blank | Needs Review - Lowes Statement |
| 27-HM- 7001 Outrigger Dr | `OUTRIGGER-LOWES-6140-20260502-85288` | 6140 closing 2026-05-02 | `85288` | 2026-04-02 | 40.85 | blank | Needs Review - Lowes Statement |
| 27-HM- 7001 Outrigger Dr | `OUTRIGGER-LOWES-6140-20260602-89689` | 6140 closing 2026-06-02 | `89689` | 2026-05-30 | 43.51 | Electrical Fixtures | Needs Review - Lowes Statement |
| 28-SYH-320 Rose Pl | `ROSE-LOWES-6140-20260602-91899` | 6140 closing 2026-06-02 | `91899` | 2026-05-16 | 22.37 | blank | Needs Review - Lowes Statement |
| 28-SYH-320 Rose Pl | `ROSE-LOWES-6140-20260602-90796` | 6140 closing 2026-06-02 | `90796` | 2026-05-16 | 82.49 | blank | Needs Review - Lowes Statement |
| 28-SYH-320 Rose Pl | `ROSE-LOWES-6140-20260602-75497` | 6140 closing 2026-06-02 | `75497` | 2026-05-19 | 20.35 | blank | Needs Review - Lowes Statement |

## Duplicate Checks

Before insertion, Invoice Entry searched each target workbook for the candidate invoice/reference numbers. No existing workbook matches were found for the nine added Review rows.

## Excluded Or Retained Detail

- `5997` closing 2026-04-17: no project purchase rows found; payment/interest activity only.
- `6140` closing 2026-01-02: no project purchase rows found; payment activity only.
- Home/non-project rows stayed out of project workbooks.
- Sales-tax-only, tax-credit-only, finance charge, payment, and accounting-only rows stayed out of project workbooks.
- Dense OCR rows from `6140` March, `6140` April, parts of `6140` May, parts of `6140` June, and uncertain rows from `5997` February were retained for later review rather than inserted from unreliable item-level extraction.

## Validation

Validated after Excel reopen:

- `tblInvoiceReview` contained all expected new Review Row IDs.
- `invoiceEntryReviewRequest` still reopened as `=Review!$B$1`.
- Excel reported zero external workbook links in each updated workbook.
- Rollback copies were created before editing under `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\lowes-statements-2026-requested-20260715\rollback-copies`.

## Notes

The source statement PDFs are scanned/image-based. Direct PDF text extraction was not reliable, so Invoice Entry used rendered-page OCR and visual review. Rows that could not be tied to project and item detail with enough confidence were intentionally retained instead of inserted.
