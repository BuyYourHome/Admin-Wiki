# AIOS New-Chat Smoke Test - 2026-06-08

## Purpose

Test whether a new AI chat can start from `AIOS/start-here.md`, identify the correct working folder, and route common Admin wiki requests to the right source files without moving or renaming the vault.

## Test Method

Simulated a new-chat startup by following the reading order in:

```text
C:\Codex\Wiki Files\AIOS\start-here.md
```

Verified that the referenced startup files and workflow files exist locally.

## Path Check

Result: passed.

Confirmed present:

- `AIOS/start-here.md`
- `AIOS/me.md`
- `AIOS/vault-map.md`
- `AIOS/skills-map.md`
- `AIOS/privacy-rules.md`
- `Admin Home.md`
- `Project Room Workflow.md`
- `Codex Skill Source Rule.md`
- `Document Scanning SOP.md`
- `Invoice and Receipt Processing Notes.md`
- `SOP Spreadsheet Maintenance Rule.md`
- `operations/grocery-list/README.md`
- `AIOS/tool-startup/codex.md`
- `AIOS/tool-startup/claude.md`
- `AIOS/tool-startup/chatgpt.md`

## Routing Checks

| Representative Request | Expected Route | Result |
| --- | --- | --- |
| "Create a project room for a new multi-source task." | `Project Room Workflow.md`, then `Project Rooms/<Project>/` | passed |
| "Update a Codex skill." | `Codex Skill Source Rule.md`, then `AIOS/skills-map.md`, then `skills/<skill>/SKILL.md` | passed |
| "Process a scanned invoice." | `Document Scanning SOP.md`, `Document Scanning Skill Spec.md`, `Invoice and Receipt Processing Notes.md` | passed |
| "Change an SOP workbook." | `SOP Spreadsheet Maintenance Rule.md` | passed |
| "Handle grocery-list work." | `operations/grocery-list/README.md` and grocery-list rules/data files | passed |
| "Use a sensitive source file." | `AIOS/privacy-rules.md`; ask first when source is sensitive or outside allowed local context | passed |

## Observations

- The AIOS overlay now gives a clear vault root: `C:\Codex\Wiki Files`.
- Tool-specific startup files are thin pointers and do not create competing sources of truth.
- The ACE overlay is explanatory only; no existing folders were moved or renamed.
- This was a smoke test, not a full new-chat behavioral test with an independent model session.

## Follow-Up

Step 11 should revise the AIOS files after a real new-chat trial or after the next workflow where the maps fail to route clearly.
