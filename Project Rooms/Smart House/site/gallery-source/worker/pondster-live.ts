// Public voice has a fixed backend configuration and no private house tools.
// Native WebSocket timers are a best-effort cap while this Worker remains alive;
// unconfirmed reservations deliberately remain occupied after a lost connection.
import { safeProviderFailure, VoiceProviderFailure } from './pondster-live-diagnostics';
export const VOICE_COOKIE = 'pondster_voice_visitor';
export const VOICE_DURATION_SECONDS = 180;
export const VOICE_SETUP_MS = 20_000;
const DAY_MS = 86_400_000;
const MAX_MESSAGE_BYTES = 65_536;
const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
const COOKIE_VALUE = /^[a-f0-9]{32}$/;
const ACTIVE_STATES = "'pending','active','closing','unconfirmed'";

export type VoiceEnvironment = {
  DB?: D1Database;
  OPENAI_API_KEY?: string;
  PONDSTER_VOICE_ENABLED?: string;
};
type PublicAction = { menu: string; room?: string; scene?: string };
type PublicAnswer = { text: string; action?: PublicAction };
type Socket = Pick<WebSocket, 'send' | 'close' | 'addEventListener'> & { accept?: () => void };
type Reservation = { requestId: string; visitorKey: string; createdAt: number; expiresAt: number };
type Finish = { state: 'closed' | 'failed' | 'unconfirmed'; usageSeconds: number; confirmed: boolean };
export type VoiceStore = {
  reserve: (reservation: Reservation) => Promise<boolean>;
  activate: (requestId: string, providerId: string) => Promise<void>;
  finish: (requestId: string, result: Finish) => Promise<void>;
};
type ControllerOptions = {
  client: Socket;
  store: VoiceStore;
  visitorKey: string;
  createSession: (sdp: string, signal: AbortSignal, requestId: string) => Promise<{ id: string; sdp: string }>;
  attach: (id: string, signal: AbortSignal) => Promise<Socket>;
  answer: (question: string) => PublicAnswer;
  now?: () => number;
  setTimer?: (callback: () => void, milliseconds: number) => ReturnType<typeof setTimeout>;
  clearTimer?: (timer: ReturnType<typeof setTimeout>) => void;
  track?: (task: Promise<unknown>) => void;
};

export function voiceIsAvailable(env: VoiceEnvironment) {
  return Boolean(env.DB && env.OPENAI_API_KEY?.trim() && env.PONDSTER_VOICE_ENABLED !== 'false');
}
export function voiceVisitor(request: Request) {
  const value = request.headers.get('cookie')?.split(';').map(part => part.trim()).find(part => part.startsWith(`${VOICE_COOKIE}=`))?.slice(VOICE_COOKIE.length + 1);
  return value && COOKIE_VALUE.test(value) ? value : null;
}
export function voiceStatus(request: Request, env: VoiceEnvironment) {
  const headers = new Headers({ 'Content-Type': 'application/json', 'Cache-Control': 'no-store, private', Vary: 'Cookie' });
  const origin = request.headers.get('origin');
  if (origin && origin !== new URL(request.url).origin) return new Response(JSON.stringify({ available: false }), { status: 403, headers });
  const visitor = voiceVisitor(request) ?? crypto.randomUUID().replaceAll('-', '');
  headers.set('Set-Cookie', `${VOICE_COOKIE}=${visitor}; Path=/; HttpOnly; SameSite=Strict; Max-Age=2592000${new URL(request.url).protocol === 'https:' ? '; Secure' : ''}`);
  return new Response(JSON.stringify({ available: voiceIsAvailable(env) }), { headers });
}
export async function hashVoiceVisitor(cookie: string, pepper: string) {
  const encoder = new TextEncoder();
  const key = await crypto.subtle.importKey('raw', encoder.encode(pepper), { name: 'HMAC', hash: 'SHA-256' }, false, ['sign']);
  const signed = await crypto.subtle.sign('HMAC', key, encoder.encode(`pondster-voice:${cookie}`));
  return Array.from(new Uint8Array(signed), value => value.toString(16).padStart(2, '0')).join('');
}

