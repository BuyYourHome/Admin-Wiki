# Source Inventory

| Source | Type | Status | Notes |
| --- | --- | --- | --- |
| `sources\initial-scope.md` | Wes instruction | authoritative | Defines the room name, all-computer scope, daily cadence, and multi-machine awareness requirement. |
| `Project Room File Ownership And Git Coordination Rule.md` | Admin rule | authoritative | Controls dirty-worktree handling, fetch/pull safety, shared-main commits, and push safety. |
| `Git Work Scope Rule.md` | Admin rule | authoritative | Controls commit and push scope. |
| `Project Room Messaging Rule.md` | Admin rule | authoritative | Defines multi-machine Project Room messaging and host behavior. |
| `Project Rooms\Codex Environment\README.md` | Related workflow | authoritative for machine deployment | Codex Environment owns machine setup, remote deployment, and broader environment updates. |
| `Project Rooms\Codex Environment\working\target-computer-register.md` | Machine register | authoritative | Initial approved machines are WesStudio and Wes-VideoEditor; future active machines should be evaluated for enrollment. |
| `tools\sync-github\Invoke-SafeAdminWikiSync.ps1` | Safe-sync runner | authoritative | Performs deterministic out-of-sandbox fetch and clean fast-forward-only updates and writes atomic local status. |
| `tools\sync-github\Install-SafeAdminWikiSyncTask.ps1` | Windows task installer | authoritative | Registers the OFFICEASSIST task under `OfficeAssistLogin` at limited run level with logon and repeating triggers. |
| `tools\sync-github\tests\Test-SafeAdminWikiSync.ps1` | Isolated validation harness | authoritative | Validates already-current, dirty refusal and preservation, safe fast-forward, and repeated-failure suppression without touching the Admin Wiki history. |
