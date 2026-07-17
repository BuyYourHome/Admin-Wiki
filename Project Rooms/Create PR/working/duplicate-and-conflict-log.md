# Duplicate And Conflict Log

| Item | Status | Notes |
| --- | --- | --- |
| Project Room creation rules | no conflict identified | `Project Room Workflow.md`, `Project Room Chat Startup Rule.md`, and `Agent Unit Standard.md` are complementary. |
| Skill source location | no conflict identified | `Codex Skill Source Rule.md` controls; wiki-managed skills live under `C:\Codex\Wiki Files\skills`. |
| Branch handling | clarified | New PR creation works from `main`; do not create a branch unless Wes explicitly asks for one. |
| Dedicated task creation | clarified | Local PR setup should not wait indefinitely on Codex app task creation; commit local files first and mark the thread id pending if the connector does not return promptly. |
| Push behavior | watch | Global rules allow commits for durable instructions but pushes only when authorized or final. |
