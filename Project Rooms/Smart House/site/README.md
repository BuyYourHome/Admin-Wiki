# Pond Street website draft

Local, dependency-free website concept for 908 Pond Street. Open `index.html` in a browser. HTML, CSS, and JavaScript travel together; no build or external service is required.

Wes asked to begin creating the Pond Street website in this chat on 2026-10-18. This first draft implements only a local concept preview. Public hosting, accounts, live controls, and device configuration are outside this draft.

Source: [[Project Rooms/Smart House/working/planning-context]] and the preserved planning conversation. The architectural artwork and room illustration are conceptual CSS drawings, not representations of verified property plans or photographs. Lighting scenes are simulated. Equipment, owner records, and portal capabilities are described as planned until verified.

No personal data, secrets, external fonts, analytics, network integrations, or real device commands are included. Home Assistant and LED lighting retain technical ownership. This source folder may be exported independently of the Admin wiki.

The four highlighted exterior AI concepts are local preview copies in ignored `assets/`. Restore these exact filenames from the SharePoint folder recorded in [[Project Rooms/Smart House/working/source-inventory]] when using a fresh checkout. They are intentionally absent from Admin Wiki Git. Do not treat them as current-condition photography or approved construction specifications.

Wes subsequently requested ChatGPT hosting for the purchased `Pondstr.com` domain. The public Site is deployed at https://pondstr.com and https://pondstr.coolnewt4097.chatgpt.site . DNS, custom-domain routing, and the HTTPS certificate are verified active. Wes requested removal of the visitor login gate on 2026-10-23. Sites access is public; an unauthenticated HTTPS request returned HTTP 200 and the Pond Street page without the login gate. See [[Project Rooms/Smart House/working/hosting-and-domain]]. The Sites source repository contains the four approved images for deployment; the Admin Wiki repository retains external references only. Reuse the project ID in `.openai/hosting.json`. Buildless publication uses `dist/` in the separate ignored `.hosting-work/` checkout, containing only `index.html`, `styles.css`, `app.js`, and the four image assets.
