# Pinetree Mode 2 Labels-Safe Conversion

Output workbook: `C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Redesign\Need Verification\17_Project Management - 3413 Pinetree Ln - mode2 labels-safe 20260530_163443.xlsm`

Created by rerunning Mode 1 and Mode 2 from Pond with Profit labels preserved and refinance disabled unless explicitly mapped.

## Key Checks

- Output: `C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Redesign\Need Verification\17_Project Management - 3413 Pinetree Ln - mode2 labels-safe 20260530_163443.xlsm`
- EmptyTemplate: `C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Redesign\template-reference\Project Management - empty template from Pond Excel-native labels-safe 20260530_163443.xlsm`
- ProfitA4: `CMA:`
- ProfitA14: `Reinstatment Cost 1st:`
- ProfitA21: `Purchase Cost:`
- ProfitB2: `3413 Pinetree Ln`
- ProfitB4: `287000`
- ProfitB6: `=IF(B1="Flip",B4,IF(C1="hold",B4*(1+C5),+Amortization!O3))`
- ProfitC19: ``
- ProfitD19: `=-C19`
- ProfitC20: `30000`
- ProfitD20: `=-C20`
- ProfitH22: `$0`
- ProfitH54: `$0`
- ProfitF15: `=IF(OR($R$3=1,$R$3=2,$R$3=3),IF(OR($R$3=1,$R$3=2),-C15,Amortization!AI9),0)`
- GnattI2: `=SUMIF(qryContractsToGnatt[Assigned],$D2,qryContractsToGnatt[Price])`
- ContractRowsLoaded: `16`
- Misc2ReviewNote: `Source MISC 2 not loaded in core pass; needs explicit destination decision.`
