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

## 2026-07-15 - Requested Remaining 2026 Lowe's Statements

- Processing log: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\2026-07-15-lowes-remaining-statements-processing-log.md`
- Working extraction folder: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\lowes-statements-2026-requested-20260715`

The following details were seen during the requested two-account sweep but were not inserted into project workbooks. Rows with confident project placement were routed to the applicable project workbook `Review` table and are listed in the processing log.

| Statement account | Statement closing date | Source statement path | Ref # / group | PO / project clue | Description | Amount | Line type | Recommended project/property | Confidence/status | Hold reason | Later action/status |
| --- | --- | --- | --- | --- | --- | ---: | --- | --- | --- | --- | --- |
| `5997` | 2026-02-17 | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Credit Cards\Lowe's PRO BYH 5997\26-02-17 .pdf` | `70285`, `70317`, `78776`, `87522`, `93083`, `93086`, `93059`, `75063`, `91665` | mixed or OCR-unclear | February statement transaction detail with uncertain PO/project or uncertain item split | OCR unclear | Charge/credit items | Needs Review | Needs Review - OCR / Project / Item split | Not reliable enough for project Review insertion from OCR. | Held for Doc Scan/item-level rework or manual review. |
| `5997` | 2026-02-17 | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Credit Cards\Lowe's PRO BYH 5997\26-02-17 .pdf` | `74677` | Home | Home/non-project transaction detail | 44.06 | Charge item | Home / non-project | Non-project/Home | Home row; no project workbook destination. | Held outside project workbooks. |
| `5997` | 2026-04-17 | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Credit Cards\Lowe's PRO BYH 5997\26-04-17 .pdf` | statement activity | n/a | Payment/interest-only statement activity; no project purchase detail found | n/a | Payment/interest | n/a | Excluded | Not a project purchase row. | No workbook action. |
| `6140` | 2026-01-02 | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Credit Cards\Lowe's Pro-SYH-6140\26-01-02.pdf` | statement activity | n/a | Payment-only statement activity; no project purchase detail found | n/a | Payment | n/a | Excluded | Not a project purchase row. | No workbook action. |
| `6140` | 2026-03-02 | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Credit Cards\Lowe's Pro-SYH-6140\26-03-02 .pdf` | `81460`, `93536`, `82993`, `82224`, `89225`, `82978`, `88582`, `78928`, `96029` | OCR suggests possible `7001` on multiple rows | March statement transaction detail, likely mixed vendor-tab items | 14.74 to 974.69 | Charge items | Needs Review - likely Outrigger on some rows | Needs Review - OCR / Project / Item split | Dense OCR was not reliable enough for project Review insertion or item-level vendor-tab preparation. | Held for Doc Scan/item-level rework or manual review. |
| `6140` | 2026-04-02 | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Credit Cards\Lowe's Pro-SYH-6140\26-04-02.pdf` | `81881`, `80280`, `87683`, `88058`, `89715`, `89716`, `76314`, `91875`, `95184`, `84348`, `77621`, `82923`, `89698`, `84750`, `88578`, `73005`, `78019`, `85211`, `97863` | OCR suggests possible `7001` on multiple rows | April statement transaction detail, mixed items | 6.09 to 1604.78 | Charge items | Needs Review - likely Outrigger on some rows | Needs Review - OCR / Project / Item split | Dense OCR was not reliable enough for project Review insertion or item-level vendor-tab preparation. | Held for Doc Scan/item-level rework or manual review. |
| `6140` | 2026-05-02 | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Credit Cards\Lowe's Pro-SYH-6140\26-05-02 - Lowe's Pro.pdf` | `79632`, `75134`, `72473`, `83893`, `88825`, `73472`, returns/credits | mixed or OCR-unclear | May statement detail not confidently tied to one project or item-level allocation | 25.24 to 2449.68 | Charge/credit items | Needs Review | Needs Review - OCR / Project / Item split | Project and item allocation need review before workbook insertion. | Held for Doc Scan/item-level rework or manual review. |
| `6140` | 2026-06-02 | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Credit Cards\Lowe's Pro-SYH-6140\26-06-02 - Lowe's Pro - 6140.pdf` | `93549`, `81286`, `30231`, `83130`, `99831`, `74807`, `78157`, `79804`, credits | mixed or OCR-unclear | June statement page 2 detail not confidently tied to project/item split | 9.53 to 310.87 | Charge/credit items | Needs Review | Needs Review - OCR / Project / Item split | Project and item allocation need review before workbook insertion. | Held for Doc Scan/item-level rework or manual review. |
| `6140` | 2026-06-02 | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Credit Cards\Lowe's Pro-SYH-6140\26-06-02 - Lowe's Pro - 6140.pdf` | `77590` | Home | Home transaction detail | 42.25 | Charge item | Home / non-project | Non-project/Home | Home row; no project workbook destination. | Held outside project workbooks. |
