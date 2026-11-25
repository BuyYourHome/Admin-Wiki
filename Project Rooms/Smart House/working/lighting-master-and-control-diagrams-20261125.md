# Lighting master, controls and Pondster — November 25, 2026

## Authority and scope

Wes authorized adding the lighting schedule and Shelly review to Belong, adding smart-device and additional-load-relay columns to the source workbook, and connecting Pondster to the Teams/SharePoint master so edits do not require a second manually maintained specification. He subsequently supplied a revised four-light/six-control example and authorized applying its control approach across the defined house groups, with the switch/controller/relay assignments reflected in the workbook, diagrams and Pondster.

The initial three-control diagram was held at Wes's request and never published. His revised upload resumes work on the six-location example. Preserve the supplied PDF; do not silently convert it into a universal wiring drawing or assign it to a particular circuit.

This is Smart House website and source-package work. LED lighting's technical materials may be read for context, but no other Project Room or skill is edited. No devices are operated, purchases made or provider credentials provisioned.

## Single editable source — private mapping

- Master: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\26-BYH -908 Pond St\Owning\Planning\908-Pond-Electrical-Circuit-Schedule.xlsx` — the Windows copy is synced from Teams/SharePoint.
- Verified SharePoint drive: `b!4mDJWAoUZEiObH1uIc-tPNklzEL-JwdPrMve0F7Efu7K7Z-rHQDJTLJE2cO-WifT`.
- Verified item: `01ZGFUBDPPSHJYTXMYMBBKVM76K2H3EBBS`.
- Exact reference: `https://graph.microsoft.com/v1.0/drives/b!4mDJWAoUZEiObH1uIc-tPNklzEL-JwdPrMve0F7Efu7K7Z-rHQDJTLJE2cO-WifT/items/01ZGFUBDPPSHJYTXMYMBBKVM76K2H3EBBS`.

Keep these references, the street address, raw source text, author metadata, source ETag and local paths out of public projections. Public location remains Cary, North Carolina.

The main Circuit schedule owns quantities and models. Columns I:M distinguish total primary/input smart devices, their counted model bundle, additional **load** relays and control notes. New N:R distinguish load-controller quantity/model, ordinary remote quantity, input-module quantity/model. Derived I/J/P/Q and supporting sheets should follow the editable source cells; unknown station counts remain unknown. Existing fixture and control-location counts are preserved.

The expanded master was replaced only after rechecking its prior hash and the validated candidate, verifying an exclusive file-open check, and preserving `908-Pond-Electrical-Circuit-Schedule-before-control-approach-20261125.xlsx` beside it. Destination readback matches SHA-256 `c2fc02bf694fa3c638c2ab65d081c467c4d8edb2e6d6bfecab09bc6e377f32d9` (44,923 bytes). Native SharePoint returned the same configured item, version-2 ETag and modification time `2026-11-25T10:19:51Z`; the ETag stayed stable across the extracted-text read. The final generated seed was parsed from that cloud read, not a manually reconstructed table.

All eight tabs, original main A:H values/formulas/styles and four unrelated tabs were preserved. Formula errors are zero. ArtifactTool/.NET strict reimport and rendered review passed after correcting a duplicate generic XML content-type entry in the earlier export's package. Formula sensitivity checks proved changing L-011 from two to six locations recalculates five remotes, two input modules and three smart devices; a blank count remains TBD. The strip branch-budget dependency remains live and was restored after its test.

## Control approach

- Compatible ordinary lighting: one US wall dimmer at the primary location, with ordinary remote inputs through appropriately placed i4 UL modules. Dimmability, driver compatibility, neutral availability and the combined 150 W LED/CFL limit remain conditions, not verified installation facts.
- An i4 is input-only and has no load output. For this proposed arrangement, four available input channels give a per-group lower bound of `ceil(remote locations / 4)`; actual conductor and enclosure locations can require more modules.
- Fans, fan/light combinations and switched receptacles use conditional on/off load-controller candidates; they are not assigned a wall dimmer.
- Hidden analog-strip controllers stay powered under the revised proposal. All ordinary strip-wall stations are remote inputs, unlike a dimmer with its own face control. Retained PWM-controller quantities are provisional and require actual strip voltage, channel/total current, supplies, thermal/injection and compatibility checks. Do not parallel outputs or infer final controller quantities solely from removing a relay.
- The addressable stair group retains one conditional AC supply relay until its actual controller/API and recovery behavior are verified.
- Module stock and final purchase quantities remain separate from proposed requirements.

