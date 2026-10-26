# Pondster voice: prepared OpenAI Support request

Status: sent through the signed-in official OpenAI Help support chat on 2026-10-26; human escalation confirmed. The request contains account/project identifiers and application timestamps, but no credential, payment details, audio, transcript, SDP or private property location.

Owning chat: Smart House, `01a14585-ffe6-7850-8db1-efcdd58e7071`.

## Approval and continuation

Resolved decision: Wes answered **Yes—send the support request** to the exact question about sending the prepared request, including the API organization/project IDs and two failed-request timestamps, to confirm session creation, closure and usage.

The approved message below was sent, then a follow-up requested a human API specialist and case number. The automated response could not verify the two attempts from timestamps alone. The official chat displayed **Escalation requested** and **Escalated to a support specialist**, with replies expected in coming days and also by email. No case number was displayed; do not substitute a number from an unrelated older support conversation. Proof outside Git: `C:\Users\wesbr\.codex\visualizations\2026\10\26\pondster-support-escalated.png`. The signed-in support tab is retained for continuation.

Wes then asked whether the two attempts could be canceled. A scoped follow-up was sent in the same approved support conversation: **Please cancel any still-active Live sessions associated with the two UTC attempts identified above in that exact API organization/project. Please confirm whether they existed, their provider session IDs, closure and final usage. This cancellation request is limited to those two voice sessions.** The message is visible as sent. Cancellation itself is not confirmed; no API plan, key, billing setting or local reservation was canceled or cleared.

Await actual provider evidence. Keep Browser voice and typed guidance available and preserve both uncertain reservations. The same authorization permits continuing this scoped support conversation; it does not permit sending keys, payment details, cookies, private house records, audio or transcripts. No mailbox checking or recurring follow-up was configured. A generic support suggestion to retry does not establish session creation/closure or authorize bypassing the website's limits.

## Exact approved message (sent)

Subject: GPT-Live creation status needed for two failed Pondster voice requests

Please help investigate two failed GPT-Live starts for the public Pondster website at https://pondstr.com . The website could not obtain a provider session ID or a session.closed event. Its safety controls now preserve both attempts as unconfirmed and prevent another start.

- API organization: `org-6hhPwlIw5tjFOgfHd5xbz6mr`
- API project: `proj_znosabwXUoxbhVE7fxsL3cd0`
- Model: `gpt-live-1`
- Endpoint: `POST https://api.openai.com/v1/live/sessions`, WebRTC transport
- Attempt 1, UTC: `2026-10-26T04:59:01.567Z`; application request ID `690cbd94-804a-4dc1-bf27-f2476a028659`
- Attempt 2, UTC: `2026-10-26T10:53:47.127Z`; application request ID `59bac828-75c8-4427-a212-e64084db8afc`

Those two UUIDs are internal application IDs, not OpenAI x-request-id values, and were not sent as X-Client-Request-Id. The original provider HTTP result/request ID is no longer available in the hosting service's bounded recent-log view. Both rows have null provider IDs and final usage unconfirmed; those facts alone do not prove no session was created.

The API account was still a zero-credit free trial when these attempts occurred. The owner has since enabled pay-as-you-go API billing, verified on 2026-10-26. The hosted model-metadata check returns HTTP 200, which does not prove voice execution or closure. The website retains its existing configured project key.

For each UTC window, please confirm whether a provider voice session was created. If rejected, please identify the HTTP/error outcome. If a session was created, please provide its provider session ID, whether it is closed, and the available final-usage evidence or supported reconciliation procedure. Please advise how to recover an unknown session safely without bypassing application limits or treating elapsed time as proof of closure.

No credential or audio content is included in this request.

## Internal evidence (not part of the proposed message)

- Native Sites database read on 2026-10-26 verified exactly two unconfirmed rows above and the separately reconciled original failed row `aa4eb72d-ebce-4b7d-9d3b-f1a3c3064afc`.
- Billing overview for the configured organization/project displayed Pay as you go and $50.00 API credit. No financial setting was changed by Codex.
- Current official GPT-Live [session guidance](https://developers.openai.com/api/docs/guides/live-conversations) and [server controls](https://developers.openai.com/api/docs/guides/voice-server-controls) do not supply recovery by these application UUIDs; the unknown provider session IDs prevent trusted attachment for closure. No numerical eight-hour closure guarantee was found.
- Both uncertain rows must remain unchanged until evidence supports exact reconciliation. The old redirect-validation repair applies only to its original exact row.
