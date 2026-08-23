# Network And Identity Baseline

## Confirmed

| Item | Current state |
|---|---|
| Network model | Windows workgroup; no business domain documented |
| Authoritative messaging host | `WES-VIDEOEDITOR` |
| Messaging queue | `\\WES-VIDEOEDITOR\BYH-PRMessaging$` |
| Messaging host IPv4 | `10.0.0.130` in current configuration |
| OfficeAssist identity observed during diagnostics | `OFFICEASSIST\wesbr` |
| OfficeAssist production roles | Email Monitor and Doc Scan |
| WesStudio join state observed locally | Not Azure AD, enterprise, domain, or workplace joined |

## To Verify Per Computer

| Computer | Windows edition | Join state | Intune | BitLocker | Critical workflows | Status |
|---|---|---|---|---|---|---|
| WesStudio | Pending | Local observation: not joined | Pending | Pending | Primary workstation | Audit needed |
| OfficeAssist | Pending | Pending | Pending | Pending | Email Monitor, Doc Scan | Do not use as first pilot |
| WES-VIDEOEDITOR | Pending | Pending | Pending | Pending | Video editing, messaging host | Do not use as first pilot |

## Baseline Rule

Read-only discovery may be performed in Audit mode. Any action that changes identity, enrollment, security, credentials, sharing, or production workflow state requires Wes's exact approval.

