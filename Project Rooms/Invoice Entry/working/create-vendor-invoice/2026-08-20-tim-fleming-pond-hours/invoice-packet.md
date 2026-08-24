# Tim Fleming Pond Hours Invoice Packet - August 17-20, 2026

## Status

- State: `Approved by Wes - Not Paid; Final PDF Filed; Workbook Review Upload Needs Wes`
- Vendor/payee: `Tim Fleming`
- Contact: `tflem04@gmail.com`
- Project: `26-BYH - 908 Pond St`
- Invoice number: `IE-TF-20260820-POND-001`
- Invoice date: `2026-08-20`
- Rate: `$62.50 per hour`
- Reported time: `18.5 hours`
- Approved total: `$1,156.25`
- Payment and paid status: not performed

## Exact Sources

- Dispatch `email-monitor-route-vendor-invoice-20260820-tim-hours-aug17-19-001`; payload hash `c8e2fed006b21ea81c061a5a9eb65f7f5a13822a90dfb9f4e9cd19dbdb6ca9ec`; Outlook message ending `ACi7Vd2wAAAA==`.
- Dispatch `email-monitor-route-vendor-invoice-20260820-tim-hours-aug20-001`; payload hash `919d7533efa1a2a7b4674d936260bee434896be1f43c43e7a74e50c99d69722e`; Outlook message ending `ACjkdy8AAAAA==`.
- Dispatch `email-monitor-route-vendor-invoice-20260821-tim-hours-aug21-001`; payload hash `af1cedca2941b603d31f492207184f844d98f9d37c5b1504d19231d0ddd828f6`; Outlook message ending `ACjvzcuQAAAA==`. Tim reported no hours. The subject says `Friday 8/21`, while the body says `Friday 8/12`; both date statements are preserved without selecting one.
- Parent PR message `prmsg-email-monitor-route-vendor-invoice-20260824-tim-hours-approval-001`; dispatch `email-monitor-route-vendor-invoice-20260824-tim-hours-approval-001`; payload hash `cbc2b6a7f2f50f2d2adc70711df82ac9c0a5318f74a5080e1463d8030bb82c49`. Wes's current chat instruction expressly authorized routing the unsent approval draft and applying its approval to this exact invoice.
- Linked correction PR message `prmsg-email-monitor-route-vendor-invoice-20260824-tim-hours-approval-correction-001`; payload hash `55b4f6414eb810e4e9bea198931fd17636f8b7df76d9e64e432bede6e745b83c`. The correction restores the dollar signs in `$62.50` and `$1,156.25` and changes no invoice fact.

## Draft Lines

| Work date | Reported project | Description | Hours | Rate | Amount |
| --- | --- | --- | ---: | ---: | ---: |
| 2026-08-17 | 908 Pond St | Cut basement tile; moved staircase; framed bedroom and basement walls | 4.5 | `$62.50` | `$281.25` |
| 2026-08-18 | 908 Pond St | Cut plywood beneath kitchen cabinets; attached subfloor; removed rear garage siding; project meeting | 4.0 | `$62.50` | `$250.00` |
| 2026-08-19 | 908 Pond St, correction review | Installed spiral-stair treads, spindles, and railing; source also notes a Rosebrooks stop with no separate duration | 5.0 | `$62.50` | `$312.50` |
| 2026-08-20 | 908 Pond St | Aligned and adjusted stairs, rails, and railing; anchored platform | 5.0 | `$62.50` | `$312.50` |
| **Total** |  |  | **18.5** |  | **`$1,156.25`** |

## Correction Review

Tim expressly reported the August 19 line as `Pond 5 hours`, so the draft keeps all five hours at Pond as the working interpretation. The same description says he stopped at Rosebrooks to turn off water and discuss Josh's questions but supplies no separate duration. The draft and delivery request disclose that ambiguity and ask Tim to reply only if the allocation, hours, dates, work, rate, or amount needs correction.

## Artifact

- Archive folder: `Invoice Entry Working Archive\Generated\2026-08-20-Tim-Pond-Hours-Draft`.
- PDF: `26-08-20 - Tim Fleming - 908 Pond St - Invoice Draft.pdf`.
- PDF and structured input total two durable generated artifacts before the disposable QA render is removed.
- One-page visual, extracted-text, invoice-number, status, and arithmetic checks passed.

## Duplicate Control

- Prior Tim package ends August 14; these August 17-20 hours do not overlap it.
- No prior dispatch, Outlook source, invoice number, or August 17-20 Tim packet matched these sources.
- Repeated routing must update this packet rather than create another obligation.
- The zero-hours source creates no payable line and does not change the existing `18.5` hours or `$1,156.25` draft total. Its date conflict remains source evidence only unless Tim supplies a correction.

## Correction-Review Delivery

- Request: `IE-EMAIL-20260820-TIM-POND-DRAFT-001`.
- Sent and verified: `2026-08-20T22:26:05Z` from OfficeAssist to Tim; Wes and Jenny copied; BCC empty.
- Subject: `908 Pond St - Tim Fleming August 17-20 Invoice - Correction Review`.
- Sent message id ending: `ACjkgFuQAAAA==`.
- One non-inline `application/pdf` attachment verified: `26-08-20 - Tim Fleming - 908 Pond St - Invoice Draft.pdf`, 4,040 transmitted bytes.
- No approval, filing, workbook posting, payment, or paid status followed.

## Wes Approval And Finalization

- Wes approved the exact invoice `IE-TF-20260820-POND-001`, `18.5` hours at `$62.50` per hour, total `$1,156.25`.
- The final one-page PDF is marked `APPROVED BY WES / NOT PAID`; visual, extracted-text, arithmetic, and source checks passed.
- Working archive: `Invoice Entry Working Archive\Generated\2026-08-24-Tim-Pond-Hours-Approved\26-08-20 - Tim Fleming - 908 Pond St - Invoice.pdf`.
- PDF SHA-256: `0DBA9A1345934D74E68847F51EA9433054F978A23C57B4F43A99A36176CBB306`.
- The final PDF was filed once and read back from `Property/26-BYH -908 Pond St/Owning/Invoices/26-08-20 - Tim Fleming - 908 Pond St - IE-TF-20260820-POND-001.pdf`.
- The unsent Outlook approval draft was not sent. Tim was not contacted, and no payment or paid status was created.

## Workbook Review Placement

- Fresh authoritative source: `Property/26_Project Management - 908 Pond St 3.xlsm`, SharePoint item `01ZGFUBDJX4TR5QBFBDBG2RQTZNGHMZVZV`.
- Duplicate checking found no existing invoice number `IE-TF-20260820-POND-001` or Review Row ID `IE-20260824-TIM-20260820-POND`.
- One local Review row was staged with blank destination, status `Needs Review`, amount `$1,156.25`, and the stable Review Row ID. Excel reopen, formula fingerprint, VBA presence, zero-external-link, table, and visual checks passed.
- SharePoint rejected the exact full-workbook replacement as requiring explicit shared-workbook overwrite approval. No alternate write path was attempted, so the authoritative workbook is unchanged.
