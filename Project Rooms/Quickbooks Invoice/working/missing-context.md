# Missing Context

| Question or Gate | Status | Decision Needed |
| --- | --- | --- |
| Approved QuickBooks connector or API integration | blocked | No callable QuickBooks/Intuit connector is available in the current Codex environment. Select and connect an approved integration; do not substitute browser automation. |
| Connector authentication | pending | Authenticate outside Git and durable messages after an approved integration is selected. |
| Least-privilege access | pending | Review and record the narrowest permissions reasonably available for invoice creation and read-back. |
| Exact QuickBooks target company/file | needs Wes | Wes must identify and confirm the exact company/file; validation must compare its immutable connector identifier. |
| Safe validation environment | pending | Use a QuickBooks sandbox, connector dry run, or another explicitly approved no-production-impact path. |
| Duplicate protection validation | pending | Prove the connector can search required duplicate fields before creation and preserve a stable source/idempotency reference. |
| Dedicated task and Project Room messaging lifecycle | pending | Create the task, register its exact identity, verify host access, and complete the one-notification synthetic lifecycle. |
