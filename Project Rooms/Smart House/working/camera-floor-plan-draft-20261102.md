# Camera floor plan — version 87, November 2, 2026

## Authority and saved state

Wes directed Smart House to use the newest House Render floor plan with camera locations, replace the existing floor plan, retain every established room connection, and treat each camera arc as a room-like target that displays its virtual video. The work was initially held locally. Wes subsequently lifted that hold with “You can publish all when you get that,” authorizing both this change and the saved November 1 swipe/Explore-link draft. Version 87 is now public; its source was pushed with the supported Sites helper. No Admin Wiki push occurred.

Source rooms are read-only. Smart House changed only its owned website sources and records, with no changes to House Render, Home Designer, actual cameras, home controls or credentials.

## Selected source and registration

Newest matching package inspected: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\26-BYH -908 Pond St\Owning\Planning\House Render\camera-plans\908-Pond-Camera-Views-v15-20261102`.

- Clean base: `908-Pond-Clean-Plan-Base.png`, 2340×2225, 175,678 bytes. SHA-256 `bcc66478f34eba8fbe77d0c5501b9c7522e461487af364731456efad9ebd5841`.
- Geometry JSON SHA-256 `709eae53db13ad36541ab1cb15817b0a1588eac860e19b91e197559a9b093bf8`.
- Overlay SVG SHA-256 `5a8530e075f1157dbcd9e31c5d5ceb334b879a9870444d5c7360902a70badec8`.
- The package uses presentation plan v11. Its source notes preserve the Home Designer Proposed 9 geometry authority. Deck outer edge Y517.86 supersedes the old website outline at Y556.2387. The draft removes the obsolete 12-foot claim and retains the visual-concept/final-dimension qualification.
- Existing 19 room regions register by `newX = oldX × 5/3 + 775/3`, `newY = oldY × 5/3 + 670/3`. Room IDs, gallery IDs, detail content and the extra Front Elevation/ADU selector options remain.

The anonymous website base `/plans/first-floor-camera-plan-v15.png` is byte-identical to the clean source; no address-bearing PDF, provenance, source screenshot or local path is exposed. The inspected plan has no readable exact address and its PNG metadata contains only DPI.

## Camera targets and videos

| Target | Position | Arc | Website movie | Public bytes / SHA-256 |
| --- | --- | --- | --- | --- |
| `camera-1`, Front gable | 954,1930 | 22.5°–157.5°, radius260 | `/media/camera-1-virtual.mp4` | 1,474,302 / `c2e06c49ed99c1708d8f80408ed55f5ec0d18c9b24dcf17a3d777cffc125d26b` |
| `camera-2`, Barn door | 1985,805 | −90°–90°, radius270 | `/media/camera-2-virtual.mp4` | 1,184,615 / `5a6b3eed0191d836150432e0f2c60731befe790d562bdb62f4d1aa52a0fa6ab8` |
| `camera-3`, Deck | 1435,540 | 48°–228°, radius520 | `/media/camera-3-virtual.mp4` | 1,108,597 / `56a6b185bd8a6ef46fb71482d3c1fcb307540ffad306ef11c1599b36689dd64d` |
| `camera-4`, West side | 313,665 | 90°–270°, radius260 | `/media/camera-4-virtual.mp4` | 1,222,734 / `ed2b292703d0bbf7d6baad25073a9590422c336bae3d7e4a5b9a2b76d5f7fb57` |

Video sources are `908-Pond-CAM-01-walking-6s.mp4` through `04` under the matching property `House Render\motion\pond-four-camera-selected-cam3-v15-20261102` folder. All four are six seconds, 1920×1080, 16:9, H.264, 24fps and silent. Public copies stream-copy the video with metadata removal/faststart; no re-encoding or visual changes occurred. Full decode, encoded-packet hashes and full decoded-frame hashes match source/public for every movie. Source file hashes, C1–4 respectively: `34e87c2cea32492621ab2bac2942fd2c85e803b6a1e2a73212e868ba5ac53268`, `ba1acc11ef492c3c68f642897ea130cbe9dcb681d866d1f6cf29f09d4f064f1f`, `b34555822f32eb817b6c06590d921e74973592fec9d78c86bee7b3ce62cf4416`, `bb52b9b06b763317ce80484409c64985bb395fa4639b5b497b66cffcb917aee2`.

Matching `QA-CAM-0N-midpoint.jpg` sources become `/media/camera-N-poster.jpg`. They are 1920×1080, already free of EXIF/comments, and byte/pixel-identical. Public sizes C1–4: 743,554 / 511,960 / 795,740 / 699,099 bytes. SHA-256 C1–4: `c5b616f548ed90412ad578016048b7797b4f29987c82c96c562fcd0a3af39a46`, `b21ebb069b045c834e2c6d1ceea75e5409761d4eefc09f3a2471215f12bf98b4`, `7ee636244161c43e07d35e7f50553646c9a75d6de5157a81f19a7be66f1994b6`, `d69df7581416fb009603dd3abf62cdbA85796b225006132b95c06c603d47b844`.

The source videos and plan have two known differences: Camera 1's earlier view needs reconciliation with its moved mount; Camera 4's video uses its older background, whereas the newest plan/still points toward the front road. These differences are disclosed in the view and Pondster's shared knowledge. No replacement render was generated. Camera 3 uses the owner-selected scene, but its new 180° plan arc does not make that image a calibrated optical simulation. All arcs use display radii, not measured coverage. Clips are marked DEMO / NOT LIVE, with a synthetic walker; twelve start/middle/end frames contained no readable exact address, plates or private text.

## Interaction and guide behavior

Fields are inline SVG, beneath room targets so overlapping Camera 3 shading cannot hide Open Deck. Camera markers sit above room targets. The visible key directs visitors to the numbered marker or native chooser when a field crosses a room. All four arcs have keyboard Enter/Space activation and their own pressed state; selecting a camera does not also mark Living Room selected.

Camera selection displays a muted, looping, native-control video in the existing detail frame. Previous/Next and horizontal swipes browse the four cameras. Enlarge uses a modal with keyboard arrows, Escape, focus restoration to the remounted Enlarge button, and reachable Start/Stop voice and Voice controls. Native video scrubbing retains its own keyboard/touch behavior. Changing view, enlarging, closing or leaving the map pauses outgoing media; leaving also closes the modal. Titles and controls use separate side columns in compact landscape rather than covering the video.

The guide's fixed destination set adds only the four camera IDs. Numbered/named concept-view requests reveal Explore → floor-plan → the matching camera. Brief narration identifies the concept view. Camera manual/specification requests still reveal Belong equipment; Back Deck gallery requests still open Design. Unknown, private/live, quoted, negated or compound requests do not silently become a camera reveal. Shared live context knows the simulations and C1/C4 caveats without exposing source coordinates/paths. The existing server fallback and API/key configuration are unchanged.

The earlier provisional “I keep an eye outside” feature-card destination is unchanged; the requested Living Room TV-surveillance illustration remains separate from these direct camera-view clips.

## Verification and continuation

Focused geometry, actual UI/hook, page navigation/reveal, camera intent, destination, guide, speech and live-context suites passed. Coverage includes all 19 source label centers and bounds, deck correction, all four exact sector/marker definitions, room-over-field priority, path/marker/chooser/keyboard events, media mapping, swipe protection, video errors, modal focus and cleanup, and voice-control callbacks. TypeScript, production build and diff checks passed. The final source/build check found no approved secret in 229 text files. No microphone, paid provider session, production vote/comment or real-house operation was used.

Local browser verification confirmed C1 arc playback; C2 marker playback; C3 keyboard activation, enlargement and Escape focus return; C4 navigation in the modal; camera Voice controls returning to Contact with the modal closed; Open Deck selection beneath the field; and Master Bath picture → correct first gallery choice. Videos played muted with six-second duration and no media error. Physical phone swipes and a fresh natural spoken request were not tested. The owned local tab/server were closed/stopped after QA.

Proofs outside Git: `C:\Users\wesbr\.codex\visualizations\2026\10\16\01a14585-ffe6-7850-8db1-efcdd58e7071\pondster-camera-map-draft-20261102.png` and `pondster-camera-video-draft-20261102.png` in the same folder. Sixteen text files are mirrored byte-equal in `site/gallery-source`; nine binary copies remain only in the ignored independent Site runtime and their authoritative external sources.

## Publication

Version **87** published successfully at `2026-11-03T02:34:26.142206+00:00` (November 2, 9:34 PM Eastern), preserving public access and environment revision **4**. Source `1830a53f56c8683c7d3b4fadfd2a5514682feaac`; saved version `appgprj_6ad4d98e08708191858cab113814704e~appgver_279632496ca88191a6f63ff1e128ff94`; deployment `appgdep_6ae94824c0b8819182a52da37b8f686b`. Archive `sha256:1673ffbffddea64f2bd672ea26e03e2cb95c81cd9c2e9091b7b2b2471621ae19`, 150 files / 111,452,160 uncompressed bytes. Archive path: `C:\Users\wesbr\AppData\Local\Temp\pondster-cameras-and-swipes-v87-20261102.tar.gz`.

All 25 combined-release text mirrors match the clean pushed Site checkout. All nine new public camera files matched their local hashes. Public browser checks on Pondstr.com confirmed C3/C4 muted playback with duration six seconds/no error, enlargement, Next and Escape; Hall Bath room image opening its first gallery choice; and the sound feature card revealing the receiver guides at top192.875px beneath the fixed header. No vote/comment, microphone, paid voice call or device operation was used. Physical finger swipes and a fresh natural spoken trial remain unperformed.

Live proof: `C:\Users\wesbr\.codex\visualizations\2026\10\16\01a14585-ffe6-7850-8db1-efcdd58e7071\pondster-cameras-and-swipes-published-v87-20261102.png`. The existing user-owned public tab remains open on Explore. This publication record supersedes the earlier local-only hold and draft-state wording in the intake history.
