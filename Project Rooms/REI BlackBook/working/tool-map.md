# REI BlackBook Tool Map

Observed 2026-07-09 in an authorized logged-in Chrome session as `Jean (Wes)`.

## Access And Safety

- Use Chrome connector control for REI BlackBook work whenever possible.
- Do not use blind desktop keystrokes or SendKeys on Wes's three-screen computer. If the connector is unavailable, stop and ask Wes to bring the target browser window forward or restore connector access.
- Login is available through Chrome Password Manager. Do not record passwords, session cookies, recovery codes, or other secrets in this project room, wiki, scripts, or commits.
- Treat REI BlackBook as a live production system. Do not save, publish, delete, deactivate, clear domains, clear website cache, send texts, send broadcasts, change workflows, change DNS, purchase ListHQ plans, or change account settings without explicit approval for that specific action.

## Top Navigation

| Area | Main Tools Observed | Notes |
| --- | --- | --- |
| Contacts | Smart Contacts, Legacy Contacts | Smart Contacts opened but did not expose much readable content in the connector pass. Needs deeper workflow-specific discovery before contact changes. |
| Tasks | Tasks | Add task, assign, due date/time, task type, contact/property/project tagging, mark complete, delete. Deleting or completing tasks requires approval unless Wes specifically asks. |
| Deals | Deals New, Pipelines New, Legacy Property Pipeline, Multi Offer Generator, Equity Analyzer, Property Search, Property Finders | Deals page has New Deal action. Deal or property changes require workflow-specific confirmation. |
| Marketing | Workflows, Callflows, Campaign Tracker, Broadcasts, Inbox, Outbox | Workflows and callflows can affect automated contact handling. Broadcasts, inbox/outbox, calls, texts, and workflow changes require explicit approval. |
| Web Tools | Domains, Websites, Landing Pages, Web Forms, Optin Popups, Classified Engine | Current primary work area. Websites is at `https://my.reiblackbook.com/webtools/sites`. |
| Resources | Quick Start Guide, Webinar Replays, Open Office Hours, Animation Library, Content Library | Reference and training materials. |
| Academy | New Academy, Marketing Budget Calculator, Property Alerts, Accelerators, Bootcamps | Training and marketing/planning tools. |
| Properties | All Properties, My Prospecting List, Imports | Add/import/filter properties. Imports and record changes require approval. |
| ListHQ | ListHQ New | Lead-list subscription/plan page. Activation or paid plan changes require explicit approval. |
| Account Menu | My Account, My Team, Marketing Profiles, System Settings, Deal Settings, Log Out | Account, team, and settings changes require explicit approval. |

## WebTools Sites

Main URL: `https://my.reiblackbook.com/webtools/sites`

Observed controls:

- `Create New Site` / `Add Website`
- Per-site `Control Panel`
- Per-site `Site Builder`
- Per-site hidden destructive links for deactivate and delete
- FAQ/help links for logo and content editing

Existing sites:

| Site | Type | Public URL | Site ID | Control Panel | Builder |
| --- | --- | --- | --- | --- | --- |
| BYH | Authority | `https://buyyourhomellc.com/` | `36859` | `https://my.reiblackbook.com/webtools/sites/advanced/36859` | `https://u113450.h.reiblackbook.com/authority2/` |
| Providence Landing | Generic | `https://providence-landing.com/` | `43476` | `https://my.reiblackbook.com/webtools/sites/advanced/43476` | `https://u113450.h.reiblackbook.com/generic3/` |
| Personal Brand | Generic | `https://mybrowning.net/` | `43808` | `https://my.reiblackbook.com/webtools/sites/advanced/43808` | `https://u113450.h.reiblackbook.com/generic4/` |
| Landing Pages | Blank | `https://buyyourhomeraleigh.com/` | `46796` | `https://my.reiblackbook.com/webtools/sites/advanced/46796` | `https://u113450.h.reiblackbook.com/blank5/` |

## BYH Site Control Panel

Site: BYH / Authority / `buyyourhomellc.com`

Primary control-panel sections:

| Section | URL | Purpose Observed |
| --- | --- | --- |
| Site Details | `https://my.reiblackbook.com/webtools/sites/advanced/36859` | Domain assignment, merge-field data, site nickname, company name, tagline, market, contact details. |
| Manage Pages | `https://my.reiblackbook.com/webtools/sites/advanced/36859/pages/#view` | Add/manage pages and page content. Includes Add New Page and Save controls. |
| Manage Blog | `https://my.reiblackbook.com/webtools/sites/advanced/36859/blog/#view` | Add/manage blog posts, categories, and tags. |
| Edit Menu | `https://my.reiblackbook.com/webtools/sites/advanced/36859/menu/#view` | Menu/navigation editing. |
| Edit Theme | `https://my.reiblackbook.com/webtools/sites/advanced/36859/theme/#view` | Theme customization, basic/advanced options, image upload. |
| Tracking Codes | `https://my.reiblackbook.com/webtools/sites/advanced/36859/analytics/#view` | Google Analytics and Facebook tracking-code fields; add tracking code to site. |

Common control-panel actions:

- `< Go Back`
- `Clear Website Cache`
- `Edit Site in Builder`
- `Update Domain`
- `Clear Domain`
- `Save Merge Field Data`
- `Save`, `Save & Publish`, `Save & Close`, `Save & Edit`

Observed BYH merge-field details:

- Company Name: `Buy Your Home, LLC`
- Site Tagline: `Wes Will Buy Your Home`
- Contact Name: `Wes Browning`
- Contact Email: `WesWill@BuyYourHomeLLC.com`
- Phone Number: `919 917 7466`
- Business Address includes `2156 Haig Point Way`, `Raleigh`, North Carolina details visible in the form.

## Other Web Tools

| Tool | URL | Observed Purpose |
| --- | --- | --- |
| Domains | `https://my.reiblackbook.com/services/domains` | Domain inventory/search. Page showed no separate domain list in the first pass, while site control-panel domain dropdown showed several domains and statuses. |
| Landing Pages | `https://my.reiblackbook.com/webtools/pages` | Landing-page list with published/unpublished filters and `Add Landing Page`. |
| Web Forms | `https://my.reiblackbook.com/forms/details` | Web form builder with `New Web Form`, filters by active/inactive and website, and create form modal. |
| Optin Popups | `https://my.reiblackbook.com/forms/optins` | Optin popup builder with `New Optin Popup`, filters by active/inactive and website, and create popup modal. |

## First-Pass Non-WebTools Notes

- Tasks can create and manage assigned tasks tied to projects, contacts, properties, email templates, and due dates.
- Deals page exposes `New Deal`; pipeline and offer tools need deeper mapping before use.
- Marketing Workflows are under system settings and should be treated as automation infrastructure.
- Profit Dial Inbox redirected to calls view and showed call-detail/no-number areas.
- Properties supports importing and adding properties plus filters and saved views.
- ListHQ is a lead-list plan/activation area; do not activate or change plans without Wes's explicit approval.

## Discovery Still Needed

- Deeper Smart Contacts workflow map.
- Actual page inventory for each existing site.
- Site builder editing model for Authority, Generic, and Blank sites.
- Form routing, notification recipients, and connected workflows for web forms and opt-in popups.
- Published/mobile QA checklist for each active public site.
- Marketing workflow/callflow inventory, only after Wes asks for those workflows.
