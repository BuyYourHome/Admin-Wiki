# Pond Street hosting and domain

Wes reported buying `Pondstr.com` from GoDaddy and instructed Smart House to host it through ChatGPT on 2026-10-18. This supersedes the earlier local-only scope for hosting and connecting this purchased domain. No further purchase or live-device work is authorized.

## Hosting configuration

- Provider: ChatGPT Sites.
- Project ID: `appgprj_6ad4d98e08708191858cab113814704e`.
- Hosted URL: https://pondstr.coolnewt4097.chatgpt.site
- Audience: public, authorized by Wes in this chat on 2026-10-23. Visitors do not need to sign in. The owner retains editing access.
- Initial publication succeeded: 2026-10-18T14:43:26Z.
- Initial Site source commit: `f01a688c6167555dfc0474bbdbd43d043b99695d` in the separate Sites source repository. This is not an Admin Wiki commit.
- Initial saved version: `appgprj_6ad4d98e08708191858cab113814704e~appgver_0176b707d1688191be325f28960f58a6`.
- Initial deployment: `appgdep_6ad4dafedea88191934ecd974a287155`.
- Canonical linkage: `site/.openai/hosting.json`.
- Publication checkout: ignored `site/.hosting-work/`. Current publication uses the supported Sites Vinext runtime, gallery code, schema migrations, the eleven supplied concepts, and the featured Media Center video and poster. Never publish the wiki, private records, credentials, or source inventories. The original static page remains as a historical local concept.

## Pondstr.com connection

Custom-domain ID: `appgdom_6ad4db25251c819184c11d38ed7bcbbe`. GoDaddy DNS is configured and publicly verified. At 2026-10-18T15:00:28Z Sites confirmed overall status `active`, provider routing `active`, and SSL `active`. The custom domain is connected at https://pondstr.com .

Exact DNS records returned by Sites on 2026-10-18:

| Type | GoDaddy name | Value |
| --- | --- | --- |
| A | `@` | `162.159.143.30` |
| A | `@` | `172.66.3.26` |
| TXT | `_openai-site-verification` | `openai-site-verification=WB9VsheBIO-J-yOL-iKeCQMeKm8ZHV7xsjywZ4udlfE` |
| TXT | `_cf-custom-hostname` | `5322fd4e-ef21-4c01-80ca-51a38a42160f` |

These are domain-verification DNS values intended for public DNS, not account credentials. No `www` hostname has been added. Do not substitute the subdomain CNAME target for the apex A records.

## Remaining work

Wes completed the domain purchase and asked Smart House to retry. GoDaddy's receipt confirmed `pondstr.com` registration, and its domain DNS editor then became available. The prior missing-domain blocker is resolved.

On 2026-10-18 Smart House replaced the parked apex A record with `162.159.143.30`, added the second required A address `172.66.3.26`, and added the two exact TXT verification records above. All four were read back in GoDaddy after its successful-save notices. Nameservers, SOA, existing `www` and `_domainconnect` CNAMEs, and `_dmarc` were preserved. GoDaddy displayed 600-second TTL for both A records and one hour for the new TXT records.

Public resolver `1.1.1.1` independently returned both correct A addresses and both exact TXT values. At 2026-10-18T14:57:40Z Sites reported provider routing `active` but SSL `pending_validation`. A normal HTTPS check failed to establish SSL; no certificate checks were bypassed.

Completion: the subsequent Sites refresh confirmed active domain routing and certificate. A normal HTTPS request completed certificate validation and received HTTP 401, consistent with owner-private access. Browser verification at https://pondstr.com displayed **Log in to access** and **Continue with ChatGPT**. The sign-in link reached OpenAI login; no credentials were entered. Signed-out delivery of the private site's access page is verified; a fresh owner login inside this browser was not completed. No public-audience change was made. Reuse the existing Sites project and domain record for future changes.

## Windows publication notes

The official `site-workflow.mjs` helper uploaded and packaged the source. Its process required Git Bash and bundled Node on PATH, `TAR_OPTIONS=--force-local` for the Windows archive path, and a process-only `safe.directory` entry restricted to the newly created `.hosting-work` checkout because sandbox-created files had a different Windows owner. No global Git trust configuration was changed. Source credentials stayed in session memory and were passed through hidden stdin; none were written to Git or ordinary files.

