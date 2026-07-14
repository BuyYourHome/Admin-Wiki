# Lowes Statement Held Detail Register

Use this register for Lowe's statement detail that Invoice Entry has seen but cannot yet insert into a project workbook or vendor table.

Retain rows here when they are Home/non-project, accounting-review, unclear-project, belong to a project whose workbook is not ready, or otherwise cannot yet be inserted. Do not use this register as an approval source; it is a retention and traceability queue.

When a held row is later imported, update its status and reference the processing log that moved it.

## Required Retention Fields

- Statement account or suffix
- Statement closing date
- Source packet path
- Source statement path
- Packet row
- Transaction date
- Reference number
- Store
- PO/project clue
- SKU/item number, if available
- Description
- Amount
- Line type
- Recommended project/property, if any
- Recommended workbook, if any
- Confidence/status
- Hold reason
- Later action/status

## 2026-03-17 - Lowe's PRO BYH 5997

- Source packet: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\sources\document-scan-packets\2026-03-17 - Lowes PRO BYH 5997 - Item-Level Packet.md`
- Source statement: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Credit Cards\Lowe's PRO BYH 5997\26-03-17 .pdf`
- Statement account suffix: `5997`
- Statement closing date: 2026-03-17
- Processing logs:
  - `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\statement-mode-lowes-5997-2026-03-17-processing-log.md`
  - `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\2026-07-14-outrigger-review-request-followup-log.md`

| Packet row | Tran date | Ref # | Store | PO / project clue | SKU | Description | Amount | Type | Recommended project/property | Recommended workbook | Confidence/status | Hold reason | Later action/status |
| --- | --- | --- | --- | --- | --- | --- | ---: | --- | --- | --- | --- | --- | --- |
| 3 | 2026-02-18 | `74298` | `444` | Printed PO `7001` | n/a | Sales tax for ref `74298` | 3.63 | Tax | `27-HM- 7001 Outrigger Dr` | Outrigger workbook | Needs Review - Allocation / Vendor Tab | Sales-tax-only line; tax is handled later by approved spreadsheet method. | Held, not inserted. |
| 7 | 2026-02-17 | `83160` | `907` | Printed PO `7001` | n/a | Sales tax for ref `83160` | 4.67 | Tax | `27-HM- 7001 Outrigger Dr` | Outrigger workbook | Ready for Invoice Entry duplicate check; Review-first | Sales-tax-only line; tax is handled later by approved spreadsheet method. | Held, not inserted. |
| 10 | 2026-02-17 | `91816` | `907` | Printed PO `7001` | n/a | Sales tax for ref `91816` | 38.06 | Tax | `27-HM- 7001 Outrigger Dr` | Outrigger workbook | Ready for Invoice Entry duplicate check; Review-first | Sales-tax-only line; tax is handled later by approved spreadsheet method. | Held, not inserted. |
| 12 | 2026-03-03 | `76164` | `1095` | Printed PO `7001` | n/a | Sales tax credit for ref `76164` | -0.91 | Tax credit | `27-HM- 7001 Outrigger Dr` | Outrigger workbook | Ready for Invoice Entry duplicate check; Review-first | Tax-credit-only line; tax is handled later by approved spreadsheet method. | Held, not inserted. |
| 13 | 2026-02-25 | `94293` | `444` | Printed PO `home` | `000000000283875` | 1.50-GAL PANSY HB | 14.26 | Charge item | Home / non-project | blank | Non-project/Home | Home/non-project detail; no project workbook destination. | Held outside project workbooks. |
| 14 | 2026-02-25 | `94293` | `444` | Printed PO `home` | `000000001497748` | 3.00-QT TULIP WOOD BOX BT | 12.33 | Charge item | Home / non-project | blank | Non-project/Home | Home/non-project detail; no project workbook destination. | Held outside project workbooks. |
| 15 | 2026-02-25 | `94293` | `444` | Printed PO `home` | `000000001152267` | 1.50-PT DIANTHUS ERLY BRD | 12.32 | Charge item | Home / non-project | blank | Non-project/Home | Home/non-project detail; no project workbook destination. | Held outside project workbooks. |
| 16 | 2026-02-25 | `94293` | `444` | Printed PO `home` | n/a | Sales tax for ref `94293` | 2.82 | Tax | Home / non-project | blank | Non-project/Home | Home/non-project tax detail; no project workbook destination. | Held outside project workbooks. |
| 21 | 2026-03-05 | `84314` | `1095` | Handwritten `7001`; printed PO not reliable | n/a | VISA credit component | 63.80 | Credit component | Needs Review - Project | blank | Needs Review - Allocation | Allocation and project handling need review. | Held; not inserted into vendor table. |
| 22 | 2026-03-05 | `84314` | `1095` | Handwritten `7001`; printed PO not reliable | n/a | Sales tax credit for ref `84314` | -14.13 | Tax credit | Needs Review - Project | blank | Needs Review - Mixed Tab / Allocation | Tax-credit-only and allocation uncertain. | Held; not inserted. |
| 24 | 2026-03-06 | `94895` | `444` | Printed PO `na`; handwritten `? 7001` | n/a | Sales tax for ref `94895` | 0.47 | Tax | Needs Review - Project | blank | Needs Review - PO conflict / Allocation | Tax-only line and PO conflict. | Held; not inserted. |
| 25 | 2026-03-17 | n/a | n/a | No project clue | n/a | Interest charge | 66.27 | Interest | Accounting review | blank | Accounting Review | Statement finance charge; not a project purchase item without accounting direction. | Held for accounting direction. |

### Rows Retained Elsewhere

The following statement rows are not in this held-detail table because they are retained in the Outrigger workbook `Review` table or have been moved from Review into vendor tables:

- Rows moved to vendor tables: packet rows 1, 4, 5, 6, 8, 9, 11, 17, 18, 19, 20, and 23.
- Row retained in Outrigger `Review`: packet row 2, currently destination `Exterior`, excluded from movement because `Exterior` is outside approved Vendor Tabs Mode scope.
