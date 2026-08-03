# Semimonthly Time Card Invoice Template

Use this template for Josh Kennedy LLC Time Card invoices.

## Purpose

Create one payable invoice for the semimonthly period while distributing its total among projects and BackOffice according to accepted Time Card hours.

## Required Labels

- `INVOICE`
- `DRAFT` until the period closes and Wes approves it
- `Josh Kennedy LLC`
- `profcyber0077@gmail.com`
- `Buy Your Home`

## Required Content

- issuer and contact email,
- invoice number,
- invoice date,
- semimonthly period,
- project and BackOffice allocation summary,
- work dates, descriptions, and hours,
- allocated cost by line,
- total amount due,
- period cost and proportional-allocation method,
- source traceability,
- statement that the report does not authorize or request payment.

## Allocation Rule

For Josh, total the fixed `$1,250.00` weekly service amounts included in the semimonthly period, then distribute the invoice total proportionally:

`destination allocation = invoice total x destination hours / total accepted period hours`

Round line allocations to cents and adjust the final line only when needed so every line and destination reconciles exactly to the single invoice total.

## Generator

`C:\Codex\Wiki Files\skills\invoice-entry\scripts\create-project-cost-allocation-report.py`
