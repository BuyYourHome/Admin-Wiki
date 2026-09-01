# Missing Context

| Question | Status | Notes |
| --- | --- | --- |
| Which computers are currently in the business inventory? | partially resolved | The register lists WesStudio, WES-VIDEOEDITOR, OfficeAssist, Jenny, LivingRoomMedia, and the Home Assistant mini. WesStudio, WES-VIDEOEDITOR, and OfficeAssist received a login/account survey on 2026-09-01. Jenny and LivingRoomMedia are identified by name but otherwise unsurveyed, and the Home Assistant mini still lacks identifying and access facts. |
| What fields are required for every computer? | draft | Start with hostname, user, role, location, OS, CPU, RAM, storage, serial/service tag, installed business apps, security posture, remote access, Codex readiness, status, and notes. |
| Should Computers have a scheduled audit automation? | not requested | Current setup is on demand only. |
| Where should large screenshots or vendor reports live? | pending | Keep durable references in Git; use Teams or another approved external archive for large generated evidence unless Wes identifies a file as durable source material. |
| Should Computers perform remote installs? | clarified | No by default. Route setup to Codex Environment unless Wes explicitly assigns a setup run to Computers. |
| What is the Home Assistant mini's manufacturer, model, computer name/hostname, serial number, CPU, RAM, and storage? | needs Wes | The handoff verifies only that a non-Windows mini exists and runs Home Assistant. Do not guess or inspect/configure it without authorization. |
| What exact operating system or Home Assistant installation type does the mini use? | needs Wes | Confirm whether it uses Home Assistant OS or another non-Windows platform and record the version when known. |
| Who owns or administers the Home Assistant mini, and where is it physically located? | needs Wes | Primary user/entity and location are unverified. |
| What are the Home Assistant mini's hostname, IP/network address, approved access method, security/update posture, backup status, and operational readiness? | needs Wes | Network and readiness facts are unverified; no device or network changes were authorized. |
| What is the continuing purpose of the enabled `Offic` account on OfficeAssist? | needs Wes | The 2026-09-01 direct survey found both `Offic` (full name `Office Assistant`) and `OfficeAssistLogin`. No account change was made or authorized. |
| What are Jenny's and LivingRoomMedia's current Windows editions, primary users, business roles, locations, specifications, account identities, remote-access methods, and readiness states? | needs Wes or direct inspection | Verified only that Windows Pro is not currently installed on either computer. No other facts should be inferred. |
