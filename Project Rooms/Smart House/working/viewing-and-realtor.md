# View page, realtor, and self-viewing preview

## Wes requirements — 2026-10-23

Wes directed Smart House to find content from the realtor's website, feature her on View, and add a calendar/date and entry-code experience for visiting without a realtor. He clarified to use her email domain to identify her and then explicitly said: "For now. The entry code will be simulated. Later we will connect it to a real lock."

The website portion is authorized. No real lock, account provisioning, message sending, or live access-control work is performed by this implementation.

## Realtor sources

- Targeted Outlook People lookup for Ashley returned Ashley Morello and business address `ashley@elementrealtygroup.net`, matching the public professional candidate. No email was sent and no unrelated private email content was used.
- Official domain: https://elementrealtygroup.net/ .
- Official brokerage profile: https://ashleymorello.allentate.com/ . The profile identifies Ashley as REALTOR / Team Founder with Element Realty Group at Howard Hanna Allen Tate and publishes phone 919-417-0612. It describes service across Cary, Apex, Raleigh, and surrounding Triangle communities.
- The View page uses a short factual paraphrase and links to both official sites. The direct brokerage page presented an automated browser check to the local downloader, so no portrait was obtained or guessed. An AM monogram is used instead of a headshot. No third-party personal records were used as website content.

## Implemented behavior

- View features Ashley's name, role, brokerage, business email, phone, and official website links.
- Embedded native date picker and Eastern-time selection produce a viewing preview and a `DEMO-` prefixed six-digit simulated code.
- Date selection requires today or a future property-local date. Times are illustrative, not confirmed availability.
- The confirmation clearly says no appointment was booked and the code does not unlock the house. Selections remain in component memory and are not sent to Ashley or stored in D1.
- Changing the selection clears the previous preview. No personal information is collected by the demo.
- A separate email link lets visitors request an actual viewing from Ashley. Opening the link does not send an email or confirm an appointment.
- The visual notebook remains available as an expandable section, preserving the design images and enlarge behavior. Design voting and the Media Center motion clip remain unchanged.

## Virtual design tour — 2026-10-25

Version 30 adds Wes's automatic vote-based virtual design tour. Its invitation appears above the early-buying design note and realtor/viewing cards, while the original visual notebook remains below. See [[Project Rooms/Smart House/working/virtual-design-tour]] for scene selection, soundtrack, playback, and validation.

## Future connection

A real booking calendar needs verified availability, booking ownership, confirmation/delivery rules, cancellation handling, and a selected provider. A real lock connection needs an identified system and authorized Home Assistant implementation, with codes tied to confirmed windows and revocable access. Do not represent this public preview as a working door-access system or place actual lock secrets in the frontend.

See [[Project Rooms/Smart House/working/hosting-and-domain]] for the published version and verification.

Published as Sites version 6 at https://pondstr.com/#view . The production build, local demo flow, selection reset, phone layout, and live custom-domain demo passed. No live door or actual appointment integration was activated.

## Portrait and anonymous introduction — 2026-10-24

Wes requested Ashley's picture on View. The former Allen Tate profile now redirects to https://ashleymorello.howardhanna.com/ . Its live About Me page, https://ashleymorello.howardhanna.com/Agent/Content/108213/about_me, visibly identifies Ashley Morello and publishes the 628-by-628 portrait at https://ashleymorello.howardhanna.com/ClientImage/Agent-Full/108213.jpg . The browser's observed page-asset export recovered the image after a prolonged download stall; a direct shell fetch had been challenged. The exported JPEG was visually inspected and copied unchanged to the separate Site repo as `/people/ashley-morello.jpg`. No portrait binary is stored in Admin Wiki Git. The photo replaces the prior AM initials, and the official website link now uses the current Howard Hanna hostname.

While this request was active, Wes directed that the property address be removed for now, with coy wording that Pondster needs to start anonymously. The public greeting, brand marks, footers, page metadata, Built By identity line, guide/location answers, viewing-email subject/body, and voting-error copy now use Pondster without the property address. The Sites display title is Pondster. Current public app/lib/build/assets were searched for the old street-address text. All five exterior concept images were visually checked and contained no legible property address or street number.

Keep the internal property association and private source history for room operations. This is an anonymous introduction on the current public website, not a claim that past published versions or third-party records have been erased. The existing URL, realtor contact, concept galleries, and simulated viewing functionality remain in place.

## Early-buyer design participation — 2026-10-24

Wes asked for a View-page paragraph explaining that buyers who purchase in advance can have a say in final design. Place it prominently below the page introduction and above Ashley's profile/viewing preview, in Pondster's first-person voice:

> Buy me early, while I’m still taking shape, and you can have a say in my final design. Help choose from the finishes and details that are still open, so I can feel like your home from the start. Talk with Ashley, my realtor, about which choices are available and when they need to be made.

Keep this limited to choices still open; the paragraph does not promise control over every design decision or define prices, incentives, deadlines, or purchase terms. Ashley remains the contact for the actual options and timing. Publication and visual verification are recorded in the hosting notes.
