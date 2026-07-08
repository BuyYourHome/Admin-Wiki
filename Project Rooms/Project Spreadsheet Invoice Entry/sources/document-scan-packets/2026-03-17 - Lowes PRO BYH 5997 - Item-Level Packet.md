# 2026-03-17 - Lowe's PRO BYH 5997 - Item-Level Packet

## Packet Summary

- Source workflow: Doc Scan - Lowe's Statement Allocation Mode
- Packet purpose: item-level Lowe's handoff under the receipt/transaction item-splitting rule
- Supersedes:
  - `C:\Codex\Wiki Files\Project Rooms\Project Spreadsheet Invoice Entry\sources\document-scan-packets\2026-03-17 - Lowes PRO BYH 5997 - Statement Allocation Test.md`
  - `C:\Codex\Wiki Files\Project Rooms\Project Spreadsheet Invoice Entry\sources\document-scan-packets\2026-03-17 - Lowes PRO BYH 5997 - Revised Project-First Packet.md`
- Source statement path: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Credit Cards\Lowe's PRO BYH 5997\26-03-17 .pdf`
- Filed statement path: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Credit Cards\Lowe's PRO BYH 5997\26-03-17 .pdf`
- Statement holder: Buy Your Home LLC
- Lowe's account label: Lowe's PRO / Lowe's Business Account
- Account number shown: `821 3134 248599 7`
- Account last 4: `5997`
- Statement closing date: 2026-03-17
- Statement period: not separately shown
- Payment due date: 2026-04-11
- New balance: `$2,993.16`
- Total minimum payment due: `$125.00`
- Purchases/debits total shown: `$693.17`
- Other credits total shown: `$158.74`
- Interest charged: `$66.27`
- Payment shown: `($105.97)`
- Confidence/status: `Needs Review - Statement Mode`

## Item-Splitting Rule Applied

Each visible purchased item, returned item, delivery/shipping component, tax component, credit component, or finance charge is represented as its own packet row. The shared Lowe's transaction header is repeated on each row so Invoice Entry can place approved rows into the correct project workbook `Review` table and later copy approved rows to vendor tabs.

Item amounts below are the statement detail `EXT. PRICE` or separately shown tax/credit/interest amount. Where tax is shown at the transaction level, it is split as a separate row so the transaction can reconcile. Invoice Entry should not allocate tax across item rows unless an approved allocation rule exists.

Doc Scan did not edit any project-management workbook and did not check workbook duplicates.

## Handoff Counts

- Total packet rows, excluding payment and zero-dollar promotional discount rows: 25
- High-confidence project rows: 12
- High-confidence project rows with recommended destination worksheet: 8
- High-confidence project rows with worksheet needing review: 4
- Unclear project rows: 8
- Non-project/Home rows: 4
- Mixed-tab/project-review rows: 6
- PO-conflicted rows: 2
- Accounting-review rows: 1
- Payment rows excluded from invoice-entry packet: 1
- Zero-dollar promotional discount rows omitted from packet rows: 3

## High-Confidence Project Rows

These rows have printed PO `7001`, which supports routing to `27-HM- 7001 Outrigger Dr`.

