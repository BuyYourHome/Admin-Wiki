# Lowes Statement Mode Processing Log - 2026-03-17 Statement

## Source

- Packet: `C:\Codex\Wiki Files\Project Rooms\Project Spreadsheet Invoice Entry\sources\document-scan-packets\2026-03-17 - Lowes PRO BYH 5997 - Statement Allocation Test.md`
- Statement PDF: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Credit Cards\Lowe's PRO BYH 5997\26-03-17 .pdf`
- Target workbook: `Property/27_Project Management - 7001 Outrigger Dr.xlsm`
- Work copy: `C:\Codex\Wiki Files\Project Rooms\Project Spreadsheet Invoice Entry\working\statement-mode\lowes-5997-2026-03-17\27_Project Management - 7001 Outrigger Dr.lowes-5997-2026-03-17.20260708-140429.xlsm`
- Rollback copy: `C:\Codex\Wiki Files\Project Rooms\Project Spreadsheet Invoice Entry\working\backups\27_Project Management - 7001 Outrigger Dr.before-lowes-5997-2026-03-17-20260708-140429.xlsm`

## Supersession

The initial partial vendor-tab insertion was superseded on 2026-07-08 after Wes approved the Lowes Review-first rule. The live Teams/SharePoint workbook was reverted from the pre-Lowes rollback copy and reprocessed so that every extracted Lowes statement item is in `Review` first. No Lowes statement lines remain directly inserted in `Plumbing Fixtures`.

Review-first work copy: `C:\Codex\Wiki Files\Project Rooms\Project Spreadsheet Invoice Entry\working\statement-mode\lowes-5997-2026-03-17-review-first\27_Project Management - 7001 Outrigger Dr.lowes-5997-review-first.20260708-142327.xlsm`

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
