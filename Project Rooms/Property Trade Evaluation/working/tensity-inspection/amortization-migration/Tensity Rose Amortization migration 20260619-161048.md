# Tensity Rose Amortization Migration

- Date/time: 2026-06-19 16:11:55 -04:00
- Source template workbook: `C:\Codex\Wiki Files\Project Rooms\Contract for Deed\source\320 Rose project spreadsheet\28_Project Management - 320 Rose Pl.xlsm`
- Target project workbook: `C:\Codex\Wiki Files\Project Rooms\Property Trade Evaluation\working\tensity-inspection\24_Project Management - 4121 Tensity Dr 2 - inspection copy after trade properties final.xlsm`
- Rollback copy: `C:\Codex\Wiki Files\Project Rooms\Property Trade Evaluation\working\tensity-inspection\backups\24_Project Management - 4121 Tensity Dr 2 - before Rose Amortization Swap 20260619-161048.xlsm`
- Source layout confirmation: Rose Amortization sheet contains expected Docs-facing formulas at Docs!B7, Docs!B10, Docs!B12, Docs!B13, Amortization!AA4:AA6, and Amortization!Q11.

## Key Values Before / After

| Key value | Before | After saved/reopened |
|---|---|---|
| Profit sale price | Formula=`=IF(B1="Flip",B4,IF(C1="hold",B4*(1+C5),+Amortization!O3))` Text=`$290,640` Value=`290640` | Formula=`=IF(B1="Flip",B4,IF(C1="hold",B4*(1+C5),+Amortization!O3))` Text=`$346,500` Value=`346500` |
| Profit down payment pct | Formula=`=+Amortization!O2` Text=`10%` Value=`0.1` | Formula=`=+Amortization!$K$3` Text=`10%` Value=`0.1` |
| Profit down payment amount | Formula=`=+B6*B7` Text=`$29,064` Value=`29064` | Formula=`=+B6*B7` Text=`$34,650` Value=`34650` |
| Profit monthly cash flow | Formula=`=IF(OR(C1="Hold",D1="Slow Flip"),IF(C1="hold",+B9,+Amortization!AJ7),"")` Text=`$1,084` Value=`1083.53` | Formula=`=IF(OR(C1="Hold",D1="Slow Flip"),IF(C1="hold",+B9,+Amortization!AJ8),"")` Text=`$1,031` Value=`1031.01` |
| Profit owner finance sale | Formula=`=IF(R3=3,+Amortization!AJ10,0)` Text=`298,254` Value=`298253.79` | Formula=`=IF(R3=3,+Amortization!AJ11,0)` Text=`256,253` Value=`256252.55` |
| Profit first loan 5yr balance | Formula=`=IF(OR($R$3=1,$R$3=2,$R$3=3),IF(OR($R$3=1,$R$3=2),-C15,Amortization!AI9),0)` Text=`-79,062` Value=`-79062.0299999999` | Formula=`=IF(OR($R$3=1,$R$3=2,$R$3=3),IF(OR($R$3=1,$R$3=2),-C15,Amortization!AI10),0)` Text=`-114,708` Value=`-114708.09` |
| Amort finance sale price | Formula=`=IF($AW$2=1,P3,IF($AW$2=2,Q3,IF($AW$2=3,R3)))` Text=`290,640 ` Value=`290640` | Formula=`=IF($AW$2=1,P3,IF($AW$2=2,Q3,IF($AW$2=3,R3)))` Text=`346,500 ` Value=`346500` |
| Amort down payment | Formula=`=IF($AW$2=1,P4,IF($AW$2=2,Q4,IF($AW$2=3,R4)))` Text=`29,064 ` Value=`29064` | Formula=`=IF($AW$2=1,P4,IF($AW$2=2,Q4,IF($AW$2=3,R4)))` Text=`34,650 ` Value=`34650` |
| Amort loan amount | Formula=`=IF($AW$2=1,P5,IF($AW$2=2,Q5,IF($AW$2=3,R5)))` Text=`261,576 ` Value=`261576` | Formula=`=IF($AW$2=1,P5,IF($AW$2=2,Q5,IF($AW$2=3,R5)))` Text=`311,850 ` Value=`311850` |
| Amort seller interest | Formula=`30` Text=`30.00` Value=`30` | Formula=`=IF($AW$2=1,P7,IF($AW$2=2,Q7,IF($AW$2=3,R7)))` Text=`6.250%` Value=`0.0625` |
| Amort seller payment | Formula=`=ROUND(PMT($O$6/12,$P$7,-$O$5,0), 2)` Text=`1,610.57` Value=`1610.57` | Formula=`=ROUND(PMT($O$7/12,$P$9,-$O$5,0), 2)` Text=`1,920 ` Value=`1920.11` |
| Amort term years | Formula=`45717` Text=`45,717.00` Value=`45717` | Formula=`30` Text=`30.00` Value=`30` |
| Amort loan start | Formula=`` Text=`` Value=`` | Formula=`45748` Text=`4/1/2025` Value=`45748` |
| Amort loan end | Formula=`` Text=`` Value=`` | Formula=`=EDATE(O11, P9-1)` Text=`3/1/2055` Value=`56674` |
| Amort doc sale amount | Formula=`=IF($AW$2=1,AB4,IF($AW$2=2,AC4,IF($AW$2=3,AD4)))` Text=`29,064 ` Value=`29064` | Formula=`=IF($AW$2=1,AB4,IF($AW$2=2,AC4,IF($AW$2=3,AD4)))` Text=`331,193 ` Value=`331193.4` |
| Amort doc down payment | Formula=`=IF($AW$2=1,AB5,IF($AW$2=2,AC5,IF($AW$2=3,AD5)))` Text=`331,193 ` Value=`331193.4` | Formula=`=IF($AW$2=1,AB5,IF($AW$2=2,AC5,IF($AW$2=3,AD5)))` Text=`34,650 ` Value=`34650` |
| Amort doc loan amount | Formula=`` Text=`` Value=`` | Formula=`=IF($AW$2=1,AB6,IF($AW$2=2,AC6,IF($AW$2=3,AD6)))` Text=`296,543 ` Value=`296543.4` |
| Amort rate 1 | Formula=`=IF($AW$2=1,AB6,IF($AW$2=2,AC6,IF($AW$2=3,AD6)))` Text=`6.250%` Value=`0.0625` | Formula=`0.0375` Text=`3.75%` Value=`0.0375` |
| Amort payment 1 | Formula=`=ROUND(PMT($AA$9/12,$AC$9,-$AB$9,0), 2)` Text=`1,630 ` Value=`1630.04` | Formula=`=ROUND(PMT($AA$9/12,$AC$9,-$AB$9,0), 2)` Text=`1,534 ` Value=`1533.81` |
| Amort rate 2 | Formula=`` Text=`` Value=`` | Formula=`0.0625` Text=`6.25%` Value=`0.0625` |
| Amort payment 2 | Formula=`` Text=`` Value=`` | Formula=`=ROUND(PMT($AA$10/12,$AC$10,-$AB$10,0), 2)` Text=`1,630 ` Value=`1630.04` |
| Amort tax escrow | Formula=`` Text=`` Value=`` | Formula=`188.55` Text=`188.55` Value=`188.55` |
| Amort insurance | Formula=`188.55` Text=`188.55` Value=`188.55` | Formula=`134.17` Text=`134.17` Value=`134.17` |
| Docs selling purchase price | Formula=`=+Amortization!AA5` Text=`331,193 ` Value=`331193.4` | Formula=`=+Amortization!AA4` Text=`331,193 ` Value=`331193.4` |
| Docs selling down payment | Formula=`=+Amortization!$O$4-B38` Text=`28,964 ` Value=`28964` | Formula=`=+Amortization!$O$4-B38` Text=`34,550 ` Value=`34550` |
| Docs loan amount | Formula=`=+B10-SUM(B38:B52)` Text=`323,403.81` Value=`323403.81` | Formula=`=+B10-SUM(B38:B52)` Text=`323,403.81` Value=`323403.81` |
| Docs payment 1 | Formula=`=+Amortization!Z8` Text=`1533.810` Value=`1533.81` | Formula=`=+Amortization!Z9` Text=`1533.810` Value=`1533.81` |
| Docs payment 2 | Formula=`=+Amortization!Z9` Text=`1630.040` Value=`1630.04` | Formula=`=+Amortization!Z10` Text=`1630.040` Value=`1630.04` |
| Docs base rate | Formula=`=TEXT(Amortization!$C$3,"0.000%")` Text=`3.750%` Value=`3.750%` | Formula=`=TEXT(Amortization!$C$4,"0.000%")` Text=`3.750%` Value=`3.750%` |
| Docs rate 1 | Formula=`=TEXT(+Amortization!AA8,"0.000%")` Text=`3.750%` Value=`3.750%` | Formula=`=TEXT(+Amortization!AA9,"0.000%")` Text=`3.750%` Value=`3.750%` |
| Docs rate 2 | Formula=`=TEXT(Amortization!$O$6,"0.000%")` Text=`6.250%` Value=`6.250%` | Formula=`=TEXT(Amortization!$O$7,"0.000%")` Text=`6.250%` Value=`6.250%` |
| Docs tax escrow | Formula=`=+Amortization!$T$9` Text=`189` Value=`188.55` | Formula=`=+Amortization!$T$10` Text=`189` Value=`188.55` |
| Docs insurance | Formula=`=+Amortization!$T$8` Text=`134` Value=`134.17` | Formula=`=+Amortization!$T$9` Text=`134` Value=`134.17` |
| Replacement Docs selling purchase price | Formula=`=+Amortization!AA5` Text=`331,193 ` Value=`331193.4` | Formula=`=+Amortization!AA4` Text=`331,193 ` Value=`331193.4` |
| Replacement Docs down payment | Formula=`=+Amortization!$O$4-B48` Text=`28,964 ` Value=`28964` | Formula=`=+Amortization!$O$4-B48` Text=`34,550 ` Value=`34550` |
| Replacement Docs payment 1 | Formula=`=+Amortization!Z8` Text=`1533.810` Value=`1533.81` | Formula=`=+Amortization!Z9` Text=`1533.810` Value=`1533.81` |
| Replacement Docs payment 2 | Formula=`=+Amortization!Z9` Text=`1630.040` Value=`1630.04` | Formula=`=+Amortization!Z10` Text=`1630.040` Value=`1630.04` |
| Replacement Docs tax escrow | Formula=`=+Amortization!$T$9` Text=`189` Value=`188.55` | Formula=`=+Amortization!$T$10` Text=`189` Value=`188.55` |
| Replacement Docs insurance | Formula=`=+Amortization!$T$8` Text=`134` Value=`134.17` | Formula=`=+Amortization!$T$9` Text=`134` Value=`134.17` |
| Replacement Docs base rate | Formula=`=TEXT(Amortization!$C$3,"0.000%")` Text=`3.750%` Value=`3.750%` | Formula=`=TEXT(Amortization!$C$4,"0.000%")` Text=`3.750%` Value=`3.750%` |
| Replacement Docs rate 1 | Formula=`=TEXT(+Amortization!AA8,"0.000%")` Text=`3.750%` Value=`3.750%` | Formula=`=TEXT(+Amortization!AA9,"0.000%")` Text=`3.750%` Value=`3.750%` |
| Replacement Docs rate 2 | Formula=`=TEXT(Amortization!$O$6,"0.000%")` Text=`6.250%` Value=`6.250%` | Formula=`=TEXT(Amortization!$O$7,"0.000%")` Text=`6.250%` Value=`6.250%` |

