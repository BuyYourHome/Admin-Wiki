# Hall Bath tub-and-shower color studies

## Current placement — owner correction, 2026-10-25

After the version 33 release, Wes clarified: “These pics need to be in the hall bath. A room not yet specified”. This direct owner correction is the authoritative current placement and supersedes the original Master Bath instruction below.

These same six tub-and-shower choices are now in the newly specified **Hall Bath** gallery. The original six vanity studies stay in **Master Bath**. Every `bath-tub-{slug}` design ID, source image, public filename, and hash is retained; no image generation or asset changes were needed. The note filename, external folder, and `master-bath-tub-*.jpg` asset names remain historical references rather than statements of current room ownership.

The corrected catalog has nine galleries, six Hall Bath choices, six Master Bath choices, and 37 choices overall. The populated Hall Bath adds a ninth View-tour scene; the three separate films remain unchanged. Version 34 published successfully at `2026-10-25T22:20:29.765759+00:00`, from source `9662bd139a0999c1579b11179e3f807768002ddf`. The version 33 checks below establish only the previous placement.

Live database reads at intake, immediately before deployment, and after publication each found only the existing Media Center `media-06` vote and no Bath/tub/Hall votes. No vote transfer, data backfill, schema change, or production test vote was needed.

Guide and tour checks, TypeScript, the production build, full local vote regression, and combined prepared-voice context checks passed. Tests retain all 37 IDs, reject tub choices in Master Bath and original vanity choices in Hall Bath, preserve independent room preferences across visitors and vote changes, and select independent winners for both tour scenes. Local and fresh live Chrome verified Hall Bath's six named cards, Master Bath's six original cards, the new Explore feature card/link, Pondster's Hall Bath routing, and the unchanged full-size 1672×941 image. Live proof: `C:\Users\wesbr\.codex\visualizations\2026\10\25\pondster-hall-bath-live.png`. Exact deployment identifiers are in [[Project Rooms/Smart House/working/hosting-and-domain]].

## Authority and sources — 2026-10-25

Wes supplied `C:\Users\wesbr\.codex\generated_images\01a0b696-05a2-7291-a857-084a6f2bc2eb\exec-f8568204-4054-4818-8f7f-98296d05c14d.png`, then explicitly chose to create six color studies and add them to Master Bath voting. The wood-vanity baseline is reference material, not an additional voting entry.

Authoritative external folder: `C:\Users\wesbr\.codex\visualizations\2026\10\25\pondster-master-bath-tub-shower-color-schemes`.

- `baseline.png`: 1672×941, 1,968,291 bytes; SHA256 `8AA9DABA5CC5A36CDB979A879A7234AE1193981D6833B181E5BC97E8150ADB46`.
- Six final PNGs: `warm-ivory.png`, `dusty-blue.png`, `deep-navy.png`, `master-bath-tub-forest-green.png`, `master-bath-tub-mushroom-taupe.png`, and `master-bath-tub-terracotta.png`.
- `schemes-a.json`, `schemes-b.json`, and combined `prompts.json`: exact built-in `image_gen` prompts, palette details, generation paths, and QC. Each study independently used the same baseline; no CLI/API/key generation or iterative recoloring.
- `website-assets.json`: authoritative source/web paths, dimensions, byte sizes, and SHA256 hashes; manifest SHA256 `CF29D768507D2DAE9A7232BE7BDE2567C1CF99CECB54204B2BDED5584460A9DF`. Keep full prompts and image binaries outside Admin Wiki Git; this note records references only.

## Initial Master Bath catalog — historical placement

The initial placement added six separate Master Bath choices titled `Tub & shower · {palette}`, with the IDs and public assets below. The existing six vanity choices and all existing IDs were preserved: version 33 had 12 Master Bath choices, 37 total choices, and eight galleries. Its View tour retained eight scenes and three separate films. The owner correction above supersedes this room placement and these room/tour counts.

