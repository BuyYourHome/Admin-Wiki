# Carrying Delete Record Rollout

## Authorization and Scope

October 3, 2026, starting 7:19 PM Eastern. Wes requested migration of the just-approved Delete Record addition to all active projects. Tensity was already delivered and verified at version 1254. This rollout covers the remaining nine active projects, limited to the new Carrying button, its code and toolbar placement. Do not import Tensity's rent records or change Profit accounting, and do not alter Cool Springs Amortization.

Saved-and-closed confirmation for the nine targets was requested before replacement. Local preparation may proceed; no live replacements until that gate is met. Inactive exclusions remain Old Buckhorn, Burgwyn, Pearces, Sandy Run, Larchmont, Willowdell and Mom. The older Pond filename marked Dont Use is excluded.

## Targets and Progress

All sources retrieved fresh through the Teams connector from the Property root, not individual property folders. Drive: `b!4mDJWAoUZEiObH1uIc-tPNklzEL-JwdPrMve0F7Efu7K7Z-rHQDJTLJE2cO-WifT`.

| Project ID | Workbook | Live Item | Source ETag | Status |
| --- | --- | --- | --- | --- |
| 26 | 26_Project Management - 908 Pond St 3.xlsm | 01ZGFUBDLVK7BSTEO4Z5D2YYXQAVBZT7UB | "{29C35775-DC91-47CF-AC62-F0054399FE81},103" | Local audit/tests passed |
| 28 | 28_Project Management - 320 Rose Pl.xlsm | 01ZGFUBDNXYJNAKFRLTNDLLP2SWMYIHHCJ | "{055AC2B7-2B16-469B-B5BF-52B330839C49},6" | Local audit/tests passed |
| 18 | 18_Project Management - 1426 Pleasant Garden Ln.xlsm | 01ZGFUBDOJANAWG5C6NBFKWD57UBKLDLF4 | "{634103C9-5E74-4A68-AB0F-BFA054B1ACBC},13" | Local audit/tests passed |
| 20 | 20_Project Management - 115 Rosebrooks Dr.xlsm | 01ZGFUBDKNFHBV4Q4X65DYNEVWA5RYUHRG | "{5EC3294D-9743-47F7-8692-B607638A1E26},176" | Local audit/tests passed |
| 22 | 22_Project Management - 2325 Cool Springs Rd 4.xlsm | 01ZGFUBDMNVSURGFMGXNBZUOMLQBCSV4MU | "{13A9AC8D-8615-43BB-9A39-8B80452AF194},136" | Local audit/tests passed |
| 25 | 25_Project Management - 612 Britton Ct.xlsm | 01ZGFUBDO5QEQ7M544BRELUSIAOY3CVLKE | "{F62181DD-9C77-480C-BA49-0076362AAD44},362" | Local audit/tests passed |
| 27 | 27_Project Management - 7001 Outrigger Dr.xlsm | 01ZGFUBDLI2T63UQHIQVGZVZH4LRMVCLTC | "{BAFDD468-E840-4D85-9AE4-FC5C59512E62},608" | Local audit/tests passed |
| 07 | 07_Project Management - 3325 Banks Rd.xlsm | 01ZGFUBDNNVCCRFRETBFEZDV5BJFWF4XTK | "{1285A8AD-93C4-4909-91D7-A1496C5E5E6A},44" | Local audit/tests passed |
| 17 | 17_Project Management - 3413 Pinetree Ln.xlsm | 01ZGFUBDJX7HLYEOS4ENELSVOIWZMWVOCW | "{82D7F937-5C3A-4823-B955-C8B6596AB856},51" | Local audit/tests passed |

## Recovery and Validation

