# Duplicate And Conflict Log

| Item | Status | Notes |
|---|---|---|
| Automation id versus REI watcher id | resolved | `officeassist-morning-email-summary` is the email summary. `morning-weswill-email-summary` is the REI text watcher heartbeat and should not be used for email-summary development. |
| Live status thread versus development chat | open | The live automation has an existing `target_thread_id` for status/failure visibility. A new development chat can resume build work without automatically becoming the live status target. |
| Jenny daily summary | paused | Registry and automation notes say Jenny summary remains paused until Wes explicitly resumes it. |
| Connector versus local Outlook | resolved | Prefer Outlook Email connector for mailbox access and OfficeAssist send verification. Use local Outlook only as a safe fallback. |
