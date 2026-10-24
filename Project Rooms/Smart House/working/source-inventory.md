# Source inventory

| Source | Status | Use |
| --- | --- | --- |
| Central message prmsg-jean-create-pr-smart-house-20261016-001 | Hash and exact destination verified; Accepted then Processing | Setup authority and scope |
| Jean's Voice task 019fbe57-fcd9-7c83-be74-e377c7b9c4d0; 16 relevant planning turns | Read via app; preserved in sources/planning-conversation-2026-10-16.md | Original requirements and discussion |
| working/planning-context.md | Derived brief with source provenance | Continuation context, not new authority |
| Project Rooms/LED lighting/README.md | Read-only reference reviewed | Lighting owner/scope; technical specifications not inventoried |
| Project Rooms/Home Assistant/README.md | Read-only scope reference reviewed | Integration/configuration owner |
| 908 Pond Street Teams records/diagrams | Reported by Wes; exact paths not yet verified | Future authorized source review |

## Exterior design images — 2026-10-18

Authoritative external asset folder: [Exterior Design Concepts 2026-10-18](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/Shared%20Documents/Property/26-BYH%20-908%20Pond%20St/Owning/Planning/Smart%20House/Exterior%20Design%20Concepts%202026-10-18).

Jean Wright supplied this location in the owning chat. Smart House independently verified the four named files through the SharePoint connector on 2026-10-18. Per Wes's correction relayed by Jean, only these four belong to this intake. Originals remain outside Git; no upload was repeated.

Highlighted AI visual concepts:

- `06-wall-warm-white-board-batten.png`
- `07-wall-charcoal-green-board-batten.png`
- `08-wall-limewashed-brick.png`
- `23-front-final-with-garage.png`

These are design explorations, not photographs of completed work, measured construction drawings, as-built records, or confirmation of selected materials. A filename containing `final` does not establish construction approval. Four local preview copies are ignored under `site/assets/` for the website Wes asked to begin on 2026-10-18.

Other images in the external folder are outside this PR intake. These four concepts do not establish current property condition.

## Black-shutter front elevation — 2026-10-23

Wes directly supplied `C:\Users\wesbr\.codex\generated_images\01a0b696-05a2-7291-a857-084a6f2bc2eb\exec-a693cf80-9491-413e-9a85-9f929973da1c.png` and authorized adding it as another public Front Elevation voting choice on 2026-10-23. The owning chat visually confirmed an AI front elevation with black louvered shutters, dark left siding, pale right siding, warm exterior lighting, a vivid sunset, and a garage.

Use public copy `front-black-shutters.png` and design ID `front-black-shutters`; preserve existing choice `front-23` (`23-front-final-with-garage.png`) so Front Elevation has two choices. Keep the original and all image binaries outside Admin Wiki Git; package the selected public copy only in the separate Sites source repository. Publication and verification are recorded in [[Project Rooms/Smart House/working/hosting-and-domain]].

## Media Center color concepts — 2026-10-23

Wes directly supplied `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\26-BYH -908 Pond St\Owning\Planning\Entertainment-Color-Options-20261023` in this chat for the website gallery. Read and visually reviewed the six concepts and source captions in `COLOR-NAMES.txt` and `website-assets.json`. The manifest identifies Built-in Imagegen as the method and explicitly limits the colors to concepts rather than paint specifications.

| Choice | Cabinets / TV frame | Central TV backdrop | Short filename |
| --- | --- | --- | --- |
| 1 | Warm ivory cream | Muted warm mushroom taupe | `01-warm-ivory.png` |
| 2 | Soft dusty sage green | Warm pale cream | `02-soft-sage.png` |
| 3 | Deep muted navy blue | Light warm greige | `03-deep-navy.png` |
| 4 | Medium mushroom taupe | Soft warm ivory | `04-mushroom-taupe.png` |
| 5 | Deep muted olive green | Light warm sand | `05-deep-olive.png` |
| 6 | Rich charcoal gray | Muted terracotta clay | `06-charcoal-clay.png` |

