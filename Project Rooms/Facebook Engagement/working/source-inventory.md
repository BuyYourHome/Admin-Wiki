# Source Inventory

| Source | Type | Status | Notes |
| --- | --- | --- | --- |
| Wes setup instruction, dispatch `jeans-voice-20260808-create-facebook-engagement-v1` | User instruction | authoritative | Creates the room, skill, routing/registry entries, and dedicated task. No external action is authorized. |
| Wes scope update, same dispatch id | User instruction | authoritative | Future photo review and Page post drafting. Each post needs specific final authorization unless later rules explicitly grant it. |
| Wes dedicated-task confirmation, 2026-08-08 | User instruction | authoritative | Confirms task `019fe20a-db88-7602-a4a7-544d1be0ceee` as the dedicated Facebook Engagement task. This does not authorize Google Photos access or an external Facebook action. |
| Dispatch `jeans-voice-20260808-lunch-facebook-post-draft-v2` | Wes-authorized Jean handoff | authoritative | Authorizes the exact Google Photos source check, non-destructive preservation, one identity-preserving smart-casual edit, and approval-only draft. Explicitly prohibits external Facebook action. |
| `sources/2026-08-08-lunch-photo-intake.md` | Source check record | authoritative | Records that no visible August 8 image plausibly matched the supplied four-person lunch facts; no photo was selected, downloaded, or changed. |
| `Project Room Workflow.md` | Wiki rule | authoritative | Defines room structure and durable outcome logs. |
| `Project Room Chat Startup Rule.md` | Wiki rule | authoritative | Defines Start PR and dispatcher intake/return. |
| `Project Room Delegation Contract.md` | Wiki rule | authoritative | Defines action ownership and delegation. |