## Public access — 2026-10-23

Wes requested removal of the website login requirement so the public can access it easily. The existing Sites project's access mode was changed from owner-only custom access to `public` through the Sites connector. The connector confirmed policy revision 2. An HTTPS request without cookies or authentication to https://pondstr.com/ returned HTTP 200, the expected Pond Street page, and no login gate. This changes visitor access to the existing concept website only; it does not provide device controls, owner records, or editing access. No source rebuild or DNS change was needed.

## Galleries and voting — 2026-10-23

Wes requested Design, Explore, View, and Manage navigation and six room galleries with public voting. The website now uses the supported Sites Vinext Worker runtime and logical D1 binding `DB`, with no R2 binding. Public access and the existing custom domain were preserved. The database migration creates only the vote schema; no synthetic votes were seeded into production.

- Current Site source commit: `98d90b9c6698385308daac33bc9e416a625f4712`.
- Current saved version: `appgprj_6ad4d98e08708191858cab113814704e~appgver_30df629334bc8191a4c47731b977d086` (version 13).
- Current deployment: `appgdep_6adca1f41cc48191adb994090d44fa65`, confirmed `succeeded` at 2026-10-24 8:18 AM Eastern (`2026-10-24T12:18:04.497246Z`).
- Live URL: https://pondstr.com . The original Sites URL remains https://pondstr.coolnewt4097.chatgpt.site .
- Media Center has six supplied color concepts; Front Elevation has two concepts; Garage Barn Door has three concepts. Kitchen, ADU, and Master Bath await images.

The official source helper pushed and packaged the matching built source; the native Sites save/deploy operations confirmed publication. Final read-only checks against the custom domain returned HTTP 200 and zero initial Media Center votes, with secure HTTP-only voter-cookie initialization. Browser verification showed all six Media Center images loaded. Local-only tests covered saving, repeated votes, changing choices, separate visitor totals, missing cookies, invalid choices, empty galleries, and origin rejection. The local preview was stopped after verification.

See [[Project Rooms/Smart House/working/design-galleries-and-voting]] for requirements, voting limits, and validation details. The earlier static page is historical; use the runtime source for future updates. Current portable publication required no Bash or global Git trust changes; credentials remained in memory and hidden stdin.

Wes added the exact black-shutter rendering as another Front Elevation voting choice on 2026-10-23. Version 4 preserves `front-23` and adds `front-black-shutters`, with a two-column desktop comparison and one-column phone layout. The production build passed; local browser checks confirmed saving the new choice and changing between both elevations without increasing the total. A 390-pixel viewport had no horizontal overflow. The live Front Elevation gallery displayed both choices and loaded public vote totals; no production test votes were submitted. No schema, login-policy, or DNS change was needed. The local preview was stopped.

Version 5 adds the supplied TV-Motion-20261023 clip as the main visual above the six Media Center color choices. Public assets: `/media/media-center-art-to-football.mp4` and `/media/media-center-art-poster.png`. The eight-second H.264 clip has native controls, inline playback, looping after manual play, metadata preload, a poster, and no autoplay. It is labeled an illustrative AI motion concept with unvalidated mount mechanics. The official build passed; local and live browser checks confirmed eight-second 1280×720 metadata, playback progress without errors, and play/pause controls. Phone-layout checks showed a 343-pixel player inside a 375-pixel page, no horizontal overflow, and placement above the voting cards. Public access, all voting choices, and the schema are preserved. The local preview was stopped after testing.

Version 6 features Ashley Morello on View, with the business email identified from Wes's Outlook contact, a concise profile based on her official brokerage website, phone, and official website/team links. An AM monogram is used; no unverified portrait is published. The visual notebook is retained in an expandable section.

At Wes's explicit clarification that entry codes are simulated for now, View also includes a date picker, Eastern-time selection, and a generated `DEMO-` code. No real appointment is reserved and no code operates a lock. The page communicates these limits and offers a separate email link to request a real viewing from Ashley. No booking data or personal information is written to the database or sent to Ashley by the demo.