Only the floating vanity paint and main painted wall vary. Preserve the tub/shower and visible jets, peach-cream onyx/tile surround and step, patterned window, gray stone floor, white counter, rounded rectangular gold mirror and reflection, gold hardware/sconces, ceiling and under-vanity LEDs, and open white WC doorway with niche/toilet. Public copy remains in Pondster's first person and labels these AI visual concepts; the images do not confirm installed finishes, manufacturer paint specifications, dimensions, or construction approval.

## Public copies

Root encoded JPEGs at quality 92 with 4:4:4 sampling, without crop or resize. All six remain 1672×941. Public files belong only in the separate Sites repository under `/concepts/`.

| Palette / title suffix | Design ID | Public filename | JPEG bytes | JPEG SHA256 |
| --- | --- | --- | --- | --- |
| Warm Ivory | `bath-tub-warm-ivory` | `master-bath-tub-warm-ivory.jpg` | 343,939 | `0a7fa6b34bbe277b4669e0250bd8c23491d5328f0fdecbab62ce2b2500812e76` |
| Dusty Blue | `bath-tub-dusty-blue` | `master-bath-tub-dusty-blue.jpg` | 359,923 | `786e9d7bb44793cd5a487c3b25fd531f9af708d1f910c9ffddb2465c8d872d80` |
| Deep Navy | `bath-tub-deep-navy` | `master-bath-tub-deep-navy.jpg` | 356,758 | `341fbb39ea6c9a0d7a30db9949e85dbde8410365dafa99fe08b2e23a7db92c91` |
| Forest Green | `bath-tub-forest-green` | `master-bath-tub-forest-green.jpg` | 360,510 | `d1a9444836a2b292f70adcce9f7361d74bc9e74e2612ec6ca8f574ac5c9a1144` |
| Mushroom Taupe | `bath-tub-mushroom-taupe` | `master-bath-tub-mushroom-taupe.jpg` | 354,257 | `b491ef063dcbe847b0b828c5533eb45076c09ac729adafe099659ab63ec46132` |
| Terracotta | `bath-tub-terracotta` | `master-bath-tub-terracotta.jpg` | 345,308 | `2368e6b665d0374e91d66174ffacefbe4b09489e3193930db203a2efd64d1eb0` |

## Version 33 validation and publication — historical placement

Generation, external source preservation, web encoding, and catalog implementation are complete. The owning chat visually reviewed all six finals against the baseline; no fixes or material geometry drift were found. These are visual studies, without a pixel-identical or measured-geometry claim.

Guide and tour suites, TypeScript, and production build passed. Checks cover all 37 choices, stable original IDs, original versus tub/shower palette routing, spoken “and,” operating-command boundaries, and a new winning Master Bath still without changing the eight-scene/three-film tour. The full local vote suite accepted all six new choices, preserved one vote while changing/repeating, rejected other-gallery IDs, and kept separate visitors' choices isolated. The combined prepared-voice checkout's guide/context tests and code backup's guide/tour tests also passed.

Local Chrome saved Dusty Blue and displayed its selected state. The enlarged image loaded at 1672×941 with `contain` fitting. At a 390×844 phone viewport, the longer Mushroom Taupe card measured 345 pixels and its button/image 343 pixels within 375-pixel page content; the voting name used 18-pixel text without horizontal overflow. The temporary viewport override was reset. No production test votes, comments, bookings, microphone access, or house-system actions occurred.

Sites version 33 deployed successfully at `2026-10-25T22:07:21.053120+00:00`, from source `f9f26a6fe3ab3eebd2a42c74364019b50c263f91`. Fresh Chrome checks at https://pondstr.com/#design showed 12 Master Bath choices, all six new named voting buttons, and all six new images loaded at 1672×941. A typed “Show Tub and shower Deep Navy” request returned the exact new title and opened Master Bath. The live Warm Ivory viewer retained full-frame `contain` fitting. Live gallery proof is saved outside Git at `C:\Users\wesbr\.codex\visualizations\2026\10\25\pondster-master-bath-tub-shower-live.png`. No production test votes were cast. Exact saved-version/deployment identifiers are in [[Project Rooms/Smart House/working/hosting-and-domain]].

Related requirements: [[Project Rooms/Smart House/working/design-galleries-and-voting]] and [[Project Rooms/Smart House/working/source-inventory]].
