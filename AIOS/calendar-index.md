# AIOS Calendar Index

This index groups time-based context in the Admin wiki. It is an ACE overlay index, not a folder migration.

## Purpose

Use this when the request asks:

- what happened,
- when something ran,
- what changed by date,
- what the last cutoff was,
- what a recurring workflow is supposed to review,
- or where dated logs live.

## Automation Schedules And Run Context

| Area | Path |
| --- | --- |
| Agents and automation registry | `Agents and Automations Registry.md` |
| Doc Scan automation notes | `Document Scanning SOP.md` |
| Morning email summary rules | `AGENTS.md` and `Agents and Automations Registry.md` |
| Connector availability checks | `Connector and Plugin Usage Rules.md` |

Local automation definitions live outside the wiki under:

```text
C:\Users\wesbr\.codex\automations
```

Inspect those only when the request involves automation setup, schedules, or runtime behavior.

## Dated Logs And Histories

| Area | Path |
| --- | --- |
| AIOS maintenance history | `AIOS/maintenance-log.md` |
| AIOS smoke test | `Project Rooms/AIOS/working/new-chat-smoke-test-2026-06-08.md` |
| AIOS step-11 revision log | `Project Rooms/AIOS/working/step-11-revision-log-2026-06-08.md` |
| Grocery request log | `operations/grocery-list/data/request-log.md` |
| Grocery purchase history | `operations/grocery-list/data/purchase-history.md` |
| Wiki log | `wiki/log.md` |

## External Time-Based Locations

Some time-based operational logs live outside the wiki, especially scan logs:

```text
C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files\Logs
```

Use external logs only when the workflow calls for them. Treat scanned document logs and source folders as potentially sensitive.

## Rule

Do not move files into a `Calendar/` folder. This page is the Calendar view of the existing wiki.
