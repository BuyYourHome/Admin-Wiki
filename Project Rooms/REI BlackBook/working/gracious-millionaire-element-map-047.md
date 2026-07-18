# Gracious Millionaire Element Map 047

Date: 2026-07-18
Status: Current working map. Supersedes map 046.

## Journal Signup

- Public page: `https://graciousmillionaire.com/blog/`.
- Preview-host page: `https://u113450.h.reiblackbook.com/generic6/blog/`.
- Public presentation now uses `Join the Journal`, a clear email-frequency description, an unsubscribe expectation, and a visible `Join the Journal` button.
- The button opens the existing `Website - Subscribe` opt-in popup (form record 545548; opt-in record 545722).
- Public popup fields remain Name and Email. No phone or SMS field is present.
- Form 545548 now runs `GM - Tag Contact` (320804), updates an existing contact record when appropriate, and has submission-report email notifications disabled.
- The on-page confirmation says the reader is on the Gracious Millionaire Journal list and that new Journal posts and book updates will be shared as published.
- Passing name/email data to another page is disabled.
- No form was submitted during QA.

## Existing Updates Form

- Existing active form: `Website - Contact` (545547), source `Gracious Millionaire`.
- Public page: `https://graciousmillionaire.com/contact/`.
- Public fields remain Name, Email, and optional Phone; submit label remains `REQUEST BOOK UPDATES`.
- Contact duplicate handling remains `Update Contact Record`.
- Form 545547 runs `GM - Tag Contact` and its submission-report email notification is now disabled and verified after reopening through the supported editor path.
- No form submission, SMS, autoresponder, campaign, recipient change, or customer message was triggered.

## GM Contact Records

- Contact tag: `GM` (1163029).
- Contact workflow: `GM - Tag Contact` (320804).
- Workflow behavior: apply only the `GM` tag.
- Journal and Updates forms both attach the verified workflow and do not notify Wes of submissions.

## Inactive Draft Form

- `GM - Journal Signup` form 545720 (opt-in record 545721) remains inactive and unembedded.
- It contains First Name and Email, the GM workflow, disabled submission notifications, and the approved on-page confirmation.
- It was created while verifying the supported form path but is not used by the live Journal page because the existing site-specific 545548 popup was the correct reusable record.
- Do not activate, embed, duplicate, or delete it without a deliberate cleanup decision.

## Drawn by Grace Direct Index

- WordPress page 6405 remains live at `https://graciousmillionaire.com/drawn-by-grace-chapter-index/`.
- It remains absent from the main navigation and Books page.
- It contains only the 20 approved section titles and review-status labels; no manuscript body text is public.

## Manuscript Boundaries

- Foreword and Introduction remain the only publicly approved Gracious Millionaire chapter pages.
- L.D. Evans Chapters 4 and 5 and their four source-video URLs remain mapped locally but unpublished pending the owning project room's identity, chronology, location, and dialogue clearance.
- Drawn by Grace full chapter text remains withheld pending section-specific publication approval.

## QA

- The public Journal page shows only its intended heading, consent/frequency copy, and visible signup button; old posts, category output, generic multi-service copy, and contact details remain absent.
- The Journal button opens the Name-and-Email popup on the public domain.
- Form 545548 reopens with `GM - Tag Contact` selected, update-contact handling selected, and submission-report notifications unchecked.
- Form 545547 reopens with its GM workflow and submission-report notifications unchecked.
- The public Updates page still renders its three intended fields and `REQUEST BOOK UPDATES` button without exposing an address or direct contact block.
- Desktop visual QA found no clipping, overlap, or broken public element on Journal or Updates.

## Remaining Backlog

1. Select and approve the exact personal homepage hero image before any personal-photo replacement.
2. Obtain L.D. Evans manuscript-level clearance, then publish only cleared chapters with their matching YouTube links.
3. Identify approved Drawn by Grace sections, publish their direct pages, and link them from page 6405.
4. Publish another Gracious Millionaire chapter only after explicit chapter approval.
5. Decide whether inactive form 545720 should be retained as a draft or removed in a later cleanup pass.

Exact next objective: select the approved personal homepage image, or process the next explicit manuscript publication approval.
