# Contact conversation last — 2026-10-27

Wes asked to make Talk to me the last thing on the Contact page. The request began at `2026-10-27T23:04:18Z`.

Contact now follows this DOM and keyboard order: public people/company details, trade contacts, Contact comments, then the conversation. The single Pondster Guide stays mounted inside the hidden Contact section so off-page voice remains available. Contact comments keep their existing key and storage, appear once, and are not fetched as hidden off-page comments.

The people cards use the available page width, with two columns on larger screens and one on phones. Nested comments avoid the former extra horizontal inset. Ordinary Contact navigation no longer focuses the bottom input automatically; explicit Ask, Talk and Voice controls retain a guarded focus shortcut after navigation. No voice controller, provider, microphone, billing, privacy, voting or other-page comment behavior was changed.

Static React rendering verified people/trades/comments/conversation order and retention of the hidden child. Existing Contact/navigation/hover checks, independent focus review, TypeScript, production build, diff checks and the 183-file secret scan passed. Browser visual behavior is not newly verified; no live voice session or microphone was used.

## Publication — version 71

- Source: `070635d51f6162514146ce92e4cbec8d7ae25ba3`.
- Saved version: `appgprj_6ad4d98e08708191858cab113814704e~appgver_75681b5b95dc8191a1d019f296f61862`.
- Deployment: `appgdep_6ae12f7d68888191b30d630288949566`, succeeded `2026-10-27T23:11:03.009345+00:00`, environment revision **4**.
- Archive: `sha256:e2e7221d21de892749bd9532ed52589730891c518c2f6c5fdee725214f937474`, 128 files, 66,406,400 bytes.

The public page returned HTTP 200 and its markup places the conversation after the contact sections. Static rendering establishes that active Contact comments are before it as well. Four text mirrors match the source. Opening https://pondstr.com/#contact in Codex returned queued; no browser visual claim is made. The website remains public and the existing voice implementation remains otherwise unchanged.
