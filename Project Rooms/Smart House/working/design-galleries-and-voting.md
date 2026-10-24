# Design galleries and voting

## Requested experience

Wes requested the main menu `Design`, `Explore`, `View`, and `Manage`, with design-choice galleries and public voting for Kitchen, Media Center, Front Elevation, Garage Barn Door, ADU, and Master Bath in this chat on 2026-10-23.

- Design: room selection, image galleries, full-size image viewer, preference voting, and aggregate results.
- Explore: the conceptual lighting demonstration and house-system explanations.
- View: the available approved interior and exterior concepts together.
- Manage: an explicitly planned owner-information area; no live administration, private data, or house control is exposed.

## Current Design galleries — 2026-10-24

Wes added Spiral Staircase and Back Deck after the original six galleries. Keep the original order and append entry 07 **Spiral Staircase** (`spiral-staircase`) and entry 08 **Back Deck** (`back-deck`). The current catalog has eight galleries; derive UI and guide counts from the catalog. This requirement supersedes the original six-gallery count above without changing its historical request.

Pondster's guide recognizes `spiral staircase`, `spiral stairs`, `staircase`, and `stairs` for Spiral Staircase, and `back deck`, `rear deck`, and `deck` for Back Deck. Both new galleries show pending-image empty states, with no fictional choices or votes. Once authorized images are supplied, use the existing gallery, full-size viewer, and voting behavior. The 11 existing choices remain unchanged: six Media Center, two Front Elevation, and three Garage Barn Door.

