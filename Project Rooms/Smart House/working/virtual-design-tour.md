# View page virtual design tour

## Wes instruction — 2026-10-25

Wes directed creating a virtual tour from View that selects each room's video or most-voted design, combines the scenes with a soundtrack, and advances automatically. This is a public concept tour using the website's existing authorized assets, not a new recording of the completed house. Website implementation and publication are covered by the current room authority.

Current published behavior is version 36: six scenes and three films, one view per populated gallery, with the nine-gallery/37-choice catalog unchanged. The owner clarification below supersedes the initial selection/order and optional-fullscreen description preserved here as history.

## Initial source and selection — historical

- The shared `lib/designs.ts` catalog supplies current voting choices. The tour reads each populated gallery's existing `/api/votes?room=...` endpoint at the start of each new tour. It does not submit votes or change vote storage.
- Current populated galleries: Front Elevation, Media Center, Master Bath, and Garage Barn Door. Kitchen, ADU, Spiral Staircase, and Back Deck have no image choices yet and are omitted until available.
- Each populated gallery contributes its highest valid vote choice as a still scene. A tie uses the first matching gallery entry and is identified as joint lead. A gallery without votes uses its first image with a featured-preview label. Failed vote reads use a distinct votes-unavailable preview label, never a fabricated leader.
- After the selected Media Center and Garage images, the tour includes their existing illustrative motion films. They are explicitly separate from the chosen color/finish; the existing film is not recolored or represented as the winning design's film. Required football credit and source-use notice accompany the Media Center scene.
- Initial order: Front Elevation, Media Center choice, Media Center film, Master Bath, Garage choice, Garage film. Future populated galleries are appended in catalog order.

## Initial experience — historical

The View page has a prominent tour invitation above the early-buying design paragraph. Starting it opens a modal player. Images remain uncropped for eight seconds; films play once and advance on completion. Scenes include their room, design name, vote status, and concept description. Playback includes pause/resume, previous/next, direct scene selection, optional full screen, replay, and music on/off. Closing the tour returns focus to its invitation; changing pages disposes playback. Leaving the tab pauses the tour and music.

The soundtrack is a quiet original Web Audio instrumental composition created in browser code, with no third-party music file, purchase, account, or outbound audio request. The invitation's checked soundtrack control makes sound expected on the Start click; no sound starts merely from opening View. Browsers without usable audio can continue the visual tour. Existing supplied motion films remain muted.

Loading and playback errors use labeled still fallbacks or permit skipping. Reduced-motion preferences remove image fades and progress animation. The tour closes the Pondster question panel before playback; no microphone, live house control, lock code, private owner record, or exact location is added.

## Initial validation and publication — version 30 history

The focused vote-selection and Web Audio lifecycle/race suites, full TypeScript check, and production build passed. Local Chrome verified automatic still-to-film and film-to-next progression, current vote selection and ties, quick pause/resume, 25-second final film completion, completion/replay controls, music enabled without startup errors on a clean page, Escape/focus/scroll-lock recovery, and phone fitting. The 390×844 modal was 376 pixels wide with 44-pixel or taller playback buttons and no page overflow. Audio was not recorded or independently listened to for musical quality. Native full-screen behavior and reduced-motion preference were reviewed in source but not exercised separately.

The generic build wrapper encountered a missing `npm` executable on this host. The exact existing build script, `node scripts/run-framework.mjs build`, completed with bundled Node and unchanged dependencies/configuration. The official Sites source helper then pushed the matching source and packaged the completed build. A process-only Git safe-directory entry was restricted to the established sandbox-owned Sites checkout; global Git trust was not changed.

Sites version 30 deployed successfully at `2026-10-25T19:26:40.662281+00:00`. Source commit: `0883f0b9215d84af9028ef3193eff5f1ccfb60d3`; saved version: `appgprj_6ad4d98e08708191858cab113814704e~appgver_44dac207488c8191aa27384320187bcd`; deployment: `appgdep_6ade57e7afb88191a9b5e25175ba78db`. A fresh custom-domain View page showed the invitation and live player. See [[Project Rooms/Smart House/working/hosting-and-domain]]. No production votes, comments, bookings, messages, microphone use, paid services, account changes, private records, DNS changes, or house-system actions were created.

## Owner clarification and current requirements — 2026-10-25

Wes clarified that each gallery should use its video if available, otherwise its most-voted scheme, and identified that the tour was not filling the screen. This supersedes the earlier winner-still-plus-film behavior; version 34's nine-scene record remains historical.

- Use one scene per populated gallery: Media Center, Garage Barn Door, and Spiral Staircase use their existing main films; Front Elevation, Master Bath, and Hall Bath use their highest-voted images. Expected result: six scenes and three films.
- Do not show both a winner still and a film for the same gallery. Use the selected winner still only as that film's load/playback-failure fallback.
- Preserve valid-vote selection, stable ties, and honest first-image previews for no votes or unavailable vote reads; never imply an unverified leader.
- Fill the viewport with media and visible controls. Attempt native fullscreen from the Start user click, with a CSS viewport fallback; contain the whole image/video without cropping.
- Preserve original music, automatic progression, pause/resume, Close, and existing cleanup behavior.

Version 36 published successfully at `2026-10-25T23:04:10.793606+00:00`. TypeScript and the production build passed through the official helper for the exact pushed source; local selection/soundtrack suites and combined prepared-voice TypeScript also passed. Local desktop 1920×911 and phone 390×844 viewport fitting, 44-pixel phone controls, automatic transitions through the final Spiral film to Thanks/Replay, pause/resume, Escape/Close, Start focus return, and scroll-lock cleanup were verified. Native fullscreen now targets the document root, but automated clicks still rejected it; native fullscreen remains unverified, with the uncropped viewport fallback verified.

Fresh https://pondstr.com/#view displayed “one view per room” and six spaces/three films. A silent live Start, pause, and Next opened Media Center directly as room 2's readyState 4 video without a duplicate still; dialog/media filled 1920×911 and playback resumed. No production votes, comments, or bookings were created. Exact source, saved-version, deployment, and archive identifiers are in [[Project Rooms/Smart House/working/hosting-and-domain]]. Natural voice remains inactive and unpublished.
