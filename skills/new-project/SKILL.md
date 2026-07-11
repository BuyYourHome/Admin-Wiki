---
name: new-project
description: Start and maintain the Buy Your Home New Project project room. Use when Wes asks to use, develop, scope, organize, inventory, or produce work from `Project Rooms\New Project`, or when a request explicitly refers to the New Project room or New Project skill.
---

# New Project

## Branch And Push Mode

- Project branch: `project/new-project`.
- At startup for durable Project Room work, verify `C:\Codex\Wiki Files` and use the matching Project Room branch when it is safe to switch.
- When Wes says `Push`, follow `C:\Codex\Wiki Files\Project Room Branch and Push Mode Rule.md`: commit and push only this room's intentional durable work, this skill source when changed, and directly related registry or rule updates.
- Do not update GitHub `main` unless Wes explicitly says `Push to main` or `promote to main`.

Use this skill to organize and develop the `New Project` project room.

## Required Context

Read these files first:

- `C:\Codex\Wiki Files\Admin Home.md`
- `C:\Codex\Wiki Files\AGENTS.md`
- `C:\Codex\Wiki Files\Project Room Workflow.md`
- `C:\Codex\Wiki Files\Codex Skill Source Rule.md`
- `C:\Codex\Wiki Files\Project Rooms\New Project\README.md`
- `C:\Codex\Wiki Files\Project Rooms\New Project\working\source-inventory.md`
- `C:\Codex\Wiki Files\Project Rooms\New Project\working\duplicate-and-conflict-log.md`
- `C:\Codex\Wiki Files\Project Rooms\New Project\working\missing-context.md`

## Workflow

1. Work only from `C:\Codex\Wiki Files`.
2. Keep New Project materials under `C:\Codex\Wiki Files\Project Rooms\New Project`.
3. When Wes says to create a new project, suggest an existing project to use as the template for the new project spreadsheet and associated folders, then wait for Wes to confirm that template or name another one.
4. Expect Wes to provide the new project address. Use that address for the new project spreadsheet and associated folders after the template project is confirmed.
5. When the new project spreadsheet is created, review the `Profit` sheet and blank out specific values that came from the prototype/template project and should not carry into the new project. Preserve formulas, labels, structural formatting, and reusable assumptions unless Wes says to change them.
6. If it is unclear whether a `Profit` sheet value is template-specific or a reusable formula/assumption, record it for review instead of deleting it.
7. If Wes has not defined the project scope, record the missing scope in `working\missing-context.md` and ask only for the minimum needed next decision.
8. Put raw source files or source notes in `sources\`.
9. Update `working\source-inventory.md` before drafting from sources.
10. Record duplicate, outdated, conflicting, or unclear sources in `working\duplicate-and-conflict-log.md`.
11. Keep analysis, experiments, and drafts in `working\`.
12. Put review-ready drafts and final deliverables in `outputs\`.
13. Mark unsupported factual claims instead of smoothing over gaps.
14. Commit durable wiki changes locally. Push only under the Admin wiki push rules.

## Boundaries

- Do not move unrelated project-room materials into New Project unless Wes explicitly says they belong there.
- Do not treat New Project as a substitute for an existing specialized room when a better room already exists.
- Do not create final deliverables from unclear or missing source context.
- Preserve original source files.
