# Missing Context

| Question or Gate | Status | Decision Needed |
| --- | --- | --- |
| Approved QuickBooks connector or API integration | selected | Zapier QuickBooks Online MCP is the authorized integration path. Interactive Chrome is permitted for setup and OAuth only, not production invoice execution. |
| Zapier account login | needs Wes | The Zapier sign-in page is preserved in Chrome. Wes must sign in before QuickBooks OAuth can continue. |
| Connector authentication | blocked | Waiting for Wes to complete Zapier login; keep credentials, tokens, and personal MCP URLs outside Git and durable messages. |
| Least-privilege access | pending | Review and record the narrowest permissions reasonably available for invoice creation and read-back. |
| Five company connections | pending | After authentication, configure five separately named QuickBooks Online connections and record each exact display name and immutable connector identity without secrets. |
| Fixed tool set | pending | Permit only `Find Customer`, `Find Product/Service`, `Find Invoice`, and `Create Invoice`; readiness validation must not invoke `Create Invoice`. |
| Exact QuickBooks target company/file | needs Wes | Wes must identify and confirm the exact company/file; validation must compare its immutable connector identifier. |
| Safe validation environment | pending | Run read-only company identity, customer, product/service, and invoice lookups only. No production invoice creation or other business action is authorized. |
| Duplicate protection validation | pending | Prove the connector can search required duplicate fields before creation and preserve a stable source/idempotency reference. |
| Project Room messaging lifecycle | ready | Exact task registration, host access, and corrected synthetic lifecycle `prmsg-quickbooks-invoice-readiness-validation-20260831-1342-correction-001` completed on `WESSTUDIO` after exactly one notification. This does not satisfy connector readiness. |
