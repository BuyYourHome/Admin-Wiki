# Design galleries and voting

## Requested experience

Wes requested the main menu `Design`, `Explore`, `View`, and `Manage`, with design-choice galleries and public voting for Kitchen, Media Center, Front Elevation, Garage Barn Door, ADU, and Master Bath in this chat on 2026-10-23.

- Design: room selection, image galleries, full-size image viewer, preference voting, and aggregate results.
- Explore: the conceptual lighting demonstration and house-system explanations.
- View: the available approved interior and exterior concepts together.
- Manage: an explicitly planned owner-information area; no live administration, private data, or house control is exposed.

## Image scope

Front Elevation uses concept 23; Garage Barn Door uses concepts 06, 07, and 08. Wes supplied six Media Center concepts on 2026-10-23 from `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\26-BYH -908 Pond St\Owning\Planning\Entertainment-Color-Options-20261023`. Read `website-assets.json` and `COLOR-NAMES.txt` for source captions. The long descriptive names and short numbered aliases are byte-identical; display six choices, not twelve. Keep the baseline as a source reference rather than a seventh voting option.

The Media Center choices pair warm ivory cream with mushroom taupe, dusty sage with pale cream, navy with greige, mushroom taupe with ivory, olive with sand, and charcoal with terracotta clay. Accent colors refer only to the central TV backdrop; surrounding walls stay warm off-white and the honey-toned wood floor stays unchanged. These are concept names, not manufacturer paint specifications.

Kitchen, ADU, and Master Bath still need design images; show honest empty states and no voting for invented choices. Concepts remain labeled as AI studies, not measured drawings or current-condition photos. Keep source binaries outside Admin Wiki Git and package selected copies only in the dedicated Sites source repository.

## Vote behavior

The site stays public. Voting requires no ChatGPT login and collects no names, email addresses, or IP addresses in the vote table. A random, site-scoped HTTP-only cookie identifies one browser. There is one current choice per browser per gallery; choosing a different design replaces that browser's earlier choice. Clearing cookies or using another browser can produce another vote; this is a preference poll, not verified one-person voting.

Use the Sites D1 `DB` binding for durable shared vote records. The `design_votes` table has a composite primary key of gallery and browser voter key, with design ID and update timestamp. Initialize the voter cookie while loading totals before enabling voting; a vote without that cookie requires a page reload. Preserve the cookie even on an error response so a retry after an uncertain save reuses the same key. Reject unknown galleries, choices outside the selected gallery, malformed or oversized submissions, and cross-origin writes. Return no browser identifiers in public totals. Do not create database tables during requests; use generated schema migrations.

## Source and operation

Authored application, gallery catalog, schema, and local-only API regression tests are under `site/gallery-source/`. The supported Sites Vinext runtime and complete publication source live in the separate Site repository at ignored `site/.hosting-work/`; preserve project ID, Pondstr.com, and public access. Images remain outside Admin Wiki Git. Record generated migrations with the authored source before publishing. Never run write tests against the production vote database.

The original buildless `site/index.html` is the earlier local concept; the new application is served by the Sites runtime. Use the runtime preview for current gallery and voting development.

## Verification — 2026-10-23

- TypeScript check and official Sites production build passed.
- The local D1 migration creates only `design_votes` and its composite primary key. The SQL, snapshot, and journal are preserved under `site/gallery-source/drizzle/`.
- Local API checks passed for GET cookie initialization, missing-cookie rejection, saved votes, repeated submissions, changed votes, separate visitors, cookie preservation on errors, invalid choices, empty galleries, and cross-origin rejection.
- Browser checks passed for public voting, changing and reloading a vote, full-size viewing, pending Kitchen content, all four main menus, and the lighting simulation. A 390-pixel viewport had no horizontal overflow; its temporary viewport override was reset.
- Production verification is read-only. Test votes stay in the separate local database; no synthetic votes were added to the live poll.

The cookie is browser storage, not proof of a person. Simultaneous first-page initialization, cookie replacement, clearing cookies, other browsers, and the alternative hosted origin can create another identity. Use these totals as informal design preferences.
