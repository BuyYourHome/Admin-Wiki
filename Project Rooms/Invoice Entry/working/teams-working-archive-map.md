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
