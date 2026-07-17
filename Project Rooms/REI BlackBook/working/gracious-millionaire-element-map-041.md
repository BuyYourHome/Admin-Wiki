# Gracious Millionaire Element Map 041

Date: 2026-07-17
Status: Current working map. Supersedes map 040.

## Live Objective Completed

Wes explicitly approved the Foreword for public publication. The exact current Quick Mode Foreword is now public, and the Book Outline clearly distinguishes it from chapters that remain unavailable.

## Approved Foreword

- Authoritative source: `Project Rooms\Gracious Millionaire\outputs\quick-mode\chapters\01-foreword.md`
- WordPress page ID: `6396`
- Public URL: `https://www.graciousmillionaire.com/foreword/`
- Preview URL: `https://u113450.h.reiblackbook.com/generic6/foreword/`
- The theme supplies the single page H1 `Foreword`; the source heading is not duplicated in the body.
- Body typography is 18px with 1.75 line height and a maximum 780-pixel reading width.
- The 13 short questions are set as 20px editorial blockquotes without changing their wording.
- A visible opening notice says the Foreword is approved and explains that additional chapters will be linked from the outline after approval.
- The final link returns to the canonical Book Outline.

## Book Outline

- Public URL: `https://www.graciousmillionaire.com/book-outline/`
- Preview URL: `https://u113450.h.reiblackbook.com/generic6/book-outline/`
- A new 22px explanation heading states that approved chapters are marked `Available to read` and link to full chapter text.
- The Foreword is the only approved chapter. Its title link renders at 20px on an evergreen background with a separate gold `Available to read` label.
- The Foreword link now routes to `/foreword/`.
- The other 24 chapter links continue to route to `/chapter-being-edited/`.

## QA

- Both hosts contain the exact source opening `Some books begin with a question the author already knows how to answer.` and ending `Lordship is the invitation.`
- Both hosts show one Foreword H1, the approved-chapter notice, all 92 source text blocks, 13 styled questions, and the return link.
- Both outline hosts show exactly one `Available to read` link and 24 editing-status links.
- Production desktop QA found no horizontal overflow or inherited address/phone output.
- True 390 x 844 QA passed for the Foreword and outline with no horizontal overflow; the Foreword article renders at 335 pixels wide.
- No form, workflow, recipient, notification, contact detail, DNS setting, image, or other manuscript chapter changed.

## Reusable Implementation Note

For a single approved chapter, create a dedicated native WordPress page from the current authoritative chapter file, omit its Markdown H1 because the theme supplies the page title, and preserve the source paragraph order exactly. Update only the matching outline item, then verify one approved link and the unchanged count of editing-status links on both hosts.

## Remaining Backlog

1. Publish additional chapters only after Wes explicitly identifies and approves them.
2. Keep approved chapters visibly marked and linked from the Book Outline.
3. Select and place a more personal homepage main image when the exact photo is approved for public upload.
4. Define Journal signup and contact-form delivery, recipient, consent, and confirmation behavior before activation.
5. Consider replacing the low-resolution L.D. Evans video frame if a stronger source image is identified.

Exact next objective: wait for the next chapter approval, or select the personal homepage image.