The production build passed. Local browser checks found and resolved a controlled date-input issue; the final native form preserves the selected date/time and generates the corresponding preview. Changing the time clears the previous code. A phone-sized layout had 375-pixel content within a 375-pixel viewport and a 297-pixel calendar with no horizontal overflow. The custom domain displayed Ashley's profile and successfully generated a simulated October 27, 2026, 2 PM Eastern viewing/code preview. No real appointment, message, lock action, or production vote was submitted. See [[Project Rooms/Smart House/working/viewing-and-realtor]] for source and future integration requirements.
Version 7 establishes Pondster as the house identity throughout header branding, metadata, introductions, gallery copy, and footer, preserving the 908 Pond Street address and current domain. It credits Jean Wright as SI designer, exactly as Wes instructed. A persistent public website guide supports typed questions and optional browser speech across Design, Explore, View, and Manage. It can open galleries/pages and change the lighting illustration; it has no live house or owner-system access.

The focused knowledge/routing checks, TypeScript check, and production build passed. Local browser checks verified named Jean answers, Front Elevation navigation, an Evening simulation request, retained conversation across all menus, keyboard close/focus return, and phone fitting without overflow. The published custom domain displayed the Pondster title/brand and answered the Jean Wright prompt. No microphone was opened for testing; actual microphone recognition and audible playback remain unverified end to end and depend on browser support, permission, and the browser speech service. The UI provides explicit listening controls, error/unsupported fallback, typed input, and a speech-service privacy notice. The local preview was stopped after verification. See [[Project Rooms/Smart House/working/pondster-identity-and-guide]].

Version 8 adds Built By between View and Manage, with a direct `#built-by` link. It features Buy Your Home, LLC using its official website: a visually verified copy of the linked header graphic, a short paraphrased company overview and services, Wes Browning at 919-917-7466, and official website/About links. No private data, financing guarantees, or contractor-license claims were added. The original company image is packaged only in the separate Sites repo; the Wiki stores code and source references.

Pondster answers who built it and can navigate to Built By; Wes contact requests open the company page. Focused routing checks, TypeScript checking, and the production build passed. Local browser checks verified the direct link, guide navigation from Manage, the 900-by-270 logo loading, and correct HTTPS and telephone links. Phone preview showed all five menu items within the 375-pixel page, no horizontal overflow, and a 287-pixel logo. The published custom domain displayed the new menu and complete company page. Public access, existing concepts/video, voting, domain, and device boundaries remain unchanged. See [[Project Rooms/Smart House/working/built-by-page]].

Version 9 applies Wes's menu correction: Design, Explore, View, Own, Built By. Manage is renamed Own in the menu, page heading, and Pondster guide actions/copy. The new URL is `#own`; existing `#manage` links remain an alias to Own. The existing guide checks and production build passed. Local browser checks verified both old and new links; the published custom domain displayed the corrected menu order and Own page. No access-policy or owner capability change was made.

## Portrait, anonymous introduction, and voting emphasis — 2026-10-24

Version 10 adds Ashley Morello's unaltered 628-by-628 official brokerage portrait to View and updates her website link to the canonical Howard Hanna profile. The binary is packaged only in the separate Sites repository. The source and retrieval details are recorded in [[Project Rooms/Smart House/working/viewing-and-realtor]].

At Wes's direction, the current public site starts anonymously. The introduction says, “I’m Pondster. I need to start anonymously for now.” The street address was removed from current public page copy, metadata, branding, footer, guide answers, and encoded viewing-request links. The Sites display title is Pondster. This supersedes version 7's public address treatment; internal property association and historical source records are retained. The current built public assets contain no street-address text, and the exterior concepts have no legible property address.

Vote buttons now use the existing warm terracotta background, white bold text, and larger touch targets across all galleries: 14-pixel type on desktop and 16-pixel type on phones, with minimum heights of 52 and 56 pixels. Selected choices retain their dark-green appearance. Voting behavior is unchanged.

