# Outrigger Carrying Migration

## Authorization and Sources

- Wes authorized Outrigger, confirmed it saved and closed, then authorized the active-project batch with manual grid values taking precedence over table values and blank Vendors filled from Category.
- Target: `Property/27_Project Management - 7001 Outrigger Dr.xlsm`, same Teams item `01ZGFUBDLI2T63UQHIQVGZVZH4LRMVCLTC`; source saved September 24, 2026 at 13:00:55Z, eTag version 555.
- Prototype: fresh active `Property/26_Project Management - 908 Pond St 3.xlsm`, saved September 30 at 21:52:40Z. Prototype expense records and pending form inputs were not copied.
- Rollback: `Property/Project Template/Rollback Copies/27_Project Management - 7001 Outrigger Dr.before-carrying-20260930-2117.xlsm`, Teams item `01ZGFUBDKDFJ6VICJEF5FJZFJ5V634FTXU`.
- Replacement saved September 30, 2026 at 9:27:04 PM Eastern (October 1 at 01:27:04Z).

## Independent Mapping

| Item | Before | After |
| --- | --- | --- |
| Source table | AI2:AS134, 132 rows | AL2:AV134, 132 rows |
| Vendor fields | 132 blank | Category defaults in all 132; no verified vendor identity invented |
| Water May 28, 2026 | Table AN86 = 55.15; grid Q12 = 38.78 | 38.78 in matching source row |
| Water June 27, 2026 | Table AN87 blank; grid Q13 = 77.56 | 77.56 in matching source row |
| Water subtotal | 331.79 | 392.98 |
| Carrying cost | Profit B42 = 15,818.27 | Profit B43 = 15,879.46 |
| Labor subtotal | Not present | Carrying AI29 = 0, Profit Labor row 41 |
| Docs E39 | Carrying E5, a mortgage payment | Profit C9 = 2,200 |
| Profit return date references | L82 referred to date headings J73/H73 | L83 refers to actual dates J75/H75; retains this project's J83 numerator |
| Review destination | Carrying absent | Appended to existing B5:B225 dropdown |

Water matches were verified by exact grid/table date values. Notes preserve original grid coordinates and previous amounts. Net authorized expense change is +61.19. Other category totals are unchanged: Duke Electric 616.92, Mortgage Payment 11,119.56, Private Money 3,750, others zero after existing escrow offsets.

There were no literal numeric-zero Amount records to delete. After recovery, 91 blank Amount records remain intentionally; blanks are not numeric zero and still display as zero in the grid. Repeated dates with different records were not deduplicated. Category capacity is at most 19 records, within the 21-row display.

The complete source block was moved through an empty temporary area before adding Labor. The complete grid including its referenced blank tail was moved below itself, then to row 5. Current Pond form and grid formatting were copied, but source records, escrow formulas and totals remained project-specific. Added named inputs, linked Include checkbox, Insert Record and Recurring Bill controls, hidden AX Vendor helper, and the current reviewed VBA modules. Existing VBA source was verified unchanged.

## Validation

- Raw XML/formula audit compares all original cells, including formulas beneath merged cells, mapped references, resolved styles, tables, names, print settings and existing controls. Shared formulas are expanded before comparison.
- No unexpected cell/formula/style changes, no missing controls and no external workbook links. Two existing Profit errors were removed; the two existing MOG errors remain.
- All 132 native displayed date/amount pairs match the source records. Flip/Hold/Slow Flip controls, original Hold selection, private-lender checkbox, Review request marker and rent link verified.
- Native macro tests passed: blank input, insertion, literal text, leading-zero invoice numbers, duplicate and repeated-click prevention, filtered/excluded duplicate checks, negative credit, Include No and immediate Labor/Profit recalculation. Test records were not saved.
- Recurring tests passed: Vendor/Category grouping, explicit category choice, latest description, blank latest amount, filtered records, retained input date/formula, 14 synthetic date-pattern cases and actual project histories. Future blank forecasts remain part of the history; Property Taxes therefore suggests August 28, 2042, not a presumed current due date.
- Native PDF previews of Carrying and affected Profit rows were visually checked. Buttons have matching dimensions and do not overlap the grid.
- Freshness checked immediately before replacement; same Teams item retained. Download SHA-256 matches validated output: `0E9D7F16B7837BC545C5262CE1AB79EF7164EAA6FF65A49B37C10833E5A6BC19`.
- Post-download unsaved native verification passed: insertion, automatic Labor/Profit totals, duplicate checks, controls, real recurring histories and multi-category handling. No test edits saved. Superseded temporary workbooks and previews removed after verification; rollback remains in Teams.

## Unresolved Source Issues

- Mortgage Payment record originally on table row 31 is dated January 20, 1900 with amount 727.42. Preserved and flagged; no unsupported date correction.
- MOG E16 and E26 retain pre-existing `#DIV/0!` errors outside this migration scope.
- Existing future blank schedules can produce future recurrence suggestions and visible zero amounts. They were not deleted under the numeric-zero-only cleanup rule.

## Lessons

- Audit blank Vendor fills even when the original XML omitted empty cells; validate every filled record against its own Category rather than treating the new XML cell as an unexplained addition.
- Existing option-control names differ between projects: Outrigger uses `Mode Option B1/C1/D1`, not Tensity's numbered shape names. Inspect names and links before tests.
- Native control geometry can change with saved anchors. Match the recurring button dimensions explicitly and verify after native reopen, even when copying the latest template's controls.
- Grid-first recovery must precede numeric-zero deletion. Rose's next mapped candidate has an actual grid electric bill over a zero table placeholder; deleting first would lose its direct record mapping.

## Remaining Batch

Rose inspected read-only: 152 source records at AI2:AS154; grid A17/B17 gives June 17, 2026 and 66.61, while matching table row 16 has the same calendar date with a time fraction and zero amount. Recover that bill/date before deleting the other zero rows. Initial numeric-zero count is 116, of which one is the recovered bill. Rose is not edited or delivered yet.

Other approved active targets remain pending independently confirmed closure and migration: Rose, Banks, Pinetree, Pleasant Garden, Rosebrooks, Cool Springs, Britton and Tensity's remaining recurring-module upgrade. Pond is already enhanced and remains the prototype. No Amortization changes are authorized by this Carrying batch.
