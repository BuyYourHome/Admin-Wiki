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

- Current Site source commit: `5a726bc9f4450fdc5097b89ced336745007dfc6e`.
- Current saved version: `appgprj_6ad4d98e08708191858cab113814704e~appgver_c9afbb5479408191aab34655d820cd5d` (version 29).
- Current deployment: `appgdep_6ade4b4b255c8191923430ff1df7d6f2`, confirmed `succeeded` at 2026-10-25 2:32 PM Eastern (`2026-10-25T18:32:53.319989+00:00`).
- Live URL: https://pondstr.com . The original Sites URL remains https://pondstr.coolnewt4097.chatgpt.site .
- Media Center has six supplied color concepts; Front Elevation has two concepts; Garage Barn Door has three concepts; Master Bath has six color studies. Kitchen, ADU, Spiral Staircase, and Back Deck await images.

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

## Fixed-frame Media Center video replacement — 2026-10-24

Wes supplied `908-Pond-TV-Opening-Frame-Fixed-Moving-Football.mp4`, found in the existing property TV-Motion source folder. Version 14 replaces the featured Media Center player source with `/media/media-center-fixed-frame-football.mp4`, above the same six voting choices. The supplied 2,412,141-byte binary is unchanged; its copied SHA-256 matches `82896b300e815f23baa13a63e467afa1dd9aa0d4f3af641d5e5365b11c6b8906`. No video binary is stored in Admin Wiki Git.

The revised ten-second clip keeps the decorative wall frame in place while the TV moves and the artwork transitions to moving football footage. Duration copy and Pondster's guide answer now describe this revision. The original poster visually matches the new opening. Native controls, inline playback, looping after manual play, metadata preload, and no autoplay remain. The caption retains the illustrative-composite and unvalidated-mount limits.

