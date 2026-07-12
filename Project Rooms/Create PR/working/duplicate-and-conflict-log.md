# Duplicate And Conflict Log

| Item | Status | Notes |
| --- | --- | --- |
| Project Room creation rules | no conflict identified | `Project Room Workflow.md`, `Project Room Chat Startup Rule.md`, and `Agent Unit Standard.md` are complementary. |
| Skill source location | no conflict identified | `Codex Skill Source Rule.md` controls; wiki-managed skills live under `C:\Codex\Wiki Files\skills`. |
| Branch starting point | clarified | New PR creation starts from `main`, then uses a scoped `project/<project-room-slug>` branch for the new room work. |
| Push behavior | watch | Global rules allow commits for durable instructions but pushes only when authorized or final. |
