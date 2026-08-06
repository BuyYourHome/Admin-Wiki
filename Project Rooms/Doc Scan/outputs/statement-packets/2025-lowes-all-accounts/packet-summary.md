# 2025 Lowe's Statement Packet Summary

- Dispatch ID: `jean-dispatch-20260804-lowes-statements-2025-v1-docscan-intake`
- Packet root: `C:\Codex\Wiki Files\Project Rooms\Doc Scan\outputs\statement-packets\2025-lowes-all-accounts`
- Statement packets: 18
- Extracted OCR rows: 86
- Tensity-supported rows: 8

## Coverage

- BYH 5997: May-Dec 2025 present; Jan-Apr missing.
- SYH 6140: Mar-Dec 2025 present; Jan-Feb missing.
- Source PDFs remain in the original Teams/SharePoint-synced statement folders.

## Packets

| Account | Period | Rows | Tensity rows | Packet |
| --- | --- | ---: | ---: | --- |
| BYH-5997 | 2025-05-17 | 6 | 6 | `C:\Codex\Wiki Files\Project Rooms\Doc Scan\outputs\statement-packets\2025-lowes-all-accounts\BYH-5997-2025-05-17-packet.json` |
| BYH-5997 | 2025-06-17 | 6 | 0 | `C:\Codex\Wiki Files\Project Rooms\Doc Scan\outputs\statement-packets\2025-lowes-all-accounts\BYH-5997-2025-06-17-packet.json` |
| BYH-5997 | 2025-07-17 | 2 | 2 | `C:\Codex\Wiki Files\Project Rooms\Doc Scan\outputs\statement-packets\2025-lowes-all-accounts\BYH-5997-2025-07-17-packet.json` |
| BYH-5997 | 2025-08-17 | 0 | 0 | `C:\Codex\Wiki Files\Project Rooms\Doc Scan\outputs\statement-packets\2025-lowes-all-accounts\BYH-5997-2025-08-17-packet.json` |
| BYH-5997 | 2025-09-17 | 0 | 0 | `C:\Codex\Wiki Files\Project Rooms\Doc Scan\outputs\statement-packets\2025-lowes-all-accounts\BYH-5997-2025-09-17-packet.json` |
| BYH-5997 | 2025-10-17 | 0 | 0 | `C:\Codex\Wiki Files\Project Rooms\Doc Scan\outputs\statement-packets\2025-lowes-all-accounts\BYH-5997-2025-10-17-packet.json` |
| BYH-5997 | 2025-11-17 | 4 | 0 | `C:\Codex\Wiki Files\Project Rooms\Doc Scan\outputs\statement-packets\2025-lowes-all-accounts\BYH-5997-2025-11-17-packet.json` |
| BYH-5997 | 2025-12-17 | 7 | 0 | `C:\Codex\Wiki Files\Project Rooms\Doc Scan\outputs\statement-packets\2025-lowes-all-accounts\BYH-5997-2025-12-17-packet.json` |
| SYH-6140 | 2025-03-02 | 1 | 0 | `C:\Codex\Wiki Files\Project Rooms\Doc Scan\outputs\statement-packets\2025-lowes-all-accounts\SYH-6140-2025-03-02-packet.json` |
| SYH-6140 | 2025-04-02 | 1 | 0 | `C:\Codex\Wiki Files\Project Rooms\Doc Scan\outputs\statement-packets\2025-lowes-all-accounts\SYH-6140-2025-04-02-packet.json` |
| SYH-6140 | 2025-05-02 | 1 | 0 | `C:\Codex\Wiki Files\Project Rooms\Doc Scan\outputs\statement-packets\2025-lowes-all-accounts\SYH-6140-2025-05-02-packet.json` |
| SYH-6140 | 2025-06-02 | 2 | 0 | `C:\Codex\Wiki Files\Project Rooms\Doc Scan\outputs\statement-packets\2025-lowes-all-accounts\SYH-6140-2025-06-02-packet.json` |
| SYH-6140 | 2025-07-02 | 0 | 0 | `C:\Codex\Wiki Files\Project Rooms\Doc Scan\outputs\statement-packets\2025-lowes-all-accounts\SYH-6140-2025-07-02-packet.json` |
| SYH-6140 | 2025-08-02 | 14 | 0 | `C:\Codex\Wiki Files\Project Rooms\Doc Scan\outputs\statement-packets\2025-lowes-all-accounts\SYH-6140-2025-08-02-packet.json` |
| SYH-6140 | 2025-09-02 | 28 | 0 | `C:\Codex\Wiki Files\Project Rooms\Doc Scan\outputs\statement-packets\2025-lowes-all-accounts\SYH-6140-2025-09-02-packet.json` |
| SYH-6140 | 2025-10-02 | 10 | 0 | `C:\Codex\Wiki Files\Project Rooms\Doc Scan\outputs\statement-packets\2025-lowes-all-accounts\SYH-6140-2025-10-02-packet.json` |
| SYH-6140 | 2025-11-02 | 2 | 0 | `C:\Codex\Wiki Files\Project Rooms\Doc Scan\outputs\statement-packets\2025-lowes-all-accounts\SYH-6140-2025-11-02-packet.json` |
| SYH-6140 | 2025-12-02 | 2 | 0 | `C:\Codex\Wiki Files\Project Rooms\Doc Scan\outputs\statement-packets\2025-lowes-all-accounts\SYH-6140-2025-12-02-packet.json` |

## Blockers And Limits

- All source PDFs are image-only; rows were extracted with Windows OCR and must be verified by Invoice Entry before workbook insertion.
- Item boundaries and item-level amounts are marked review-needed where OCR did not prove a clean row/amount match.
- Doc Scan did not modify any project-management workbook, send email, make payments, or create duplicate source PDFs.
- BYH-5997 2025-08-17: no invoice blocks extracted from OCR
- BYH-5997 2025-09-17: no invoice blocks extracted from OCR
- BYH-5997 2025-10-17: no invoice blocks extracted from OCR
- SYH-6140 2025-07-02: no invoice blocks extracted from OCR

## Correction

- 2026-08-04: Invoice Entry visually verified BYH-5997 2025-05-17 page 3 and BYH-5997 2025-07-17 page 3, then returned a correction before workbook action. Doc Scan corrected five PO-4121 invoice blocks into eight nonzero item-level rows, preserved invoice/date/PO/source-page evidence, marked invoice 74794 as handwritten/corrected PO 4121 evidence, and excluded tax-only amounts from item rows.
- 2026-08-04: Added visible store numbers and `item_number_sku` values to the eight corrected PO-4121 rows without changing the verified item amounts or PO evidence.
