# Project Room Chat Startup Rule

Use this rule whenever Wes asks to create, move, fork, or resume a chat for a Buy Your Home Project Room.

## Canonical Working Folder

Every Project Room chat must work from:

```text
C:\Codex\Wiki Files
```

The Codex app may create a new chat with a different default folder. The chat must self-correct before doing file work.

## Required Startup Text

Any new Project Room chat-start prompt should include this instruction block:

```text
Work only from the canonical Admin wiki Git repository:
C:\Codex\Wiki Files

Before doing file work, verify the default folder with Get-Location.
If the session default is not C:\Codex\Wiki Files, still use C:\Codex\Wiki Files explicitly as the workdir for every shell command and use absolute paths under C:\Codex\Wiki Files for all file reads and edits.

If any tool would use a relative path, stop and convert it to an absolute path under C:\Codex\Wiki Files first.

First, read:
- C:\Codex\Wiki Files\Admin Home.md
- C:\Codex\Wiki Files\AGENTS.md
- C:\Codex\Wiki Files\Repository Location Rule.md
- C:\Codex\Wiki Files\Project Room Workflow.md
- C:\Codex\Wiki Files\Agent Unit Standard.md
- the Project Room README or PROJECT-ROOM.md for the room being used
- the matching skill source under C:\Codex\Wiki Files\skills, when one exists
```

## Chat Creation Rule

When creating a new Project Room chat:

0. Create a new chat only when Wes explicitly asks or when no existing chat should own the work.
1. Name the chat after the Project Room unless Wes gives another name.
2. Include the required startup text above.
3. Include the Project Room path, matching skill path, and any automation id or thread id that belongs to the room.
4. Do not point the chat to the Teams-synced wiki folder.
5. Do not copy files to Teams merely because a chat was created. Teams receives final deliverables only when Wes explicitly asks or an established workflow says so.

## Relative Path Rule

If a Project Room chat starts outside `C:\Codex\Wiki Files`, it may still proceed only when every file operation uses:

- `C:\Codex\Wiki Files` as shell `workdir`, and
- absolute paths under `C:\Codex\Wiki Files`.

Do not use relative paths from a non-canonical default folder.

## Handoff Rule

When moving work into a new Project Room chat, include the current status, open decisions, relevant source paths, output paths, matching skill, and any connector or automation limitations. Do not assume the new chat will have remembered prior context unless the handoff states it directly.

## Branch Rule

Project Room work uses `main` by default. Do not create a new Git branch for a Project Room unless Wes explicitly asks for one.
