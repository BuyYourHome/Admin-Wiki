# Teams Working Archive Map

This map records Contract for Deed working files that were removed from the Admin wiki Git working tree and preserved in Teams.

## Teams Root

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\28-SYH-320 Rose Pl\Selling\Ever Cardoza\Codex Working Archive\Contract for Deed`

Use this Teams folder only for Codex working-history cleanup material. It is separate from the active buyer `Contract Package` folder and should not be treated as a closing-package delivery location.

## Cleanup Recorded 2026-07-24

The following ignored local working files were copied to Teams, verified by file count and byte total, and then removed from `C:\Codex\Wiki Files`.

| Local source under `Project Rooms\Contract for Deed\working` | Teams destination under `Codex Working Archive\Contract for Deed\2026-07-24 repo cleanup` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| `__pycache__` | `working\__pycache__` | 18 | 384,282 | Python cache |
| `attorney-sync` | `working\attorney-sync` | 63 | 8,666,676 | generated attorney-sync backups, render previews, and LibreOffice profiles |
| `rendered-affidavit-manager-update` | `working\rendered-affidavit-manager-update` | 8 | 834,956 | rendered QA output |
| `rendered-closing-document-header` | `working\rendered-closing-document-header` | 2 | 366,125 | rendered QA output |
| `run-metrics` | `working\run-metrics` | 30 | 875,748 | generator/run metrics |
| `spreadsheet-refactor` | `working\spreadsheet-refactor` | 1 | 834,536 | spreadsheet-refactor backup |

Total moved in this cleanup: 122 files, 11,962,323 bytes.

## Use Rule

Do not copy these archived Teams files back into Git unless Wes explicitly identifies a specific file as durable source material. If a prior render, backup, metric, or cache-adjacent file is needed for comparison, copy that specific file into a short-lived local working folder, use it for the task, and remove it when finished unless Wes approves preserving it.

For current work, keep CFD prototypes, scripts, transaction handoffs, durable logs, and source rules in the project room. Move generated render previews, LibreOffice profiles, Python caches, benchmark/run-metric batches, temporary workbook backups, and superseded working artifacts to the separate Teams `Codex Working Archive` after they are processed and verified. Do not place cleanup artifacts in the active Teams `Contract Package`.