Recommended workbook for these rows:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27_Project Management - 7001 Outrigger Dr.xlsm`

| Row | Tran Date | Post Date | Ref # | Store | PO / Project Clue | SKU | Item Description | Qty | Item Amount | Type | Recommended Project/Property | Recommended Workbook | Recommended Vendor Tab | Confidence / Status | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | ---: | ---: | --- | --- | --- | --- | --- | --- |
| 1 | 2026-02-18 | 2026-02-18 | `74298` | `444` | Printed PO `7001` | `000000000171973` | PFJCRWN L49 3-5/8-INX9/16 | 2 | `$40.74` | Charge item | `27-HM- 7001 Outrigger Dr` | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27_Project Management - 7001 Outrigger Dr.xlsm` | blank | Needs Review - Vendor Tab | Ref total is `$53.66`; zero-dollar promotional discount omitted. Put in Outrigger `Review`; leave `Destination Worksheet` blank. |
| 2 | 2026-02-18 | 2026-02-18 | `74298` | `444` | Printed PO `7001` | `000000000076250` | 2-8-8 TOP CHOICE #2 SYP P | 1 | `$9.29` | Charge item | `27-HM- 7001 Outrigger Dr` | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27_Project Management - 7001 Outrigger Dr.xlsm` | blank | Needs Review - Vendor Tab | Ref total is `$53.66`; category is not clear from approved Vendor Tabs Mode list. |
| 3 | 2026-02-18 | 2026-02-18 | `74298` | `444` | Printed PO `7001` | n/a | Sales tax for ref `74298` | n/a | `$3.63` | Tax | `27-HM- 7001 Outrigger Dr` | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27_Project Management - 7001 Outrigger Dr.xlsm` | blank | Needs Review - Allocation / Vendor Tab | Transaction-level tax shown separately. Keep with ref `74298`; do not allocate across item rows without approved rule. |
| 4 | 2026-02-17 | 2026-02-18 | `83160` | `907` | Printed PO `7001` | `000000000758108` | INSTALL KIT-ELECTRIC WH | 1 | `$31.93` | Charge item | `27-HM- 7001 Outrigger Dr` | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27_Project Management - 7001 Outrigger Dr.xlsm` | `Plumbing Fixtures` | Ready for Invoice Entry duplicate check; Review-first | Put in Outrigger `Review`, with `Destination Worksheet = Plumbing Fixtures`. |
| 5 | 2026-02-17 | 2026-02-18 | `83160` | `907` | Printed PO `7001` | `000000000000002` | Delivery and Shipping | 1 | `$20.00` | Delivery/shipping | `27-HM- 7001 Outrigger Dr` | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27_Project Management - 7001 Outrigger Dr.xlsm` | `Plumbing Fixtures` | Ready for Invoice Entry duplicate check; Review-first | Delivery is separately shown and tied to the water-heater transaction. |
| 6 | 2026-02-17 | 2026-02-18 | `83160` | `907` | Printed PO `7001` | `000000003488471` | 24-IN PLASTIC WH DRAIN PA | 1 | `$12.58` | Charge item | `27-HM- 7001 Outrigger Dr` | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27_Project Management - 7001 Outrigger Dr.xlsm` | `Plumbing Fixtures` | Ready for Invoice Entry duplicate check; Review-first | Put in Outrigger `Review`, with `Destination Worksheet = Plumbing Fixtures`. |
| 7 | 2026-02-17 | 2026-02-18 | `83160` | `907` | Printed PO `7001` | n/a | Sales tax for ref `83160` | n/a | `$4.67` | Tax | `27-HM- 7001 Outrigger Dr` | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27_Project Management - 7001 Outrigger Dr.xlsm` | `Plumbing Fixtures` | Ready for Invoice Entry duplicate check; Review-first | Ref total is `$69.18`. Tax is transaction-level and tied to plumbing items. |
| 8 | 2026-02-17 | 2026-02-18 | `91816` | `907` | Printed PO `7001` | `000000002483229` | AOS 50-GAL 6YR ELEC TALL | 1 | `$483.55` | Charge item | `27-HM- 7001 Outrigger Dr` | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27_Project Management - 7001 Outrigger Dr.xlsm` | `Plumbing Fixtures` | Ready for Invoice Entry duplicate check; Review-first | Put in Outrigger `Review`, with `Destination Worksheet = Plumbing Fixtures`. |
| 9 | 2026-02-17 | 2026-02-18 | `91816` | `907` | Printed PO `7001` | `000000000000002` | Delivery and Shipping | 1 | `$0.00` | Delivery/shipping | `27-HM- 7001 Outrigger Dr` | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27_Project Management - 7001 Outrigger Dr.xlsm` | `Plumbing Fixtures` | Ready for Invoice Entry duplicate check; Review-first | Delivery is separately shown at `$0.00`; include for source fidelity but do not create cost unless Invoice Entry keeps zero rows. |
| 10 | 2026-02-17 | 2026-02-18 | `91816` | `907` | Printed PO `7001` | n/a | Sales tax for ref `91816` | n/a | `$38.06` | Tax | `27-HM- 7001 Outrigger Dr` | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27_Project Management - 7001 Outrigger Dr.xlsm` | `Plumbing Fixtures` | Ready for Invoice Entry duplicate check; Review-first | Ref total is `$521.61`. Tax is transaction-level and tied to the water-heater purchase. |
| 11 | 2026-03-03 | 2026-03-03 | `76164` | `1095` | Printed PO `7001` | `000000003488471` | 24-IN PLASTIC WH DRAIN PA | 1 | `($12.58)` | Credit/return item | `27-HM- 7001 Outrigger Dr` | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27_Project Management - 7001 Outrigger Dr.xlsm` | `Plumbing Fixtures` | Ready for Invoice Entry duplicate check; Review-first | Return/credit for drain pan. Put in Outrigger `Review`, with `Destination Worksheet = Plumbing Fixtures`. |
| 12 | 2026-03-03 | 2026-03-03 | `76164` | `1095` | Printed PO `7001` | n/a | Sales tax credit for ref `76164` | n/a | `($0.91)` | Tax credit | `27-HM- 7001 Outrigger Dr` | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27_Project Management - 7001 Outrigger Dr.xlsm` | `Plumbing Fixtures` | Ready for Invoice Entry duplicate check; Review-first | Ref total is `($13.49)`. Tax credit is transaction-level and tied to the drain-pan return. |