The long descriptive filenames match the short aliases by SHA-256; count six distinct voting choices. The baseline is reference material, not another voting choice. Surrounding walls remain neutral warm off-white and the honey-toned floor remains unchanged. Selected copies are prefixed `media-` in the separate Sites source repository; originals and image binaries remain outside Admin Wiki Git.

Kitchen, ADU, and Master Bath images have not been supplied for their requested galleries.

## Media Center motion concept — 2026-10-23

Wes supplied `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\26-BYH -908 Pond St\Owning\Planning\TV-Motion-20261023` and authorized its video as the main visual of Design > Media Center on 2026-10-23, above the six existing color voting choices.

- Video: `908-Pond-TV-Opening-Art-to-Football.mp4`; public copy `/media/media-center-art-to-football.mp4`.
- Poster: `01-retracted-art.png`; public copy `/media/media-center-art-poster.png`. `02-extended-football.png` is the ending-state source reference.
- `README.txt` lists 8 seconds, 1280×720, 30 fps, H.264 MP4, using Imagegen imagery and composited movement. Reviewed both stills: framed still-life artwork transitions to football as the TV moves into viewing position. The motion is illustrative; mount mechanics have not been validated.

Use native video controls, `playsInline`, the poster, and metadata preload, with no autoplay and an illustrative caption. Keep all source binaries outside Admin Wiki Git and package public copies only in the dedicated Sites repository. Published as Sites version 5; verification and deployment details are recorded in [[Project Rooms/Smart House/working/hosting-and-domain]].

## Realtor and self-viewing preview — 2026-10-23

Wes asked to feature his realtor on View and instructed Smart House to use her email domain. A targeted Outlook People lookup returned Ashley Morello at `ashley@elementrealtygroup.net`. Official sources: https://elementrealtygroup.net/ and https://ashleymorello.allentate.com/ . The brokerage profile provides her public role, service area, and phone 919-417-0612. Use short factual paraphrases and official links. The direct portrait source was not verified; the site uses an AM monogram. No private personal material or source email bodies are published.

Wes explicitly clarified that the entry code is simulated for now, with real-lock integration later. The date/time picker and code are a labeled browser-local demonstration, not confirmed appointment availability. See [[Project Rooms/Smart House/working/viewing-and-realtor]].
## Pondster identity and Jean Wright role — 2026-10-24

Wes directly named the house Pondster, requested named voice responses throughout the website, and identified Jean Wright as its SI designer. The exact term SI is preserved. This instruction authorizes identity, copy, and public website interaction updates, not publication of private owner information, a connection to Jean's chat, or live device control. The public guide draws only from the supplied design/video catalog, official realtor contact, and documented site behavior. Browser speech compatibility/privacy references and current limits are in [[Project Rooms/Smart House/working/pondster-identity-and-guide]].

## Built By company page — 2026-10-24

Wes asked for a Built By menu option using BuyYourHomeLLC.com. Public sources are https://www.buyyourhomellc.com/ and https://www.buyyourhomellc.com/buyer/authority-about/ . The company describes buying, repairing, managing, and selling homes with flexible options and individual service, and publishes Wes Browning at 919-917-7466. The official homepage header graphic was downloaded and visually verified; only the separate Sites repo contains the public image binary. No private contact information, internal SOPs, or stale financing/rate claims were used. See [[Project Rooms/Smart House/working/built-by-page]].

## Ashley portrait and anonymous public identity — 2026-10-24

Wes asked to add Ashley's picture and then withhold the property address, saying Pondster needs to start anonymously for now. Verified the current official redirect to https://ashleymorello.howardhanna.com/ and its named About Me page for agent108213. Public full portrait: https://ashleymorello.howardhanna.com/ClientImage/Agent-Full/108213.jpg, 628 by 628. Recovered the observed image through browser asset export, visually inspected it, and packaged an unchanged public copy only in the dedicated Sites repo. The earlier unverified-portrait/initials limitation is resolved. Current public address references are removed; internal property routing remains private. See [[Project Rooms/Smart House/working/viewing-and-realtor]].

