# Duplicate And Conflict Log

| Item | Resolution |
| --- | --- |
| Assumption that one dispatcher can wake Codex tasks on every computer | Superseded. The durable queue is cross-machine, but task notification is host-local. |
| One heartbeat per destination Project Room | Rejected. Use one dispatcher heartbeat per computer. |
| OfficeAssist dispatcher duplication | Do not create a second heartbeat while Email Monitor's local dispatcher stage remains active and verified. |
| Manual synthetic lifecycle as dispatchability proof | Insufficient for cross-machine readiness. Require unattended discovery and acceptance from another computer. |
| Busy/pending-status connection as mandatory worker dependency | Superseded for the September 7 authorized serialized development change only, after a bounded real busy-queue test. No production gate or active messaging rule is changed. |
| CLI exit 0 or queue acknowledgment treated as delivery/completion | Neither is a recipient receipt. Preserve a destination slot through exact acceptance and a verified terminal result; ambiguous submissions retain the slot without automatic retry. A non-Completed final releases transport only, never claims business completion. |
| Historic README says WES-VIDEOEDITOR heartbeat is active | Runtime automation is PAUSED under Wes's persistent instruction. This development request does not resume it or modify its prompt, schedule or memory. |
| Isolated serialization tests treated as real-queue canary readiness | September 7 read-only review found nine historical Quickbooks holds under the current conservative predicate, including three legacy hash discrepancies. Stop before canary; preserve original records pending scoped compatibility/hold-policy review. No business processing or automatic ignore/migration is authorized. |
| Subsequent approved correction to historical holds | The three discrepancies reproduce legacy JSON escape variants, not evidence of changed payloads. Wes approved compatibility/verified-terminal worker corrections and only one exact SupersededUndelivered administrative closure. The seven other non-Completed final records keep their business state, and the Completed record keeps its original result. No bulk-clear, new delivery attempt or self-test retry occurred. |
