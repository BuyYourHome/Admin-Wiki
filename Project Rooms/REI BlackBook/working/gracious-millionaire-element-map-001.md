# Gracious Millionaire Element Map 001

Created 2026-07-09 from a browser crawl of the current Gracious Millionaire REI BlackBook site.

Audit target:

`https://u113450.h.reiblackbook.com/generic6/`

Public domain:

`https://graciousmillionaire.com`

## Purpose

Map the current site elements locally before the next live edit pass. Wes's direction is that every visible element should describe something about the book, the book project, the authors, the outline, the editing status, updates, or excerpt requests. Generic business-template copy should be replaced, renamed, hidden, or removed.

## Global Elements

| Element | Current state | Book-focused direction |
| --- | --- | --- |
| Site logo | Generic REI BlackBook `generic_logo.png` with alt text `Gracious Millionaire`. | Replace with approved Gracious Millionaire logo/wordmark, or use text branding until a logo is approved. |
| Main navigation | `Home`, `Services`, `About`, `Contact`, `Blog`. | Rename to `Home`, `Book Outline`, `About the Book`, `Request Updates`, `Editing Notes` or remove/disable Blog until real book-update posts exist. |
| Footer copyright | `Copyright 2015 . All rights reserved.` | Update to current Gracious Millionaire copyright line after footer editing path is confirmed. |
| Sidebar About Us widget | Says Gracious Millionaire is a multi-service company with `[list business services here]`. | Replace with a short book-project description: Gracious Millionaire is a book by Wes and Jenny Browning about faith, stewardship, work, generosity, and lessons still being edited. |
| Sidebar Blog widget | Shows generic posts: `Will You Be an Internet Success?`, `Creatives: Think out of the box`, `Setting Your Goals`. | Replace with book-update links only, or hide the widget until approved update posts exist. |
| Sidebar Categories widget | Shows `All`, `Best Tips Ever`, `Success Stories`. | Rename or remove. If kept, use book categories such as `Book Updates`, `Chapter Notes`, `Author Reflections`, and `Release News`. |
| Sidebar Contact widget | Shows business contact details. | Keep only approved book-project contact details and update wording to request updates/excerpt notices. |
| Search form | Default WordPress search field appears on most pages. | Keep only if Blog/updates remain active; otherwise remove from public pages. |
| Stock background | Several pages use `SplitShire_Blur_Background_XVI.jpg`. | Replace with selected landscape photo after Chrome upload permission is fixed, or use a plain book-focused page style. |

## Home

URL: `https://u113450.h.reiblackbook.com/generic6/`

Status: mostly book-focused, but still has template imagery, generic navigation, default logo, search, and footer.

| Element | Current state | Book-focused direction |
| --- | --- | --- |
| H1 | `Gracious Millionaire` | Keep. |
| Hero text | `A book project by Wes and Jenny Browning about stewardship, faith, work, generosity, and the lessons being gathered from a life of calling.` | Keep as working copy. |
| Hero button | `View Outline` -> `/book-outline/` | Keep. |
| Supporting line | `A story of stewardship, favor, responsibility, and generosity.` | Keep. |
| Section heading | `Follow the Gracious Millionaire Book Project` | Keep or tighten to `Follow the Book Project`. |
| Card 1 | `Book Outline`; text says chapter text is not posted yet. | Keep; image should become `reader-notebook.jpg`. |
| Card 2 | `About the Book`; text explains why Wes and Jenny are gathering stories. | Keep; image should become `wes-jenny-building.jpg`. |
| Card 3 | `Request Updates`; text mentions book updates, excerpt notices, and release information. | Keep; image should become `faith-notes.jpg` or another approved update image. |
| CTA | `Want updates as the book develops?` with contact-page link. | Keep; later connect to a dedicated update/excerpt request form. |
| Images | Generic logo, one coffee-shop hero background, three stock thumbnail images. | Replace all with approved book-project imagery after upload is unblocked. |

## Services

URL: `https://u113450.h.reiblackbook.com/generic6/services/`

Status: not book-focused. This is the largest off-topic page.