## Lines Not Ready For A Project Workbook

These rows should not be placed into the Outrigger workbook merely because the same statement contains Outrigger rows.

| Row | Tran Date | Post Date | Ref # | Store | PO / Project Clue | SKU | Item Description | Qty | Item Amount | Type | Recommended Project/Property | Recommended Workbook | Recommended Vendor Tab | Confidence / Status | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | ---: | ---: | --- | --- | --- | --- | --- | --- |
| 13 | 2026-02-25 | 2026-02-25 | `94293` | `444` | Printed PO `home` | `000000000283875` | 1.50-GAL PANSY HB | 2 | `$14.26` | Charge item | `Home / non-project` | blank | blank | Non-project/Home | Do not insert into a project workbook unless Wes later gives a handling rule for Home items. |
| 14 | 2026-02-25 | 2026-02-25 | `94293` | `444` | Printed PO `home` | `000000001497748` | 3.00-QT TULIP WOOD BOX BT | 1 | `$12.33` | Charge item | `Home / non-project` | blank | blank | Non-project/Home | Ref total is `$41.73`; zero-dollar promotional discount omitted. |
| 15 | 2026-02-25 | 2026-02-25 | `94293` | `444` | Printed PO `home` | `000000001152267` | 1.50-PT DIANTHUS ERLY BRD | 2 | `$12.32` | Charge item | `Home / non-project` | blank | blank | Non-project/Home | Non-project/Home row. |
| 16 | 2026-02-25 | 2026-02-25 | `94293` | `444` | Printed PO `home` | n/a | Sales tax for ref `94293` | n/a | `$2.82` | Tax | `Home / non-project` | blank | blank | Non-project/Home | Transaction-level tax for Home/non-project purchase. |
| 17 | 2026-03-05 | 2026-03-05 | `84314` | `1095` | Handwritten `7001`; printed PO not reliable | `000000000028827` | WP SN SB STORM DOOR MORTI | 1 | `($75.03)` | Credit/return item | `Needs Review - Project` | blank | blank | Needs Review - Mixed Tab / Project | Windows & Doors-like return; project proof is handwritten/unclear. Resolve project before workbook routing. |
| 18 | 2026-03-05 | 2026-03-05 | `84314` | `1095` | Handwritten `7001`; printed PO not reliable | `000000003529255` | BN STM DR M2 MORTISE LATC | 1 | `($59.48)` | Credit/return item | `Needs Review - Project` | blank | blank | Needs Review - Mixed Tab / Project | Windows & Doors-like return; continuation page detail. |
| 19 | 2026-03-05 | 2026-03-05 | `84314` | `1095` | Handwritten `7001`; printed PO not reliable | `000000000758108` | INSTALL KIT-ELECTRIC WH | 1 | `($31.93)` | Credit/return item | `Needs Review - Project` | blank | blank | Needs Review - Mixed Tab / Project | Plumbing-like return; same transaction also contains door items. |
| 20 | 2026-03-05 | 2026-03-05 | `84314` | `1095` | Handwritten `7001`; printed PO not reliable | `000000000476952` | WP WH 6CS TAP-N-GO CLSR | 1 | `($28.48)` | Credit/return item | `Needs Review - Project` | blank | blank | Needs Review - Mixed Tab / Project | Plumbing-like return; same transaction also contains door items. |
| 21 | 2026-03-05 | 2026-03-05 | `84314` | `1095` | Handwritten `7001`; printed PO not reliable | n/a | VISA credit component | n/a | `$63.80` | Credit component | `Needs Review - Project` | blank | blank | Needs Review - Allocation | Statement shows `VISA` credit total `$63.80`; allocation and project handling need review. |
| 22 | 2026-03-05 | 2026-03-05 | `84314` | `1095` | Handwritten `7001`; printed PO not reliable | n/a | Sales tax credit for ref `84314` | n/a | `($14.13)` | Tax credit | `Needs Review - Project` | blank | blank | Needs Review - Mixed Tab / Allocation | Transaction shows sub `($194.92)`, tax `($14.13)`, invoice total `($209.05)`, credits total `$63.80`, and balance due `($145.25)`. Resolve allocation before workbook routing. |
| 23 | 2026-03-06 | 2026-03-06 | `94895` | `444` | Printed PO `na`; handwritten `? 7001` | `000000003625390` | RB TANK TO BOWL STAINLESS | 1 | `$6.52` | Charge item | `Needs Review - Project` | blank | blank | Needs Review - PO conflict | Printed PO is `na`; handwritten note suggests `7001`. Do not recommend Outrigger workbook until Wes resolves the conflict. |
| 24 | 2026-03-06 | 2026-03-06 | `94895` | `444` | Printed PO `na`; handwritten `? 7001` | n/a | Sales tax for ref `94895` | n/a | `$0.47` | Tax | `Needs Review - Project` | blank | blank | Needs Review - PO conflict / Allocation | Ref total is `$6.99`. Do not recommend a project workbook until PO conflict is resolved. |
| 25 | 2026-03-17 | 2026-03-17 | n/a | n/a | No project clue | n/a | Interest charge | n/a | `$66.27` | Interest | `Accounting review` | blank | blank | Accounting Review | Statement finance charge, not a project purchase item. Do not insert as a project invoice without accounting direction. |

