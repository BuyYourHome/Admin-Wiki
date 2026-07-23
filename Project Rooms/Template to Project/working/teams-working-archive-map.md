# Teams Working Archive Map

This map records Template to Project working files that were removed from the Admin wiki Git working tree and preserved in Teams.

## Teams Root

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\Project Template`

Use this Teams folder as the retained location for large Template to Project workbook working history, generated migration batches, rollback/current workbook copies, validation evidence, and experiment outputs that should not live in Git.

## Cleanup Recorded 2026-07-23

The following untracked local working files were copied to Teams, verified by file count and byte total, and then removed from `C:\Codex\Wiki Files`.

| Local source under `Project Rooms\Template to Project` | Teams destination under `Project Template` | Files | Bytes | Category |
| --- | --- | ---: | ---: | --- |
| `working\dependency-analysis` | `Working Archive\Experiments\Dependency Analysis\dependency-analysis` | 2 | 1,480,673 | experiment output |
| `working\format-standardization-test` | `Working Archive\Experiments\Format Standardization Test\format-standardization-test` | 10 | 5,017,320 | experiment output |
| `working\review-trigger` | `Working Archive\Experiments\Review Trigger\review-trigger` | 2 | 1,616,249 | experiment output |
| `working\profit-mode` | `Working Archive\Profit Mode\profit-mode` | 43 | 34,557,679 | generated workbook working history |
| `working\vendor-tabs-mode` | `Working Archive\Vendor Tabs Mode\vendor-tabs-mode` | 75 | 31,180,279 | generated workbook working history |
| `working\amortization-mode\<untracked run folders>` | `Working Archive\Amortization Mode\<same run-folder structure>` | 23 | 18,570,108 | generated workbook working history |
| `working\worksheet-migration\<untracked run folders and files>` | `Working Archive\Worksheet Migration\<same run-folder structure>` | 371 | 255,785,956 | generated workbook working history |

Total moved in this cleanup: 526 files, 348,208,264 bytes.

## Use Rule

When Template to Project needs older workbook working history from the July 2026 cleanup, look in the Teams destinations above before assuming the files were deleted.

Do not copy these archived Teams files back into Git unless Wes explicitly identifies a specific file as durable source material. If a prior workbook copy is needed for comparison, copy that specific file into a short-lived local working folder, use it for the task, and remove it when finished unless Wes approves preserving it.
