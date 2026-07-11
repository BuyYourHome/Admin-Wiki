# REI BlackBook Project Room

## Branch And Push Mode

- Project branch: `project/rei-blackbook`.
- When this room starts or resumes durable file work, use `C:\Codex\Wiki Files` and switch to this branch when it is safe to do so.
- When Wes says `Push` in this room, commit and push only this room's intentional durable work, its matching skill source, and directly related registry or rule updates under [[Project Room Branch and Push Mode Rule]].
- `Push` does not update GitHub `main` unless Wes explicitly says `Push to main` or `promote to main`.

Purpose: develop and maintain Buy Your Home workflows, notes, implementation plans, browser-QA records, and operating rules for REI BlackBook. The current primary work surface is REI BlackBook WebTools Sites at `https://my.reiblackbook.com/webtools/sites`.

Status: started 2026-07-09.

Matching skill: `C:\Codex\Wiki Files\skills\rei-blackbook\SKILL.md`.

Owner intent:

- Use this room to plan, draft, build, QA, and document all REI BlackBook-related work, including websites, WebTools Sites, lead/contact workflows, text or Profit Dial-related workflows, account-access notes, and future REI BlackBook modules Wes asks Codex to support.
- Use the REI BlackBook browser UI only through an authorized logged-in session.
- Keep credentials out of the project room and git history.

Folder map:

- `sources\` - source notes, approved business language, site examples, exported text, workflow screenshots or summaries, and module-specific source material.
- `working\` - source inventory, conflicts, missing context, implementation notes, browser-QA logs, workflow maps, and access notes that do not contain secrets.
- `outputs\` - review-ready drafts, launch checklists, workflow handoffs, QA reports, and final deliverables.

Key working notes:

- `working\tool-map.md` - first-pass REI BlackBook navigation, WebTools Sites, existing site IDs, BYH control-panel map, and browser safety rules.
- `working\gracious-millionaire-element-map-005.md` - current local map of Gracious Millionaire page elements, live Update Request Received cleanup, photo-retrieval retry result, remaining off-topic template content, and book-focused replacement directions.

Standing website-update rule:

- After every REI BlackBook website update, refresh the relevant local element map so it reflects the latest public-visible page titles, navigation, copy, links, forms, images, sidebars, footer, generic-template remnants, and next replacement actions.
- When a website update produces a reusable lesson, record it in `skills\rei-blackbook\SKILL.md`; when it is site-specific, record it in the project room.

GM Mode:

- `GM Mode` is the named operating mode for Gracious Millionaire REI BlackBook website work.
- Use it whenever Wes says `GM`, `GM Mode`, or gives a Gracious Millionaire website request.
- In GM Mode, every public-visible element should describe the book, the authors, the outline, editing status, update requests, excerpt requests, release information, or approved Gracious Millionaire project context.
- As of 2026-07-10, Wes authorized GM Mode to make comprehensive live website design, structure, navigation, layout, image-placement, page-copy, sidebar/footer, and form-presentation improvements for Gracious Millionaire. The loop is intended to keep improving the live site so Wes can guide subsequent iterations.
- After every GM Mode live website update, refresh the Gracious Millionaire element map and record site-specific notes in this project room.

GM scheduled iteration:

- Automation name: `gm-mode-site-iteration`.
- Cadence: every 30 minutes, plus manual on-demand GM Mode runs.
- Current schedule anchor: first run after the 2026-07-09 update is 7:52 PM Eastern, then every 30 minutes after that.
- Run lock: use `working\gm-mode-run-lock.md` to prevent overlapping GM Mode runs. If the lock exists and is less than 3 hours old, the later run should not inspect or edit the live site and should stop quietly unless user-visible notice is needed. If the lock is 3 hours old or older, record a stale-lock takeover, replace the lock, and proceed. Clear the lock at normal completion.
- Default behavior: audit, implement useful live website improvements, QA, refresh the local element map/backlog, draft or record suggested copy, and surface recommendations.
- Authorized live implementation includes comprehensive Gracious Millionaire site improvements: generic/off-topic template replacement, page titles, navigation labels, layout/design cleanup, sidebar/footer cleanup, button text, broken public links, book-focused descriptive copy, page structure, image placement for approved assets, and form presentation or field-label changes.
- Photo retrieval should be retried as part of the image-replacement backlog, but only through browser-controlled Google Photos save/export/download paths that do not open Microsoft Photos repeatedly. If downloads launch Microsoft Photos windows, stop photo retrieval for that pass, record the blocker, and continue with safer text/content cleanup.
- Wes approved using the local Gracious Millionaire logo and book-cover concept in the next GM Mode website run on 2026-07-09. Prioritize replacing the generic REI BlackBook logo and placing the book-cover concept where a cover visual is appropriate.
- Do not activate outbound form/SMS/email/lead workflows, change who receives submitted leads or messages, upload personal Google Photos publicly, change public contact/address details, change domain/DNS settings, purchase anything, publish manuscript content, make legal/financial/compliance claims, push Git changes, or send outbound messages without Wes's explicit approval for that specific action.
- Routine quiet run: if no meaningful public-site changes or new recommendations are found, keep the run brief and record only a small project-room note if needed.
- Report to Wes when the run makes live changes, finds broken pages, leaves generic template content unresolved, finds off-topic posts, hits form/workflow risk, public privacy risk, SSL/domain problems, or needs approval for higher-risk actions.
- Never make live website edits while another fresh GM Mode run lock appears active.

Current scope:

- Build the repeatable room and skill package for REI BlackBook work.
- Gather site goals, page structure, brand assets, and publishing constraints before creating public-facing content.
- Use REI BlackBook WebTools for implementation after Wes confirms account access or an authenticated browser session is available.
- Expand to other REI BlackBook modules only as Wes asks for those workflows.

Next actions:

1. Collect Wes's desired website purpose, audience, offer, phone/email/contact routing, and page list.
2. Inventory approved logos, images, business descriptions, testimonials, disclaimers, and example sites.
3. Draft page copy under `outputs\`.
4. Implement approved content in REI BlackBook WebTools Sites when authorized.
5. QA preview or published pages before any final handoff.
6. Add separate working notes for other REI BlackBook modules as they become active.
