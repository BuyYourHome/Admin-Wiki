# Work Status

Current status: active

Current focus: Scanned-document routing, processing rules, and Doc Scan to Invoice Entry handoffs.

Notes:

- Jean routes scan-process questions and scanned-document workflow work here.
- Invoice-entry packets should be handed to Invoice Entry under the established routing rules.

## Task replacement - 2026-09-07

Wes designated task `01a07d59-9052-7623-a03c-f2b80b9116e0` as the replacement Doc Scan task on OFFICEASSIST in `C:\Codex\Wiki Files`, branch `main`. Previous local task: `01a03956-f670-7482-8a73-f85b85dd64b4`; retained for history. On 2026-09-29, the existing `doc-scan` heartbeat was found paused and still targeting that obsolete task. It was retargeted to the registered replacement, aligned with the current connector-first rules, and resumed while preserving its established schedule and `failed_runs_only` notification policy.

Validation completed 2026-09-07. A scheduled heartbeat reached the replacement task, SharePoint intake access succeeded, the constrained scratch-download broker completed, and source `2026-09-07_1539.pdf` was processed. After Wes approved the review upload, the Enbridge bill and scan log were verified in SharePoint, the original was archived, and scratch artifacts were cleaned up. Missing page 2 and the unverified handwritten payment note remain review flags, not workflow blockers.

## Backlog restoration - 2026-09-29

The verified restoration run inventoried 44 source PDFs representing 40 unique SHA-256 hashes. It created and read back 119 split/filed outputs: 16 went to high-confidence final destinations and 103 went to `Office Admin/2026/_Needs Review` because of missing pages, uncertain statement dates, ambiguous final subfolders, or competing scan evidence. Four `(1)` files were exact byte duplicates. The existing True Service invoice 129086 evidence was reused without repeating its Invoice Entry action.

All 44 originals were moved to `Office Admin/Scanned Files/Archived` only after output, log, and packet verification. The source intake now contains folders and the scan register workbook, with no eligible source PDFs left at the run cutoff. Durable evidence is in the per-source logs and `Office Admin/Scanned Files/Logs/doc-scan-backlog-restoration-2026-09-29.json`.

Six utility bills for 908 Pond St and 4121 Tensity Dr were filed to their property `Owning/Invoices` folders and handed to Invoice Entry through central record `prmsg-doc-scan-invoice-entry-utility-backlog-20260929-001`. The handoff requests duplicate review and normal intake only; it does not approve payment, payment action, or paid status.
