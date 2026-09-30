# Preflight failures leave stale worker health

Status: confirmed; scoped correction proposed, not implemented.

## Evidence

On OFFICEASSIST on 2026-09-25, the existing release 0.4.6 scheduled task was enabled and Ready, with recent last-run result 0, while production health still reported a successful tick completed at 2026-09-19T09:29:44.7586488Z.

The installed configuration pinned manager SHA-256 `DA0BFE3CE06E145A66433339FEB6D62FC89007C49DD815E2BB8B48CC13625D31`; the current canonical manager was `F89FCBFF2D8F4C8FFFDB9035863C93991CA5644930B14B93D60DEE273CBCED19`. Package and Windows identity checks passed. The first failing worker check was therefore `ManagerReleaseMismatch`, before queue inventory or lock acquisition. The separately missing CLI would also prevent later submission.

`Invoke-LowTokenWorker.ps1` catches failures and builds a Blocked result, but writes health only when both configuration and worker lock exist. The hidden launcher forwards the PowerShell exit code; the caught failure does not explicitly set a failing process exit code. Thus a pre-lock integrity failure can leave stale successful health while Task Scheduler reports success.

## Proposed bounded correction

- Preserve every integrity guard and prohibit queue operations after a failed preflight.
- Report preflight failures through an atomic, machine-local diagnostic at a fixed trusted path. Validate identity and path before writing; do not trust an unverified configuration's arbitrary state path.
- Keep preflight diagnostics separate from lock-protected tick health so an overlapping launch cannot overwrite a running worker's health. Include run identity, UTC timestamps, release, stage, and a safe error code; no payloads, credentials, or command output.
- Return a nonzero process status for a blocked preflight and preserve that status through the hidden launcher.
- Have health consumers show the latest relevant failed preflight and the age of the last completed tick; scheduler success alone must not imply healthy transport.
- Add isolated fixture tests for manager/package mismatch, missing or invalid configuration, diagnostic-write failure, and concurrent lock ownership. Require zero claims/submissions and preserved journal/central records.

Implement only as a separately reviewed worker change. The focused recovery uses the existing guarded UpgradeLive installer and does not modify worker logic, queue records, or destination work.
