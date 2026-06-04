# Amortization Worksheet Functionality and Suggested Changes

Source workbook: `sources/28_Project Management - 320 Rose Pl.xlsm`

Worksheet reviewed: `Amortization`

Related tabs referenced by formulas: `Profit`, `Docs`

## What The Worksheet Does

The `Amortization` worksheet appears to model a buyer proposal for a Contract for Deed / owner-financed sale while also comparing that buyer note against the existing underlying subject-to mortgage.

It has four main functional areas:

1. Existing underlying mortgage model, columns `A:K`
2. Proposed buyer-financed note model, columns `N:W`
3. Alternative/reduced-rate buyer note model, columns `X:AL`
4. Summary and value comparison metrics, columns `AP:AU`

## Main Buyer Proposal Inputs

The buyer-facing proposal appears to be driven primarily from this area:

| Item | Cell | Current Value |
|---|---:|---:|
| Above-ARV markup | `K3` | `5.0%` |
| Proposed sale price | `O3` | `$346,500` |
| Down payment percent | `O2` | `6.0%` |
| Deposit / down payment | `O4` | `$20,790` |
| Financed balance after deposit | `O5` | `$325,710` |
| Contract date | `O10` | `June 1, 2026` |
| Buyer note rate | `O7` | `7.5%` |
| Buyer note term | `O8` / `P8` | `30 years / 360 months` |
| Monthly principal and interest | `O9` | `$2,277.41` |
| Insurance estimate | `T8` | `$51.50` |
| Property tax estimate | `T9` | `$145.10` |

The principal and interest payment is calculated from the buyer-financed balance, interest rate, and term. Insurance and taxes are modeled separately, then included in total payment columns on the amortization schedule.

## Existing Mortgage Section

Columns `A:K` model the underlying mortgage:

- Loan amount is pulled from `Profit!C15`
- Interest rate is pulled from `Profit!B15`
- Payment is calculated in `C5`
- Mortgage start date is `C6`
- Mortgage end date is `C7`
- Monthly rows calculate beginning balance, payment, principal, interest, escrow, total payment, ending balance, year, and period.

This appears to support the business question: how much of the underlying loan will remain over time while the buyer note is being paid.

## Buyer Note Section

Columns `N:W` model the buyer note:

- Beginning balance starts at sale price less deposit.
- Payment begins once the contract date is reached.
- Payment is calculated using the selected interest rate and term.
- Principal, interest, insurance, taxes, total payment, cumulative principal, cumulative interest, and ending balance are tracked monthly.

This appears to be the main block used to produce the buyer proposal.

## Alternative Note Section

Columns `X:AL` appear to model a second version of the buyer note:

- It uses the same date stream as the underlying mortgage.
- It supports a first-period rate/payment and a later-period rate/payment.
- The visible label says the mortgage is reduced for the first five years and then changes after that period.
- It uses cells around `Y8:AC10` for rate/payment/balance terms.

This block is useful, but currently unclear because the labels do not fully explain when to use it instead of the simpler `N:W` buyer note model.

## Scenario Selection

Cell `AW2` appears to select between three scenarios. The selected scenario affects down payment, sale amount, deposit, loan amount, and rate through formulas such as:

`IF($AW$2=1, option1, IF($AW$2=2, option2, IF($AW$2=3, option3)))`

The scenario selector is powerful but hard to use because it is not visibly labeled or protected with validation.

## Summary Metrics

Columns `AP:AU` calculate long-term comparison metrics by year:

- Year 5
- Year 10
- Year 20
- Year 29

The summary uses `XLOOKUP` against the amortization rows to pull cumulative cash flow, cumulative appreciation, and maximum value measures.

## Current Design Issues

1. Key buyer terms are spread across multiple areas, which makes it easy to use the wrong number in a proposal.
2. The worksheet has at least two buyer-note models, but does not clearly identify which one is the active proposal.
3. The `Docs` tab also contains selling fields that overlap with the amortization sheet, including sale price, down payment, loan amount, and payment. This creates a risk that proposal documents could use stale or mismatched values.
4. The scenario selector `AW2` is not clearly labeled on-screen.
5. Insurance and property tax are partly hardcoded instead of clearly linked to the property data fields.
6. Date rows advance by adding 30 days, not by true calendar months. Over long terms, this can drift away from expected monthly due dates.
7. Several formulas use whole-column lookups, which makes the model harder to audit and can slow or destabilize the workbook.
8. Some parts of the workbook contain formula errors on other tabs, including `#REF!`. Those may not affect the buyer proposal directly, but they reduce confidence in the workbook as a whole.
9. Labels such as `Mortgage Fixed at 0.075` and `Mortgage Reduced to 0.075%` are potentially confusing because `0.075` means `7.5%`, not `0.075%`.
10. The worksheet mixes proposal terms, investor economics, mortgage comparison, and long-term appreciation analysis in one place.

## Recommended Changes

### High Priority

1. Create a clean `Buyer Proposal Inputs` section with one obvious source for:
   - Property address
   - Buyer name
   - Proposal date
   - Sale price
   - Deposit/down payment percent
   - Deposit/down payment amount
   - Financed balance
   - Interest rate
   - Term
   - First payment date
   - Monthly principal and interest
   - Tax escrow
   - Insurance escrow
   - Total monthly payment

2. Add a visible `Active Proposal` flag so the worksheet clearly identifies whether the proposal uses the fixed-rate model or the alternate stepped-rate model.

3. Add a `Proposal Output` block that contains only buyer-facing numbers, already formatted exactly as they should appear in a letter or email.

4. Replace the hidden scenario selector behavior with a labeled dropdown such as:
   - Scenario 1: Base proposal
   - Scenario 2: Higher-rate proposal
   - Scenario 3: Maximum-price proposal

5. Link the `Docs` tab selling fields directly to the approved `Proposal Output` block so contract documents and email proposals cannot drift apart.

### Medium Priority

6. Replace date formulas that add `30` days with `EDATE()` formulas so payment dates stay aligned to calendar months.

7. Move tax and insurance assumptions into a clearly labeled assumptions table and link all escrow calculations to that table.

8. Add checks that flag:
   - Sale price does not match Docs tab
   - Down payment does not equal sale price times down payment percent
   - Financed balance does not equal sale price less down payment
   - Payment does not match PMT result
   - Total payment does not equal principal and interest plus escrow

9. Limit lookup ranges instead of using entire-column references.

10. Rename unclear labels so `0.075` displays as `7.5%`.

### Lower Priority

11. Split the worksheet into separate tabs:
   - `Buyer Proposal`
   - `Underlying Mortgage`
   - `Owner Finance Amortization`
   - `Investor Summary`
   - `Checks`

12. Add a button or documented workflow for producing a buyer proposal email from the `Proposal Output` block.

13. Add data validation and protection so users only edit input cells.

14. Add a version/date stamp to generated proposals.

## Suggested Next Build Step

Before rewriting formulas, build a new `Buyer Proposal` tab that references the existing amortization sheet. This gives a clean user-facing output without breaking the current model. Once that is confirmed, the internal amortization logic can be simplified safely.
