---
name: rei-blackbook
description: Use for Buy Your Home REI BlackBook work, including website creation or updates inside REI BlackBook WebTools at https://my.reiblackbook.com/webtools/sites, project-room planning, site content inventory, page copy drafting, asset tracking, lead/contact or text-workflow notes, browser-based implementation, QA notes, and handoff of decisions needed before publishing or changing live REI BlackBook workflows.
---

# REI BlackBook

## Branch And Push Mode

- Project branch: `project/rei-blackbook`.
- At startup for durable Project Room work, verify `C:\Codex\Wiki Files` and use the matching Project Room branch when it is safe to switch.
- When Wes says `Push`, follow `C:\Codex\Wiki Files\Project Room Branch and Push Mode Rule.md`: commit and push only this room's intentional durable work, this skill source when changed, and directly related registry or rule updates.
- Do not update GitHub `main` unless Wes explicitly says `Push to main` or `promote to main`.

## Source Of Truth

- Project room: `C:\Codex\Wiki Files\Project Rooms\REI BlackBook`
- Skill source: `C:\Codex\Wiki Files\skills\rei-blackbook\SKILL.md`
- Current primary REI BlackBook URL: `https://my.reiblackbook.com/webtools/sites`
- Output drafts and final handoffs: `C:\Codex\Wiki Files\Project Rooms\REI BlackBook\outputs`

## Startup

1. Read `C:\Codex\Wiki Files\Admin Home.md`.
2. Read the project-room `README.md`.
3. Read `working\source-inventory.md`, `working\duplicate-and-conflict-log.md`, and `working\missing-context.md`.
4. Check whether the request is planning, drafting, editing, QA, publishing, or troubleshooting.
5. Use a browser session that is already logged in to REI BlackBook when available. Do not store, print, or commit passwords, session cookies, recovery codes, or other credentials.

## Scope

This skill owns the repeatable workflow for Buy Your Home REI BlackBook work. The current primary module is WebTools Sites:

- collect site goals, audience, calls to action, brand rules, and page list,
- draft and revise website copy in the project room before entering it into REI BlackBook,
- track images, logos, phone numbers, forms, domains, SEO titles, meta descriptions, and publishing decisions,
- implement approved site content through the REI BlackBook browser UI when logged in,
- QA published or preview pages for content, links, forms, mobile layout, and obvious accessibility issues,
- record REI BlackBook workflow notes for lead/contact, text, Profit Dial, access, or other modules when Wes asks for those workflows,
- record blockers and decisions needed from Wes before publishing.

## Boundaries

- Do not buy domains, paid add-ons, ads, templates, or subscriptions unless Wes explicitly approves the specific purchase.
- Do not publish a site, change DNS, change tracking pixels, replace a live website, send texts, alter live lead workflows, or change account settings unless Wes explicitly approves that specific action.
- Do not invent legal, lending, investment, or real-estate compliance claims. Mark unsupported claims in drafts and ask Wes for the controlling language.
- Do not use Teams as the working source of truth. Copy final files to Teams only if Wes asks.
- Do not save REI BlackBook login credentials in the project room, skill, browser notes, scripts, or commits.

## Workflow

1. Define the site purpose, target audience, primary call to action, and pages in `README.md` or a working note.
2. Add source files or source summaries under `sources\`, then update `working\source-inventory.md`.
3. Record duplicate, outdated, or conflicting source material in `working\duplicate-and-conflict-log.md`.
4. Record missing business decisions, compliance language, assets, and account-access blockers in `working\missing-context.md`.
5. Draft page copy, workflow notes, and implementation notes in `outputs\` before making live changes unless Wes asks for a quick direct edit.
6. Use the REI BlackBook WebTools browser UI for implementation after confirming the browser is authenticated.
7. Before publishing or replacing live content, report what will change and wait for explicit approval unless Wes already authorized the exact publish/change.
8. After implementation, QA desktop and mobile views when practical, test links and forms as far as safely possible, and record results in the project room.
9. After every live website update, refresh the current local element map for that site. For Gracious Millionaire, update or supersede `working\gracious-millionaire-element-map-001.md` so it reflects the latest page titles, navigation, visible copy, images, forms, links, sidebars, footer, generic-template remnants, and next replacement actions.
10. Record lessons learned from each website update in this skill when they change the repeatable workflow, and in the project room when they are site-specific.
11. Commit durable wiki/project-room changes locally. Push only when Wes says the work is finished, explicitly asks for a push, or the deliverable is final and ready to publish.

## GM Mode

Use GM Mode when Wes says `GM`, `GM Mode`, or the request is clearly about the Gracious Millionaire REI BlackBook website.

GM Mode target:

- Site name: `Gracious Millionaire`
- Site ID: `48842`
- Builder URL: `https://u113450.h.reiblackbook.com/generic6/`
- Control panel: `https://my.reiblackbook.com/webtools/sites/advanced/48842`
- Public domain: `https://graciousmillionaire.com`
- Current element map: `C:\Codex\Wiki Files\Project Rooms\REI BlackBook\working\gracious-millionaire-element-map-005.md`
- Site record: `C:\Codex\Wiki Files\Project Rooms\REI BlackBook\working\gracious-millionaire-site.md`

