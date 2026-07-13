# Pinetree Reconversion Reconciliation

Output workbook: `C:\Codex\Wiki Files\Project Rooms\Template to Project\Need Verification\17_Project Management - 3413 Pinetree Ln - reconverted 20260530_132853.xlsm`

## Profit And Amortization Checks

### profit_formulas

- B4: `287000`
- B5: `=+Amortization!M4`
- B6: `=+B4`
- B7: `=+Amortization!O2`
- F15: `=IF(OR($R$3=1,$R$3=2,$R$3=3),IF(OR($R$3=1,$R$3=2),-C15,Amortization!AI9),0)`

### amortization_inputs

- M4: `0.1`
- P2: `0`
- Q2: `0`
- R2: `0`
- P3: `=+Profit!$B$4*(1+$M$4)`
- AI9: `=-_xlfn.XLOOKUP(5,$L:$L,$K:$K)`

## Notes

- Profit!F15 restored to the modern Amortization-aware formula.
- Profit!B5/B6/B7 preserved as Amortization-linked formulas; Amortization assumptions were seeded before Profit finalization.
- Profit!B4 remains the CMA input because every available Pond/current conversion reference stores B4 as CMA, while Amortization derives sale/refi figures from it.
- Pinetree has no Carrying source tab; the Carrying table contains one excluded review marker row.
