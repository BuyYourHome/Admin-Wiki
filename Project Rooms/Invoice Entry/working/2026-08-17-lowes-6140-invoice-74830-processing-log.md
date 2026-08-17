# Lowe's SYH 6140 Invoice 74830 Processing Log

## Intake

- Dispatch id: `doc-scan-heartbeat-20260817-195112-lowes-statement-allocation`.
- Packet: `C:\Codex\Wiki Files\Project Rooms\Doc Scan\outputs\statement-packets\2026-lowes-scan-20260817\SYH-6140-2026-08-02-scanned-packet.json`.
- Source scan: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files\Archived\Receipt_2026-08-17_154629.pdf`.
- Account: Lowe's Pro SYH ending `6140`; statement close `2026-08-02`; invoice `74830`; store `907`; transaction/post date `2026-07-31`.
- Four source-supported non-tax item rows total `$111.79`; tax `$8.10` is retained in notes and excluded from item rows; invoice total is `$119.89`.

## Duplicate Review

- Searched Invoice Entry and Doc Scan statement-packet records for invoice `74830`, the statement/account identity, and all four canonical row IDs.
- Matches were confined to this new Doc Scan packet and its summary/handoff files.
- No prior Invoice Entry packet, held-detail row, Review insertion record, or processed-row record was found for invoice `74830` or the four canonical row IDs.
- Authoritative workbook duplicate checks were not attempted because the evidence does not identify one safe target workbook. No workbook was opened or changed.

## Project Conflict

- Printed Lowe's P.O. `4121` supports `24-HM - 4121 Tensity Dr`.
- Handwritten `908 Pond` supports `26-BYH - 908 Pond St`.
- Neither clue may be discarded or preferred without authoritative allocation evidence. The four rows remain held outside both project workbooks with blank destination worksheet.
- Lowe's pages 1 of 3 and 2 of 3 are present, but page 3 of 3 is missing. This does not alter the four extracted item amounts, but the scan is not complete statement coverage.

## Outcome

Status: `Needs Wes - Project Conflict; No Workbook Action`.

Wes must identify whether invoice `74830` belongs to `908 Pond St` or `4121 Tensity Dr`, or provide another authoritative allocation. After that decision, Invoice Entry can retrieve the fresh exact workbook, run workbook-level duplicate checks, and place the four rows in `Review`. No approval, payment, email, filing, or vendor contact occurred.
