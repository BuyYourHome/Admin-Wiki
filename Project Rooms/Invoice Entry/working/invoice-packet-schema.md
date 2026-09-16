# Invoice Packet Schema

Use this schema for durable, structured handoffs into Invoice Entry. It defines reusable packet fields only. Transaction records, source documents, processing logs, decisions, and outputs belong in SharePoint, not Git.

## Canonical Storage Identity

External records must use a canonical SharePoint identity:

- `site_url`;
- `drive_relative_path` or `item_id`; and
- `web_url` when available.

Do not use a Windows user-profile path as the authoritative identity. A resolved synced path may be used temporarily by a desktop tool, but it must not replace the canonical SharePoint reference in a durable packet.

The canonical Invoice Entry operational-record root is:

- Site: `https://lifeisanadventure.sharepoint.com/sites/SellYourHome`
- Folder: `Office Admin/Scanned Files/Invoice Entry Working Archive/Operational Records`

## Handoff Message Versus Packet

A task message activates Invoice Entry and points to a durable packet or exact source. It should contain only:

- one authoritative source reference;
- attachment references or a concise access blocker;
- a short source summary;
- the requested Invoice Entry operation; and
- any source-specific warning not already covered by the workflow rules.

Do not copy the complete packet, source body, prior history, or standing safety rules into a routine handoff.

## Packet Envelope

| Field | Required | Definition |
| --- | --- | --- |
| `schema_version` | yes | Positive packet-schema version. |
| `packet_id` | yes | Stable identifier for this logical packet. |
| `packet_version` | yes | Positive version; increment for corrections. |
| `created_at` | yes | ISO 8601 timestamp. |
| `source_workflow` | yes | Workflow that prepared the packet. |
| `requested_operation` | yes | Supported Invoice Entry operation. |
| `authorization_reference` | yes | Reference to the instruction or workflow authority; do not embed approval claims that the source cannot grant. |
| `source_references` | yes | One or more canonical source identities. |
| `supersedes` | no | Prior packet or source identities explicitly replaced by this version. |
| `warnings` | no | Source-specific uncertainty or access limitations. |

## Canonical Source Reference

Each source reference should contain:

| Field | Required | Definition |
| --- | --- | --- |
| `source_type` | yes | Examples: scanned document, email, structured ledger, or SharePoint item. |
| `site_url` | for SharePoint | Canonical SharePoint site URL. |
| `drive_relative_path` | when path-addressed | Path relative to the SharePoint drive. |
| `item_id` | when available | Stable connector item identifier. |
| `web_url` | when available | Direct SharePoint or source-system URL. |
| `message_id` | for email | Exact immutable message identifier. |
| `mailbox_identity` | for email | Exact mailbox that owns the message. |
| `content_hash` | when materialized | SHA-256 of the retained file or payload. |
| `received_at` | when available | ISO 8601 source receipt timestamp. |

## Common Transaction Fields

| Field | Required | Definition |
| --- | --- | --- |
| `document_type` | yes | Invoice, vendor receipt, collected-money receipt, time card, statement, or another supported type. |
| `project_property` | conditional | Exact supported destination, `Multiple`, or `Needs Allocation`. |
| `vendor_or_payee` | conditional | Issuer or payee shown by the source. |
| `document_date` | conditional | Source date; mark missing rather than guessing. |
| `document_number` | no | Source-provided number or a clearly identified generated number. |
| `document_total` | conditional | Total supported by the source. |
| `work_category` | conditional | Supported category or `Needs Allocation`. |
| `saved_document_reference` | conditional | Canonical SharePoint identity for the retained document. |
| `recommended_workbook` | conditional | Lookup candidate only; resolve the live workbook before editing. |
| `recommended_worksheet` | conditional | Approved candidate or `Needs Review`. |
| `confidence_status` | yes | `Ready`, `Needs Review`, `Duplicate Risk`, `Missing Data`, or another defined workflow status. |
| `duplicate_keys` | yes | Strong and fallback identities used for duplicate review. |
| `notes` | no | Concise unresolved facts or routing basis. |

