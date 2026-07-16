# Gracious Millionaire REI BlackBook Site

Created 2026-07-09 in REI BlackBook WebTools Sites.

## Purpose From Wes

Create a site called `Gracious Millionaire` for information related to the book Jenny and Wes are writing. The site should collect contact information from interested parties and send book excerpts when requested.

## REI BlackBook Site Record

| Field | Value |
| --- | --- |
| Site name / nickname | `Gracious Millionaire` |
| REI site type | Generic |
| Site ID | `48842` |
| Current site URL | `http://graciousmillionaire.com` |
| Temporary REI builder URL | `https://u113450.h.reiblackbook.com/generic6/` |
| Control panel | `https://my.reiblackbook.com/webtools/sites/advanced/48842` |
| Site builder | `https://u113450.h.reiblackbook.com/generic6/` |
| Tagline set in merge fields | `A book by Wes and Jenny Browning` |
| Contact name set in merge fields | `Wes and Jenny Browning` |
| Contact email currently set | `WesWill@BuyYourHomeLLC.com` |
| Phone currently set | `919 917 7466` |

## Actions Completed

- Created a new Generic Business Site in REI BlackBook after Wes approved the confirmation warning.
- REI BlackBook warned that the installer would create Web Forms, Optin Popups, Action Sets, and Email Campaigns.
- Waited for the build to finish.
- Renamed the generated site from `Generic6` to `Gracious Millionaire`.
- Saved merge-field data for site name, company/name field, tagline, market, contact name, and phone.
- Verified the Websites page lists `Gracious Millionaire` as a Generic site.
- Imported `graciousmillionaire.com` into REI BlackBook Domains.
- Connected `graciousmillionaire.com` to REI BlackBook site ID `48842`.
- Changed GoDaddy nameservers for `graciousmillionaire.com` from `ns68.domaincontrol.com` and `ns67.domaincontrol.com` to REI's required Cloudflare nameservers: `albert.ns.cloudflare.com` and `arya.ns.cloudflare.com`.
- Re-checked the REI BlackBook nameserver status; REI reported `graciousmillionaire.com is active!`.
- Created `Book Outline` at `https://u113450.h.reiblackbook.com/generic6/book-outline/`.
- Created shared chapter-status page `Chapter Being Edited` at `https://u113450.h.reiblackbook.com/generic6/chapter-being-edited/`.
- Updated the Home page Beaver Builder text to describe the Gracious Millionaire book project and linked the hero button to the outline page.
- Selected safe candidate replacement photos from Wes's logged-in Google Photos session and recorded the replacement map in `working\gracious-millionaire-photo-selection-001.md`.

## Current Content Notes

- Iteration loop: `working\gracious-millionaire-iteration-loop.md`.
- Latest implementation report: `working\gracious-millionaire-iteration-001.md`.
- Current full element cleanup map: `working\gracious-millionaire-element-map-010.md`.
- Book Outline contains the 25 current working chapter titles and links all titles to the shared `Chapter Being Edited` page.
- Chapter content is not published on the site.

## Not Yet Configured

