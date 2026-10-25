# Explore features

## Authorized experience — 2026-10-24

Wes requested feature lists for the whole house and each room in Explore. Pondster introduces its ideas in the first person, with clear `ON MY WEBSITE`, `MY DESIGN CONCEPT`, and `IN MY PLANS` labels. Materials, dimensions, equipment, construction details, and installation status still require confirmation; concept imagery and planned capabilities are not installed specifications.

The current requirement is ten house-wide summaries: the four owner-requested planned capabilities below come first, followed by the six existing summaries **My voice**, **My lighting moods**, **My sound & screens**, **My climate & comfort**, **Your say in my design**, and **My owner experience**. Keep all eight room cards. Distinguish working website functions from design concepts and plans; none of the four new summaries establishes installed equipment or live control.

## Owner-requested capabilities — 2026-10-24, America/New_York

Wes directly supplied these four requirements in the owning chat. Label their first-person website descriptions `IN MY PLANS` and retain the requested behavior:

- Natural-gas tankless hot water with whole-house recirculation; instant hot water is the requested goal, without a validated performance claim.
- Proximity devices tracking multiple people for automations. The TV faces an occupied kitchen when the living room is empty and returns when people settle in the living room.
- Voice bath/shower operation that knows the user: fill the bath to that user's preferred temperature, stop when full, and start the shower by voice.
- Exterior cameras follow individuals; the TV switches to surveillance while its viewer is inside.

Use the same planned-feature descriptions in Explore and Pondster's bounded replies. Kitchen/Media Center bullets may explain the occupancy-aware TV example and planned hot-water service; Master Bath bullets may explain planned personalized voice filling and shower start. Do not infer camera locations or recognition methods. See [[Project Rooms/Smart House/working/source-inventory#Owner-requested smart capabilities — 2026-10-24|the exact intake and gaps]]. No models, specifications, or installation/operating validation accompanied these requirements, and this website update authorizes no live integrations.

Eight room cards follow the current Design catalog, with a button selecting the matching gallery:

| Card | Gallery ID | Current source-backed scope |
| --- | --- | --- |
| Kitchen | `kitchen` | Layout/finish ideas pending; TV turns toward the kitchen in the concept; owner-requested recirculating hot water and occupancy-aware TV behavior remain plans |
| Media Center | `media-center` | Framed TV motion study; six color pairs; warm off-white surrounding walls and honey-toned floor in the studies; multi-person TV orientation and surveillance switching remain plans |
| Front Elevation | `front-elevation` | Warm wood versus black shutters; dark/pale siding and warm exterior lighting concepts; exterior camera following and an indoor TV view remain plans |
| Garage Barn Door | `garage-barn-door` | Independent inward center entry, full assembly sliding left, illustrated Tesla drive-out and white-marble garage; three exterior finish studies |
| ADU | `adu` | Planned design category; layout, finishes, and equipment unconfirmed |
| Master Bath | `master-bath` | Fixture/material ideas pending; user-aware voice bath filling to preferred temperature, stopping at full, and voice shower start remain plans |
| Spiral Staircase | `spiral-staircase` | Stair design, materials, and dimensions unconfirmed |
| Back Deck | `back-deck` | Outdoor-living ideas; layout, materials, and finishes pending |

Keep the existing lighting simulator and Explore comments. Daylight, Evening, and Unwind change only the illustration. A Pondster scene request from another page opens Explore, scrolls to the lighting section, and focuses it. Shared public content in `site/gallery-source/lib/features.js` supplies both Explore and Pondster's feature replies; `app/explore-page.tsx` renders the summaries/cards from the catalog so room coverage stays aligned.

## Sources and gaps

Use [[Project Rooms/Smart House/working/planning-context]] for Wes's whole-house vision, [[Project Rooms/Smart House/working/pondster-identity-and-guide]] for current voice/privacy boundaries, and [[Project Rooms/Smart House/working/source-inventory]] plus [[Project Rooms/Smart House/working/design-galleries-and-voting]] for authorized concepts and pending galleries.

Property Planning references: `Entertainment-Color-Options-20261023/website-assets.json` and `COLOR-NAMES.txt`; `TV-Motion-20261023/Scrolling-Caption-Notes.txt` and `Frame-Fixed-Moving-Football-Notes.txt`; `Barn-Door-Motion-20261024/README.txt` and `README-Tesla-Drive-Out-White-Marble.txt`. TV/door movement and vehicle travel are illustrative, without validated hardware, clearances, or turning radius. Color names are concepts, not manufacturer specifications. Kitchen, ADU, Master Bath, Spiral Staircase, and Back Deck still await images; do not fill gaps with invented features. Keep the location/address confidential and private operational records out of public copy.

Equipment selection, plumbing/recirculation design, delivered hot-water timing, presence/identity methods, multi-person automation rules, temperature/fill-level limits, and camera/TV integration and privacy settings still need confirmed specifications and validation. Do not imply that the public guide recognizes people, fills a bath, starts a shower, tracks individuals, displays live camera feeds, or moves a real TV. Live integration/configuration remains outside this copy task.

## Earlier validation and publication — version 23

The guide suite, eight feature-request checks, TypeScript check, and final production build passed. The 390px preview showed eight cards at 345px wide with 375px page content. The Back Deck gallery button routed correctly; a cross-page Evening request scrolled to and focused the lighting section.

The earlier six-summary revision published successfully as Sites version 23 at `2026-10-24T15:17:06.623341Z`; those checks do not validate the four later additions. Exact publication identifiers and current deployment status belong in [[Project Rooms/Smart House/working/hosting-and-domain]].

The four owner-requested additions published as version 27 at 2026-10-24 9:42 PM Eastern. The guide suite, planned-system refusal/routing checks, TypeScript check, and build passed. Browser checks confirmed ten house summaries, eight room cards, phone fitting, and a typed bath request receiving the plan without operating anything. The custom-domain page displayed all four new planned features; current publication evidence is in the hosting record.
