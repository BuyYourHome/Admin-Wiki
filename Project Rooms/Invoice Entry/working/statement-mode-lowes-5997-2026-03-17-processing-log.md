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

## Amended Review Inclusion Reprocess

On 2026-07-08, Wes amended the Lowes Statement Mode inclusion rule: exclude rows that clearly do not belong, include rows that certainly belong or may belong to the target project, and exclude sales-tax-only or tax-credit-only rows because tax will be calculated or allocated later.

The Outrigger workbook was rebuilt from the clean pre-item-level SharePoint-current copy and reprocessed under the amended rule.

Work copy: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\statement-mode\lowes-5997-2026-03-17-amended-review\27_Project Management - 7001 Outrigger Dr.lowes-amended-review.20260708-175119.xlsm`

Rows added to `Review`:

| Packet row | Ref | Item | Amount | Destination Worksheet | Status |
| --- | --- | --- | ---: | --- | --- |
| 1 | `74298` | PFJCRWN L49 3-5/8-INX9/16 | 40.74 |  | Needs Review - Vendor Tab |
| 2 | `74298` | 2-8-8 TOP CHOICE #2 SYP P | 9.29 |  | Needs Review - Vendor Tab |
| 4 | `83160` | INSTALL KIT-ELECTRIC WH | 31.93 | Plumbing Fixtures | Ready for review-copy to destination |
| 5 | `83160` | Delivery and Shipping | 20.00 | Plumbing Fixtures | Ready for review-copy to destination |
| 6 | `83160` | 24-IN PLASTIC WH DRAIN PA | 12.58 | Plumbing Fixtures | Ready for review-copy to destination |
| 8 | `91816` | AOS 50-GAL 6YR ELEC TALL | 483.55 | Plumbing Fixtures | Ready for review-copy to destination |
| 9 | `91816` | Delivery and Shipping | 0.00 | Plumbing Fixtures | Ready for review-copy to destination |
| 11 | `76164` | 24-IN PLASTIC WH DRAIN PA | -12.58 | Plumbing Fixtures | Ready for review-copy to destination |
| 17 | `84314` | WP SN SB STORM DOOR MORTI | -75.03 |  | Needs Review - Project / Destination |
| 18 | `84314` | BN STM DR M2 MORTISE LATC | -59.48 |  | Needs Review - Project / Destination |
| 19 | `84314` | INSTALL KIT-ELECTRIC WH | -31.93 |  | Needs Review - Project / Destination |
| 20 | `84314` | WP WH 6CS TAP-N-GO CLSR | -28.48 |  | Needs Review - Project / Destination |
| 21 | `84314` | VISA credit component | 63.80 |  | Needs Review - Allocation / Project |
| 23 | `94895` | RB TANK TO BOWL STAINLESS | 6.52 |  | Needs Review - PO conflict |

Rows intentionally excluded:

- Sales-tax-only and tax-credit-only rows: packet rows 3, 7, 10, 12, 16, 22, and 24.
- Clearly Home/non-project rows: packet rows 13, 14, and 15.
- Accounting-only interest row: packet row 25.

Amended validation:

- Rebuilt from clean pre-item-level workbook copy.
- `Review` table rows after update: `15` including the existing GTI review row and 14 Lowes rows.
- Lowes rows present: packet rows 1, 2, 4, 5, 6, 8, 9, 11, 17, 18, 19, 20, 21, and 23.
- No Lowes Review row text contains sales tax.
- Home ref `94293` was not found in the Lowes Review rows.
- Interest was not found in the Lowes Review rows.
- `Plumbing Fixtures!L14`: `$982.74`
- `Plumbing Fixtures!L16`: `$982.74`
- `Gnatt Chart!G10`: `982.74`
- Workbook links: `0`
- External link package parts: `0`

Upload status:

- SharePoint upload attempted at 2026-07-08 21:52 UTC.
- Upload blocked with `423 resourceLocked`; the live SharePoint workbook was locked.
- SharePoint upload retried successfully at 2026-07-08 22:16 UTC, size `807244`.
- The corrected amended-review workbook replaced the live Teams/SharePoint workbook.

## Review Description Column Reprocess

On 2026-07-08, Wes added a required `Description` field for Review rows because reviewed rows will later be copied into vendor tables. The Outrigger workbook was updated so `Review` has a `Description` column immediately after `Invoice #` and before `Amount`.