- SSL/TLS readiness for public `https://graciousmillionaire.com`; immediately after nameserver update, DNS resolved to Cloudflare and HTTP redirected, but HTTPS was not completing the TLS handshake yet. REI says DNS/nameserver propagation can take up to 24 hours.
- Remaining default page copy for About, Services/Updates, Contact, Blog, and Thank You.
- Contact form fields and notification routing.
- Excerpt request workflow.
- Email campaign copy for excerpts.
- Consent language for collecting contact information.
- Review of generated Web Forms, Optin Popups, Action Sets, or Email Campaigns.
- Published/mobile QA of the generated site.
- Navigation/menu cleanup, including adding `Book Outline` and renaming/repurposing `Services`.
- Cleanup decision for redundant individual chapter placeholder pages created before Wes clarified that all chapter links can point to the same shared landing page.
- Photo replacement is waiting on Chrome Codex extension local-file upload permission. The selected photo set is local only and should not be committed or pushed without Wes's explicit approval.
- Future GM Mode runs should retry approved Google Photos retrieval, but must avoid the download/open path that launches a separate Microsoft Photos window for each picture. Use Chrome-controlled save/export/download methods only; if Microsoft Photos opens, stop that photo attempt and record the blocker.
- Full element audit found generic template content still present on Services, About, Contact, Blog, Thank You, sidebars, categories, stock images, logo, and footer; see `working\gracious-millionaire-element-map-001.md`.
- First scheduled GM Mode pass changed safe page titles/navigation labels on original template pages: Services -> Book Themes, About -> About the Book, Contact -> Request Updates, Blog -> Editing Notes, and Thank You -> Update Request Received. Remaining generic content is tracked in `working\gracious-millionaire-element-map-002.md`.
- Manual GM Mode rerun replaced the About page Lorem Ipsum, three generic feature headings, and generic CTA with book-focused text. Remaining generic shared/sidebar/footer content is tracked in `working\gracious-millionaire-element-map-003.md`.
- Scheduled GM Mode pass replaced the Book Themes visible heading, six generic service blocks, and generic CTA with book-focused theme text. Remaining generic shared/sidebar/footer content is tracked in `working\gracious-millionaire-element-map-004.md`.
- Scheduled GM Mode pass successfully retried a Chrome-controlled Google Photos download without opening Microsoft Photos, then replaced the Update Request Received visible heading and generic confirmation copy with book-update confirmation language. Remaining generic shared/sidebar/footer content is tracked in `working\gracious-millionaire-element-map-005.md`.
- Wes approved using `outputs\gracious-millionaire-assets\gracious-millionaire-logo-concept-2026-07-09.png` and `outputs\gracious-millionaire-assets\gracious-millionaire-book-cover-concept-2026-07-09.png` in the next GM Mode website run. Prioritize the logo replacement and an appropriate cover visual placement.
- Manual GM Mode run created `outputs\gracious-millionaire-assets\gracious-millionaire-logo-header-2026-07-09.png` as a web-header crop from the approved logo concept, but WordPress upload is still blocked by Chrome Codex extension file access (`Not allowed`). Enable `Allow access to file URLs` under the Codex extension before the next upload attempt.
- Scheduled GM Mode pass on 2026-07-10 changed the Request Updates page footer/sidebar About widget from generic multi-service-company copy to `About the Book` with a book-focused Wes/Jenny description. Public QA passed on the public and preview contact URLs. Other pages still need the same generic About-widget cleanup.
- Manual GM Mode rerun on 2026-07-10 repeated the About-widget cleanup on Book Themes and About the Book. Public QA passed on both pages. Update Request Received and Editing Notes still need the same cleanup; the browser connector timed out while opening the next builder page.
- Heartbeat GM Mode run on 2026-07-10 retried the remaining About-widget cleanup on Update Request Received, but the Chrome builder session timed out before any public change was confirmed. Public QA confirmed Update Request Received and Editing Notes still show the generic About-widget placeholder. Close stale GM builder tabs or restart the Chrome connector before retrying the remaining widget cleanup.
- Heartbeat GM Mode read-only audit on 2026-07-10 confirmed all mapped public pages returned HTTP 200 and found that the visible header logo is correct, but the header still references the old generic REI BlackBook retina logo asset in `data-retina`. Fix the retina logo reference when the header/logo settings path is stable.
- Manual GM Mode run on 2026-07-15 closed a stale builder tab, uploaded the staged web-sized Gracious Millionaire photo set, replaced the Home hero image, placed the uploaded book cover in the homepage card section, replaced two remaining homepage card images with `wes-jenny-building.jpg` and `faith-notes.jpg`, published the changes, and public-QA confirmed the new images on `https://www.graciousmillionaire.com/`. Remaining generic/shared items are tracked in `working\gracious-millionaire-element-map-006.md`.
- Heartbeat GM Mode run on 2026-07-15/16 changed the shared WordPress menu to `Home`, `The Book`, `Themes`, `Journal`, `Updates` and confirmed the new order on the REI preview at desktop and mobile sizes. The custom domain retained the prior cached menu, the REI cache-clear confirmation hung, and the generic retina-logo reference remains; see `working\gracious-millionaire-element-map-007.md`.
- Heartbeat GM Mode run on 2026-07-16 confirmed the navigation had propagated to both hosts, but Beaver Builder and the direct WordPress editor both timed out on The Book page ID `1765`. The Advanced Theme Customizer saved revised footer text, but public QA proved the managed theme continued to render its separate 2026 copyright value. Remaining Book-page stock/broken images and the clean-session continuation path are tracked in `working\gracious-millionaire-element-map-008.md`.
- Heartbeat GM Mode run on 2026-07-16 removed the stale generic retina-logo override through the stable Advanced Theme Customizer path. Public and preview HTML now use the approved header logo with an empty retina override. One clean The Book builder retry still failed to load, so the next run moves to Journal/sidebar cleanup; see `working\gracious-millionaire-element-map-009.md`.
- Heartbeat GM Mode run on 2026-07-16 made all six generic template posts private, deleted the two generic categories, and emptied the shared WordPress Primary Sidebar. Native WordPress confirmed the changes, but both public hosts still served old Journal HTML from the REI page cache. The embedded Journal contact block remains unchanged under the public-contact boundary; see `working\gracious-millionaire-element-map-010.md`.

## Safety Notes

- Do not send excerpt emails, activate broadcasts, or change generated workflows without Wes's explicit approval for that step.
- Before configuring excerpt delivery, identify which excerpts are approved to share and whether requests should be fulfilled by REI BlackBook email campaign, OfficeAssist, or another approved path.