| Element | Current state | Book-focused direction |
| --- | --- | --- |
| Page title | `Services` | Rename to `Book Themes`, `What the Book Explores`, or remove from navigation. |
| Service blocks | `Communication`, `Protection`, `Growth`, `Advice`, `Adventure`, `Payment Processing` with placeholder Latin-like copy. | Replace with book-theme blocks: `Stewardship`, `Faith and Calling`, `Work and Responsibility`, `Generosity`, `Jenny's Perspective`, `Lessons Still Unfinished`. |
| CTA | `Want to find out more? Why not visit our contact page, we would love to chat with you!` | Replace with `Want updates as the book develops? Request future Gracious Millionaire updates and excerpt notices.` |
| Sidebar widgets | Generic About, Blog, Categories, Contact. | Replace or remove according to global direction. |
| Image | Broken `[profile_image_url]` placeholder plus generic logo/background. | Remove broken image and replace background/logo after upload is unblocked. |

## About

URL: `https://u113450.h.reiblackbook.com/generic6/about-2/`

Status: not book-focused except the page title.

| Element | Current state | Book-focused direction |
| --- | --- | --- |
| Page heading | `About Gracious Millionaire` | Keep. |
| Body copy | Multiple paragraphs of Lorem Ipsum placeholder text. | Replace with book-project description: what Gracious Millionaire is, why Wes and Jenny are writing it, and what readers can expect without publishing manuscript content. |
| Three feature labels | `Fast Response`, `Professional Experience`, `Simplified Solutions`. | Replace with `A Faith-Centered Story`, `Wes and Jenny's Reflections`, `Stories Still Being Edited`. |
| CTA | `Looking for more info? Why not visit our contact page, we would love to chat with you!` | Replace with request-update/excerpt notice copy. |
| Image | Stock circular image plus broken `[profile_image_url]` placeholder. | Replace stock image with approved Wes/Jenny author-context photo; remove broken placeholder. |
| Sidebar widgets | Generic About, Blog, Categories, Contact. | Replace or remove according to global direction. |

## Contact / Request Updates

URL: `https://u113450.h.reiblackbook.com/generic6/contact/`

Status: form exists, but wording is still generic and contact details are business-template oriented.

| Element | Current state | Book-focused direction |
| --- | --- | --- |
| Page title | `Contact Us` | Rename visible page purpose to `Request Book Updates` or `Request Gracious Millionaire Updates`. |
| Contact block | Shows `Gracious Millionaire`, address, and phone. | Decide whether the public book site should show street address. Recommended: remove street address unless Wes explicitly wants it public; keep approved email/phone if desired. |
| Lead text | `Fill out the form below and we'll contact you shortly!` | Replace with `Use this form to request Gracious Millionaire updates, excerpt notices, and release information.` |
| Form fields | Name, Email, Phone, opt-in consent checkbox. | Keep fields, but align labels/help text to book updates and excerpt requests. Phone should be optional unless SMS workflow is intentionally used. |
| Button | `GET STARTED >>` | Replace with `Request Updates` or `Request Excerpt Notices`. |
| SMS consent text | Generic automated-message consent. | Keep only if the REI workflow will send texts. Otherwise adjust workflow/form to email-first before collecting phone consent. |
| Images | Generic logo, loading GIFs, broken `[profile_image_url]`. | Remove loading/broken visual placeholders from the live visitor experience where possible. |
| Sidebar widgets | Generic About, Blog, Categories, Contact. | Replace or remove according to global direction. |

## Blog

URL: `https://u113450.h.reiblackbook.com/generic6/blog/`

Status: not book-focused. It currently shows generic template posts and stock images.

| Element | Current state | Book-focused direction |
| --- | --- | --- |
| Page title | `Blog` | Rename to `Book Updates`, `Editing Notes`, or hide until real updates exist. |
| Category selector | `All`, `Best Tips Ever`, `Success Stories`. | Replace with book categories or remove until there are approved posts. |
| Post titles | `Will You Be an Internet Success?`, `Creatives: Think out of the box`, `Setting Your Goals`, `10 Small Steps To Improve Your Health`, `5 Rules for Negotiating Like a Pro`, `7 Signs of an Entrepreneur`. | Remove generic posts from navigation/public display, or replace with approved book-update placeholders such as `Why Gracious Millionaire Is Being Written`, `How the Outline Is Taking Shape`, and `When Excerpts Will Be Available`. |
| Subscribe CTA | `Like what you see? Sign up for our newsletter` with `Subscribe >>`. | Replace with `Want Gracious Millionaire updates? Request excerpt notices and release information.` |
| Images | Six generic stock blog images plus generic logo/background. | Replace only after approved book-update posts exist; otherwise hide stock blog listing. |
| Sidebar widgets | Generic About, Blog, Categories, Contact. | Replace or remove according to global direction. |

