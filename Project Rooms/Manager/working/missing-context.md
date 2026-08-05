# Missing Context

| Question | Status | Notes |
| --- | --- | --- |
| What should Manager manage? | partially answered | Tasks owns durable task intake, priority, delivery, and status tracking. Time Card owns the Manager's source time ledger, time/task display, clarification, and Invoice Entry packet preparation. Other Manager modes remain undefined. |
| Where is the Josh Kennedy MoU? | needed | Wes said the MoU is in the Sell Your Home channel and gives specifics of Josh's contract. Retrieve or preserve it before treating contract-specific details as source-verified. |
| What is the exact legal name for Investment Services? | needed when drafting legal wording | Wes referred to `Investment Services` and Josh's `IS role`; confirm the full legal name before drafting signature blocks or legal documents. |
| Should Manager have a dedicated chat? | resolved | The dedicated `Manager` task exists. Thread id: `019f8274-5b7e-7170-a051-f7944954de82`. |
| Should Manager have an automation? | not requested | Tasks processes direct Email Monitor `Manager Routing` handoffs as event-driven intake. Manager does not query or continuously monitor a mailbox. |
| Will Invoice Entry accept structured Time Card packets directly from Manager? | resolved | Invoice Entry accepted and implemented authorized, versioned Manager Time Card packet intake in commit `0bf157b7`, including deduplication, correction history, active-total validation, and cross-channel duplicate holds. |
| Should Time Card packets be handed off automatically at a schedule or period close? | not requested | Time Card is on-demand. Manager sends a packet only when Wes requests draft/final processing or otherwise authorizes the Invoice Entry handoff. |
