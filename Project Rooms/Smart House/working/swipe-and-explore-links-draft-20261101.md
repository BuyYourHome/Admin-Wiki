# Swipe and Explore links — unpublished draft, 2026-11-01

## Authority and publication gate

Wes requested swiping wherever the website has Previous/Next navigation; Explore floor-plan room pictures that open their matching Design gallery; and clickable cards under “What makes me, Pondster.” He approved best-guess destinations and expects to redirect some later. He specifically requested the camera card lead to a Living Room image showing surveillance cameras on the TV.

Wes explicitly said **do not publish until he says so**. These changes are saved locally only. Public Pondstr.com remains version **86**, Site source `89937dc22cea536c130350ebf2a82027a08e400d`. No Site source commit/push, archive upload, saved version or deployment was made for this draft. Admin Wiki changes are committed locally without a push. This gate overrides the room's ordinary publication default for the pending draft.

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

Next step: await Wes's explicit publication instruction. Before any later release, recheck the local changes and map, preserve unrelated work, use the supported Sites source/package/deploy workflow, and verify the public result. Do not infer publication permission from acceptance of these provisional destinations.
