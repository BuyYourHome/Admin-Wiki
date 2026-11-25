# LED control specification and total Shelly requirements

## Authority and source

On November 25, Wes supplied `C:\Users\wesbr\Downloads\generic-12v-led-strip-control.pdf` and instructed Smart House to use it to specify all LED circuits and build a Shelly buying list. He requested a total list without stock deductions and confirmed **both a BLU wall station and a wired manual switch in every standard strip zone**. These are planning assignments, not field verification, purchases or live device configuration.

The supplied one-page PDF is retained unchanged, SHA-256 `f11b6a787197b9e9386d4c15821e6021f4d5c2bfad086a20024d53c8dcbb74b5`. It supersedes the cancelled Codex-generated LED example, which must not be substituted. The existing four-light/six-location AC example remains separate.

The authoritative workbook remains the Teams/SharePoint `Owning\Planning\908-Pond-Electrical-Circuit-Schedule.xlsx`, at the exact configured drive/item recorded in [[lighting-master-and-control-diagrams-20261125]]. The new `Shelly purchase list` tab derives requirements from the master role columns. This note is dated evidence, not a second editable equipment schedule.

## Control approach

Seven analog zones use one Shelly Pro RGBWW PM, one Shelly BLU RC Button 4 US ZB and one wired manual switch apiece. The BLU uses Bluetooth commands and the wired manual uses the Pro's native low-voltage input; these are two parallel paths into the same continuously powered Pro. An i4 module or additional load relay is not inherently required for these seven groups. Do not put a phase-cut AC wall dimmer before their DC power supplies.

The Pro supports five PWM outputs, with manufacturer limits of 6 A per output and 16 A total at 12–24 V DC. At the workbook's 12 V basis, the current allowances require fourteen separately allocated outputs across seven controllers. This applies the supplied single-channel, constant-voltage strip example; actual strip type and runs remain to be confirmed. Output channels are not extra controllers. Balanced output allowances below are provisional sizing allocations, not measured physical strip runs; never parallel PWM outputs.

| Group | Strip allowance | DC current | Used outputs |
| --- | ---: | ---: | ---: |
| LS-001, master bedroom bed area | 118.8 W | 9.90 A | 2 |
| LS-005, master-bath shower | 109.2 W | 9.10 A | 2 |
| LS-007, guest bath/toilet | 32.4 W | 2.70 A | 1 |
| LS-011, living room | 145.8 W | 12.15 A | 3 |
| LS-012, kitchen | 91.8 W | 7.65 A | 2 |
| LS-018, bedroom 1 | 108 W | 9.00 A | 2 |
| LS-019, bedroom 2 | 108 W | 9.00 A | 2 |

The generic drawing shows SW1 controlling O1. Larger groups require commissioning so **both controls operate every allocated room output together**; default SW1-to-O1 mapping alone is insufficient. Confirm compatible firmware, Bluetooth coverage and recovery behavior. Power-supply quantity/model, overhead, protection and physical cable/output allocation remain separate design details; one controller does not imply one power supply.

LS-010 retains its addressable GLEDOPTO stair controller and one conditional Shelly AC supply relay, preserving sequencing. The seventeen ordinary AC groups retain their existing assignments. The two previously blank bathroom station counts are now resolved as Wes's new design choice, not as confirmation of existing wiring.

## Dated gross requirements

The prepared source has 39 Shelly devices: 13 Plus Wall Dimmer US, 5 Shelly 1 Gen4 UL US, 7 Plus i4 UL, 7 Pro RGBWW PM and 7 BLU RC Button 4 US ZB. LED scope is 15 of these: seven Pro controllers, seven BLU stations and the stair supply relay. The retained GLEDOPTO and ordinary manual switches are outside the Shelly total. No owned stock is subtracted.

Official US single-unit prices checked November 25 total $1,110.61, including $594.50 for LED scope, before tax and shipping. These are dated estimates, not an order. Plus i4 UL was out of stock. The BLU order must specify US ZB model `SBBT-104CUS` / EAN `3800238072544`; the store's technical block still carries older-model text. Keep exact variant notes separate from concise equipment names.