Work copy: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\statement-mode\lowes-5997-2026-03-17-review-description\27_Project Management - 7001 Outrigger Dr.review-description.20260708-182428.xlsm`

Validation:

- `Review` header order now includes `Invoice #`, `Description`, then `Amount`.
- All 14 Lowes Review rows have clean item descriptions populated.
- Lowes rows present remain packet rows 1, 2, 4, 5, 6, 8, 9, 11, 17, 18, 19, 20, 21, and 23.
- No Lowes Review row text contains sales tax.
- Home ref `94293` was not found in the Lowes Review rows.
- Interest was not found in the Lowes Review rows.
- `Plumbing Fixtures!L14`: `$982.74`
- `Plumbing Fixtures!L16`: `$982.74`
- `Gnatt Chart!G10`: `982.74`
- Workbook links: `0`
- External link package parts: `0`
- SharePoint upload completed: 2026-07-08 22:25 UTC, size `806334`.

## Lowes Product Description Lookup

On 2026-07-08, Wes asked Invoice Entry to use Lowe's item numbers to improve `Review[Description]`. Lowe's item numbers were searched without leading zeroes. Reliable Lowe's product-page matches were used where available; statement-derived descriptions were retained for delivery/shipping, credit components, and rows without a reliable Lowe's match.

Work copy: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\statement-mode\lowes-5997-2026-03-17-lowes-descriptions\27_Project Management - 7001 Outrigger Dr.lowes-descriptions.20260708-183135.xlsm`

Descriptions after lookup:

| Packet row | Item number | Description |
| --- | --- | --- |
| 1 | `171973` | PFJCRWN L49 3-5/8-in x 9/16-in crown moulding |
| 2 | `76250` | Top Choice 2-in x 8-in x 8-ft #2 Prime Southern Yellow Pine Kiln-Dried Lumber |
| 4 | `758108` | EASTMAN Electric Water Heater Installation Kit |
| 5 | n/a | Delivery and Shipping |
| 6 | `3488471` | EASTMAN 24-in ID Plastic Water Heater Drain Pan with PVC Fitting |
| 8 | `2483229` | A.O. Smith Signature 100 50-Gallon Tall 6-Year 4500-Watt Double Element Electric Water Heater |
| 9 | n/a | Delivery and Shipping |
| 11 | `3488471` | EASTMAN 24-in ID Plastic Water Heater Drain Pan with PVC Fitting |
| 17 | `28827` | WRIGHT PRODUCTS Storm Door Satin Nickel Lockable Storm Door Replacement Handleset |
| 18 | `3529255` | LARSON Brushed Silver Lockable Storm Door Replacement Handleset |
| 19 | `758108` | EASTMAN Electric Water Heater Installation Kit |
| 20 | `476952` | WRIGHT PRODUCTS 12.688-in EZ-Hold Adjustable White Aluminum Hold Open Screen/Storm Door Pneumatic Closer |
| 21 | n/a | VISA credit component |
| 23 | `3625390` | RELIABILT Stainless Steel Toilet Tank-to-Bowl Bolts |

Validation:

- All 14 Lowes Review rows have populated descriptions.
- Lowes rows present remain packet rows 1, 2, 4, 5, 6, 8, 9, 11, 17, 18, 19, 20, 21, and 23.
- No Lowes Review row text contains sales tax.
- Home ref `94293` was not found in the Lowes Review rows.
- Interest was not found in the Lowes Review rows.
- `Plumbing Fixtures!L14`: `$982.74`
- `Plumbing Fixtures!L16`: `$982.74`
- `Gnatt Chart!G10`: `982.74`
- Workbook links: `0`
- External link package parts: `0`
- SharePoint upload completed: 2026-07-08 22:33 UTC, size `807641`.