export const RESERVE_VOICE_SQL = `INSERT INTO voice_sessions (request_id, visitor_key, created_at, expires_at, state, usage_seconds, final_usage_confirmed)
 SELECT ?, ?, ?, ?, 'pending', 0, 0
 WHERE (SELECT COUNT(*) FROM voice_sessions WHERE created_at > ?) < 20
 AND (SELECT COUNT(*) FROM voice_sessions WHERE visitor_key = ? AND created_at > ?) < 4
 AND NOT EXISTS (SELECT 1 FROM voice_sessions WHERE visitor_key = ? AND created_at > ?)
 AND (SELECT COUNT(*) FROM voice_sessions WHERE state IN (${ACTIVE_STATES})) < 2
 AND NOT EXISTS (SELECT 1 FROM voice_sessions WHERE visitor_key = ? AND state IN (${ACTIVE_STATES}))
 ON CONFLICT(request_id) DO NOTHING`;

// A read-only preview of the same predicates used by the atomic reservation.
// It never releases an uncertain session or replaces the reservation at Start.
export const VOICE_ADMISSION_SQL = `SELECT CASE WHEN
 (SELECT COUNT(*) FROM voice_sessions WHERE created_at > ?) < 20
 AND (SELECT COUNT(*) FROM voice_sessions WHERE visitor_key = ? AND created_at > ?) < 4
 AND NOT EXISTS (SELECT 1 FROM voice_sessions WHERE visitor_key = ? AND created_at > ?)
 AND (SELECT COUNT(*) FROM voice_sessions WHERE state IN (${ACTIVE_STATES})) < 2
 AND NOT EXISTS (SELECT 1 FROM voice_sessions WHERE visitor_key = ? AND state IN (${ACTIVE_STATES}))
 THEN 1 ELSE 0 END AS admitted`;

export async function voiceAdmissionStatus(request: Request, env: VoiceEnvironment, base = voiceStatus(request, env)): Promise<Response> {
  if (base.status !== 200 || !voiceIsAvailable(env)) return base;
  const unavailable = () => new Response(JSON.stringify({ available: false,
    message: 'My natural voice connection needs a service check. You can use Browser voice or type to me.' }), { headers: base.headers });
  // A first status request has no request cookie yet: use exactly the identity
  // issued by voiceStatus rather than minting a second visitor for this check.
  const visitor = voiceVisitor(request) ?? base.headers.get('set-cookie')?.match(/^pondster_voice_visitor=([a-f0-9]{32})(?:;|$)/)?.[1];
  if (!visitor) return unavailable();
  try {
    const visitorKey = await hashVoiceVisitor(visitor, env.OPENAI_API_KEY!);
    const now = Date.now();
    const result = await env.DB!.prepare(VOICE_ADMISSION_SQL)
      .bind(now - DAY_MS, visitorKey, now - DAY_MS, visitorKey, now - 60_000, visitorKey)
      .first<{ admitted: number }>();
    return result?.admitted === 1 ? base : unavailable();
  } catch { return unavailable(); }
}

export function d1VoiceStore(db: D1Database): VoiceStore {
  return {
    async reserve(reservation) {
      const { requestId, visitorKey, createdAt, expiresAt } = reservation;
      const result = await db.prepare(RESERVE_VOICE_SQL).bind(requestId, visitorKey, createdAt, expiresAt,
        createdAt - DAY_MS, visitorKey, createdAt - DAY_MS, visitorKey, createdAt - 60_000, visitorKey).run();
      return result.success && result.meta.changes === 1;
    },
    async activate(requestId, providerId) {
      const result = await db.prepare("UPDATE voice_sessions SET provider_id = ?, state = 'active' WHERE request_id = ?").bind(providerId, requestId).run();
      if (!result.success || result.meta.changes !== 1) throw new Error('reservation unavailable');
    },
    async finish(requestId, result) {
      await db.prepare('UPDATE voice_sessions SET state = ?, usage_seconds = ?, final_usage_confirmed = ? WHERE request_id = ?')
        .bind(result.state, result.usageSeconds, result.confirmed ? 1 : 0, requestId).run();
    }
  };
}

