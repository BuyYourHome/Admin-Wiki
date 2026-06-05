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
3. Commit the Admin wiki changes locally.
4. Push only when Wes says the skill is a finished product, explicitly asks for a push, or the task instructions already define the deliverable as final and ready to publish.
5. Run `powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Codex\Wiki Files\tools\sync-codex-skills.ps1"` only when the updated skill is ready to become the installed local version.
6. On another computer, pull the Admin wiki repo, run the sync script only when the updated skill is ready to install there, then start a new Codex chat/session so the updated skill is loaded.

## Project Rooms

Project rooms remain the working source/history for project-specific materials, prototypes, staged files, outputs, source inventories, and decision notes.

Skills should point to project rooms when they need project-specific context. Skills should not replace project rooms.

For contract-for-deed work, do not sync the installed `contract-for-deed` skill merely because project-room scripts, prototypes, or drafts changed. Keep those changes in the project room until the new prototypes/workflow are ready. Sync the skill after the prototypes are completed or when Wes explicitly asks to update the installed skill.

## Direct Local Edits

If a skill is accidentally edited directly in `%USERPROFILE%\.codex\skills`, copy the change back into `C:\Codex\Wiki Files\skills` before relying on it. Then commit the wiki update locally and push only under the normal finished-product rule.
