# Carrying Manual Entry

Workbook-side design owned by Template to Project. Operational invoice posting remains Invoice Entry's responsibility. This implementation is for Excel desktop XLSM workbooks, not Excel Online. It does not send requests or modify Review records.

## Package

- `BYHCarryingEntry.bas`: standard VBA module; uses ThisWorkbook, workbook input names, and table column headers. Never uses the active workbook or an external project path.
- `Install-CarryingEntry.ps1`: native hidden Excel installer for an independently mapped A1:AJ grid with its source table to the right. Requires fresh connector source and a new output path. Refuses repeat installation and module collisions.
- `Test-CarryingEntry.ps1`: native Excel tests on an isolated copy; never saves test records. Current assertions are mapped specifically to Pond's moved grid and Profit links.
- `audit_package.py`: read-only Pond source/output package audit. It does not save workbooks through openpyxl. Compares formulas, constants, resolved styles, merges, names, tables, controls, links, print settings and saved errors. The mapped move is A1:AJ29 to A5:AJ33, with the visible grid ending at row 29.
- `Migrate-Tensity.ps1`, `Test-Tensity.ps1`, `audit_tensity.py`: independently mapped September 30 Tensity migration and read-only/unsaved checks. Not a generic batch runner. Relocates Tensity's source block, uses current Pond form formatting, adds Labor and supporting Profit/Review/Docs changes, preserves existing records and tests all 134 displayed pairs.

These are migration building blocks, not an authorized batch runner. Re-map each project independently before adapting installation and validation. Do not copy Pond's records to another project.

Required follow-on for authorized Carrying migrations: `Remove-CarryingZeroRows.ps1` removes literal numeric-zero records after independent mapping. Supply verified source row count, numeric-zero count and Profit subtotal address. Preserve blank/space amounts, credits and formula-driven values; retain headings and reconcile all survivors/totals. This requirement was approved after Tensity's initial migration, so the historical `Migrate-Tensity.ps1` build alone is no longer the complete migration pipeline. See Carrying Mode Rules.

## Interface

Four rows above the Carrying grid contain yellow Date, Category, Vendor, Description, Amount, Include, Invoice #, Source, Source File, Notes and Status inputs. Category uses the mapped category list; Include is a linked native checkbox. Insert Record calls `CarryingEntry_Insert`. Latest owner formatting uses white, unmerged feedback at W3; the original Pond installer retains its historical orange merged feedback. For migration use the current saved template, not stale installer formatting. Long feedback can extend to the right; no owner approval to redesign that presentation has been given.

The `ce` workbook names identify each input; `ceCategories`, `ceDisplayCapacity` and `ceVersion` identify configuration. Names refer to individual anchor cells, not whole merged ranges. The button is bound to the destination workbook's filename without a local path; rebind during a file rename or migration.

Required manual-entry fields: valid date, listed category, vendor, description and numeric amount. Negative credits are supported. Source defaults to Manual Entry; Status defaults to Entered, which is not invoice approval or evidence of payment. Optional invoice and source references should be supplied when available. Include controls whether the existing grid/Profit formulas count the record.

Insertion checks all table rows, including excluded and filtered records. Same vendor/amount with the same nonblank invoice number, or the same vendor/category/date/amount, is flagged as a possible duplicate. A legitimate matching bill requires source-table review; the button deliberately provides no bypass. This is a conservative manual-entry check, not Invoice Entry's cross-destination source-line reconciliation.

Only one new ListRow is appended, by header. User text is stored literally, preserving leading zeros and preventing formula injection. The record is verified before fields are cleared. Failures preserve input; an incomplete new row is rolled back when possible. A reentrancy guard and cleared successful input prevent repeated-click inserts. No email, external file transfer, approval, payment, workbook save or query refresh occurs in the macro.

The display remains a fixed-height grid. All included rows affect the full-category subtotal; feedback warns when a category exceeds configured display capacity. Do not claim the grid automatically expands.

## Installation And Validation