GM Mode rules:

1. Every public-visible element should describe the book, the authors, the book outline, editing status, update requests, excerpt requests, release information, or approved Gracious Millionaire project context.
2. Treat generated template content as off-topic until it is verified. This includes services, generic business copy, placeholder Latin text, generic blog posts, generic categories, generic sidebars, footer text, default logos, stock images, broken profile placeholders, and default thank-you wording.
3. Before live edits, consult the current element map and decide which mapped items are in scope for the pass.
4. After every live website update, refresh the Gracious Millionaire element map so it reflects the current live/preview site after the change. If the map version becomes stale or materially different, create the next numbered map and update `source-inventory.md` and `gracious-millionaire-site.md`.
5. Record reusable GM Mode lessons in this skill. Record site-specific implementation notes, blockers, and decisions in the REI BlackBook project room.
6. Do not publish manuscript chapter content unless Wes explicitly approves that content for public use. Chapter links may point to the shared editing-status page when content is not ready.
7. As of 2026-07-10, Wes authorized GM Mode to make comprehensive live website design, structure, navigation, layout, image-placement, page-copy, sidebar/footer, and form-presentation improvements for Gracious Millionaire without limiting each pass to low-risk visible-copy fixes. Use judgment and QA after each live change.
8. Personal photos from Google Photos may be selected for planning only when Wes authorizes it. Do not upload them publicly until they have been selected for the site, and do not commit the image files to GitHub without explicit approval.
9. During GM Mode scheduled runs, retry approved Google Photos retrieval as part of the image-replacement backlog. Avoid any download/open path that launches Microsoft Photos or creates repeated Microsoft Photos windows; use the logged-in Chrome session and browser-controlled download/export/save paths only. If Chrome cannot save without opening Microsoft Photos, record the blocker and continue with text/content cleanup instead of trying repeated downloads.

GM scheduled iteration:

- Automation name: `gm-mode-site-iteration`.
- Cadence: every 30 minutes, unless Wes changes the schedule.
- Current schedule anchor: first run after the 2026-07-09 update is 7:52 PM Eastern, then every 30 minutes after that.
- Run lock: use `C:\Codex\Wiki Files\Project Rooms\REI BlackBook\working\gm-mode-run-lock.md` to prevent overlapping GM Mode runs. At startup, if the lock exists and is less than 3 hours old, do not inspect or edit the live site; stop quietly unless user-visible notice is needed. If the lock is 3 hours old or older, treat it as stale, record the stale-lock takeover in the project room, replace the lock, and proceed. Clear the lock at normal completion. If the run crashes or cannot clear the lock, the next run uses the stale-lock rule.
- Default action is audit, implement useful live website improvements, QA, refresh the map, and record the result.
- Authorized live implementation includes comprehensive Gracious Millionaire site improvements: generic/off-topic template replacement, page titles, navigation labels, layout/design cleanup, sidebar/footer cleanup, button text, broken public links, book-focused descriptive copy, page structure, image placement for approved assets, and form presentation or field-label changes that keep the site focused on book updates and excerpt requests.
- On each scheduled run, inspect the public Gracious Millionaire site, implement live improvements through the authorized logged-in REI BlackBook/WordPress browser session when available, QA affected pages, refresh or supersede the local element map, update the improvement backlog or recommendations, and record QA findings.
- As of the 2026-07-10 manual GM Mode rerun, Chrome uploads work after enabling Codex extension file access, the Gracious Millionaire header logo is live, and the approved book cover is uploaded to WordPress media as attachment `6319`. Future GM Mode runs should focus on placing the uploaded cover where appropriate and replacing remaining generic stock images through a safe Beaver Builder edit path.
- Keep routine quiet runs short. Notify Wes when live changes were made, meaningful findings remain, blockers occur, high-risk approval is needed, or QA finds broken pages, generic/off-topic content, public privacy risk, workflow/form risk, SSL/domain issues, or recommended next actions.
- Still stop for actions with outside consequences unless Wes explicitly approves that specific action: activating outbound excerpt email, SMS, lead-notification, or autoresponder workflows; changing who receives submitted leads or messages; uploading personal Google Photos to the public site; exposing or changing public contact details; changing DNS/domain settings; purchasing anything; pushing Git changes; sending messages; publishing manuscript chapter content; or making legal/financial/compliance claims.
- Never make live website edits while another fresh GM Mode run lock appears active.

