# Missing Context

These items should be resolved before making major live automation changes.

| Question | Why It Matters | Status |
|---|---|---|
| Should the new development chat also become the live automation `target_thread_id`? | This controls where future failure/blocker notices appear. Changing it affects live automation visibility. | Needs Wes approval before change. |
| Where should persistent run memory live if it is not already in the automation environment? | The skill requires last verified Boss summary send time and run-state updates. | Needs implementation confirmation. |
| What reliable text/SMS fallback is available for summary failures? | Current rules require text/SMS fallback when available, but the reliable path must be confirmed before use. | Needs confirmation. |
| Should token-summary reporting remain in the daily email? | Current skill includes token totals when reliable. | Keep current behavior unless Wes changes it. |