function safeSend(socket: Socket, value: unknown) {
  try { socket.send(JSON.stringify(value)); } catch { /* Connection cleanup handles a departed visitor. */ }
}
function safeClose(socket: Socket | null) {
  try { socket?.close(1000, 'Pondster voice ended'); } catch { /* Already closed. */ }
}
function actionIsPublic(action: PublicAction) {
  return ['Design', 'Explore', 'View', 'Own', 'Built By'].includes(action.menu)
    && (!action.room || /^[a-z][a-z-]{0,49}$/.test(action.room))
    && (!action.scene || ['day', 'evening', 'relax'].includes(action.scene));
}

export function createPondsterLiveControl(options: ControllerOptions) {
  const now = options.now ?? Date.now;
  const setTimer = options.setTimer ?? setTimeout;
  const clearTimer = options.clearTimer ?? clearTimeout;
  const track = options.track ?? ((task: Promise<unknown>) => { void task.catch(() => {}); });
  const timers = new Set<ReturnType<typeof setTimeout>>();
  const later = (callback: () => void, milliseconds: number) => {
    const timer = setTimer(() => { timers.delete(timer); callback(); }, milliseconds);
    timers.add(timer); return timer;
  };
  const cancel = (timer: ReturnType<typeof setTimeout> | undefined) => { if (timer !== undefined) { clearTimer(timer); timers.delete(timer); } };
  let requestId: string | null = null;
  let reserved = false;
  let attempted = false;
  let creationRejected = false;
  let ready = false;
  let closing = false;
  let finished = false;
  let confirmed = false;
  let usageSeconds = 0;
  let sideband: Socket | null = null;
  let starting: Promise<void> | null = null;
  let finishing: Promise<void> | null = null;
  let closeMessage = 'I’ve ended our voice conversation.';
  let textCount = 0;
  let lastTextAt = -Infinity;
  let lastDelegationOffset = -1;
  let consumedTranscriptEnd = -1;
  const delegations = new Set<string>();
  const fragments: Array<{ text: string; start: number; end: number }> = [];
  let fragmentCharacters = 0;
  const abort = new AbortController();
  let resolveProviderClosed: () => void = () => {};
  const providerClosed = new Promise<void>(resolve => { resolveProviderClosed = resolve; });
  let complete: () => void = () => {};
  const completed = new Promise<void>(resolve => { complete = resolve; });
  const idle = later(() => { track(stop('I didn’t receive a voice request. Please try again.')); }, 10_000);

  function error(message: string) { safeSend(options.client, { type: 'pondster.error', message }); }
  function deliver(question: string, delegationId: string | null) {
    if (closing || !ready || !sideband) return;
    const reply = options.answer(question);
    // Short public facts only; no user text is sent as a trusted instruction.
    const content = reply.text.slice(0, 1500);
    sideband.send(JSON.stringify({ type: 'session.commentary.append', event_id: crypto.randomUUID(), delegation_id: delegationId, content }));
    if (reply.action && actionIsPublic(reply.action)) safeSend(options.client, { type: 'pondster.action', action: reply.action });
  }
  function providerMessage(data: unknown) {
    if (finished || typeof data !== 'string' || data.length > 131_072) return;
    let event: Record<string, unknown>;
    try { event = JSON.parse(data); } catch { return; }
    if (!event || typeof event !== 'object') return;
    if (event.type === 'session.closed') {
      const usage = event.usage as { seconds?: unknown } | undefined;
      if (typeof usage?.seconds === 'number' && Number.isFinite(usage.seconds) && usage.seconds >= 0) usageSeconds = usage.seconds;
      confirmed = true; resolveProviderClosed(); track(stop()); return;
    }
    if (event.type === 'session.usage.updated') {
      const usage = event.usage as { seconds?: unknown } | undefined;
      if (typeof usage?.seconds === 'number' && Number.isFinite(usage.seconds) && usage.seconds >= 0) usageSeconds = Math.max(usageSeconds, usage.seconds);
      return;
    }
    if (closing) return;
    if (event.type === 'error') { error('I couldn’t continue our live voice connection. Please try again later.'); track(stop()); return; }
    if (event.type === 'session.input_transcript.delta' && typeof event.delta === 'string'
      && typeof event.start_ms === 'number' && Number.isFinite(event.start_ms)
      && typeof event.end_ms === 'number' && Number.isFinite(event.end_ms)) {
      const fragment = { text: event.delta.slice(0, 2000), start: event.start_ms, end: event.end_ms };
      fragments.push(fragment); fragmentCharacters += fragment.text.length;
      while (fragments.length > 80 || fragmentCharacters > 8000) fragmentCharacters -= fragments.shift()!.text.length;
      return;
    }
    if (event.type === 'session.delegation.created') {
      const delegation = event.delegation as { id?: unknown; target?: unknown } | undefined;
      if (delegation?.target !== 'client' || typeof delegation.id !== 'string' || delegation.id.length > 256
        || delegations.has(delegation.id) || delegations.size >= 20 || typeof event.offset_ms !== 'number' || !Number.isFinite(event.offset_ms)) return;
      const id = delegation.id, offset = event.offset_ms, previousOffset = lastDelegationOffset;
      delegations.add(id); lastDelegationOffset = Math.max(offset, lastDelegationOffset);
      // A small buffer admits fragments delivered just after delegation metadata.
      later(() => {
        if (closing) return;
        const selected = fragments.filter(fragment => fragment.end > Math.max(previousOffset, consumedTranscriptEnd) && fragment.start <= offset + 250)
          .sort((a, b) => a.start - b.start);
        const question = selected.map(fragment => fragment.text).join('').trim().slice(-1500);
        if (selected.length) consumedTranscriptEnd = Math.max(consumedTranscriptEnd, ...selected.map(fragment => fragment.end));
        try {
          if (question) deliver(question, id);
          else sideband?.send(JSON.stringify({ type: 'session.commentary.append', event_id: crypto.randomUUID(), delegation_id: id, content: 'I couldn’t quite catch your question. Please ask me again.' }));
        } catch { error('I couldn’t answer that voice request. Please try again.'); track(stop()); }
      }, 250);
    }
  }
  async function finish() {
    if (finishing) return finishing;
    finishing = (async () => {
      if (sideband && !confirmed) {
        try { sideband.send(JSON.stringify({ type: 'session.close', event_id: crypto.randomUUID() })); } catch { /* Finalization remains unconfirmed. */ }
        await Promise.race([providerClosed, new Promise<void>(resolve => { later(resolve, 2000); })]);
      }
      finished = true; ready = false;
      for (const timer of timers) clearTimer(timer);
      timers.clear(); safeClose(sideband);
      if (reserved && requestId) {
        try { await options.store.finish(requestId, { state: confirmed ? 'closed' : creationRejected ? 'failed' : attempted ? 'unconfirmed' : 'failed', usageSeconds, confirmed }); }
        catch { /* Existing reservation remains occupied: fail closed. */ }
      }
      safeSend(options.client, { type: 'pondster.ended', message: closeMessage });
      safeClose(options.client); fragments.length = 0; complete();
    })();
    return finishing;
  }
  async function stop(message?: string) {
    if (message) closeMessage = message;
    closing = true; cancel(idle);
    if (starting) await starting;
    return finish();
  }
  async function start(sdp: string) {
    cancel(idle);
    const createdAt = now();
    const setup = later(() => {
      error('I couldn’t start my voice connection in time. Please try again later.');
      closing = true; abort.abort();
    }, VOICE_SETUP_MS);
    try {
      reserved = await options.store.reserve({ requestId: requestId!, visitorKey: options.visitorKey, createdAt, expiresAt: createdAt + VOICE_SETUP_MS + VOICE_DURATION_SECONDS * 1000 });
      if (!reserved) { error('I’m taking a short voice break. Please try again later.'); closing = true; return; }
      if (closing) return;
      attempted = true;
      const session = await options.createSession(sdp, abort.signal, requestId!);
      try { await options.store.activate(requestId!, session.id); }
      catch {
        // A D1 write failure must not prevent closing a session already created.
        error('I couldn’t save my voice session state. Please try again later.'); closing = true;
      }
      // Once a provider ID is known, cleanup must not reuse the setup signal:
      // creation may resolve even after that signal was aborted. A fresh bounded
      // attach lets us close the late session without activating browser audio.
      const attachAbort = new AbortController();
      const attachTimeout = later(() => {
        closing = true; attachAbort.abort();
      }, 5000);
      try { sideband = await options.attach(session.id, attachAbort.signal); }
      finally { cancel(attachTimeout); }
      sideband.addEventListener('message', event => providerMessage((event as MessageEvent).data));
      sideband.addEventListener('close', () => { track(stop()); });
      sideband.addEventListener('error', () => { if (!finished) { error('I lost my live voice connection. Please try again later.'); track(stop()); } });
      sideband.accept?.();
      if (closing) return;
      ready = true;
      later(() => { track(stop('I’ve reached my three-minute voice limit. You can keep exploring my website.')); }, VOICE_DURATION_SECONDS * 1000);
      safeSend(options.client, { type: 'pondster.ready', session: { id: session.id }, transport: { type: 'webrtc', sdp: session.sdp }, maxDurationSeconds: VOICE_DURATION_SECONDS });
    } catch (failure) {
      // A directly observed terminal create rejection is a failed startup, not
      // a confirmed provider close. Attach/transport/parse failures stay unknown.
      creationRejected = failure instanceof VoiceProviderFailure && failure.isDefinitiveCreateRejection();
      error(failure instanceof VoiceProviderFailure ? failure.message : 'I couldn’t start my live voice connection. My written guide is still available.'); closing = true;
    } finally {
      cancel(setup);
      if (closing) track(finish());
    }
  }
  async function message(data: unknown) {
    if (closing || finished) return;
    if (typeof data !== 'string' || new TextEncoder().encode(data).byteLength > MAX_MESSAGE_BYTES) {
      error('I can’t accept a voice message that large.'); return stop();
    }
    let input: Record<string, unknown>;
    try { input = JSON.parse(data); } catch { error('I couldn’t read that voice request.'); return stop(); }
    if (!input || typeof input !== 'object') { error('I couldn’t read that voice request.'); return stop(); }
    if (input.type === 'pondster.stop') return stop();
    if (input.type === 'pondster.start') {
      if (requestId || typeof input.requestId !== 'string' || !UUID.test(input.requestId)
        || typeof input.sdp !== 'string' || !input.sdp.startsWith('v=0') || input.sdp.length < 10) {
        error('I need a fresh voice connection. Please try again.'); return stop();
      }
      requestId = input.requestId.toLowerCase();
      starting = start(input.sdp); return starting;
    }
    if (input.type === 'pondster.text' && ready && typeof input.text === 'string' && input.text.trim().length > 0 && input.text.length <= 1000) {
      if (textCount >= 20 || now() - lastTextAt < 2000) { error('Please give me a moment before your next question.'); return; }
      textCount++; lastTextAt = now();
      try { deliver(input.text.trim(), null); } catch { error('I couldn’t answer that question.'); return stop(); }
      return;
    }
    error('I couldn’t use that voice command. Please try my voice controls.'); return stop();
  }
  return { message, stop, completed };
}