- All nine untouched source workbooks are in the Teams rollback archive `Property/Project Template/Rollback Copies/Carrying Delete Rollback 20261003-1919.zip`, item `01ZGFUBDLSAGWHF3FKDFBJGMFEBBWBIZDM`. Archive uploaded and downloaded/hash-verified before edits: SHA256 `44BEA99B894E78EA5738080588ECB5C4DC91A1CD183C7AD53C615A5F9A2E6DBD`.
- Isolated working root: `C:\Users\wesbr\AppData\Local\Temp\carrying-delete-rollout-20261003-1919`. Each project has its own source, output, native before/after inspection, preservation audit, test results and toolbar preview. Temporary workbooks stay outside Git.
- Preserve the target's original VBA, appending only the approved Delete suffix; do not replace Banks/Pinetree's hardened blank-date editor with an older version. Duplicate the target Cancel button to retain native styling, place Delete last and distribute six buttons within the existing context-box boundary.
- Independently map every included grid date/amount to its source row, using named grid/header ranges and the target's real display capacity. Exercise Cancel and confirmed deletion on category samples and every undated record; compare every surviving source field, unchanged grid formulas and pending manual-form contents. Pinetree needs empty-table and unsaved synthetic-record tests, not imported bills.
- Read-only whole-workbook audit compares all constants/formulas/styles, dimensions, names, tables, validations, print settings, original VBA and shapes. Native Flip/Hold/Slow Flip outputs must match the same project's fresh source; preserve pre-existing unrelated errors. No records are deleted in installed files; all functional-test changes are discarded.
- Before delivery, recheck each live ETag; if changed, refetch/rebuild/revalidate. After same-item upload, download/hash-match and re-test. Archive evidence externally before cleaning superseded local copies. No Git push authorized.

## Prepared Results

All nine local copies passed, preserving 698 source records. Every included displayed record was independently mapped: 615 grid records; the other 83 are existing excluded records preserved unchanged (five Rosebrooks, 78 Outrigger). Forty-six category/undated sample deletions were verified and discarded, plus Pinetree's empty-table/synthetic-record test. No test changes were saved and no live project replacements have occurred.

| Project | Source/Output Records | Included Records Mapped | Existing Errors Preserved |
| --- | ---: | ---: | ---: |
| Pond | 90 | 90 | 102 |
| Rose | 37 | 37 | 224 |
| Pleasant Garden | 129 | 129 | 0 |
| Rosebrooks | 24 | 19 | 1 |
| Cool Springs | 98 | 98 | 12217 |
| Britton | 34 | 34 | 66 |
| Outrigger | 126 | 48 | 2 |
| Banks | 160 | 160 | 4 |
| Pinetree | 0 | 0 | 2 |

All preservation audits reported zero issues. Flip/Hold/Slow Flip results match each project's current source; original VBA and pending form inputs are preserved. The existing error counts above are not introduced by this addition or certified correct. Nine toolbar previews passed visibility/placement review, with all six labels present and the instruction box unobstructed. Banks' undated record was successfully matched and tested without inventing a date. Pinetree's estimate-based Profit is unchanged.

Prepared-validation evidence uploaded and downloaded/hash-verified: `Property/Project Template/Validation Evidence/Carrying Delete Prepared Validation 20261003-1919.zip`, item `01ZGFUBDJOPTXUOLLQTFCZSBEJDLZND4IA`, SHA256 `C1F83E4FC5ABC481334EDF67D6C15B36DACB742290DFD413D2EFBBBD3F697BB7`. Its `readiness.json` records exact source/output SHA256 hashes. These are preparation results, not delivered-file tests.

## Remaining Gate and Resume

Wes has not yet answered the nine-target saved-and-closed question. Do not replace the live files until he confirms closure. Current validated candidates remain under each two-digit project directory's `final` subfolder in the isolated working root above. They are not live Teams files.

After confirmation, recheck the exact source ETag independently for each item, rebuild any changed project from a fresh connector copy with a new rollback, upload to the original Property item/filename, download/hash-match the candidate, run `Test-ProjectDelete.ps1` again against the downloaded copy without saving, record actual delivery metadata, archive delivered evidence and remove superseded temporary binaries. No further redesign decision is required for unchanged sources.

Lessons: keep the detailed Tensity test separate from target-independent rollout tests; derive actual record count and grid capacity instead of carrying over 68-row/21-row assumptions. Read and compare COM grid/source arrays in bulk to keep full-record preservation tests practical. Empty and undated cases need separate assertions. Excluded records must remain in the table even though the grid does not display them.