Primary references: [Pro specifications](https://kb.shelly.cloud/knowledge-base/shelly-pro-rgbww-pm), [BLU ZB specifications](https://kb.shelly.cloud/knowledge-base/shelly-blu-rc-button-4-zb), [BTHome control API](https://shelly-api-docs.shelly.cloud/gen2/DynamicComponents/BTHome/BTHomeControl/), and the official product links recorded in the workbook's purchase tab. Final load/driver, exact model acceptance and installation review remain with the electrician; no safety listing or site commissioning is inferred from a model name.

## Validation and publication

The nine-tab candidate passed preservation, formula/cache, strict ArtifactTool reimport and visual checks. All seventeen ordinary groups and LS-010 A:R, four unrelated tabs and existing power-supply formulas were preserved. Formula errors are zero. The purchase tab is derived from main-sheet role cells; its print core is A1:H22, with product URLs and detailed notes retained in I:J. A second independent row audit reconciled the 39/15 Shelly quantities, extensions and fourteen PWM-output allocations without double-counting.

The master was updated only after verifying its prior `f1df844e…` hash under an exclusive file lock and saving/verifying `908-Pond-Electrical-Circuit-Schedule-before-led-pro-blu-20261125.xlsx`. Destination readback matches SHA-256 `5fe9047f9bbaec8b52d91ad73f6226ec5d32e51528ec1f589c6ce5418357a9a0`, 55,618 bytes. SharePoint returned the same configured item, version-4 ETag and modification time `2026-11-25T12:53:01Z`; metadata stayed stable across the native extracted-text read. The new bundled seed was parsed from that actual cloud extraction.

Site changes passed six focused suites and strict TypeScript checks: optional PWM fields and validation, public export/knowledge, separate supplied-PDF navigation, parallel BLU/native topology, ordinary AC/i4 preservation, owner writer/readback and privacy. The final supported build passed with exit 0 after correcting aggregate wall-station labels and adding the BLU ZB manufacturer reference. The source privacy scan passed across 228 text files. Public outputs omit private source identifiers/address/prices. The existing hourly owner refresh remains unchanged; this task does not independently verify its scheduled execution.

Version **92** is published. Pushed Site source: `5004814fbf525a360d739c8d4bde2d752f4b376d`; saved version `appgprj_6ad4d98e08708191858cab113814704e~appgver_d6fc865799b0819194510842cceb8e57`; deployment `appgdep_6b06dc265d048191ad5717a78ca7dd93`, succeeded `2026-11-25T13:01:35.610078+00:00`, environment revision 5. Archive `sha256:20aa20abe82b1c49d3545fac0f9742b2902e3fc269dbe98c2a44a762e9abb0c0`, 163 files / 119,736,320 bytes. Public audience and existing runtime bindings are unchanged. Native URL: https://pondstr.coolnewt4097.chatgpt.site ; custom domain: https://pondstr.com .

After a fresh exact-item metadata check, the real owner writer imported the native SharePoint text and saved revision `6573fd0ae18ec3b694786ad2677825753be58f92fbed5495c293a3c2d54af463` at `2026-11-25T13:02:18.145Z`. Owner status/readback reports current with version-4 ETag. Custom and native public JSON have that revision. The review has 25 per-group diagrams, including seven BLU/native parallel arrangements. The two-tab public Excel extract includes the same revision and PWM fields without private master packaging or formulas. The downloaded supplied PDF exactly matches its original hash.

The publication has 25 load controllers and 14 input devices/stations: 39 primary/input smart devices plus one additional load relay, across all brands. This includes one GLEDOPTO; **Shelly purchases total 39** after excluding that non-Shelly controller and including the stair supply relay. Public totals are not a substitute for the gross Shelly purchase tab.

Chrome visual inspection confirmed the living-room LS-011 diagram shows one BLU station and one wired manual in parallel, one Pro, three separately assigned outputs, and zero extra load relay. Proof: `C:\Users\wesbr\.codex\visualizations\2026\10\16\01a14585-ffe6-7850-8db1-efcdd58e7071\pondster-led-controls-live-20261125.jpg`. No paid natural-voice trial or device operation was performed. Owned implementation text is mirrored under `site/gallery-source`; source binaries, workbook candidates and raw native extraction stay outside Wiki Git.
