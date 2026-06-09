# Credit Worthiness Handoff

Drop the current Credit Worthiness Evaluator handoff for this buyer here as:

`Credit Worthiness Handoff.md`

This folder is an input location for Contract for Deed work. The handoff should identify buyer names/roles, credit decision, affidavit requirements, funds-to-close status, unresolved legal/compliance items, report path, and source cutoff date.

On CFD startup, use `Credit Worthiness Handoff.md` if it exists. Do not call CWE again only because `CWE Kickoff.md` also exists.

Use `CWE Kickoff.md` in this folder only when CFD needs CWE to start from files because no current handoff exists. The kickoff file is only a routing/source-control pointer: verified project/property, live project spreadsheet path, CFD transaction folder path, required handoff destination, and kickoff date/time. CWE derives transaction facts under the CWE skill rules, not from instructions stored in the kickoff file.
