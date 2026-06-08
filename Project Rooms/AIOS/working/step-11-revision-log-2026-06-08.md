# Step 11 Revision Log - 2026-06-08

## Purpose

Harden the AIOS first drafts after the startup smoke test and mark the first usable overlay version as finalized where appropriate.

## Review Method

Read the AIOS files in the same order a new assistant should use:

1. `AIOS/start-here.md`
2. `AIOS/me.md`
3. `AIOS/vault-map.md`
4. `AIOS/skills-map.md`
5. `AIOS/privacy-rules.md`

Then checked for missing files, unclear routing, and gaps that could cause a new chat to start in the wrong folder or choose the wrong workflow.

## Findings And Fixes

| Finding | Risk | Fix |
| --- | --- | --- |
| `AIOS/maintenance-log.md` was part of the intended AIOS file set but did not exist yet. | AIOS changes would be harder to track after the first implementation. | Created `AIOS/maintenance-log.md`. |
| `AIOS/start-here.md` told assistants to read the matching workflow file, but did not explicitly say to use the routing table in `AIOS/vault-map.md` to choose that file. | A new chat could still guess the workflow file from memory. | Clarified that `AIOS/vault-map.md` routing rules should be used before opening the matching workflow file. |
| The first drafts were still labeled as partial/in-progress after the smoke test passed. | Future chats could treat the overlay as unfinished even though the first usable version is ready. | Updated project-room status to mark steps 1-11 as completed for the first usable overlay. |
| The smoke test was local, not a separate independent model session. | Step 11 should not overclaim that all future new chats will behave correctly. | Kept the caveat and made the next revision trigger a real independent new-chat failure or major workflow change. |

## Result

Steps 1-11 are complete for the first usable AIOS overlay. Step 12, physical ACE migration, remains deferred.

## Follow-Up

Run a real independent new-chat trial later by giving the new chat only:

```text
C:\Codex\Wiki Files\AIOS\start-here.md
```

Then revise AIOS if the assistant lands in the wrong folder, misses a workflow rule, or overreads sensitive context.
