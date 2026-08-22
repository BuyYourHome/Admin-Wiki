# Duplicate And Conflict Log

| Item | Status | Notes |
| --- | --- | --- |
| Codex Environment `Update Existing Machine` overlap | resolved by boundary | Sync GetHub owns daily Git-only freshness checks and clean fast-forward pulls. Codex Environment retains machine setup, remote deployment, broader app/environment updates, and installed-skill synchronization. |
| Changes on several machines | controlled | GitHub is the exchange point. Unpushed or uncommitted local work cannot be safely incorporated automatically and must be reported on the computer where it exists. |
| Automatic push | excluded | Scheduled runs do not push. Existing shared-main push validation and owning-PR authority remain controlling. |
| Dirty worktree versus remote updates | controlled | Fetch may proceed, but no pull, stash, reset, merge, rebase, or cleanup is allowed while local work is dirty. |
