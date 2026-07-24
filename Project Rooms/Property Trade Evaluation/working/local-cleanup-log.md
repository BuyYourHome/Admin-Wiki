# Local Cleanup Log

Use this file to record local generated/dependency cleanup that affects performance but does not move authoritative source material.

| Date | Path | Category | Action | Verification | Notes |
| --- | --- | --- | --- | --- | --- |
| 2026-07-24 | `working\node_modules\` | generated dependency cache | Removed from local Admin wiki working tree | Folder removed; Git already ignored it and tracked 0 files under this path | Recreate dependencies only if a future Property Trade Evaluation tool run needs them. Do not commit dependency folders as durable source. |
| 2026-07-24 | `working\__pycache__`, `working\amortization-rollout`, `working\render-*`, `working\rendered-*`, `working\satisfaction-note-draft`, `working\tensity-inspection` | generated working artifacts | Copied to Teams, verified, then removed from local Admin wiki working tree | 60 files / 22,910,945 bytes verified at `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\24-HM - 4121 Tensity Dr\Selling\Codex Working Archive\Property Trade Evaluation\2026-07-24 repo cleanup` | Includes Python caches, migration logs, rendered QA images, one short render DOCX, satisfaction-note rendered pages, and Tensity workbook backups. Do not restore to Git unless Wes explicitly identifies a specific file as durable source. |