## Excluded From Packet Rows

| Tran Date | Post Date | Ref # | Description | Amount | Reason |
| --- | --- | --- | --- | ---: | --- |
| 2026-02-26 | 2026-02-26 | n/a | Payment - Thank You | `($105.97)` | Payment activity, not an invoice-entry purchase or project cost. |
| 2026-02-18 | 2026-02-18 | `74298` | Promotional discount applied | `$0.00` | Zero-dollar promotional line; noted in packet but not useful as an invoice-entry cost row. |
| 2026-02-25 | 2026-02-25 | `94293` | Promotional discount applied | `$0.00` | Zero-dollar promotional line; non-project/Home transaction. |
| 2026-03-06 | 2026-03-06 | `94895` | Promotional discount applied | `$0.00` | Zero-dollar promotional line; PO conflict transaction. |

## Recommended Handoff

Invoice Entry should consume this item-level packet instead of either prior Lowe's packet.

Recommended handling:

- Perform duplicate checks before any workbook write.
- For rows 1-12, use the Outrigger workbook `Review` table first.
- Fill `Destination Worksheet` only where shown above.
- Do not place rows 13-25 in the Outrigger workbook until their project/accounting/allocation status is resolved.
- Do not insert any Lowe's statement item directly into a vendor tab during initial packet consumption.
- For rows marked `Needs Review - Allocation`, do not create final inserted vendor-tab rows until Invoice Entry has an approved allocation method.
