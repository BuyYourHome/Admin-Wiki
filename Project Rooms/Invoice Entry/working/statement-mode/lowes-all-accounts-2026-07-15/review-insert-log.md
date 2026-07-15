# 2026-07-15 - Lowe's All-Accounts Review Insert Log

## Request

After the initial held-only processing, Wes instructed Invoice Entry to add entries to the project spreadsheets so he can review them from the workbook Review tabs.

## Action Taken

Invoice Entry inserted Review-table rows only. No vendor-tab rows were inserted.

Updated Teams/SharePoint workbooks:

- `Property/26_Project Management - 908 Pond St 3.xlsm`
- `Property/27_Project Management - 7001 Outrigger Dr.xlsm`
- `Property/28_Project Management - 320 Rose Pl.xlsm`

`invoiceEntryReviewRequest` was not set to `TRUE`; these rows are for Wes review, not approved movement to vendor tables.

## Review Rows Added

| Workbook | Rows added |
| --- | ---: |
| `26_Project Management - 908 Pond St 3.xlsm` | 2 |
| `27_Project Management - 7001 Outrigger Dr.xlsm` | 3 |
| `28_Project Management - 320 Rose Pl.xlsm` | 11 |

### 908 Pond

- `POND-LOWES-5997-20260117-93783-DOCSCAN`
- `POND-LOWES-6140-20260202-83033-DOCSCAN`

### Outrigger

- `OUTRIGGER-LOWES-6140-20260302-78928-DOCSCAN`
- `OUTRIGGER-LOWES-6140-20260502-85288-DOCSCAN`
- `OUTRIGGER-LOWES-6140-20260602-89689-DOCSCAN`

### 320 Rose

- `ROSE-LOWES-6140-20260602-93549-DOCSCAN`
- `ROSE-LOWES-6140-20260602-81286-DOCSCAN`
- `ROSE-LOWES-6140-20260602-80231-DOCSCAN`
- `ROSE-LOWES-6140-20260602-99831-DOCSCAN`
- `ROSE-LOWES-6140-20260602-74807-DOCSCAN`
- `ROSE-LOWES-6140-20260602-78157-DOCSCAN`
- `ROSE-LOWES-6140-20260602-79804-DOCSCAN`
- `ROSE-LOWES-6140-20260602-UNKNOWN-2545-DOCSCAN`
- `ROSE-LOWES-6140-20260602-91899-DOCSCAN`
- `ROSE-LOWES-6140-20260602-90796-DOCSCAN`
- `ROSE-LOWES-6140-20260602-75497-DOCSCAN`

## Validation

Before upload, Invoice Entry reopened each edited workbook through Excel and confirmed:

- all expected Review Row IDs were present,
- `invoiceEntryReviewRequest` still reopened as `=Review!$B$1`,
- Excel reported zero external workbook links.

The validated workbooks were uploaded back to the same SharePoint targets.

## Limits

Rows remain `Needs Review - Lowes Statement`. Many are incomplete-source review rows because Doc Scan reported image-only scans, OCR uncertainty, and possible missing statement detail pages. These rows are not approved for vendor-tab movement until Wes reviews and supplies or confirms destination worksheet decisions.
