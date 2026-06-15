# SOP - Item 024: Validate Test Text Campaign in REI Blackbook

## Purpose

Review contacts in the test foreclosure text campaign, resolve delivery errors, and tag failed contacts correctly.

## When To Use

Use this after contacts have been added to a test foreclosure text campaign in REI Blackbook.

## Owner

- Role: Lead Sourcing / Office Assistant
- Backup: Wes

## Category

Lead Sourcing

## Inputs Needed

- REI Blackbook access
- Contacts tagged for test foreclosure campaign
- BeenVerified access when additional phone numbers are needed

## Tools / Systems

- REI Blackbook
- BeenVerified

## Steps

1. Open REI Blackbook and log in.
2. Go to Contacts.
3. Open saved filters/search and choose `Test Foreclosure`.
4. Open the first contact in the list.
5. Click Texts in the middle of the page.
6. Check whether the text shows delivery errors.
7. If there are no errors, remove the `Foreclosure TEST` tag.
8. Confirm removal when prompted.
9. Move to the next contact.
10. If there is an error and the contact has another untried phone number, remove the `TEXT 1` tag.
11. Edit the contact primary details.
12. Select the next untried phone number from the phone dropdown.
13. Change the contact from Opted Out to Opt In, following REI's confirmation prompts.
14. Move to the next contact and repeat testing.
15. If there are errors and no untried numbers remain, check BeenVerified for additional phone numbers or emails.
16. Remove the `Foreclosure TEST` tag.
17. Remove the `Foreclosure TEXT 1` tag.
18. Add the `Foreclosure_Fail` tag.

## Decision Rules

- Do not text contacts marked DNC or otherwise legally restricted.
- Use additional numbers only when the source indicates they are valid and usable.
- Failed contacts should be tagged clearly so they do not continue in the same workflow.

## Common Mistakes

- Removing test tags before verifying delivery status.
- Retrying the same failed phone number.
- Forgetting to add `Foreclosure_Fail` when no valid number remains.

## Source Material

- Source email: `Project Rooms/SOPs/sources/emails/Task Instructions Item 024_ Validate Test Text Campaign.msg`
- Extracted note: `Project Rooms/SOPs/sources/extracted-emails/Item 024 - Validate Test Text Campaign.md`
- Spreadsheet item: 24

## Review Notes

- Last reviewed: 2026-05-23
- Reviewed by: Codex draft
- Status: Draft - Needs Review
