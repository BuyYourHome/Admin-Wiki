# Network Modernization Roadmap

## Decision Direction

Use a cloud-managed identity and device-management pilot as the first modernization path. Do not build traditional on-premises Active Directory solely to address workgroup SMB credentials.

Keep device enrollment and Project Room messaging transport as separate projects with separate rollback plans.

## Phase 0 - Baseline And Prerequisites

1. Inventory each business computer's Windows edition, activation, identity join state, BitLocker state, administrators, scheduled tasks, applications, and production workflows.
2. Verify Microsoft 365 licensing and whether the required Entra ID and Intune capabilities are already included.
3. Document profile-bound data, credentials, connectors, automations, and shares.
4. Select a noncritical Windows Pro pilot computer.
5. Define acceptance tests and a rollback procedure.

### Exit Gate

- Inventory is complete enough to predict profile and workflow impact.
- Licensing is verified.
- Wes approves the exact pilot device and proposed changes.

## Phase 1 - Entra ID And Intune Pilot

1. Capture a recoverable pre-change baseline and local administrator fallback.
2. Join the approved pilot to Microsoft Entra ID.
3. Enroll it in Intune using the approved tenant configuration.
4. Apply a minimal pilot policy set rather than a broad production policy set.
5. Validate sign-in, application access, OneDrive/Teams access, remote support, printing, updates, security, and recovery.
6. Observe the pilot before approving production rollout.

### Exit Gate

- Acceptance tests pass.
- Rollback has been proven or remains immediately available.
- Support and recovery procedures are documented.
- Wes accepts the pilot.

## Phase 2 - Staged Production Rollout

Recommended sequence after pilot acceptance:

1. A low-dependency secondary workstation.
2. WesStudio after profile and application dependencies are mapped.
3. OfficeAssist only after Email Monitor and Doc Scan continuity tests are prepared.
4. WES-VIDEOEDITOR only after the authoritative messaging queue is protected or relocated.

Each device requires its own approval, preflight, maintenance window, rollback, and post-change verification.

## Phase 3 - Project Room Messaging Transport

Evaluate independently:

| Option | Strength | Main concern |
|---|---|---|
| Hardened existing SMB | Lowest migration effort | Retains host and credential coupling |
| Managed NAS or Windows server | Central ownership and backup | New infrastructure and administration |
| Cloud-native durable queue | Better machine independence and service semantics | Application changes, cost, and migration complexity |
| AD-backed SMB | Familiar centralized access control | Requires domain infrastructure and administration |

Preserve the current immutable message IDs, payload hashes, lifecycle states, deduplication, and audit behavior regardless of transport.

### Exit Gate

- Wes selects the target architecture.
- Dual-run, migration, rollback, backup, and credential-rotation plans are approved.
- Email Monitor, Doc Scan, and Jean dispatch tests pass before cutover.

## Phase 4 - Operating Standard

- Maintain an authoritative device and identity register.
- Use staged policy changes and named owners.
- Monitor device compliance, workflow health, messaging health, backups, and credential expiration.
- Keep local emergency access and documented recovery paths.
- Review the architecture after major device, staffing, or workflow changes.

## Immediate Next Decision

Identify a noncritical Windows Pro computer for the pilot. OfficeAssist and WES-VIDEOEDITOR should not be the first pilot because they currently host production workflows.

