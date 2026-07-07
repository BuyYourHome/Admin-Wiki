# Duplicate And Conflict Log

| Item | Status | Notes |
| --- | --- | --- |
| STR vendor tab design | unclear | STR does not currently match the standard two-group vendor-tab layout. Do not insert STR invoice records until Wes approves the target design. |
| Atlantic Discount Flooring LLC invoice `001199` for Outrigger | inserted | Read-only inspection found no duplicate evidence. After Wes authorized finishing processing, inserted into `Flooring!A8:H8` and validated the row total at `$4,629.65`. |
| GTI Stone Design Corporation invoice `101492` for Outrigger | routed to Review | Read-only workbook inspection found no hits for invoice number `101492`, vendor name, exact amount `$4,563.00`, or `Borris`. Routed to `Review!A2:K2` because countertops plus sinks could map to `Cabinets` or `Plumbing Fixtures`; Document Scan also noted possible source-file uncertainty with `26-03-17 Borris invoice.pdf`. |
| Outrigger `Gnatt Chart` formulas | existing workbook issue | Read-only inspection found existing `#REF!` formulas in later `Gnatt Chart` timeline columns. Direct Flooring summary link is `Gnatt Chart!G14 = +Flooring!I22`, but downstream validation after insertion should account for the pre-existing formula issue. |
