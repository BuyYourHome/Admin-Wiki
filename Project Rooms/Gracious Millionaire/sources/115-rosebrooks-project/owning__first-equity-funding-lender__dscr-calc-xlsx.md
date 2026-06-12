# DSCR Calc.xlsx

## Source Metadata

- Original path: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\19-HM-115 Rosebrooks Dr\Owning\First Equity Funding - Lender\DSCR Calc.xlsx`
- Relative path: `Owning\First Equity Funding - Lender\DSCR Calc.xlsx`
- File type: `.xlsx`
- Size bytes: 23807
- Last modified: 2024-04-30T08:56:40
- SHA256: `1bbe9c2129a5eeda2abb872544a264c8871049c082c7ac9ff4e1a2022c881af6`
- Extraction status: text-extracted
- Notes: Workbook sheets extracted to markdown-like tables; capped for very large sheets.

## Extracted Content

## Sheet: DSCR
| *Only edit blue cells* |  |  |  |  |  |
| Borrower Name |  | Wes Browning |  |  |  |
| Property Address |  | 115 Rosebrooks Ln  Cary, NC 27513 |  |  |  |
| Loan Amount |  | 115000 |  |  |  |
| Loan Term (Years) |  | 30 |  |  |  |
| Interest Only |  | No |  |  |  |
| Interest Rate |  | 0.075 |  |  |  |
| Income |  | Monthly |  |  |  |
|  | Unit 1 Qualifying Rent | 1245 |  |  |  |
|  | Unit 2 Qualifying Rent | 0 |  |  |  |
|  | Unit 3 Qualifying Rent | 0 |  |  |  |
|  | Unit 4 Qualifying Rent | 0 |  |  |  |
| Total |  | =SUM(C12:C15) |  |  |  |
| Expenses |  | Annual | Monthly |  |  |
|  | Property Tax | 1200 |  |  |  |
|  | Property Insurance | 2400 |  |  |  |
|  | Flood Insurance | 0 |  |  |  |
|  | HOA | 1500 |  |  |  |
| Total |  | =SUM(C19:C22) | =C23/12 |  |  |
| Debt Service |  |  |  |  |  |
|  | Monthly Principal | =IF(C8="No",PPMT(C9/12,1,C7*12,-C6),0) |  |  |  |
|  | Monthly Interest | =IPMT(C9/12,1,C7*12,-C6) |  |  |  |
| Total |  | =SUM(C26:C27) |  |  |  |
| DSCR |  |  |  |  |  |
|  | Qualifying Rent | =C16 |  |  |  |
|  | =IF(C8="No","PITIA","ITIA") | =(C23/12)+C28 |  |  |  |
| DSCR |  | =C31/C32 |  |  |  |
[truncated to 200 rows x 6 columns]
## Sheet: Sheet2
| No |
| Yes |
[truncated to 200 rows x 1 columns]
