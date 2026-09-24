# SOP - Item 024: Validate Test Text and Email Campaigns in REI Blackbook

**Sequence navigation:** Previous: [[SOP - Item 022 - Import ForeclosureList to REI|← SOP 022]] | Next: [[SOP - Item 025 - Respond to remove request in REI|SOP 025 →]]

## Purpose

Review contacts in the test foreclosure text and email campaigns, resolve delivery errors, and tag failed contacts correctly.

## When To Use

Use this after contacts have been added to the test foreclosure text and email campaigns in REI Blackbook.

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
19. Immediately after completing the text-campaign validation, click Emails for the contact.
20. Confirm the contact is enrolled in the correct email campaign.
21. Check the email activity for delivery errors, bounces, or an inactive campaign.
22. If the email campaign is active and shows no delivery error, consider the email campaign validated.
23. If an email error appears, verify the current email address against an available source.
24. Replace the address only when another verified email address is available, then recheck the campaign.
25. If no valid email address is available, do not guess or keep retrying. Record or tag the email failure using the established REI campaign convention.
26. Repeat the email-campaign validation for each contact in the `Test Foreclosure` list.

## Decision Rules

- Do not text contacts marked DNC or otherwise legally restricted.
- Do not email contacts who have unsubscribed or requested removal.
- Use additional numbers only when the source indicates they are valid and usable.
- Use replacement email addresses only when they are verified by an available source.
- Failed contacts should be tagged clearly so they do not continue in the same workflow.

## Common Mistakes

- Removing test tags before verifying delivery status.
- Retrying the same failed phone number.
- Forgetting to add `Foreclosure_Fail` when no valid number remains.
- Completing the text validation but skipping the email-campaign check.

## Source Material

- Source email: `Project Rooms/SOPs/sources/emails/Task Instructions Item 024_ Validate Test Text Campaign.msg`
- Extracted note: `Project Rooms/SOPs/sources/extracted-emails/Item 024 - Validate Test Text Campaign.md`
- Spreadsheet item: 24
- Wes instruction dated 2026-09-24: validate the email campaign immediately after validating the text campaign.

## Review Notes

- Last reviewed: 2026-05-23
- Reviewed by: Codex draft
- Status: Draft - Needs Review

---

**Sequence navigation:** Previous: [[SOP - Item 022 - Import ForeclosureList to REI|← SOP 022]] | Next: [[SOP - Item 025 - Respond to remove request in REI|SOP 025 →]]
