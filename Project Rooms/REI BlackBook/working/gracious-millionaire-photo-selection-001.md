# Gracious Millionaire Photo Selection 001

Created 2026-07-09 from Wes-authorized review of the logged-in Google Photos session for Gracious Millionaire website imagery.

## Selected Photos

Personal photo files were copied locally for website preparation only and should not be committed or pushed to GitHub without Wes's explicit approval.

Local working folder:

`Project Rooms\REI BlackBook\sources\gracious-millionaire-photos\`

Web-sized upload copies:

`Project Rooms\REI BlackBook\sources\gracious-millionaire-photos\web-sized\`

| Website surface | Recommended replacement | Rationale |
| --- | --- | --- |
| Home hero background | `web-sized\hero-landscape-01.jpg` | Open landscape image that fits a reflective book site without revealing a private address or unrelated book content. |
| Secondary background / alternate hero | `web-sized\landscape-02.jpg` | Similar safe landscape option if the first crop does not fit the builder layout. |
| About the Book / author context card | `web-sized\wes-jenny-building.jpg` | Personal Wes/Jenny image that gives the site a real author signal. |
| Book Outline card | `web-sized\reader-notebook.jpg` | Reading and notes image that supports the book-outline section without publishing manuscript content. |
| Request Updates / faith-and-reflection card | `web-sized\faith-notes.jpg` | Faith and notes image that matches the reflective tone of the book, pending Wes/Jenny approval for public use. |

## Excluded Photos

| File | Reason |
| --- | --- |
| `PXL_20221016_115611702.MP.jpg` | Shows another book and inscription; do not use on the public site without a separate rights and messaging decision. |
| `PXL_20240622_193846129.MP.jpg` | Shows a house exterior with a visible street number; do not use on the public site. |

## Current Upload Blocker

The WordPress/REI BlackBook upload page is logged in and visible at:

`https://u113450.h.reiblackbook.com/generic6/wp-admin/media-new.php`

The Chrome connector can open the WordPress media uploader, but Chrome currently blocks Codex from passing local image files into the file chooser. The direct file chooser error is:

`Not allowed`

The direct WordPress upload endpoint and nonce are visible in the logged-in page, but the connector's isolated page context does not expose normal browser upload objects strongly enough to complete the upload without Chrome local-file permission.

Needed setting before Codex can upload the selected local photos through Chrome:

Go to `chrome://extensions`, click `Details` under the Codex extension, and enable `Allow access to file URLs`.

Reference: `https://developers.openai.com/codex/app/chrome-extension#upload-files`

## Next Replacement Pass

After Chrome file upload access is enabled:

1. Upload the five web-sized files into WordPress Media Library.
2. Replace the Home hero background with `hero-landscape-01.jpg`.
3. Replace the three Home callout/card images with `reader-notebook.jpg`, `wes-jenny-building.jpg`, and `faith-notes.jpg`.
4. Replace or remove the default `generic_logo.png`; if a true Gracious Millionaire logo is not approved, use text branding instead of a generic stock logo.
5. QA Home, Book Outline, and Chapter Being Edited on desktop and mobile.
