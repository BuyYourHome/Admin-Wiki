# Pinetree Current Conversion Review

Output workbook: `C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Redesign\Need Verification\17_Project Management - 3413 Pinetree Ln - current conversion review.xlsm`

This is the overwrite target for current review. It preserves Profit!B64 as a formula to the Gantt Chart and includes buying closing costs from source B53:B70 mapped to target B69:B86.

## Checks

- Output: `C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Redesign\Need Verification\17_Project Management - 3413 Pinetree Ln - current conversion review.xlsm`
- TotalCMA: Formula=`287000` Text=`$287,000` Value=`287000`
- TotalPurchaseCost: Formula=`=+B21` Text=`$185,424` Value=`185424`
- TotalRehabExpense: Formula=`=+SUM(D64:E66)` Text=`-$337,382` Value=`-337382.463555225`
- TotalDebt: Formula=`=+SUM(C15:C19)+B46` Text=`$143,024` Value=`143024`
- MonthlyCarryingCost: Formula=`=IF(+R3=3,-H56,+C42/B28)` Text=`$890` Value=`890.28`
- MonthlyIncome: Formula=`=+SUM(H54:I54)` Text=`$0` Value=`0`
- TotalProfit: Formula=`=+I57+G56` Text=`-256,997` Value=`-256997.143555225`
- BuyingClosingCostTotal: Formula=`=+SUM(B69:C86)` Text=`$5,998` Value=`5998`
- SellingClosingCostTotal: Formula=`=+SUM(B90:C97)` Text=`$290` Value=`290`
- ProfitB64: Formula=`='Gnatt Chart'!I6` Text=`306,711` Value=`306711.33050475`
- GnattI6: Formula=`=SUM(I2:K5)` Text=`$306,711` Value=`306711.33050475`
- ProfitB6: `=IF(B1="Flip",B4,IF(C1="hold",B4*(1+C5),+Amortization!O3))`
- ProfitF15: `=IF(OR($R$3=1,$R$3=2,$R$3=3),IF(OR($R$3=1,$R$3=2),-C15,Amortization!AI9),0)`
- ContractRowsLoaded: `16`
- Note: `B64 preserved as Gantt formula. B53:B70 buying closing costs mapped to B69:B86. Gantt refresh remains a separate blocker.`
