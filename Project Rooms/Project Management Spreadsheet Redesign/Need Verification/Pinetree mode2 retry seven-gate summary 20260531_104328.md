# Pinetree Mode 2 Retry Seven-Gate

Output workbook: `C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Redesign\Need Verification\17_Project Management - 3413 Pinetree Ln - mode2 retry seven-gate 20260531_104328.xlsm`

Created from the labels-safe empty template. This retry skips copying old source vendor tabs into modern vendor tabs because their column meanings do not align. It disables unmapped template estimates and maps the old source rehab truth from source Profit/Gantt summary into the new Profit rehab summary path.

## Checks

- Output: `C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Redesign\Need Verification\17_Project Management - 3413 Pinetree Ln - mode2 retry seven-gate 20260531_104328.xlsm`
- TotalCMA: Formula=`287000` Text=`$287,000` Value=`287000`
- TotalPurchaseCost: Formula=`=+B21` Text=`$185,424` Value=`185424`
- TotalRehabExpense: Formula=`=+SUM(D64:E66)` Text=`-$5,676` Value=`-5676.264`
- TotalDebt: Formula=`=+SUM(C15:C19)+B46` Text=`$143,024` Value=`143024`
- MonthlyCarryingCost: Formula=`=IF(+R3=3,-H56,+C42/B28)` Text=`$5,477` Value=`5477.26166666667`
- MonthlyIncome: Formula=`=+SUM(H54:I54)` Text=`$0` Value=`0`
- TotalProfit: Formula=`=+I57+G56` Text=`52,475` Value=`52475.166`
- ProfitB6: `=IF(B1="Flip",B4,IF(C1="hold",B4*(1+C5),+Amortization!O3))`
- ProfitF15: `=IF(OR($R$3=1,$R$3=2,$R$3=3),IF(OR($R$3=1,$R$3=2),-C15,Amortization!AI9),0)`
- ProfitQ6: `FALSE`
- ProfitB64: Formula=`5160.24` Text=`5,160` Value=`5160.24`
- ProfitD67: Formula=`=+SUM(D64:E66)` Text=`-$5,676` Value=`-5676.264`
- GnattI2: `=SUMIF(qryContractsToGnatt[Assigned],$D2,qryContractsToGnatt[Price])`
- ContractRowsLoaded: `16`
- Note: `Skipped old-source vendor-tab copy because old and modern vendor tab columns do not align.`
