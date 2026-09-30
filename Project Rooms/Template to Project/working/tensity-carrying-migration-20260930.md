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

## Approved Zero-Dollar Cleanup - Delivered

Wes subsequently approved deleting Tensity's zero-dollar records and making this a required Carrying migration step. Blank/space amounts and credits remain. Category headings remain even when empty. This supersedes the original no-deletion scope above for numeric-zero records only.

- Fresh Teams source saved `2026-09-30T19:45:23Z`, newer than the initial migration delivery; SHA-256 `919C2477753AFF7FA800A864E8996D4C63BAE1C11A66D020C76BD1834CDEB9DD`. This later owner save is the cleanup base.
- Rollback: `Property/Project Template/Rollback Copies/24_Project Management - 4121 Tensity Dr 2.before-zero-cleanup-20260930-1947.xlsm`, item `01ZGFUBDIPLIUMVGXL3VGLNRMYPRQAHJBM`.
- Prepared locally: 93 numeric-zero rows removed, 41 records remain, table AL2:AV43. Per-category deletion counts: Duke Electric 12, Mortgage Payment 14, Private Money 4, Insurance Payments 19, Water 15, HOA 13, Property Taxes 16. Ten blank/space-only amounts remain; two true blanks can display $0.00. Category totals and Profit B43 remain unchanged at $17,416.09 in aggregate.
- Validated cleanup SHA-256: `A44EAC61E4E95920B3EFF50B9CFC9333784D3FF3A179D7AD067EE202E57D066B`. Temporary source/build/download copies are superseded after delivery; the live file and rollback remain in Teams, not Git.
- Local validation passed: all 41 date/amount pairs, preserved survivor content/styles, formulas outside the source table, names, controls, table definitions/ranges, merges, print settings, no new errors/links, Automatic calculation, checkbox, manual insertion, credits and filtered/excluded duplicate checks. All three Profit mode controls, Docs rent and Review marker/destination passed. Native VBA source comparison passed for every component although Excel changed VBA binary metadata. PDF preview inspected; no test entries saved.
- Shared-formula cells must be expanded before a raw XML preservation comparison; Excel may change shared-formula serialization without changing formulas. The cleanup audit resolves them through a read-only workbook reader and still checks hidden merged-cell contents from XML.
- Wes confirmed closed. Rechecked Teams source unchanged at 19:45:23Z, ETag 1163, then replaced the same item through the connector at `2026-09-30T20:07:54Z`. Fresh connector download matched the validated hash above exactly.
- Post-upload native tests passed: Automatic calculation, entry/checkbox behavior, immediate Labor/Profit recalculation, credits, filtered/excluded duplicates, literal text, leading-zero invoice IDs and repeated-click protection. All 41 displayed date/amount pairs, three Profit mode controls, Review request marker/destination and Docs rent passed. Tests were discarded without saving. No other project started and no push authorized.
