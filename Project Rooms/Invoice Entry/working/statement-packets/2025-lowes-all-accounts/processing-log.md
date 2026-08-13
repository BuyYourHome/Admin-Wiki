# 2025 Lowe's Statement Processing Log

## 2026-08-04 - Source inventory and reconciliation

- Accepted dispatch `jean-dispatch-20260804-lowes-statements-2025-v1` from Jean Wright.
- Located 18 distinct calendar-year 2025 Lowe's statement PDFs in the authoritative SharePoint Documents library: 8 for BYH account ending 5997 and 10 for SYH account ending 6140.
- Preserved the original SharePoint sources and recorded direct source links in `statement-inventory.md`.
- Reconciled periods, SharePoint item identities, and existing Invoice Entry evidence. Found no duplicate 2025 statement period, no second source copy, and no existing 2025 structured Statement packet.
- Identified BYH gaps January-April and SYH gaps January-February.
- Resolved the corrected priority project to `24-HM - 4121 Tensity Dr` and its registered workbook `Property/24_Project Management - 4121 Tensity Dr 2.xlsm`.
- Stopped before statement extraction or spreadsheet processing. Invoice Entry is not authorized to inspect/OCR or parse raw Lowe's statements, and the delegation prohibits creating a substitute Doc Scan task.
- No statement was changed, copied, or downloaded; no workbook was opened, changed, or uploaded; no email, payment, Git push, or other external action occurred.

Outcome: `Needs Wes - Doc Scan structured Statement packets required`.

## 2026-08-04 - Corrected packet verification and Tensity workbook hold

- Accepted corrected Doc Scan packets under dispatch `jean-dispatch-20260804-lowes-statements-2025-v1-docscan-intake`.
- Visually verified source page 3 for BYH 5997 statements closing 2025-05-17 and 2025-07-17. The corrected packets contain eight non-tax PO-4121 item rows totaling `$426.32` across invoices `79852`, `90370`, `74794`, `96737`, and `98873`.
- Confirmed no workbook duplicate hit for the five invoice numbers, eight packet row IDs, source filenames, or verified item descriptions.
- Retrieved fresh authoritative workbook `Property/24_Project Management - 4121 Tensity Dr 2.xlsm`, modified `2026-08-04T14:31:36Z`, and created a rollback copy.
- The workbook-open Reconcile preflight found Amazon Review row `IE-20260722-AMAZON-111-5051554-5651422` with destination `Electrical Fixtures`. The validated local workbook posts that row once to `tblElectricalFixturesInvoices` for `$34.31`, changes its Review status to `Posted`, and leaves tax blank because the source establishes only the total.
- The validated local workbook adds the eight Lowe's rows to `Review!tblInvoiceReview`, keeps every `Destination Worksheet` blank, uses controlled status `Needs Review`, preserves packet/source-page traceability, and excludes tax-only amounts.
- Read-back validation passed: eight unique Lowe's rows totaling `$426.32`; Amazon destination count one; Electrical Fixtures total and `Gnatt Chart!G15` both `$195.388775`; request name still `=Review!$B$1`; checkbox still `FALSE`; Automatic calculation and iteration preserved; zero external links.
- Package validation preserved all 30,446 formulas, the exact formula fingerprint, and the same 19 pre-existing error cells. No external-link package parts were introduced. The workbook reopened cleanly in Excel and the edited rows were visually inspected.
- Exact SharePoint replacement failed at `2026-08-04T17:32:13Z` with HTTP `423 resourceLocked`. The authoritative workbook was not changed, so neither the Amazon posting nor the eight Lowe's Review rows are complete.
- Preserved the validated workbook and rollback copy in `Invoice Entry Working Archive\Generated\2026-08-04-2025-Lowes-Tensity-Upload-Hold`; 2 files / 1,480,982 bytes; source and destination SHA-256 hashes matched.
- Doc Scan completed the final packet-quality correction: all eight rows now include source-verified `store` and `item_number_sku` values; the eight amounts, PO 4121 evidence, source-page references, and handwritten/corrected PO note for invoice `74794` are unchanged.

Current outcome: `Blocked - Authoritative Tensity workbook locked`. After the lock clears, re-check SharePoint freshness. If the source changed after `2026-08-04T14:31:36Z`, re-fetch and reapply against the new version instead of overwriting it with the held copy.

