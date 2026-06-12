# CFD Docs Field Source Map

Workbook copy:

`C:\Codex\Wiki Files\Project Rooms\Contract for Deed\working\spreadsheet-refactor\28_Project Management - 320 Rose Pl - CFD REFACTOR WORKING COPY.xlsm`

Purpose: remove CFD dependency on the legacy horizontal `Docs` row 1 / row 2 field table.

## Current Rule

CFD reads recognized `Docs` label/value pairs wherever they appear in grouped blocks on `Docs`:

- field label: any cell containing a recognized CFD label
- field value or formula: the cell immediately to the right of the label
- section 9 adverse conditions use separate label/value pairs: `Adverse Conditions1`, `Adverse Conditions2`, and `Adverse Conditions3`

CFD no longer needs the horizontal `Docs` row 1 / row 2 field table.

## Test Result

Test workbook:

`C:\Codex\Wiki Files\Project Rooms\Contract for Deed\working\spreadsheet-refactor\28_Project Management - 320 Rose Pl - CFD ROWS 1-2 DELETED TEST.xlsm`

Rows 1-2 were deleted from `Docs` using Excel automation and recalculated. The normalized CFD values matched the original refactor copy with no differences for the active document fields.

## Field Map

| CFD value | Recognized Docs label | Upstream source |
| --- | --- | --- |
| Buyer 1 | `Selling-Buyer1` | direct value |
| Buyer 2 | `Selling-Buyer2` | direct value |
| Buyer address | repeated `Selling-Buyer Add1` rows | direct value |
| Seller entity | `Selling -Seller` | direct value |
| Purchase price | `Selling Purchase Price:` | `Amortization!AA4` |
| Earnest money | `Selling Earnest Money:` | `Amortization!K2` |
| Down payment | `Selling Down Payment:` | `Amortization!O4` |
| Loan amount | `Loan Amount:` | `Amortization!O5` |
| Monthly payment | `Monthly Payment1` | `Principal&Interst:` plus escrow/insurance values in generator |
| Principal/interest | `Principal&Interst:` | `Amortization!Z9` |
| Term years | `TermYears` | `Amortization!O9` |
| Term months | `TermMonths1` | term years label value multiplied by 12 |
| Loan start | `Loan Start1` | `Amortization!O11` |
| Loan end | `Loan End1` | `Amortization!Q11` |
| Adverse conditions | `Adverse Conditions1`, `Adverse Conditions2`, `Adverse Conditions3` | direct values combined in label order |
| Interest rate | `Interest rate1` | `TEXT(Amortization!AA9, "0.000%")` |
| Property address | `Address` | `Profit!B2` |
| Property city/state/ZIP | `City-State` | `Profit!E2` |
| County | `County` | direct value |
| Tax escrow | `Tax Escrow:` | `Amortization!T10` |
| Property insurance | `Property Insurance:` | `Amortization!T9` |
| Brief legal description | `Brief Legal Description` | direct value |
| Legal description | `Legal Description` | direct value |
| Parcel ID | `Property Parcel ID` | direct value |
| Trustee | `Trustee` | direct value |
| Trustee address 1 | `Trustee Address1:` | direct value |
| Trustee address 2 | `Trustee Address2:` | direct value |
| Trust name | `Trust` | combines property address, document month, and document year labels |
| Manager | `Manger` or `Manager` | direct value |
| Document year | `Doc Year` | `YEAR(NOW())` |
| Document month | `Doc Month:` | `MONTH(NOW())` |
