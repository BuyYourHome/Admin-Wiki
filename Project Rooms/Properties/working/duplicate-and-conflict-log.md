# Duplicate And Conflict Log

| Item | Status | Notes |
|---|---|---|
| Tensity as temporary template | open | Wes confirmed Tensity for this test, but the workbook is still an in-progress working copy and not a confirmed clean default template. |
| Inherited workbook formula-error matches | open | The 5512 Desert Willow test workbook still shows inherited `#REF!` matches at `Gnatt Chart!AP14` and `Paint!J46`; these were not caused by Profit cleanup and need review before production use. |
| Top-level `DONT USE` project-management workbooks | open | Teams Property root includes `07_Project Management - 3325 Banks Rd - DONT USE.xlsx`, `17_Project Management - 3413 Pinetree Ln - DONT USE.xlsx`, `18_Project Management - 1426 Pleasant Garden Ln - DONT USE.xlsx`, `20_Project Management - 115 Rosebrooks Dr - DONT USE.xlsx`, `26_Project Management - 908 Pond St-Dont Use.xlsm`, and `Dont Use 22_Project Management - 1343 Old Buckhorn Rd - Dont Use.xlsx`; these should not be treated as authoritative values without Wes review. |
| `00-2156 Haig Point Way` folder with `_Project Management - 2608 Alton Pl.xlsx` | open | Folder name and workbook property name do not match. Keep any values from this folder out of final property facts until the property identity is reconciled. |
| `4121 Tensity Dr` duplicate/placeholder folder | open | Teams has both `24-HM - 4121 Tensity Dr` and `4121 Tensity Dr`; the unnumbered folder had no first-pass matching evidence and needs review before merging or ignoring. |
| Ambiguous workbook rent fields | open | Several `Profit!A9` rent candidates show values such as 12, 36, or 60, which may be term/month settings or formula-mode outputs rather than actual rent. Verify against leases before finalizing rent. |
