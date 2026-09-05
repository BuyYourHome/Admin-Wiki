# Teams Working Archive Map

This map records Invoice Entry machine handoff packets, workbook copies, and generated working files that were removed from the Admin wiki Git working tree and preserved in Teams.

## Teams Root

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files\Invoice Entry Working Archive`

Use this Teams folder as the retained location for Invoice Entry working files that may be useful for audit or comparison but should not live in Git.

## Cleanup Recorded 2026-07-23

The following untracked local Invoice Entry files were copied to Teams, verified by file count and byte total, and then removed from `C:\Codex\Wiki Files`.

| Local source under `Project Rooms\Invoice Entry` | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| `sources\doc-scan-packets\doc-scan-amazon-4121-tensity-20260722-100701.json` | `Packets\doc-scan-amazon-4121-tensity-20260722-100701.json` | 1 | 2,581 | machine handoff packet |
| `working\lowes-statements-2026-requested-20260715` | `Lowes Statement Working Files\lowes-statements-2026-requested-20260715` | 62 | 14,407,394 | generated statement working files |
| `working\review-requests` | `Review Requests` | 25 | 10,233,815 | review workbook copies/evidence |
| `working\workbooks` | `Workbook Copies` | 3 | 2,139,047 | temporary workbook copies |

Total moved in this cleanup: 91 files, 26,782,837 bytes.

## Cleanup Recorded 2026-07-24

The following ignored local Invoice Entry working files were copied to Teams with long-path-safe file copy, verified by file count and byte total, and then removed from `C:\Codex\Wiki Files`.

| Local source under `Project Rooms\Invoice Entry` | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| Ignored files under `working\`, preserving the same relative folder structure | `Ignored Working Files\2026-07-24 working cleanup\<same folder structure>` | 122 | 126,866,724 | ignored workbook backups, statement working files, generated invoice PDFs/render previews, and temporary workbook downloads |

The following tracked Invoice Entry operational source files were copied to Teams, verified by file count and byte total, and then removed from Git under the Source Packet And Email Retention Rule. These are retained source packets and routed email source records, not durable wiki rules.

| Local source under `Project Rooms\Invoice Entry` | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| Operational files under `sources\`, excluding root `sources\README.md`, preserving the same relative folder structure | `Source Documents\2026-07-24 source cleanup\<same folder structure>` | 19 | 60,335 | retained packet, routed email, and source-folder instruction files |

## Use Rule

When Invoice Entry needs older machine handoff packets, Lowe's statement working files, review-request evidence, or temporary workbook copies from the July 2026 cleanup, look in the Teams destinations above before assuming the files were deleted.

Do not copy archived Teams files back into Git unless Wes explicitly identifies a specific file as durable source material. Prefer durable Markdown logs that record what happened to the document or spreadsheet item.

## Cleanup Recorded 2026-07-28

| Local source under `Project Rooms\Invoice Entry` | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| `sources\email\2026-07-27-*` | `Source Documents\2026-07-28 Josh Kennedy Time Card\email` | 3 | 5,887 | routed Time Card sources |
| Generated July 31 draft PDF and render preview | `Generated\2026-07-28-JK` | 2 | 155,290 | generated invoice working files |
| Regenerated week-ending July 24 worker-verified PDFs and render previews | `Generated\2026-07-28-JK-Week24-Final` | 4 | 470,429 | generated final-status invoice working files |
| Atlantic Discount Flooring invoice `001521` routed sources | `Source Documents\2026-07-28 Atlantic Discount Flooring 001521\email` | 5 | 8,224 | routed duplicate invoice and payment-confirmation sources |
| Atlantic Discount Flooring invoice `001521` PDF | `Source Documents\2026-07-28 Atlantic Discount Flooring 001521\invoice` | 1 | 51,959 | authoritative downloaded Square invoice |

The files were copied, verified by file count and byte total, and removed from the Admin wiki working tree.

## Cleanup Recorded 2026-07-29

| Local source under `Project Rooms\Invoice Entry` | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| `working\create-vendor-invoice\2026-07-20-josh-kennedy-timesheet\approval-2026-07-29` | `Generated\2026-07-29-JK-Week24-Approval` | 12 | 3,938,996 | approved PDFs, workbook rollback/validation copies, render evidence, and run scripts |
| `sources\email\2026-07-29-135616-wes-approval-josh-time-card-week-ending-2026-07-24.md` | `Source Documents\2026-07-29 Josh Kennedy Time Card Approval\email` | 1 | 1,903 | routed Wes approval source |

The files were moved after destination, file-count, and byte-total verification. The authoritative Outlook message id and durable processing outcome remain in the packet and source inventory.

## Cleanup Recorded 2026-07-30

| Local source under `Project Rooms\Invoice Entry` | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| July 29 update PDF and render preview for Josh Kennedy week ending 2026-07-31 | `Generated\2026-07-30-JK-Week31-Update` | 2 | 186,689 | generated Time Card invoice and visual-QA evidence |

The files were moved after destination, file-count, and byte-total verification. The weekly structured packet and delivery evidence remain in the Invoice Entry working records.

## Additional Cleanup Recorded 2026-07-30

| Local source under `Project Rooms\Invoice Entry` | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| Outside-person internal invoice template PDF and render preview | `Generated\2026-07-30-Outside-Person-Invoice-Template-Draft` | 2 | 163,563 | template-review PDF and visual-QA evidence |
| `sources\email\2026-07-30-132551-wes-forward-tim-fleming-hours-week-2026-07-29.md` | `Source Documents\2026-07-30 Tim Fleming Multi-Project Hours\email` | 1 | 1,120 | routed Tim Fleming hours source |

The template artifacts were file-count and byte-total verified. The Tim source was moved to the recorded archive destination and its destination byte count was verified. The proposed template generator remains in the project room for Wes-requested review revisions.

## Canonical Template Replacement Archive Recorded 2026-07-30

| Local source under `Project Rooms\Invoice Entry` | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| Josh replacement PDFs, Tim verification drafts, structured generator inputs, and render previews | `Generated\2026-07-30-Canonical-Template-Replacements` | 15 | 660,075 | canonical-format invoice generation and visual-QA evidence |

The files were copied, verified by file count and byte total, and removed from the Admin wiki working tree. Josh's two authoritative SharePoint PDFs were replaced at their existing paths. Tim's three PDFs remain verification drafts pending his response and Wes's later approval.

## Payment And Verification Archive Recorded 2026-07-30

| Local source under `Project Rooms\Invoice Entry` | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| Josh biweekly service-payment invoice, week-ending July 24 allocation reports, structured inputs, and render previews | `Generated\2026-07-30-Josh-Biweekly-And-Allocation` | 9 | 529,989 | payable draft plus non-payable allocation working artifacts |
| Tim Fleming vendor-verified invoices, structured inputs, and render previews | `Generated\2026-07-30-Tim-MultiProject-Wes-Approval` | 9 | 418,250 | Wes approval package working artifacts |
| Josh week-ending July 31 allocation report, structured input, and render preview | `Generated\2026-07-30-JK-Week31-Allocation` | 3 | 193,414 | non-payable Time Card allocation working artifacts |
| Tim vendor-verification and Josh July 28 completion source records | `Source Documents\2026-07-30 Tim Verification And Josh Time Completion\email` | 2 | 2,372 | routed source evidence |

Each file was hash-verified at the archive destination before its working copy was removed. Durable packet, delivery, and status records remain in the Invoice Entry project room.

## Semimonthly Time Card Draft Cleanup Recorded 2026-08-03

| Local source under `Project Rooms\Invoice Entry` | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| July 16-31 Josh Kennedy LLC invoice PDF, structured input, and two visual-QA renders | `Generated\2026-08-03-Josh-Semimonthly-Draft` | 4 | 348,155 | semimonthly Time Card invoice draft and QA evidence |
| Superseded week-ending July 31 allocation JSON and two delivery working records | `Generated\2026-08-03-JK-Week31-Superseded-Working-Records` | 3 | 5,768 | superseded weekly generated and delivery working artifacts |

Both archive destinations were verified by file count and byte total before the generated local copies were removed. The OfficeAssist Sent Items copy remains the authoritative delivered draft; the durable Invoice Entry packet and delivery receipt remain in the project room.

## Approved Semimonthly Invoice Format Archive Recorded 2026-08-03

| Local source under `Project Rooms\Invoice Entry` | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| Approved July 16-31 Josh Kennedy LLC invoice PDF and one-page visual-QA render | `Generated\2026-08-03-Josh-Semimonthly-Approved-Format` | 2 | 250,796 | approved semimonthly Time Card invoice revision and QA evidence |

Both archived files were SHA-256 verified against the generated working copies. The revised OfficeAssist Sent Items attachment remains the authoritative delivered copy; filing, workbook posting, payment, and paid-status action were not performed.

## 2025 Lowe's Tensity Upload Hold Recorded 2026-08-04

| Local working files | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| Validated edited Tensity workbook and pre-edit rollback copy | `Generated\2026-08-04-2025-Lowes-Tensity-Upload-Hold` | 2 | 1,480,982 | SharePoint `423 resourceLocked` upload hold |

The archived files were verified by file count, byte total, and SHA-256. Validated edited workbook hash: `C57EB95396F5185BB885F61428FF62AFB19EF9E5B8FFC575909D57FAF75D2552`. Rollback hash: `E875FA56C14C0EA70ECF292DECEF5D2714D183FFE3B1C061A9180301DB98FD60`. The freshness-safe retry succeeded on 2026-08-04; the re-fetched authoritative workbook matched the validated hash exactly. Retain both files as upload and rollback evidence; do not upload the held copy again.

## Sullivan Surveying Invoice 2475 Source Recorded 2026-08-08

| Source | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| Primary Outlook attachment for Sullivan Surveying invoice `2475` | `Source Documents\2026-08-08 Sullivan Surveying 2475\invoice` | 1 | 107,785 | authoritative routed invoice attachment; duplicate Outlook transport copy not downloaded |

The retained PDF hash is `C35B6EBCEE79CA9EAC304B6415C35FD9A8369A8CF4EECF0431B011F934A728E2`. It remains a held source document, not a project-folder filing, approval, payment record, or paid-status artifact.

## Josh August 1-15 Daily Draft Archive Recorded 2026-08-11

| Local working files | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| August 1-15 Josh Kennedy LLC daily draft PDF, structured input, and one-page visual-QA render | `Generated\2026-08-11-Josh-Semimonthly-Daily-Draft` | 3 | 187,477 | open-period semimonthly Time Card draft and QA evidence |

The archive destination was verified by file count and byte total before removal of the generated local copies. The OfficeAssist Sent Items attachment is the authoritative delivered copy. The period remains open; the draft is not final, approved, filed, posted, paid, or proof of payment.

## Josh August 1-15 Updated Daily Draft Archive Recorded 2026-08-11

| Local working files | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| August 1-15 Josh Kennedy LLC draft updated through August 11, structured input, and one-page visual-QA render | `Generated\2026-08-11-Josh-Semimonthly-Daily-Draft-Through-Aug11` | 3 | 220,530 | open-period semimonthly Time Card draft and QA evidence |

The archive destination was verified by file count and byte total before removal of the generated local copies. The OfficeAssist Sent Items attachment is the authoritative delivered copy. The August 11 work date remains a documented received-date assumption subject to correction-by-exception review; no finalization, filing, posting, approval, payment, or paid status occurred.

## Mathews Flooring Invoice 936569 Archive Recorded 2026-08-11

| Local/source files | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| Outlook inline image `image0.jpeg` for Mathews Flooring invoice 936569 | `Source Documents\2026-08-11 Mathews Flooring 936569\image` | 1 | 2,348,369 | authoritative routed source image |
| Generated Mathews Flooring draft PDF, structured input, and one-page QA render | `Generated\2026-08-11-Mathews-Flooring-936569-Draft` | 3 | 163,433 | review-ready generated invoice and QA evidence |

The source image SHA-256 is `6CF41EC84DF7F46F0C216C5A18CCC4070A9AD8BDA06C03C3A497B0D1C34A886D`. Both archive destinations were verified by file count and byte total before generated working copies were removed.

On 2026-08-12, Wes directed that the PDF be sent to him and moved into the property folder. After the SharePoint copy and OfficeAssist Sent Items attachment were verified, the PDF was removed from `Generated\2026-08-11-Mathews-Flooring-936569-Draft`. That archive folder now retains 2 files totaling 160,186 bytes: the structured generation input and QA render. The filed PDF is authoritative at `Property/24-HM - 4121 Tensity Dr/Owning/Invoices/26-08-07 - Mathews Flooring LLC - Invoice 936569 - 4121 Tensity Dr.pdf`. Filing and review delivery do not establish approval, payment, paid status, or workbook posting.

## Mathews Flooring Invoice 936569 Final Archive Recorded 2026-08-12

| Local working files | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| Final approved structured input and one-page visual-QA render | `Generated\2026-08-12-Mathews-Flooring-936569-Final` | 2 | 154,438 | approved final generation and QA evidence |

The final PDF itself remains authoritative in the Tensity property `Owning/Invoices` folder and in OfficeAssist Sent Items. The archive destination was verified by file count and byte total before the temporary local files were removed. Approval does not establish payment, paid status, or workbook posting.

## Josh August 1-15 Final-Style Presentation Draft Archive Recorded 2026-08-12

| Local working files | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| Corrected August 1-15 Josh Kennedy LLC final-style presentation PDF through August 11, structured input, and one-page visual-QA render | `Generated\2026-08-12-Josh-Semimonthly-Final-Style-Draft` | 3 | 191,160 | open-period final-style Time Card presentation and QA evidence |

The archive destination was verified by file count and byte total before removal of the generated local copies. The OfficeAssist Sent Items attachment is the authoritative delivered copy. The PDF intentionally omits approval and draft wording for appearance review, but the email identifies it as a presentation draft; the period remains open and no finalization, filing, posting, approval, payment, or paid status occurred.

## Josh August 1-15 Updated Daily Draft Through August 12 Recorded 2026-08-13

| Local working files | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| Josh Kennedy LLC open-period draft PDF through August 12, structured input, and one-page visual-QA render | `Generated\2026-08-13-Josh-Semimonthly-Daily-Draft-Through-Aug12` | 3 | 205,150 | open-period semimonthly Time Card draft and QA evidence |

The archive destination was verified by file count and byte total before the generated local copies were removed. The OfficeAssist Sent Items attachment is the authoritative delivered copy. The period remains open; no finalization, filing, posting, approval, payment, or paid status occurred.

## Rosebrooks Cleanup Cash Receipt Hold Recorded 2026-08-14

| Local working files | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| Verified Rosebrooks cleanup-cash receipt PDF | `Generated\2026-08-14-Rosebrooks-Cleanup-Cash-Receipt-Hold` | 1 | 3,080 | completed receipt held pending authoritative property destination |

The archive copy matches SHA-256 `840577A7E20AD829BDAA207772D2DD8DD6BE0C0F6B8921735B4CD59C1FB58243`. Property filing is held because the current `20-HM` Rosebrooks `Owning` folder has no established receipt destination; the stale `19-HM` centralized invoice folder was not used. At the receipt-hold step, no workbook insertion, deposit record, Marketplace action, email, payment, approval, or paid status occurred; the later authorized workbook posting is recorded below.

## Receipt Opposite-Sign Workbook Posting Archive Recorded 2026-08-14

| Local working files | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| Tensity and Rosebrooks pre-edit rollback workbooks plus validation manifest | `Generated\2026-08-14-Receipt-Opposite-Sign-Workbook-Posting` | 3 | 1,451,032 | rollback and authoritative read-back evidence for two receipt postings |

The Tensity rollback hash is `1692670AFB1ADE6098E34E0388823E45DED30888ECAC6F37F1BDF9EF29357480`; the Rosebrooks rollback hash is `212141F3DDC36F5E0C3ABFCAE89F80A50C6182E1FDFB61A4774DE2E0BB8AE351`. Authoritative uploaded/read-back hashes are `F417613E9F53CC395D326B23199C73E2246C07BCD7691FAF4B454083C2B535BD` for Tensity and `2FEE630DA2762745DCED877AB33679F8C6A260DB9CE8B170693B44F054AC6770` for Rosebrooks. Both postings were duplicate-checked, reopened in Excel, visually sampled, uploaded by exact target, and downloaded byte-for-byte. No email, payment, deposit, Marketplace, approval, or paid-status action occurred.

## Rosebrooks Estate Sale Item ES-20260815-003 Receipt And Workbook Evidence Recorded 2026-08-14

| Local working files | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| Formal receipt PDF, structured JSON, and one-page QA render | `Generated\2026-08-14-Rosebrooks-ES-003-Receipt-Hold` | 3 | 143,644 | completed receipt held pending authoritative property receipt destination |
| Rosebrooks pre-edit rollback workbook and validation manifest | `Generated\2026-08-14-Rosebrooks-ES-003-Workbook-Posting` | 2 | 717,650 | rollback and authoritative read-back evidence |

The receipt PDF matches SHA-256 `ADC476AB842B4D6AC29AF87A5F8C877D8D365E8537FD20479E5DBDD8F68C14A3`. The rollback workbook matches `2FEE630DA2762745DCED877AB33679F8C6A260DB9CE8B170693B44F054AC6770`; the authoritative uploaded/read-back workbook matches `D2090DBCB53976461D306A2988383FE09C133B968308EB3E3AF0FEB30BB93EA0`. Filing remains held because the current Rosebrooks property folder has no established receipt destination. No email, payment, approval, paid status, deposit record, or direct Facebook action occurred.

## Tim Fleming Three-Project Approved Package Recorded 2026-08-16

| Local working files | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| Three approved-not-paid PDFs, three structured inputs, and three one-page QA renders | `Generated\2026-08-16-Tim-Jeff-Hours-Approved` | 9 | 291,863 | final approved package and visual-QA evidence; Rosebrooks filing hold copy retained |

All three PDFs passed visual, extracted-text, status, invoice-number, and arithmetic checks. Pond and Tensity were filed once to their established SharePoint `Owning/Invoices` folders and read-back verified. Rosebrooks remains retained here because its current property folder has no established `Invoices` destination. The approved-status email was sent and verified. No workbook posting, payment, or paid status occurred.

## Josh Kennedy August 1-15 Draft Through August 14 Recorded 2026-08-16

| Local working files | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| Period-closed correction-review PDF, structured input, and one-page QA render | `Generated\2026-08-16-Josh-Semimonthly-Daily-Draft-Through-Aug14` | 3 | 254,854 | semimonthly Time Card draft and QA evidence; not finalized |

The one-page PDF passed visual, extracted-text, hours, and arithmetic checks. Both detail and project allocation totals equal `$2,708.33`. No filing, workbook posting, approval, payment, or paid status occurred.

## Josh Kennedy August 1-15 Closed Draft Through August 15 Recorded 2026-08-17

| Local working files | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| Full-period correction-review PDF, structured input, and one-page QA render | `Generated\2026-08-17-Josh-Semimonthly-Closed-Draft-Through-Aug15` | 3 | 271,603 | semimonthly Time Card draft and QA evidence; awaiting Wes approval |

The one-page PDF passed visual, extracted-text, hours, and arithmetic checks. Accepted time is `100 hours 25 minutes`, and both detail and project allocation totals equal `$2,708.33`. Correction-review delivery to Josh and the separate approval request to Wes were both sent exactly once and verified. No finalization, property filing, workbook posting, payment, or paid status occurred.

## Tim Fleming August 17-20 Pond Draft Recorded 2026-08-20

| Local working files | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| Correction-review PDF and structured input | `Generated\2026-08-20-Tim-Pond-Hours-Draft` | 2 | 5,603 | generated vendor invoice draft; not approved, filed, posted, or paid |

The one-page PDF passed visual, extracted-text, invoice-number, source, status, and arithmetic checks. The disposable QA render was removed after inspection. The draft records `18.5` hours / `$1,156.25` and visibly preserves the August 19 Rosebrooks-duration question. OfficeAssist delivery to Tim with Wes and Jenny copied was sent exactly once and verified at `2026-08-20T22:26:05Z`.

## Josh Kennedy August 16-31 Draft Through August 25 Recorded 2026-08-26

| Local working files | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| Open-period correction-review PDF, structured input, and one-page QA render | `Generated\2026-08-26-Josh-Semimonthly-Daily-Draft-Through-Aug25` | 3 | 296,444 | semimonthly Time Card draft and QA evidence; August 25 allocation unresolved |

The PDF matches SHA-256 `61D5BD870127149D73F6168597564687033F351C55F3D264563A05A2A3B463E4` and passed one-page visual, extracted-text, hours, ambiguity-label, and arithmetic checks. The August 25 10:30 AM-4:15 PM interval remains unallocated between Rosebrooks and BackOffice. The dispatch prohibited vendor contact, so this updated draft was not emailed. No approval, finalization, filing, workbook posting, payment, or paid status occurred.

## Josh Kennedy August 16-31 Draft Through August 26 - Local Archive Hold Recorded 2026-08-27

| Local working files | Intended Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Status |
| --- | --- | ---: | ---: | --- |
| One-page correction-review PDF, structured input, and QA render under `working\create-vendor-invoice\2026-08-31-josh-kennedy-semimonthly-time-card-invoice\generated-2026-08-27` | `Generated\2026-08-27-Josh-Semimonthly-Daily-Draft-Through-Aug26` | 3 | 283,859 | Retained locally; this intake did not authorize copying the draft to Teams |

The PDF matches SHA-256 `DB797EB679CCAB3BEB17CF9B507147695323EF65B0E1A2E5F52BCCE5E8427ACE` and passed one-page visual, extracted-text, source-spelling, hours, and arithmetic checks. The files are classified and preserved locally pending explicit archive authority. No email, filing, workbook action, approval, payment, or paid status occurred.

## Josh Kennedy August 16-31 Closed-Period Correction Review - Archived 2026-09-01

| Local working files | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Status |
| --- | --- | ---: | ---: | --- |
| One-page correction-review PDF, structured input, and QA render from `working\create-vendor-invoice\2026-08-31-josh-kennedy-semimonthly-time-card-invoice\generated-2026-09-01-closeout` | `Generated\2026-09-01-Josh-Semimonthly-Closeout-Draft` | 3 | 368,707 | Destination count, byte total, and per-file SHA-256 verified; temporary local generation folder removed |

The PDF matches SHA-256 `857A85444FA98FB2B7E8DFA3A0EFE5C13467C4AAB71993A4EA75E83643FB61E0` and passed one-page visual, hours, disclosure, and arithmetic checks. Email delivery was Sent Items-verified before cleanup. The invoice remains a correction-review draft awaiting Wes approval; it is not final, filed, posted, paid, or marked paid.

## Josh Kennedy August 17 Corrected Closed-Period Draft - Local Hold 2026-09-01

| Local working files | Intended handling | Files | Bytes | Status |
| --- | --- | ---: | ---: | --- |
| Corrected one-page draft PDF, JSON input, and QA render under `tmp\pdfs\josh-aug17-correction` | Hold locally pending authorized cleanup or archive handling | 3 | 396,390 | Visual and arithmetic QA passed; external Working Archive retention was not authorized under the no-filing restriction |

The PDF matches SHA-256 `7409455004CFDE4B1BBBA5E8E42FBDFB782ED6044F0A3A1F454D4B0F940F0670`. It reflects only Josh's exact August 17 allocation correction; August 25 remains unresolved. No email, finalization, filing, workbook posting, QuickBooks routing, approval, payment, or paid status occurred.

## Tim Fleming August 24-28 Correction-Review Package - Archived 2026-08-31

| Local working files | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Status |
| --- | --- | ---: | ---: | --- |
| Two separate invoice PDFs, two JSON generation inputs, and two visual-QA PNG renders from `working\create-vendor-invoice\2026-08-24-tim-fleming-pond-hours\generated-2026-08-31` | `Generated\2026-08-31 Tim Fleming Weekly Correction Review` | 6 | 355,158 | Destination count and byte total verified; temporary local generation folder removed |

OfficeAssist delivery `IE-EMAIL-20260831-TIM-WEEKLY-CORRECTION-REVIEW-001` was Sent Items-verified before cleanup. The archive contains the generated correction-review evidence only; neither invoice is approved, filed to a property, posted, paid, or marked paid.

## Josh Kennedy August 25 Corrected Closed-Period Draft - Local Hold 2026-09-01

| Local working files | Intended handling | Files | Bytes | Status |
| --- | --- | ---: | ---: | --- |
| Corrected one-page draft PDF, JSON input, and QA render under `tmp\pdfs\josh-aug25-correction` | Hold locally pending authorized cleanup or archive handling | 3 | 391,136 | Visual and arithmetic QA passed; external Working Archive retention was not authorized under the no-filing restriction |

The PDF matches SHA-256 `0FF68C2F51F43D2BF632B96884722BB6F45D11AD46039AA8D829445739A6BB2E`. It incorporates Josh's exact August 17 and August 25 allocation corrections. Corrected delivery `IE-EMAIL-20260901-JOSH-SEMIMONTHLY-CORRECTED-DRAFT-009` was sent exactly once and Sent Items-verified; the malformed predecessor was blocked before send. No finalization, filing, workbook posting, QuickBooks routing, approval, payment, or paid status occurred.

## Josh Kennedy LLC August 16-31 Approved Invoice - 2026-09-01

- Final filing: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Invoices & Receipts\26-08-31 - Josh Kennedy LLC - Time Card Invoice - 2026-08-16 to 2026-08-31.pdf`.
- Working archive: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files\Invoice Entry Working Archive\Generated\2026-09-01-Josh-Semimonthly-Approved-Aug16-31`.
- Approved PDF SHA-256: `7C7035C1FE3EC44DC6A485D54E7E7EC566D7FC9DF556BCDBE3C31D0D6051E433`.
- Archive contains the approved PDF, workbook rollback copies, validated edited/staged copies, and Review QA evidence for Pond, Rosebrooks, and Tensity.

## Josh Kennedy September 1-15 Draft Through September 1 - 2026-09-02

| Local working files | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Status |
| --- | --- | ---: | ---: | --- |
| One-page open-period draft PDF, structured JSON input, and QA render from `working\create-vendor-invoice\2026-09-15-josh-kennedy-semimonthly-time-card-invoice\generated-2026-09-02` | `Generated\2026-09-02-Josh-Semimonthly-Daily-Draft-Through-Sep1` | 3 | 109,170 | Destination count, byte total, and per-file SHA-256 verified; local generated folder removed |

The PDF matches SHA-256 `C4035D25A2C3C0A40E469DCFD2FA203B3029ACF6C88D9152EBE62EB0E06FD630`. Email Delivery request `IE-EMAIL-20260902-JOSH-SEMIMONTHLY-DAILY-DRAFT-010` was sent exactly once and OfficeAssist Sent Items-verified before cleanup. The invoice remains an open-period correction-review draft; no approval, finalization, filing, workbook posting, QuickBooks routing, payment, or paid status occurred.

## Josh Kennedy September 1-15 Draft Through September 3 - 2026-09-03

| Local working files | Teams destination under `Invoice Entry Working Archive` | Files | Bytes | Status |
| --- | --- | ---: | ---: | --- |
| One-page open-period draft PDF, structured JSON input, and QA render from `working\create-vendor-invoice\2026-09-15-josh-kennedy-semimonthly-time-card-invoice\generated-2026-09-03` | `Generated\2026-09-03-Josh-Semimonthly-Daily-Draft-Through-Sep3` | 3 | 151,099 | Destination count, byte total, and per-file SHA-256 verified; local generated folder removed |

The PDF matches SHA-256 `3E1003B9B7077311B7ACEB3B68C38E5DD7D823B744F4C639A6DC216DC78F1C78`. The updated draft was internally verified but not sent because both intake records prohibit contact with Josh. The prior September 1 Sent Items evidence was not repeated. No approval, finalization, filing, workbook posting, QuickBooks routing, payment, or paid status occurred.
