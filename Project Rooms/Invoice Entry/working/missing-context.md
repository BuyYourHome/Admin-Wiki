# Missing Context

| Need | Status | Notes |
| --- | --- | --- |
| First test invoice packet | received | Doc Scan handed off two Outrigger packets on 2026-07-07: Atlantic Discount Flooring invoice `001199` and GTI Stone Design invoice `101492`. |
| Vendor-tab yellow-section row insertion rule | pilot table created | The Outrigger `Flooring` actual-invoice section is now table `tblFlooringInvoices` over `A7:H20`. This is a pilot only; Wes/design approval is still needed before rolling the table pattern to all vendor tabs. |
| Automation authority | partial | Direct-message handoff is the primary packet trigger, and the backup heartbeat may monitor project-room packets hourly for missed handoffs. No automated live workbook insertion authority exists yet; use on-demand approval until Wes defines insertion automation rules. |
| GTI Stone Design final worksheet | routed to Review | Packet may belong to `Cabinets` because of countertops, but sinks could overlap `Plumbing Fixtures`; entry is now in the workbook `Review` tab pending final placement. `Review!A2:A200` has a worksheet dropdown for choosing the destination tab. |

