# Review Formatting Rollout - Active Projects - 2026-07-15

## Scope

Source template: Teams current `27_Project Management - 7001 Outrigger Dr.xlsm`.

Worksheet: `Review`  
Table: `tblInvoiceReview`

The rollout added the visible controlled-status definitions, retained yellow input formatting on `Project/property` and `Status`, applied the approved column widths, retained rows 1-3 at 15 points and row 4 at 30 points, auto-fit project-specific data rows with a 45-point minimum, and froze rows 1-4.

No Review table values or formulas were migrated between projects.

## Status Definitions

| Status | Meaning |
| --- | --- |
| Needs Review | Not ready for Invoice Entry action. |
| Ready | Approved for evaluation; destination, duplicate, and required-data checks still apply. |
| Posted | Copied to the destination vendor tab and complete; keep the Review row as the audit record. |
| Copied - Needs Owner Verification | Provisionally copied; Wes verification is still required. |
| Hold | Hard stop; do not copy or post. |
| Duplicate Risk | Possible duplicate; resolve before copying or posting. |
| Missing Data | Required data or traceability is missing. |
| Do Not Move | Explicit stop; do not move. |

## Validation

All workbooks passed:

- Review table value/formula fingerprint unchanged.
- Workbook formula fingerprint unchanged.
- `invoiceEntryReviewRequest = Review!$B$1`; checkbox value preserved.
- Existing Status list validation and approved values preserved.
- No external workbook links.
- Worksheet and workbook-name counts unchanged.
- Yellow formatting present on every `Project/property` and `Status` data cell.
- Rows 1-4 frozen; first scrollable row is row 5.
- Rendered Review legend/header inspected.
- Exact Teams replacement downloaded and matched the validated local SHA-256 hash.

| Project | Review rows | Teams roundtrip SHA-256 |
| --- | ---: | --- |
| Outrigger | 18 | `09C16FDBA66BF36886B1FC0A1671AA5AC99DF2CD84DA26BC5CE924909052E96C` |
| Rose | 12 | `65B7C32A4B303E4E50B796421147FB0BC5236B8DD33C3B6761E0E49F50269E2B` |
| Pond | 12 | `C110B44799BFBA32CA265A78AE6FD8E3C34B621C65762C6413525AAF0F576CA2` |
| Banks | 15 | `3A393F6819E49DCD80D1C0747D5116047E61977A33EC97A240AEB327325CE5A2` |
| Pinetree | 15 | `3DF561291609618E9F6C9B33D9DE13E9780BE1A51E52A751B2043C0D196D8BD7` |
| Pleasant Garden | 15 | `3336F27DD9B21E62261DA3F5D4F6FA2118625C21632804FD362ADCD3461BAC39` |
| Rosebrooks | 15 | `FD422AA87D655282F526598E7DEAE331894E76853CB38B0A098B9DFF1530765C` |
| Cool Springs | 15 | `641242DCE482F13165C05F3BCD28EDC84AFE5E70764B496BEE6BBE2481C0E9B6` |
| Tensity | 15 | `FFDADF80ED671E7295F5FC003741DD5DEC12F74A7BDF216233669EB58BB39D4B` |
| Britton | 14 | `4DE30432BBCE11F336CD5937633005BE09F647E50400EBE03FA3897AC55BA8CD` |

## Rollback

Fresh pre-change Teams rollback workbooks for the nine target projects are retained under:

`Project Rooms\Template to Project\working\vendor-tabs-mode\review-format-rollout-20260715-155222`

Outrigger's pre-change rollback is retained in SharePoint version history as version `345.0`, saved at `2026-07-15T19:49:19Z`. The updated Outrigger workbook is version `346.0`.
