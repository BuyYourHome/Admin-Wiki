# SOP - Item 092: Import File to Direct Skip

## Purpose

Upload a foreclosure contact CSV to Direct Skip, order skip tracing, and prepare the returned file for REI import.

## When To Use

Use this after the ForeclosureList export file has been prepared and downloaded.

## Owner

- Role: Lead Sourcing / Office Assistant
- Backup: Wes

## Category

Lead Sourcing

## Inputs Needed

- CSV file exported from ForeclosureList
- Access to Direct Skip
- Approved payment method for add-ons
- Email address to receive order completion notices

## Tools / Systems

- Direct Skip
- Excel
- Teams `_Letters/Direct Skip` folder

## Steps

1. Download the imported CSV file from the Direct Skip folder or the current export location.
2. Log in to Direct Skip using approved saved credentials.
3. Go to Your Files / Step 1.
4. Upload the CSV file.
5. Check the box indicating the file has a header row.
6. Add the internal email address that should receive the completed-order notice.
7. Save the Step 1 settings.
8. In Step 2, fill in the new order fields.
9. Map custom fields for County, Complete File Num, and Status.
10. In Step 3, review entries and confirm columns are correct.
11. If entries are wrong, restart the upload rather than ordering a bad file.
12. If entries are correct, save and continue.
13. On the order summary/add-ons page, select DNC/Litigator Scrub when required.
14. Confirm payment method and purchase the order.
15. Wait for the completed skip trace email.
16. Return to Your Files and download the completed file when the download button appears.
17. Open the completed file in Excel.
18. Delete columns AJ through JG so the file is small enough for REI to handle.
19. Save the edited file as `Direct skip - edited - imported yy-mm-dd.csv`.
20. Save the edited file to the Letters > Direct Skip folder.
21. Continue with Item 093 to import the edited Direct Skip file into REI.

## Decision Rules

- Do not place passwords in this SOP; use approved credential storage.
- Restart the order if the review screen shows bad mapping or incorrect data.
- Include DNC/Litigator Scrub when the campaign requires compliance screening.

## Common Mistakes

- Forgetting to check the header-row box.
- Missing custom fields needed later in REI.
- Uploading the unedited returned file to REI with too many columns.

## Source Material

- Source email: `Project Rooms/SOPs/sources/emails/Task Instructions Item 092_ Import to Direct Skip.msg`
- Extracted note: `Project Rooms/SOPs/sources/extracted-emails/Item 092 - Import to Direct Skip.md`
- Spreadsheet item: 92

## Review Notes

- Last reviewed: 2026-05-23
- Reviewed by: Codex draft
- Status: Draft - Needs Review