## Book Outline

URL: `https://u113450.h.reiblackbook.com/generic6/book-outline/`

Status: book-focused and should remain. It still inherits generic navigation, logo, search, and footer.

| Element | Current state | Book-focused direction |
| --- | --- | --- |
| Page title | `Book Outline` | Keep. |
| Main heading | `Gracious Millionaire Book Outline` | Keep. |
| Intro copy | Explains that the outline lists working chapter titles while the manuscript is being edited. | Keep. |
| Chapter links | 25 chapter titles, all pointing to shared chapter-status page. | Keep current behavior per Wes's instruction. |
| Update link | `Request updates about Gracious Millionaire`. | Keep and route to request-updates page after Contact is renamed. |
| Global inherited items | Generic navigation, logo, search, footer. | Update according to global direction. |

## Chapter Being Edited

URL: `https://u113450.h.reiblackbook.com/generic6/chapter-being-edited/`

Status: book-focused and should remain. It still inherits generic navigation, logo, search, and footer.

| Element | Current state | Book-focused direction |
| --- | --- | --- |
| Page title | `Chapter Being Edited` | Keep. |
| Body copy | Says the chapter is being edited and will be available later; notes that it is not a manuscript excerpt. | Keep. |
| Link | `Return to the book outline`. | Keep. |
| Global inherited items | Generic navigation, logo, search, footer. | Update according to global direction. |

## Thank You

URL: `https://u113450.h.reiblackbook.com/generic6/thank-you/`

Status: partly functional but generic.

| Element | Current state | Book-focused direction |
| --- | --- | --- |
| Page title | `Thank You for Contacting Us!` | Rename to `Thank You for Requesting Gracious Millionaire Updates`. |
| Body copy | Says Gracious Millionaire will respond within 24-48 hours and gives phone number. | Replace with `Thank you for your interest in Gracious Millionaire. We will send book updates, excerpt notices, or release information when they are ready to share.` |
| Sidebar widgets | Generic About, Blog, Categories, Contact. | Replace or remove according to global direction. |
| Images/background | Generic logo and stock background. | Replace after upload is unblocked. |

## Broken Or Unwanted URLs

| URL | Current state | Direction |
| --- | --- | --- |
| `/about/` | Returns `Page Does Not Exist`; real About page is `/about-2/`. | Either redirect `/about/` to `/about-2/`, rename slug to `/about/`, or avoid linking to `/about/`. |
| Individual chapter placeholder pages | Previously created before Wes clarified all chapter links can point to one page. | Leave unlinked for now, then delete/unpublish after confirming no useful content is attached. |

## Suggested Page Rename Map

| Current label | Proposed label | Reason |
| --- | --- | --- |
| `Services` | `Book Themes` | Services is off-topic for a book site. |
| `About` | `About the Book` | More specific and book-focused. |
| `Contact` | `Request Updates` | Matches the current purpose of collecting interested-party contact information. |
| `Blog` | `Editing Notes` or `Book Updates` | Avoids generic blog framing and can hold short approved project updates. |
| `Thank You` | `Update Request Received` | Makes form follow-up book-specific. |

## Next Live Edit Pass

Recommended order:

1. Rename navigation/page labels and remove or repurpose `Services`.
2. Replace Services page with book themes or remove it from navigation.
3. Replace About page Lorem Ipsum with book/about-author copy.
4. Rename Contact to Request Updates and adjust form heading, helper text, and button label.
5. Hide or repurpose Blog and generic posts.
6. Replace global sidebar widgets with book-focused widgets or remove sidebars.
7. Replace stock images after Chrome file upload permission is enabled.
8. Fix footer copyright and `/about/` broken URL.
