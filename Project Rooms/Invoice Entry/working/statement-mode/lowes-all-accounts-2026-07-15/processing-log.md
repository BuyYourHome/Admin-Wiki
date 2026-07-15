# 2026-07-15 - Lowe's All-Accounts Doc Scan Packet Processing Log

## Source Packet

- Packet root: `C:\Codex\Wiki Files\Project Rooms\Doc Scan\outputs\lowes-statement-all-accounts-2026-07-15`
- Structured input: `C:\Codex\Wiki Files\Project Rooms\Doc Scan\outputs\lowes-statement-all-accounts-2026-07-15\lowes_statement_transaction_sections.csv`
- Packet summary: 10 filed Lowe's statements, 26 OCR pages, 58 OCR-derived transaction/reference sections.

## Initial Invoice Entry Decision

Initially, no project workbook rows were inserted from this packet.

Reason: this packet is a conservative review-grade Statement Mode handoff. It contains OCR-derived transaction/reference sections, not clean final item-level rows ready for project Review-table import. Several `amount_candidate_raw` values are tax/subtotal fragments rather than reliable invoice totals, and some source PDFs appear incomplete compared with printed statement page counts. The latest `6140` statement is a clear example: the summary page lists more references than the available detail pages support.

## Routing Outcome

| Outcome | Count |
| --- | ---: |
| Transaction/reference sections received | 58 |
| Rows inserted into project Review tables | 0 |
| Rows inserted into vendor tabs | 0 |
| Rows retained in held-detail CSV | 58 |

Held detail file:

`C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\statement-mode\lowes-all-accounts-2026-07-15\held-detail.csv`

## Notable Possible Project Clues

These rows may be project-related but were held because project, item split, or amount was not reliable enough for workbook import:

- `93783`, BYH `5997`, statement `26-01-17`: possible `908 Pond` from visible `908` in OCR snippet.
- `83033`, SYH `6140`, statement `26-02-02`: possible `908 Pond` from visible `908` in OCR snippet.
- `85288`, SYH `6140`, statement `26-05-02`: possible `7001 Outrigger` from visible `7001` in OCR snippet.
- `89689`, SYH `6140`, statement `26-06-02`: possible `7001 Outrigger` from visible `7001` in OCR snippet.
- `75497`, SYH `6140`, statement `26-06-02`: possible `320 Rose` from visible `320` in OCR snippet.
- `91899` and `90796`, SYH `6140`, statement `26-06-02`: possible `320 Rose` by adjacency on the same rendered detail page, but their individual OCR sections do not contain their own reliable PO markers.

Home/non-project row:

- `77590`, SYH `6140`, statement `26-06-02`: OCR shows `home`; held outside project workbooks.

## Follow-Up Needed

Doc Scan should provide a more workbook-ready Statement Mode packet before Invoice Entry imports rows to project Review tables. For each row, Invoice Entry needs:

- reliable project/property,
- reliable transaction/reference number,
- reliable transaction date,
- reliable total amount for the row or item,
- item-level description when a transaction has multiple purchased/returned items,
- tax/payment/interest rows separated from purchasable project rows,
- explicit missing-page or incomplete-source flags.

Until then, the current packet is retained as source evidence but is not treated as approval or a complete extraction.

## Later Review-Table Insert

Wes then instructed Invoice Entry to add entries to the project spreadsheets so he can review them from the workbook Review tabs. Invoice Entry inserted selected project-review rows into the Pond, Outrigger, and Rose Review tables, without inserting any vendor-tab rows.

See:

`C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\statement-mode\lowes-all-accounts-2026-07-15\review-insert-log.md`
