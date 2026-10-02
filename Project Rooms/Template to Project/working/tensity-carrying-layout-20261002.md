# Tensity Carrying Layout and Context

## Scope and Source

Wes requested consistent category widths from G:H:I, evenly spaced top buttons, preservation of his two added rows/heights, then button-specific contextual instructions and orange fill across the grid. He confirmed saved/closed. Tensity only; prepare later all-project migration, do not execute it yet.

- Live item: Property/24_Project Management - 4121 Tensity Dr 2.xlsm, `01ZGFUBDNQEWEPX3YGHZFYAFNBA3XOUXD4`.
- Fresh connector source saved October 2 at 17:46:25Z, version 1235; source SHA256 `D4E3E34590AFE80B8D37E546CE64B7401EAD88FFA998046D38439BB4780DC919`. Metadata remained identical immediately before replacement.
- Table AL4:AV60, 56 records. Grid names shifted automatically to A7:AJ7 and A10:AJ30; form starts row 3. Total $28,224.97; Labor $6,207.47. Owner form holds an unfinished Neal Isaacs edit; preserve ceEditActive=TRUE and all fields.
- Teams rollback: `Property/Project Template/Rollback Copies/24_Project Management - 4121 Tensity Dr 2.before-carrying-layout-20261002-1346.xlsm`, item `01ZGFUBDMLL7XS3JK2TJGKGHTNJAGVFKYA`.

## Implementation

- Date/amount/spacer widths 10.14/9.00/2.86 repeated across A:AJ. AA remains 9.14 because it contains escrow amounts; exact narrow-width preview produced ####. Exception disclosed to Wes; awaiting review, not a global exception assumption.
- Preserved rows 1 and 2 at 23.25 points, all existing row heights and button dimensions. Order Recurring Bill, Insert Record, Edit Record, Save Changes, Cancel Edit; equal gaps 101.8125 points, vertically centered in the two-row top band left of W.
- Added named merged W1:AJ2 context box, ceButtonContext, gray background and wrapped 10-point text. Each button updates action-specific explanation. Original ceFeedback remains Z5 and shows actual outcomes. Context is best-effort and optional on older installs.
- Applied existing H11 orange #FFC000 to A7:AJ31, including category headings, date/payment headings, spacers and totals. Yellow input cells and source-table formatting unchanged. No new protection or record changes.
- Updated only BYHCarryingEdit, preserving every other VBA component. Source gate accepts only observed Application.GoTo/Err.description VBE capitalization normalization relative to approved commit 27cb3d7b. No security settings changed; hidden native Excel preserved XLSM controls/macros that the generic XLSX authoring path cannot safely roundtrip.

## Validation and Delivery

- Before/after native PDFs visually inspected. No clipped grid dates or amounts in delivered candidate; original source-reference field truncation remains owner layout. Context and controls fit without overlap. Escrow exception prevents newly hidden amounts.
- Whole-workbook preservation audit: zero issues after narrowly allowing requested widths, orange fill, context-box cell/merge/style and one new name. All 17 pre-existing errors remain, no new errors; values/formulas/records/tables/other styles/validation/row heights/print settings preserved.
- Native tests passed: all five context strings, relocated-grid load, save/cancel/no-op, literal text, duplicate rejection, unchanged source formulas/blanks/date fractions, concurrent-change rejection, sorted-row identity, protected sheets, event-state preservation and saved-active-edit safeguards. Tests discarded, not saved.
- Live upload October 2 at 18:04:34Z. SHA256 `123E29FEE28A53EA4808BD671A27D17CEF2DC6AE3F21E604D75A8451DF8E413F`, matched exactly by fresh connector download. Downloaded native tests passed with no test edits saved. Superseded temporary workbooks removed; approved preview retained for Wes's inspection.
- Preview archived at `Property/Project Template/Validation Evidence/Tensity Carrying Layout 2026-10-02.pdf`, item `01ZGFUBDLQ3HGJF5WMCJAYJQPMZ3ERT5KP`.

## Migration Lessons

- Uniform third-column widths are unsafe where the third column contains data rather than whitespace. Inventory every category independently before formatting.
- Use named ranges after owner row insertion; test fixtures must not hardcode former grid coordinates.
- Preserve active edit state and pending inputs. Reopening requires cancellation/reload by design; do not mistake that for a formatting regression or silently clear the form.
- Reserve context-box space before distributing buttons, preserve the separate result message, and test all action paths, including rejected operations.
- Rollout plan is in [[carrying-migration-plan]]. Only Tensity was changed. No push authorized.
