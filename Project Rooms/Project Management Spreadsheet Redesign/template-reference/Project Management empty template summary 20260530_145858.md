# Empty Project Management Template From Pond

Output workbook: `C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Redesign\template-reference\Project Management - empty template from Pond 20260530_145858.xlsm`

Created by copying the Pond macro workbook package and clearing project-specific constants from known input/data/table body areas while preserving formulas, formatting, table parts, query/external-data parts, relationships, and VBA.

## Package Checks

- parts: 255
- tables: 17
- external_query_like: 7
- vba: True

## Cell Checks

- Profit!B2: `None`
- Profit!B4: `None`
- Profit!B6: `=IF(B1="Flip",B4,IF(C1="hold",B4*(1+C5),+Amortization!O3))`
- Profit!F15: `=IF(OR($R$3=1,$R$3=2,$R$3=3),IF(OR($R$3=1,$R$3=2),-C15,Amortization!AI9),0)`
- Profit!C19: `None`
- Profit!D19: `=-C19`
- Profit!D20: `=-C20`
- Gnatt Chart!I2: `=SUMIF(qryContractsToGnatt[Assigned],$D2,qryContractsToGnatt[Price])`
- Contact!A4: `None`

## Review Note

This is a first clean-template pass. Review visible tabs once in Excel before using it as the production base for conversions.
