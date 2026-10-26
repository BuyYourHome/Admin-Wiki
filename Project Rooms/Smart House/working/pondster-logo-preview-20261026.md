# Pondster logo preview — 2026-10-26

Status: local preview prepared and visually checked; **not published**. Wes explicitly requested seeing the revised logo in chat before publication. Production remains Sites version 56. Do not publish these logo changes until Wes approves the preview or explicitly requests publication.

## Requested changes

- Move burnt-orange Your left by about half its previous rightward movement.
- Lower only the rectangle's bottom edge by approximately half the font size of A home with a voice.
- Subsequent copy edit: change only the Design introduction's first sentence to **I’m Pondster, the voice and persona of this house.** The two app/page.tsx source copies match. This remains with the unpublished preview batch; no other authored wording or voice greeting was changed.

The preview reduces Your's horizontal offset from 22px to 11px on desktop and from 15px to 7.5px on phone. It extends the rectangle down by 8.25px on desktop (half the 16.5px tagline font) and 7.5px on phone (half 15px). Matching bottom padding preserves Your/HOME's vertical position. Signature, I Am, tagline, header height, logo voice action, animation, menu order and all website behavior stay in place.

## Source and visual checks

- CSS edit: `site/.hosting-work/work/gallery-release-20261025/app/globals.css`, mirrored to `site/gallery-source/app/globals.css` for durable recovery. The publication checkout retains this CSS as an unpublished change after source commit `88483de445a82f54750730353fa63624399f1369`; no Site source helper push/save/deploy was run for the preview.
- Desktop1920px: rectangle height108.25px, Your translation11px, tagline16.5px. Compared with production, frame top and signature/Your/HOME/tagline vertical coordinates are identical; only frame bottom extends8.25px and Your moves11px left. Header/brand height remains100px; no horizontal overflow.
- Phone390px: rectangle height87.5px, Your translation7.5px, tagline15px, brand height80px; no horizontal overflow. Temporary browser viewport override was reset.
- Screenshot outside Git: `C:\Users\wesbr\.codex\visualizations\2026\10\26\pondster-logo-your-left-lower-frame-preview.jpg`. It is an actual crop of the local website, not a generated logo mockup.
- Local page returned HTTP200. This CSS-only preview used visual/geometry checks; no microphone, new provider session, vote, comment, real booking or device action occurred. No new automated tests were added.

After approval, publish the pending logo edit and Design sentence through the existing Site source workflow, preserving version56's voice admission fixes and all current galleries. The separate unresolved voice-session support request remains in [[Project Rooms/Smart House/working/pondster-voice-support-request-20261026]].
