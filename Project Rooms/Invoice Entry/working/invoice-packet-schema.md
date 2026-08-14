# Invoice Packet Schema

Use this schema when Doc Scan hands a scanned invoice, receipt, or Statement packet to Invoice Entry or Manager sends an authorized structured Time Card packet under the special-source rules below. Other intake sources are out of scope unless Wes separately approves and documents them.

Doc Scan owns Lowes Statement extraction and will send extracted statement data for Invoice Entry to consume. Statement packets should not be inserted until Wes approves a tested process for allocating statement line items by project and by worksheet/table.

## Handoff Message Versus Packet

Keep the direct task handoff concise. The handoff activates Invoice Entry and points to the durable source; it does not reproduce this schema or the standing workflow rules.

A normal handoff needs only:

- the packet path, exact Outlook message ID/link, or authoritative Teams/SharePoint source path;
- external attachment paths or an attachment-access blocker when applicable;
- a short source summary;
- the requested Invoice Entry operation; and
- a warning unique to that source when needed.

Store the complete structured fields below in the referenced packet or build them inside Invoice Entry from the exact routed source. Do not paste full email bodies, prior-thread history, or repeated safety instructions into routine handoff messages.

## Required Fields

| Field | Required | Notes |
| --- | --- | --- |
| `project_property` | yes | Property name or address. For Statement, use `Needs Allocation` or `Multiple` when line items span projects. |
| `vendor_name` | yes | Vendor shown on invoice. |
| `invoice_date` | yes | Invoice date when available; otherwise mark missing. |
| `invoice_number` | no | Use when present. |
| `invoice_amount` | yes | Total amount to insert. |
| `work_category` | yes | Best known category, such as Plumbing Fixtures, HVAC, Paint, or Landscape. For Statement, use `Needs Allocation` or `Multiple` when line items span categories. |
| `source_scan_path` | yes for Doc Scan packets | Original scan or archived scan path used by Doc Scan. |
| `saved_invoice_file_path` | yes | Teams/project-folder path where intake saved the invoice file. |
| `recommended_workbook` | yes | Active project-management workbook candidate. For Statement, use `Needs Allocation` or list likely project workbooks only when supported by the extracted line data. |
| `recommended_worksheet` | yes | Candidate worksheet or `Needs Review`. For Statement, use `Needs Allocation` unless every line item has approved worksheet allocation. |
| `confidence_status` | yes | Suggested values: `Ready`, `Needs Review`, `Duplicate Risk`, `Missing Data`, `Needs Review - Statement`. |
| `notes` | no | Uncertainty, duplicate hints, or routing explanation. |

## Special Source Types

### Cash Collection Receipt Packets

Use a Receipt packet only for money the business has actually collected. It is distinct from a vendor receipt documenting money the business paid.

Required fields:

- `document_type`: `Receipt`;
- `receipt_number`, `receipt_date`, and `receiving_entity`;
- exact `project_property` and project identity;
- `received_from`, or an explicit note that the cash buyer's name was not recorded;
- `collected_by`, `payment_method`, and `collection_status`;
- item description, quantity, and actual amount collected for each line;
- `total_collected`, which must equal the line-item sum;
- `application`, normally `Estate Sale Proceeds / Project Credit` for an estate-sale item assigned to a property;
- `deposit_status`, kept separate from collection status;
- authoritative source confirming the completed sale and collected amount; and
- Marketplace item ID, listing title/URL, draft ID, or source path when Marketplace supplied the item identity.

Receiver rules:

- Marketplace listing price is not sale evidence and must not be substituted for the actual amount collected.
- Narrow Rosebrooks Estate Sale exception: Wes's direct command `Receipt item #<item number>` is confirmation that the exact item sold for its current established Marketplace price and cash was collected. Use a different price or payment method only when Wes states it in the command. This exception does not let a listing price establish a sale without Wes's receipt command.
- Treat an active listing, draft, or Marketplace inventory row as item-identification evidence only unless an authorized source separately confirms the completed sale.
- Deduplicate first by property plus receipt number, then by Marketplace item ID plus sale date plus actual amount.
- Do not mark a Marketplace listing sold, contact a buyer, accept payment, or edit Marketplace records from Invoice Entry.
- After the Rosebrooks receipt facts are durably recorded, send one sold-status handoff to the registered Marketplace task with the item number, exact listing reference, sale date, established or overridden amount, payment method, receipt number, and source command. Record Marketplace's returned `confirmed`, `blocked`, or `needs Wes` result; never repeat an ambiguous or verified Facebook action.
- `Cash Received` does not mean `Deposited`. Use `Not Recorded`, `Pending Deposit`, or `Deposited` only as supported by separate evidence.
- Preserve the original project expense. Do not enter sale proceeds as a negative invoice, refund, or expense reduction unless the source specifically establishes that accounting treatment.
- Until an approved receipts/project-credit worksheet mode exists, set workbook status to `Needs Review - Project Credit Placement` and do not insert the receipt into a Vendor Tab or expense area.

