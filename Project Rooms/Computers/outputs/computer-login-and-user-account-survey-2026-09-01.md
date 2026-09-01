# Computer Login And User Account Survey

Survey date: 2026-09-01

## Scope And Safety

This is a read-only inventory of known login identities, local Windows accounts, user profiles, and account roles for computers in the Computers register. No passwords, PINs, password hashes, MFA data, recovery information, authentication tokens, or license keys were collected or recorded. No accounts or settings were created, changed, disabled, or deleted.

Three Windows computers were surveyed. The Home Assistant mini remains unverified because its hostname/IP address and approved access method are not recorded. Computers did not scan for or configure that device.

## Summary

| Computer | Assigned human or workflow | Primary sign-in/profile | Related business or Microsoft identity | Survey result |
| --- | --- | --- | --- | --- |
| `WESSTUDIO` | Wes Browning | `WESSTUDIO\wesbr` | `wesbrowning1@outlook.com` | Direct local survey completed. |
| `WES-VIDEOEDITOR` | Josh Kennedy / Office Manager | `WES-VIDEOEDITOR\IRAMa` | Windows sign-in `IRAManagerBYH@outlook.com`; business identity `IRAManager@SellYourHomeRaleigh.com` | Direct Local Users and Groups survey completed through the existing authorized RDP session. |
| `OFFICEASSIST` | OfficeAssist / Email Monitor | RDP/login account `OFFICEASSIST\OfficeAssistLogin`; established Windows profile `OFFICEASSIST\wesbr` | Microsoft sign-in previously reported as `wesbrowning1@outlook.com` | Direct Local Users and Groups survey completed through saved authorized RDP access. |
| Home Assistant mini | Home Assistant workflow | unverified | unverified | Not surveyed: hostname/IP and approved access method are missing. |

## WESSTUDIO

Direct inspection identified the following accounts:

| Account | Status | Role or evidence |
| --- | --- | --- |
| `wesbr` | enabled; loaded profile | Primary Wes Browning Windows profile. Windows reports Microsoft-account principal source; established account association is `wesbrowning1@outlook.com`. |
| `CodexSandboxOffline` | enabled | Codex sandbox support account. A local profile exists. |
| `CodexSandboxOnline` | enabled | Codex sandbox support account. |
| `DELL_H1TY6f91` | enabled | Scanner service account; Windows description says it is used for saving scanned images to the PC. |
| `Administrator` | disabled | Standard built-in administrator account. |
| `DefaultAccount` | disabled | Standard Windows-managed account. |
| `Guest` | disabled | Standard built-in guest account. |
| `WDAGUtilityAccount` | disabled | Standard Windows Defender Application Guard account. |
| `WsiAccount` | disabled | Standard Windows Web Sign-in account; a local profile exists. |

Observed non-special local profiles: `wesbr` (loaded), `CodexSandboxOffline`, and `WsiAccount`.

## WES-VIDEOEDITOR

Direct Local Users and Groups inspection identified:

| Account | Status | Role or evidence |
| --- | --- | --- |
| `IRAMa` | enabled | Full name `Josh Kennedy`; primary Office Manager profile. Established Windows sign-in is `IRAManagerBYH@outlook.com`, with business identity `IRAManager@SellYourHomeRaleigh.com`. |
| `WesBr` | enabled | Full name `Wes Browning`; secondary human/admin profile retained from earlier setup. |
| `PRMsg-OfficeAssist` | enabled | PR messaging transport account for OfficeAssist. |
| `PRMsg-WesStudio` | enabled | PR messaging transport account for WesStudio. |
| `CodexSandboxOffline` | enabled | Codex sandbox support account. |
| `CodexSandboxOnline` | enabled | Codex sandbox support account. |
| `Administrator` | disabled | Standard built-in administrator account. |
| `DefaultAccount` | disabled | Standard Windows-managed account. |
| `Guest` | disabled | Standard built-in guest account. |
| `WDAGUtilityAccount` | disabled | Standard Windows Defender Application Guard account. |

The Microsoft and business email associations above come from the authoritative 2026-08-24 setup verification; the local account names and enabled/disabled states were rechecked directly on 2026-09-01.

## OFFICEASSIST

Direct Local Users and Groups inspection identified:

| Account | Status | Role or evidence |
| --- | --- | --- |
| `OfficeAssistLogin` | enabled | Saved authorized Remote Desktop/login identity used for this survey. |
| `Offic` | enabled | Full name `Office Assistant`; separate local account whose ongoing purpose needs confirmation. |
| `wesbr` | enabled | Full name `Wes Browning`; established Windows profile is `OFFICEASSIST\wesbr`, with Microsoft sign-in previously reported as `wesbrowning1@outlook.com`. |
| `CodexSandboxOffline` | enabled | Codex sandbox support account. |
| `CodexSandboxOnline` | enabled | Codex sandbox support account. |
| `Administrator` | disabled | Standard built-in administrator account. |
| `DefaultAccount` | disabled | Standard Windows-managed account. |
| `Guest` | disabled | Standard built-in guest account. |
| `WDAGUtilityAccount` | disabled | Standard Windows Defender Application Guard account. |
| `WsiAccount` | disabled | Standard Windows Web Sign-in account. |

## Home Assistant Mini

The only verified facts remain that a non-Windows/non-Microsoft mini computer exists and runs Home Assistant. Its hostname, IP address, user accounts, administrator identity, authentication method, and approved access path are unverified. Login inspection or configuration belongs to the Home Assistant Project Room once Wes provides or authorizes the needed access details.

## Decisions Or Context Still Needed

1. Confirm the purpose of the separate enabled `Offic` account on `OFFICEASSIST` and whether it is still needed. No account change is proposed or authorized by this survey.
2. Provide the Home Assistant mini's hostname/IP address, owner/administrator, and approved read-only access method if Wes wants its login identities inventoried.
3. Confirm whether the account survey should be repeated on a schedule or remain on demand.
