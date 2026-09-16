# Project Room Repository Retention Cleanup Tracker

## Purpose

Track Project Rooms that may retain operational records, source documents, generated artifacts, or other non-wiki working files in Git. Review one room at a time under its own retention and ownership rules. Candidate counts are audit signals, not automatic authorization to move or remove files.

## Classification Rule

- Keep reusable rules, specifications, schemas, templates, scripts, generic lessons, and static source-location pointers in Git.
- Keep active status, transaction records, queues, registers, processing logs, packets, attachments, generated deliverables, workbook copies, and validation evidence in the approved Teams, SharePoint, or runtime location.
- Verify the external copy by file identity and hash before removing a tracked current-tree copy.
- Do not rewrite Git history during the initial cleanup.
- Preserve unrelated work and use one focused commit per Project Room unless Wes explicitly approves a combined cleanup.

## Cleanup Queue

The counts below were measured from tracked files under `Project Rooms/*/working` on 2026-09-15. `Operational candidates` uses filename patterns such as work status, action log, ledger, queue, register, processing log, and transaction packet. `Binary candidates` counts tracked Word, Excel, PDF, image, archive, and message files.

| Order | Project Room | Tracked working files | Operational candidates | Binary candidates | Status |
| ---: | --- | ---: | ---: | ---: | --- |
| 1 | Invoice Entry | 126 | 89 | 0 | Completed 2026-09-15; 124 operational files hash-verified in Teams and removed from the current Git tree; two reusable files retained |
| 2 | Template to Project | 122 | 1 | 83 | Pending owner audit |
| 3 | Property Trade Evaluation | 105 | 0 | 73 | Pending owner audit |
| 4 | Operating Agreements | 93 | 0 | 27 | Pending owner audit |
| 5 | Credit Worthiness Evaluator | 155 | 1 | 18 | Pending owner audit |
| 6 | Contract for Deed | 203 | 1 | 15 | Pending owner audit |
| 7 | Brynda Suit | 29 | 0 | 3 | Pending owner audit |
| 8 | Doc Scan | 20 | 2 | 1 | Pending owner audit |
| 9 | Manager | 9 | 4 | 0 | Pending owner audit |
| 10 | Gracious Millionaire | 77 | 4 | 0 | Pending owner audit |
| 11 | Email Monitor | 14 | 2 | 0 | Pending owner audit |
| 12 | PR Messaging Dispatcher | 6 | 2 | 0 | Pending owner audit |
| 13 | Jean Wright | 9 | 2 | 0 | Pending owner audit |
| 14 | Facebook Engagement | 5 | 2 | 0 | Pending owner audit |
| 15 | Create PR | 4 | 1 | 0 | Pending owner audit |
| 16 | Dashboard | 10 | 1 | 0 | Pending owner audit |
| 17 | Sync Github | 4 | 1 | 0 | Pending owner audit |
| 18 | Home Assistant | 4 | 1 | 0 | Pending owner audit |
| 19 | REI BlackBook | 60 | 1 | 0 | Pending owner audit |
| 20 | Quickbooks | 6 | 1 | 0 | Pending owner audit |
| 21 | Computers | 5 | 1 | 0 | Pending owner audit |
| 22 | Marketplace | 13 | 1 | 0 | Pending owner audit |

## Invoice Entry Completion

- Retained in Git: `working/invoice-packet-schema.md` and `working/iteration-lessons.md`.
- Archived and removed from the current Git tree: the other 124 formerly tracked `working` files, totaling 915,522 bytes.
- Live operational root: `Office Admin/Scanned Files/Invoice Entry Working Archive/Operational Records`.
- Historical snapshot: `Legacy Git Archive/2026-09-15 Repository Retention Cleanup`.
- Verification: relative paths preserved; all 124 files verified by SHA-256; Teams `migration-manifest.json` records the source-to-archive mapping.
- Status reconciliation: the newer `work-status-OfficeAssist.md` content was promoted to canonical Teams `work-status.md`; the stale predecessor was preserved in the historical snapshot. The OfficeAssist-named file is migration evidence only.

## Completion Record

For each room, record the external destination, files retained in Git, files removed from the current tree, verification method, commit ID, push status, and any unresolved exception.
