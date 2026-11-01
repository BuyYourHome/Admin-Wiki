# Garage v18 replacements — 2026-11-01

## Authority and scope

Wes supplied three updated garage exterior schemes and a revised warm-white film, then answered yes to the proposal to replace the existing garage choices and featured video while keeping their votes and updating Explore and the tour. This release replaces those assets and related descriptive copy. It does not add choices, change voting records or alter live house controls.

Image source folder: `C:\Users\wesbr\.codex\visualizations\2026\10\26\01a178f1-8292-7aa3-863d-f6de8a3c44f7\garage-elevation-three-colors-v18-20261031`.

| Source | Dimensions | Original SHA-256 | Public copy | Public SHA-256 |
| --- | --- | --- | --- | --- |
| `01-warm-white-new-geometry.png` | 3810×1650 | `f8fbb0040c6769b9afcbc6973dbaaebeaf86de63f92dedb8ebedfdefb36271b1` | `/concepts/garage-v18-warm-white.webp` | `d6bf0b00f9413082fbd84729408c550b27824858a6b96a4ac91eb51ed8ebb13a` |
| `02-charcoal-green-new-geometry.png` | 1905×825 | `046b2034f17559445456b4a24ab40cf2ddfbb50c74eab9fcf179c2ca1a9d87fb` | `/concepts/garage-v18-charcoal-green.webp` | `14b024dd717dc6bea0f325b7fa154625164087d8cc71d112be32707239a8c27c` |
| `03-limewashed-brick-new-geometry.png` | 1905×825 | `d8da388bb39a975a39ac8cc43bf085a934e9a23d9023d9cf5edce1b3c6efd46e` | `/concepts/garage-v18-limewashed-brick.webp` | `6e7a4dfb123234d4b13a7cadcf100b9baaa49edccbd3ee4fc86cd761d6bbe128` |

The WebP copies are lossless, retain full dimensions and framing, and passed decoded RGBA byte equality against the originals. EXIF/XMP/IPTC are absent from the public copies. Public sizes are 8,597,646 / 2,427,388 / 2,498,348 bytes respectively. Originals are unchanged. Visual inspection found no legible exact address, people, vehicle plates or construction-approval claims in the stills; the far-left facade reaches their supplied image edge.

## Revised film

- Original: `C:\Users\wesbr\.codex\visualizations\2026\10\26\01a178f1-8292-7aa3-863d-f6de8a3c44f7\garage-video-v8\908-Pond-Garage-Warm-White-Geometry-Corrected-Video-Review-v18.mp4`.
- Original: 15,095,807 bytes; SHA-256 `ee99f5d448b78bd2450fee1f9997482ff08840aca55014fba24ee0ede26ab115`.
- Public: `/media/garage-v18-warm-white.mp4`; 15,095,807 bytes; SHA-256 `2db714a9028e6b8387874d4fcab4ab7a5b9523fd0f2bff2ec5abde337f49494f`.
- Poster: `/media/garage-v18-poster.jpg`; 1920×832; 735,593 bytes; SHA-256 `1312c472bc0b1c1444b1bfd7c2d7ad5f11a62c1f452955ef264efa011ef46745`.

The film is 25 seconds, 24 fps, H.264 High/yuv420p, progressive and silent. Coded size is 3840×1664 with sample aspect 1651:1650 and display aspect 127:55; the display aspect matches the stills. Browser videoWidth rounds the adjusted width to 3842. The gallery uses the 127/55 display ratio and contain fitting. The public copy stream-copies the original video, removes source metadata and moves the MP4 index forward for playback. Encoded-packet SHA-256 is unchanged: `24bee9dcfac6fb047233de2f8a3fb2e8a09bf6df9cf876213523e7f4b13ec0db`.

Full source decode passed without errors. Eight representative frames from 0 to 24.88 seconds plus full-resolution car views were inspected. The center pedestrian leaf opens outward and closes, the full assembly slides left, and a white Tesla emerges and turns screen-left along the driveway. The revealed space is described as the lit garage interior; no marble-floor material is inferred. No legible exact address or vehicle plate appeared in the inspected frames. Mechanics and clearances remain illustrative and unvalidated.

## Attribution and integration

The supplied render source's `car-assets/CREDITS.md` identifies the 2024 Tesla Model 3 Highland model by RBLXSupercars, shared by brandonleong28, with embedded CC BY 4.0 licensing and earlier adaptation. Both the Design caption and tour retain the model/source link, both credited parties, license link, adaptation/animation disclosure and non-endorsement. The official [CC BY 4.0 deed](https://creativecommons.org/licenses/by/4.0/) was opened; the [supplied model page](https://sketchfab.com/3d-models/tesla-model-3-2024-36c52f3f89f6439c90310f14e8ff33f2) returned 403 during this check. No fresh model download or independent source-license verification is claimed.

Catalog IDs `garage-06`, `garage-07`, `garage-08`, their order and full-image flags are retained. Explore obtains the updated warm-white primary through the catalog, including both garage plan regions. The tour retains its single `garage-barn-door-motion` scene and vote-selected fallback; its film keeps its warm-white finish independent of voting. Counts remain nine galleries, 31 choices, seven tour scenes and three films. Back Deck images and all existing vote identities remain unchanged. Old media remain recoverable in the separate Site source history; no binary is added to Admin Wiki Git.

## Verification and publication

Guide, actual page navigation/reveal, tour selection/fallback, live public-context, TypeScript, production build and diff checks passed. The final source/build secret-absence scan passed across 215 text files. Independent review found no stale active garage paths, inward-opening or marble copy, ID changes, missing credits or private source paths.

Local browser checks verified all three images with Next in the enlarged viewer, the new warm-white image in Explore's New Garage details, muted autoplay with advancing playback and no media error, and the new film in the virtual tour. No vote/comment was posted and no microphone, paid voice call or real house control was used. The temporary preview was closed and stopped.

Version **86** published successfully at `2026-11-01T12:06:07.751070+00:00`, preserving public access and environment revision **4**.

- Source: `89937dc22cea536c130350ebf2a82027a08e400d`.
- Saved version: `appgprj_6ad4d98e08708191858cab113814704e~appgver_80fdb66f953c8191aef770e5724313d0`.
- Deployment: `appgdep_6ae72b1e5724819191795334fb2fa113`.
- Archive: `sha256:3f9069383963d57d7ac73fe314dfe1636ac1003d73842121aa6a45ccdf85a2bc`, 141 files / 103,485,440 uncompressed bytes.
- Public site: https://pondstr.com/#design .

The supported helper pushed the exact source and packaged the matching build. Its checkout is clean and all eight text mirrors are byte-equal. All five new files were retrieved from public Pondstr.com and matched their checked hashes exactly. The browser connection was temporarily unavailable and later recovered; after refresh, public browser inspection verified all three new images through Next and the film playing muted at 17.44 seconds with duration 25 seconds and no media error. Voting controls remained available; no vote or comment was submitted. No paid voice, microphone or real device was used.

Public proof screenshot: `C:\Users\wesbr\.codex\visualizations\2026\10\16\01a14585-ffe6-7850-8db1-efcdd58e7071\pondster-garage-v18-published-20261101.png`.
