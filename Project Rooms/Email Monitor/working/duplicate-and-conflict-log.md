# Duplicate And Conflict Log

| Item | Status | Notes |
|---|---|---|
| Automation id versus REI watcher id | resolved | `officeassist-morning-email-summary-and-instruction-monitor` is the Email Monitor heartbeat. `morning-weswill-email-summary` is the REI text watcher heartbeat and should not be used for Email Monitor development. |
| Live status thread versus development chat | resolved | Current `target_thread_id`: `019ecba7-f1cc-7ac1-aaf7-d89a3f21b582` on WesStudio. The OfficeAssist replacement task `01a029bf-81d2-76e1-9960-64558a57640b` was never activated and remains inactive after the 2026-08-24 rollback review. Development chats should not become the live status target unless Wes explicitly changes it again. |
| Jenny daily summary | resolved | Wes explicitly resumed Jenny's daily email summary on 2026-06-29. Outlook Email connector access to `Jenny@BuyYourHomeLLC.com` was verified. As of 2026-07-02, Jenny's summary is emailed to `Jenny@BuyYourHomeLLC.com` from OfficeAssist and verified in OfficeAssist Sent Items. |
| Connector versus local Outlook | resolved | Prefer Outlook Email connector for mailbox access and OfficeAssist send verification. Use local Outlook only as a safe fallback. |
