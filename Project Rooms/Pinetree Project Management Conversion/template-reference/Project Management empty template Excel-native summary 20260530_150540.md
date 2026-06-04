# Excel-Native Empty Project Management Template

Output workbook: `C:\Codex\Wiki Files\Project Rooms\Pinetree Project Management Conversion\template-reference\Project Management - empty template from Pond Excel-native 20260530_150540.xlsm`

Created by opening the Pond template in Excel, clearing constants in known project-data ranges, preserving formulas/tables/query metadata through Excel's native save path, and reopening read-only for validation.

## Key Checks

- Output: `C:\Codex\Wiki Files\Project Rooms\Pinetree Project Management Conversion\template-reference\Project Management - empty template from Pond Excel-native 20260530_150540.xlsm`
- ProfitB2: ``
- ProfitB4: ``
- ProfitB6: `=IF(B1="Flip",B4,IF(C1="hold",B4*(1+C5),+Amortization!O3))`
- ProfitF15: `=IF(OR($R$3=1,$R$3=2,$R$3=3),IF(OR($R$3=1,$R$3=2),-C15,Amortization!AI9),0)`
- ProfitC19: ``
- ProfitD19: `=-C19`
- ProfitD20: `=-C20`
- GnattI2: `=SUMIF(qryContractsToGnatt[Assigned],$D2,qryContractsToGnatt[Price])`
