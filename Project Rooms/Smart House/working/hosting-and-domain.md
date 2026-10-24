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

- Current Site source commit: `7024e3b7b8c1723c23c8290f418a4d6ceabde69e`.
- Current saved version: `appgprj_6ad4d98e08708191858cab113814704e~appgver_3839e40551188191b746ab2f3951d2d8` (version 7).
- Current deployment: `appgdep_6adc307597788191a8c32c5400394b2e`, confirmed `succeeded` at 2026-10-24 12:13 AM Eastern (`2026-10-24T04:13:48.838342Z`).
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
