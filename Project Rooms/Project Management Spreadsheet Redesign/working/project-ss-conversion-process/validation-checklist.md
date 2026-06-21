# Validation Checklist

Use this checklist before telling Wes a template or converted workbook is ready for review.

## Before Editing

- [ ] Excel process check is clean.
- [ ] Source workbook and template paths are recorded.
- [ ] Output path is in `Need Verification` or `template-reference`, not Teams/live property storage.

## Template Validation

- [ ] Excel opens the generated template without repair prompt.
- [ ] `Profit!B2` and `Profit!B4` are blank for an empty template.
- [ ] `Profit!C19` is blank unless intentionally defaulted.
- [ ] `Profit!B6`, `Profit!F15`, `Profit!D19`, `Profit!D20`, and `Gnatt Chart!I2` formulas are intact.
- [ ] Table parts and query/external-data parts are preserved or Excel-native validation passed.

## Conversion Validation

- [ ] Excel opens the converted workbook without repair prompt.
- [ ] Formula drift audit is clean for approved formula map.
- [ ] Template-residue audit shows no unrelated project constants.
- [ ] Key source values reconcile to target cells.
- [ ] Carrying treatment is documented, especially if the source lacks a dated Carrying tab.
- [ ] Summary and reconciliation report are written.

## Template Health Gate

- [ ] Untouched candidate template formula scan is recorded before conversion.
- [ ] Existing template #REF! formulas and visible formula errors are classified as inherited defects or fixed before production use.
- [ ] Converted workbook error scan is compared to the untouched template baseline, not reviewed in isolation.
- [ ] Profit column A labels are compared against the template after Mode 1 cleaning.
- [ ] Refinance inputs are disabled or explicitly mapped before relying on Profit!H54.

## Seven Profit Totals Gate

- [ ] Total CMA reconciles.
- [ ] Total Purchase Cost reconciles.
- [ ] Total Rehab Expense reconciles.
- [ ] Total Debt reconciles or intentional template-method difference is documented.
- [ ] Monthly Carrying Cost reconciles.
- [ ] Monthly Income reconciles.
- [ ] Total Profit reconciles after the six upstream totals pass.
