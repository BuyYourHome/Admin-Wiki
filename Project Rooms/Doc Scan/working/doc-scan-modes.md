# Doc Scan Modes

These are the defined operating modes for the Doc Scan project room. A scan run may use more than one mode when a source scan contains mixed documents. The detailed routing and safety rules remain in `Document Scanning SOP.md`, `Document Scanning Skill Spec.md`, `Document Scanning Folder Map.md`, and the canonical `skills\doc-scan\SKILL.md`.

## Mode Selection Rules

- Identify the mode from document content, not from the source scan filename alone.
- Split combined scans by mode and document boundary when page boundaries are clear.
- If a page or file could belong to more than one mode and the routing consequence matters, route it to the correct review path and log the uncertainty.
- Preserve the source scan. Never delete source scan files.
- Never overwrite filed PDFs or image files silently.
- Keep invoice review separate from statement review.
- Use the SharePoint/Teams connector as the default discovery path when connector access is available; use local synced folders as scanner drop-zone, processing workspace, archive/log path, and fallback.

## Defined Modes

| Mode | Use When | Primary Destination Pattern | Review/Handoff Rule |
| --- | --- | --- | --- |
| Mortgage Statement Mode | The document is a mortgage, servicer, escrow, tax, or payment statement tied to a property loan. | Matched property folder under `Buy Your Home - Property`, then `Owning`, then the mortgage-company folder. | Route uncertain property, loan, or mortgage-company matches to statement review. Generate mortgage statement reports when requested or appropriate. |
| Bank Statement Mode | The document is a bank account statement. | Office Admin yearly bank-statement folder from the folder map. | Route unclear account, date, or institution matches to statement review. |
| Credit Card Statement Mode | The document is a credit card statement, including Lowe's Pro card statements. | Office Admin yearly credit-card folder from the folder map. | Route unclear account/date matches to statement review. Generate credit card statement reports when requested or appropriate. When the filed statement is Lowe's, call Lowe's Statement Allocation Mode after normal statement filing. |
| Lowe's Statement Allocation Mode | A filed credit card statement is identified as a Lowe's statement and needs project-spreadsheet-style item extraction. | Preserve the normal filed Lowe's statement path; create item-level allocation packet(s) in the approved Invoice Entry handoff location. | Split each statement transaction/reference into distinct item rows when detail is visible, including delivery/shipping, fees, returns, and credits. Use PO/project clues when shown. Recommend project/property, workbook, and vendor tab only when confidence is high. Mark unclear, non-project/Home, mixed-tab, accounting-review, amount-split, and allocation-review rows with the specific review status. Send a direct handoff summary by status count and do not edit project spreadsheets directly. |
| Doc Search | A scanned invoice, receipt, statement line, Lowe's allocation row, or explicit Wes request needs supporting project-related document context that may not have come through the Doc Scan intake. | No filing destination by default. Search results are recorded as evidence notes in the scan log, review note, or Invoice Entry packet. | Trigger only when context is needed; do not run on every heartbeat. Search Teams/SharePoint project folders and Admin wiki/project-room records for related POs, orders, receipts, invoices, statements, notes, and prior packets. Do not move or file found documents, edit spreadsheets, or decide final invoice-entry placement. |
| Loan / Line-of-Credit Statement Mode | The document is a non-mortgage loan or line-of-credit statement. | Office Admin yearly loan/line-of-credit folder from the folder map unless a specific property rule applies. | Route unclear account/date/lender matches to statement review. |
| Property Insurance Mode | The document is from an insurance company or mortgage company about property insurance coverage. | Matched property folder under `Buy Your Home - Property`, then that property's `Insurance` folder. | Track property/policy chronology and current status. Route low-confidence matches, missing Insurance folders, and unresolved cancellation/lapse notices to review. Generate insurance status reports when requested or regenerated. |
| Property Closing Documents Mode | The scan contains signed property closing-package documents for a Buy Your Home property. | Same property folder location as the matching unsigned version, with ` - Signed` added before `.pdf`. | Route unclear document boundaries, property matches, titles, or unsigned-version matches to review. File signer ID pages as `Signer ID` when applicable. |
| Signed Operating Agreement Mode | The scan contains newly signed operating agreements, amendments, consents, membership schedules, or related signature pages for a Buy Your Home-related entity. | Same entity folder location as the matching unsigned, approved-final, or controlling source version, with ` - Signed` added before `.pdf`. | Route unclear entity, title, signature status, or source-version matches to review. Generate signed operating-agreement status reports when a run files these documents. |
| Invoice / Receipt Mode | The document is an invoice, receipt, bill, or purchase record. | Project-specific items go to the matched property/project folder, usually `Owning`; general items go to the approved Office Admin invoice/receipt folder. | Route uncertain project/vendor/date/destination matches to invoice review. For high-confidence project invoices/receipts, create a structured packet and hand off to Invoice Entry. Never pay, submit, move money, or contact vendors. |
| CPA / Tax / Donation / Medical Admin Mode | The document is a CPA form, tax/property-tax document, donation record, medical bill/statement, or similar non-statement admin record. | Office Admin yearly category folder from the folder map. | Route unclear category, date, or destination matches to general review unless a more specific review folder applies. |

## Cross-Mode Notes

- Statement-like documents use statement review unless they are clearly invoices/receipts.
- Invoice-like project documents use invoice review and invoice handoff rules, not statement review.
- Lowe's Statement Allocation Mode is called by Credit Card Statement Mode only after normal Lowe's statement filing and reporting are preserved.
- Doc Search is a support/search mode, not a filing mode. Use it only when a scanned document, packet row, review item, or explicit Wes request needs project-related context from documents outside the active scan intake.
- For explicit Wes-requested Doc Search work that is not tied to an active scan, record the completed search in the scanned document action log or another appropriate durable activity log. Treat one-off Markdown search notes in `Project Rooms\Doc Scan\working` as temporary scratch and delete them after the result is reported or handed off unless Wes explicitly asks to keep the research trail or the note is part of a larger unresolved review packet.
- Every Doc Scan mode must follow the End-Of-Run Working File Cleanup Rule in the canonical `skills\doc-scan\SKILL.md`, including durable outcome logging, Teams archive mapping, Teams-copy verification, and removal of generated local working artifacts before the run is declared complete.
- Every Doc Scan mode must follow the Source Document Retention Rule in the canonical `skills\doc-scan\SKILL.md`: source binaries belong in Teams, SharePoint, scanner archives, property folders, Office Admin folders, or another approved Teams archive, not as durable Admin wiki repo content unless Wes explicitly approves a specific file.
- Property-related modes take precedence over generic Office Admin folders when the document can be confidently tied to a property and the SOP says it is a property document.
- A report mode is not a separate filing mode. Reports summarize one of the defined modes after routing or review.
