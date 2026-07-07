# Agent Unit Standard

Use this standard when a Buy Your Home workflow is expected to behave like an agent-like operating unit.

An agent unit is not always an independent software agent. It is the durable package that lets Codex perform a recurring role consistently.

## Standard Package

Each agent unit should identify these parts:

| Part | Purpose |
| --- | --- |
| Project Room | Source files, working notes, output files, run logs, and open questions. |
| Skill | Reusable workflow instructions for Codex. |
| Registry Entry | Human-readable dashboard showing status, ownership, triggers, paths, and automation id when any. |
| Chat Or Thread | Active discussion and development surface when one exists. |
| Automation | Scheduled or event-triggered runner only when the workflow needs it. |

Project Room chats must follow [[Project Room Chat Startup Rule]] so new chats self-correct to `C:\Codex\Wiki Files` before doing file work.

## Project Room Minimum

Each substantial Project Room should contain:

- `README.md` with purpose, scope, status, matching skill, automation id if any, folder map, and next actions.
- `sources\` for raw source files, exported messages, source notes, or source summaries.
- `working\source-inventory.md`.
- `working\duplicate-and-conflict-log.md`.
- `working\missing-context.md`.
- `outputs\` for review-ready drafts and final deliverables.

## Skill Minimum

Each workflow skill should include:

- source of truth paths,
- when to use the skill,
- required startup files,
- required inputs,
- what the skill owns,
- what it does not own,
- output and delivery locations,
- connector or local-file preferences,
- commit, push, and failure-reporting rules.

Keep support skills separate from workflow skills. A support skill, such as `email-delivery` or `admin-request-wrapup`, can be called by other workflows without owning its own Project Room.

## Registry Minimum

The [[Agents and Automations Registry]] should show:

- the agent unit name,
- type,
- status,
- schedule or trigger,
- primary definition paths,
- automation id when any,
- known connector dependency when material.

## Naming Rules

- Project Room names should be human-readable title case, such as `Document Scan`.
- Skill names should be lower-case hyphen-case, such as `document-scanning`.
- Registry names should match the user-facing role name.
- If one room has several property-specific subrooms, keep the shared workflow skill on the shared parent role.

## Update Rule

When a workflow becomes repeatable, add or update the Project Room README, skill, and registry entry together. Commit only the scoped durable changes for that agent unit.
