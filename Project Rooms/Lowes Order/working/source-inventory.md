# Source Inventory

| Source | Type | Status | Notes |
| --- | --- | --- | --- |
| Wes request to create `Lowes Order` PR | User instruction | authoritative | Establishes this Project Room and matching skill. |
| `Project Room Workflow.md` | Wiki rule | authoritative | Defines required Project Room structure and source-preparation workflow. |
| `Project Room Chat Startup Rule.md` | Wiki rule | authoritative | Defines startup requirements for the dedicated chat. |
| `Agent Unit Standard.md` | Wiki rule | authoritative | Defines Project Room, skill, registry, chat, and automation package expectations. |
| `Git Work Scope Rule.md` | Wiki rule | authoritative | Defines scoped commits and push behavior. |
| Wes instruction to fill a Lowe's cart from email through Chrome | User instruction | authoritative | Expands the workflow to retrieve order items from email, use Chrome with the existing Lowe's session, add confirmed items to the cart, and stop before checkout unless specifically approved. |
| `sources\2026-07-27-josh-kennedy-lowes-order-summary.md` | Email source summary | authoritative | Josh Kennedy's 2026-07-27 OfficeAssist Lowe's order email with item numbers but missing quantities. |
| Wes instruction to default missing Lowe's quantities to `1` | User instruction | authoritative | When a confirmed item has no stated quantity, add quantity `1` to the cart and record that Wes can adjust quantities in the cart. If a source email did not identify Lowes Order mode in the subject, tell the sender to correct it next time. |
| `outputs\2026-07-30-josh-kennedy-lowes-order-cart-filled.md` | Cart-fill output | authoritative result | Reprocessed Josh Kennedy's 2026-07-27 Lowe's order under the default quantity `1` rule; cart filled and notification emails verified. |
| Wes instruction to include the Lowe's cart link in cart-loaded notifications | User instruction | authoritative | When the cart is loaded, send the instruction sender, Jenny, and Wes a notification that includes `https://www.lowes.com/cart`. |
| `sources\2026-08-29-bathroom-roughin-cart-handoff-summary.md` | PR message source summary | authoritative | Bathroom Fixtures durable handoff for the Lowe's rough-in cart package. |
| `outputs\2026-08-29-bathroom-roughin-cart-filled.md` | Cart-fill output | authoritative result | Bathroom Fixtures rough-in package was loaded into Lowe's cart and OfficeAssist notification was verified. |
| `sources\2026-08-31-bathroom-complete-cart-handoff-summary.md` | PR message source summary | authoritative | Bathroom Fixtures durable handoff for the complete selected package with delivery/ship-to-home preference for ZIP `27511`. |
| `outputs\2026-08-31-bathroom-complete-cart-filled.md` | Cart-fill output | authoritative result | Complete Bathroom Fixtures package was loaded to the extent possible; all requested items except out-of-stock Moen `S3102` were in the cart and OfficeAssist notification was verified. |
