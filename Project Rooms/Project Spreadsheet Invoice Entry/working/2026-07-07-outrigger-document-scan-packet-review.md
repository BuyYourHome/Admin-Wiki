# 2026-07-07 Outrigger Document Scan Packet Review

## Scope

Reviewed two Document Scan handoff packets for `27-HM- 7001 Outrigger Dr`:

- `sources\document-scan-packets\2026-07-07 - 7001 Outrigger - Atlantic Discount Flooring - 001199.md`
- `sources\document-scan-packets\2026-07-07 - 7001 Outrigger - GTI Stone Design - 101492.md`

Target workbook named in both packets:

- `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27_Project Management - 7001 Outrigger Dr.xlsm`

Live workbook processing was completed after Wes added the `Review` tab and closed the workbook.

## Workbook Duplicate Check

The local Teams-synced workbook could not be opened directly by the read-only workbook library because the file reported a permission error. A same-timestamp read-only staging copy was made for duplicate inspection only, then removed after the inspection.

Read-only workbook search results:

| Packet | Workbook duplicate result | Notes |
| --- | --- | --- |
| Atlantic Discount Flooring LLC invoice `001199`, `$4,629.65`, dated `2026-03-09` | No workbook duplicate evidence found | No hits for invoice number `001199`, vendor name `Atlantic Discount Flooring`, or exact amount `$4,629.65`. The invoice date appears elsewhere in the workbook but not with the vendor/amount/invoice number. |
| GTI Stone Design Corporation invoice `101492`, `$4,563.00`, dated `2026-03-17` | No workbook duplicate evidence found | No hits for invoice number `101492`, vendor name `GTI Stone Design`, exact amount `$4,563.00`, or `Borris`. The invoice date appears in `Carrying!AK9`, but not with the vendor/amount/invoice number. |

## Placement Review

| Packet | Placement status | Notes |
| --- | --- | --- |
| Atlantic Discount Flooring LLC `001199` | Ready for Wes review before insertion | The packet maps to the approved Vendor Tabs Mode worksheet `Flooring`. Insertion is still blocked until Wes approves the row placement or the missing yellow-section row insertion rule is defined. |
| GTI Stone Design Corporation `101492` | Needs Review | The packet says likely `Cabinets`, but countertops plus sinks could overlap `Plumbing Fixtures`. Do not choose a final vendor tab without Wes review. Also preserve the Document Scan note that `26-03-17 Borris invoice.pdf` may need separate duplicate/source review. |

## Validation Notes

- `Flooring` has no `#REF!` formulas in the read-only inspection.
- `Cabinets` has no `#REF!` formulas in the read-only inspection.
- `Plumbing Fixtures` has no `#REF!` formulas in the read-only inspection.
- `Gnatt Chart` contains existing `#REF!` formulas in later timeline columns. The direct summary link for Flooring is `Gnatt Chart!G14 = +Flooring!I22`, but downstream validation after any insertion should account for the pre-existing `Gnatt Chart` formula issue.

## Decision Needed

Before insertion:

1. Confirm whether Atlantic Discount Flooring invoice `001199` should be inserted into `Flooring`.
2. Define or approve the yellow actual-invoice row placement rule for Vendor Tabs Mode.
3. Decide the final worksheet for GTI Stone Design invoice `101492`: `Cabinets`, `Plumbing Fixtures`, or another approved tab.
4. Decide whether the `26-03-17 Borris invoice.pdf` file requires Document Scan/source review before GTI is inserted.

## Completed Processing

Completed on 2026-07-07 against:

- `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\27_Project Management - 7001 Outrigger Dr.xlsm`

Rollback copy:

- `C:\Codex\Wiki Files\Project Rooms\Project Spreadsheet Invoice Entry\working\backups\27_Project Management - 7001 Outrigger Dr.before-invoice-entry-20260707-125449.xlsm`

Actions:

- Inserted Atlantic Discount Flooring LLC invoice `001199` into `Flooring!A8:H8`.
- Used the first blank yellow actual-invoice row in the `Flooring` tab.
- Preserved the existing row formulas: `G8 = C8*F8*E8` and `H8 = +G8*0.0725`.
- Set the unit cost so existing subtotal plus tax formulas calculate to the paid invoice total of `$4,629.65`.
- Left the `Flooring` template selector unchanged at `Yes`; therefore the current `Flooring` worksheet total and `Gnatt Chart` direct Flooring value remain based on the template estimate.
- Added GTI Stone Design Corporation invoice `101492` to `Review!A2:K2` for final worksheet/category review.

Validation:

- Workbook reopened cleanly in Excel after save.
- `Flooring!A8:H8` contains Atlantic invoice `001199`.
- `Flooring!G8 + H8` recalculates to `$4,629.65`.
- `Flooring!I21` remains `$0.00` because the selector is still `Yes`.
- `Flooring!J22` remains `$8,896.26`.
- `Gnatt Chart!G14` and `Gnatt Chart!H14` remain `$8,896.26`.
- Workbook link count: zero.
- External-link package parts: zero.
- `Flooring` and `Review` have zero `#REF!` formulas.
- `Gnatt Chart` still has pre-existing `#REF!` formulas in later timeline columns; this was not introduced by the invoice entry.

## Review Tab Dropdown

Updated on 2026-07-07:

- Added `Worksheet` as column A on the `Review` tab.
- Added a dropdown validation list to `Review!A2:A200` for choosing the destination worksheet.
- Dropdown choices: `Demo & Trash Haul`, `Appliances`, `Plumbing Fixtures`, `Windows & Doors`, `Cabinets`, `Paint`, `Flooring`, `HVAC`, `Electrical Fixtures`, `Landscape`, `STR`, `Exterior`, `Furnishing`.
- Verified `Review!A2` has Excel list validation and the workbook has zero workbook links.
- Uploaded the updated workbook to Teams/SharePoint through the SharePoint connector signed in as `OfficeAssist@BuyYourHomeLLC.com`.
