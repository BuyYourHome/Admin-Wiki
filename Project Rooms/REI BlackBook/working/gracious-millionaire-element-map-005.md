# Gracious Millionaire Element Map 005

Created 2026-07-09 by `gm-mode-site-iteration` after the scheduled photo-retry and thank-you cleanup pass.

Audit targets:

- `https://graciousmillionaire.com`
- `https://www.graciousmillionaire.com/thank-you/`
- `https://u113450.h.reiblackbook.com/generic6/thank-you/`

## Run Summary

Safe live content fixes completed:

- Replaced the visible `Thank You for Contacting Us!` heading on the Update Request Received page with `Update Request Received`.
- Replaced the generic 24-48 hour callback / immediate-phone-call confirmation copy with book-update confirmation language:
  - `Thanks for asking to follow Gracious Millionaire.`
  - `The book is still being edited. Future updates and excerpt availability will be shared as the project moves closer to release.`

These were low-risk Beaver Builder text edits. No form routing, SMS/email workflows, contact details, DNS, images, personal photos, manuscript chapter content, legal/financial/compliance claims, or outbound messages were changed.

Photo retrieval retry:

- The logged-in Chrome session had an open Google Photos photo page.
- A single Chrome-controlled Google Photos `Download` action succeeded.
- No Microsoft Photos process opened during or after the controlled download check.
- Existing selected local photo candidates remain under `sources\gracious-millionaire-photos\` and are still local-only. They must not be uploaded publicly or committed to GitHub without Wes's explicit approval.

Public QA:

- `https://u113450.h.reiblackbook.com/generic6/thank-you/` returned title `Update Request Received - Gracious Millionaire`.
- `https://graciousmillionaire.com/thank-you/` returned title `Update Request Received - Gracious Millionaire`.
- Both public checks found the new heading and new confirmation copy.
- Both public checks did not find the old `Thank You for Contacting Us!` heading or the old 24-48 hour callback copy.

## Current Global State

| Element | Current state after live pass | Remaining action |
| --- | --- | --- |
| Main navigation on original template pages | `Home`, `Book Themes`, `About the Book`, `Request Updates`, `Editing Notes`. | Keep; verify after deeper builder/menu work. |
| Main navigation on newer Book Outline and Chapter Being Edited pages | Still shows `Home`, `Services`, `About`, `Contact`, `Blog`. | Fix menu inheritance or menu assignment for newer pages. |
| Site logo | Still generic REI BlackBook `generic_logo.png`. | Next GM Mode run should use `outputs\gracious-millionaire-assets\gracious-millionaire-logo-header-2026-07-09.png`, cropped from the approved logo concept. Upload is blocked until Chrome Codex extension file access is enabled. |
| Footer copyright | Still `Copyright 2015 . All rights reserved.` | Update when footer editing path is confirmed. |
| Shared/sidebar About Us widget | Still says Gracious Millionaire is a multi-service company with `[list business services here]`. | Replace with book-project description or hide widget. |
| Shared/sidebar Blog widget | Still shows generic internet-success/creative/goals posts. | Replace with book update links or hide until approved posts exist. |
| Shared/sidebar Categories widget | Still `All`, `Best Tips Ever`, `Success Stories`. | Replace with book categories or hide. |
| Search form | Still appears on many pages. | Keep only if Editing Notes/updates remain active; otherwise remove from public pages. |
| Stock images/backgrounds | Still generic stock assets. | Next GM Mode run should add/use `outputs\gracious-millionaire-assets\gracious-millionaire-book-cover-concept-2026-07-09.png` where a cover visual is appropriate. Upload is blocked until Chrome Codex extension file access is enabled. Continue treating personal Google Photos as separate assets that need explicit public-photo approval. |

## Page Status

### Home

URL: `https://u113450.h.reiblackbook.com/generic6/`

Current title: `Home - Gracious Millionaire`

Improved:

- Navigation shows `Book Themes`, `About the Book`, `Request Updates`, and `Editing Notes`.

Remaining:

- Generic logo.
- Stock hero/background and thumbnail images.
- Footer copyright still says `Copyright 2015`.

### Book Themes

URL: `https://www.graciousmillionaire.com/services/`

Current title: `Book Themes - Gracious Millionaire`

Improved:

- Visible page heading says `Book Themes`.
- Theme blocks describe `Stewardship`, `Faith and Calling`, `Work and Responsibility`, `Generosity`, `Jenny's Perspective`, and `Lessons Still Unfinished`.
- CTA says `Explore the outline` and describes the chapter-outline/editing-status flow.

