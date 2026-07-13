# Gracious Millionaire Publication Workflow

Separate manuscript writing from packaging and delivery so a packaging correction does not trigger a manuscript rewrite.

## Phase 1: Content

1. Identify the mode and controlling source set.
2. Update only the affected modular chapter files for Quick mode, or complete the required source maps before a directly requested full-manuscript mode.
3. Record the manuscript version in the mode manifest or manuscript heading.
4. Complete the mode-specific editorial and factual review.

## Phase 2: Build And Validate

1. Run `tools/gm-manuscript.cmd Quick refresh or tools/gm-manuscript.cmd Dialogue refresh` for a modular mode.
2. Confirm the cover is embedded, every manifest chapter appears, every outline link resolves, the version is visible, and word/page statistics are present.
3. For a non-modular legacy manuscript, validate the existing review packet without rewriting manuscript prose.
4. Treat cover, anchor, filename, and attachment corrections as packaging changes. Rebuild or resend the packet only; do not rerun the writing mode.

## Phase 3: Publish

1. Copy the review manuscript to Teams `SellYourHome / Documents / Marketing / Gracious Millionaire` using a filename that contains its version.
2. For a significant manuscript change, send the stable current review packet through the allowed OfficeAssist workflow and verify OfficeAssist Sent Items.
3. Record Teams and email delivery in `working/delivery-register.md`.
4. Update `working/current-state.md` and the applicable mode manifest.
5. Commit the scoped project-room changes. Push only when the Admin wiki rules authorize it.

## Versioned Teams Naming

- Keep versions in Teams filenames even when the local working filename is stable.
- Examples: `Gracious Millionaire - Quick Mode v1.html`, `Gracious Millionaire - Dialogue Mode v1.html`, and `Gracious Millionaire - Rewrite Mode v28.html`.
- Never overwrite a different version silently. Use replace only when correcting the packaging of the same manuscript version.

## Full-Mode Parallel Drafting

For directly requested Rewrite, Dialogue, or Interview manuscripts, create the controlling source map, chapter map, speaker boundaries, and chapter jobs first. Chapter groups may then be drafted in parallel from the same original-source snapshot. Assign disjoint chapter files, prohibit workers from using another mode product as source authority, and run one central continuity, redundancy, factual, voice, and fairness review before publication.
