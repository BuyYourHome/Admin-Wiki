# SOP - Item 022: Prepare ForeclosureList Export and Import New Records to REI

## Purpose

Export new ForeclosureList records, create the CSV used for skip tracing and REI import, and begin the REI Blackbook import process.

## When To Use

Use this after new foreclosure records have been entered into the ForeclosureList and need to be imported into REI or sent to Direct Skip.

## Owner

- Role: Lead Sourcing / Office Assistant
- Backup: Wes

## Category

Lead Sourcing

## Inputs Needed

- ForeclosureList workbook
- New records with blank Imported column
- Access to Teams
- Access to REI Blackbook
- Today's date

## Tools / Systems

- Microsoft Teams
- Excel
- ForeclosureList workbook
- REI Blackbook

## Steps

1. Open Teams and go to All Properties > Files.
2. Open `ForeclosureList.xlsx` or the current ForeclosureList workbook in the desktop Excel app.
3. Clear existing filters.
4. Find the first blank cell in column B, `Imported`.
5. Filter column B by blank values to show records not yet exported.
6. Filter the address column to exclude blank addresses.
7. Confirm the visible rows are the records to export.
8. Enter today's date into column B for all visible exported records.
9. Save the workbook.
10. Save a copy in the `_Letters/Exported` folder with a name like `ForeclosureList - imported yy-mm-dd.xlsm`.
11. In the copied workbook, clear filters.
12. Filter column B for records that do not equal today's date.
13. Delete visible rows that are not part of today's import, leaving the header row intact.
14. Clear filters and confirm only today's imported records remain.
15. Save the copied workbook.
16. Save another copy in CSV UTF-8 format using the same base name and location.
17. Close the spreadsheet.
18. In Teams, confirm the new CSV is the newest file in the Exported folder.
19. Download the CSV if needed for REI Blackbook or Direct Skip.
20. If importing manually to REI, open REI Blackbook and go to Contacts.
21. Click Add Contact and choose Import Contact.
22. Choose the CSV file and upload it.
23. Match spreadsheet columns to REI fields.
24. Run the import.
25. Confirm the new contacts appear in REI and have today's import tag.
26. Continue with Item 092 if the next step is Direct Skip.

## Decision Rules

- Do not delete the header row when removing non-import records.
- Only records with an address should be exported.
- Save both the working Excel copy and the CSV export.

## Common Mistakes

- Editing the master workbook instead of the export copy.
- Leaving old records in the CSV.
- Forgetting to mark today's imported rows before saving.

## Source Material

- Source email: `Project Rooms/SOPs/sources/emails/Task Instructions Item 022_ Prepare ForeclosureList for Direct Skip.msg`
- Extracted note: `Project Rooms/SOPs/sources/extracted-emails/Item 022 - Import ForeclosureList to REI.md`
- Spreadsheet item: 22

## Review Notes

- Last reviewed: 2026-05-23
- Reviewed by: Codex draft
- Status: Draft - Needs Review
