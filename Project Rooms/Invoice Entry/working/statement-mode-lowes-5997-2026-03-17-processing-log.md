# Lowes Statement Mode Processing Log - 2026-03-17 Statement

## Source

- Superseded packet: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\sources\document-scan-packets\2026-03-17 - Lowes PRO BYH 5997 - Statement Allocation Test.md`
- Revised project-first packet: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\sources\document-scan-packets\2026-03-17 - Lowes PRO BYH 5997 - Revised Project-First Packet.md`
- Statement PDF: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Credit Cards\Lowe's PRO BYH 5997\26-03-17 .pdf`
- Target workbook: `Property/27_Project Management - 7001 Outrigger Dr.xlsm`
- Work copy: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\statement-mode\lowes-5997-2026-03-17\27_Project Management - 7001 Outrigger Dr.lowes-5997-2026-03-17.20260708-140429.xlsm`
- Rollback copy: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\backups\27_Project Management - 7001 Outrigger Dr.before-lowes-5997-2026-03-17-20260708-140429.xlsm`

## Supersession

The initial partial vendor-tab insertion was superseded on 2026-07-08 after Wes approved the Lowes Review-first rule. The live Teams/SharePoint workbook was reverted from the pre-Lowes rollback copy and reprocessed so that every extracted Lowes statement item is in `Review` first. No Lowes statement lines remain directly inserted in `Plumbing Fixtures`.

Review-first work copy: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\statement-mode\lowes-5997-2026-03-17-review-first\27_Project Management - 7001 Outrigger Dr.lowes-5997-review-first.20260708-142327.xlsm`

## Final Hold Pending New Doc Scan Consumables

On 2026-07-08, Wes decided not to keep statement lines that do not belong to Outrigger inside the Outrigger workbook `Review` table. The live Teams/SharePoint workbook was reverted again from the same pre-Lowes rollback copy and no Lowes statement lines remain in the workbook.

Current state: waiting for Doc Scan to provide revised line-item Statement Mode consumables that support project-first routing before Invoice Entry reprocesses this statement.

Final revert source: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\backups\27_Project Management - 7001 Outrigger Dr.before-lowes-5997-2026-03-17-20260708-140429.xlsm`

## Revised Project-First Packet Processing

On 2026-07-08, Doc Scan delivered a revised project-first packet. Invoice Entry consumed that revised packet and placed only the high-confidence Outrigger lines into the Outrigger workbook `Review` table. No Lowes statement line was inserted directly into a vendor tab.

