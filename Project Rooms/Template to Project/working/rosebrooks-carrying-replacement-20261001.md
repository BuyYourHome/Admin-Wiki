# Rosebrooks Carrying Replacement

## Authorization And Status

Wes authorized replacing the entire Carrying tab with the new model, creating table data rows from the old grid's values, and retaining the old tab. This supersedes the earlier Rosebrooks deferral for the Carrying design. Banks remains deferred. The Rosebrooks rent/Docs question remains deferred.

Status: completed and verified in the live Teams item, version 158, saved 2026-10-01T13:52:57Z (9:52:57 AM Eastern). Exact downloaded SHA256 matches the validated build; downloaded-copy native entry, recurrence, selector, date/amount and VBA tests passed without saving test data. Wes may reopen Rosebrooks. Initial upload was rejected with HTTP 423 at 13:48:55Z; after Wes reconfirmed closure, fresh source bytes still matched and the retry succeeded. No lock bypass was used.

## Fresh Sources

- Target: `Property/20_Project Management - 115 Rosebrooks Dr.xlsm`, item `01ZGFUBDKNFHBV4Q4X65DYNEVWA5RYUHRG`. Initial mapping used version 152; implementation refetched the owner save 2026-10-01T13:04:04Z, version 156. Source SHA256 `83EA8692023468DF958ABEA93D38410C0B9DF4EB93F3FF9FFA1C3AF2642377E1`. Before upload, version 157 had identical bytes and save time, verified by a fresh download.
- Prototype: `Property/26_Project Management - 908 Pond St 3.xlsm`, item `01ZGFUBDLVK7BSTEO4Z5D2YYXQAVBZT7UB`, version 88, saved 2026-10-01T12:50:42Z. Fetch both again if Teams changes before implementation.
- Prototype SHA256 `F3472F537753736A2D41B8511AF640F2646404AE37BE8EE639CBA70AC2339C7B`.
- [Open Rosebrooks](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7B5EC3294D-9743-47F7-8692-B607638A1E26%7D&action=default).

## Approved Value-Snapshot Interpretation

- Rename the existing tab `Carrying - Old`; retain its cells, formulas, formatting, and calculation logic. Native reference changes from the name and supporting Profit row insertion are expected and must be audited.
- Copy the approved current Pond Carrying design natively into an adjacent new `Carrying` tab. Clear prototype records, pending form entries and tax escrow offsets; never transplant Pond expenses or assumptions.
- Snapshot saved typed dates and amounts from Rosebrooks grid detail rows 3:48, not formulas or subtotal row 49. Preserve the original formula text and cell coordinates in each new record's Notes. This is not independent verification that a payment occurred.
- Map 24 records: 18 nonzero amounts and six dated records with blank Amount (five Mortgage Payment, one Private Money). Mark blanks `Missing Data`; retain blanks as blanks. Other records use `Migrated Snapshot`.
- Omit 196 zero-valued grid entries from the snapshot, including 172 formula results and 24 literal zeros. Their original formulas/values remain on the retained old tab. This explicit value-snapshot replacement differs from ordinary table-to-table migration, which preserves formula-driven zero records.
- Preserve named vendor `Neal Issac` for Private Money; remaining migrated categories have no other known vendor identity, so use their Category. No invoices, source documents, payment confirmations, or dates are invented.

| Category | Old Grid Date / Amount | Snapshot Total |
| --- | --- | ---: |
| Duke Electric | B / C | $0.00 |
| Mortgage Payment | E / F | $4,206.41 |
| Private Money | H / I | $1,875.00 |
| Insurance Payments | K / L | $1,408.19 |
| Water | N / O | $0.00 |
| Natural Gas | Q / R | $0.00 |
| HOA | T / U | $120.00 |
| Property Taxes | W / X | $3,238.60 |
| Total | | $10,848.20 |

## Dependencies And Validation

- Existing Profit Carrying $236,584 is not a source total: its formulas read wrong positional grid cells, including date serials. Reconnect by category to the new grid totals; expected new Carrying total $10,848.20. Add the approved Labor row and Review destination. Preserve mode and other inputs.
- Apply the previously approved Profit return date-reference repair. Do not repair old schedule cutoff logic; the new table stores snapshot values and the old tab retains the legacy formulas.
- Leave Profit C9 text and the deferred Docs E39 meaning unchanged. Native renaming should leave Docs E39 pointing to `Carrying - Old!E5`; do not point it at the new Mortgage display or the text `Net Income:`.
- Guarded implementation: `tools/carrying-entry/map_rosebrooks_grid.py`, `Replace-RosebrooksCarrying.ps1`, `audit_rosebrooks_replacement.py`. Map generated from a fresh source, not a reusable cross-project mapping.
- Required before delivery: Teams rollback, closure/freshness, native build, full original-sheet/reference/style/control preservation audit, exactly 24 mapped table records, no prototype residue/external links/new errors, canonical VBA checks, all date/amount pairs, insertion/duplicate/credit/recurrence tests, visual check, same-item upload, exact roundtrip hash and downloaded-copy native tests.

