# Codex Skill Source Rule

Codex skills for Buy Your Home admin workflows are source-controlled in the Admin wiki.

## Canonical Source

- Canonical wiki skill folder: `C:\Codex\Wiki Files\skills`
- Local installed skill folder: `%USERPROFILE%\.codex\skills`
- Sync script: `C:\Codex\Wiki Files\tools\sync-codex-skills.ps1`
- Sync command: `powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Codex\Wiki Files\tools\sync-codex-skills.ps1"`

Do not treat `%USERPROFILE%\.codex\skills` as the source of truth. Local installed skill folders are generated copies used by Codex on that computer.

## Update Workflow

1. Edit the canonical skill under `C:\Codex\Wiki Files\skills`.
2. If the skill depends on a project room, update the project room instructions/scripts at the same time.
3. Run `powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Codex\Wiki Files\tools\sync-codex-skills.ps1"` to copy wiki skills into the local Codex skills folder.
4. Commit and push the Admin wiki changes.
5. On another computer, pull the Admin wiki repo, run the sync script, then start a new Codex chat/session so the updated skill is loaded.

## Project Rooms

Project rooms remain the working source/history for project-specific materials, prototypes, staged files, outputs, source inventories, and decision notes.

Skills should point to project rooms when they need project-specific context. Skills should not replace project rooms.

## Direct Local Edits

If a skill is accidentally edited directly in `%USERPROFILE%\.codex\skills`, copy the change back into `C:\Codex\Wiki Files\skills` before relying on it. Then commit and push the wiki update.
