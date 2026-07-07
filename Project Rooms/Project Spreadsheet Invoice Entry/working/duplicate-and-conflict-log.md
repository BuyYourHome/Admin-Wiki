# Duplicate And Conflict Log

| Item | Status | Notes |
| --- | --- | --- |
| STR vendor tab design | unclear | STR does not currently match the standard two-group vendor-tab layout. Do not insert STR invoice records until Wes approves the target design. |
| Atlantic Discount Flooring LLC invoice `001199` for Outrigger | no workbook duplicate evidence found | Read-only inspection of a local staging copy of `27_Project Management - 7001 Outrigger Dr.xlsm` found no hits for invoice number `001199`, vendor name, or exact amount `$4,629.65`. Insertion still needs Wes approval and the Vendor Tabs yellow-section row placement rule. |
| GTI Stone Design Corporation invoice `101492` for Outrigger | placement conflict / no workbook duplicate evidence found | Read-only workbook inspection found no hits for invoice number `101492`, vendor name, exact amount `$4,563.00`, or `Borris`. Packet still needs final worksheet decision because countertops plus sinks could map to `Cabinets` or `Plumbing Fixtures`; Document Scan also noted possible source-file uncertainty with `26-03-17 Borris invoice.pdf`. |
| Outrigger `Gnatt Chart` formulas | existing workbook issue | Read-only inspection found existing `#REF!` formulas in later `Gnatt Chart` timeline columns. Direct Flooring summary link is `Gnatt Chart!G14 = +Flooring!I22`, but downstream validation after insertion should account for the pre-existing formula issue. |