## Git Coordination

Startup fetched a clean but diverged main. Existing local migration commit `424fb5b4` and remote dispatcher commit `3ef17979` were merged normally without rewriting either commit or manually editing another room. No push requested.

## Executed Validation

- Fresh rollback saved through Teams connector: `Property/Project Template/Rollback Copies/20_Project Management - 115 Rosebrooks Dr.before-carrying-replacement-20261001-1327.xlsm`, item `01ZGFUBDLTPXZ2YDZ3B5HKFI5JHNW5NKEN`.
- Built by native hidden Excel. New `Carrying` follows `Carrying - Old`; source table is `tblCarryingExpenses`, AL2:AV26. Original 26 VBA components preserved; canonical entry and recurring modules verified on reopen.
- Independent raw-XML/shared-formula audit: zero issues. Original cells, constants, formulas, resolved styles, merges, widths, heights, tables, names and controls preserved, except the explicitly mapped changes and native reference shifts. Every old-grid cached value also preserved. New form/grid styles, dimensions, merges and print setup match Pond; no prototype records or tax offsets remain.
- Formula errors decrease from three to one: Profit L83/L85 repaired; pre-existing Profit C30 `#DIV/0!` remains. No new errors or external-link package parts.
- Exactly 24 date/amount pairs match the mapped source. Six missing Amounts remain blank in the table; the grid can display $0.00 for them. Profit total is $10,848.20 in all three selector modes. Docs E39 stays `='Carrying - Old'!E5`, value 45474; business correction deferred.
- Native unsaved tests passed: Include checkbox, insert, leading-zero invoice number, literal formula-looking text, dates, automatic Labor/Profit totals, repeated-click and filtered/excluded duplicate prevention, credits, Include No, invalid category, Vendor dropdown, same-size buttons, recurring matching with changing descriptions/filters, next logical date and preservation of an entered date formula. Test rows were not saved.
- Native Carrying and Profit PDF previews visually inspected. New Carrying shows the full twelve-category grid and both entry buttons. The old layout is retained for inspection.
- Final and delivered SHA256 `98ECF52A46FCB3FF638EBCA4A120F16CA544159DDF749FDE1D84E031624498B8`. Same original Teams item/name, 773,553 bytes. Rejected-upload verification initially returned the old source; only the successful retry's download is delivery evidence.
- Visual evidence archived in `Property/Project Template/Validation Evidence/Rosebrooks Carrying 20261001 grid.pdf` and `Rosebrooks Carrying 20261001 profit.pdf`. Profit preview reflects an unsaved selector test, not a change to the saved original Flip selection. Superseded local sources, working/roundtrip workbooks and previews are removed after verification; Teams rollback and evidence remain.

## Lessons

- Native Worksheet.Copy may silently return without inserting a sheet; assert destination sheet-count increase before selecting or renaming the next sheet. Explicitly copy objects and verify control identities; restore the prior CopyObjectsWithCells setting. Use only reviewed, isolated macro-enabled copies with events disabled; no persistent trust/security setting was changed.
- Keep source and destination open until the copied destination is saved, and use bulk formula reads. The earlier build's Excel process crashed; Windows logged Office module-version mismatch/crash events. Do not label the crash as workbook corruption or assume a successful COM call means preservation. Subsequent clean native reopen, package audit and behavior tests were required.
- Copied sheet-local names can reference an external structured table using a bare `file.xlsm!table[column]` form without square brackets around the filename. Audit workbook and sheet-local names plus external-link package parts. Four unused imported Contract names were removed in a separate native finalization pass; original target names were untouched.
- Compare numeric snapshot data numerically with tight tolerance, not decimal serialization strings (161.42 can serialize as 161.41999999999999). Preserve blank versus zero explicitly.
- A changed Teams ETag does not alone prove changed workbook bytes; fetch and compare. Conversely, a closure confirmation does not override a 423 lock. Never force-unlock, rename around a lock, or claim an upload succeeded when the connector rejected it.
