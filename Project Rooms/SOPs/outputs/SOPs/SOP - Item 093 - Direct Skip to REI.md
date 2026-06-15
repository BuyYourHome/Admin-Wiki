# SOP - Item 093: Import Direct Skip Results to REI

## Purpose

Import edited Direct Skip results into REI Blackbook and start appropriate communication campaigns for each contact.

## When To Use

Use this after Item 092 creates the edited Direct Skip CSV file.

## Owner

- Role: Lead Sourcing / Office Assistant
- Backup: Wes

## Category

Lead Sourcing

## Inputs Needed

- Edited Direct Skip CSV
- REI Blackbook access
- Contact field mapping list
- DNC status from Direct Skip

## Tools / Systems

- REI Blackbook
- Edited Direct Skip CSV

## Steps

1. Open REI Blackbook.
2. Go to Contacts.
3. Click Add Contact.
4. Choose Import Contact.
5. Choose the edited Direct Skip CSV file.
6. Upload the CSV.
7. Map CSV columns to REI fields.
8. Use these expected mappings:
   - Property Address to Input Property Address
   - Property City to Input Property City
   - Property State to Input Property State
   - Property Zip to Input Property Zip
   - County to Custom Field 1
   - Mailing Address to Input Mailing Address
   - Mailing City to Input Mailing City
   - Mailing State to Input Mailing State
   - Mailing Zip to Input Mailing Zip
   - Status to Custom Field 3
   - Complete File Num to Custom Field 2
   - First Name to Input First Name
   - Last Name to Input Last Name
   - Phone fields to Phone 1 through Phone 4
   - Email fields to Email 1 and Email 2
   - Age, Deceased, and DNC/Litigator Scrub to their matching fields if available
9. Run the import.
10. Click Go To Contacts to view imported contacts.
11. Open the first imported contact.
12. If Status is `P`, add the `Priority` tag.
13. If Deceased is `Y`, add the `Deceased` tag.
14. Edit the contact profile.
15. Add the property to the contact or connect the contact to the existing property.
16. If Do Not Call is No, opt the contact in for text following REI's confirmation prompts.
17. If Do Not Call is DNC, leave the contact opted out and do not text the contact.
18. Start the email campaign if appropriate.
19. Start the text campaign if appropriate and legally allowed.
20. Save the profile.
21. Remove the `Imported` tag after setup is complete.
22. Move to the next imported contact and repeat.

## Decision Rules

- Do not text DNC contacts.
- Connect contacts to the existing property when another owner/contact already has the property record.
- Priority and deceased statuses must be tagged before moving on.

## Common Mistakes

- Mapping custom fields incorrectly.
- Texting DNC contacts.
- Creating duplicate property records instead of linking to an existing property.

## Source Material

- Source email: `Project Rooms/SOPs/sources/emails/RE_ Task Instructions Item 093_ Direct Skip to REI.msg`
- Extracted note: `Project Rooms/SOPs/sources/extracted-emails/Item 093 - Direct Skip to REI.md`
- Spreadsheet item: 93

## Review Notes

- Last reviewed: 2026-05-23
- Reviewed by: Codex draft
- Status: Draft - Needs Review
