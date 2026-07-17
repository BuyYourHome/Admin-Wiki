# Gracious Millionaire Element Map 026

Created 2026-07-17 while processing Wes's routed `GM Site` instruction email.

## Intake

- Source: `sources\email\2026-07-17-174421-gm-site.md`.
- Outlook message id was not previously processed.
- OfficeAssist had already added the routed source to `working\source-inventory.md` before this run.

## Live Change

- Changed the shared WordPress navigation label from `The Book` to `Books` and saved menu `Generic`.
- WordPress confirmed `Generic has been updated.`

## Public QA

- The REI preview homepage and both Updates-page hosts render `Books`.
- The custom-domain homepage still renders cached `The Book`, so menu propagation is incomplete across hosts.
- Both Updates-page hosts still publicly render the old working-title copy, Google map, street address, phone/email contact block, and broken profile placeholder.

## Staged Updates-Page Changes

The authenticated Beaver Builder tab at `/contact/?fl_builder` contains saved module changes that were not published before Chrome control failed:

- map module visibility set to `Never`;
- address/phone rich-text module visibility set to `Never`;
- Categories widget visibility set to `Never`;
- Contact Us widget visibility set to `Never`;
- About the Book copy changed to remove `working title` and reference `Gracious Millionaire - Drawn by Grace` and `The L.D. Evans story`.

Publishing through Windows Computer Use requires action-time confirmation because it changes public website content. The builder tab was left open for recovery.

## Asset Decisions And Blockers

- Current public homepage cover remains the July 10 cover.
- The approved replacement is `outputs\gracious-millionaire-assets\gracious-millionaire-book-cover-current-smaller-the-2026-07-16.png`, showing Wes and Jenny moving forward.
- Uploading that cover through the WordPress media uploader timed out before a file was selected; no new cover attachment was created.
- `reader-notebook.jpg`, WordPress media attachment `6325`, is the selected stronger replacement candidate for the homepage `Request Updates` card. It is already uploaded and was not applied in this pass.

## Exact Next Objective

After Wes confirms the action-time public publish step, recover the open Updates builder tab, click `Done` -> `Publish Changes`, and QA both public hosts. Then replace the homepage Request Updates image with media `6325`, retry the approved July 16 cover upload through a stable browser file-chooser path, replace the homepage cover, and QA desktop/mobile plus host propagation.
