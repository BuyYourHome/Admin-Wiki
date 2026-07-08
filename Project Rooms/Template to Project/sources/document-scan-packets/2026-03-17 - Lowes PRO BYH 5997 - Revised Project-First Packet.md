# 2026-03-17 - Lowe's PRO BYH 5997 - Revised Project-First Packet

## Packet Summary

- Source workflow: Doc Scan - Lowe's Statement Allocation Mode
- Packet purpose: revised project-first handoff after the prior Lowe's test packet was superseded
- Prior packet: `C:\Codex\Wiki Files\Project Rooms\Template to Project\sources\document-scan-packets\2026-03-17 - Lowes PRO BYH 5997 - Statement Allocation Test.md`
- Source statement path: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Credit Cards\Lowe's PRO BYH 5997\26-03-17 .pdf`
- Filed statement path: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Credit Cards\Lowe's PRO BYH 5997\26-03-17 .pdf`
- Statement holder: Buy Your Home LLC
- Statement vendor/card: Lowe's PRO / Lowe's Business Account
- Account number shown: `821 3134 248599 7`
- Account last 4: `5997`
- Statement closing date: 2026-03-17
- Statement period: not separately shown in the prior extraction
- Payment due date: 2026-04-11
- New balance: `$2,993.16`
- Total minimum payment due: `$125.00`
- Purchases/debits total shown: `$693.17`
- Other credits total shown: `$158.74`
- Interest charged: `$66.27`
- Payment shown: `($105.97)`
- Confidence/status: `Needs Review - Statement Mode`

## New Project-First Rule Applied

Do not send every Lowe's statement line to the Outrigger workbook just because some lines belong to Outrigger.

Only lines with a high-confidence project/property match should recommend a project workbook. Lines marked Home/non-project, accounting-review, mixed-tab with unclear project, or PO-conflicted should not recommend a project-management workbook until Template to Project or Wes resolves the project first.

For high-confidence Outrigger rows, Template to Project should place the row in the Outrigger workbook `Review` table first. A filled destination worksheet is only a recommendation for later review-copy into a vendor tab.

Doc Scan did not edit any project-management workbook and did not check workbook duplicates.

## Handoff Counts

- Total extracted statement lines: 8
- High-confidence project lines: 4
- High-confidence project lines with recommended destination worksheet: 3
- High-confidence project lines with worksheet needing review: 1
- Unclear project lines: 2
- Non-project/Home lines: 1
- Mixed-tab lines: 1
- Accounting-review lines: 1
- Payment lines excluded from Template to Project packet: 1

## High-Confidence Project Lines

These lines have printed PO `7001`, which supports routing to `27-HM- 7001 Outrigger Dr`.

