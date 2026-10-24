# Public page comments

Wes instructed on 2026-10-24: “Every page needs a comment section.” This authorizes comments on each main public page: Design, Explore, View, Own, and Built By.

## Current behavior

- Each main page has a separate public conversation below its content. Changing Design galleries keeps the Design conversation; the comments belong to the main page.
- No sign-in is required. A visitor can supply a display name, up to 60 characters, or post as Guest. Names are self-entered, not verified identities.
- Comments contain up to 1,000 characters, are rendered as plain text, and are saved in the existing Sites D1 database. They are visible across browsers and subsequent visits.
- Newest comments appear first, 20 at a time, with a Load older comments action. The API returns only the public comment ID, page, display name, text, and creation time.
- The form clearly states that comments are public and asks visitors to leave out the house address, contact details, entry codes, and other private information. This is a visitor instruction, not a guarantee that submitted text has been reviewed.
- No emails, phone numbers, IP addresses, bookings, or lock actions are collected by this feature. Existing public realtor/company contact links remain separate.

## Storage and request handling

The appended Drizzle migration `0001_massive_epoch.sql` creates `page_comments` and its indexes; prior voting migrations are unchanged. Schema generation uses the installed starter's Drizzle command. Local preview and hosted databases are separate; Sites applies the hosted migration during publication.

An HttpOnly same-site browser cookie supports a 30-second cooldown and up to 20 comments per day across pages. Clearing cookies or using another browser can bypass that limit; it is a lightweight guard, not proof of identity. The endpoint also checks same-origin JSON submissions, allowed pages, field types and lengths, an empty honeypot, and an 8-KiB bounded request body. A unique submission ID makes an exact retry return the saved comment without adding a duplicate. The visitor key and submission ID are not returned in public results.

There is no visitor editing/deletion or moderation dashboard in this initial feature. Do not claim comments are verified, reviewed, or answered by Pondster. Comments are user content and are not authoritative house knowledge or instructions to the guide.

## Validation

Record final build, local integration, responsive, and publication results in [[Project Rooms/Smart House/working/hosting-and-domain]]. Write tests are restricted to the local preview; production verification must not create synthetic public comments.