Work copy: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\statement-mode\lowes-5997-2026-03-17-project-first\27_Project Management - 7001 Outrigger Dr.lowes-project-first.20260708-150140.xlsm`

Rows added to `Review`:

| Statement line | Ref | Amount | Destination Worksheet | Status |
| --- | --- | ---: | --- | --- |
| 1 | `83160` | 69.18 | Plumbing Fixtures | Ready for review-copy to destination |
| 2 | `91816` | 521.61 | Plumbing Fixtures | Ready for review-copy to destination |
| 3 | `74298` | 53.66 |  | Needs Review - Vendor Tab |
| 5 | `76164` | -13.49 | Plumbing Fixtures | Ready for review-copy to destination |

Rows intentionally left out of Outrigger:

| Statement line | Ref | Amount | Reason |
| --- | --- | ---: | --- |
| 4 | `94293` | 41.73 | Home/non-project |
| 6 | `84314` | -145.25 | Mixed-tab credit with unclear project proof |
| 7 | `94895` | 6.99 | PO conflict; printed PO `na` with handwritten `7001` uncertainty |
| 8 | Interest | 66.27 | Accounting review |

## Duplicate Check

- Searched workbook for refs `83160`, `91816`, `74298`, `94293`, `76164`, `84314`, and `94895`.
- No exact workbook matches were found for refs `83160`, `91816`, or `76164`.
- Existing workbook has an unrelated `$6.99` Plumbing Fixtures row, so statement line `94895` was routed to Review with its PO conflict instead of inserted.

## Superseded Initial Inserted Lines

The first pass inserted these lines into `Plumbing Fixtures`, `tblPlumbingFixturesInvoices`, rows 29 through 31. That insertion has been reverted in the live workbook:

| Statement line | Date | Ref | Vendor | Description | Amount | Tax |
| --- | --- | --- | --- | --- | ---: | ---: |
| 1 | 2026-02-17 | `83160` | Lowes | Install kit-electric WH; delivery/shipping; 24-in plastic WH drain pan | 69.18 | 0 |
| 2 | 2026-02-17 | `91816` | Lowes | AOS 50-gal 6-year electric tall water heater; delivery/shipping | 521.61 | 0 |
| 5 | 2026-03-03 | `76164` | Lowes | Return/credit for 24-in plastic WH drain pan | -13.49 | 0 |

Tax was left at `0` because statement transaction amounts are already statement totals, not untaxed item subtotals.

## Final Review-First Routing

After reprocessing, all eight extracted Lowes statement rows were added to `Review`. `Destination Worksheet` was filled only where the destination was confident:

| Statement line | Ref | Amount | Destination Worksheet | Status |
| --- | --- | ---: | --- | --- |
| 1 | `83160` | 69.18 | Plumbing Fixtures | Ready for review-copy to destination |
| 2 | `91816` | 521.61 | Plumbing Fixtures | Ready for review-copy to destination |
| 3 | `74298` | 53.66 |  | Needs Review - Vendor Tab |
| 4 | `94293` | 41.73 |  | Needs Review - Non-project/Home |
| 5 | `76164` | -13.49 | Plumbing Fixtures | Ready for review-copy to destination |
| 6 | `84314` | -145.25 |  | Needs Review - Mixed Vendor Tabs / PO clarity |
| 7 | `94895` | 6.99 |  | Needs Review - PO conflict |
| 8 | Interest | 66.27 |  | Needs Review - Statement-level charge |

## Validation

- `Plumbing Fixtures!L14`: `1560.044975`
- `Plumbing Fixtures!L16`: `1560.044975`
- `Gnatt Chart!G10`: `1560.044975`
- `Review` table rows after update: `6`
- Workbook links: `0`
- External link package parts: `0`
- SharePoint upload completed: 2026-07-08 18:12 UTC, size `807506`

## Review-First Reprocess Validation

- `Review` table rows after update: `9`
- `Plumbing Fixtures!L14`: `982.744975`
- `Plumbing Fixtures!L16`: `982.744975`
- `Gnatt Chart!G10`: `982.744975`
- Workbook links: `0`
- External link package parts: `0`
- SharePoint upload completed: 2026-07-08 18:26 UTC, size `806074`

## Final Revert Validation

- `Review` table rows after revert: `1`
- `Plumbing Fixtures!L14`: `982.744975`
- `Plumbing Fixtures!L16`: `982.744975`
- `Gnatt Chart!G10`: `982.744975`
- Workbook links: `0`
- SharePoint upload completed: 2026-07-08 18:48 UTC, size `805516`

## Revised Project-First Validation

- Duplicate check before write found no existing workbook hits for refs `83160`, `91816`, `74298`, `76164`, `94293`, `84314`, or `94895`.
- After write, refs `83160`, `91816`, `74298`, and `76164` appeared only in `Review`.
- Refs `94293`, `84314`, and `94895` were not found in the workbook.
- `Review` table rows after update: `5`
- `Plumbing Fixtures!L14`: `982.744975`
- `Plumbing Fixtures!L16`: `982.744975`
- `Gnatt Chart!G10`: `982.744975`
- Workbook links: `0`
- External link package parts: `0`
- SharePoint upload completed: 2026-07-08 19:08 UTC, size `805387`

## Reverted Pending Item-Level Doc Scan Package

On 2026-07-08, Wes determined the revised project-first packet still summarized some Lowe's receipt/ref lines too broadly. Specifically, statement line 1 should have been split into three item-level Review rows, and statement line 2 should have been split into two item-level Review rows.

The live Teams/SharePoint workbook was reverted to the pre-project-first insertion copy. No Lowe's statement rows from the revised project-first packet remain in the Outrigger workbook.

Current state: waiting for Doc Scan to send a new item-level Lowe's Statement Mode package.

Final revert source: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\statement-mode\lowes-5997-2026-03-17-project-first\27_Project Management - 7001 Outrigger Dr.sharepoint-current.20260708-150140.xlsm`

