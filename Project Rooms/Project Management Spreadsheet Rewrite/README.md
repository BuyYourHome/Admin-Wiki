# Project Management Spreadsheet Rewrite

## Purpose

Rewrite and improve the Project Management spreadsheet used by Buy Your Home for real estate projects. The current workbook has a new instance for each real estate project, so the redesign must support repeatable project-level use without losing property-specific flexibility.

## Intended Output

- A clear source inventory of the current spreadsheet, related instructions, example project instances, and any supporting notes.
- A redesigned spreadsheet specification covering tabs, fields, formulas, data validation, status tracking, and reporting views.
- A migration plan from the current spreadsheet structure to the redesigned structure.
- A review-ready workbook or workbook template when the specification is approved.
- Durable wiki instructions for how the spreadsheet should be maintained.

## Current Scope

Included:

- Current Project Management spreadsheet structure.
- Existing project-specific spreadsheet instances.
- Real estate project lifecycle tracking needs.
- Reporting needs for Wes, Jenny, and office/admin workflows.
- Any formulas, statuses, and task categories currently used.

Excluded for now:

- Final workbook rebuild until source files and requirements are inventoried.
- Automation design unless it becomes part of the spreadsheet rewrite.
- Replacing the spreadsheet with a different system unless Wes asks for that evaluation.

## Source Locations

- Room sources: `sources\`
- Working notes: `working\`
- Outputs: `outputs\`

## Matching Skill

- Skill source: `C:\Codex\Wiki Files\skills\project-management-spreadsheet-redesign\SKILL.md`
- Use the Redesign skill for active spreadsheet redesign and rollout work. Treat this room as planning/history unless Wes specifically asks to work here.

## Working Templates

- Buyer proposal email template: `working\Buyer proposal email template.md`

## Source Inventory Status

- Authoritative sources: pending
- Duplicate/outdated sources: pending
- Missing context: pending

## Known Starting Context

- The spreadsheet is called the Project Management spreadsheet.
- A new instance is used for each real estate project.
- The rewrite is expected to be extensive.
- The first task is to build the Project Room before redesigning the workbook.

## Decisions Needed

- Location of the current master spreadsheet or best example workbook.
- Whether each project should continue to have its own workbook, or whether a master template plus per-project copies is preferred.
- Whether completed project instances should be used as examples of successful structure.

## Next Actions

1. Add or identify the current Project Management spreadsheet files.
2. Add at least one strong example project instance and one problematic project instance, if available.
3. Build `working/source-inventory.md`.
4. Build `working/duplicate-and-conflict-log.md`.
5. Build `working/missing-context.md`.
6. Draft the spreadsheet redesign spec only after the source set is clean.
## Start PR Pointer

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.
