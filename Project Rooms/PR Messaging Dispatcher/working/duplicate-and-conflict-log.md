# Duplicate And Conflict Log

| Item | Resolution |
| --- | --- |
| Assumption that one dispatcher can wake Codex tasks on every computer | Superseded. The durable queue is cross-machine, but task notification is host-local. |
| One heartbeat per destination Project Room | Rejected. Use one dispatcher heartbeat per computer. |
| OfficeAssist dispatcher duplication | Do not create a second heartbeat while Email Monitor's local dispatcher stage remains active and verified. |
| Manual synthetic lifecycle as dispatchability proof | Insufficient for cross-machine readiness. Require unattended discovery and acceptance from another computer. |
| Busy/pending-status connection as mandatory worker dependency | Superseded for the September 7 authorized serialized development change only, after a bounded real busy-queue test. No production gate or active messaging rule is changed. |
| CLI exit 0 or queue acknowledgment treated as delivery/completion | Neither is a recipient receipt. Preserve a destination slot through exact acceptance and verified completion; ambiguous submissions retain the slot without automatic retry. |
| Historic README says WES-VIDEOEDITOR heartbeat is active | Runtime automation is PAUSED under Wes's persistent instruction. This development request does not resume it or modify its prompt, schedule or memory. |