Recommended workbook for these rows:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27_Project Management - 7001 Outrigger Dr.xlsm`

| Line | Tran Date | Post Date | Invoice/Ref # | Description | PO / Project Clue | Amount | Type | Recommended Project/Property | Recommended Workbook | Recommended Vendor Tab | Confidence / Status | Notes |
| --- | --- | --- | --- | --- | --- | ---: | --- | --- | --- | --- | --- | --- |
| 1 | 2026-02-17 | 2026-02-18 | `83160` | Install kit-electric WH; delivery/shipping; 24-in plastic WH drain pan | Printed PO `7001` | `$69.18` | Charge | `27-HM- 7001 Outrigger Dr` | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27_Project Management - 7001 Outrigger Dr.xlsm` | `Plumbing Fixtures` | Ready for Template to Project duplicate check; Review-first | Water-heater related materials; store `907`; date of sale `260217`. Put in Outrigger `Review` first, with `Destination Worksheet = Plumbing Fixtures`. |
| 2 | 2026-02-17 | 2026-02-18 | `91816` | AOS 50-gal 6-year electric tall water heater; delivery/shipping | Printed PO `7001` | `$521.61` | Charge | `27-HM- 7001 Outrigger Dr` | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27_Project Management - 7001 Outrigger Dr.xlsm` | `Plumbing Fixtures` | Ready for Template to Project duplicate check; Review-first | Water-heater purchase; store `907`; date of sale `260217`. Put in Outrigger `Review` first, with `Destination Worksheet = Plumbing Fixtures`. |
| 3 | 2026-02-18 | 2026-02-18 | `74298` | Crown moulding / lumber materials | Printed PO `7001` | `$53.66` | Charge | `27-HM- 7001 Outrigger Dr` | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27_Project Management - 7001 Outrigger Dr.xlsm` | `Needs Review` | Needs Review - Vendor Tab; Review-first | Project is high-confidence from printed PO, but product description does not map cleanly to the current approved Vendor Tabs Mode tab list. Put in Outrigger `Review` first and leave `Destination Worksheet` blank. |
| 5 | 2026-03-03 | 2026-03-03 | `76164` | Return/credit for 24-in plastic WH drain pan | Printed PO `7001` | `($13.49)` | Credit | `27-HM- 7001 Outrigger Dr` | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27_Project Management - 7001 Outrigger Dr.xlsm` | `Plumbing Fixtures` | Ready for Template to Project duplicate check; Review-first | Credit/return tied to water-heater drain pan; store `1095`; date of sale `260303`. Put in Outrigger `Review` first, with `Destination Worksheet = Plumbing Fixtures`. |

## Lines Not Ready For A Project Workbook

These lines should not be placed into the Outrigger workbook merely because the same statement contains Outrigger rows.

| Line | Tran Date | Post Date | Invoice/Ref # | Description | PO / Project Clue | Amount | Type | Recommended Project/Property | Recommended Workbook | Recommended Vendor Tab | Confidence / Status | Notes |
| --- | --- | --- | --- | --- | --- | ---: | --- | --- | --- | --- | --- | --- |
| 4 | 2026-02-25 | 2026-02-25 | `94293` | Pansies, tulip wood box, dianthus | Printed PO `home` | `$41.73` | Charge | `Home / non-project` | blank | blank | Non-project/Home | Do not insert into a project workbook unless Wes later gives a handling rule for Home items. |
| 6 | 2026-03-05 | 2026-03-05 | `84314` | Return/credit containing storm-door mortise latch and water-heater related items; includes Visa credit line | Handwritten `7001`; printed PO area partly unclear/blank | `($145.25)` | Credit | `Needs Review - Project` | blank | blank | Needs Review - Mixed Tab / Project | Contains both Windows & Doors-like and Plumbing Fixtures-like return items, and project proof is not a clear printed PO. Resolve project before workbook routing. |
| 7 | 2026-03-06 | 2026-03-06 | `94895` | RB tank to bowl stainless | Printed PO `na`; handwritten `? 7001` | `$6.99` | Charge | `Needs Review - Project` | blank | blank | Needs Review - PO conflict | Printed PO is `na`; handwritten note suggests `7001`. Do not recommend Outrigger workbook until Wes resolves the conflict. |
| 8 | 2026-03-17 | 2026-03-17 | n/a | Interest charge | No project clue | `$66.27` | Interest | `Accounting review` | blank | blank | Accounting Review | Statement finance charge, not a project purchase line. Do not insert as a project invoice without accounting direction. |

## Excluded From Invoice-Entry Line Items

| Tran Date | Post Date | Description | Amount | Reason |
| --- | --- | --- | ---: | --- |
| 2026-02-26 | 2026-02-26 | Payment - Thank You | `($105.97)` | Payment activity, not an Template to Project purchase or project cost. |

## Recommended Handoff

Template to Project should consume this revised packet instead of the prior test packet.

Recommended handling:

- Perform duplicate checks before any workbook write.
- For lines 1, 2, 3, and 5, use the Outrigger workbook `Review` table first.
- Fill `Destination Worksheet` only for lines 1, 2, and 5 as `Plumbing Fixtures`.
- Leave line 3 `Destination Worksheet` blank pending vendor-tab review.
- Do not place lines 4, 6, 7, or 8 in the Outrigger workbook until their project/accounting status is resolved.
- Do not insert any Lowe's statement line directly into a vendor tab during initial packet consumption.