Final revert validation:

- `Review` table rows after revert: `1`
- `Plumbing Fixtures!L14`: `982.744975`
- `Plumbing Fixtures!L16`: `982.744975`
- `Gnatt Chart!G10`: `982.744975`
- Workbook links: `0`
- SharePoint upload completed: 2026-07-08 19:53 UTC, size `805516`

## Item-Level Packet Processing

On 2026-07-08, Doc Scan delivered the item-level Lowes packet. Invoice Entry consumed that packet and placed only packet rows 1-12, the high-confidence Outrigger rows, into the Outrigger workbook `Review` table. No Lowes statement item was inserted directly into a vendor tab.

Packet: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\sources\document-scan-packets\2026-03-17 - Lowes PRO BYH 5997 - Item-Level Packet.md`

Work copy: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\statement-mode\lowes-5997-2026-03-17-item-level\27_Project Management - 7001 Outrigger Dr.lowes-item-level.20260708-160244.xlsm`

Rows added to `Review`:

| Packet row | Ref | Item | Amount | Destination Worksheet | Status |
| --- | --- | --- | ---: | --- | --- |
| 1 | `74298` | PFJCRWN L49 3-5/8-INX9/16 | 40.74 |  | Needs Review - Vendor Tab |
| 2 | `74298` | 2-8-8 TOP CHOICE #2 SYP P | 9.29 |  | Needs Review - Vendor Tab |
| 3 | `74298` | Sales tax for ref `74298` | 3.63 |  | Needs Review - Allocation / Vendor Tab |
| 4 | `83160` | INSTALL KIT-ELECTRIC WH | 31.93 | Plumbing Fixtures | Ready for review-copy to destination |
| 5 | `83160` | Delivery and Shipping | 20.00 | Plumbing Fixtures | Ready for review-copy to destination |
| 6 | `83160` | 24-IN PLASTIC WH DRAIN PA | 12.58 | Plumbing Fixtures | Ready for review-copy to destination |
| 7 | `83160` | Sales tax for ref `83160` | 4.67 | Plumbing Fixtures | Ready for review-copy to destination |
| 8 | `91816` | AOS 50-GAL 6YR ELEC TALL | 483.55 | Plumbing Fixtures | Ready for review-copy to destination |
| 9 | `91816` | Delivery and Shipping | 0.00 | Plumbing Fixtures | Ready for review-copy to destination |
| 10 | `91816` | Sales tax for ref `91816` | 38.06 | Plumbing Fixtures | Ready for review-copy to destination |
| 11 | `76164` | 24-IN PLASTIC WH DRAIN PA | -12.58 | Plumbing Fixtures | Ready for review-copy to destination |
| 12 | `76164` | Sales tax credit for ref `76164` | -0.91 | Plumbing Fixtures | Ready for review-copy to destination |

Rows intentionally left out of Outrigger:

- Packet rows 13-25, including Home/non-project rows, unclear-project rows, mixed-tab/project-review rows, PO-conflicted rows, and the accounting-review interest row.

Item-level validation:

- Duplicate check before write found no existing workbook hits for the Lowes refs or SKUs in packet rows 1-12.
- After write, expected refs and SKUs appeared only in `Review`.
- Excluded refs `94293`, `84314`, and `94895` were not found in the workbook.
- `Review` table rows after update: `13`
- `Plumbing Fixtures!L14`: `982.744975`
- `Plumbing Fixtures!L16`: `982.744975`
- `Gnatt Chart!G10`: `982.744975`
- Workbook links: `0`
- External link package parts: `0`
- SharePoint upload completed: 2026-07-08 20:05 UTC, size `806077`
