# Minimum PR Chat Set Run Manifest

Run date: 2026-08-25

## Target

- Computer: `WES-VIDEOEDITOR`
- Windows profile: `WES-VIDEOEDITOR\IRAMa`
- Assigned user: Josh Kennedy
- Business identity: `IRAManager@SellYourHomeRaleigh.com`
- Codex project: `Admin Wiki`
- Codex project id: `d0e2c36c-2fe7-440d-a88a-dafb64b147de`
- Canonical repository: `C:\Codex\Wiki Files`
- Branch: `main`
- Git state before task work: clean and aligned with `origin/main`

## Approved Task Set

1. Codex Environment
2. Computers
3. Jean Wright
4. Email Monitor
5. Doc Scan
6. Invoice Entry
7. Marketplace
8. Manager
9. Sync GetHub

All nine Project Room README files and matching skill sources were present in the canonical repository.

## Task Results

| Task | Disposition | Task id | Startup verification | Notes |
| --- | --- | --- | --- | --- |
| Codex Environment | reused | `01a0352d-3716-74b1-9ed8-8aca14b604c7` | unverified | Matching title, local Admin Wiki project, and canonical cwd were verified. The read-only startup turn completed without a visible final result; one status-only follow-up also returned no visible result. |
| Computers | created | `01a038f0-58be-7033-82d0-a81109f86cff` | accepted | Verified `C:\Codex\Wiki Files`, clean `main` aligned with `origin/main`, room and skill paths, current draft status, and open inventory decisions. |
| Jean Wright | reused | `01a0352d-3b8c-78d1-8665-8db87bc31cba` | unverified | Matching title, local Admin Wiki project, and canonical cwd were verified. The read-only startup turn completed without a visible final result; one status-only follow-up also returned no visible result. |
| Email Monitor | reused | `01a0352d-3fea-7db1-9fc3-343e6a11d39c` | unverified | Matching title, local Admin Wiki project, and canonical cwd were verified. The read-only startup turn completed without a visible final result; one status-only follow-up also returned no visible result. |
| Doc Scan | reused | `01a0352d-4487-72d0-bea9-2fce6455eeda` | unverified | Matching title, local Admin Wiki project, and canonical cwd were verified. The read-only startup turn completed without a visible final result; one status-only follow-up also returned no visible result. |
| Invoice Entry | reused | `01a0352d-48f2-7d63-95be-98bbf4db0a62` | unverified | Matching title, local Admin Wiki project, and canonical cwd were verified. The read-only startup turn completed without a visible final result; one status-only follow-up also returned no visible result. |
| Marketplace | reused | `01a0352d-57ad-7360-87e2-ed2f9b92b41f` | unverified | Matching title, local Admin Wiki project, and canonical cwd were verified. The read-only startup turn completed without a visible final result; one status-only follow-up also returned no visible result. Marketplace was not activated. |
| Manager | reused | `01a0352d-4de5-77c1-b945-5276a990aadb` | unverified | Matching title, local Admin Wiki project, and canonical cwd were verified. The read-only startup turn completed without a visible final result; one status-only follow-up also returned no visible result. |
| Sync GetHub | created | `01a038f0-5ce0-7e10-91af-d7e6ca99869f` | blocked | The task returned `setup refresh had errors` before completing its read-only startup checks. |

## Sync GetHub Automation Verification

| Item | Result | Evidence |
| --- | --- | --- |
| Machine-local automation `sync-gethub-daily` | pending | No `C:\Users\IRAMa\.codex\automations\sync-gethub-daily` installation was present. The Sync GetHub README and registry also record WES-VIDEOEDITOR deployment as pending. |
| Daily 5:30 AM Eastern schedule | pending | The required schedule is documented, but no machine-local automation configuration was available to verify. |
| First safe run | pending | No machine-local first-run evidence was found. The automation is not installed on this profile. |

The automation was not installed or run. Sync GetHub rules require separate Codex Environment deployment authorization for installation on this computer.

## Scope Controls

- Reused seven matching IRAMa-profile tasks and created only the two missing tasks.
- Did not reuse August 20 WesBr-profile tasks as IRAMa-profile tasks.
- Did not create duplicate tasks.
- Did not change central dispatcher destinations or task metadata.
- Did not activate Marketplace.
- Did not create or change automations.
- Did not push Git changes.

## Follow-up

- Repair the Codex task execution-helper issue, then repeat startup verification for the seven unverified reused tasks and Sync GetHub.
- Obtain separate Codex Environment deployment authorization before installing `sync-gethub-daily` on WES-VIDEOEDITOR.
- After installation, verify the daily 5:30 AM Eastern schedule and complete one safe run before marking Sync GetHub enrolled on this computer.

