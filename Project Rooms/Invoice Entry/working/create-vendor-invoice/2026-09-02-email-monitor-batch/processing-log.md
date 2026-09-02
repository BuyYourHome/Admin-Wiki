# Processing Log - September 2, 2026 Email Monitor Batch

## Accepted Sources

- `prmsg-email-monitor-route-vendor-invoice-20260902-greenview-000379-001`, hash `b270050cd3a004fc8acfa98488fb60012374544581c21eee50041f62e8e93a8b`.
- `prmsg-email-monitor-route-vendor-invoice-20260902-greenview-000380-001`, hash `5800a6bca45e8ae1b56a134f42224d62f389d99bb00737cc45606c99c037854a`.
- `prmsg-email-monitor-route-vendor-invoice-20260902-meridian-50-32856-2-001`, hash `e4a9ed2c83c8b50f4e41ea676dfd0eea0115912458a76b8a9b87b9a573ef08b1`.
- `prmsg-email-monitor-route-vendor-invoice-20260902-meridian-50-36858-4-001`, hash `f6fd51cc035aa5fb5f8aca88765fd0e25375fe205c4b9d36fd053e898c1f8ca0`.
- `prmsg-email-monitor-route-vendor-invoice-20260902-ncaoc-august-stats-001`, hash `c3b7548b2905f658da5a15427198af7eb9fbc708cb019ab58ce79274e7621403`.

Each record's exact Invoice Entry destination and payload hash was validated. Accepted and Processing were written before substantive work.

## Greenview Works

### Invoice 000379

- Authoritative Outlook message ends `AClUGMNAAAAA==`.
- Vendor: Greenview Works.
- Customer/entity: Buy Your Home LLC.
- Property: 4121 Tensity Drive.
- Invoice date and due date: 2026-09-02.
- Service date: 2026-08-29.
- Amount: `$120.00`.
- Description: monthly property maintenance; lawn service August 15 and August 29.
- Source conflict: the summary heading says `MONTHLY PROPERTY MAINTENANCE- JULY`, while both listed service dates are in August. Preserve both; do not silently correct the month.

### Invoice 000380

- Authoritative Outlook message ends `AClUGMMwAAAA==`.
- Vendor: Greenview Works.
- Customer/entity: Buy Your Home LLC.
- Property: 908 Pond St, Cary.
- Invoice date and due date: 2026-09-02.
- Service date: 2026-08-29.
- Amount: `$100.00`.
- Description: property maintenance; lawn service August 14 and August 29.

No existing Invoice Entry record or retained/filed filename matched invoice `000379` or `000380`. The exact Outlook bodies establish payable invoice facts and contain separate PDF-download links, but no PDF is retained in an authorized persistent source/archive path. No project workbook action was authorized. Both invoices remain `Needs Wes - Source Filing / Project Worksheet / QuickBooks Mapping`: preserve the invoice facts, obtain or retain the source PDFs through an authorized source path, identify the approved project-workbook worksheet, and resolve the exact QuickBooks expense/account and other required mappings before any child handoff. No approval, payment, vendor contact, payment-flow access, workbook posting, QuickBooks save, or paid status occurred.

## Meridian Waste Solutions

### Account 50-32856 2

- Authoritative Outlook message ends `AClUGMMgAAAA==`.
- Attachment: `Billing50-32856 2_153.pdf`, 169,518 bytes, non-inline.
- Prior authoritative property-file history associates account `50-32856 2` with `26-BYH - 908 Pond St`, but current invoice number, date, amount, due date, service address, and line detail remain inside the uninspected PDF.

### Account 50-36858 4

- Authoritative Outlook message ends `AClUGMMQAAAA==`.
- Attachment: `Billing50-36858 4_154.pdf`, 168,884 bytes, non-inline.
- No authoritative project mapping was found from the account suffix alone. Current invoice number, date, amount, due date, service address, and line detail remain inside the uninspected PDF.

Outlook successfully materialized both exact PDF attachments, but host security refused the local download needed for read-only PDF inspection because this batch arrived through a cross-task wake-up. No workaround was attempted. Both Meridian records are blocked pending explicit Wes authorization to retrieve and inspect the exact attachments, or a persistent authorized file path supplied by Email Monitor. No invoice obligation, project assignment, amount, approval, payment, vendor contact, portal action, workbook posting, QuickBooks handoff, or paid status was inferred.

## NCAOC August Statistics

- Authoritative Outlook message ends `AClUGMNQAAAA==`.
- The source visibly states `THIS IS NOT AN INVOICE` and `YOUR INVOICE IS SENT SEPARATELY`.
- It reports user `UIBUY01`: 47 transactions / `$18.33` on 2026-08-25 and 30 transactions / `$11.70` on 2026-08-26, total `$30.03`.
- The `$30.03` total corroborates parent invoice record `prmsg-email-monitor-route-vendor-invoice-20260902-ncaoc-41247772-001`, invoice `41247772`, but does not create another obligation.

This supporting record is complete. The parent invoice remains separately unresolved in central state and still requires its own duplicate-safe processing. No approval, payment, vendor contact, workbook posting, QuickBooks action, or paid status occurred.

## Central State Limitation

The five authoritative records were accepted and moved to `Processing`. The attempted final-state writes were refused by the host safety gate because this batch arrived after the user-authorized Poyner request and Wes had not directly authorized these five records in this Invoice Entry task. No workaround was attempted. The records therefore remain `Processing` centrally until Wes explicitly authorizes this batch here; then Invoice Entry may write the already-determined final states without repeating source retrieval or analysis.
