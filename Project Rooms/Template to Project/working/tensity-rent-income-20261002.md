# Tensity Rent Income Category

## Authorization and Source

Wes requested a three-column Rent category while retaining his merged/formatted instruction boxes. He confirmed saved/closed and clarified Rent is recurring income, not an expense, and must not roll into expense totals. Scope is Tensity only plus future migration rules.

- Source: same Teams item `01ZGFUBDNQEWEPX3YGHZFYAFNBA3XOUXD4`, `Property/24_Project Management - 4121 Tensity Dr 2.xlsm`, version 1241 saved October 2 at 18:36:26Z. Fresh connector bytes SHA256 `CAD8DBD622B0CFF6C2AEB4E628186BE892160AAA5D63126FBD202DA95C8B3AC1`; metadata unchanged before upload.
- Rollback: `Property/Project Template/Rollback Copies/24_Project Management - 4121 Tensity Dr 2.before-rent-income-20261002-1436.xlsm`, item `01ZGFUBDL5T5C3R4UKINAL5VEQA2ZPUMW6`.

## Mapping and Change

- Native whole-column insertion at AK:AM moved the former AK spacer to AN, source table AL4:AV60 to AO4:AY60, table title accordingly and hidden AX Vendor helper to BA. All 56 records and all VBA modules remain exact.
- Copied Labor's three-column presentation into AK7:AM31, changed category heading to Rent, and retained the existing date/amount formulas relative to that heading. Rent subtotal is AL31; starts at zero without placeholder records. Widths 10.14/9/2.86 and orange fill match the approved grid.
- Appended Rent to ceCategories and the Category dropdown. Extended ceEditHeaders to A7:AM7 and ceEditGrid to A10:AM30. Vendor helper reference and table-dependent formulas shifted natively.
- Preserved the owner's green instruction/result boxes, fonts, borders, wrapping, merge geometry and button placements. Corrected ceButtonContext from outdated W1:AJ2 to actual Y1:AI2. ceFeedback remains Y4, inside Y4:AI5. Context text reflects grid-selected recurrence.
- Rent is income. Profit B43 remains exactly `=+B28*SUM(B31:B42)` and its existing category-specific links remain unchanged. Rent neither adds to nor offsets expenses. No separate Profit income link was requested or added.

## Validation and Delivery

- Full preservation audit zero issues after mapping the native three-column move and narrowly allowing new Rent cells, dropdown/category/grid names and context text/name. Original values/formulas/styles, instruction formatting, merges, controls, validations, widths outside expansion, row heights, print setup and names preserved. Formula audit uses parsed range tokens only for changed references, avoiding whitespace reserialization of unchanged MOG formulas/LAMBDA names.
- Original 17 formula errors retained, no new errors. Expense total remains $28,224.97; original record count 56. Native visual preview reviewed with Rent after Labor and both owner-green boxes intact.
- Native tests passed: three $1,250 Rent test rows displayed $3,750, recurrence proposed the next month, editing one row raised Rent to $3,760, every existing expense subtotal and Profit Carrying Cost stayed unchanged. Original records remained exact. Dropdown, instruction updates, automatic calculation and no saved test data verified.
- Delivered to same Teams item October 2 at 18:50:07Z (2:50:07 PM Eastern). Downloaded SHA256 verified as `8E834412F32586F8666CF739FE3540FE203EB04D393958264D4D2CF4B35995AA`. Downloaded native tests passed, with no saved test records. Superseded working workbooks removed; rollback and approved preview retained. Wes can reopen Tensity.
- Preview: `Property/Project Template/Validation Evidence/Tensity Carrying Rent Income 2026-10-02.pdf`, item `01ZGFUBDJCUPILDOWPUVG25SMODOLCTFQK`.

## Lessons

- Category classification is owner-defined, not inferred from a tab/table name. Rent income must remain excluded from expense aggregation even though it shares manual and recurring controls.
- Existing source/helper areas may occupy the requested expansion columns. Move them natively and map original records/formulas, rather than overwriting or appending a distant disconnected display.
- Compare actual style properties or resolved XML styles, not COM Style object identity, to verify formatting preservation.
- Other projects unchanged; the expanded mode is documented for later authorization. No push requested.