export async function handlePondsterLiveControl(request: Request, env: VoiceEnvironment,
  ctx: { waitUntil: (task: Promise<unknown>) => void }, buildSession: () => unknown, answer: (question: string) => PublicAnswer) {
  const reject = (message: string, status: number) => new Response(JSON.stringify({ error: message }), { status, headers: { 'Content-Type': 'application/json', 'Cache-Control': 'no-store' } });
  if (request.method !== 'GET') return reject('I need a WebSocket connection for live voice.', 405);
  if (request.headers.get('origin') !== new URL(request.url).origin) return reject('I can only start voice from my website.', 403);
  if (request.headers.get('upgrade')?.toLowerCase() !== 'websocket') return reject('I need a WebSocket connection for live voice.', 426);
  const visitor = voiceVisitor(request);
  if (!visitor) return reject('Please refresh my voice controls before starting.', 409);
  if (!voiceIsAvailable(env)) return reject('My live voice connection isn’t available yet.', 503);
  const visitorKey = await hashVoiceVisitor(visitor, env.OPENAI_API_KEY!);
  const pair = new WebSocketPair();
  const [client, server] = Object.values(pair);
  server.accept();
  const control = createPondsterLiveControl({
    client: server, store: d1VoiceStore(env.DB!), visitorKey, answer, track: task => ctx.waitUntil(task),
    async createSession(sdp, signal, clientRequestId) {
      let response: Response;
      try { response = await fetch('https://api.openai.com/v1/live/sessions', {
        method: 'POST', headers: { Authorization: `Bearer ${env.OPENAI_API_KEY!.trim()}`, 'Content-Type': 'application/json', 'X-Client-Request-Id': clientRequestId },
        body: JSON.stringify({ session: buildSession(), transport: { type: 'webrtc', sdp } }), signal, redirect: 'manual'
      }); } catch {
        console.warn('pondster.voice.provider', JSON.stringify({ stage: 'create-fetch', httpStatus: null, code: 'transport_failure' }));
        throw new Error('voice unavailable');
      }
      if (!response.ok) { const code = await safeProviderFailure(response, 'create-http'); throw new VoiceProviderFailure('create-http', response.status, code); }
      let payload: { session?: { id?: unknown }; transport?: { type?: unknown; sdp?: unknown } };
      try { payload = await response.json(); } catch {
        console.warn('pondster.voice.provider', JSON.stringify({ stage: 'create-json', httpStatus: response.status, code: 'invalid_json' })); throw new Error('voice unavailable');
      }
      if (typeof payload.session?.id !== 'string' || payload.session.id.length > 256 || payload.transport?.type !== 'webrtc'
        || typeof payload.transport.sdp !== 'string' || payload.transport.sdp.length > MAX_MESSAGE_BYTES) {
        console.warn('pondster.voice.provider', JSON.stringify({ stage: 'create-shape', httpStatus: response.status, code: 'unexpected_response' })); throw new Error('voice unavailable');
      }
      return { id: payload.session.id, sdp: payload.transport.sdp };
    },
    async attach(id, signal) {
      let response: Response;
      try { response = await fetch(`https://api.openai.com/v1/live/sessions/${encodeURIComponent(id)}/attach`, {
        headers: { Upgrade: 'websocket', Authorization: `Bearer ${env.OPENAI_API_KEY!.trim()}` }, signal, redirect: 'manual'
      }); } catch {
        console.warn('pondster.voice.provider', JSON.stringify({ stage: 'attach-fetch', httpStatus: null, code: 'transport_failure' })); throw new Error('voice unavailable');
      }
      if (!response.webSocket) { const code = await safeProviderFailure(response, 'attach-http'); throw new VoiceProviderFailure('attach-http', response.status, code); }
      return response.webSocket;
    }
  });
  server.addEventListener('message', event => { ctx.waitUntil(control.message(event.data)); });
  server.addEventListener('close', () => { ctx.waitUntil(control.stop()); });
  server.addEventListener('error', () => { ctx.waitUntil(control.stop()); });
  return new Response(null, { status: 101, webSocket: client });
}