## Media Center fixed-frame moving-football revision — 2026-10-24

Historical Sites version 14 source: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\26-BYH -908 Pond St\Owning\Planning\TV-Motion-20261023\908-Pond-TV-Opening-Frame-Fixed-Moving-Football.mp4`. File size is 2,412,141 bytes; independently checked SHA-256 is `82896b300e815f23baa13a63e467afa1dd9aa0d4f3af641d5e5365b11c6b8906`. Its public copy was `/media/media-center-fixed-frame-football.mp4`; preserve this revision and the earlier animation as history. The six existing color concepts remain the voting choices.

Read the adjacent `Frame-Fixed-Moving-Football-Notes.txt`. It specifies 10 seconds, 1280×720, 30 fps, H.264 MP4, silent: the decorative wall frame stays stationary, only the TV moves, and actual moving football continues through the final extended hold. Its fixed-frame sample checks, moving-screen sample checks, and full-decode checks are source-reported validation. The original `/media/media-center-art-poster.png` was visually matched to the new opening still-life scene. Website browser metadata and playback checks confirmed 10 seconds, 1280×720, advancing playback, and moving football without a media error.

The notes identify the football excerpt as U.S. Marine Corps video by Sgt. James Stanfield, **125th Army-Navy Football Game B-Roll**, December 14, 2024: https://www.dvidshub.net/video/947000/125th-army-navy-football-game-b-roll . The 01:20–01:30 excerpt was resized and color adjusted without source audio; the notes identify it as public domain and place the source credit in the final two seconds. Preserve that ending credit and the official near-player notice: "The appearance of U.S. Department of War (DoW) visual information does not imply or constitute DoW endorsement." Source policy reference supplied in the notes: https://www.dvidshub.net/about/copyright .

This historical animation remains an illustrative AI/composited design concept, without validated mount mechanics. Keep all source binaries outside Admin Wiki Git and package public copies only in the dedicated Sites repository. See the hosting notes for version 14 publication and verification; version 5 checks apply only to the earlier clip.

## Media Center kitchen-view scrolling-caption revision — 2026-10-24

Wes supplied `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\26-BYH -908 Pond St\Owning\Planning\TV-Motion-20261023\908-Pond-TV-Automatic-Kitchen-View-Scrolling-Caption.mp4` and requested Pondster-first-person wording. The source is 2,722,948 bytes, SHA-256 `8D23681DCA0133946DE1D3EB51F140C4450EF93401B806387D057136FDA2DF69`; it remains untouched. Adjacent `Scrolling-Caption-Notes.txt` describes the third-person caption, fixed decorative frame, moving TV and football, and ending credit above the bottom caption band.

The derived web copy `/media/media-center-kitchen-view.mp4` was regenerated from the unchanged fixed-frame base using the same overlay and credit layout. Its exact scrolling caption is **“My TV automatically extends and turns toward my kitchen for better viewing.”** The web copy is 2,826,252 bytes, SHA-256 `5B0D569EE89475E3751173717D35EC82F6DBE030760919D2A98A1CB7037CA5E2`: 10 seconds, 1280×720, 30 fps, H.264 MP4, silent. Full decode passed; middle and final sample frames were visually verified for caption readability and ending credit above the band. The fixed-frame base hash was unchanged before and after generation.

Keep the existing poster, six color voting choices, source attribution, non-endorsement notice, and illustrative/unvalidated-mount-mechanics caveat. Source binaries remain outside Admin Wiki Git; the derived public binary belongs only in the dedicated Sites repository. Version 14 remains historical. Version 15 deployed successfully, with the new media URL, matching metadata, and advancing playback verified on the custom domain. Exact publication identifiers are recorded in [[Project Rooms/Smart House/working/hosting-and-domain]].
