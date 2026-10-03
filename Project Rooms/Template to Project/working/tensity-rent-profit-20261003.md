# Tensity Rent to Profit Prototype

## Authorization and Scope

October 3, 2026: Wes authorized Tensity as the prototype, a minimally redesigned Carrying-to-Profit rent connection, and population from Teams leases without further questions. Tensity only; this new income design is not yet approved for other projects. No Invoice Entry files, other project workbooks or shared Admin rules changed. No Git push requested.

## Authoritative Sources

- Current Teams item: [24_Project Management - 4121 Tensity Dr 2.xlsm](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7BFB8825B0-06EF-4B3E-8015-A106EEEA5C7C%7D). Item `01ZGFUBDNQEWEPX3YGHZFYAFNBA3XOUXD4`; source version 1246, last modified October 2 at 3:51:15 PM Eastern. Retrieved through the SharePoint connector; no synced-file substitution.
- [Signed lease](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/Shared%20Documents/Property/24-HM%20-%204121%20Tensity%20Dr/Renting/25-07-01%20Ever%20Cardoza%20Rental%20Application%20and%20Lease%20SIGNED.pdf): visually read Exhibit A, PDF page 8. Tensity address, July 1, 2025 through June 30, 2026, $1,850 monthly, $22,200 annual. Lease signatures are on PDF pages 7 and 9. The application pages contain private data and are not reproduced in this log or validation archive.
- [June 5, 2026 landlord payment-verification letter](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7B05C9AFB1-2B24-43EC-8C4C-EE3EC0303FA3%7D): names Ever Cardoza, Tensity, July 2025-June 2026, $1,850 monthly and timely payments. Stored under Rose's buyer package but explicitly refers to the Tensity tenancy; it is not Rose rent.
- The related rent-history affidavit has unsigned signature/notary lines. It was read for context, not treated as an executed affidavit or independent bank confirmation. The earlier unsigned `.doc` lease and draft sale documents were not used to extend the tenancy.
- No receipt-level payment dates or bank reconciliation were established. The imported amounts are **Reported Collected**, not independently verified bank receipts. No renewal, rent increase, deposit, late fee or post-June 2026 payment was inferred.

## Record Mapping

Preserve all 56 existing Carrying records and every field. Append 12 Rent records to `tblCarryingExpenses`, expanding AO4:AY60 to AO4:AY72 without changing its 11-column schema.

| Field | Mapping |
| --- | --- |
| Include / Category | Yes / Rent |
| Date | First day of each supported rental month, July 2025-June 2026; not an asserted receipt date |
| Vendor | Ever Cardoza, primary tenant named by the verification letter |
| Description | Residential rent plus named month |
| Amount | $1,850 per month |
| Source | Lease + landlord verification |
| Invoice # | Generated stable source key `TENSITY-RENT-YYYY-MM`, not a landlord-issued invoice number |
| Source File | Signed lease Teams URL |
| Status | Reported Collected |
| Notes | Monthly allocation, verification-letter date/URL, and missing receipt-date/reconciliation limitation |

The Rent grid is AK:AM. Change only its date heading to Month, amount heading to Rent and date display to `mmm yyyy`. Existing orange fill, widths, rows, controls and entry/edit/recurring behavior remain. Status choices are added to the existing merged Status input and table Status column. Default recurring status stays Entered and is not recognized as collected.

## Profit Map

- Existing inputs B9=12 and C9=$1,850 remain. B9 also affects costs, appreciation, subject-loan lookup and MOG; replacing it with actual rental months would alter unrelated assumptions.
- Rent history occupies the previously unpopulated Q18:W25 area, with no inserted worksheet rows or changed column widths.
- `rentTotalCollected` = V19: included Rent with Collected or Reported Collected status. Linked into E9 in all modes.
- `rentMonthsRented` = V20: distinct positive, included monthly Rent periods through the current month, with Scheduled/Collected/Reported Collected status. Split payments count once; refunds reduce income without erasing the original occupied month.
- V21 separately discloses landlord-reported collections; V22 reports lease schedules awaiting confirmation. V23 / `rentMonthsProjected` reports the remaining Hold rental horizon after elapsed/collected months, including prepaid future months but excluding unpaid future schedules.
- A9 is relabeled minimally. K57 changes only to remove the already-accounted-for monthly rent estimate in Hold. Existing full-horizon expenses and CFD monthly cash flow remain unchanged. E9 replaces the former B9*C9 historical-rent estimate in Slow Flip.
- Rent remains excluded from Carrying Cost B43 and every expense subtotal. Docs monthly rent remains connected to C9, not the total collected amount. No external workbook reference introduced.

