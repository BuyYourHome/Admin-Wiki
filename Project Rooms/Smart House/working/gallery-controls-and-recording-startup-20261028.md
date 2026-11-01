# Pondster gallery controls and recording startup — 2026-10-28

## Requested corrections

Wes reported voice Previous/Next failing, no voting button on enlarged pictures, no comparable controls on gallery videos, and Voice controls being unclickable. This continues the authorized website publication. No device configuration, new service, voice/model/key change, or manual selection is included.

## Implemented behavior

- A shared control strip provides Previous/Next, vote access, Start/Stop voice, and Voice controls inside the image modal and expanded gallery films. Controls sit beside the image in short landscape screens, with their own scrolling area; the media remains contained rather than cropped.
- Enlarged images can be voted on from Design or View. Their immutable design ID selects the correct gallery. Voting waits for that gallery's loaded totals, and the handler rejects a mismatched ID. Alternate deck views remain one choice.
- Films remain illustrative media, not new voting choices. Their vote button opens the first actual design choice; Next opens the first still and Previous opens the last. Existing vote IDs and totals remain intact.
- Starting voice on Design no longer navigates away to View. A voice destination outside the gallery closes the image modal. Escape closes an image/video viewer before acting as a voice-stop shortcut. Voice controls explicitly reveal Contact's voice section.
- Voice startup sends a matching browser revision and whether this visitor expects text saving. The backend rejects stale pages or an expected-but-missing recorder before reserving or creating a paid call. Text history initializes before provider creation; a local history failure does not create an unknown provider-session fence.
- The earlier v78 generic spoken gallery fallback, default saving with opt-out, gentle form-of-address greeting, 90-day text/name expiry and garage v3 replacement remain in place.

## Evidence and limits

Focused tests exercise real TSX controls and callbacks, modal-contained vote/voice controls, cross-page gallery ownership, actual page action routing, first/next/previous/close, alternate-view IDs, stale-client rejection, missing-recorder rejection, history failure before provider creation, SQLite preferences/retention, and voice lifecycle/30-second quiet shutdown. TypeScript and the production build passed. Tests use mocks/in-memory SQLite; no paid test call, physical microphone test, or live vote write was made. Browser-control infrastructure was unavailable for a fresh visual/interaction check.

Production conversation tables were empty at the 14:21:16 UTC check despite recent voice-session records. Native-host profile creations at deployment-crawler times are not evidence of a visitor test. An old client or a saving-disabled preference is a possible cause; neither was established. No old transcript can be reconstructed. Confirm the next real refreshed-site call through owner-only records before claiming live capture has been demonstrated. Preserve private transcript content, identifiers and request logs outside the public site and Git notes.

## Remaining source blocker

The sound-system/camera equipment photos mentioned by Wes are not available in this chat's accessible attachment records or the searched property folders. The supplied garage renderings are not equipment labels. Actual photos, exact filenames or model numbers are required before finding official manufacturer manuals or adding equipment-specific knowledge to Belong. Do not guess models or publish private serial/MAC/QR/access information.

## Publication

Native Sites publication succeeded as version **79**, saved version `appgprj_6ad4d98e08708191858cab113814704e~appgver_4db34e8772e881918dc833050eee2886`, source `9306788f73bed46e47a51e14dab8dfe0f337bfbb`, deployment `appgdep_6ae20db12af48191a4bce765ce30aad1`, at `2026-10-28T14:59:07.956914+00:00`. Environment revision 4 and public audience are unchanged. Archive `sha256:0cba77f66e72a582e6272b731b4a604658ff6e633f4dd39790af5bb747f2e867`, 136 files / 74,065,920 bytes. Source helper pushed the matching Site source; the production archive passed the secret scan (204 text files, no key found). Source mirrors were byte-verified. Public site: https://pondstr.com; native alias: https://pondstr.coolnewt4097.chatgpt.site . Fresh real-browser/microphone validation and live text-capture confirmation remain pending; automated checks do not substitute for those.
