# Tensity Carrying Migration

## Authorization And Source

Wes selected Tensity first, confirmed Tensity closed, and authorized continuation and Git reconciliation. Scope: current Pond Carrying design and its supporting Profit, Review and Docs integration. No other target, Amortization replacement, invoice posting, source-record deletion or push was authorized.

- Template: `Property/26_Project Management - 908 Pond St 3.xlsm`, Teams save `2026-09-30T18:46:48Z`; SHA-256 `F17D7BB831AC57CB95012DFAA5A96E5A9C56B740EB7319BE433519B2E37907B7`. Fresh connector snapshot, not a previous working build. Pond remained unchanged and no longer needed to stay open after retrieval.
- Target: `Property/24_Project Management - 4121 Tensity Dr 2.xlsm`, item `01ZGFUBDNQEWEPX3YGHZFYAFNBA3XOUXD4`, source save `2026-09-29T19:53:27Z`, ETag 1157. Source SHA-256 `9912D6E24104B2D327569B46C028546E7FF29C10F4E136A9B19A9AEBE32E86F6`.
- Rollback: `Property/Project Template/Rollback Copies/24_Project Management - 4121 Tensity Dr 2.before-carrying-migration-20260930-1925.xlsm`, item `01ZGFUBDLYRMZWRAHDHZDZKLG26QD5KVNB`, created through the Teams connector before edits.

## Independent Mapping

- All 134 records and 11 source headers in `tblCarryingExpenses` preserved exactly, including dated zeros, blanks and space-only schedule amounts. No fixed date/amount overrides were found in the friendly grid. Category counts: Water 20; Duke Electric, Mortgage Payment, Private Money, Insurance Payments, HOA and Property Taxes 19 each. No Labor source records.
- Table/title block moved AI1:AS136 through BA1:BK136 to AL1:AV136; table is AL2:AV136. Existing grid A1:AG29 moved through A1000:AG1028 to A5:AG33, including blank referenced tail and hidden merged-cell formulas. Added Labor AH:AJ, subtotal AI29. Both temporary regions were confirmed empty.
- Copied current Pond form presentation: yellow/black-bordered inputs, row heights 19/25/19/25, column widths, centered first-row headings, smaller Insert Record button and white unmerged W3 feedback. Cleared transient input/feedback; defaults Include TRUE, Source Manual Entry, Status Entered. Added local ce names, linked checkbox, button bound to Tensity and reviewed BYHCarryingEntry module. Existing VBA source unchanged.
- Date/amount formulas retain typed dates and amounts, chronological sorting and anchored row counters. Removed unnecessary VALUE conversion for Tensity's blank/space schedules. Labor subtotal uses SUMIFS by Category and Include. Existing tax escrow offsets/net subtotal preserved; no change to source schedule assumptions.
- Profit: inserted whole row 41 for Labor before Lawn, which moved to 42. Labor B41 reads Carrying!AI29 / B28 and J41 uses the existing Hold/Slow Flip allocation. B43 totals B31:B42 times B28. All original Profit values, formulas and controls follow the row insertion; no Pond financial values copied.
- Profit date repair: old L82 -> L83 uses actual J75/H75 dates instead of headings. Preserved Tensity's J83 profit numerator, not Pond's H75 date-serial numerator. L83 and L85 now calculate 0 instead of their previous #VALUE! errors.
- Docs E39 (Buying Rent): Carrying!E5, $660.59 -> Profit!C9, $1,850, as required by the approved design.
- Review B5:B227 destination list now includes Carrying. Existing 25 Review records, statuses, other validations, controls and invoiceEntryReviewRequest = Review!B1 preserved. No Review rows posted or cleared.

## Before And After

Category totals unchanged: Duke Electric $89.95; Mortgage Payment $3,302.95; Private Money $13,745.55; Water $277.64; Casa Lending, Insurance Payments, Natural Gas, HOA, Property Taxes net, Excavator Rental and Lawn $0. New Labor $0.

Profit carrying subtotal old B42 -> B43 remains $17,416.09. Months carried remains 6.01577909270217. Flip selector remains 1. Private lender enabled remains TRUE, rate 10%, debt $100,000. Operating expense $5,000, rehab $39,038.17487416, marketing $600, start 2025-04-01, end 2025-10-01 and all other project constants preserved by whole-workbook mapped audit.

## Validation And Delivery

- Native hidden Excel only; no visible app or security-setting change. Existing macro events disabled. No openpyxl or package-rewrite authoring; read-only package audit includes hidden merged-cell content.
- Local tests passed: blank/invalid input rejection, literal text/leading zeros, positive entry, credit, Include checkbox, automatic Labor/Profit recalculation, repeated-click rejection, filtered/excluded duplicates and preserved rejected input. Test records discarded without saving.
- All 134 displayed date/amount pairs independently matched to sorted included source records. All fit the 21-row category capacity. Flip/Hold/Slow Flip option buttons, private-lender checkbox value, Review marker and destination dropdown passed.
- Whole-workbook mapped audit: zero unexpected formula/constant differences, zero unexpected resolved style differences, no missing merges/tables/controls, no new errors, no external links. Original 19 error cells reduced to 17 by two approved Profit repairs. 122 dependent formula cells differ in raw source, principally expected row/reference movement; token-aware comparison verifies intended formulas while ignoring Excel's compatibility-prefix/whitespace serialization.
- PDF previews of Carrying and Profit integration visually inspected. Form/button, yellow inputs, Labor section and private-lender checkbox visible; existing merged totals retained. Print settings not saved from previews.
- Rechecked live target unchanged immediately before connector replacement. Same Teams item replaced at `2026-09-30T19:37:59Z`. Fresh connector download exactly matched validated SHA-256 `AF5A334DE78198DA0D5C9EE7F749E75E269ECBA44F6DE881D86800D5644890EA`.
- Post-upload native tests passed on the exact downloaded Teams file: Automatic calculation without forcing it, linked checkbox, successful insertion and immediate Labor/Profit response, credits, invalid input, filtered/excluded duplicates, literal text, leading zeros and repeated-click prevention. All 134 original date/amount pairs, three mode controls, Review marker/destination and Docs rent passed again. No test edits were saved.
- Superseded temporary sources, failed builds, delivered test copy and previews were removed after verification. Live replacement and rollback remain in Teams; Git contains no workbook binaries.

[Open Tensity in Teams](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7BFB8825B0-06EF-4B3E-8015-A106EEEA5C7C%7D&file=24_Project%20Management%20-%204121%20Tensity%20Dr%202.xlsm&action=default&mobileredirect=true)

## Residual Issues And Lessons

The 17 pre-existing error cells and existing broken legacy names remain outside this scoped migration. This is not a whole-workbook financial certification. Existing schedule dates, escrow logic and zero/space placeholders were not endorsed or removed. W3 feedback intentionally follows Wes's unmerged white presentation; a long warning can extend to the right. Normal desktop macro trust still applies; VBA project-object access can be turned off after installation.

Early disposable builds were rejected before save/upload: VBA-project access ordering, an overly strict pre-existing-name check, then a genuine SUMPRODUCT/VALUE failure caused by space-only source amounts. Subsequent fixes did not change live Teams until all local gates passed. Reusable lessons are in Carrying Mode Rules; supporting Profit mapping is in Profit Mode Rules. Stop here for Wes to inspect Tensity.