1. Confirm exact project, closure and approved scope. Fetch current Teams item and preserve a timestamped Teams rollback. Check source hash/version again before replacement.
2. Inventory every project's table schema, actual records, category labels, blank tail references, all downstream references, controls, VBA and print settings. Any occupied temporary move area, source table overlap, protected VBA or conflicting names needs reconciliation before installation.
3. Use a reviewed, isolated hidden Excel instance. Do not automate security settings. VBA project-object access requires Wes's explicit enablement; disable it again after installation. Existing events remain disabled while building/testing; review existing macro source before allowing the isolated copy's code to execute.
4. Move the complete presentation block, including blank rows referenced by formulas, to a confirmed empty area below itself. Reacquire the moved Range, then move the complete block to its final location. Never use an overlapping move of the merged grid. Do not insert entire worksheet rows through the source table.
5. Add the form/module, bind controls/names, preserve source records and existing macro source, restore Automatic calculation while preserving iteration settings, recalculate and save natively.
6. Reopen normally in fresh hidden Excel. Test blank input, category validation, literal strings, leading-zero invoice numbers, credits, Include checkbox, immediate recalculation, duplicate/repeated clicks and duplicates hidden by a table filter. Test data must never remain in the deliverable. Verify all original totals and records, including the source table's location.
7. Audit saved content and render the actual final layout. Resolve style IDs and differential-format IDs before comparison; native Excel can renumber them without changing formatting. Audit raw cell XML too: merged cells can contain hidden legacy formulas that a high-level reader hides.
8. Replace the same Teams item through the connector only after freshness and validation pass. Download the uploaded file, match its SHA-256 and run unsaved native tests again. Retain rollback, remove superseded temporary workbooks, document lessons and commit this room's scoped source. Do not push without authorization.

## Vendor Prefill Extension

`BYHCarryingPrefill.bas` adds the separate `CarryingEntry_Recurring` button handler and testable `CarryingEntry_Prefill` function. `Install-CarryingPrefill.ps1` is a guarded fresh-install tool, not an unattended batch or in-place module updater. Require independently mapped `ExpectedTableAddress`, `ExpectedBlankVendors`, and explicit `FillBlankVendorsFromCategory` approval. It installs a dynamic Vendor list in hidden AX, adds a same-size button below Insert Record, and moves named feedback and its message to Z3. Existing insertion code remains unchanged. Existing prefill modules require source comparison and a scoped upgrade rather than rerunning this installer.

Select a vendor, click Recurring Bill, then review Date and Amount before Insert Record. Matching uses Vendor + Category only. Description is copied from the latest record; differing descriptions do not trigger a prompt or split date history. Multiple categories prompt selection of a source-table cell to identify the category, then the latest record in that category supplies the fields. An entered Date or formula is preserved. When Date is blank, the three latest distinct matching dates are used to attempt weekly, monthly, quarterly or annual recurrence, with month-end and leap-year handling. Monthly-based billing jitter is limited to three days; unclear or insufficient history leaves Date blank. Invoice number, source-file reference and notes are cleared; Source and Status reset to Manual Entry and Entered. Blank latest amounts remain blank. Nothing is inserted or saved by prefill. The suggestion advances the latest matching record, not today's date, and does not establish whether a bill is due or paid.

`Update-CarryingPrefill.ps1` upgrades only an existing prefill module after comparing its source with an explicit approved Git commit. It tolerates only the observed VBE capitalization normalization of `Err.Description`; other differences stop the update. Verify every other VBA component unchanged and run `audit_vendor_prefill.py source result 0 --module-only` to require cell/formula/style/table/name/validation preservation. See [[pond-recurring-category-match-20260930]].

Run the project-specific prefill tests, existing insertion tests, and `audit_vendor_prefill.py source result approvedBlankVendorCount` against the fresh source and result. `Test-CarryingPrefill.ps1` contains initial Tensity baseline assertions; `Test-CarryingRecurringDates.ps1` tests date edge cases and Pond examples. Independently remap expectations for later projects. Tests are unsaved. The audit resolves differential-format IDs and permits Excel's hidden LET compatibility name; it does not write workbooks. See [[tensity-vendor-prefill-20260930]] and [[pond-recurring-date-20260930]].

## Security And Limits

Do not enable all macros globally or create a broad trusted folder. VBA project-object access is needed to install code, not for ordinary use of the button; Wes can turn it off again. Normal workbook macro trust still applies. If organizational policy blocks the macro, obtain an approved signing/deployment path rather than weakening that policy.

The code requires a writable, unprotected destination table. It preserves rather than repairs unrelated workbook errors. Tests for this iteration do not establish that unrelated legacy macros or every financial assumption are correct.
