# Pondster logo preview — 2026-10-26

Status: **published in Sites version57** after Wes explicitly said **publish** on 2026-10-26. The requested chat preview was delivered before that approval. The approved logo and Design sentence were published together; no pending edit remains in this batch.

## Requested changes

- Move burnt-orange Your left by about half its previous rightward movement.
- Lower only the rectangle's bottom edge by approximately half the font size of A home with a voice.
- Subsequent copy edit: change only the Design introduction's first sentence to **I’m Pondster, the voice and persona of this house.** The two app/page.tsx source copies match. This was included in version57; no other authored wording or voice greeting was changed.

The preview reduces Your's horizontal offset from 22px to 11px on desktop and from 15px to 7.5px on phone. It extends the rectangle down by 8.25px on desktop (half the 16.5px tagline font) and 7.5px on phone (half 15px). Matching bottom padding preserves Your/HOME's vertical position. Signature, I Am, tagline, header height, logo voice action, animation, menu order and all website behavior stay in place.

## Source and visual checks

- CSS edit: `site/.hosting-work/work/gallery-release-20261025/app/globals.css`, mirrored to `site/gallery-source/app/globals.css` for durable recovery. The preview was held locally after source commit `88483de445a82f54750730353fa63624399f1369`; following approval the source helper pushed and packaged the exact released source `1ae6eb045c502080f1a6c769a8698d89219a5d57`.
- Desktop1920px: rectangle height108.25px, Your translation11px, tagline16.5px. Compared with production, frame top and signature/Your/HOME/tagline vertical coordinates are identical; only frame bottom extends8.25px and Your moves11px left. Header/brand height remains100px; no horizontal overflow.
- Phone390px: rectangle height87.5px, Your translation7.5px, tagline15px, brand height80px; no horizontal overflow. Temporary browser viewport override was reset.
- Screenshot outside Git: `C:\Users\wesbr\.codex\visualizations\2026\10\26\pondster-logo-your-left-lower-frame-preview.jpg`. It is an actual crop of the local website, not a generated logo mockup.
- Local page returned HTTP200. This CSS-only preview used visual/geometry checks; no microphone, new provider session, vote, comment, real booking or device action occurred. No new automated tests were added.

The production build and 166-file secret-absence scan passed. The custom-domain Design page displayed the exact persona sentence and the approved desktop frame height108.25px/Your offset11px, with unchanged signature/tagline positions and no horizontal overflow. Live proof outside Git: `C:\Users\wesbr\.codex\visualizations\2026\10\26\pondster-logo-persona-published.jpg`. Exact version/deployment/archive IDs are in [[Project Rooms/Smart House/working/hosting-and-domain]]. Version56's voice admission fixes and all current galleries were preserved. The separate unresolved voice-session support request remains in [[Project Rooms/Smart House/working/pondster-voice-support-request-20261026]].