The prepared 25-group row review has 30 known load controllers, 12 known input modules and one additional load relay. Two bathroom input/station counts remain unresolved. The known 33 control locations reconcile with the existing source. These are planning subtotals; do not repeat them as immutable rules in code.

The supplied six-location example uses one wall dimmer, five ordinary remotes and two i4 input modules: three primary/input smart devices and zero additional load relays. Public per-group diagrams must instead use the current workbook roles and counts.

## Publication and synchronization

Version 89 is live: Belong's initial lighting references, downloadable workbook and separate Shelly review were published successfully on November 25. Source commit `1a53639e3ff3e96c24c2be516941e5a83f35c80c`; deployment `appgdep_6b06a731d4e08191a9daf5f15c989a21`; succeeded `2026-11-25T09:15:40.310100+00:00`. This version does not contain either diagram or automatic synchronization.

Version 90 is published and reads one sanitized D1 publication through `/api/lighting`. Belong, the generated public Excel extract, the separate review, all 25 per-group control diagrams and Pondster's typed/live reference use that projection. Natural conversation reloads current lighting data for delegated answers during an ongoing session. A bundled generated seed is only initial fallback data, not another editable master or proof of a cloud refresh.

The public workbook is an approved-field extract, not the eight-tab private master. Public outputs omit private source packaging and unapproved fields. Failed source validation retains the last good publication. Storage failures do not revert newer data to the initial seed. Exact-source binding, ETag comparison, modification-time checks, atomic update/readback and owner authorization protect updates.

The Site MCP writer uses the verified owner identity supplied by Sites. Runtime configuration names are `LIGHTING_SYNC_OWNER_EMAIL`, `LIGHTING_SOURCE_DRIVE_ID` and `LIGHTING_SOURCE_ITEM_ID`. No credentials belong in source or scheduled prompts. A public Site remains public; its writer remains owner-only.

Version 90 evidence: pushed source `ee04e4cc04617a4ca5de217bfffc31fb6958756a`; saved version `appgprj_6ad4d98e08708191858cab113814704e~appgver_db6eed7c4bc8819193c0cf104e1798a2`; deployment `appgdep_6b06b7c87b8081918db5a972e820d238`; succeeded `2026-11-25T10:26:24.942547+00:00`, environment revision 5. Native URL: https://pondstr.coolnewt4097.chatgpt.site ; custom domain remains https://pondstr.com . Public audience is unchanged. Archive hash `sha256:8a9d3b095baf34aafc4c1b7236510ea58af203fa41a87fe7d2e2c7149cb593f4`.

The newly provisioned Pondster plugin reports installed. Its tools became available in a fresh child context. Real owner status, exact stable-ETag SharePoint import and persistent readback passed. An unchanged-ETag replay returned `changed:false` and retained public revision `bc68e482329964d5319066c63ea4521a7a0108e295e2738200c6ee5e9540b949`; successful check `2026-11-25T10:31:18.617Z`. This proves the actual writer through the owner's tools, not an independent cloud scheduled run.

`Keep Pondster lighting in sync` is saved and enabled as cloud automation `Automation_fedd963ff67c819186343229959dd2da`, hourly in `America/New_York`, starting November 25 at 6:00 AM Eastern. Sites rejected a fifteen-minute cadence because this account permits at most one task run per hour; that failed attempt created no automation. Native Site automation metadata confirms exactly one linked task. The prompt binds to the configured master, passes raw extracted text verbatim to the owner writer, requires stable ETag/readback and preserves last-good data on failure. Routine updates do not republish source.

**Remaining verification:** the first independent cloud scheduled run has not executed yet. Do not describe its saved configuration or the authoring/child-context test as cloud-run proof. There is no supported run-now operation exposed, and the Sites workflow prohibits waiting solely for a scheduled occurrence to prove readiness. The first cloud run must verify both source and writer access and report a concrete blocker if either fails.

