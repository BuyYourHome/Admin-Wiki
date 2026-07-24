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

## Use Rule

When Invoice Entry needs older machine handoff packets, Lowe's statement working files, review-request evidence, or temporary workbook copies from the July 2026 cleanup, look in the Teams destinations above before assuming the files were deleted.

Do not copy archived Teams files back into Git unless Wes explicitly identifies a specific file as durable source material. Prefer durable Markdown logs that record what happened to the document or spreadsheet item.
