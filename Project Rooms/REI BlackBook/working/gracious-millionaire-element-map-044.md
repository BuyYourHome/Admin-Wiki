# Gracious Millionaire Element Map 044

Date: 2026-07-17
Status: Current working map. Supersedes map 043.

## Approved Workflow Specification

Wes approved the starting configuration for the Journal signup and contact form:

- Journal fields: first name and email.
- Journal purpose: weekly or occasional manuscript updates.
- Journal contacts: create or update the REI BlackBook contact record and apply the `GM` tag.
- Journal audience: contacts carrying the `GM` tag.
- Journal sending identity: `WesWill@BuyYourHomeLLC.com`.
- Journal confirmation: on-page confirmation.
- Journal email requirements: clear signup consent and an unsubscribe path.
- Contact fields: name, email, topic, and message.
- Contact handling: create or update the REI BlackBook contact record and apply the `GM` tag.
- Contact notifications: none to Wes.
- SMS and contact-form autoresponder: disabled.
- Newsletter signup and contact inquiry remain separate consent paths.

## Implementation Attempt

- Target: REI BlackBook Web Forms at `https://my.reiblackbook.com/forms/details`.
- The authenticated forms page opened in Chrome, but the controlled DOM did not return before timeout.
- A fresh Chrome reconnection found and claimed the existing REI BlackBook forms tab.
- The claimed tab timed out again before the current form records or settings could be inspected.
- No form, tag, Action Set, campaign, notification, sender, recipient, autoresponder, SMS, consent, or public page setting changed.
- The unstable agent-created forms tab was finalized and closed.

## Safety Decision

Do not create a replacement form or edit a guessed form record while the Web Forms inventory cannot be inspected. A partially configured form could capture contacts without the approved tag, consent, or notification behavior.

## Remaining Backlog

1. Retry the Web Forms inventory after Chrome and the REI forms editor are stable; identify the existing GM form records before editing.
2. Implement and verify contact capture plus the `GM` tag on both separate form paths without submitting public test contacts.
3. Configure Journal sender identity as `WesWill@BuyYourHomeLLC.com`, with no SMS, no contact autoresponder, and no Wes notification.
4. Add the approved fields, consent wording, unsubscribe expectation, and on-page confirmations to the public Journal and contact surfaces.
5. Select and place a more personal homepage main image when the exact photo is approved for public upload.
6. Publish additional chapters only after explicit chapter approval.

Exact next objective: retry the existing Web Forms inventory in a stable authenticated Chrome session, then edit only the verified GM form and workflow records.