## Browser Rules

- Prefer a browser automation/control tool when Codex needs to inspect or update the REI BlackBook UI.
- Do not use blind desktop keystrokes or SendKeys for REI BlackBook work on Wes's three-screen computer. If browser connector control is unavailable, stop and ask Wes to bring the target browser window forward or restore connector access before continuing.
- If the site asks for login and no authenticated session is available, stop and ask Wes to log in or provide the next authorized access step.
- Treat REI BlackBook as a live production surface. Confirm destructive, public-facing, customer-facing, or workflow-changing actions before taking them.
- Take care with form submissions: test only when the action will not contact leads, vendors, customers, or public recipients unless Wes authorizes the test.

## Lessons Learned

- Generic REI BlackBook site templates can leave off-topic content in navigation, service pages, sidebars, blog posts, categories, footer text, stock images, profile placeholders, and thank-you pages even after the Home page is rewritten. Treat every visible page element as suspect until it is mapped.
- For book sites such as Gracious Millionaire, every public element should describe the book, the authors, the outline, editing status, update requests, excerpt requests, or release information. Generic business language such as services, multi-service company, fast/friendly/flexible, placeholder Latin copy, internet-success posts, and generic categories should be replaced, hidden, or removed.
- Keep a local element map before and after live edits. The map should separate current state from book-focused replacement direction so the next implementation pass can update the site without inventing copy inside the browser.
- Chrome file uploads through the Codex extension may require `Allow access to file URLs` under the Codex extension details at `chrome://extensions`. If local photo upload fails with `Not allowed`, record the blocker and use web-sized local copies only after Wes has approved those photos for public use.
- For Beaver Builder text-module edits in Chrome, a reliable path is to open the page with `?fl_builder`, move the pointer over the target module until the overlay appears, click the module wrench, edit only the visible text/title field, click the module `Save`, then use builder `Done` -> `Publish Changes` and public-QA the page. Do not edit InsiteForms workflow/settings panels unless Wes explicitly approves routing/workflow changes.
- Do not commit personal Google Photos or other private image files to GitHub unless Wes explicitly approves committing those files. It is acceptable to commit a Markdown plan that references local-only photo filenames and privacy decisions.
- Repeated Google Photos downloads can open separate Microsoft Photos windows on Wes's computer and interfere with browser control. For GM Mode photo retrieval, avoid OS photo-viewer launch paths and stop after the first such launch pattern is detected.
- Wes broadened GM Mode on 2026-07-10 so the iteration loop can make comprehensive live site-design and site-structure improvements. Future passes should be proactive about improving the site, then use the element map, QA notes, and concise recommendations so Wes can guide the next iteration.

## Output Standards

- Keep drafts concise, direct, and ready to paste into REI BlackBook fields.
- Separate page copy from implementation notes.
- For each page, track title, slug or URL path, purpose, primary call to action, body sections, media needed, forms, links, and SEO notes when available.
- Mark unsupported claims with `[UNSUPPORTED]` instead of smoothing them into final language.