## Manual Mapping

- Mapped Tensity above-ARV percentage from old Amortization!M4 to new Amortization!P2:Q2:R2 and compatibility cell M4.
- Mapped Tensity down-payment percentage from old Amortization!O2 to new Amortization!K3.
- Mapped Tensity base rate from old Amortization!C3 to new Amortization!C4.
- Mapped Tensity financing point adders from old Amortization!P1:R1 to new Amortization!P6:R6.
- Mapped Tensity loan start date from Docs!B20 to new Amortization!O11.
- Mapped Tensity insurance/tax escrow from old Amortization!T8:T9 to new Amortization!T9:T10.
- Mapped Tensity reduced-rate payment assumptions from old Amortization!AA8:AC9 into new Amortization!AA9:AC10.
- Retargeted formulas that Excel auto-repointed to Amortization - Old back to the final Amortization sheet.
- Updated Profit formulas B5, B7, I9, G13, and F15 to Rose-layout output cells.
- Updated Docs and Replacement Docs formulas for selling purchase price, payment cells, rates, tax escrow, and insurance to Rose-layout cells.

## Unresolved Issues

- The workbook still has two document sheets (`Docs` and `Replacement Docs`). Both were updated where they referenced old Amortization output cells, but Wes should confirm which sheet is authoritative for production document generation.
- This migration preserves Tensity-specific reduced-rate payment outputs by mapping old AA8:AC9 assumptions into the Rose layout payment cells. Review the financing method if Rose should strictly use its original equal-rate assumptions instead.

## Post-Migration Correction - 2026-06-19 16:14

- Corrected external Rose workbook links that Excel introduced while copying the Rose `Amortization` sheet. Formulas now point to local workbook sheets.
- Recalculated `Amortization!X5` after localizing formulas so Tensity `Docs!B10` selling purchase price remains `331,193.40`.
- Non-Excel package scan found no remaining references to `28_Project Management - 320 Rose Pl.xlsm` or the Rose source workbook path.
- Verified corrected key values after reopening read-only:
  - `Amortization!O3` finance sale price: `290,640`
  - `Amortization!O4` down payment: `29,064`
  - `Amortization!O5` loan amount: `261,576`
  - `Docs!B10` selling purchase price: `331,193.40`
  - `Docs!B11` selling down payment after binder deposit: `28,964`
  - `Docs!B14` payment 1: `1,533.81`
  - `Docs!B15` payment 2: `1,630.04`
