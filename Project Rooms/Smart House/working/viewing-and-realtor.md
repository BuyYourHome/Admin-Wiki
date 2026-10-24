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

## Future connection

A real booking calendar needs verified availability, booking ownership, confirmation/delivery rules, cancellation handling, and a selected provider. A real lock connection needs an identified system and authorized Home Assistant implementation, with codes tied to confirmed windows and revocable access. Do not represent this public preview as a working door-access system or place actual lock secrets in the frontend.

See [[Project Rooms/Smart House/working/hosting-and-domain]] for the published version and verification.

Published as Sites version 6 at https://pondstr.com/#view . The production build, local demo flow, selection reset, phone layout, and live custom-domain demo passed. No live door or actual appointment integration was activated.
