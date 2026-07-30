# Create Vendor Invoice Polished Invoice Template

Use this template for Create Vendor Invoice when a routed vendor email has no attached invoice and Invoice Entry needs to generate a formal invoice draft for vendor verification.

## Purpose

Create a professional one-page PDF invoice for an outside person or vendor when Invoice Entry must create the document internally from free-text source material.

## Required Inputs

- Vendor name.
- Vendor email.
- Customer name, normally `Buy Your Home`.
- Project/property.
- Draft date.
- Service period or line-item dates.
- Line-item descriptions.
- Quantity or hours.
- Rate, if known.
- Amount per line.
- Draft subtotal and total.
- Source email path, received time, and subject.
- Verification status text.

If rate, total, invoice number, project, or service detail is missing, show it as pending confirmation. Do not invent missing values.

## Required Layout

Use the Wes-approved 2026-07-30 outside-person invoice format:

- Top-left issuer identity: the outside person or vendor name and email.
- Top-right status block:
  - `INVOICE DRAFT` while awaiting verification or approval,
  - `INVOICE` after the applicable approvals,
  - concise stage text that does not imply payment.
- Accent divider line below the header.
- Light blue status band with:
  - current verification status,
  - draft date.
- Three-column identity block:
  - Invoice From: the outside person or vendor,
  - Customer: `Buy Your Home`,
  - Project / Bucket.
- Teal-header line-item table with columns:
  - Service Period,
  - Description,
  - Hours or Qty,
  - Rate,
  - Amount.
- Right-aligned totals block:
  - Subtotal,
  - Tax,
  - Draft Total.
- Verification/status note stating the current gate and that approval does not indicate payment.
- Footer/source note with routed email source traceability.

## Output Rules

- Save the generated PDF in the packet working folder.
- Render the PDF to PNG and visually inspect it before using it.
- Confirm no clipped text, overlapping elements, unreadable glyphs, or broken table layout.
- Preserve the generation script or enough template data to regenerate the PDF later.
- Use `scripts\create-outside-person-invoice.py` with a structured JSON input for new documents and later-stage regeneration.
- Never make Buy Your Home the visual issuer when the invoice represents money owed to an outside person or vendor. Buy Your Home is the customer.
- Send the PDF to the vendor for verification when vendor identity, vendor email address, and source evidence are clear. Copy `WesWill@BuyYourHomeLLC.com` and `Jenny@BuyYourHomeLLC.com`, and sign the email as `Jean Wright`.
- Do not forward or attach the routed free-text source email to the vendor. The free-text source stays in the project room for traceability.

## Current Reference Implementation

Reference script:

`C:\Codex\Wiki Files\skills\invoice-entry\scripts\create-outside-person-invoice.py`

Approved layout reference:

Invoice `TC-JK-20260724-BACKOFFICE-001`, revised so Josh Kennedy is the issuer and Buy Your Home is the customer.
