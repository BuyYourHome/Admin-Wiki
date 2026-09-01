# Duplicate And Conflict Log

| Item | Status | Notes |
| --- | --- | --- |
| Computer names | pending | Watch for the same physical computer appearing under hostname, device nickname, asset tag, or user description. |
| Computer ownership | pending | Record conflicts between primary user, owner, business entity, and physical location for review. |
| Specs and configuration | pending | Mark conflicting CPU/RAM/storage/OS/app facts as `conflict` until the source is verified. |
| Codex Environment overlap | clarified | Codex Environment owns authorized remote setup and installation work by default; Computers owns the durable inventory and configuration register. |
| Investigate Computer overlap | clarified | Investigate Computer owns suspected compromise diagnostics; Computers may record the final status or handoff reference. |
| Jenny versus `Jennys` | needs confirmation | Wes calls the computer Jenny; local DNS reported hostname `Jennys.localdomain` at `10.0.0.140` on 2026-09-01. Keep Jenny as the register name and `Jennys` as the observed hostname until the intended computer name is confirmed. |
