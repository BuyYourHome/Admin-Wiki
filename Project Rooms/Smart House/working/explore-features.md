# Explore features

## Authorized experience — 2026-10-24

Wes requested feature lists for the whole house and each room in Explore. Pondster introduces its ideas in the first person, with clear `ON MY WEBSITE`, `MY DESIGN CONCEPT`, and `IN MY PLANS` labels. Materials, dimensions, equipment, construction details, and installation status still require confirmation; concept imagery and planned capabilities are not installed specifications.

The six house-wide summaries are **My voice**, **My lighting moods**, **My sound & screens**, **My climate & comfort**, **Your say in my design**, and **My owner experience**. They distinguish the working public guide, voting, and comments from planned lighting/control ideas, connected media, equipment-care information, and future owner guides/handover records.

Eight room cards follow the current Design catalog, with a button selecting the matching gallery:

| Card | Gallery ID | Current source-backed scope |
| --- | --- | --- |
| Kitchen | `kitchen` | Layout/finish ideas pending; TV concept turns toward the kitchen |
| Media Center | `media-center` | Framed TV motion study; six color pairs; warm off-white surrounding walls and honey-toned floor in the studies |
| Front Elevation | `front-elevation` | Warm wood versus black shutters; dark/pale siding and warm exterior lighting concepts |
| Garage Barn Door | `garage-barn-door` | Independent inward center entry, full assembly sliding left, illustrated Tesla drive-out and white-marble garage; three exterior finish studies |
| ADU | `adu` | Planned design category; layout, finishes, and equipment unconfirmed |
| Master Bath | `master-bath` | Fixture/material ideas pending |
| Spiral Staircase | `spiral-staircase` | Stair design, materials, and dimensions unconfirmed |
| Back Deck | `back-deck` | Outdoor-living ideas; layout, materials, and finishes pending |

Keep the existing lighting simulator and Explore comments. Daylight, Evening, and Unwind change only the illustration. A Pondster scene request from another page opens Explore, scrolls to the lighting section, and focuses it. Shared public content in `site/gallery-source/lib/features.js` supplies both Explore and Pondster's feature replies; `app/explore-page.tsx` renders the summaries/cards from the catalog so room coverage stays aligned.

## Sources and gaps

Use [[Project Rooms/Smart House/working/planning-context]] for Wes's whole-house vision, [[Project Rooms/Smart House/working/pondster-identity-and-guide]] for current voice/privacy boundaries, and [[Project Rooms/Smart House/working/source-inventory]] plus [[Project Rooms/Smart House/working/design-galleries-and-voting]] for authorized concepts and pending galleries.

Property Planning references: `Entertainment-Color-Options-20261023/website-assets.json` and `COLOR-NAMES.txt`; `TV-Motion-20261023/Scrolling-Caption-Notes.txt` and `Frame-Fixed-Moving-Football-Notes.txt`; `Barn-Door-Motion-20261024/README.txt` and `README-Tesla-Drive-Out-White-Marble.txt`. TV/door movement and vehicle travel are illustrative, without validated hardware, clearances, or turning radius. Color names are concepts, not manufacturer specifications. Kitchen, ADU, Master Bath, Spiral Staircase, and Back Deck still await images; do not fill gaps with invented features. Keep the location/address confidential and private operational records out of public copy.

## Validation and publication

The guide suite, eight feature-request checks, TypeScript check, and final production build passed. The 390px preview showed eight cards at 345px wide with 375px page content. The Back Deck gallery button routed correctly; a cross-page Evening request scrolled to and focused the lighting section.

Published successfully as Sites version 23 at `2026-10-24T15:17:06.623341Z`. Exact publication identifiers and deployment status belong in [[Project Rooms/Smart House/working/hosting-and-domain]].
