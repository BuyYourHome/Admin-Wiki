# Project Cost Allocation Report Template

Use this template for Josh Kennedy Time Card allocations.

## Purpose

Distribute Josh's fixed weekly service cost among projects and BackOffice according to accepted Time Card hours without creating additional invoices or payables.

## Required Labels

- `PROJECT COST ALLOCATION REPORT`
- `INTERNAL ALLOCATION ONLY`
- `NOT AN INVOICE`
- `NOT PAYABLE`

## Required Content

- worker,
- report number,
- report date,
- week-ending date,
- project or BackOffice destination,
- work dates, descriptions, and hours,
- allocated cost by line,
- allocated destination total,
- weekly cost and proportional-allocation method,
- source traceability,
- statement that the report does not authorize or request payment.

## Allocation Rule

For Josh, distribute the fixed `$1,250.00` weekly service cost proportionally:

`destination allocation = weekly cost x destination hours / total accepted weekly hours`

Round line allocations to cents and adjust the final line only when needed so all destination reports reconcile exactly to `$1,250.00`.

## Generator

`C:\Codex\Wiki Files\skills\invoice-entry\scripts\create-project-cost-allocation-report.py`
