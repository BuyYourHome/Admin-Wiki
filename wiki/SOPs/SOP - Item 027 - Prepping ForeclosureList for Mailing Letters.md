# SOP - Item 027: Prep ForeclosureList for Mailing Letters

## Purpose

Prepare the ForeclosureList workbook so eligible records are moved into the Print Envelopes batch for the next mailing.

## When To Use

Use this before printing foreclosure mailing letters.

## Owner

- Role: Marketing / Office Assistant
- Backup: Wes

## Category

Marketing

## Inputs Needed

- Local copy of `ForeclosureList.xlsm`
- Next mailing date, normally next Tuesday
- Macro-enabled workbook access

## Tools / Systems

- Excel
- ForeclosureList workbook
- Teams, for file storage

## Steps

1. Open `ForeclosureList.xlsm` from the local folder, not directly from Teams.
2. Go to the `PreForeclosure` tab.
3. Clear all filters from the Data menu.
4. Run the `SetFirstDateSent` macro.
5. Confirm the macro filtered records where:
   - First Date Sent is blank or empty
   - File Closed is blank or empty
   - Role is heir or blank
   - Mailing address line 1 is not blank
   - Mail? is not `Don't Mail`
6. Confirm the macro calculated the next Tuesday mailing date.
7. Confirm the macro set `Next Date Sent` for all visible rows.
8. If the macro fails, manually apply those filters and enter the next Tuesday date.
9. If expected records are not marked for first mailing, check whether they are spouse records, missing dependent values, or affected by an incorrect days-until-mailing value on the Macros tab.
10. Run the `BuildPrintEnvelopesBatch` macro from the `Print Envelopes` tab if available.
11. If that macro fails, manually clear filters on `Print Envelopes`.
12. Copy the formula/setup cells from columns S through W from the last existing print row to new rows below.
13. Set columns S and T to `No` on the copied setup row.
14. Set column U to the next mailing date.
15. Copy enough setup rows for the expected mailing batch.
16. Set cell V1 to the next mailing date.
17. Set cell N1 to letter number `1`.
18. Return to the `PreForeclosure` tab.
19. Clear filters.
20. Filter out blank addresses.
21. Filter `Calc Letter` to exclude `0`, `Exceeded`, and blanks.
22. Copy the green highlighted records from columns N through AE.
23. Paste those records into the first open row below the green records on the `Print Envelopes` tab.
24. Save the workbook.
25. Confirm the Print Envelopes tab contains the correct mailing batch.

## Decision Rules

- Use macros when they work; use manual fallback only when needed.
- Do not mail records marked `Don't Mail`.
- Spouse records may be correctly excluded from individual letters.

## Common Mistakes

- Opening the Teams copy instead of the local macro-enabled workbook.
- Forgetting to clear filters before running macros.
- Selecting the header row when deleting or copying rows.
- Setting the wrong mailing date.

## Source Material

- Source email: `sources/emails/RE_ Task Instructions Item 027_ Prepping ForeclosureList for Mailing Letters.msg`
- Extracted note: `sources/extracted-emails/Item 027 - Prepping ForeclosureList for Mailing Letters.md`
- Spreadsheet item: 27

## Review Notes

- Last reviewed: 2026-05-23
- Reviewed by: Codex draft
- Status: Draft - Needs Review
