# 2026-03-17 - Lowe's PRO BYH 5997 - Statement Allocation Test

## Packet Summary

- Source workflow: Doc Scan - Lowe's Statement Allocation Mode test
- Source statement path: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Credit Cards\Lowe's PRO BYH 5997\26-03-17 .pdf`
- Filed statement path: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Credit Cards\Lowe's PRO BYH 5997\26-03-17 .pdf`
- Statement holder: Buy Your Home LLC
- Statement vendor/card: Lowe's PRO / Lowe's Business Account
- Account number shown: `821 3134 248599 7`
- Account last 4: `5997`
- Statement closing date: 2026-03-17
- Payment due date: 2026-04-11
- New balance: `$2,993.16`
- Total minimum payment due: `$125.00`
- Purchases/debits total shown: `$693.17`
- Other credits total shown: `$158.74`
- Interest charged: `$66.27`
- Payment shown: `($105.97)`
- Recommended project workbook for PO `7001` rows: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27_Project Management - 7001 Outrigger Dr.xlsm`
- Statement allocation status: `Needs Review - Lowe's Statement Allocation Test`

## Allocation Notes

- Handwritten source notes appear to allocate `7001 = $492.70` and `Home = $41.73`, which matches statement purchase/credit math excluding payment and interest.
- PO `7001` maps to project/property `27-HM- 7001 Outrigger Dr`.
- `Home` appears to be non-project or personal/home allocation and should not be inserted into the Outrigger project workbook without Wes approval.
- Printed PO values are the strongest project clue. Handwritten PO/project notes are useful review clues but should not override conflicting printed data without review.
- Doc Scan did not check the live workbook for duplicates and did not insert any spreadsheet rows.

## Line Items

| Line | Tran Date | Post Date | Invoice/Ref # | Description | PO / Project Clue | Amount | Type | Recommended Project/Property | Recommended Workbook | Recommended Vendor Tab | Confidence / Status | Notes |
| --- | --- | --- | --- | --- | --- | ---: | --- | --- | --- | --- | --- | --- |
| 1 | 2026-02-17 | 2026-02-18 | `83160` | Install kit-electric WH; delivery/shipping; 24-in plastic WH drain pan | Printed PO `7001` | `$69.18` | Charge | `27-HM- 7001 Outrigger Dr` | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27_Project Management - 7001 Outrigger Dr.xlsm` | `Plumbing Fixtures` | Ready for Template to Project duplicate check | Water-heater related materials; store `907`; date of sale `260217`. |
| 2 | 2026-02-17 | 2026-02-18 | `91816` | AOS 50-gal 6-year electric tall water heater; delivery/shipping | Printed PO `7001` | `$521.61` | Charge | `27-HM- 7001 Outrigger Dr` | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27_Project Management - 7001 Outrigger Dr.xlsm` | `Plumbing Fixtures` | Ready for Template to Project duplicate check | Water-heater purchase; store `907`; date of sale `260217`. |
| 3 | 2026-02-18 | 2026-02-18 | `74298` | Crown moulding / lumber materials | Printed PO `7001` | `$53.66` | Charge | `27-HM- 7001 Outrigger Dr` | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27_Project Management - 7001 Outrigger Dr.xlsm` | `Needs Review` | Needs Review - Vendor Tab | Product description does not map cleanly to the current approved Vendor Tabs Mode tab list. |
| 4 | 2026-02-25 | 2026-02-25 | `94293` | Pansies, tulip wood box, dianthus | Printed PO `home` | `$41.73` | Charge | `Home / non-project review` | `Needs Review` | `Needs Review` | Needs Review - Non-project/Home | Appears intentionally marked `home`; do not insert into Outrigger workbook without approval. |
| 5 | 2026-03-03 | 2026-03-03 | `76164` | Return/credit for 24-in plastic WH drain pan | Printed PO `7001` | `($13.49)` | Credit | `27-HM- 7001 Outrigger Dr` | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27_Project Management - 7001 Outrigger Dr.xlsm` | `Plumbing Fixtures` | Ready for Template to Project duplicate check | Credit/return tied to water-heater drain pan; store `1095`; date of sale `260303`. |
| 6 | 2026-03-05 | 2026-03-05 | `84314` | Return/credit containing storm-door mortise latch and water-heater related items; includes Visa credit line | Handwritten `7001`; printed PO area partly unclear/blank | `($145.25)` | Credit | `27-HM- 7001 Outrigger Dr` | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27_Project Management - 7001 Outrigger Dr.xlsm` | `Needs Review` | Needs Review - Mixed Vendor Tabs / PO clarity | Contains both Windows & Doors-like and Plumbing Fixtures-like return items. Do not choose one tab automatically. |
| 7 | 2026-03-06 | 2026-03-06 | `94895` | RB tank to bowl stainless | Printed PO `na`; handwritten `? 7001` | `$6.99` | Charge | `27-HM- 7001 Outrigger Dr` possible | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27_Project Management - 7001 Outrigger Dr.xlsm` possible | `Plumbing Fixtures` possible | Needs Review - PO conflict | Printed PO is `na`; handwritten note suggests `7001`. Requires review before insertion. |
| 8 | 2026-03-17 | 2026-03-17 | n/a | Interest charge | No project clue | `$66.27` | Interest | `Needs Review` | `Needs Review` | `Needs Review` | Needs Review - Statement-level charge | Statement finance charge, not a project purchase line. Do not insert as a project invoice without accounting direction. |

## Excluded From Invoice-Entry Line Items

| Tran Date | Post Date | Description | Amount | Reason |
| --- | --- | --- | ---: | --- |
| 2026-02-26 | 2026-02-26 | Payment - Thank You | `($105.97)` | Payment activity, not an Template to Project purchase or project cost. |

## Recommended Handoff

- Send this packet to Template to Project for test handling.
- Suggested handling by Template to Project:
  - perform workbook duplicate checks for each line item,
  - insert only rows that are approved by the current Vendor Tabs Mode rules,
  - route unclear or mixed-tab lines to `Review`,
  - preserve the statement path as source evidence for every line,
  - treat this as a Lowe's Statement Allocation Mode pilot and report any schema changes needed.

