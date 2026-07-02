# Pinetree Strict Reconversion

Output workbook: `C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Redesign\Need Verification\17_Project Management - 3413 Pinetree Ln - strict reconverted 20260530_141818.xlsm`

## Rule

Template structure, formatting, and formulas were preserved. Template constants in mapped Profit input areas were cleared unless they were explicitly mapped from Pinetree.

## Key Checks

- Profit!B4: `287000`
- Profit!C5: `0.1`
- Profit!B6: `=IF(B1="Flip",B4,IF(C1="hold",B4*(1+C5),+Amortization!O3))`
- Profit!F15: `=IF(OR($R$3=1,$R$3=2,$R$3=3),IF(OR($R$3=1,$R$3=2),-C15,Amortization!AI9),0)`
- Profit!C18: `None`
- Profit!C19: `None`
- Profit!D19: `=-C19`
- Profit!C20: `30000`
- Profit!D20: `=-C20`
- Profit!B21: `=-SUM(D14:D20)-F19`
- Profit!B45: `=-D67`
- Profit!D45: `=-B45`
- Profit!B52: `=+D87`
- Profit!D52: `=-B52`
- Profit!B53: `=+D98`
- Profit!F53: `=-B53`

Formula drift count: 0

## Residue Watch

- Profit!C19: `None`
- Profit!D19: `=-C19`
- Profit!D20: `=-C20`
- Profit!B45: `=-D67`
- Profit!B52: `=+D87`
- Profit!B53: `=+D98`
