# Gracious Millionaire REI BlackBook Site

Created 2026-07-09 in REI BlackBook WebTools Sites.

## Purpose From Wes

Create a site called `Gracious Millionaire` for information related to the book Jenny and Wes are writing. The site should collect contact information from interested parties and send book excerpts when requested.

## REI BlackBook Site Record

| Field | Value |
| --- | --- |
| Site name / nickname | `Gracious Millionaire` |
| REI site type | Generic |
| Site ID | `48842` |
| Current site URL | `http://graciousmillionaire.com` |
| Temporary REI builder URL | `https://u113450.h.reiblackbook.com/generic6/` |
| Control panel | `https://my.reiblackbook.com/webtools/sites/advanced/48842` |
| Site builder | `https://u113450.h.reiblackbook.com/generic6/` |
| Tagline set in merge fields | `A book by Wes and Jenny Browning` |
| Contact name set in merge fields | `Wes and Jenny Browning` |
| Contact email currently set | `WesWill@BuyYourHomeLLC.com` |
| Phone currently set | `919 917 7466` |

## Actions Completed

- Created a new Generic Business Site in REI BlackBook after Wes approved the confirmation warning.
- REI BlackBook warned that the installer would create Web Forms, Optin Popups, Action Sets, and Email Campaigns.
- Waited for the build to finish.
- Renamed the generated site from `Generic6` to `Gracious Millionaire`.
- Saved merge-field data for site name, company/name field, tagline, market, contact name, and phone.
- Verified the Websites page lists `Gracious Millionaire` as a Generic site.
- Imported `graciousmillionaire.com` into REI BlackBook Domains.
- Connected `graciousmillionaire.com` to REI BlackBook site ID `48842`.
- Changed GoDaddy nameservers for `graciousmillionaire.com` from `ns68.domaincontrol.com` and `ns67.domaincontrol.com` to REI's required Cloudflare nameservers: `albert.ns.cloudflare.com` and `arya.ns.cloudflare.com`.
- Re-checked the REI BlackBook nameserver status; REI reported `graciousmillionaire.com is active!`.

## Not Yet Configured

- SSL/TLS readiness for public `https://graciousmillionaire.com`; immediately after nameserver update, DNS resolved to Cloudflare and HTTP redirected, but HTTPS was not completing the TLS handshake yet. REI says DNS/nameserver propagation can take up to 24 hours.
- Actual page copy about the book.
- Contact form fields and notification routing.
- Excerpt request workflow.
- Email campaign copy for excerpts.
- Consent language for collecting contact information.
- Review of generated Web Forms, Optin Popups, Action Sets, or Email Campaigns.
- Published/mobile QA of the generated site.

## Safety Notes

- Do not send excerpt emails, activate broadcasts, or change generated workflows without Wes's explicit approval for that step.
- Before configuring excerpt delivery, identify which excerpts are approved to share and whether requests should be fulfilled by REI BlackBook email campaign, OfficeAssist, or another approved path.
