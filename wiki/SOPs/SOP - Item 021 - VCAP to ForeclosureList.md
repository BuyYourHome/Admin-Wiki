# SOP - Item 021: VCAP to ForeclosureList

## Purpose

Find new foreclosure case records in VCAP, collect required property and hearing information, and enter them into the ForeclosureList spreadsheet.

## When To Use

Use this when adding new foreclosure records by county and file number into the ForeclosureList.

## Owner

- Role: Lead Sourcing / Office Assistant
- Backup: Wes

## Category

Lead Sourcing

## Inputs Needed

- Current county and next file number
- Access to VCAP
- ForeclosureList spreadsheet in Teams
- County tax record websites
- BeenVerified
- Zillow

## Tools / Systems

- VCAP
- Microsoft Teams
- ForeclosureList spreadsheet
- County tax records
- BeenVerified
- Zillow

## Steps

1. Open VCAP.
2. Open the ForeclosureList spreadsheet from Teams.
3. Open the county tax record website for the county being searched.
4. Open BeenVerified and Zillow for cross-checking information.
5. In VCAP, navigate to the foreclosure case search area using the current VCAP procedure and saved credentials.
6. Enter the next file number for the county.
7. Continue increasing file numbers until a file shows `PETN FORE`.
8. For each foreclosure record, enter the county, file number, today's date, and owner name into the ForeclosureList.
9. Use county tax records to find the property address and owner mailing address.
10. Enter both addresses into the ForeclosureList, using the mailing address when it differs from the property address.
11. In VCAP, locate the hearing date by navigating to the calendar/date screen for the case.
12. Enter the hearing date into the ForeclosureList.
13. Return to the VCAP file-number screen and continue to the next file number.
14. When changing counties, return to county selection, select the new county, and continue from the next known file number for that county.
15. When VCAP reaches red text or appears to run past available records, check a few more file numbers.
16. Mark the stopping point as `Last Record` in the spreadsheet.
17. Save the ForeclosureList.

## Decision Rules

- Only add records that are foreclosure petitions or match the current foreclosure criteria.
- Treat `Last Record` as the next starting point for the county.
- Verify addresses from county tax records before relying on BeenVerified or Zillow.

## Common Mistakes

- Entering the property address where the mailing address belongs.
- Forgetting to update the hearing date.
- Continuing past the real last record without marking the stopping point.

## Source Material

- Source email: `sources/emails/RE_ Task Instructions Item 021_ VCAP to Foreclosure List.msg`
- Extracted note: `sources/extracted-emails/Item 021 - VCAP to ForeclosureList.md`
- Spreadsheet item: 21

## Review Notes

- Last reviewed: 2026-05-23
- Reviewed by: Codex draft
- Status: Draft - Needs Review