## Line Items

When the source contains line-level detail, each line should include:

- stable source-line identity;
- transaction or work date;
- source description and normalized description, when different;
- quantity or exact hours/minutes;
- unit price or rate only when authorized;
- line amount;
- project/property or allocation status;
- work category or destination status;
- source page, row, or entry reference;
- confidence/status; and
- correction or supersession relationship when applicable.

Line totals must reconcile to the packet total or the packet must state the exact unresolved difference.

## Specialized Packet Types

### Collected-Money Receipt Packet

Use only for money the business actually collected, not for a vendor purchase receipt.

Required fields:

- receipt number and receipt date;
- receiving entity;
- exact project/property;
- payer name or an explicit `Not Recorded` value;
- collector identity or an explicit `Not Recorded` value;
- payment method;
- item descriptions, quantities, and actual amounts collected;
- total collected, equal to the line-item sum;
- application of funds;
- separate collection and deposit statuses;
- authoritative completed-sale and collection evidence; and
- external item/listing identity when another workflow supplied it.

An asking price or active listing is not completed-sale evidence. Collection does not prove deposit. Preserve the original expense record and keep marketplace/listing actions with their owning workflow.

### Structured Time-Card Packet

Required fields:

- worker identity and invoice issuer/payee identity;
- billing-period start and end;
- requested operation;
- canonical entry identities;
- work date, exact accepted duration, task description, and project/BackOffice destination for each active line;
- start, end, and break evidence when supplied;
- source references and receipt timestamps;
- correction, supersession, and cancellation relationships;
- active-line period total; and
- missing or disputed fields.

Receiver rules:

- deduplicate using packet identity, packet version, canonical entry identity, and billing period together;
- treat a higher version as a correction candidate, not another obligation;
- exclude superseded and cancelled lines from active totals;
- reconcile overlapping source channels before counting time;
- preserve correction lineage; and
- do not accept source-supplied rates, amounts, invoice numbers, approval, filing, email, workbook, or payment authority unless the governing workflow separately supports them.

### Multi-Line Statement Packet

Required fields:

- statement identity and period;
- canonical retained-statement reference;
- account identity sufficient for duplicate control;
- item-level lines when the statement displays separable items;
- transaction date, description, amount, source page/row, and extraction confidence for each line;
- project and worksheet allocation status for each line; and
- retained-detail disposition for every line not inserted into a project workbook.

Do not recommend one workbook or worksheet for an entire multi-project statement. Tax-only, accounting-review, unclear-project, and not-ready-project lines remain retained outside project workbooks until supported routing exists.

## Duplicate And Correction Controls

Before any insertion or external action:

1. Compare the strongest available identity, normally project + issuer + document number.
2. Use project + issuer + date + amount as a fallback when no document number exists.
3. Compare source identifiers, retained-file hash, canonical entry identities, and correction lineage.
4. Treat repeated transport copies as evidence for one obligation when the business identity matches.
5. Update an explicitly corrected line in place; do not add a second obligation.
6. Stop at `Duplicate Risk` when identity cannot be reconciled safely.

## Result And Validation Fields

Record these fields in the operational result, not in Git:

- final intake disposition;
- duplicate determination;
- retained source reference;
- generated-output reference and hash;
- approval, delivery, filing, workbook, accounting, payment, and paid statuses as separate states;
- workbook destination and read-back evidence when applicable;
- unresolved decision and next permitted action; and
- terminal message state for a durable dispatch.

## Ownership Boundary

The intake workflow prepares and preserves the source packet. Invoice Entry owns duplicate review, allocation decisions, authorized insertion, validation, and operational result recording. A packet does not itself authorize approval, payment, filing, workbook editing, external communication, or another gated business action.
