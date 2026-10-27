# Entity Reporting Progress

Updated October 27, 2026. Goal remains active under [[Project Rooms/Quickbooks/working/2027-01-01-entity-reporting-goal]]. None of the evidence below establishes completed entity separation, live synchronization, migration, or subscription cancellation.

## Verified Offline Intake

- Implemented `scripts\Capture-QboReportSnapshot.py`: read-only XLSX ingestion into an external SQLite source archive; complete original file bytes and source hashes retained; no transaction/entity allocation or accounting write capability.
- The archive refuses financial storage under the Git repository, source-file overwrite, an unrelated database identity/schema, and corrupted stored snapshot bytes. Same-company/source-byte replay reuses its snapshot. Legitimate repeated report lines remain intact in the source file.
- Coverage inspection distinguishes missing classes, accounts, identifiers and debit/credit columns; blank values and uncached formulas do not become a false balance. Accounting basis comes from recognized report metadata. Input coverage does not imply independently reconciled entity books.
- Twenty-one targeted tests passed using the bundled Python runtime with `-B`, including numeric precision, missing/uncached inputs, report totals, repeated lines, source protection, batch rollback, archive identity and corruption checks. The Windows SQLite fixture handles are explicitly closed.
- A subsequent narrow fix recognizes standalone cash/accrual basis metadata in summary reports without treating them as transaction tables. All 24 tests passed, including summary-metadata rejection and unchanged cached-audit replay. The fix does not rewrite existing snapshots' `audit_json` on replay.
- Independent read-only reinspection of all three preserved BLOBs recognized Cash Basis; source hashes verified, SQLite integrity remained `ok`, and the archive's full-file hash was unchanged before/after. Both summary reports still reported `no_transaction_table_detected`; all sources remained `entity_reporting_ready: false`. Cached historical P&L inspections intentionally retain their original unknown-basis result; fresh inspection evidence is separate.
- Actual capture: three existing BYH 2025 exports; first run created three snapshots, second run created zero. Independent stored-content hashing verified all three exact source copies; SQLite integrity check returned `ok`.
- Verified app-independent archive on `WesStudio`: `C:\Users\wesbr\BYH Quickbooks Data\entity-reporting\pilot-2025\source-snapshots.sqlite3`. This is a local pilot source copy, not the required independently backed-up HM/Home historical archive. No financial files/databases were added to Git.

## Source Coverage Findings

The original 2025 BYH General Ledger (IRS source key T08108) is a cash-basis report covering dated rows from January 1 through December 31, 2025. The inspected worksheet has 4,927 total rows, 4,513 dated report rows across all twelve months, and 172 detected account-section headings. These are report-row counts, not unique transaction counts or proof of posting completeness.

Its nine columns are a blank section-label column, Transaction date, Transaction type, Num, Name, Description, Split, Amount and Balance. It lacks transaction-level class, explicit debit/credit, explicit account-ID and source transaction-ID columns. Account-section headings remain source provenance, not verified account identities. No balanced entity ledger can be certified from this input alone.

Both the owner-accepted original class P&L workbook and the later `upd.xlsx` candidate were preserved separately. The original is 136 rows by 31 columns; the candidate is 141 rows by 29 columns. They are summary reports, not posting tables. The later file's authority and numerical differences are not resolved by its modification date or this structural inspection.

### Verified Report-Revision Conflict

A subsequent read-only comparison inspected both workbooks without saving them. Their source hashes remained the values below. Both reports identify `Buy Your Home LLC`, `Profit and Loss by Class`, January-December 2025, and Cash Basis. Their printed generation footers differ: June 11, 2026 at 02:42 AM GMT+03:00 versus September 23, 2026 at 01:20 AM GMT+03:00. These are the report's printed timestamps, not local-time assumptions or proof of a shared extraction cutoff.

