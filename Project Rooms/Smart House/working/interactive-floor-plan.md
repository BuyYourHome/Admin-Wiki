# Interactive Explore Floor Plan

## Request And Scope

On 2026-10-27 Wes supplied the proposed first-floor presentation PDF and directed that it become the lead interactive app on Explore, with clickable rooms opening room details. During implementation he changed the header tagline to **A Home You can Relate to**. Routine implementation and publication are authorized by those direct requests.

Image creation remains with the Rendering PR. This website change reuses its supplied drawing, extracts a public crop, and adds navigation; it does not revise the architectural plan or create a new rendering.

## Initial v7 Source And Public Asset

- Source intake path: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\26-BYH -908 Pond St\Owning\Planning\House Render\floor-plans\908-Pond-Proposed-9-Presentation-Plan-v7.pdf`.
- Source PDF SHA-256 reported by its adjacent provenance: `d25c8278110672272bae30d34a3bd7904aeb674326362cbc908df56378333225`.
- The adjacent provenance and generator identify the current Home Designer Proposed 9 native export as the controlling plan, with the owner's proposed 12-foot deck added for presentation. No Rendering PR source was edited by this website workflow.
- The PDF's address-bearing header, sidebar and footer are excluded from the website asset. The original PDF is not published.
- Drawing crop in PDF points: left 140, top 245, width 1140, height 1030. Poppler rendered this at 144 dpi to 2280×2060 px, with no text/EXIF metadata chunks in the resulting PNG.
- Public asset: `/plans/proposed-first-floor.png`; SHA-256 `caf7b236790880b8fcc85059019dd0e473d3f67ecd87a3251ec9929123910aa9`.
- Binary assets remain in the independent Sites checkout/publication archive and the external temporary preparation folder; no PDF or image is added to Admin Wiki Git.

At final wrap-up, the original v7 path could no longer be reopened and the v7 filenames were not found under the property Planning folder. The exact drawing had already been read, rendered, visually inspected and packaged; its public crop is retained in the Sites source/archive with the verified hash above. Do not silently substitute a later plan for future edits; obtain its verified source location/version from the Rendering PR when needed.

## Initial v7 Navigation And Details

The plan is the first feature below the existing Explore heading and lead. Seventeen labeled spaces have selectable navigation regions: Living Room, Kitchen, Dining Room, Master Bedroom, Master Bath, Hall, Bedrooms 1/2, Open Deck, Pantry, Laundry, Existing Garage, New Garage, Walk-in Closet, each bedroom closet, and Utility Closet.

| Plan space | Details and related gallery |
| --- | --- |
| Living Room | Existing feature content; `media-center` gallery |
| Kitchen | Existing feature content; `kitchen` gallery |
| Master Bath | Existing feature content; `master-bath` gallery |
| Open Deck | Existing outdoor plans plus supplied deck facts; `back-deck` gallery |
| Existing Garage / New Garage | Source-backed separate descriptions; optional related `garage-barn-door` concepts, without asserting either rendering is a confirmed fit |
| Other labeled spaces | Source-backed proposed-layout descriptions and explicitly unfinished design details |

Hall is not mapped to Hall Bath. The plan does not invent first-floor targets for Home Theatre, ADU or Front Elevation; their existing cards and galleries remain available below. Living, dining and kitchen navigation zones partition their shared open space for selection, without adding walls.

SVG regions support pointer activation and Enter/Space. A native room chooser provides a readable alternative for small spaces; changing its value preserves keyboard focus. The explicit details button focuses the chosen room heading, and Back to my plan returns to the corresponding region. Zoom runs from 100% to 250% within a scrollable canvas; the initial view fits the drawing. The site's exact Explore hash and existing gallery navigation callback are retained.

## Version 9 Source Update — 2026-10-27

Wes supplied the newer PDF directly after the first interactive-plan release, authorizing the same website app to use this revision. The new source is `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\26-BYH -908 Pond St\Owning\Planning\House Render\floor-plans\908-Pond-Proposed-9-Presentation-Plan-v9.pdf`. Its actual SHA-256 matches the adjacent provenance: `30ccb8bf501dec95dbfab4e3a876ce8b2941f0cd616312080eab4b654cf159bd`.

The supplied v9 presentation adds Hall Bath and the native spiral stair, retains the two garages and triangular laundry, and corrects the deck projection to 144 inches measured from the exterior wall face. Numeric dimension callouts are omitted from the supplied sheet; this website workflow does not alter the drawing or its source files.

The current public drawing-only crop uses PDF points left 140, top 245, width 1190, height 1030. The wider right edge preserves the complete GARAGE DOOR label while stopping before the sidebar. Poppler at 144 dpi produces 2380×2060 px. The original address-bearing PDF is not published. Public asset `/plans/proposed-first-floor.png` SHA-256: `8f5ba9a003c504a422bce881b1a4f1bb44ae51600e9b95f216be848b814fb04b`.

The app now has **19** selectable spaces. Hall Bath opens its existing `hall-bath` tub-and-shower gallery and feature content. Spiral Stair has separate source-backed details and a related `spiral-staircase` Home Theatre concept link; it does not assert a final physical connection or fit. Hall excludes these new targets. Deck selection follows the revised native bounds X230.5420004593–594.8641685495, Y412.2386944702–556.2386944702. Existing gallery IDs, stored votes/comments, room chooser, zoom and focus behavior remain compatible.

All 19 source label centers select the correct topmost region; all region coordinates stay within the crop and IDs are unique. Local Chrome verified Hall Bath selection and its gallery navigation, showing all six existing color choices. An additional phone viewport check was interrupted by Chrome debugger detachment; the responsive component/CSS is unchanged. Production build, TypeScript, secret scan and live verification are recorded with the release below.

## Initial Verification And Release

Implementation checks: all 17 source label centers, bounds, unique room IDs and gallery targets passed geometry review; the Hall nook was included after review. TypeScript passed. Local desktop room activation displayed Master Bath details. A 390×844 viewport showed the plan before the existing feature sections, with no document overflow and the complete new tagline fitting horizontally. Browser debugger detachment interrupted additional keyboard checks; production verification and the publication record are recorded in [[Project Rooms/Smart House/working/hosting-and-domain]].

Version **59** was published and visually verified on the custom domain. Live room activation displayed Master Bath, whose gallery action opened the correct Master Bath voting choices; Master Bedroom opened its own details. Proof outside Git: `C:\Users\wesbr\.codex\visualizations\2026\10\27\pondster-interactive-plan-published.jpg` and `C:\Users\wesbr\.codex\visualizations\2026\10\27\pondster-room-details-published.jpg`. The new delivery tab uses the browser’s normal sizing. Resetting the earlier temporary viewport on detached preview tabs was unavailable; those intermediate tabs are left to automatic cleanup.

Version **60** publishes v9 at https://pondstr.com/#explore. Live Hall Bath and Spiral Stair selections displayed their separate details. Full release metadata: [[Project Rooms/Smart House/working/hosting-and-domain]]. Proof outside Git: `C:\Users\wesbr\.codex\visualizations\2026\10\27\pondster-v9-floor-plan-published.jpg`. The v7 sections above preserve the original release history; v9 is the current source.

Version 61 keeps the v9 drawing and all 19 regions, and replaces the gallery action with a framed primary picture inside each room detail. The nine room cards expand their pictures and details in place. See [[Project Rooms/Smart House/working/future-feature-language-and-room-pictures]] for image selection, wording and verification limits.
