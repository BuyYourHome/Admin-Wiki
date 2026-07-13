# Docs Mode Rules

Use these rules when updating the `Docs` worksheet across project-management spreadsheets.

## Source Order

- Treat the target workbook's existing `Docs` sheet as the first source for project-specific document values.
- Treat the Tensity `Docs` sheet as the layout, formula, and formatting template only.
- Treat `MOG` as an old-source recovery sheet only. Do not leave new `Docs` formulas permanently dependent on `MOG`.
- If a workbook has no `MOG` and the existing `Docs` sheet has broken seller-name formulas, leave the seller-name cells stable and blank unless another project-specific source is identified.

## Replacement Method

- Keep a rollback copy before any Docs-mode edit.
- Preserve the old tab by renaming the target workbook's existing `Docs` sheet to a dated old sheet, such as `Docs - Old 0704`, before creating the replacement `Docs` sheet.
- Do not rely on Excel whole-sheet copy between workbooks from PowerShell COM for this mode. It may fail silently or leave the wrong sheet active.
- Safer method: create a new blank worksheet, copy the Tensity `Docs` used-range formulas and formatting into it, copy column widths and row heights, then name it `Docs`.
- After copying formulas, scan for formulas that point to `MOG`, `#REF!`, or an external source workbook before upload.

## Value Mapping

- Map project-specific values by exact visible label from the target workbook's old `Docs` sheet. Do not use broad positional guesses.
- Copy values, not formulas, when recovering old `MOG`-derived document fields.
- For buying seller names:
  - Use `Docs` values when available.
  - If missing and `MOG` exists, recover `MOG!B3:C4` into `Docs!B3:B4` as fixed values.
  - Set `Docs!B7` from the recovered Docs values, not from `MOG`.
- Keep contract date output formulas error-tolerant for document fields, such as `IFERROR(cfdContractDate,"")` and `IFERROR(cfdEndDate,"")`.

## Validation

- Before upload, validate the local workbook for:
  - no visible errors on `Docs`;
  - no `Docs` formulas containing `MOG`;
  - no `Docs` formulas containing `#REF!`;
  - no external workbook links;
  - expected seller-name recovery status.
- Upload only after the local validation is clean.
- After upload, verify SharePoint reports the expected root-level `Property/<workbook name>` target and a current modified timestamp.

## Current Known Gap

- Banks, Pinetree, Pleasant Garden, and Rosebrooks had no recoverable old `MOG` or old `Docs` seller names during the 2026-07-04 Docs pass. Their seller-name cells were stabilized without errors, but the missing names need a separate project-specific source if those document fields will be used.
