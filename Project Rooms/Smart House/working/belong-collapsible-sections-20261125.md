# Compact, collapsible Belong sections

## Request and behavior

On November 25, Wes requested collapsible cards because Belong had become too busy to identify sections without scrolling through all content. This authorizes the ordinary implementation, checks and publication under the existing website workflow.

All eight main reference cards start collapsed: permits, deck drawing, lighting and smart controls, LED example, AC example, equipment guides, more home guides and owner handover. Each heading remains visible in a compact row with a disclosure indicator. Visitors may independently open several sections. Nested circuit-schedule/review and camera/audio cards use the same native disclosure pattern. The introductory text is shortened to explain opening a section or asking Pondster for it.

Native `details`/`summary` provides keyboard behavior and expanded/collapsed semantics. Headings stay unique, focus is visible, and touch targets remain at least 44 pixels. Content and authored document links remain in the DOM behind the disclosures; no records, lighting data, workbook or PDF assets are changed by this layout update.

## Navigation preservation

The existing reveal effect checked visibility before opening a disclosure. That cannot find a nested record inside a collapsed ancestor. The new shared helper opens the target and all containing disclosures, outermost first, before any layout measurement; scrolling waits another animation frame. Repeated requests are idempotent and do not close other sections.

The seventeen existing Belong destination IDs are preserved. This covers individual permit records, deck drawing, schedule/review, both control examples, equipment guides, cameras/audio and future guide/handover destinations. Existing generic voice activation already includes native summaries, so an explicit click/press/toggle request can operate their unique heading labels.

Named L/LS circuit requests currently target the schedule card rather than an individual table row. Its ordinary and strip tables retain their existing expanded defaults inside the default-closed schedule. An explicit schedule reveal also reopens the authored table subsections if a visitor previously closed them; unrelated cards remain unchanged. Ordinary rendering or manual summary toggling does not force other disclosures open.

## Validation and publication

Six focused suites passed, covering native closed defaults, preserved references and source rows, unique headings, target/ancestor expansion before measurement, repeated navigation, manually closed schedule tables, unrelated disclosure state and generic summary voice activation. The real page-effect test checks that expansion precedes visibility/geometry reads. Strict TypeScript, the 236-text source/privacy scan, diff checks and the supported production build passed with confirmed exit 0. Source was frozen before packaging.

Version **94** is published. Site source `946ec8ee8cd78365f8598f00247411911d6801a4`; saved version `appgprj_6ad4d98e08708191858cab113814704e~appgver_ef9c7f11c39c81918593225c8949d217`; deployment `appgdep_6b074ec957808191bbdc9b9256883a00`, succeeded `2026-11-25T21:10:50.110756+00:00`, environment revision 5. Archive `sha256:190725d49693a0f2bcbe7ffaa8ad67b5ab4f5794a0dbd232c9576e9087995196`, 168 files / 119,982,080 bytes. Public audience and existing bindings are unchanged. Native URL: https://pondstr.coolnewt4097.chatgpt.site ; custom domain: https://pondstr.com .

Desktop Chrome inspection confirmed eight collapsed main headings in one view with Voice off. Clicking permits and deck allowed both to remain open. Space collapsed a focused section without closing its sibling. Enter expanded the nested camera guide inside equipment; native focus styling remained visible. The final compact view was restored. Responsive wrapping and minimum touch-target styles were reviewed; native live navigation was verified with the focused mocks, without a paid conversation.

Live proof: `C:\Users\wesbr\.codex\visualizations\2026\10\16\01a14585-ffe6-7850-8db1-efcdd58e7071\belong-collapse-20261125\pondster-belong-collapsed-live.jpg`. Owned text is mirrored under `site/gallery-source`. The source diff contains only text implementation/tests. Public records retain the scope approved in [[permits-card-20261125]]; the lighting master remains the source established in [[lighting-master-and-control-diagrams-20261125]].
