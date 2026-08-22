# Jean Quo Text Interface

## Purpose

Jean's Quo number is `(984) 459-7776`. OfficeAssist receives Quo message webhooks and gives Wes an immediate SMS response without waiting for a Codex heartbeat.

## Architecture

- Host: `OFFICEASSIST`
- Quo phone number ID: `PNH4YjkRKj`
- Quo number: `+1 984-459-7776`
- Authorized Wes sender: `+1 919-696-0339`
- Immediate response model: OpenAI Responses API using `gpt-5-mini`
- Destination Jean Wright task for work requests: `019e8e54-f8c3-7233-88dd-e1dffd79c9a6`
- Durable work transport: `Manage-ProjectRoomMessage.ps1` and the authoritative queue on `WES-VIDEOEDITOR`
- Public ingress: an outbound Cloudflare quick tunnel to a listener bound only to `127.0.0.1:8787`
- Scheduled task: `Codex - Quo Jean Instant Bridge`

At logon, the launcher starts the local listener and Cloudflare tunnel, creates a same-label Quo `message.received` webhook for the new tunnel URL, stores the returned signing key locally, and then removes prior bridge webhooks. Quo webhook requests must pass HMAC-SHA256 signature verification before processing.

## Response Contract

1. Quo delivers an authorized incoming SMS to OfficeAssist immediately.
2. The listener verifies the webhook signature, exact Quo number, direction, sender number, and event ID.
3. The OpenAI API classifies the text as `answer`, `handoff`, or `clarification` and generates a concise SMS response.
4. Safe conversational or informational questions may be answered directly.
5. Requests requiring files, current business data, external action, specialist work, or a safety decision become immutable Jean Wright queue records. The immediate SMS acknowledges routing but never claims completion.
6. The existing Project Room dispatcher wakes the registered destination task. The bridge checks the central record every 15 seconds and sends a final SMS only after a valid terminal result is recorded.
7. Event IDs, message IDs, dispatch IDs, and payload hashes provide deduplication. Unknown senders are not treated as Wes and receive no automatic response.
8. If an outbound Quo reply fails after the webhook has been accepted, the bridge saves the reply in local durable state and retries with bounded exponential backoff instead of silently dropping it.

The 15-second interval applies only to checking already-routed work for a final result. Incoming texts and their initial responses are webhook-driven; they do not wait for polling or the five-minute Email Monitor heartbeat.

## Safety Boundary

The instant model has no direct business tools and cannot perform external actions. It can answer simple questions or decide that Jean must handle the request. Email, purchases, payments, account changes, legal or financial changes, document changes, and specialized Project Room work remain subject to the normal Jean Wright and owning-workflow rules.

OpenAI response storage is disabled for bridge requests (`store=false`). Do not include credentials or full sensitive documents in SMS instructions.

## Secret Storage

Secrets are Windows DPAPI-encrypted for the OfficeAssist `wesbr` profile under:

`%LOCALAPPDATA%\BuyYourHome\Quo\`

- `api-key.dpapi` - Quo API key
- `openai-api-key.dpapi` - OpenAI API key
- `webhook-key.dpapi` - current Quo webhook signing key

Never place these values in Git, Markdown, a task message, a queue record, logs, screenshots, or command output.

## Local Runtime State

The same local folder contains non-secret runtime state and logs:

- `webhook.json` - current webhook ID and endpoint, without the signing key
- `instant-bridge-state.json` - processed event IDs, queued outbound replies, and pending/final dispatch return state
- `instant-bridge.log` - listener events without message bodies or secrets
- `launcher.log` and `cloudflared.*.log` - startup and tunnel diagnostics

## Availability Note

The first deployment uses a Cloudflare quick tunnel so OfficeAssist does not need inbound firewall or router changes. Quick tunnels are appropriate for this initial private interface but do not provide a production uptime SLA. A named Cloudflare tunnel can replace it later without changing the Quo/OpenAI processing contract.
