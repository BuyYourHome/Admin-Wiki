# Git Untracked Cleanup Review

Date: 2026-07-12

## Current State

After adding ignore rules for generated dependency folders, Python caches, rendered previews, scan previews, and generated spreadsheet working copies, the visible untracked file count dropped from 16,538 to 117.

The remaining 117 files should not be hidden or deleted as generic clutter. They include source material, final or review outputs, working copies, and workflow logs from several project rooms.

## Classification

### Likely Durable Sources

- Estate Documents: Heritage IRA email body and images.
- Operating Agreements: Josh Kennedy MOU source text.
- REI BlackBook: Gracious Millionaire photo source assets and web-sized copies.

Recommended handling: review by project room, then commit if the project-room owner wants these preserved in Git.

### Likely Deliverables Or Review Outputs

- Doc Scan: July 7 scan run report PDF.
- Estate Documents: Heritage IRA Roth conversion statement DOCX/PDF outputs and rendered review pages.
- Operating Agreements: Joshua Kennedy MOU redline output.

Recommended handling: review by project room, then either commit final deliverables or copy final deliverables to the requested external destination.

### Working Binary Copies

- Invoice Entry: Lowes 5997 statement-mode workbook copies.
- Operating Agreements: multiple Joshua Kennedy MOU working review DOCX files.
- Property Trade Evaluation: short-render term sheet DOCX.

Recommended handling: do not hide automatically. These are likely process artifacts or review copies. Project-room-specific cleanup should decide whether they are historical, final, or disposable.

### Working Logs And Data

- Doc Scan: closing acquisition audit CSV/TXT outputs.
- Template to Project: worksheet migration and validation JSON/CSV/TXT logs.
- Estate Documents: promissory-note text support file.

Recommended handling: keep visible until the relevant workflow decides whether these are needed for auditability or can be ignored as generated run logs.

## Cleanup Rule

Do not delete or broadly ignore remaining visible untracked files just to make Git clean. Treat each group as project-room-specific work:

1. Durable sources and final outputs can be committed in scoped project-room commits.
2. Old generated render/log material can be ignored or deleted only after confirming it is not the authoritative record.
3. Binary working copies should be reviewed before committing because they can be large, sensitive, or obsolete.
