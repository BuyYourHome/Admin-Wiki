# Teams Working Archive Map

This map records Doc Scan working files and generated outputs that were removed from the Admin wiki Git working tree and preserved in Teams.

## Teams Root

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files\Doc Scan Working Archive`

Use this Teams folder as the retained location for Doc Scan generated output packets, OCR/text working files, and scan-run logs that should not live in Git.

## Cleanup Recorded 2026-07-23

The following untracked local Doc Scan files were copied to Teams, verified by file count and byte total, and then removed from `C:\Codex\Wiki Files`.

| Local source under `Project Rooms\Doc Scan` | Teams destination under `Doc Scan Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| `outputs\lowes-statement-all-accounts-2026-07-15` | `Outputs\lowes-statement-all-accounts-2026-07-15` | 67 | 76,998,251 | generated output / review packet |
| `working\logs` | `Logs` | 2 | 2,310 | scan-run logs |
| `working\lowes-all-statements-2026-07-15` and `working\scan-*` folders | `OCR Working Files\<same folder structure>` | 91 | 189,935 | OCR/text working files |

Total moved in this cleanup: 160 files, 77,190,496 bytes.

## Cleanup Recorded 2026-07-24

The following tracked Doc Scan generated working artifacts were copied to Teams, verified by file count and byte total, and then removed from Git. These were not original scans and should not be reprocessed as new scanned documents.

| Local source under `Project Rooms\Doc Scan` | Teams destination under `Doc Scan Working Archive` | Files | Bytes | Category | Audit |
| --- | --- | ---: | ---: | --- | --- |
| `working\closing-2026-06-18-093957`, `working\heartbeat-2026-06-16-*`, `working\heartbeat-2026-06-17-1432`, `working\oa-2026-06-18-095324`, and `working\scan-now-2026-06-30` tracked image/PDF artifacts | `Tracked Working Artifacts\2026-07-24 tracked working image cleanup\<same folder structure>` | 108 | 39,717,411 | generated page renders, contact crops, and one report preview | `working\tracked-working-image-audit-2026-07-24.md` |

The following ignored local Doc Scan working files were copied to Teams, verified by file count and byte total, and then removed from `C:\Codex\Wiki Files`. These were generated working artifacts retained temporarily for review and may be deleted from Teams later after Wes approves final retention cleanup.

| Local source under `Project Rooms\Doc Scan` | Teams destination under `Doc Scan Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| Ignored files under `working\`, preserving the same relative folder structure | `Ignored Working Files\2026-07-24 working cleanup\<same folder structure>` | 320 | 212,088,590 | ignored generated working files, render/page previews, contact sheets, OCR/test output, and scan-run working folders |

The following ignored local Doc Scan output files were copied to Teams, verified by file count and byte total, and then removed from `C:\Codex\Wiki Files`. These were generated output previews and a scan-run report retained temporarily for review and may be deleted from Teams later after Wes approves final retention cleanup.

| Local source under `Project Rooms\Doc Scan` | Teams destination under `Doc Scan Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| Ignored files under `outputs\`, preserving the same relative folder structure | `Ignored Output Files\2026-07-24 output cleanup\<same folder structure>` | 11 | 2,073,915 | ignored generated output previews and scan-run report |

## Source Document Archive Recorded 2026-07-24

The following tracked Doc Scan source documents were copied to Teams, verified by file count and byte total, and then removed from Git under the Source Document Retention Rule. These are retained source documents, not generated scratch.

| Local source under `Project Rooms\Doc Scan` | Teams destination under `Doc Scan Working Archive` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| Binary source documents under `sources\`, preserving the same relative folder structure | `Source Documents\2026-07-24 source cleanup\<same folder structure>` | 269 | 71,607,325 | retained source scans and email attachment source documents |

## Use Rule

When Doc Scan needs older OCR text, scan-run logs, or generated Lowe's statement output packets from the July 2026 cleanup, look in the Teams destinations above before assuming the files were deleted.

Do not copy archived Teams files back into Git unless Wes explicitly identifies a specific file as durable source material. If an archived file is needed for comparison or audit, copy that specific file into a short-lived local working folder, use it for the task, and remove it when finished unless Wes approves preserving it.
