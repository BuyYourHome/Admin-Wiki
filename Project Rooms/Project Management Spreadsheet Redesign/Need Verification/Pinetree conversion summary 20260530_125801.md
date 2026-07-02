# Pinetree Conversion Summary

Output workbook: `C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Redesign\Need Verification\17_Project Management - 3413 Pinetree Ln - converted 20260530_125801.xlsm`

## Migration Completed

- Used the Pond St workbook as the working template and kept the output inside `Need Verification`.
- Migrated Pinetree `Profit`, `MOG`, `Contact`, `Seller Advance`, direct expense tabs, and ProposalUpdate rows into the Pond-style `Contract` table.
- Cleared Pond sample Carrying rows and added one non-included review marker row because Pinetree has no dedicated Carrying source tab.
- Copied Pinetree `MISC 2` into `MISC 2 Review` because the Pond template has no exact `MISC` destination tab.

## Key Reconciliation Inputs

- Source CMA: 287000
- Source address: 3413 Pinetree Ln, Greenville, NC 27858
- Source rehab: 5676.264
- Source buying closing cost: 5998
- Source selling closing cost: 290
- Source Gantt grand total: 5160.24

## Formula Scan

The Pond template has pre-existing formula references that scan as errors in query/Gantt areas. Untouched template scan: 5145 formula-error matches. Converted output scan: 5139 formula-error matches. No new net increase was detected in the converted copy.

## Review Caveats

- Carrying detail could not be rebuilt from dated rows because the Pinetree source workbook does not contain a Carrying tab or dated carrying ledger.
- The output is review-ready in `Need Verification`; it should not be moved to Teams until Wes reviews the Carrying treatment and `MISC 2 Review` placement.
