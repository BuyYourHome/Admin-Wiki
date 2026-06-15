# SOP - Item 026: Export Closed Contacts from REI to ForeclosureList

## Purpose

Export closed contacts from REI Blackbook so the ForeclosureList can mark matching records as Do Not Mail.

## When To Use

Use this before preparing mailing letters so closed contacts are excluded from mail campaigns.

## Owner

- Role: Lead Sourcing / Office Assistant
- Backup: Wes

## Category

Lead Sourcing

## Inputs Needed

- REI Blackbook access
- Saved filter named `Export`
- Access to Teams Properties folder
- Current ForeclosureList workbook

## Tools / Systems

- REI Blackbook
- Microsoft Teams
- Excel

## Steps

1. In REI Blackbook, go to Contacts.
2. Apply the `Export` filter.
3. Select all visible contacts using the checkbox next to the Name column.
4. If REI offers a link to select all matching items, click it.
5. Open Actions and choose Export Contacts.
6. In the export options, use Filter by Contact Tab and select the Details tab.
7. Select all Details fields. Confirm that 26 fields are selected.
8. Click Export and Download CSV.
9. Click Download File.
10. Locate the downloaded file.
11. Rename it `Foreclosure-Closed.csv`.
12. Move it to the Teams Properties folder, replacing the existing file when appropriate.
13. Open ForeclosureList while `Foreclosure-Closed.csv` is available.
14. Confirm the ForeclosureList reads the closed contacts and sets the Mail? column to `Don't Mail` for matching records.
15. Continue with Item 027 to prepare the ForeclosureList for mailing letters.

## Decision Rules

- Only export the Details fields; do not mix fields from other tabs.
- Confirm all 26 Details fields are selected before downloading.
- Replace the existing `Foreclosure-Closed.csv` only when the new export is correct.

## Common Mistakes

- Exporting only the visible page instead of all filtered contacts.
- Selecting the wrong field group.
- Forgetting to rename the file before moving it to Teams.

## Source Material

- Source email: `Project Rooms/SOPs/sources/emails/RE_ Task Instructions Item 026_ Exporting Closed Contacts from REI to ForeclosureList.msg`
- Extracted note: `Project Rooms/SOPs/sources/extracted-emails/Item 026 - Exporting Closed Contacts from REI to ForeclosureList.md`
- Spreadsheet item: 26

## Review Notes

- Last reviewed: 2026-05-23
- Reviewed by: Codex draft
- Status: Draft - Needs Review
