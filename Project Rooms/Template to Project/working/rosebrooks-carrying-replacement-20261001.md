# Rosebrooks Carrying Replacement

## Authorization And Status

Wes authorized replacing the entire Carrying tab with the new model, creating table data rows from the old grid's values, and retaining the old tab. This supersedes the earlier Rosebrooks deferral for the Carrying design. Banks remains deferred. The Rosebrooks rent/Docs question remains deferred.

Status: mapping and implementation prepared; workbook edits and Teams replacement have not run. Awaiting the requested confirmation that Rosebrooks is saved and closed. Native read-only source previews do not save either workbook. The installer and audit have passed syntax checks, not execution validation; do not treat them as a delivered workbook.

## Fresh Sources

- Target: `Property/20_Project Management - 115 Rosebrooks Dr.xlsm`, item `01ZGFUBDKNFHBV4Q4X65DYNEVWA5RYUHRG`, version 152, saved 2026-09-30T12:48:56Z. Source SHA256 `F9FD1B1ABD55F9AE51C64209985ABDE5542663435678C324368042C38172DDB5`.
- Prototype: `Property/26_Project Management - 908 Pond St 3.xlsm`, item `01ZGFUBDLVK7BSTEO4Z5D2YYXQAVBZT7UB`, version 88, saved 2026-10-01T12:50:42Z. Fetch both again if Teams changes before implementation.
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
