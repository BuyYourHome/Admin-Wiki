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

- Production cutover validation on 2026-08-21 completed through the central queue: Email Monitor returned a read-only health result, and Invoice Entry accepted and processed a real routed approval using the same durable state contract.
- The dispatcher heartbeat was paused on 2026-08-21 because Codex displayed routine empty heartbeat turns. Durable queue records remain available while a genuinely quiet background dispatcher is prepared.
- OfficeAssist client transport passed on 2026-08-22: the restricted share authenticated successfully, the host was available, SMB 3.1.1 encryption was active, and no local spool records were pending. Email Monitor task registration and production execution remain deferred to the OfficeAssist cutover.
- OfficeAssist Email Monitor task `01a029bf-81d2-76e1-9960-64558a57640b` subsequently completed exact-identity synthetic processing, restored compact state, activated the production heartbeat, and completed one gap-free live no-message routing cycle. The predecessor WesStudio heartbeat was paused before activation. Email Monitor liveness supervision remains temporarily disabled on the WesStudio shared supervisor to avoid false stale alerts; Invoice Entry supervision remains unchanged.

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

## Validation Record - 2026-08-21

- `WES-VIDEOEDITOR` installed the secured host at `D:\BuyYourHome\PRMessaging`.
- Share `\\WES-VIDEOEDITOR\BYH-PRMessaging$` requires SMB encryption and grants change access only to `MicrosoftAccount\wesbrowning1@outlook.com` plus local administrators.
- Firewall rule `BYH PR Messaging SMB Host` permits TCP 445 only on the Private profile from `10.0.0.0/24`.
- WesStudio created authoritative synthetic request `prmsg-pilot-20260821-001` for Doc Scan.
- `WES-VIDEOEDITOR` read the same record, accepted it under the registered Doc Scan identity, entered Processing, and completed it without a business action.
- WesStudio read back `Completed` with payload hash `6ebedee8aad2c152458ba63e95e566a6989ed3e33a82bd5b1a0b3b2904dd6f35`; acceptance and completion both identify `WES-VIDEOEDITOR`.
- The local automated suite also passed duplicate/hash conflict protection, offline spool synchronization, and a 12-writer concurrency test.

At this stage, transport validation was complete but production migration remained disabled because an actual destination Codex task had not yet demonstrated automatic queue polling or wake-up and same-ID acceptance. Manual execution of a queue record was not treated as evidence of automatic task delivery.

Automatic task wake-up was subsequently validated with `prmsg-pilot-20260821-002`: the dispatcher heartbeat wrote attempt 1 before notifying the registered Doc Scan task, and Doc Scan independently verified the central payload hash, wrote Accepted and Processing, and returned Completed without business action. This run exposed that acceptance did not close the attempt's `Pending` outcome; the canonical manager and automated suite were corrected so destination acceptance atomically closes the latest pending attempt as `Delivered`.

Regression message `prmsg-pilot-20260821-003` then passed through the same dispatcher and actual Doc Scan task. Its central record reached `Completed`, attempt 1 closed as `Delivered` at acceptance, and no business action occurred. All synthetic central records were removed afterward. Production migration remains disabled pending reconciliation of unresolved legacy records and a deliberate low-risk production cutover.

## Rollback

On clients, stop using the new queue and leave local spool records untouched.

On `WES-VIDEOEDITOR`, run from elevated PowerShell:

```powershell
& 'C:\Codex\Wiki Files\tools\pr-messaging\Remove-ProjectRoomMessagingHost.ps1'
```

The removal script removes the share and dedicated firewall rule but preserves message data. Set `legacy_queue_remains_authoritative` to `true` and continue with the existing Email Monitor queue until the host is repaired and revalidated.
