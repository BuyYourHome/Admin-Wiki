# Manager Task Register

Use this register as the durable status record for Manager Tasks.

## Allowed Values

- Priority: `Critical`, `High`, `Normal`, `Low`
- Status: `New`, `Delivered`, `Acknowledged`, `In Progress`, `Waiting`, `Completed`, `Cancelled`

## Tasks

| Task ID | Received | Requester | Task | Priority | Status | Due | Delivered | Last Updated | Source / Delivery / Update Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| MGR-20260719-001 | 2026-07-19T16:08:21Z | Wes Will Buy Your Home | Josh should be proactive in keeping Wes out of the field; on every project, look for ways to add value before Wes has to ask; work closely with Tim, take instruction from Tim, bridge communication between Tim and Wes, track hours by project/task, and keep regular office hours for training and systems exposure. | Normal | New |  |  | 2026-07-23 | Source: `sources\email\2026-07-19 - Joshua.md`. Delivery not requested in this cleanup step. |
