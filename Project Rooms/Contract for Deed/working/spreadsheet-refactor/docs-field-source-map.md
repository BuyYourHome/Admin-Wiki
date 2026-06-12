# CFD Docs Field Source Map

Workbook copy:

`C:\Codex\Wiki Files\Project Rooms\Contract for Deed\working\spreadsheet-refactor\28_Project Management - 320 Rose Pl - CFD REFACTOR WORKING COPY.xlsm`

Purpose: remove CFD dependency on the legacy horizontal `Docs` row 1 / row 2 field table.

## Current Rule

CFD reads the vertical `Docs` field list:

- field label: column `A`
- field value or formula: column `B`
- multi-value rows, currently `Adverse Conditions`, may use additional cells on the same row

CFD no longer needs the horizontal `Docs` row 1 / row 2 field table.

## Test Result

Test workbook:

`C:\Codex\Wiki Files\Project Rooms\Contract for Deed\working\spreadsheet-refactor\28_Project Management - 320 Rose Pl - CFD ROWS 1-2 DELETED TEST.xlsm`

Rows 1-2 were deleted from `Docs` using Excel automation and recalculated. The normalized CFD values matched the original refactor copy with no differences for the active document fields.

## Field Map

| CFD value | Vertical Docs source | Upstream source |
| --- | --- | --- |
| Buyer 1 | `Docs!B8` / `Selling-Buyer1` | direct value |
| Buyer 2 | `Docs!B9` / `Selling-Buyer2` | direct value |
| Buyer address | `Docs!B10` / `Selling-Buyer Add1` | direct value |
| Seller entity | `Docs!B12` / `Selling -Seller` | direct value |
| Purchase price | `Docs!B13` / `Selling Purchase Price:` | `Amortization!AA4` |
| Earnest money | `Docs!B14` / `Selling Earnest Money:` | `Amortization!K2` |
| Down payment | `Docs!B15` / `Selling Down Payment:` | `Amortization!O4` |
| Loan amount | `Docs!B16` / `Loan Amount:` | `Amortization!O5` |
| Monthly payment | `Docs!B17` / `Monthly Payment1` | `SUM(Docs!B18:B18)` |
| Principal/interest | `Docs!B18` / `Principal&Interst:` | `Amortization!Z9` |
| Term years | `Docs!B21` / `TermYears` | `Amortization!O9` |
| Term months | `Docs!B22` / `TermMonths1` | `Docs!B21 * 12` |
| Loan start | `Docs!B24` / `Loan Start1` | `Amortization!O11` |
| Loan end | `Docs!B25` / `Loan End1` | `Amortization!Q11` |
| Adverse conditions | `Docs!B28:D28` / `Adverse Conditions` | direct row values |
| Interest rate | `Docs!B53` / `Interest rate1` | `TEXT(Amortization!AA9, "0.000%")` |
| Property address | `Docs!B68` / `Address` | `Profit!B2` |
| Property city/state/ZIP | `Docs!B69` / `City-State` | `Profit!E2` |
| County | `Docs!B70` / `County` | direct value |
| Tax escrow | `Docs!B72` / `Tax Escrow:` | `Amortization!T10` |
| Property insurance | `Docs!B73` / `Property Insurance:` | `Amortization!T9` |
| Brief legal description | `Docs!B76` / `Brief Legal Description` | direct value |
| Legal description | `Docs!B77` / `Legal Description` | direct value |
| Parcel ID | `Docs!B78` / `Property Parcel ID` | direct value |
| Trustee | `Docs!B86` / `Trustee` | direct value |
| Trustee address 1 | `Docs!B87` / `Trustee Address1:` | direct value |
| Trustee address 2 | `Docs!B88` / `Trustee Address2:` | direct value |
| Trust name | `Docs!B89` / `Trust` | combines `Docs!B68`, `Docs!B90`, and `Docs!B91` |
| Manager | `Docs!B92` / `Manger` | direct value |
| Document year | `Docs!B93` / `Doc Year` | `YEAR(NOW())` |
| Document month | `Docs!B94` / `Doc Month:` | `MONTH(NOW())` |

