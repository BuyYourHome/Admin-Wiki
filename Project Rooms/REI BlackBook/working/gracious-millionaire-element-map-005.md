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

Scope update, 2026-07-10:

- Wes broadened GM Mode so future passes may make comprehensive live site-design and site-structure improvements, not just conservative visible-copy fixes.
- Authorized live improvements now include design/layout cleanup, navigation/page-structure changes, sidebar/footer cleanup, approved logo/book-cover placement, visible-copy rewrites, button/field-label changes, and form presentation changes that keep the site focused on the Gracious Millionaire book project.
- Continue to stop before actions with outside consequences unless Wes explicitly approves the specific action: outbound form/SMS/email/lead workflow activation, changing who receives submitted leads or messages, public upload of personal Google Photos, public contact/address changes, DNS/domain changes, purchases, Git pushes, outbound messages, manuscript chapter publication, or legal/financial/compliance claims.

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

Scheduled GM Mode update, 2026-07-10 09:22 Eastern:

- On the Request Updates page, opened the Beaver Builder settings for the footer/sidebar `About Us` Text widget and changed it to:
  - Title: `About the Book`
  - Body: `Gracious Millionaire is the working title of a book by Wes and Jenny Browning about faith, stewardship, generosity, and the lessons still being shaped through their story.`
- Published the Beaver Builder change.
- Public QA passed on both `https://graciousmillionaire.com/contact/` and `https://u113450.h.reiblackbook.com/generic6/contact/`: the old `multi-service company` placeholder text is gone from that page, and the new book-focused About text is visible.
- Follow-up public checks show the same generic About widget text still remains on `Book Themes`, `About the Book`, `Update Request Received`, and `Editing Notes`, so this edit should be repeated page-by-page or replaced through a confirmed global/template edit path.

Manual GM Mode rerun, 2026-07-10 09:52 Eastern:

- Repeated the proven Beaver Builder Text-widget edit path on:
  - `Book Themes` / `/services/`
  - `About the Book` / `/about-2/`
- Public QA passed with `curl.exe`: both pages now show the `About the Book` widget title and the book-focused Wes/Jenny description, and no longer show the `multi-service company` placeholder in that widget.
- The batch browser edit timed out while moving into the next page. A recovery attempt to open `Update Request Received` with `?fl_builder` also timed out before the builder finished loading.
- No further live edits were made in this run after the timeout.
- Remaining generic About-widget pages confirmed by public QA:
  - `Update Request Received` / `/thank-you/`
  - `Editing Notes` / `/blog/`

## Current Global State

| Element | Current state after live pass | Remaining action |
| --- | --- | --- |
| Main navigation on original template pages | `Home`, `Book Themes`, `About the Book`, `Request Updates`, `Editing Notes`. | Keep; verify after deeper builder/menu work. |
| Main navigation on newer Book Outline and Chapter Being Edited pages | Still shows `Home`, `Services`, `About`, `Contact`, `Blog`. | Fix menu inheritance or menu assignment for newer pages. |
| Site logo | Updated live on `https://graciousmillionaire.com/` to use the uploaded Gracious Millionaire header logo. Public HTML no longer references `generic_logo.png`. | Keep monitoring public pages for any secondary theme areas that still inherit an old logo. |
| Footer copyright | Still `Copyright 2015 . All rights reserved.` | Update when footer editing path is confirmed. |
| Shared/sidebar About Us widget | Request Updates, Book Themes, and About the Book now use `About the Book` with book-focused copy. Update Request Received and Editing Notes still show the generic multi-service-company placeholder. | Repeat the proven Beaver Builder widget-settings edit on remaining pages when Chrome builder navigation is stable, or find a confirmed global/template edit path. |
| Shared/sidebar Blog widget | Still shows generic internet-success/creative/goals posts. | Replace with book update links or hide until approved posts exist. |
| Shared/sidebar Categories widget | Still `All`, `Best Tips Ever`, `Success Stories`. | Replace with book categories or hide. |
| Search form | Still appears on many pages. | Keep only if Editing Notes/updates remain active; otherwise remove from public pages. |
| Stock images/backgrounds | Homepage still has three generic stock thumbnail assets. | The approved book cover was uploaded to WordPress media as attachment `6319`; place it through a safe Beaver Builder module-edit path when available. Continue treating personal Google Photos as separate assets that need explicit public-photo approval. |

Contact-structure implementation attempt, 2026-07-10:

- BuyYourHomeLLC.com contact structure found:
  - Contact menu parent.
  - `Contact Form` at `https://www.buyyourhomellc.com/buyer/authority-contact/`.
  - `Contact Wes` at `https://u113450.h.reiblackbook.com/generic4/contact_wes/`.
- Gracious Millionaire already has the same basic lead-capture fields on `Request Updates`: Name, Email, Phone, SMS consent, and submit button.
- Initial visible-copy target from the conservative pass:
  - Heading: `Contact Wes and Jenny`.
  - Project identity: `Gracious Millionaire`.
  - Helper copy: `Use this page to request updates, future excerpt notices, and release information for the Gracious Millionaire book project.`
  - Form intro: `Fill out the form below and we'll follow up about the book project.`
  - Button: `REQUEST UPDATES >>`.
- Historical note: no live contact-page change was made in the first contact-structure attempt because the older WordPress/Page Builder edit screen blocked reliable mutation through the Chrome connector. A later Beaver Builder module-edit path succeeded for visible contact-page heading/helper text.

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
- Footer/sidebar About widget now says `About the Book` and uses book-focused Wes/Jenny project copy instead of generic multi-service-company copy.

Remaining:

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
- Footer/sidebar About widget now says `About the Book` and uses book-focused Wes/Jenny project copy instead of generic multi-service-company copy.

Remaining:

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
- Main visible heading now says `Contact Wes and Jenny`.
- Lead text now says `Fill out the form below and we'll follow up about the Gracious Millionaire book project.`
- Footer/sidebar About widget now says `About the Book` and uses book-focused Wes/Jenny project copy instead of generic multi-service-company copy.
- Public QA confirmed the form still shows Name, Email, Phone, SMS consent, and the existing submit button.

Remaining:

- Button still says `GET STARTED >>`.
- Public street address and phone remain visible.
- SMS consent remains visible.
- Blog, Categories, Contact Us, footer copyright, and form button remain generic or not yet redesigned.

Boundary note:

- Under the broader 2026-07-10 GM Mode scope, form presentation, visible button/field labels, and page structure may be improved live. Still do not activate outbound SMS/email/lead workflows, change who receives submissions, or change public contact/address details without explicit Wes approval for that specific action.

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

1. Repeat the proven Text-widget settings edit path on `Update Request Received` and `Editing Notes` when Chrome builder navigation is stable, or identify a confirmed global/template edit path.
2. Redesign the Request Updates/contact page around the `Contact Wes` structure Wes referenced, including better button wording and form presentation while avoiding outbound workflow activation or lead-recipient changes unless separately approved.
3. Place the uploaded Gracious Millionaire book cover on a public page through Beaver Builder or WordPress Media, then QA desktop/mobile rendering.
4. Fix menu inheritance/assignment so Book Outline and Chapter Being Edited show the updated navigation labels.
5. Replace or hide generic Blog/Categories widgets and search blocks that do not support the book project, then fix footer copyright and any remaining generic footer/sidebar public contact blocks.
