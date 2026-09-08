# WES-VIDEOEDITOR Assisted Worker Deployment

## Result

The bounded deployment authorized by central record `prmsg-jean-wve-assisted-worker-deployment-20260907-001` was installed and verified. The record payload hash `b2344cae2864249288dd632fa600d80ae8daeaa79fdef9290e36cae47044c128` was recomputed successfully; the owning dispatcher wrote `Accepted` and `Processing` before implementation.

Release: `0.3.0-assisted`.

## Scope and controls

- Machine: `WES-VIDEOEDITOR`.
- Windows identity: `WES-VIDEOEDITOR\\IRAMa` (interactive token, limited run level).
- Destination allowlist: Quickbooks task `01a05967-9a05-7081-a62e-616b2d8e61fd` only.
- Schedule: Windows Scheduled Task `BYH PR Messaging Assisted Worker - Quickbooks`, every 60 seconds indefinitely.
- Installed config: `C:\Users\IRAMa\AppData\Local\BuyYourHome\PRMessaging\low-token\releases\0.3.0-assisted\low-token\config.json`.
- Durable state/health: `C:\Users\IRAMa\AppData\Local\BuyYourHome\PRMessaging\low-token\assisted-quickbooks\`.
- Manual opening of Quickbooks may be required; a CLI queue acknowledgment is not recipient acceptance.
- Existing `pr-messaging-dispatcher-wes-videoeditor` heartbeat remains PAUSED (hash `0CA185E83670F01538B373E8DADF4DA7DA41E9BCD044A1699277EE71D9A0687C`). OFFICEASSIST and WESSTUDIO schedules were not changed.
- No SYSTEM account, credentials, ACLs, browser, mailbox, Quickbooks business action, new task, or production record was created or processed during setup verification.

## Actual verification

`Install-LowTokenWorker.ps1 -Install` returned `Installed`, `schedule_registered=true`, task state `Ready`, user `WES-VIDEOEDITOR\\IRAMa`, interval `PT1M`, duration `P3650D`.

The first scheduled tick ran at `2026-09-08T01:18:28.5383006Z` and completed at `2026-09-08T01:18:31.3623494Z`. Task Scheduler reported `LastTaskResult=0`. Health reported `status=Empty`, `claims=0`, `submissions=0`, `model_requests=0`, `candidate_count=0`, and no attention items. No Quickbooks queue record was eligible, so no claim or notification occurred.

The prior canary journal was reconciled before installation through the supported Canary worker path: its entry is now `phase=closed`, `outcome=Delivered`, with no submission or retry. Its central record remains Completed and its one queue item was already consumed.

## Rollback and limitations

`Install-LowTokenWorker.ps1 -Uninstall` unregisters only this assisted task and retains journals, state and central records. It does not reactivate the paused dispatcher heartbeat. Unattended loading of an unloaded Quickbooks task, reboot/login durability, and real SMB outage recovery remain unproved. Do not widen the allowlist or resume the old heartbeat without a separate authorization and reconciliation of outstanding submissions.
