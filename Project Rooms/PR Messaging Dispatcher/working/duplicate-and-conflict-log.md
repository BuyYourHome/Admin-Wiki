# Duplicate And Conflict Log

| Item | Resolution |
| --- | --- |
| Assumption that one dispatcher can wake Codex tasks on every computer | Superseded. The durable queue is cross-machine, but task notification is host-local. |
| One heartbeat per destination Project Room | Rejected. Use one dispatcher heartbeat per computer. |
| OfficeAssist dispatcher duplication | Do not create a second heartbeat while Email Monitor's local dispatcher stage remains active and verified. |
| Manual synthetic lifecycle as dispatchability proof | Insufficient for cross-machine readiness. Require unattended discovery and acceptance from another computer. |