- The company Net Income controls differ: original `Sheet1!AE132` versus candidate `Sheet1!AC137`. This is not only a class relabeling or display-width difference.
- The BYH, HM and Not specified Net Income controls also differ. Their source cells are respectively `S132`, `AA132`, `AD132` in the original and `Q137`, `Y137`, `AB137` in the candidate.
- The original BYH group contains `2325` and `7001` columns absent from the candidate's BYH group. Property labels repeat under HM, so a flat label/column-position join would misidentify classes. Preserve the full hierarchy and exclude subtotal columns from leaf-column sums.
- The changed attorney-fee subclass is relevant to a provisional manual adjustment recorded in private IRS workpapers. `CURRENT-CORRECTIONS.md` and `ROSEBROOKS-TITLE-COSTS-2025.md` under `C:\Users\wesbr\AppData\Local\BYH\IRS\2025-draft-returns` explicitly require rechecking/rebasing that overlay when a refreshed P&L arrives. A matching amount is not transaction-level class or payment-application proof. No IRS workpaper was changed, and no tax conclusion or posting was made.
- Keep the owner-accepted original baseline and September candidate as distinct revisions. Neither the current snapshot archive nor this comparison certifies a compatible source set. Do not combine the candidate with the old ledger or copy legacy manual adjustments onto it until the source changes and existing overlays are reconciled.

The next pilot source package must identify a consistent source revision/cutoff, exact report filters and basis, companion ledger/control reports, and the authority for selecting that set. Exact requirements are in [[Project Rooms/Quickbooks/working/entity-reporting-feed-contract]].

| Preserved Source | SHA-256 |
| --- | --- |
| Original BYH 2025 GL | `8b44ba1b694029b9093e2ac7efb968c70d70a0d9b0dbb31e10de2b7ad3ca2d6c` |
| Original BYH 2025 class P&L | `bd8a581956a084973c3ec1029d17e0fa1d232c4f102141054f6540f9a86eb660` |
| Updated BYH 2025 class P&L candidate | `6810f8d6fdbb29ac1dfd7f74b1f30501351b7b8cede93ade6561d863236dbc53` |

## Immediate Preservation Priority And Access Evidence

[[Project Rooms/Quickbooks/working/hm-home-preservation-package]] is prepared for the exact HM and Home company files. Bounded metadata searches found no standalone company archive in the searched CPA yearfolders/catalog. The combined BYH source is not a replacement for either archive.

Two browser inventory calls on WesStudio timed out and reset their kernel without returning browser/company state. A read-only task-reader request for registered Quickbooks task `01a05967-9a05-7081-a62e-616b2d8e61fd` could not determine its existence and reported host `durable` unavailable; this is not proof the task is stopped or absent. Plugin Management search for `QuickBooks` returned an empty plugin list. No remote notification, authenticated export, subscription change, or financial action occurred.

The next external dependency is usable authenticated, read-only access to the actual companies, preferably through the registered Quickbooks execution task on WES-VIDEOEDITOR. If the current observation failure is transient, recheck that same task/connection rather than creating a replacement. Preserve existing work and resume when access is restored.

## Remaining Goal Requirements

- Export and independently verify complete HM/Home archives before relying on preservation for cancellation. Confirm retained-subscription login/read-only conditions and exact company identities.
- Obtain posting-complete pilot data, account/class master lists, independent opening/closing controls and settlement links; resolve the original versus updated P&L authority without discarding the owner-accepted baseline.
- Confirm the exact five-file versus legal-entity scope, account ownership, reporting basis and target file. Preserve the known private IRS ownership/loan corrections and version lineage; no allocations were inherited blindly from filenames.
- Implement and validate entity allocation, equity/intercompany/open-item reconciliation and two closed pilot months with no unexplained differences.
- Establish and test the authenticated automatic collector, protected operational storage/independent backups, change/deletion recovery, reporting freshness/failure handling and repeatability. The offline capture tool is not that deployed collector.
- Complete all-entity parallel validation, required accounting review, migration/rollback design and specific production cutover authority for the January 1, 2027 target.

## Offline Capture Usage

Use the full bundled Python executable to run `scripts\Capture-QboReportSnapshot.py` with `--company` set to the verified source company, `--database` set to an absolute external `.sqlite3` path, and one or more absolute `--source` XLSX paths. The command prints coverage findings and snapshot identities; it never publishes approved financial statements. Sources remain unchanged. Store detailed run output privately when needed.

Read an existing archive with SQLite read-only mode and verify stored content hashes before relying on the file. Do not sum or append different report snapshots together as transaction activity. The future collector requirements are documented in [[Project Rooms/Quickbooks/working/entity-reporting-feed-contract]].
