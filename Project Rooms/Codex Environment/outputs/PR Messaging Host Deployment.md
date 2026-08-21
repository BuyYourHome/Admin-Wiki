# PR Messaging Host Deployment

## Scope

Deploy the shared Project Room messaging store on `WES-VIDEOEDITOR` and register approved client computers without migrating production traffic until validation passes.

## Planned Topology

- Host: `WES-VIDEOEDITOR` (`10.0.0.130` observed on 2026-08-20).
- Share: `\\WES-VIDEOEDITOR\BYH-PRMessaging$`.
- Host data: `D:\BuyYourHome\PRMessaging`, falling back to `C:\ProgramData\BuyYourHome\PRMessaging` only when `D:` is unavailable.
- Pilot clients: WesStudio and `WES-VIDEOEDITOR`.
- Pilot PRs: Jean Wright, Email Monitor, Invoice Entry, Doc Scan, and Marketplace.

## Preconditions

1. Confirm `WES-VIDEOEDITOR` is on the Private network profile and resolves to the intended machine.
2. Confirm an elevated administrator session on `WES-VIDEOEDITOR`.
3. Resolve the exact Windows principal that clients will use for SMB access. Do not grant `Everyone` or unauthenticated access.
4. Confirm the Admin Wiki contains `tools\pr-messaging` and `config\pr-messaging.json`.
5. Keep `legacy_queue_remains_authoritative` set to `true` during installation and testing.

## Host Installation

From elevated PowerShell on `WES-VIDEOEDITOR`:

```powershell
& 'C:\Codex\Wiki Files\tools\pr-messaging\Install-ProjectRoomMessagingHost.ps1' `
  -AllowedPrincipal 'MicrosoftAccount\wesbrowning1@outlook.com' `
  -RemoteSubnet '10.0.0.0/24'
```

The installer:

- refuses to run on another computer;
- creates the host data folders;
- applies protected NTFS permissions for SYSTEM, local Administrators, and the exact approved principal;
- creates an access-based SMB share with SMB encryption required;
- creates `BYH PR Messaging SMB Host`, a Private-profile TCP 445 firewall rule scoped to `10.0.0.0/24`.

If the principal cannot be resolved on the host, stop. Do not replace it with a broader group without Wes's explicit approval.

## Client Registration

After Windows can authenticate to the share, run on each approved client:

```powershell
& 'C:\Codex\Wiki Files\tools\pr-messaging\Register-ProjectRoomMessagingClient.ps1' `
  -ProjectRoom 'Jean Wright' `
  -TaskId '019e8e54-f8c3-7233-88dd-e1dffd79c9a6'
```

Repeat for each PR/task that may execute on that computer. Registration writes only machine-local configuration under `%LOCALAPPDATA%\BuyYourHome\PRMessaging`.

## Validation

1. Run `Test-ProjectRoomMessagingHost.ps1` from the host and every client.
2. Confirm host availability, SMB 3.x, and SMB encryption.
3. Create one synthetic `request` message from WesStudio.
4. Accept and process it from `WES-VIDEOEDITOR`.
5. Write a status update and final result from the host.
6. Verify the same immutable record and payload hash from WesStudio.
7. Disconnect the host temporarily and confirm a new test message stays `Pending Host` locally.
8. Restore the host, run `SyncSpool`, and verify the message appears once centrally.
9. Test `Delivery Ambiguous`, retry reconciliation, a linked correction, `Needs Wes`, and `Rejected as Wrong Room`.
10. Remove all synthetic records before production migration.

## Production Migration Gate

Production migration requires all validation checks to pass. Then:

1. Inventory unresolved records in the existing Email Monitor dispatch queue.
2. Preserve or migrate each unresolved record exactly once.
3. Change `live_migration_status` to `validated`.
4. Change `legacy_queue_remains_authoritative` to `false`.
5. Sync the updated skills on each client.
6. Run one low-risk real delegation and verify acceptance and return before expanding traffic.

## Rollback

On clients, stop using the new queue and leave local spool records untouched.

On `WES-VIDEOEDITOR`, run from elevated PowerShell:

```powershell
& 'C:\Codex\Wiki Files\tools\pr-messaging\Remove-ProjectRoomMessagingHost.ps1'
```

The removal script removes the share and dedicated firewall rule but preserves message data. Set `legacy_queue_remains_authoritative` to `true` and continue with the existing Email Monitor queue until the host is repaired and revalidated.