## Reconciliation

| Result | Before | After |
| --- | ---: | ---: |
| Original expense records | 56 | 56 |
| Rent records | 0 | 12 |
| Carrying expenses / Profit B43 | $28,224.97 | $28,224.97 |
| Reported historical collections | Not tracked in table | $22,200.00 |
| Recorded rental months | Not tracked in table | 12 |
| Flip total profit J58 | $129,036.79 | $151,236.79 |
| Hold total profit J58 | $240,112.47 | $240,112.47 |
| Slow Flip total profit J58 | $156,966.17 | $156,966.17 |

Hold/Slow Flip are unchanged overall at the source's same $1,850 x 12 assumptions because actual historical rent replaces their prior estimate. Flip now includes the previously omitted historical rental income. This is a targeted connection, not a certification of all existing project financial assumptions.

## Validation

- Native hidden Excel normal reopen, Automatic calculation and zero external workbook links.
- Whole-workbook raw/shared-formula preservation audit, resolved cell styles, existing dimensions/merges/print settings/names, original controls and all VBA module source unchanged outside the explicit additions.
- Original 56 records preserved; dynamic Vendor list correctly adds Ever Cardoza.
- All 12 displayed rental month/amount pairs verified, plus visual review of Profit and Rent grid.
- Tests cover all three modes, schedule/unconfirmed/excluded states, partial/split payments, refunds, future schedules/prepayment, hidden and actively filtered records, empty Rent, first insertion, grid-selected recurrence and Edit/Save/Cancel. All synthetic records and temporary test code are discarded without saving.
- Seventeen pre-existing displayed #REF! errors remain in Contract and Gnatt Chart. Excel SpecialCells initially returned 21 cells because it included four blank merged companions; the audit now counts actual error displays. No new errors; no unrelated repair performed.

## Delivery

Rollback preserved in Teams before editing: [Tensity before rent-income connection](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7BD3252F37-ECF8-4150-9648-5110546B8937%7D).

Completed in the same Teams item October 3 at **9:02:52 AM Eastern** (`2026-10-03T13:02:52Z`), version **1247**, 799,259 bytes. The immediately preceding connector metadata still matched source version 1246. The connector-downloaded replacement has exact SHA-256 `DF8CB5A268CC5026A82DD84DEBD31219600FBBFC73E061DBCBC751A18158538C`, matching the validated local candidate. The full unsaved native test suite passed again on that downloaded file. Tensity can be reopened; other projects were not changed.

Rollback was downloaded and verified against source SHA-256 `C35D51C952DED3057459041C8857D35493FDE93A398CA8D4A48290FB1F580E8A`.

[Validation archive](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/Shared%20Documents/Property/Project%20Template/Validation%20Evidence/Tensity%20Rent%20Profit%20validation%2020261003.zip) contains baseline/final native snapshots, zero-issue preservation audit, downloaded-file tests and Profit/Rent previews. Its connector-downloaded SHA-256 is `2A8F22AC6815FEE333A3EF6E645214FD4B7D7E49BF5C1399AA09B2D9752C833D`, matching the local archive. Lease application pages and banking details are not in this archive. Superseded local source/working/verification copies are removed after verification under the working-file rule; durable rollback and evidence remain in Teams.

## Reusable Lessons

The Carrying and Profit mode rules now distinguish lease obligations, landlord-reported collections and confirmed receipts; define rental-month dates; preserve the modeled horizon; prevent Hold double counting; and test existing native behaviors. Formula-array spill caches and native merged error companions require semantic validation rather than raw count comparison. Keep the new income design Tensity-only until Wes authorizes migration.
