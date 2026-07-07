# Missing Context

| Need | Status | Notes |
| --- | --- | --- |
| First test invoice packet | received | Document Scan handed off two Outrigger packets on 2026-07-07: Atlantic Discount Flooring invoice `001199` and GTI Stone Design invoice `101492`. |
| Vendor-tab yellow-section row insertion rule | provisional | For the Atlantic Flooring packet, used the first blank yellow actual-invoice row and preserved the row's subtotal/tax formulas. A durable Vendor Tabs Mode rule still needs Wes/design approval before treating this as the standard for all vendor tabs. |
| Automation authority | partial | The heartbeat may monitor project-room packets every 15 minutes, but no automated live workbook insertion authority exists yet; use on-demand approval until Wes defines insertion automation rules. |
| GTI Stone Design final worksheet | routed to Review | Packet may belong to `Cabinets` because of countertops, but sinks could overlap `Plumbing Fixtures`; entry is now in the workbook `Review` tab pending final placement. `Review!A2:A200` has a worksheet dropdown for choosing the destination tab. |

