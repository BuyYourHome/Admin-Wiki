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
- Destination: Quickbooks Invoice task `01a05967-9a05-7081-a62e-616b2d8e61fd` on `WES-VIDEOEDITOR`
- Current state: `Queued`
- Operation: read-only bill existence and duplicate audit
- Required return: one `Found`, `Not Found`, `Ambiguous`, or `Blocked` result per invoice, with QuickBooks transaction ID when visible
- Prohibited: any create, edit, save, payment, paid-status, email, vendor, mapping, or other QuickBooks data change

Direct task notification was unavailable from this host and was recorded `NotDelivered`; the central child remains the authoritative queued handoff.

An earlier pre-delivery control record, `prmsg-invoice-entry-poyner-spruill-qb-existence-audit-20260831-001`, serialized its aggregate as `$0.00`. It was blocked before notification or recipient action and must never be processed. The corrected `-002` child above is the only valid processable handoff.