The exact supplied clip preserves its ending source credit. The near-player caption adds the verified U.S. Marine Corps / Sgt. James Stanfield credit, direct DVIDS source link, and official non-endorsement disclaimer/use-notice link. The official source page identifies the footage as public domain; its copyright page provides the required notice. See [[Project Rooms/Smart House/working/source-inventory#Media Center fixed-frame moving-football revision — 2026-10-24|the new source record]].

The focused guide checks and production build passed. Local browser metadata confirmed 10 seconds and 1280×720, with advancing playback, moving football, matching opening/poster, and no media error. Phone checks showed a 343-pixel player within 375-pixel content and no horizontal overflow. After the successful deployment, the custom domain loaded the new exact media URL, confirmed ten-second 1280×720 metadata, and played without error; the player was paused after verification. Credits and the unchanged binary are preserved; browser seeking did not verify the final credit frame separately. No production comments, votes, messages, bookings, lock actions, or microphone use occurred. The local preview was stopped.

## First-person house voice and kitchen-view caption — 2026-10-24

Version 15 follows Wes's instruction that the site's wording come from Pondster, including “Meet Ashley, my realtor.” Narrative copy across Design, Explore, View, Own, and Built By now uses I, my, and me, including gallery descriptions, comments guidance, guide replies, notices, metadata, and accessible descriptions. Visitor-authored comments, the visitor-composed viewing-request email, proper names, neutral form/navigation labels, source credits, and the exact required non-endorsement notice retain their appropriate authorship. Jean Wright remains a static SI designer credit; Pondster remains the only question recipient and voice wake name. The location-confidential introduction and witness-protection joke remain.

Wes also supplied the kitchen-view scrolling-caption clip. The featured Media Center player now uses `/media/media-center-kitchen-view.mp4`, a web copy with the scrolling caption “My TV automatically extends and turns toward my kitchen for better viewing.” The supplied original is untouched. The ten-second 1280×720 silent H.264 copy retains the fixed decorative frame, TV movement, moving football, and ending footage credit. The existing poster still matches the opening. Source paths, hashes, and sizes are recorded in [[Project Rooms/Smart House/working/source-inventory]]. No video binary is stored in Admin Wiki Git.

Focused guide and comments checks, TypeScript checking, and the final production build passed. Full decoding of the new media passed; inspected middle and final frames show the first-person caption and retained credit. Local browser checks covered all five pages and a typed realtor question answered by Pondster. A 390-pixel phone preview had 375-pixel content, a 351-pixel guide panel, and a 261-pixel launcher within the content area. Local video metadata confirmed ten seconds and 1280×720.

The official Sites helper pushed and packaged the matching source, and Sites confirmed version 15 deployed successfully. Live browser verification at https://pondstr.com showed the new first-person title and opening, loaded the new video URL with ten-second 1280×720 metadata, and advanced playback without a media error. The live View page displayed “Meet Ashley, my realtor” beside Ashley's loaded portrait. A screenshot was saved outside Git for the completion response. No production comments, votes, messages, appointments, lock actions, or microphone use occurred; public audience and DNS are unchanged.

## Header prominence and animated logo — 2026-10-24

Version 16 removes the forced break in View's “Come meet me” heading and keeps it on one line on desktop. The shared header now features a much larger serif Pondster wordmark, subordinate tagline, and larger P/HOME monogram. A gentle seven-second light sweep and glint give the mark movement; reduced-motion CSS disables both animations and the hover lift. No new image, dependency, or JavaScript animation was added.

The production build passed. Browser checks at 1280 and 760 pixels confirmed a one-line heading and room between the enlarged brand and navigation. A 390-pixel phone preview had 375-pixel content without horizontal overflow, all five menu items, and a 40-pixel wordmark. Computed transforms changed between observations, confirming the logo animation was running; the reduced-motion override was reviewed in source. No microphone or production writes were used for testing.

The official Sites helper pushed and packaged the exact built source, and Sites confirmed version 16 deployed successfully. The custom domain displayed the larger wordmark and single-line heading, with the logo animation applied. A live screenshot was saved outside Git for the completion response. Public audience, domain, voting, comments, first-person narrative, and house-system boundaries are preserved. The local preview was stopped after verification.
## Media Center autoplay — 2026-10-24

Wes requested automatic video playback. Version 17 adds native `autoPlay` and `muted` to the existing Media Center video, retaining looping, inline playback, manual controls, the poster, and the same silent kitchen-view clip. This supersedes the prior no-autoplay behavior. Browser preferences and media policies can still require manual play.

The production build passed. In the local browser, playback started when the player entered the visible page, without pressing Play. After successful deployment, the custom domain likewise showed autoplay and muted enabled, looping retained, `paused: false`, advancing time, and no media error after scrolling the player into view. A live screenshot was saved outside Git. No database writes or microphone access were used. The owned local preview was stopped after verification.

## Garage Barn Door featured video — 2026-10-24

Wes supplied the inward-entry/sliding-left/Tesla concept clip. Version 18 features it above the same three Garage Barn Door voting choices, titled “Watch me make an entrance.” The player uses muted autoplay, looping, inline playback, native controls, a matching first-frame poster, and a 5:2 panoramic aspect ratio. Pondster answers barn-door video and Tesla-animation questions with this gallery. The introduction and accessible description remain in Pondster's first-person voice and explicitly label the motion an illustrative AI/composited concept with unvalidated hardware/clearances.

The supplied original is untouched. The web copy uses three first-person captions while preserving the 16-second sequence, fixed facade/camera, door movement, Tesla reveal, and 1600×640 framing. Public assets are `/media/garage-barn-door-tesla.mp4` and `/media/garage-barn-door-poster.jpg`; exact source and derived-copy hashes/sizes are in [[Project Rooms/Smart House/working/source-inventory]]. Binaries are packaged only in the separate Sites source repository.

Focused guide checks and the production build passed. Source and derived video fully decoded; reviewed sample frames showed readable first-person captions and no legible address or plate. Local browser checks confirmed 16-second 1600×640 metadata, automatic muted playback without a media error, and three existing voting cards. At a 390-pixel phone viewport, the 343×137-pixel player fit within 375-pixel content without horizontal overflow.

The official helper pushed and packaged the matching source; Sites confirmed version 18 deployed successfully. The custom domain loaded the exact new video URL, reported the same metadata, and played automatically while muted. The live garage gallery and first-person caption were visually verified, with a screenshot saved outside Git. No production comments, votes, messages, appointments, house controls, or microphone use occurred. Public audience and DNS are preserved; the owned preview was stopped and temporary tab closed.

## Early-buyer design paragraph — 2026-10-24

Version 19 adds Wes's requested buyer-design paragraph near the top of View, between the introduction and Ashley/viewing cards. Pondster invites buyers who purchase while the house is taking shape to have a say in final design, limited to finishes and details still open for selection. The paragraph directs buyers to Ashley for available choices and timing. Exact wording is preserved in [[Project Rooms/Smart House/working/viewing-and-realtor]]. A soft background and accent rule make the invitation visible without changing the page's existing behavior.

The production build passed, and the official Sites helper pushed and packaged the matching source. Sites confirmed version 19 deployed successfully. The published custom-domain View page displayed the complete paragraph above Ashley's portrait and the viewing preview. A 390-pixel phone check showed a 345-pixel paragraph, 15-pixel text, and 375-pixel content without horizontal overflow. A desktop screenshot was saved outside Git for the completion response. No booking, message, comment, vote, or house-system action was performed; public audience and DNS are preserved.

## Scroll-to-expand video — 2026-10-24

Wes chose expansion when scrolling to videos, rather than hovering. Version 20 applies a shared ScrollVideo wrapper to the Media Center and Garage Barn Door clips. As a video's stable gallery frame crosses the middle of the viewport, its player fills the browser window. Scrolling past releases it naturally; Back to my gallery, Escape, or focusing the next gallery item also dismisses it. Manual dismissal suppresses immediate reopening until the source frame leaves and re-enters the activation area. This uses no browser Fullscreen API, scroll lock, automatic focus capture, or new dependency.

The original video element stays mounted so playback position and pause state survive expansion. The normal-flow aspect-ratio frame keeps page height stable. Expanded playback uses contain fitting, including letterboxing for the panoramic garage film. Native controls and existing mute/autoplay/loop behavior remain. Reduced-motion CSS removes the reveal animation. An already-open Pondster panel prevents expansion so listening/stop controls remain visible; while a video is expanded, the floating launcher is temporarily hidden to clear native playback controls, then restored on release. Existing figure captions, source credits, and disclaimers remain in the gallery.

The production build, TypeScript check, and focused read-only code review passed. Local browser checks verified expansion and return, unchanged page height (3,890 pixels), pause at 6.151719 seconds preserved through return and re-entry, Escape, dismissal suppression, switching galleries, automatic playback, and phone fitting without overflow. At 390×844, the uncropped garage stage measured 375×844 within 375-pixel page content; Tab moved to the next design and released the stage. A genuinely open Pondster panel prevented expansion while the source frame was inside the activation area. Reduced motion was reviewed in source, not emulated in the browser.

The official Sites helper pushed and packaged the matching source, and Sites confirmed version 20 deployed successfully. At the custom domain, scrolling activated a 1165×828 stage matching the browser content viewport, playback advanced, and native fullscreen remained false. Scrolling past restored the gallery and visible launcher. A live screenshot was saved outside Git. No production comments, votes, messages, bookings, device actions, or microphone use occurred. The owned preview was stopped and its temporary tab closed; public access and DNS are unchanged.

## Tesla drive-out and white-marble garage replacement — 2026-10-24

Wes supplied `908-Pond-Barn-Door-Tesla-Drives-Out-White-Marble.mp4`. Version 21 replaces the featured Garage Barn Door clip with the 25-second revision at `/media/garage-barn-door-tesla-drive-out.mp4`, using `/media/garage-barn-door-drive-out-poster.jpg`. Its opening matches the earlier poster; the longer sequence adds the white Tesla driving forward, moving across the scene toward screen-left, and leaving the white-marble garage floor visible. The fixed facade and exterior concrete stay unchanged. The page title is “Watch me open up.” The duration, accessible description, concept caption, and Pondster guide response now describe this revision. The three existing voting choices, native controls, muted autoplay, looping, panoramic ratio, and scroll expansion are preserved.

The supplied source remains untouched. The derived web copy changes only the existing three caption bands to Pondster's first-person wording, leaving later car movement without additional overlays. All 750 frames of the source and web copy decoded successfully at 1600×640, 30 fps, H.264, silent. Source and derived hashes, sizes, captions, and sample findings are recorded in [[Project Rooms/Smart House/working/source-inventory]]. The source README describes an illustrative composite, not validated clearances or a turning-radius study; the public caption retains that limit. No video binary is stored in Admin Wiki Git.

Focused guide checks and the production build passed. The official Sites helper pushed and packaged the matching source; Sites confirmed version 21 deployed successfully. Live browser checks loaded the exact new URL, confirmed 25-second 1600×640 metadata, and observed muted automatic playback with advancing time and no media error in the expanded stage. Existing scroll expansion had already passed its desktop and phone checks in version 20 and remains unchanged. No production comments, votes, messages, appointments, house-system actions, or microphone use occurred. Public access and DNS are unchanged.

Wes also clarified that routine website updates do not need separate conversational approval for every step. This standing preference is recorded within the Smart House README; required native permission boundaries remain in force.

## Spiral Staircase and Back Deck galleries — 2026-10-24

Version 22 appends Spiral Staircase and Back Deck as Design galleries 07 and 08. The intro and Pondster guide derive their gallery counts from the eight-entry catalog. The guide recognizes staircase/stairs and back/rear deck wording and opens the matching gallery. The 11 existing choices remain unchanged.

A filename/folder search of all 94 property Planning files found no identifiable images for either new gallery. Both therefore display Pondster's first-person coming-soon state, without invented design choices or voting controls. The source search and pending images are recorded in [[Project Rooms/Smart House/working/source-inventory]].

The focused guide checks and production build passed. The official Sites helper pushed and packaged the matching source, and Sites confirmed version 22 deployed successfully. At the custom domain, both new galleries opened with the correct headings and pending-image messages. A 390-pixel phone check showed all eight navigation entries, 375-pixel page width, and no vote buttons for the empty Back Deck gallery. Pondster's typed “Show spiral stairs” request opened Spiral Staircase and correctly explained that images are still to come. No production votes, comments, messages, appointments, device actions, or microphone use occurred. Public access and DNS are unchanged.

## Explore house and room features — 2026-10-24

Version 23 adds six house-wide feature summaries and cards for all eight current Design spaces, with first-person feature lists and links to the matching galleries. The labels distinguish current website capabilities, design concepts, and plans. No unverified installed equipment, dimensions, construction approvals, or final material selections are asserted. Shared `lib/features.js` supplies both the Explore cards and Pondster's room-feature answers. See [[Project Rooms/Smart House/working/explore-features]] for content scope and sources.

The lighting simulation remains below the feature cards. A requested lighting scene opens Explore, waits for navigation to render, then scrolls to and focuses the lighting section. Design links preserve the existing pending-vote room guard. Public comments remain beneath Explore.

The existing guide suite, all eight feature-request checks, TypeScript check, and final production build passed. Local browser checks confirmed six house summaries, eight room cards, a matching Back Deck gallery link, lighting changes, and a cross-page Evening request bringing the correct simulation into view. At 390 pixels, room cards were 345 pixels wide inside a 375-pixel page without horizontal overflow. The official source helper pushed and packaged the matching source, and Sites confirmed version 23 publication. The custom-domain Explore page displayed all eight named room cards; a live screenshot was saved outside Git. No production votes, comments, messages, bookings, device actions, or microphone use occurred. Public access and DNS are unchanged.

## Growing vine and logo fireworks — 2026-10-24

Version 24 adds Wes's requested stylized growing vine and fireworks to the shared Pondster header. A decorative inline SVG draws a curling stem around the P/HOME monogram and beneath the wordmark, opens seven leaves, then shows two small brass/terracotta firework bursts. The entrance finishes within 4.8 seconds, leaving the vine grown. Pointer entry or keyboard focus replays the artwork. The earlier monogram sweep/glint now also runs once. Reduced-motion CSS displays the still vine and hides fireworks.

The artwork is hidden from assistive technology, ignores pointer input, and adds no dependency, external asset, timer, or network action. TypeScript checking and the production build passed. Local browser checks verified a freshly replayed stem offset, a visible firework frame, the settled vine, and keyboard replay. At a 390-pixel viewport the page stayed 375 pixels wide, the artwork's right edge was 289 pixels, and all five menu links remained available. Reduced-motion behavior was reviewed in source; browser preference emulation was not used.

The official Sites helper pushed and packaged the matching source, and Sites confirmed version 24 publication. The custom domain loaded the seven leaves and two bursts with all five menu links intact. A live logo screenshot was saved outside Git. Existing pages, public audience, domain, and house-system boundaries are unchanged.

## Named voting buttons — 2026-10-24

Version 25 moves each design choice's name into its vote button and removes the separate card title, as Wes requested. The name is the button's primary line in loading, saving, available, and selected states; the smaller second line retains the action/status. Long names can wrap. Each card is still named accessibly through its button's title, and selected buttons expose their pressed state. Gallery headings, concept numbers, descriptions, images, and full-size image labels remain.

The production build passed. Local browser checks confirmed all six Media Center button names, no separate card headings, a selected Black shutters choice, and changing that choice to Warm welcome while preserving its name. At 390 pixels, the page stayed 375 pixels wide and the 303-pixel comparison buttons used 18-pixel name text. The official helper pushed and packaged the matching source; Sites confirmed version 25 publication. Live read-only verification displayed both Front Elevation names inside their buttons, with no duplicate card headings, and a screenshot was saved outside Git. No production votes were submitted. Vote storage, current design IDs, public access, and DNS are unchanged.

## Voting buttons above pictures — 2026-10-24

Version 26 moves each existing named vote button to the first child of its design card, immediately above the image. Tablet buttons span both image/content columns, while desktop and phone cards keep their normal vertical order. The button remains full width, including a future single-choice gallery. Names, selected/disabled states, accessible labels, handlers, and stored votes are preserved.

The production build passed. Local browser checks at desktop, 1000-pixel tablet, and 390-pixel phone widths confirmed each button's bottom edge equals its image's top edge. At tablet width, buttons filled both columns and image/content began together below; phone content remained 375 pixels wide without overflow. The official helper pushed and packaged the matching source, and Sites confirmed version 26 publication. Live Front Elevation checks confirmed both buttons directly above their pictures; a screenshot was saved outside Git. No production votes were submitted. Public access and DNS are unchanged.

## Four owner-requested smart-house plans — 2026-10-24

Version 27 adds Wes's four requested capabilities at the start of Explore's house feature list: natural-gas tankless hot water with whole-house recirculation; multiple-person proximity sensing and automatic TV direction between kitchen/living room; personalized voice-activated bath filling with preferred temperature/full-level shutoff and voice-start shower; and exterior cameras following individuals with an indoor TV surveillance view. All four are labeled `IN MY PLANS` and use Pondster's first-person voice. Kitchen, Media Center, Front Elevation, and Master Bath receive relevant feature bullets. Ten house summaries and the original eight room cards remain. The direct owner requirements and confirmation gaps are preserved in [[Project Rooms/Smart House/working/explore-features]] and [[Project Rooms/Smart House/working/source-inventory]].

Shared `systemFeatures` content also supplies Pondster's public explanations. Topic matching precedes generic voice/privacy and room navigation, while private-record/credential/feed requests and unknown specifications retain their boundaries. An operation request describes the plan and states that the website cannot operate systems or show live camera feeds. This publication configures no heater, sensor, TV, bath, shower, camera, recognition method, or house integration.

The focused guide suite, new planned-system/boundary checks, TypeScript check, and production build passed. Local browser checks confirmed the ten house summaries, eight room cards, 375-pixel page width at a 390-pixel viewport, and a typed bath request receiving the planned recognition/temperature/full-level description with a no-operation explanation. The official source helper pushed and packaged the matching source; Sites confirmed version 27 publication. The custom-domain Explore page displayed all four new headings and their planned labels; a live screenshot was saved outside Git. No production votes, comments, messages, appointments, microphone use, or live device actions occurred. Public audience and DNS are unchanged.

## Voice control repair — 2026-10-24

Version 28 repairs browser voice lifecycle and feedback following Wes's failure report. **Ask by voice** captures one explicitly addressed question without a wake-name requirement. Visitors may separately choose **Keep listening for “Pondster”**. The public guide shows recognized words, explains unmatched named requests, and distinguishes microphone permission, missing microphone, blocked service, network failure, unsupported API, and stalled startup. Preparing output and actual speech have truthful states; Stop works during either, including browsers with speech output but no recognition. Close, Escape, tab hiding, stale callback protection, bounded silence reconnection, and startup/playback watchdogs are covered. See [[Project Rooms/Smart House/working/pondster-identity-and-guide]].

Deterministic browser-engine tests, the existing guide suite, TypeScript checking, and production build passed. Local browser checks confirmed the two modes without activating listening, typed Jean Wright credit, Escape/focus recovery, and a 351-pixel panel within 375-pixel phone content at a 390×844 viewport. The official source helper pushed and packaged the matching source, and Sites confirmed successful publication. The custom-domain page displayed the new controls and instructions; a screenshot was saved outside Git.

No live microphone or audible-output test was performed, so the particular browser/service failure experienced by Wes remains unverified. No microphone permission was granted and no ambient audio was captured. The repair adds no audio-upload endpoint, transcript storage, paid speech provider, house-system connection, or designer persona. Public audience, domain, votes, comments, and simulated viewing remain as before.

## Master Bath color voting — 2026-10-25

Version 29 adds six Master Bath voting choices: Warm Ivory, Soft Dusty Blue, Deep Navy, Forest Green, Mushroom Taupe, and Muted Terracotta. Wes's selected sage layout and original framing photo are saved beside the six full-resolution PNG studies and web JPEGs in the verified property Planning folder `Master-Bath-Color-Options-20261025`. The sage baseline is a saved reference rather than a seventh vote. Exact paths, palette pairings, prompts, hashes, and design intent are recorded in [[Project Rooms/Smart House/working/master-bath-color-concepts]] and [[Project Rooms/Smart House/working/source-inventory]]. No image binary enters Admin Wiki Git.

The six `/concepts/master-bath-*.jpg` images preserve the refined three-plane layout, granite, gold accents, concealed cove lighting, and corrected mirror mapping. Each is 1672×941 and about 300–323 KB, encoded without cropping or resizing. Shared catalog entries supply the gallery and vote allowlist, Explore's room features, and Pondster's guide. Explicit room wording takes priority over overlapping color names. Existing 11 choices are unchanged, for 17 choices across eight galleries. No vote schema migration is needed.

Visual review, TypeScript, focused guide checks, complete local vote API regression, and production build passed. Local browser checks loaded all six images, changed a Warm Ivory vote to Deep Navy, opened the full-size viewer, and confirmed 345-pixel cards inside 375-pixel content at a 390-pixel phone viewport. A deliberate cross-origin probe is rejected by Vite before the JSON route; the local test handles only that exact plain-text 403 and requires JSON for other responses. Test votes remained local.

The official source helper pushed and packaged the matching source; Sites confirmed version 29 deployed successfully. A fresh custom-domain check showed all six named voting cards, zero current Master Bath votes, correct guide navigation and choice list, and the first-row images. A live screenshot was saved outside Git. No production vote, comment, booking, microphone access, or house-system action occurred. Public audience and DNS are unchanged.
