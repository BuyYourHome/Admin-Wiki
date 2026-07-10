# Gracious Millionaire Element Map 002

Created 2026-07-09 by `gm-mode-site-iteration` after the first scheduled GM Mode live pass.

Audit targets:

- `https://www.graciousmillionaire.com/`
- `https://u113450.h.reiblackbook.com/generic6/`

## Run Summary

Safe live content fixes completed:

- Renamed `Services` page title to `Book Themes`.
- Renamed `About` page title to `About the Book`.
- Renamed `Contact` page title to `Request Updates`.
- Renamed `Blog` page title to `Editing Notes`.
- Renamed `Thank You` page title to `Update Request Received`.

These were low-risk WordPress page-title edits. No form routing, SMS/email workflows, contact details, DNS, images, personal photos, manuscript content, legal/financial/compliance claims, or outbound messages were changed.

Public-domain check:

- `https://www.graciousmillionaire.com/` returned status 200 with title `Home - Gracious Millionaire`.
- REI preview URL returned status 200 with title `Home - Gracious Millionaire`.

## Current Global State

| Element | Current state after live pass | Remaining action |
| --- | --- | --- |
| Main navigation on original template pages | `Home`, `Book Themes`, `About the Book`, `Request Updates`, `Editing Notes`. | Keep; verify after deeper builder/menu work. |
| Main navigation on newer Book Outline and Chapter Being Edited pages | Still shows `Home`, `Services`, `About`, `Contact`, `Blog`. | Fix menu inheritance or menu assignment for newer pages. |
| Site logo | Still generic REI BlackBook `generic_logo.png`. | Replace with approved Gracious Millionaire wordmark/logo or text branding. |
| Footer copyright | Still `Copyright 2015 . All rights reserved.` | Update when footer editing path is confirmed. |
| Sidebar About Us widget | Still generic multi-service-company language. | Replace with book-project description. |
| Sidebar Blog widget | Still generic internet-success/creative/goals posts. | Replace with book update links or hide until approved posts exist. |
| Sidebar Categories widget | Still `All`, `Best Tips Ever`, `Success Stories`. | Replace with book categories or hide. |
| Search form | Still appears on many pages. | Keep only if Editing Notes/updates remain active; otherwise remove from public pages. |
| Stock images/backgrounds | Still generic stock assets. | Replace after Chrome upload permission and public-photo approval. |

## Page Status

### Home

URL: `https://u113450.h.reiblackbook.com/generic6/`

Current title: `Home - Gracious Millionaire`

Improved:

- Navigation now shows `Book Themes`, `About the Book`, `Request Updates`, and `Editing Notes`.

Remaining:

- Generic logo.
- Stock hero/background and thumbnail images.
- Footer copyright still says `Copyright 2015`.

### Book Themes

URL: `https://u113450.h.reiblackbook.com/generic6/services/`

Current title: `Book Themes - Gracious Millionaire`

Improved:

- Browser/page title changed from `Services` to `Book Themes`.
- Navigation label changed on the original template pages.

Remaining:

- Visible page heading still says `Services`.
- Body blocks still include `Communication`, `Protection`, `Growth`, `Advice`, `Adventure`, and `Payment Processing` with placeholder text.
- Sidebar widgets remain generic.
- Broken profile placeholder still appears in source.

Next safe live content direction:

- Replace service blocks with book-theme blocks: `Stewardship`, `Faith and Calling`, `Work and Responsibility`, `Generosity`, `Jenny's Perspective`, `Lessons Still Unfinished`.

### About the Book

URL: `https://u113450.h.reiblackbook.com/generic6/about-2/`

Current title: `About the Book - Gracious Millionaire`

Improved:

- Browser/page title changed from `About` to `About the Book`.
- Navigation label changed on the original template pages.

Remaining:

- Body still includes Lorem Ipsum placeholder copy.
- Feature labels still say `Fast Response`, `Professional Experience`, and `Simplified Solutions`.
- Sidebar widgets remain generic.
- Stock/broken image placeholders remain.

Next safe live content direction:

- Replace the body with a short book-project description.
- Replace feature labels with `A Faith-Centered Story`, `Wes and Jenny's Reflections`, and `Stories Still Being Edited`.

### Request Updates

URL: `https://u113450.h.reiblackbook.com/generic6/contact/`

Current title: `Request Updates - Gracious Millionaire`

Improved:

- Browser/page title changed from `Contact` to `Request Updates`.
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

- Browser/page title changed from `Blog` to `Editing Notes`.
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

- No change needed to the core outline content.

Remaining:

- Navigation still shows old labels: `Services`, `About`, `Contact`, `Blog`.
- Footer copyright still says `Copyright 2015`.
- Generic logo remains.

Next safe live content direction:

- Fix menu inheritance/assignment so this page uses the updated labels.

### Chapter Being Edited

URL: `https://u113450.h.reiblackbook.com/generic6/chapter-being-edited/`

Current title: `Chapter Being Edited - Gracious Millionaire`

Improved:

- No change needed to the core chapter-status content.

Remaining:

- Navigation still shows old labels: `Services`, `About`, `Contact`, `Blog`.
- Footer copyright still says `Copyright 2015`.
- Generic logo remains.

Next safe live content direction:

- Fix menu inheritance/assignment so this page uses the updated labels.

### Update Request Received

URL: `https://u113450.h.reiblackbook.com/generic6/thank-you/`

Current title: `Update Request Received - Gracious Millionaire`

Improved:

- Browser/page title changed from `Thank You` to `Update Request Received`.

Remaining:

- Visible heading still says `Thank You for Contacting Us!`.
- Body text is still generic response copy.
- Sidebar widgets remain generic.

Next safe live content direction:

- Replace visible text with book-update request confirmation language.

## Next Live Edit Pass

Recommended order:

1. Fix menu inheritance/assignment so Book Outline and Chapter Being Edited show the updated navigation labels.
2. Use Beaver Builder to replace visible headings/body copy on Book Themes, About the Book, Request Updates, Editing Notes, and Update Request Received.
3. Replace or hide generic sidebars/widgets.
4. Fix footer copyright.
5. Continue deferring image replacement until upload permission and public-photo approvals are complete.