Focused guide checks and the production build passed. Local checks verified all five menus without a public address, the guide's coy location response, Ashley's loaded portrait, and the new voting styles. Phone checks showed 375-pixel content in a 375-pixel viewport, a square portrait, and 16-pixel vote text without horizontal overflow. After publication, the custom domain displayed the anonymous title/introduction, loaded the 628-pixel portrait, and rendered terracotta vote buttons with larger bold type. No production test votes, messages, real bookings, or live lock actions were submitted. Public audience and DNS were preserved.

## Public page comments — 2026-10-24

Version 11 adds a separate saved public conversation beneath Design, Explore, View, Own, and Built By, as Wes requested. Visitors can use an optional display name or Guest without signing in. Comments have a 1,000-character limit, plain-text rendering, newest-first ordering, and pagination. The appended `0001_massive_epoch.sql` migration creates the comments table and indexes in the existing D1 binding. See [[Project Rooms/Smart House/working/page-comments]] for scope and limits.

TypeScript checking, the production build, and focused local integration tests passed. Tests cover persistence, page isolation, public response fields, literal text, malformed/oversized/cross-origin requests, exact-retry deduplication, mismatched retries, concurrent cooldown, visitor isolation, and pagination. A preview rejection-path issue was reproduced and corrected by consuming bounded request bodies before rejecting headers; the full integration suite passed afterward. Existing migrations were not replayed.

Local browser checks verified a posted comment surviving reload, literal markup displayed as text, comments on all five menus, and a 345-pixel form inside a 375-pixel phone page with no horizontal overflow. The hosted deployment succeeded, and the custom domain displayed all five comment sections with successfully loaded empty conversations. Production verification created no synthetic comments. Public access, anonymous identity, voting, realtor photo, and existing domain configuration were preserved. The preview was stopped after validation.

## Pondster-only questions — 2026-10-24

Version 12 follows Wes's latest direction to acknowledge **Dean Wright** as SI designer while directing questions only to Pondster. Dean Wright is a static public credit in the introduction, footer, metadata, and guide acknowledgment. The clickable designer credit and designer-focused quick prompt were removed. Voice activation now recognizes only Pondster and its existing phonetic variants; neither Dean Wright nor Jean Wright is a wake name. Legacy typed questions about Jean receive the current Dean credit from Pondster. Every page's comment heading includes an Ask Pondster action, while public comments remain available for visitor thoughts. Realtor viewing arrangements and company contact details are preserved.

The focused guide tests and production build passed, including Pondster wake-name acceptance and designer-name rejection. Local browser checks verified the comment-section question action opening Pondster, the named designer answer in Pondster's voice, and no designer buttons or links. After the successful deployment, the custom domain displayed Dean's static credit and answered the designer question as Pondster. No microphone was enabled, and no claim of live speech recognition testing is made. No production comment, vote, message, booking, or lock action was created. The local preview was stopped after verification.

## Jean Wright and confidential location clarification — 2026-10-24

Version 13 corrects the SI designer credit to **Jean Wright**, as Wes clarified, and replaces ambiguous anonymous-identity copy. Pondster is explicitly the public voice and identity of the house; only the location/address stays confidential. The opening now says: “I’m Pondster, the voice and identity of this house. Ask me about the design ideas and follow my story as it takes shape. My location is confidential for now—think witness protection, with better curb appeal. Jean Wright is my SI designer.”

Guide greetings, identity/location answers, metadata, footer, Built By identity line, and launcher now follow the same distinction. The title is Pondster · A house with a voice, and small public labels say LOCATION CONFIDENTIAL. Jean's credit remains static; questions and voice wake requests still go only to Pondster. Earlier version 12's Dean credit is superseded.

Focused guide tests and the production build passed. Public app/lib source checks found no old designer name, anonymous-identity wording, or property address. Local browser checks confirmed the opening and a 375-pixel phone layout without horizontal overflow. The successful deployment was verified on the custom domain, including the new title, exact introduction, correct Jean credit, and absence of the address and prior name. No comments, votes, messages, bookings, or lock actions were submitted; no microphone was enabled. The local preview was stopped.
