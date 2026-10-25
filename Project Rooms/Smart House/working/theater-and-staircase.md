# Theater and staircase — 2026-10-25

Wes supplied the full theater/staircase image and confirmed that the same image should be a voting choice in both Media Center and Spiral Staircase. He also authorized the supplied motion film in both galleries and the View virtual tour. This resolves the earlier Spiral Staircase pending-image state; dated intake records remain history.

## Source assets

| Asset | Exact source | Verified properties |
| --- | --- | --- |
| Full image | `C:\Users\wesbr\.codex\generated_images\01a0b696-05a2-7291-a857-084a6f2bc2eb\exec-071e12b4-67e9-447e-8762-df77bfd4150e.png` | 1672×940 PNG; 2,041,974 bytes; SHA-256 `A02A011B043777EE202F06B4CC642766B03482B141720EAC16A120640C224F57` |
| Motion film | `C:\Users\wesbr\Downloads\908-Pond-Theater-Football-Sequential-Stair-Lights.mp4` | 12 seconds; 1672×940; 30 fps; H.264 MP4; silent; 3,684,156 bytes; SHA-256 `E37338B438E44F3B8021827337757C1F6513FEBF5ED0E371F49DFC8695521F97` |

The selected image and video were copied byte-identically into the separate Sites source repository. Source binaries and public copies are excluded from Admin Wiki Git.

- Image: `/concepts/home-theater-spiral-staircase-amber.png`.
- Film: `/media/theater-football-sequential-stair-lights.mp4`.
- Poster: `/media/theater-stair-lights-poster.jpg`, extracted from the film's first frame.

The ending burned-in credit identifies U.S. Marine Corps/DVIDS footage by Sgt. James Stanfield, *125th Army-Navy Football Game B-Roll*. That credit and the DoW non-endorsement notice are retained. Independent lineage to the credited original footage has not been verified; the preserved credit is not proof of that lineage.

## Website behavior

- Media Center adds `media-07`, **Amber-lit home theater**.
- Spiral Staircase adds `spiral-01`, **Black spiral staircase**.
- Both choices use the same complete image with `fullImage: true`, preserving its natural aspect ratio and disabling hover cropping. Existing choices and IDs remain stable; the catalog now has 19 choices across eight galleries.
- Both galleries include the 12-second film, labeled as an illustrative AI/composited concept. The fixed scene shows bottom-up sequential stair lights, steady cove lighting, and moving football on the screen. It does not verify installed lighting or construction.
- The View tour now has eight scenes, including three films. The new 12-second motion scene appears once, under Spiral Staircase, separately from the room's winning still; it is not presented as a film of the winning finish or color.
- Existing per-gallery voting, public privacy boundaries, and Pondster's first-person website voice remain in effect. No schema change or production test vote is required.

## Validation and publication

The film's complete 360-frame decode passed. Visual samples at 0, 3, 6, 9, and 11.8 seconds confirmed the fixed scene, sequential stair lights, constant cove lighting, moving screen footage, and retained ending credit. The sampled frames showed no legible property address or vehicle plate and no occupants apart from the football players on the screen.

The owning chat verified passing guide and virtual-tour checks, TypeScript, and the release build. Desktop and phone browser checks confirmed that the complete image remains uncropped: its natural dimensions are 1672×940, with `object-fit: contain`, no hover transform, and the correct displayed ratio. The phone check used a 390×844 viewport, a 343-pixel image, and no horizontal overflow; the viewport override was reset.

The clean local preview at `http://127.0.0.1:19083` began with an empty D1 database. Only the existing `0000_soft_thunderball.sql` and `0001_massive_epoch.sql` migrations were applied to its local `.wrangler/state`. Each new choice saved and persisted: `media-07` and `spiral-01` each changed its local gallery total from 0 to 1; repeating either save added no vote. A second visitor with a distinct cookie saw neither selection, and the first visitor's room choices remained independent. Comments GET returned HTTP 200. These were local test writes only; no production votes or migrations were performed for validation.

Sites version 31 deployed successfully. The live custom-domain page showed both new choices and the theater film in both galleries. The live Spiral Staircase film reported the expected `/media/theater-football-sequential-stair-lights.mp4` URL, 12-second duration, 1672×940 dimensions, muted loop, ready state 4, `object-fit: contain`, and no media error. Successive reads showed playback advancing from 3.307712 to 7.802917 seconds. Automatic expanded viewing retained the full frame; a live screenshot was saved outside Git. No production vote, comment, booking, microphone, or house-system action was initiated. See [[Project Rooms/Smart House/working/hosting-and-domain]] for exact deployment identifiers.