### Manager Time Card Packets

Manager may send a versioned Time Card packet only after Wes requests draft/final processing or otherwise authorizes Invoice Entry processing. The packet must contain:

- `dispatch_id` using `manager-dispatch-YYYYMMDD-time-card-vN`;
- `packet_version` and `created_timestamp`;
- the authorizing Wes instruction;
- worker identity;
- semimonthly period start and end;
- requested operation: `create/update draft`, `process correction`, or `prepare closed-period final review`;
- canonical Manager entry ids and display ids;
- for each entry: work date, exact hours/minutes, start/end/break evidence when supplied, task description, project/property or `BackOffice`, source reference, and source received timestamp;
- superseded/cancelled relationships and correction history;
- period total computed from active lines only;
- missing or disputed fields; and
- the canonical Manager register path.

Receiver rules:

- Deduplicate using dispatch id, packet version, canonical Manager entry id, and semimonthly period together. Repeated delivery of an unchanged packet is not a new intake.
- A correction must arrive as a higher packet version. Preserve the prior version, apply explicit superseded/cancelled relationships, and exclude `Superseded` and `Cancelled` lines from active totals.
- Recalculate active-line hours and compare them with Manager's stated period total before changing the semimonthly record.
- Reconcile canonical Manager entry ids against existing Email Monitor-derived lines and prior Manager packets. If the same work may exist under two source channels and identity cannot be proved, hold it instead of double counting.
- Preserve the canonical Manager entry id and packet version on the Invoice Entry time record and in correction history.
- Do not retry after an ambiguous, missing, or possibly successful result until durable Invoice Entry status is reconciled.
- Return the same dispatch id with `accepted`, then `done`, `blocked`, `needs Wes`, or `rejected as wrong room`.

Manager packets may not set or authorize rates, amounts, invoice numbers, approval state, filing directions, spreadsheet insertion directions, email delivery, payment, or any other external action unless Invoice Entry previously returned the value or Wes separately authorized it under Invoice Entry rules. Manager owns its source ledger and packet production; Invoice Entry owns semimonthly accumulation, rates/amounts, invoice generation, correction review, Wes approval, filing, allocation, and workbook insertion.

### Statement Packets

If the packet is for extracted statement data:

- Set `confidence_status` to `Needs Review - Statement`.
- Include the statement period and filed statement PDF path.
- Include extracted line items when available, with transaction date, description, amount, page/source reference, and extraction confidence.
- Do not recommend a single workbook or worksheet unless the approved Statement process allows that for the specific line item.
- Do not insert line items into a workbook until the Statement allocation process has been developed, tested, and approved by Wes.

### Lowes Statement Packets

If the packet is for a Lowes statement:

- Item-level rows are expected when the statement detail shows multiple purchased or returned items under one transaction/reference number.
- Preserve the shared transaction header on every item row, including statement date, transaction/posting dates, receipt/reference number, store number, PO/project clue, source statement path, and filed statement path.
- Treat `Needs Review - Amount Split` and `Needs Review - Allocation` rows as not ready for final vendor-tab copy until the amount allocation issue is resolved.
- Every extracted statement line should be represented as a row in the workbook `Review` table before any vendor-tab insertion.
- Use `Destination Worksheet` only when Invoice Entry has confidence in the final vendor tab.
- Leave `Destination Worksheet` blank when the line is Home/non-project, mixed-tab, PO-conflicted, accounting-only, or otherwise uncertain.
- Review-row status and notes should explain whether the line is ready for later copy, needs Wes review, or needs accounting direction.
- For any line not inserted into a project workbook, preserve enough detail for later action in the Invoice Entry held-detail register. Retained fields should include statement account, statement closing date, packet row, transaction date, reference number, store, PO/project clue, SKU/item number when available, description, amount, line type, recommended project/workbook if any, confidence/status, source statement path, and current hold reason.

## Handoff Boundary

The intake workflow should not edit the workbook. It should pass the packet to this project room for routing confirmation, duplicate check, insertion, and validation. For Statement, Doc Scan owns extraction and Invoice Entry owns allocation and insertion decisions.
