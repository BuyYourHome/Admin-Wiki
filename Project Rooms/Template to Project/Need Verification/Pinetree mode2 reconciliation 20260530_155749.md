# Pinetree Mode 2 Conversion From Empty Template

Output workbook: `C:\Codex\Wiki Files\Project Rooms\Template to Project\Need Verification\17_Project Management - 3413 Pinetree Ln - mode2 from empty template 20260530_155749.xlsm`

Loaded Pinetree source values into the Excel-native empty template using Excel automation. The workbook was saved and reopened read-only in Excel for validation.

## Key Checks

- Output: `C:\Codex\Wiki Files\Project Rooms\Template to Project\Need Verification\17_Project Management - 3413 Pinetree Ln - mode2 from empty template 20260530_155749.xlsm`
- ProfitB2: `3413 Pinetree Ln`
- ProfitB4: `287000`
- ProfitC5: `0.1`
- ProfitB6: `=IF(B1="Flip",B4,IF(C1="hold",B4*(1+C5),+Amortization!O3))`
- ProfitC19: ``
- ProfitD19: `=-C19`
- ProfitC20: `30000`
- ProfitD20: `=-C20`
- ProfitF15: `=IF(OR($R$3=1,$R$3=2,$R$3=3),IF(OR($R$3=1,$R$3=2),-C15,Amortization!AI9),0)`
- GnattI2: `=SUMIF(qryContractsToGnatt[Assigned],$D2,qryContractsToGnatt[Price])`
- ContractRowsLoaded: `16`
- Misc2ReviewPresent: `False`
- Misc2ReviewNote: `Source MISC 2 not loaded in core pass; needs explicit destination decision.`
