# Poyner Spruill QuickBooks Existence Audit Handoff - 2026-08-31

## Control Record

- Parent message: `prmsg-jean-poyner-spruill-qb-existence-audit-20260831-002`
- Parent payload hash: `87b053f809826d6a208fa54a0e17d3968d81871615c9fd2deef3eaaa97a289ed`
- Source folder: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\20-HM-115 Rosebrooks Dr\Lawsuit\Billing`
- Vendor: `Poyner Spruill LLP`
- QuickBooks company: `Buy Your Home LLC`
- Property: `20-HM-115 Rosebrooks Dr`
- Validated invoice count: `19`
- Validated aggregate: `$198,367.01`
- Terms shown on every invoice: `Payable upon receipt`

Each invoice number, invoice date, amount, client, and matter below was validated from the PDF itself. Statements and payment-confirmation MSG files were not counted as bills and remain reconciliation evidence only.

## PDF-Internal Inventory

| Invoice | Invoice date | Amount | Matter | Source PDF |
| --- | --- | ---: | --- | --- |
| `1258847` | `2025-02-27` | `$12,616.15` | `309131.00002000` | `25-02-27 Poyner Spruill - invoice.pdf` |
| `1260193` | `2025-04-07` | `$13,447.55` | `309131.00002000` | `25-04-07 Poyner Spruill - invoice.pdf` |
| `1261819` | `2025-05-09` | `$7,407.68` | `309131.00002000` | `25-05-09 Poyner Spruill - invoice.pdf` |
| `1262741` | `2025-06-10` | `$12,200.06` | `309131.00002000` | `25-06-11 Poyner Spruill - invoice.pdf` |
| `1263955` | `2025-07-10` | `$21,911.62` | `309131.00002000` | `25-07-10 Poyner Spruill - Invoice 1263955 - 21911.62.pdf` |
| `1265053` | `2025-08-11` | `$8,215.90` | `309131.00002001` | `25-08-10 Poyner Spruill - Invoice $8215.9 - motion to compel.pdf` |
| `1265033` | `2025-08-11` | `$8,715.80` | `309131.00002000` | `25-08-10 Poyner Spruill - Invoice $8715.80.pdf` |
| `1265911` | `2025-09-10` | `$7,065.25` | `309131.00002000` | `25-09-10 Poyner Spruill - Invoice 1265911 -7062.25.pdf` |
| `1265916` | `2025-09-10` | `$5,166.60` | `309131.00002001` | `25-09-10 Poyner Spruill - Invoice 1265916-5166.6.pdf` |
| `1266909` | `2025-10-09` | `$14,765.25` | `309131.00002000` | `25-10-10 Poyner Spruill - Invoice 11266909 - 14765.2.pdf` |
| `1266915` | `2025-10-09` | `$4,433.50` | `309131.00002001` | `25-10-10 Poyner Spruill - Invoice 1266915 - 4433.5.pdf` |
| `1268311` | `2025-11-11` | `$1,934.70` | `309131.00002000` | `25-11-11 Poyner Spruill - Invoice 1268311- 1934.7.pdf` |
| `1268317` | `2025-11-11` | `$385.20` | `309131.00002001` | `25-11-11 Poyner Spruill - Invoice 1268317 - 385.20.pdf` |
| `1269006` | `2025-11-25` | `$261.90` | `309131.00002000` | `25-11-25 Poyner Spruill - Invoice 1269006- 261.90.pdf` |
| `1269381` | `2025-12-09` | `$204.60` | `309131.00002001` | `25-12-09 Poyner Spruill - invoice 1269381.pdf` |
| `1271506` | `2026-02-10` | `$15,799.60` | `309131.00002000` | `26-02-10 Poyner Spruill - invoice 1271506 15799.6.pdf` |
| `1272381` | `2026-03-10` | `$3,968.60` | `309131.00002000` | `26-03-10 Poyner Spruill - invoice 1272381 3968.60.pdf` |
| `1274613` | `2026-05-11` | `$40,730.50` | `309131.00002000` | `26-05-11 Poyner Spruill - invoice 1274613 40730.5.pdf` |
| `1275366` | `2026-06-09` | `$19,136.55` | `309131.00002000` | `26-06-09 Poyner Spruill - invoice 1275366 19136.55.pdf` |

## Filename Conflicts Resolved

- Invoice `1265911`: the filename says `$7,062.25`; the PDF says `$7,065.25`. The PDF value controls.
- Invoice `1266909`: the filename says invoice `11266909` and rounds the amount; the PDF says invoice `1266909` and `$14,765.25`. The PDF values control.

## QuickBooks Child Handoff

- Valid child message and dispatch: `prmsg-invoice-entry-poyner-spruill-qb-existence-audit-20260831-002`
- Payload hash: `7b40a78b7e551453e98310a56287550848a3cd3c31ca0767be6acb9e8a56fb57`
- Destination task is now registered to the `Quickbooks` Project Room as `01a05967-9a05-7081-a62e-616b2d8e61fd` on `WES-VIDEOEDITOR`
- Current state: `Completed`
- Operation: read-only bill existence and duplicate audit
- Required return: one `Found`, `Not Found`, `Ambiguous`, or `Blocked` result per invoice, with QuickBooks transaction ID when visible
- Prohibited: any create, edit, save, payment, paid-status, email, vendor, mapping, or other QuickBooks data change

The WES-VIDEOEDITOR dispatcher later delivered the exact immutable child. The task now registered to `Quickbooks` accepted it, completed the read-only audit, and wrote the authoritative return on `2026-09-01T18:56:55Z`.

An earlier pre-delivery control record, `prmsg-invoice-entry-poyner-spruill-qb-existence-audit-20260831-001`, serialized its aggregate as `$0.00`. It was blocked before notification or recipient action and must never be processed. The corrected `-002` child above is the only valid processable handoff.

## Authoritative QuickBooks Return

- QuickBooks company verified: `Buy Your Home LLC`
- Vendor verified: `Poyner Spruill LLP`; vendor ID `1389`
- Result: `13 Found`, `6 Ambiguous`, `0 Not Found`, `0 Blocked`
- Found source total: `$131,634.51`
- Ambiguous source total: `$66,732.50`
- Full source total: `$198,367.01`
- Evidence rule applied: payment confirmations, bill payments, statements, and credits were not treated as proof that a bill exists.
- QuickBooks data changed: `No`

| Source invoice | Status | QuickBooks transaction ID | QuickBooks bill number | QuickBooks date | QuickBooks amount | Result note |
| --- | --- | --- | --- | --- | ---: | --- |
| `1258847` | Ambiguous | `8385` | `1258847` | `2025-01-08` | `$17,616.15` | Source is `2025-02-27` / `$12,616.15`; both date and amount conflict. |
| `1260193` | Found | `9505` | `1260193` | `2025-04-07` | `$13,447.55` | Exact vendor, number, date, and amount. |
| `1261819` | Found | `9506` | `1261819` | `2025-05-09` | `$7,407.68` | Exact vendor, number, date, and amount. |
| `1262741` | Found | `9529` | `1262741` | `2025-06-10` | `$12,200.06` | Exact vendor, number, date, and amount. |
| `1263955` | Found | `9615` | `1263955` | `2025-07-10` | `$21,911.62` | Exact vendor, number, date, and amount. |
| `1265053` | Found | `9790` | `1265053` | `2025-08-11` | `$8,215.90` | Exact vendor, number, date, and amount. |
| `1265033` | Ambiguous | `9789` | `1265033` | `2025-08-10` | `$8,715.80` | Source date is `2025-08-11`; date conflicts. |
| `1265911` | Ambiguous | `9804` | `1265911` | `2025-09-10` | `$7,062.25` | Source PDF amount is `$7,065.25`; amount conflicts by `$3.00`. |
| `1265916` | Found | `9803` | `1265916` | `2025-09-10` | `$5,166.60` | Exact vendor, number, date, and amount. |
| `1266909` | Ambiguous | `9885` | `11266909` | `2025-10-10` | `$14,765.25` | Source PDF says invoice `1266909`, dated `2025-10-09`; number and date conflict. |
| `1266915` | Ambiguous | `9884` | `1266915` | `2025-10-10` | `$4,330.00` | Source is `2025-10-09` / `$4,433.50`; date and amount conflict by `$103.50`. |
| `1268311` | Found | `10335` | `1268311` | `2025-11-11` | `$1,934.70` | Exact vendor, number, date, and amount. |
| `1268317` | Found | `10336` | `1268317` | `2025-11-11` | `$385.20` | Exact vendor, number, date, and amount. |
| `1269006` | Found | `12192` | `1269006` | `2025-11-25` | `$261.90` | Exact vendor, number, date, and amount. |
| `1269381` | Found | `10469` | `1269381` | `2025-12-09` | `$204.60` | Exact vendor, number, date, and amount. |
| `1271506` | Found | `12191` | `1271506` | `2026-02-10` | `$15,799.60` | Exact vendor, number, date, and amount. |
| `1272381` | Found | `12629` | `1272381` | `2026-03-10` | `$3,968.60` | Exact vendor, number, date, and amount. |
| `1274613` | Found | `13029` | `1274613` | `2026-05-11` | `$40,730.50` | Exact vendor, number, date, and amount. |
| `1275366` | Ambiguous | `13030` | `1275366` | `2026-05-11` | `$19,136.55` | Source date is `2026-06-09`; date conflicts. |

The six ambiguous candidates require review against the controlling PDFs and QuickBooks bill records before any correction or bookkeeping action. This read-only audit did not authorize or perform those actions.
