# Pinetree Formula-Safe Reconversion

Output workbook: `C:\Codex\Wiki Files\Project Rooms\Template to Project\Need Verification\17_Project Management - 3413 Pinetree Ln - formula-safe reconverted 20260530_134725.xlsm`

## Root Cause

The earlier conversion mixed two operations on the Profit sheet: it migrated source evaluated values and it reused the Pond target structure. Some cells that are formula-driven in the target layout were overwritten with Pinetree's evaluated source values. Later one-off fixes restored `F15`, but no final formula-preservation pass was run, so `B6` and other target formula cells could remain inconsistent.

## Conversion Rule Added

For Profit conversions, migrate values only into true input cells. After all source inputs are placed, restore the Pond/current formula map over the Profit sheet, with newer Outrigger formulas for cells where the Pond template is stale or incomplete (`B6`, `F15`).

## Key Checks

- Profit!B4: `287000`
- Profit!B5: `=+Amortization!M4`
- Profit!C5: `0.1`
- Profit!B6: `=IF(B1="Flip",B4,IF(C1="hold",B4*(1+C5),+Amortization!O3))`
- Profit!B7: `=+Amortization!O2`
- Profit!C7: `=+B6*B7`
- Profit!F15: `=IF(OR($R$3=1,$R$3=2,$R$3=3),IF(OR($R$3=1,$R$3=2),-C15,Amortization!AI9),0)`
- Profit!B31: `=+Carrying!B25/Profit!$B$28`
- Profit!B32: `=+Carrying!E25/Profit!$B$28`
- Profit!B35: `=+Carrying!N25/Profit!$B$28`
- Profit!B36: `=+Carrying!Q25/Profit!$B$28`
- Profit!B38: `=+Carrying!W25/Profit!$B$28`
- Profit!B42: `True`
- Profit!C42: `=+B28*SUM(B31:B41)`
- Profit!B45: `=-D67`
- Profit!D45: `=-B45`
- Profit!B52: `=+D87`
- Profit!D52: `=-B52`
- Profit!B53: `=+D98`
- Profit!F53: `=-B53`
- Profit!B64: `='Gnatt Chart'!I6`
- Profit!D64: `=-B64`

Formula drift count after preservation pass: 0
