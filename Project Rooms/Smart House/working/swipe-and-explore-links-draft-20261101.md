# Swipe and Explore links — draft 2026-11-01, published version 87

## Authority and publication gate

Wes requested swiping wherever the website has Previous/Next navigation; Explore floor-plan room pictures that open their matching Design gallery; and clickable cards under “What makes me, Pondster.” He approved best-guess destinations and expects to redirect some later. He specifically requested the camera card lead to a Living Room image showing surveillance cameras on the TV.

Wes initially said **do not publish until he says so**, so this draft was saved locally over public version 86. On November 2 he lifted the hold with “You can publish all when you get that,” authorizing this draft and the camera plan together. Version **87** is now public from source `1830a53f56c8683c7d3b4fadfd2a5514682feaac`; the supported helper pushed its source and packaged the checked build. Admin Wiki records remain locally committed without a push.

## Behavior

- Swipe left for Next and right for Previous on the image or media surface. It reuses existing actions in enlarged gallery pictures, alternate views of a single design, inline/expanded gallery films and the virtual tour. Existing buttons, keyboard actions, voting identities and tour boundaries remain.
- A shared touch-only controller distinguishes horizontal intent from vertical scrolling, preserves pinch/zoom, ignores interactive controls and the native video transport area, cancels on multiple touches/reset/unmount, and suppresses a drag's compatibility click without suppressing keyboard activation or a fresh tap.
- Selecting a floor-plan room still opens its details inside Explore. Clicking its available primary image opens the matching Design gallery and first choice using the existing validated reveal handler. Existing/New Garage share Garage Barn Door; Spiral Stair maps to Home Theatre; Open Deck maps to Back Deck. Missing/failed/unknown pictures remain noninteractive placeholders.
- All ten feature cards are native buttons with visible keyboard focus. Their destinations are kept in `site/gallery-source/lib/explore-feature-destinations.ts`; redirects require changing that map rather than each card.

## Provisional destinations

| Feature | Draft destination |
| --- | --- |
| My instant hot water | Explore → Kitchen details |
| I follow your routine | Explore → Living Room details |
| My bath, your preferences | Design → Hall Bath, first choice |
| I keep an eye outside | Design → Living Room, first choice — temporary |
| My voice | Contact → Voice controls |
| My lighting moods | Explore → Lighting preview |
| My sound & screens | Belong → Audio receiver guides |
| My climate & comfort | Contact → HVAC contractor |
| Your say in my design | Design → Gallery section |
| My owner experience | Belong → Owner handover |

The selected camera destination is a temporary subject match, not the requested surveillance image. Bounded inspection of available media found no Living Room still with a surveillance feed on the TV: the current six palette images show still-life artwork and the motion source shows football. The requested exact image must come from Wes or the Rendering PR; no new image was generated here. The temporary destination was disclosed in this chat and remains clearly marked in the map. All defaults may be redirected later.

## Verification and saved state

Fourteen changed/new text sources are mirrored byte-for-byte from the ignored Site runtime into `site/gallery-source`. No image/video/document binary or secret is added to Admin Wiki Git.

The real native swipe-controller and React-hook tests passed, including horizontal direction/threshold, vertical/diagonal movement, mouse/pen exclusion, buttons/native-video controls, pinch/zoom, outside second touch, cancellation/reset/unmount, endpoint bounds and ghost-click protection across navigation/rerender. The actual Explore card callbacks, typed map, page navigation/reveal and all floor-plan room mappings passed. Existing gallery/media controls, tour selection/fallback, TypeScript, production build and diff checks passed. The final source/build check found the approved secret absent across 218 text files.

Local browser verification at `http://127.0.0.1:19082/` confirmed Hall Bath's map selection remains in Explore, its picture opens the Hall Bath first choice, Enter on Next advances to its second choice, the sound card reveals the exact receiver guide card below the sticky header, the lighting card activates by keyboard, and the temporary camera card opens Living Room's first choice. Feature-card layout and focus were visually inspected. Physical finger swipes on an actual phone were not tested. No production vote/comment, microphone/paid voice session or house control was used. The owned preview tab and server were closed/stopped after checks.

Unpublished proof: `C:\Users\wesbr\.codex\visualizations\2026\10\16\01a14585-ffe6-7850-8db1-efcdd58e7071\pondster-explore-links-draft-20261101.png`.

Published as version 87 with the camera plan. Public Hall Bath image → first gallery choice and sound feature → exact receiver-guide reveal passed; the 25 combined-release text mirrors match the clean Site checkout. Physical phone swipes remain untested. Full release IDs, archive hash, live proof and verification: [[Project Rooms/Smart House/working/camera-floor-plan-draft-20261102]] and [[Project Rooms/Smart House/working/hosting-and-domain]]. The original destination defaults and missing surveillance-on-TV illustration remain as documented above.
