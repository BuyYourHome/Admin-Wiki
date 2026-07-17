# Gracious Millionaire Element Map 030

Created 2026-07-17 after Wes approved removal of the public Contact Us blocks identified in map 029.

## Live Changes

### Books

- Removed both remaining `working title` references.
- Reframed the lead as a book project by Wes and Jenny Browning.
- Added intentional references to `Gracious Millionaire - Drawn by Grace` and `The L.D. Evans story`.
- Hid the Contact Us module with Beaver Builder visibility `Never`.

### Themes

- Removed the lower About the Book block's remaining `working title` reference.
- Added the same related-manuscript references.
- Hid the Contact Us module with visibility `Never`.

### Journal

- Changed the visible `Blog` heading to `Editing Notes`.
- Hid the private stock-post grid, category selector, newsletter opt-in button, generic multi-service About block, Categories block, and Contact Us block with reversible visibility controls.
- Replaced the orphaned newsletter heading and sentence with `Notes in Progress` and `Editing notes will be shared here when they are ready for public release.`

## QA

- Both custom-domain and preview Books URLs return HTTPS HTTP 200, contain no `working title` or street-address text, and include both related manuscript names.
- Both custom-domain and preview Themes URLs return HTTPS HTTP 200 with the same working-title/contact cleanup and related-manuscript references.
- Both Journal hosts return HTTPS HTTP 200 and render `Editing Notes`, `Notes in Progress`, and the release-status sentence.
- Journal no longer renders the private stock posts, category selector, newsletter prompt/button, multi-service placeholder, street address, phone, or Contact Us block.
- Desktop visual QA passed on Books, Themes, and Journal without overlap or broken layout.
- No form was submitted and no routing, recipient, autoresponder, SMS, email, DNS, or public workflow setting was changed.

## Remaining Work

- The Updates form still uses `GET STARTED >>` and its hidden-column layout still leaves excess whitespace.
- The Updates structural-delete path remains blocked by repeated builder timeouts.
- The Books destination now references all three projects but still uses the former single-page About composition rather than a dedicated multi-book layout.
- True mobile QA remains pending because the prior Chrome viewport override did not change the actual browser width.

## Exact Next Objective

Use a later stable text/presentation path to improve the Updates submit label without changing routing or sending the form. Do not retry the Updates structural-delete path until Beaver Builder proves it can complete and publish a structural action. Then run genuine mobile QA after confirming the browser's actual viewport width.