## 2026-08-04 - Freshness-safe upload retry completed

- Wes instructed Invoice Entry to continue.
- Re-listed the authoritative workbook before retry. Its modified time was still exactly `2026-08-04T14:31:36Z` and its size was still `739,985` bytes, so the recorded freshness gate passed.
- Reverified the archived validated workbook at `740,997` bytes with SHA-256 `C57EB95396F5185BB885F61428FF62AFB19EF9E5B8FFC575909D57FAF75D2552`.
- Exact-target SharePoint replacement succeeded for item `01ZGFUBDNQEWEPX3YGHZFYAFNBA3XOUXD4`. SharePoint returned modified time `2026-08-04T18:59:07Z` and size `740,997` bytes.
- Re-fetched the authoritative SharePoint workbook after upload. Its SHA-256 was exactly `C57EB95396F5185BB885F61428FF62AFB19EF9E5B8FFC575909D57FAF75D2552`, proving the uploaded file is byte-identical to the validated workbook.
- Read-only Excel verification of the re-fetched authoritative copy found exactly eight Lowe's packet rows plus the existing Amazon Review record. The eight Lowe's rows remain `Needs Review` with blank `Destination Worksheet`; Amazon is `Posted` and appears once in `tblElectricalFixturesInvoices` for `$34.31`.
- `Electrical Fixtures!M12` and `Gnatt Chart!G15` both read `$195.388775`; `invoiceEntryReviewRequest` remains `FALSE`; Automatic calculation and iteration remain enabled.

Current outcome: `Complete - authoritative workbook uploaded and verified; eight Lowe's rows pending final Vendor Tab review`.

## 2026-08-13 - Corrected all-project packet continuation

- Wes corrected the requested year to 2025 and instructed Invoice Entry to process both BYH and SYH Lowe's statements into supported projects.
- Doc Scan returned corrected packet metadata totaling 94 OCR-derived rows. Source-supported visible PO groups now include 8 rows for PO `4121`, 3 for PO `6316`, 9 for PO `1343`, 1 for PO `612`, and 5 for PO `908`.
- The original 18 SharePoint statement PDFs were preserved. Coverage remains BYH May-December with January-April missing and SYH March-December with January-February missing. No duplicate statement periods were found.
- Project resolution from authoritative project/workbook names:
  - PO `4121` -> `24-HM - 4121 Tensity Dr`.
  - PO `6316` -> `23-SYH - 6316 Willowdell Dr`.
  - PO `1343` -> `21-SYH - 1343 Old Buckhorn Rd`.
  - PO `612` -> `25-401K - 612 Britton Ct`.
  - PO `908` -> `26-BYH - 908 Pond St`.
- Fresh workbook duplicate checks found no prior invoice/row/SKU-description match for the new PO `612` and PO `908` rows.
- `Property/25_Project Management - 612 Britton Ct.xlsm` received one source-verified Review row for invoice `95791`, `$122.55`, status `Needs Review`, blank destination.
- `Property/26_Project Management - 908 Pond St 3.xlsm` received five source-verified Review rows for invoices `87130` and `71820`, totaling `$118.24`, each status `Needs Review`, blank destination.
- Both workbooks reopened cleanly with zero external links. Artifact-tool table inspection and visual rendering passed. Freshness gates passed immediately before upload. Exact SharePoint replacement succeeded and post-upload downloads were byte-identical to the validated files:
  - Britton SHA-256 `DF0D5FB4CB8CF1C6E1ED76AF08CC0858BBC3C98C39CF4E005C4FFD2ADF70144C`.
  - Pond SHA-256 `2DFF8C6C592EA9B836E38520DD6863ABB9B7C3B3ADE4FAEE8BC2622865E83D29`.
- Willowdell and Old Buckhorn do not contain `Review!tblInvoiceReview`. Their 12 source-verified rows totaling `$988.99` were retained in `lowes-statement-held-detail-register.md`; no direct Vendor Tab insertion was made.
- All other packet rows remain unrouted because they lack source-supported project allocation or require further source review. Tax-only amounts were excluded from item rows.

Current outcome: `Partially complete - 14 source-supported rows across Tensity, Britton, and Pond are in authoritative Review tables; 12 source-supported Willowdell/Old Buckhorn rows are held until those workbooks are Review-ready; remaining rows have no supported project route`.
