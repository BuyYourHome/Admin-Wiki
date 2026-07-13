# Pinetree Retry Seven-Gate Carrying Patched

Output workbook: `C:\Codex\Wiki Files\Project Rooms\Template to Project\Need Verification\17_Project Management - 3413 Pinetree Ln - mode2 retry seven-gate carrying-patched 20260531_110424.xlsm`

This copy feeds the modern Carrying sheet from the old source monthly carrying total so Profit!K41 derives from the source instead of inherited template carrying rows.

## Checks

- Output: `C:\Codex\Wiki Files\Project Rooms\Template to Project\Need Verification\17_Project Management - 3413 Pinetree Ln - mode2 retry seven-gate carrying-patched 20260531_110424.xlsm`
- SourceMonthlyCarry: `890.28`
- SourceTotalCarry: `5341.68`
- TotalCMA: Formula=`287000` Text=`$287,000` Value=`287000`
- TotalPurchaseCost: Formula=`=+B21` Text=`$185,424` Value=`185424`
- TotalRehabExpense: Formula=`=+SUM(D64:E66)` Text=`-$5,676` Value=`-5676.264`
- TotalDebt: Formula=`=+SUM(C15:C19)+B46` Text=`$143,024` Value=`143024`
- MonthlyCarryingCost: Formula=`=IF(+R3=3,-H56,+C42/B28)` Text=`$890` Value=`890.28`
- MonthlyIncome: Formula=`=+SUM(H54:I54)` Text=`$890` Value=`890.3`
- TotalProfit: Formula=`=+I57+G56` Text=`147,588` Value=`147588.256`
- ProfitC42: Formula=`=+B28*SUM(B31:B41)` Text=`5,342` Value=`5341.68`
- ProfitB64: Formula=`5160.24` Text=`5,160` Value=`5160.24`
- GnattI6: Formula=`=SUM(I2:K5)` Text=`$306,711` Value=`306711.33050475`
- Note: `Carrying sheet fed from source monthly carrying total because source lacks a modern Carrying tab. Gantt remains stale/unreconciled; Profit rehab is source-mapped.`