Remaining:

- Shared/sidebar About Us widget still contains generic multi-service-company language.
- Shared/sidebar Blog and Categories widgets remain generic.
- Public contact/address block remains visible in shared footer/sidebar area.
- Footer copyright still says `Copyright 2015`.
- Generic logo and stock assets remain.

### About the Book

URL: `https://www.graciousmillionaire.com/about-2/`

Current title: `About the Book - Gracious Millionaire`

Improved:

- Main body describes `Gracious Millionaire` as the working title of a book by Wes and Jenny.
- The page states the site is for updates, the chapter outline, editing status, and future excerpt requests.
- Feature headings are `A Faith-Centered Story`, `Wes and Jenny's Reflections`, and `Stories Still Being Edited`.
- CTA says `Follow the book's progress` and links to the book outline.

Remaining:

- Shared/sidebar About Us widget still contains generic multi-service-company language.
- Shared/sidebar Blog and Categories widgets remain generic.
- Public contact/address block remains visible in shared footer/sidebar area.
- Footer copyright still says `Copyright 2015`.
- Generic logo and stock/broken image placeholders remain.

### Request Updates

URL: `https://u113450.h.reiblackbook.com/generic6/contact/`

Current title: `Request Updates - Gracious Millionaire`

Improved:

- Browser/page title is `Request Updates`.
- Navigation label changed on the original template pages.

Remaining:

- Visible heading still says `Contact Us`.
- Lead text still says `Fill out the form below and we'll contact you shortly!`.
- Button still says `GET STARTED >>`.
- Public street address and phone remain visible.
- SMS consent remains visible.
- Sidebar widgets remain generic.

Boundary note:

- Do not change form routing, SMS workflow, public contact details, or address display without explicit Wes approval.

### Editing Notes

URL: `https://u113450.h.reiblackbook.com/generic6/blog/`

Current title: `Editing Notes - Gracious Millionaire`

Improved:

- Browser/page title is `Editing Notes`.
- Navigation label changed on the original template pages.

Remaining:

- Visible heading still says `Blog`.
- Generic post titles still show: `Will You Be an Internet Success?`, `Creatives: Think out of the box`, `Setting Your Goals`, `10 Small Steps To Improve Your Health`, `5 Rules for Negotiating Like a Pro`, and `7 Signs of an Entrepreneur`.
- Generic categories still show `Best Tips Ever` and `Success Stories`.
- Subscribe CTA still says `Like what you see? Sign up for our newsletter`.
- Sidebar widgets remain generic.

### Book Outline

URL: `https://u113450.h.reiblackbook.com/generic6/book-outline/`

Current title: `Book Outline - Gracious Millionaire`

Improved:

- Core outline content remains book-focused.

Remaining:

- Navigation still shows old labels: `Services`, `About`, `Contact`, `Blog`.
- Footer copyright still says `Copyright 2015`.
- Generic logo remains.

### Chapter Being Edited

URL: `https://u113450.h.reiblackbook.com/generic6/chapter-being-edited/`

Current title: `Chapter Being Edited - Gracious Millionaire`

Improved:

- Core chapter-status content remains book-focused.

Remaining:

- Navigation still shows old labels: `Services`, `About`, `Contact`, `Blog`.
- Footer copyright still says `Copyright 2015`.
- Generic logo remains.

### Update Request Received

URL: `https://u113450.h.reiblackbook.com/generic6/thank-you/`

Current title: `Update Request Received - Gracious Millionaire`

Improved:

- Visible heading now says `Update Request Received`.
- Body text now confirms the user is following the `Gracious Millionaire` book project and that the book is still being edited.
- Public QA found the new copy on both the preview URL and public domain.

Remaining:

- Shared/sidebar About Us widget still contains generic multi-service-company language.
- Shared/sidebar Blog and Categories widgets remain generic.
- Public contact/address block remains visible in shared footer/sidebar area.
- Footer copyright still says `Copyright 2015`.

## Next Live Edit Pass

Recommended order:

1. Replace Request Updates visible heading/helper/button wording without changing form routing or SMS consent.
2. Fix menu inheritance/assignment so Book Outline and Chapter Being Edited show the updated navigation labels.
3. Replace or hide generic shared/sidebar widgets.
4. Fix footer copyright.
5. Enable Chrome Codex extension file access, then use the approved Gracious Millionaire logo header crop and book-cover concept in the next run: replace the generic logo and place the cover concept where a cover visual fits. Keep personal Google Photos separate unless Wes explicitly approves those specific photos for public use.
