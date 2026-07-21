---
name: codex-environment-deployment
description: Use for Buy Your Home Codex Environment Deployment project-room work, including WesStudio baseline inventory, authorized remote setup of other computers, required app installation tracking, Codex/Admin wiki environment replication, and verification under `Project Rooms\Codex Environment Deployment`.
---

# Codex Environment Deployment

## Source Of Truth

- Project room: `C:\Codex\Wiki Files\Project Rooms\Codex Environment Deployment`
- Skill source: `C:\Codex\Wiki Files\skills\codex-environment-deployment\SKILL.md`
- Admin wiki source: `C:\Codex\Wiki Files`
- Registry: `C:\Codex\Wiki Files\Agents and Automations Registry.md`

Use this skill when Wes asks Codex to prepare another authorized computer to replicate the Codex working environment from WesStudio.

## Start PR

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.

## Required Startup

Before Codex Environment Deployment file work:

1. Confirm the working folder is `C:\Codex\Wiki Files`.
2. Confirm the current branch is `main`.
3. Read `Project Room Chat Startup Rule.md`, `Project Room File Ownership And Git Coordination Rule.md`, `Project Rooms\Codex Environment Deployment\README.md`, and this skill source.
4. Read root rules needed for the request, including `AGENTS.md`, `Repository Location Rule.md`, `Project Room Workflow.md`, `Agent Unit Standard.md`, `Git Work Scope Rule.md`, `Codex Skill Source Rule.md`, `Codex Python Runtime Rule.md`, and `LibreOffice Location Rule.md`.
5. Check `git status --short --branch`.

## Workflow

1. Identify whether the task is baseline discovery, target-computer setup, app install, configuration, verification, or documentation.
2. For baseline discovery, inspect WesStudio and record required apps, runtimes, paths, connectors, plugins, skills, configuration notes, and verification checks before standardizing target installs.
3. For target-computer setup, confirm Wes authorized that specific computer and remote session before connecting.
4. Record the target computer, user, remote access path, approval, and current state in `working\target-computer-register.md`.
5. Do not store passwords, tokens, recovery codes, license keys, or secrets. Have Wes or the authorized user enter credentials directly when needed.
6. Install or configure only approved apps and prerequisites needed to replicate the Codex environment from WesStudio.
7. Configure the Admin wiki repo as `C:\Codex\Wiki Files` on the target computer; do not use Teams-synced wiki folders as the working repo.
8. Sync wiki-managed skills only after the target Admin wiki repo is current and the updated skills are ready to install.
9. Verify the target computer with a repeatable checklist before marking it ready.
10. Preserve run notes, blockers, and verification outputs under the Project Room.
11. Commit only scoped Codex Environment Deployment room, matching skill, registry, and index changes.

## Safety Boundaries

- Remote into only the specific computer Wes authorizes for the setup run.
- Confirm the remote-control tool and session identity before making changes.
- Do not install paid apps, trials that create billing risk, browser extensions, remote-control tools, VPNs, credential managers, or system-level agents unless Wes explicitly approves that exact item.
- Do not disable antivirus, firewall, BitLocker, Windows security features, or endpoint protection unless Wes explicitly approves that exact change.
- Do not make legal, financial, mailbox, security, or account-ownership changes unless Wes explicitly authorizes the specific action.
- Do not store secrets in the wiki, Project Room, skill, git history, scripts, or chat handoff notes.
- Do not edit another Project Room's files or matching skill unless Wes explicitly authorizes that specific cross-PR edit.
- Do not create Teams folders unless Wes explicitly asks.
- Do not create automations unless Wes asks for scheduled or event-triggered behavior.
- Do not commit unrelated dirty work or generated scratch folders.
- Do not push unless Wes asks, says the setup is finished, or the applicable Admin wiki rules make the deliverable ready to publish.

## Outputs

Use `C:\Codex\Wiki Files\Project Rooms\Codex Environment Deployment\outputs` for setup checklists, baseline reports, target-computer run reports, verification summaries, and handoffs.
