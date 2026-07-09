---
name: rei-blackbook-website
description: Use for Buy Your Home website creation or updates inside REI BlackBook WebTools at https://my.reiblackbook.com/webtools/sites, including project-room planning, site content inventory, page copy drafting, asset tracking, browser-based implementation, QA notes, and handoff of decisions needed before publishing.
---

# REI BlackBook Website

## Source Of Truth

- Project room: `C:\Codex\Wiki Files\Project Rooms\REI BlackBook Website`
- Skill source: `C:\Codex\Wiki Files\skills\rei-blackbook-website\SKILL.md`
- REI BlackBook WebTools URL: `https://my.reiblackbook.com/webtools/sites`
- Output drafts and final handoffs: `C:\Codex\Wiki Files\Project Rooms\REI BlackBook Website\outputs`

## Startup

1. Read `C:\Codex\Wiki Files\Admin Home.md`.
2. Read the project-room `README.md`.
3. Read `working\source-inventory.md`, `working\duplicate-and-conflict-log.md`, and `working\missing-context.md`.
4. Check whether the request is planning, drafting, editing, QA, publishing, or troubleshooting.
5. Use a browser session that is already logged in to REI BlackBook when available. Do not store, print, or commit passwords, session cookies, recovery codes, or other credentials.

## Scope

This skill owns the repeatable workflow for creating and maintaining Buy Your Home websites in REI BlackBook WebTools:

- collect site goals, audience, calls to action, brand rules, and page list,
- draft and revise website copy in the project room before entering it into REI BlackBook,
- track images, logos, phone numbers, forms, domains, SEO titles, meta descriptions, and publishing decisions,
- implement approved site content through the REI BlackBook browser UI when logged in,
- QA published or preview pages for content, links, forms, mobile layout, and obvious accessibility issues,
- record blockers and decisions needed from Wes before publishing.

## Boundaries

- Do not buy domains, paid add-ons, ads, templates, or subscriptions unless Wes explicitly approves the specific purchase.
- Do not publish a site, change DNS, change tracking pixels, or replace a live website unless Wes explicitly approves that specific action.
- Do not invent legal, lending, investment, or real-estate compliance claims. Mark unsupported claims in drafts and ask Wes for the controlling language.
- Do not use Teams as the working source of truth. Copy final files to Teams only if Wes asks.
- Do not save REI BlackBook login credentials in the project room, skill, browser notes, scripts, or commits.

## Workflow

1. Define the site purpose, target audience, primary call to action, and pages in `README.md` or a working note.
2. Add source files or source summaries under `sources\`, then update `working\source-inventory.md`.
3. Record duplicate, outdated, or conflicting source material in `working\duplicate-and-conflict-log.md`.
4. Record missing business decisions, compliance language, assets, and account-access blockers in `working\missing-context.md`.
5. Draft page copy and implementation notes in `outputs\` before making live-site changes unless Wes asks for a quick direct edit.
6. Use the REI BlackBook WebTools browser UI for implementation after confirming the browser is authenticated.
7. Before publishing or replacing live content, report what will change and wait for explicit approval unless Wes already authorized the exact publish/change.
8. After implementation, QA desktop and mobile views when practical, test links and forms as far as safely possible, and record results in the project room.
9. Commit durable wiki/project-room changes locally. Push only when Wes says the work is finished, explicitly asks for a push, or the deliverable is final and ready to publish.

## Browser Rules

- Prefer a browser automation/control tool when Codex needs to inspect or update the REI BlackBook UI.
- If the site asks for login and no authenticated session is available, stop and ask Wes to log in or provide the next authorized access step.
- Treat REI BlackBook as a live production surface. Confirm destructive or public-facing actions before taking them.
- Take care with form submissions: test only when the action will not contact leads, vendors, customers, or public recipients unless Wes authorizes the test.

## Output Standards

- Keep drafts concise, direct, and ready to paste into REI BlackBook fields.
- Separate page copy from implementation notes.
- For each page, track title, slug or URL path, purpose, primary call to action, body sections, media needed, forms, links, and SEO notes when available.
- Mark unsupported claims with `[UNSUPPORTED]` instead of smoothing them into final language.