A filename/folder search of all 94 property Planning files found no identifiable Spiral Staircase or Back Deck sources; see [[Project Rooms/Smart House/working/source-inventory#Spiral Staircase and Back Deck intake — 2026-10-24|the intake record]]. Sites version 22 published successfully; live checks confirmed both galleries select correctly and show their pending-image empty states. Exact publication identifiers are in [[Project Rooms/Smart House/working/hosting-and-domain]].

## Image scope

Front Elevation has two authorized choices: preserve `front-23` (`23-front-final-with-garage.png`, warm wood shutters) and add `front-black-shutters` (public copy `front-black-shutters.png`, black louvered shutters). Wes supplied the exact generated image and authorized the additional public voting choice on 2026-10-23; see [[Project Rooms/Smart House/working/source-inventory#Black-shutter front elevation — 2026-10-23|the source and authorization record]]. The new image also shows dark left siding, pale right siding, warm exterior lighting, a vivid sunset, and a garage. The production build, local save/change-vote checks, desktop comparison, phone layout, and live gallery verification passed; see the current deployment in [[Project Rooms/Smart House/working/hosting-and-domain]].

Garage Barn Door uses concepts 06, 07, and 08. Wes supplied six Media Center concepts on 2026-10-23 from `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\26-BYH -908 Pond St\Owning\Planning\Entertainment-Color-Options-20261023`. Read `website-assets.json` and `COLOR-NAMES.txt` for source captions. The long descriptive names and short numbered aliases are byte-identical; display six choices, not twelve. Keep the baseline as a source reference rather than a seventh voting option.

The Media Center choices pair warm ivory cream with mushroom taupe, dusty sage with pale cream, navy with greige, mushroom taupe with ivory, olive with sand, and charcoal with terracotta clay. Accent colors refer only to the central TV backdrop; surrounding walls stay warm off-white and the honey-toned wood floor stays unchanged. These are concept names, not manufacturer paint specifications.

Five galleries still need design images: Kitchen, ADU, Master Bath, Spiral Staircase, and Back Deck. Show honest empty states and no voting for invented choices. Concepts remain labeled as AI studies, not measured drawings or current-condition photos. Keep source binaries outside Admin Wiki Git and package selected copies only in the dedicated Sites source repository.

## Featured Media Center video

On 2026-10-23 Wes authorized the TV motion video as the main visual of Design > Media Center, above the six existing color voting choices. See [[Project Rooms/Smart House/working/source-inventory#Media Center motion concept — 2026-10-23|the exact video source and poster]]. The six color concepts remain the voting choices.

The selected kitchen-view revision uses `/media/media-center-kitchen-view.mp4`: 10 seconds, 1280×720, 30 fps, H.264 MP4, silent. Its exact scrolling caption is **“My TV automatically extends and turns toward my kitchen for better viewing.”** The decorative frame stays fixed while the TV moves and football footage continues during the final hold. The original supplied scrolling-caption source remains untouched; a first-person web copy was regenerated from the fixed-frame base with the same caption-band and ending-credit layout. Exact source, sizes, hashes, and lineage are in [[Project Rooms/Smart House/working/source-inventory#Media Center kitchen-view scrolling-caption revision — 2026-10-24|the kitchen-view revision record]]. Full decode passed and middle/final caption and credit frames were visually verified. Sites version 15 deployed successfully; the custom domain loaded this URL with matching metadata and advancing playback without a media error.

On 2026-10-24 Wes requested muted autoplay for the featured Media Center video. Use native `autoPlay` and `muted` attributes while retaining `loop`, `playsInline`, native controls, `preload="metadata"`, and poster `/media/media-center-art-poster.png`. Browser policies may block autoplay; keep manual play and pause controls available. Sites version 17 deployed successfully; local and live browser checks confirmed automatic muted playback when the player entered view without pressing Play.

Preserve the ending football-source credit, official near-player non-endorsement notice, and illustrative AI/composited-concept caveat; mount mechanics have not been validated. The six existing color concepts remain the voting choices. Keep video and image binaries outside Admin Wiki Git; public copies belong only in the dedicated Sites repository. The owning chat records deployment status in the hosting notes.

Historical version 14 used `/media/media-center-fixed-frame-football.mp4`, the 10-second fixed-frame moving-football concept without the new scrolling caption. Its opening poster match, local browser playback, moving football, and 1280×720 metadata were verified. Preserve that revision as history; those checks alone do not verify deployment of the kitchen-view replacement.

Historical version 5 used `/media/media-center-art-to-football.mp4` with `/media/media-center-art-poster.png`; its notes listed 8 seconds, 1280×720, 30 fps, H.264 MP4. That earlier publication passed the production build, local and live playback checks, and phone-layout validation. Those checks do not validate the replacement clip. See [[Project Rooms/Smart House/working/hosting-and-domain]] for deployment status.

## Featured Garage Barn Door video — 2026-10-24

Wes supplied the replacement barn-door drive-out concept for Design > Garage Barn Door. Feature `/media/garage-barn-door-tesla-drive-out.mp4` above the three existing color voting choices, with poster `/media/garage-barn-door-drive-out-poster.jpg`. Preserve its 1600×640 panoramic aspect ratio: 25 seconds, 30 fps, H.264 MP4, silent. Use muted autoplay with `loop`, `playsInline`, native controls, and metadata preload; browser policies may block autoplay, so manual playback remains available. The video is a featured visual, not another voting choice.

The center door swings inward independently and closes before the complete barn-door assembly slides left. The white Tesla then drives forward, turns screen-left, and exits, revealing the empty white-marble garage; the exterior concrete driveway remains. The derived web copy preserves the supplied motion and timing while replacing its baked captions with **“My center door swings inward independently”** (1.5–5.5 seconds), **“My center door closes before my full assembly moves”** (5.5–7.5 seconds), and **“My full barn door slides left to reveal the Tesla”** (8–14 seconds). No overlays are added during the later car sequence. The poster matches the final web copy's first frame. Label the video as an illustrative AI/composited concept; door mechanics, clearances, and vehicle turning radius have not been validated.

Full source and derived-video decode passed, and sample frames confirmed readable captions, the drive-out sequence, and no legible property address or vehicle plate. Exact sources, hashes, and validation are in [[Project Rooms/Smart House/working/source-inventory#Garage Barn Door drive-out and white-marble revision — 2026-10-24|the replacement source record]]. Keep source binaries outside Admin Wiki Git and selected public copies only in the dedicated Sites repository. Sites version 21 published successfully. Live checks on Pondstr.com confirmed the exact replacement media URL, 25-second 1600×640 metadata, muted autoplay with advancing playback, an active expanded stage, and no media error. Exact publication identifiers are in [[Project Rooms/Smart House/working/hosting-and-domain]].

Historical version 18 used the 16-second `/media/garage-barn-door-tesla.mp4` and `/media/garage-barn-door-poster.jpg`, ending with the Tesla inside. That publication passed local/live playback, muted autoplay, three-choice voting, and phone overflow checks. Preserve its [[Project Rooms/Smart House/working/source-inventory#Garage Barn Door motion concept — 2026-10-24|source record]] as history; those checks do not verify the replacement.

## Featured-video scroll expansion — 2026-10-24

Both featured videos expand to fill the browser viewport as their stable gallery frame crosses the middle of the viewport while scrolling. This is an in-page stage rather than the browser Fullscreen API. Keep the same video element, native controls, muted autoplay, and loop behavior; entering or leaving the stage must preserve playback position and the viewer's paused state. The original gallery frame keeps its height so expansion does not shift page layout.

Scrolling past the source frame exits the stage. **Back to my gallery** or Escape dismisses expansion until that source frame leaves and reenters the activation range. Tabbing out also releases the stage. Keep the whole video visible without cropping, using letterboxing where needed; the local 375×844 phone check confirmed this behavior without a layout-height change. Reduced-motion preferences disable the reveal animation.

Pondster's guide remains usable in the normal gallery. An already-open guide panel prevents expansion; hide its launcher only while the video is expanded so native playback controls remain clear. This behavior passed local desktop/phone checks and was published in version 20; live browser checks confirmed viewport expansion, advancing playback, and release on scrolling past. Exact deployment status belongs in [[Project Rooms/Smart House/working/hosting-and-domain]].

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

## Vote button emphasis — 2026-10-24

Wes requested more emphasis with a colored background and larger font. Gallery vote buttons now use the existing warm accent as a solid fill, 14px semibold desktop text, 16px phone text, and larger 52/56px minimum heights. Hover darkens the accent; the saved choice retains its dark-green selected state. This changes presentation only and preserves the existing voting behavior.

Wes subsequently asked to put each voting item's name in its button and remove the separate title. Each button now shows the design name in a bold primary line (16px desktop, 18px phone) with the current action/status below it. The name stays visible during loading, saving, and selection; long names wrap. Remove the standalone card heading while retaining concept numbers, descriptive text, accessible card/image names, and the full-size viewer. Voting IDs, storage, selected-state behavior, and totals are unchanged. Published as version 25; see [[Project Rooms/Smart House/working/hosting-and-domain]].

Wes then asked to place the named button above the picture. The current card order is vote button, image, then description/results. The button spans the full card width and both columns of the tablet layout. This placement is published as version 26; voting behavior is unchanged.
