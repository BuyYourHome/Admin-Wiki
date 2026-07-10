# Gracious Millionaire Element Map 003

Created 2026-07-09 by a manual GM Mode rerun after live About page cleanup.

Audit targets:

- `https://www.graciousmillionaire.com/`
- `https://u113450.h.reiblackbook.com/generic6/`

## Run Summary

Safe live content fixes completed:

- Replaced the `About the Book` page Lorem Ipsum body text with a short book-project description.
- Replaced the three generic About feature headings:
  - `Fast Response` -> `A Faith-Centered Story`
  - `Professional Experience` -> `Wes and Jenny's Reflections`
  - `Simplified Solutions` -> `Stories Still Being Edited`
- Replaced the generic About CTA block with book-progress language linking to the book outline.

These were low-risk Beaver Builder text edits. No form routing, SMS/email workflows, contact details, DNS, images, personal photos, manuscript chapter content, legal/financial/compliance claims, or outbound messages were changed.

Public QA:

- `https://www.graciousmillionaire.com/about-2/` returned title `About the Book - Gracious Millionaire`.
- Public About page contains the new book-project copy, the three new feature headings, and the new book-progress CTA.
- Public About page no longer contains Lorem Ipsum or the old feature headings.

## Current Global State

| Element | Current state after live pass | Remaining action |
| --- | --- | --- |
| Main navigation on original template pages | `Home`, `Book Themes`, `About the Book`, `Request Updates`, `Editing Notes`. | Keep; verify after deeper builder/menu work. |
| Main navigation on newer Book Outline and Chapter Being Edited pages | Still shows `Home`, `Services`, `About`, `Contact`, `Blog`. | Fix menu inheritance or menu assignment for newer pages. |
| Site logo | Still generic REI BlackBook `generic_logo.png`. | Replace with approved Gracious Millionaire wordmark/logo or text branding. |
| Footer copyright | Still `Copyright 2015 . All rights reserved.` | Update when footer editing path is confirmed. |
| Shared/sidebar About Us widget | Still says Gracious Millionaire is a multi-service company with `[list business services here]`. | Replace with book-project description or hide widget. |
| Shared/sidebar Blog widget | Still shows generic internet-success/creative/goals posts. | Replace with book update links or hide until approved posts exist. |
| Shared/sidebar Categories widget | Still `All`, `Best Tips Ever`, `Success Stories`. | Replace with book categories or hide. |
| Search form | Still appears on many pages. | Keep only if Editing Notes/updates remain active; otherwise remove from public pages. |
| Stock images/backgrounds | Still generic stock assets. | Replace after Chrome upload permission and public-photo approval. |

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

URL: `https://u113450.h.reiblackbook.com/generic6/services/`

Current title: `Book Themes - Gracious Millionaire`

Improved:

- Browser/page title is `Book Themes`.
- Navigation label changed on the original template pages.

Remaining:

- Visible page heading still says `Services`.
- Body blocks still include `Communication`, `Protection`, `Growth`, `Advice`, `Adventure`, and `Payment Processing` with placeholder text.
- Sidebar widgets remain generic.
- Broken profile placeholder still appears in source.

Next safe live content direction:

- Replace service blocks with book-theme blocks: `Stewardship`, `Faith and Calling`, `Work and Responsibility`, `Generosity`, `Jenny's Perspective`, `Lessons Still Unfinished`.

### About the Book

URL: `https://www.graciousmillionaire.com/about-2/`

Current title: `About the Book - Gracious Millionaire`

Improved:

- Main body now describes `Gracious Millionaire` as the working title of a book by Wes and Jenny.
- The page states the site is for updates, the chapter outline, editing status, and future excerpt requests.
- The old feature headings were replaced with `A Faith-Centered Story`, `Wes and Jenny's Reflections`, and `Stories Still Being Edited`.
- The generic contact CTA was replaced with `Follow the book's progress` and a link to the book outline.
- QA found no Lorem Ipsum and no old feature headings on the public About page.

Remaining:

- Shared/sidebar About Us widget still contains generic multi-service-company language.
- Shared/sidebar Blog and Categories widgets remain generic.
- Public contact/address block remains visible in shared footer/sidebar area.
- Footer copyright still says `Copyright 2015`.
- Generic logo and stock/broken image placeholders remain.

Next safe live content direction:

- Replace or hide generic shared widgets after confirming whether the footer/contact block should stay public.

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

Next safe live content direction:

- Change visible heading/helper/button wording only if it does not alter form routing or consent behavior.

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

Next safe live content direction:

- Hide the page from navigation or replace generic posts/categories with approved book-update placeholders.

### Book Outline

URL: `https://u113450.h.reiblackbook.com/generic6/book-outline/`

Current title: `Book Outline - Gracious Millionaire`

Improved:

- Core outline content remains book-focused.

Remaining:

- Navigation still shows old labels: `Services`, `About`, `Contact`, `Blog`.
- Footer copyright still says `Copyright 2015`.
- Generic logo remains.

Next safe live content direction:

- Fix menu inheritance/assignment so this page uses the updated navigation labels.

### Chapter Being Edited

URL: `https://u113450.h.reiblackbook.com/generic6/chapter-being-edited/`

Current title: `Chapter Being Edited - Gracious Millionaire`

Improved:

- Core chapter-status content remains book-focused.

Remaining:

- Navigation still shows old labels: `Services`, `About`, `Contact`, `Blog`.
- Footer copyright still says `Copyright 2015`.
- Generic logo remains.

Next safe live content direction:

- Fix menu inheritance/assignment so this page uses the updated navigation labels.

### Update Request Received

URL: `https://u113450.h.reiblackbook.com/generic6/thank-you/`

Current title: `Update Request Received - Gracious Millionaire`

Improved:

- Browser/page title is `Update Request Received`.

Remaining:

- Visible heading still says `Thank You for Contacting Us!`.
- Body text is still generic response copy.
- Sidebar widgets remain generic.

Next safe live content direction:

- Replace visible text with book-update request confirmation language.

## Next Live Edit Pass

Recommended order:

1. Fix menu inheritance/assignment so Book Outline and Chapter Being Edited show the updated navigation labels.
2. Replace the Book Themes visible heading and service blocks with book-theme blocks.
3. Replace Request Updates visible heading/helper/button wording without changing form routing or SMS consent.
4. Replace Update Request Received visible confirmation copy.
5. Replace or hide generic shared/sidebar widgets.
6. Fix footer copyright.
7. Continue deferring image replacement until upload permission and public-photo approvals are complete.
