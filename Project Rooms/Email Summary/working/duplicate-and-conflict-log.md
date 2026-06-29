# Duplicate And Conflict Log

| Item | Status | Notes |
|---|---|---|
| Automation id versus REI watcher id | resolved | `officeassist-morning-email-summary-and-instruction-monitor` is the Email Summary heartbeat. `morning-weswill-email-summary` is the REI text watcher heartbeat and should not be used for email-summary development. |
| Live status thread versus development chat | resolved | Wes approved a dedicated `Email Summary` thread for the live automation. Current `target_thread_id`: `019ecba7-f1cc-7ac1-aaf7-d89a3f21b582`. Development chats should not become the live status target unless Wes explicitly changes it again. |
| Jenny daily summary | resolved | Wes explicitly resumed Jenny's daily email summary on 2026-06-29. Outlook Email connector access to `Jenny@BuyYourHomeLLC.com` was verified. Under the global profile, Jenny's summary is posted in the Email Summary thread rather than emailed to Jenny. |
| Connector versus local Outlook | resolved | Prefer Outlook Email connector for mailbox access and OfficeAssist send verification. Use local Outlook only as a safe fallback. |