Public verification passed: current JSON returns 25 groups, 30 known load controllers, 12 known input modules, 42 known primary/input devices and one additional load relay; review HTML contains the same revision and 25 diagrams; the downloaded two-tab public XLSX contains the same revision/role columns and excludes the private address. The public six-location PDF matches the supplied SHA-256. Belong's source status and role tables and the living-room recessed/strip diagrams passed browser inspection. The direct diagram link opens the correct public PDF. Anonymous direct `/mcp` access on the custom domain is unavailable (404); owner MCP access succeeds, with explicit missing/other-owner denial covered by server tests.

No paid natural-voice trial was performed. Automatic approval review rejected the optional Ask-me UI check because it might start paid conversation; verification continued using the direct public document links. No alternate route was used to bypass that rejected conversation action.

Live proof: `C:\Users\wesbr\.codex\visualizations\2026\10\16\01a14585-ffe6-7850-8db1-efcdd58e7071\pondster-lighting-diagrams-live-20261125.jpg`. Owned implementation text is mirrored under `site/gallery-source`; source/document binaries remain outside Wiki Git.

## Source and evidence references

### Equipment-name cleanup and deferred LED example

Wes subsequently requested concise equipment designations without parenthetical qualifiers such as “compatible dimmable load.” Keep operating conditions and rating notes separate from model names. Exactly 51 authoritative model cells were simplified: primary models O6:O30, input models R6:R30 and the stair supply-relay model L17. Fifty derived string caches followed the existing links. All 371 formulas, 465 numeric cached values, eight tabs, quantities, styles, row/column layout and separate control/rating notes were preserved; strict ArtifactTool reimport and visual checks passed.

The cleaned master was hash-checked, backed up as `908-Pond-Electrical-Circuit-Schedule-before-label-cleanup-20261125.xlsx`, copied and read back. Current workbook SHA-256 is `f1df844e3bf0a17681c99ad0504d403cbc9437a21dc3468e8caf4e351f9bae8d` (44,713 bytes). Native SharePoint metadata remained stable across the extracted-text read; the real owner writer published revision `8a732026ee8580e6fe3ba58a8e61b27ef4f85a66adaaac767bcb0e25acd05390` at `2026-11-25T11:37:43.650Z`. Public JSON has no parenthetical model names and preserves all 25 groups, 30 known load controllers, 12 known input modules and one additional load relay.

One independent report reference caption also dropped the word “candidate”; its separate functional/rating notes were retained. Source `568bd24df78adb24e6e6eef5370d784b80939eb0` was built and published as version 91, saved version `appgprj_6ad4d98e08708191858cab113814704e~appgver_60655f6e913c8191a024bb8ab1b19ef5`, deployment `appgdep_6b06c98ec0a881919118aac5a1a1290d`, succeeded `2026-11-25T11:42:23.404411+00:00`, environment revision 5. Archive hash: `sha256:7755d9380aae17990d18775824925f9826d9180046e6050016cefa7aa40d6426`. Focused model/server tests, supported build, exact-caption diff and public report/readback passed. The current report uses the same data revision as the API; its 25 diagrams remain.

Wes also described a separate, generic LED-strip example with one Shelly wall dimmer, one ordinary manual switch and one LED controller, explicitly without revising any house group. He then cancelled Codex diagram creation: “forget the diagram. I will provide it.” No new LED example was published or applied to the workbook. Await Wes's supplied diagram; do not resume or substitute a generated draft. This cancellation does not undo the completed equipment-name cleanup or the previously published six-location example.

- Earlier technical review: [[Project Rooms/Smart House/outputs/908-pond-shelly-controls-review-2026-11-24]].
- Supplied revised PDF: `C:\Users\wesbr\Downloads\shelly-four-lights-six-controls.pdf`; SHA-256 `d425dce2998be4c32b5c1e66b69afeb26b28d3fd17b487be4831ee161753af40`.
- Pre-expansion master SHA-256: `381a9c10702199e07a9f5e9f08d58e5c482bba337740aceaee3c95e70be4519d`.
- First source update preserved a backup named `908-Pond-Electrical-Circuit-Schedule-before-smart-controls-20261125.xlsx` beside the master.
- Binary sources, workbook candidates, raw extracted text and visual QA remain outside Wiki Git. Only owned notes and text implementation sources belong in the scoped commit.
