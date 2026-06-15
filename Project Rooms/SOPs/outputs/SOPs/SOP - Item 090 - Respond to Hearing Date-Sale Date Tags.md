# SOP - Item 090: Respond to Hearing Date and Sale Date Tags

## Purpose

Review foreclosure contacts whose hearing date or sale date status changed and update REI and the ForeclosureList accordingly.

## When To Use

Use this at least weekly and when REI sends date-flag emails.

## Owner

- Role: Lead Sourcing / Office Assistant
- Backup: Wes

## Category

Lead Sourcing

## Inputs Needed

- Contact with date flag email or tag
- Complete file number
- Access to court portal
- Access to REI
- Access to ForeclosureList

## Tools / Systems

- REI Blackbook
- `_Set Date Flags` workflow
- North Carolina court portal
- ForeclosureList workbook

## Steps

1. At least once per week, review the `_Set Date Flags` workflow in REI.
2. Confirm the workflow is running daily on active contacts.
3. Update the date filters in the workflow branches for the current date.
4. Review contacts with date-related tags:
   - No Hearing Date
   - Hearing Date Set
   - Hearing Date has Past
   - Sale Date
5. Use the saved filter for contacts with hearing date but no sale date when sale date tags are missing.
6. For each flagged contact, copy the complete file number.
7. Search the file in the court portal.
8. Determine the current case status.
9. If the case has been dismissed, set all associated REI records to delete and set the ForeclosureList Status column to `CS` for all associated records.
10. If the hearing has been continued, look for a GAL report in the portal.
11. If a GAL report exists, add a `GAL` tag to the REI record and flag for Wes review.
12. Enter the new hearing date in all associated records.
13. If the foreclosure was allowed and a sale date was established, find the sale date in the portal documents.
14. Enter the sale date in all associated CRM records.
15. Confirm the ForeclosureList and REI record agree before moving to the next contact.

## Decision Rules

- Dismissed cases should be set to delete and marked `CS` in the ForeclosureList.
- Continued hearings require date updates, not deletion.
- GAL reports should be tagged for Wes evaluation.
- Sale dates must come from the court portal documents.

## Common Mistakes

- Updating only one associated record when multiple related contacts exist.
- Forgetting to update the workflow date filters weekly.
- Missing sale dates after a hearing date has passed.

## Source Material

- Source email: `Project Rooms/SOPs/sources/emails/Re_ Task Instructions Item 90_Respond to Hearing Date_Sale Date Tags.msg`
- Extracted note: `Project Rooms/SOPs/sources/extracted-emails/Item 090 - Respond to Hearing Date-Sale Date Tags.md`
- Spreadsheet item: 90

## Review Notes

- Last reviewed: 2026-05-23
- Reviewed by: Codex draft
- Status: Draft - Needs Review
