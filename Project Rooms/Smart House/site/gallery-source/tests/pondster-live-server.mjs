import assert from 'node:assert/strict';
import { DatabaseSync } from 'node:sqlite';
import { readFileSync } from 'node:fs';
import { createPondsterLiveControl, d1VoiceStore, handlePondsterLiveControl, hashVoiceVisitor, voiceAdmissionStatus, voiceStatus, VOICE_ADMISSION_SQL, RESERVE_VOICE_SQL, VOICE_DURATION_SECONDS, VOICE_FINALIZATION_MS } from '../worker/pondster-live.ts';
import { VoiceProviderFailure } from '../worker/pondster-live-diagnostics.ts';

const flush = async () => { for (let i = 0; i < 12; i++) await Promise.resolve(); };
const id = n => `00000000-0000-4000-8000-${String(n).padStart(12, '0')}`;
const start = n => JSON.stringify({ type: 'pondster.start', requestId: id(n), sdp: 'v=0\r\ns=local-test-only\r\n' });
function clock() {
  let now = 1_800_000_000_000, counter = 0;
  const timers = new Map();
  return {
    now: () => now,
    setTimer(fn, delay) { const timer = ++counter; timers.set(timer, { fn, at: now + delay }); return timer; },
    clearTimer(timer) { timers.delete(timer); },
    async tick(delay) {
      const end = now + delay;
      while (true) {
        const next = [...timers].filter(([, value]) => value.at <= end).sort((a, b) => a[1].at - b[1].at)[0];
        if (!next) break;
        now = next[1].at; timers.delete(next[0]); next[1].fn(); await flush();
      }
      now = end; await flush();
    },
    count: () => timers.size
  };
}
class FakeSocket extends EventTarget {
  sent = []; closed = false; accepted = false; onSend;
  accept() { this.accepted = true; }
  send(data) { const value = JSON.parse(data); this.sent.push(value); this.onSend?.(value); }
  close() { this.closed = true; }
  emit(value) { const event = new Event('message'); Object.defineProperty(event, 'data', { value: JSON.stringify(value) }); this.dispatchEvent(event); }
}
function fixture(extra = {}) {
  const timer = clock(), client = new FakeSocket(), sideband = new FakeSocket();
  const records = [], answers = [], tasks = [];
  let creates = 0, attaches = 0;
  const store = {
    async reserve(value) { records.push({ reserve: value }); return true; },
    async activate(requestId, providerId) { records.push({ activate: { requestId, providerId } }); },
    async finish(requestId, result) { records.push({ finish: { requestId, ...result } }); }
  };
  sideband.onSend = event => {
    if (event.type === 'session.close') queueMicrotask(() => sideband.emit({ type: 'session.closed', usage: { seconds: 7 } }));
  };
  const options = {
    client, visitorKey: 'hashed-visitor', store, ...timer,
    async createSession() { creates++; return { id: 'live_mock', sdp: 'v=0\r\ns=mock-answer\r\n' }; },
    async attach() { attaches++; return sideband; },
    answer(question) { answers.push(question); return { text: 'I can show my public designs.', action: { menu: 'Design', room: 'master-bath' } }; },
    track(task) { tasks.push(task); }, ...extra
  };
  const control = createPondsterLiveControl(options);
  return { control, timer, client, sideband, store, records, answers, tasks, creates: () => creates, attaches: () => attaches };
}

// Real SQLite executes the exact one-statement reservation predicates, without a provider call.
const sqlite = new DatabaseSync(':memory:');
sqlite.exec(readFileSync(new URL('../drizzle/0002_flat_agent_brand.sql', import.meta.url), 'utf8'));
const d1 = { prepare(sql) { return { bind(...values) { return { async run() { const result = sqlite.prepare(sql).run(...values); return { success: true, meta: { changes: Number(result.changes) } }; } }; } }; } };
const store = d1VoiceStore(d1);
let timestamp = 1_800_000_000_000;
const reserve = (n, visitor = `visitor-${n}`) => store.reserve({ requestId: id(n), visitorKey: visitor, createdAt: timestamp, expiresAt: timestamp + 200_000 });
const finish = n => store.finish(id(n), { state: 'closed', usageSeconds: 4, confirmed: true });
assert.equal(await reserve(1, 'a'), true);
assert.equal(await reserve(1, 'a'), false, 'A request UUID is never billed twice.');
assert.equal(await reserve(2, 'a'), false, 'One browser cannot have two active sessions.');
assert.equal(await reserve(3, 'b'), true);
assert.equal(await reserve(4, 'c'), false, 'The global active limit is atomic in SQL.');
await finish(1); await finish(3);
assert.equal(await reserve(5, 'a'), false, 'Cooldown also applies after a quick confirmed close.');
timestamp += 60_001;
for (let n = 6; n <= 8; n++) { assert.equal(await reserve(n, 'a'), true); await finish(n); timestamp += 60_001; }
assert.equal(await reserve(9, 'a'), false, 'Four browser sessions exhaust the rolling daily allowance.');
sqlite.exec('DELETE FROM voice_sessions');
for (let n = 10; n < 30; n++) { assert.equal(await reserve(n), true); await finish(n); }
assert.equal(await reserve(30), false, 'The global daily allowance applies across different browsers.');
timestamp += 86_400_001;
assert.equal(await reserve(31), true);
await store.finish(id(31), { state: 'unconfirmed', usageSeconds: 0, confirmed: false });
timestamp += 250_000;
assert.equal(await reserve(32, 'visitor-31'), false, 'Expiry alone never frees an unconfirmed possibly billed session.');
// Completed administrative waivers remain protected against late controller
// writes. This fixture has no real request identity or waiver-creation path.
sqlite.exec('DELETE FROM voice_sessions');
sqlite.prepare("INSERT INTO voice_sessions (request_id,visitor_key,provider_id,created_at,expires_at,state,usage_seconds,final_usage_confirmed) VALUES (?,?,NULL,?,?,'owner_waived',0,0)")
  .run(id(33), 'visitor-33', timestamp - 120_000, timestamp - 1);
const waived = { ...sqlite.prepare('SELECT * FROM voice_sessions WHERE request_id = ?').get(id(33)) };
await assert.rejects(store.activate(id(33), 'live_late_synthetic'), /reservation unavailable/);
await store.finish(id(33), { state: 'unconfirmed', usageSeconds: 8, confirmed: false });
await store.finish(id(33), { state: 'closed', usageSeconds: 9, confirmed: true });
assert.deepEqual({ ...sqlite.prepare('SELECT * FROM voice_sessions WHERE request_id = ?').get(id(33)) }, waived,
  'Late activation/finalization preserves an owner-waived row and every retained field.');
assert.equal(await reserve(34, 'visitor-33'), true, 'A completed waiver does not occupy an active slot.');
sqlite.close();

const visitor = 'a'.repeat(32);
const secret = 'mock-only-key-not-used-for-network';
assert.match(await hashVoiceVisitor(visitor, secret), /^[a-f0-9]{64}$/);
assert.notEqual(await hashVoiceVisitor(visitor, secret), await hashVoiceVisitor(visitor, `${secret}changed`));

// Admission performs only SELECT, reuses the exact status cookie, and agrees with
// the real atomic INSERT predicates. Fixture writes/rollbacks are in memory only.
{
  const admissionDb = new DatabaseSync(':memory:');
  admissionDb.exec(readFileSync(new URL('../drizzle/0002_flat_agent_brand.sql', import.meta.url), 'utf8'));
  const originalNow = Date.now, originalFetch = globalThis.fetch;
  const now = 1_800_000_000_000, day = 86_400_000;
  Date.now = () => now;
  let reads = 0, networkCalls = 0, serial = 9000;
  globalThis.fetch = async () => { networkCalls++; throw new Error('Admission must never call a provider'); };
  const admissionD1 = { prepare(sql) {
    assert.equal(sql, VOICE_ADMISSION_SQL, 'Admission uses only its read-only SELECT');
    return { bind(...values) { return { async first() { reads++; return admissionDb.prepare(sql).get(...values); } }; } };
  } };
  const environment = { DB: admissionD1, OPENAI_API_KEY: secret };
  const visitorKey = await hashVoiceVisitor(visitor, secret);
  const admissionRequest = new Request('https://pondstr.test/api/voice/status', { headers: { Cookie: `pondster_voice_visitor=${visitor}` } });
  const snapshot = () => admissionDb.prepare('SELECT * FROM voice_sessions ORDER BY request_id').all().map(row => ({ ...row }));
  const seed = (n, { key = visitorKey, at = now - 60_001, state = 'failed' } = {}) => admissionDb.prepare('INSERT INTO voice_sessions (request_id,visitor_key,created_at,expires_at,state,usage_seconds,final_usage_confirmed) VALUES (?,?,?,?,?,0,0)')
    .run(id(n), key, at, at + 200_000, state);
  const reset = () => admissionDb.exec('DELETE FROM voice_sessions');
  const expectAdmission = async (expected, request = admissionRequest, response = voiceStatus(request, environment), key = visitorKey) => {
    const before = snapshot();
    const checked = await voiceAdmissionStatus(request, environment, response);
    const body = await checked.clone().json();
    assert.equal(body.available, expected);
    if (expected) assert.equal(checked, response, 'Admitted response preserves the original cookie/body');
    else {
      assert.deepEqual(Object.keys(body).sort(), ['available', 'message']);
      assert.match(body.message, /Browser voice or type/);
    }
    assert.equal(checked.headers.get('set-cookie'), response.headers.get('set-cookie'));
    assert.equal(checked.headers.get('cache-control'), 'no-store, private');
    assert.deepEqual(snapshot(), before, 'Read-only admission preserves every fixture row and field');
    admissionDb.exec('BEGIN');
    try {
      const inserted = admissionDb.prepare(RESERVE_VOICE_SQL).run(id(serial++), key, now, now + 200_000,
        now - day, key, now - day, key, now - 60_000, key);
      assert.equal(Number(inserted.changes) === 1, expected, 'Admission agrees with the exact atomic reservation SQL');
    } finally { admissionDb.exec('ROLLBACK'); }
    assert.deepEqual(snapshot(), before);
  };
  try {
    await expectAdmission(true);
    for (const state of ['pending', 'active', 'closing', 'unconfirmed']) {
      reset(); seed(1, { at: now - day - 1, state }); await expectAdmission(false);
    }
    reset(); seed(1, { state: 'owner_waived' }); await expectAdmission(true);
    reset(); seed(1, { key: 'other-one', at: now - day - 1, state: 'unconfirmed' }); await expectAdmission(true);
    seed(2, { key: 'other-two', at: now - day - 1, state: 'active' }); await expectAdmission(false);
    reset();
    seed(1, { key: 'other-1', state: 'owner_waived' });
    for (let n = 2; n <= 19; n++) seed(n, { key: `other-${n}` });
    await expectAdmission(true); seed(20, { key: 'other-20' }); await expectAdmission(false);
    reset(); seed(1, { state: 'owner_waived' });
    for (let n = 2; n <= 3; n++) seed(n); await expectAdmission(true);
    seed(4); await expectAdmission(false, admissionRequest, voiceStatus(admissionRequest, environment));
    reset(); seed(1, { at: now - 59_999, state: 'owner_waived' }); await expectAdmission(false);
    reset(); seed(1, { at: now - 60_000 }); await expectAdmission(true);
    reset(); for (let n = 1; n <= 20; n++) seed(n, { key: `other-${n}`, at: now - day }); await expectAdmission(true);
    reset(); for (let n = 1; n <= 20; n++) seed(n, { key: `other-${n}`, at: now - day + 1 }); await expectAdmission(false);

    reset();
    const firstRequest = new Request('https://pondstr.test/api/voice/status');
    const issued = voiceStatus(firstRequest, environment);
    const issuedCookie = issued.headers.get('set-cookie').match(/^pondster_voice_visitor=([a-f0-9]{32});/)[1];
    const issuedKey = await hashVoiceVisitor(issuedCookie, secret);
    seed(1, { key: issuedKey, at: now - day - 1, state: 'unconfirmed' });
    await expectAdmission(false, firstRequest, issued, issuedKey);

    const beforeError = snapshot();
    const brokenEnvironment = { DB: { prepare() { throw new Error('mock D1 unavailable'); } }, OPENAI_API_KEY: secret };
    const failed = await voiceAdmissionStatus(admissionRequest, brokenEnvironment);
    assert.equal((await failed.json()).available, false, 'D1 errors fail closed');
    assert.deepEqual(snapshot(), beforeError);
    const denied = voiceStatus(new Request('https://pondstr.test/api/voice/status', { headers: { Origin: 'https://elsewhere.test' } }), environment);
    assert.equal(await voiceAdmissionStatus(admissionRequest, environment, denied), denied);
    const disabled = { ...environment, PONDSTER_VOICE_ENABLED: 'false' };
    const disabledBase = voiceStatus(admissionRequest, disabled);
    const readsBeforeDisabled = reads;
    assert.equal(await voiceAdmissionStatus(admissionRequest, disabled, disabledBase), disabledBase);
    assert.equal(reads, readsBeforeDisabled, 'Configured-unavailable status does not query admission');
    assert.equal(networkCalls, 0);
  } finally { Date.now = originalNow; globalThis.fetch = originalFetch; admissionDb.close(); }
}

const status = voiceStatus(new Request('https://pondstr.test/api/voice/status'), {});
assert.deepEqual(await status.json(), { available: false });
assert.match(status.headers.get('set-cookie'), /HttpOnly; SameSite=Strict.*Secure/);
const baseHeaders = { Origin: 'https://pondstr.test', Upgrade: 'websocket', Cookie: `pondster_voice_visitor=${visitor}` };
const context = { waitUntil() {} };
const unreachable = () => { throw new Error('No provider or configuration call was expected.'); };
assert.equal((await handlePondsterLiveControl(new Request('https://pondstr.test/api/voice/control', { headers: { ...baseHeaders, Origin: 'https://elsewhere.test' } }), {}, context, unreachable, unreachable)).status, 403);
assert.equal((await handlePondsterLiveControl(new Request('https://pondstr.test/api/voice/control', { headers: baseHeaders }), {}, context, unreachable, unreachable)).status, 503);

for (const httpStatus of [400, 401, 403, 404, 422, 429]) {
  const f = fixture({ async createSession(_sdp, _signal, requestId) {
    assert.equal(requestId, id(httpStatus));
    throw new VoiceProviderFailure('create-http', httpStatus, null);
  } });
  await f.control.message(start(httpStatus)); await f.control.completed;
  assert.equal(f.records.at(-1).finish.state, 'failed', 'An explicit terminal create rejection is a failed startup');
  assert.equal(f.records.at(-1).finish.confirmed, false, 'Failed startup never claims provider-confirmed closure');
  assert.equal(f.records.at(-1).finish.usageSeconds, 0);
  assert.equal(f.attaches(), 0);
  assert.ok(!f.records.some(record => record.activate));
}
for (const failure of [
  ...[302, 408, 409, 500, 502, 503].map(httpStatus => new VoiceProviderFailure('create-http', httpStatus, null)),
  new Error('mock transport failure'), new SyntaxError('mock invalid JSON'), new Error('mock unexpected response shape')
]) {
  const f = fixture({ async createSession() { throw failure; } });
  await f.control.message(start(510)); await f.control.completed;
  assert.equal(f.records.at(-1).finish.state, 'unconfirmed');
  assert.equal(f.records.at(-1).finish.confirmed, false);
}
for (const httpStatus of [400, 401, 403, 404, 422, 429, 500]) {
  const f = fixture({ async attach() { throw new VoiceProviderFailure('attach-http', httpStatus, null); } });
  await f.control.message(start(520)); await f.control.completed;
  assert.equal(f.records.at(-1).finish.state, 'unconfirmed', 'An attach rejection cannot claim that a created session never existed');
  assert.equal(f.records.find(record => record.activate).activate.providerId, 'live_mock');
}
{
  const f = fixture();
  await f.control.message(JSON.stringify({ type: 'pondster.start', requestId: 'invalid-request-id', sdp: 'v=0\r\ns=mock\r\n' }));
  await f.control.completed;
  assert.equal(f.creates(), 0); assert.equal(f.records.length, 0, 'Invalid UUIDs never reach reservation or provider creation');
}
// Mock the Cloudflare upgrade boundary and actual provider-fetch callback. No
// network is possible; this verifies the header rather than a copied assertion.
{
  const NativeResponse = globalThis.Response, originalFetch = globalThis.fetch, OriginalPair = globalThis.WebSocketPair, originalWarn = console.warn;
  const client = new FakeSocket(), server = new FakeSocket(), tasks = [], writes = [], providerCalls = [];
  const requestId = 'ABCDEF12-ABCD-4BCD-8BCD-ABCDEF123456';
  globalThis.WebSocketPair = class { constructor() { return { 0: client, 1: server }; } };
  globalThis.Response = function(body, init) {
    if (init?.status === 101) return { status: 101, webSocket: init.webSocket };
    return new NativeResponse(body, init);
  };
  console.warn = () => {};
  globalThis.fetch = async (url, init) => {
    providerCalls.push({ url, init });
    assert.equal(url, 'https://api.openai.com/v1/live/sessions');
    assert.equal(init.method, 'POST'); assert.equal(init.redirect, 'manual');
    assert.equal(init.headers['X-Client-Request-Id'], requestId.toLowerCase());
    assert.equal(init.headers.Authorization, `Bearer ${secret}`);
    return new NativeResponse('{"error":{"code":"invalid_api_key"}}', { status: 401 });
  };
  const mockD1 = { prepare(sql) { return { bind(...values) { return { async run() {
    writes.push({ sql, values }); return { success: true, meta: { changes: 1 } };
  } }; } }; } };
  try {
    const upgrade = await handlePondsterLiveControl(new Request('https://pondstr.test/api/voice/control', { headers: baseHeaders }),
      { DB: mockD1, OPENAI_API_KEY: ` ${secret} ` }, { waitUntil(task) { tasks.push(task); } }, () => ({ model: 'gpt-live-1' }), () => ({ text: 'mock public answer' }));
    assert.equal(upgrade.status, 101);
    server.emit({ type: 'pondster.start', requestId, sdp: 'v=0\r\ns=mock-offer\r\n' });
    await flush(); await Promise.all(tasks); await flush(); await Promise.all(tasks);
    assert.equal(providerCalls.length, 1, 'A rejected creation never attaches or retries');
    assert.equal(writes[0].values[0], requestId.toLowerCase());
    assert.equal(writes.at(-1).values[0], 'failed');
    assert.equal(writes.at(-1).values[2], 0, 'No provider-confirmed closure is invented');
  } finally { globalThis.Response = NativeResponse; globalThis.fetch = originalFetch; globalThis.WebSocketPair = OriginalPair; console.warn = originalWarn; }
}

// Exercise both real fetch adapters with thrown errors; only the allowlisted
// classification may reach logs, never exception messages or upstream payloads.
for (const stage of ['create-fetch', 'attach-fetch']) {
  const NativeResponse = globalThis.Response, originalFetch = globalThis.fetch, OriginalPair = globalThis.WebSocketPair, originalWarn = console.warn;
  const client = new FakeSocket(), server = new FakeSocket(), tasks = [], logs = [];
  let calls = 0;
  globalThis.WebSocketPair = class { constructor() { return { 0: client, 1: server }; } };
  globalThis.Response = function(body, init) {
    if (init?.status === 101) return { status: 101, webSocket: init.webSocket };
    return new NativeResponse(body, init);
  };
  console.warn = (...values) => logs.push(values);
  globalThis.fetch = async () => {
    calls++;
    if (stage === 'attach-fetch' && calls === 1) return new NativeResponse(JSON.stringify({
      session: { id: 'live_synthetic' }, transport: { type: 'webrtc', sdp: 'v=0\r\ns=synthetic-answer\r\n' },
    }), { status: 201 });
    throw new Error('synthetic private exception detail', { cause: { code: 'ERR_INVALID_CHAR' } });
  };
  const mockD1 = { prepare() { return { bind() { return { async run() { return { success: true, meta: { changes: 1 } }; } }; } }; } };
  try {
    await handlePondsterLiveControl(new Request('https://pondstr.test/api/voice/control', { headers: baseHeaders }),
      { DB: mockD1, OPENAI_API_KEY: secret }, { waitUntil(task) { tasks.push(task); } }, () => ({ model: 'gpt-live-1' }), () => ({ text: 'synthetic public answer' }));
    server.emit({ type: 'pondster.start', requestId: id(530), sdp: 'v=0\r\ns=synthetic-offer\r\n' });
    await flush(); await Promise.all(tasks); await flush(); await Promise.all(tasks);
    assert.equal(calls, stage === 'create-fetch' ? 1 : 2, 'A thrown fetch is never retried.');
    assert.equal(logs.length, 1);
    assert.deepEqual(logs[0], ['pondster.voice.provider', JSON.stringify({ stage, httpStatus: null, code: 'invalid_auth_header' })]);
  } finally { globalThis.Response = NativeResponse; globalThis.fetch = originalFetch; globalThis.WebSocketPair = OriginalPair; console.warn = originalWarn; }
}

// The actual Worker adapter reuses its trusted startup developer input for the
// sideband greeting. The browser supplies only readiness, never greeting text.
for (const seedShape of ['valid', 'null-session', 'array-session', 'null-developer', 'null-part']) {
  const NativeResponse = globalThis.Response, originalFetch = globalThis.fetch, OriginalPair = globalThis.WebSocketPair;
  const client = new FakeSocket(), server = new FakeSocket(), sideband = new FakeSocket(), tasks = [];
  const greeting = 'Synthetic trusted startup greeting, once, then listen.';
  const seed = [{ role: 'developer', content: [{ type: 'input_text', text: greeting }] }];
  // The fake transport accepts these malformed configurations only to exercise
  // structural validation without ever calling a real provider.
  const sessionConfig = seedShape === 'null-session' ? null : seedShape === 'array-session' ? []
    : { model: 'gpt-live-1', input: seedShape === 'null-developer' ? [null]
      : seedShape === 'null-part' ? [{ role: 'developer', content: [null] }] : seed };
  let postedSession;
  sideband.onSend = event => {
    if (event.type === 'session.close') queueMicrotask(() => sideband.emit({ type: 'session.closed', usage: { seconds: 3 } }));
  };
  globalThis.WebSocketPair = class { constructor() { return { 0: client, 1: server }; } };
  globalThis.Response = function(body, init) {
    if (init?.status === 101) return { status: 101, webSocket: init.webSocket };
    return new NativeResponse(body, init);
  };
  globalThis.fetch = async (url, init) => {
    if (url === 'https://api.openai.com/v1/live/sessions') {
      postedSession = JSON.parse(init.body).session;
      return new NativeResponse(JSON.stringify({ session: { id: 'live_greeting_synthetic' }, transport: { type: 'webrtc', sdp: 'v=0\r\ns=synthetic-answer\r\n' } }), { status: 201 });
    }
    assert.equal(url, 'https://api.openai.com/v1/live/sessions/live_greeting_synthetic/attach');
    return { webSocket: sideband };
  };
  const mockD1 = { prepare() { return { bind() { return { async run() { return { success: true, meta: { changes: 1 } }; } }; } }; } };
  try {
    await handlePondsterLiveControl(new Request('https://pondstr.test/api/voice/control', { headers: baseHeaders }),
      { DB: mockD1, OPENAI_API_KEY: secret }, { waitUntil(task) { tasks.push(task); } },
      () => sessionConfig, () => ({ text: 'Synthetic public answer' }));
    server.emit({ type: 'pondster.start', requestId: id(115), sdp: 'v=0\r\ns=synthetic-offer\r\n' });
    await flush(); await Promise.all(tasks);
    assert.deepEqual(postedSession, sessionConfig);
    assert.equal(sideband.sent.length, 0, 'No sideband greeting is sent before provider-readiness acknowledgement.');
    server.emit({ type: 'pondster.started', text: 'untrusted replacement', content: 'untrusted content' });
    server.emit({ type: 'pondster.started' });
    await flush(); await Promise.all(tasks);
    assert.equal(sideband.sent.length, seedShape === 'valid' ? 1 : 0, 'Malformed or null startup seeds cannot become a trusted greeting.');
    if (seedShape === 'valid') {
      assert.equal(sideband.sent[0].type, 'session.commentary.append');
      assert.equal(sideband.sent[0].delegation_id, null);
      assert.equal(sideband.sent[0].content, greeting, 'The exact startup seed is reused; untrusted fields are ignored.');
    }
  } finally {
    server.emit({ type: 'pondster.stop' }); await flush(); await Promise.all(tasks);
    globalThis.Response = NativeResponse; globalThis.fetch = originalFetch; globalThis.WebSocketPair = OriginalPair;
  }
}

{
  const f = fixture();
  await f.control.message(start(100));
  assert.equal(f.creates(), 1); assert.equal(f.attaches(), 1); assert.equal(f.sideband.accepted, true);
  assert.equal(f.client.sent.find(event => event.type === 'pondster.ready').maxDurationSeconds, 180);
  await f.control.message(start(101)); await f.control.completed;
  assert.equal(f.creates(), 1, 'A second start never creates another provider session.');
  assert.equal(f.records.at(-1).finish.state, 'closed');
}
{
  const greeting = 'Greet the visitor once in English, then pause and listen.';
  const f = fixture({ greetingInstructions: () => greeting });
  await f.control.message(JSON.stringify({ type: 'pondster.started', content: 'untrusted early text' }));
  assert.equal(f.creates(), 0, 'A readiness acknowledgement cannot create a session.');
  await f.control.message(start(112));
  assert.equal(f.sideband.sent.length, 0, 'The server waits for the browser to observe provider session.started.');
  await f.control.message(JSON.stringify({ type: 'pondster.started', content: 'untrusted greeting replacement', text: 'untrusted text' }));
  const first = f.sideband.sent[0];
  assert.equal(first.type, 'session.commentary.append');
  assert.equal(first.delegation_id, null);
  assert.equal(first.content, greeting, 'Only server-owned greeting instructions are sent to the trusted sideband.');
  assert.match(first.event_id, /^[0-9a-f-]{36}$/);
  await f.control.message(JSON.stringify({ type: 'pondster.started' }));
  assert.equal(f.sideband.sent.length, 1, 'A repeated readiness event never repeats the greeting.');
  await f.control.stop();
  await f.control.message(JSON.stringify({ type: 'pondster.started' }));
  assert.equal(f.sideband.sent.filter(event => event.type === 'session.commentary.append').length, 1, 'Stopped sessions never greet again.');

  const next = fixture({ greetingInstructions: () => greeting });
  await next.control.message(start(113));
  await next.control.message(JSON.stringify({ type: 'pondster.started' }));
  assert.equal(next.sideband.sent.length, 1, 'A new session gets its own single greeting.');
  assert.notEqual(next.sideband.sent[0].event_id, first.event_id);
  await next.control.stop();
}
{
  let resolveSession;
  const f = fixture({ greetingInstructions: () => 'Synthetic greeting', createSession() { return new Promise(resolve => { resolveSession = resolve; }); } });
  const pending = f.control.message(start(114)); await flush();
  await f.control.message(JSON.stringify({ type: 'pondster.started' }));
  assert.equal(f.sideband.sent.length, 0, 'Readiness received during setup cannot start a greeting.');
  const stopped = f.control.stop();
  resolveSession({ id: 'live_stopped_before_greeting', sdp: 'v=0\r\ns=synthetic-answer\r\n' });
  await pending; await stopped;
  assert.deepEqual(f.sideband.sent.map(event => event.type), ['session.close'], 'Cancelled setup performs trusted cleanup without greeting.');
}
{
  const f = fixture({ store: { async reserve() { return false; }, async activate() { throw new Error(); }, async finish() { throw new Error(); } } });
  await f.control.message(start(102)); await f.control.completed;
  assert.equal(f.creates(), 0); assert.equal(f.attaches(), 0);
  assert.ok(f.client.sent.some(event => event.type === 'pondster.error'));
}
{
  const f = fixture({ async attach() { throw new Error('mock unavailable'); } });
  await f.control.message(start(103)); await f.control.completed;
  assert.equal(f.creates(), 1); assert.ok(!f.client.sent.some(event => event.type === 'pondster.ready'));
  assert.equal(f.records.at(-1).finish.state, 'unconfirmed', 'A provider attempt with no closer fails closed.');
  assert.equal(f.records.find(row => row.activate)?.activate.providerId, 'live_mock', 'The runtime provider ID survives an attach failure.');
}
{
  let resolveSession;
  const f = fixture({ createSession() { return new Promise(resolve => { resolveSession = resolve; }); } });
  const pending = f.control.message(start(104)); await flush();
  const stopped = f.control.stop();
  resolveSession({ id: 'live_late', sdp: 'v=0\r\ns=late\r\n' });
  await pending; await stopped; await f.control.completed;
  assert.ok(!f.client.sent.some(event => event.type === 'pondster.ready'));
  assert.equal(f.attaches(), 1, 'A late created session still gets a trusted close connection.');
  assert.equal(f.sideband.sent.filter(event => event.type === 'session.close').length, 1);
  assert.equal(f.records.at(-1).finish.state, 'closed');
}
{
  const f = fixture();
  f.store.activate = async () => { throw new Error('mock D1 failure'); };
  await f.control.message(start(109)); await f.control.completed;
  assert.equal(f.attaches(), 1, 'A failed state write cannot bypass trusted cleanup of an already-created session.');
  assert.ok(!f.client.sent.some(event => event.type === 'pondster.ready'));
  assert.equal(f.records.at(-1).finish.state, 'closed');
}
{
  const f = fixture(); await f.control.message(start(105));
  await f.timer.tick(VOICE_DURATION_SECONDS * 1000); await f.control.completed;
  assert.equal(f.sideband.sent.filter(event => event.type === 'session.close').length, 1);
  assert.equal(f.records.at(-1).finish.usageSeconds, 7);
  assert.equal(f.records.at(-1).finish.confirmed, true);
  assert.equal(f.timer.count(), 0); assert.ok(f.client.closed && f.sideband.closed);
  f.sideband.emit({ type: 'session.delegation.created', offset_ms: 2, delegation: { target: 'client', id: 'late' } });
  await f.control.message(JSON.stringify({ type: 'pondster.text', text: 'late question' }));
  assert.equal(f.answers.length, 0, 'Late callbacks after closure cannot answer or restart.');
}
{
  const f = fixture(); await f.control.message(start(106));
  f.sideband.onSend = undefined;
  const stopped = f.control.stop(); await flush();
  await f.timer.tick(VOICE_FINALIZATION_MS - 1);
  assert.ok(!f.records.some(record => record.finish), 'The finalization receiver remains alive for the bounded drain.');
  assert.equal(f.sideband.closed, false);
  await f.timer.tick(1); await stopped;
  assert.equal(f.records.at(-1).finish.state, 'unconfirmed');
  assert.equal(f.records.at(-1).finish.confirmed, false, 'The timeout cannot claim provider finalization.');
  assert.equal(f.timer.count(), 0);
}
{
  const f = fixture(); await f.control.message(start(111));
  f.sideband.onSend = undefined;
  const stopped = f.control.stop(); await flush(); await f.timer.tick(5000);
  assert.equal(f.sideband.closed, false, 'A slower final event still has a trusted receiver after two seconds.');
  f.sideband.emit({ type: 'session.closed', usage: { seconds: 11 } });
  await stopped; await f.control.completed;
  assert.deepEqual(f.records.at(-1).finish, { requestId: id(111), state: 'closed', usageSeconds: 11, confirmed: true });
  assert.equal(f.timer.count(), 0);
}
{
  const f = fixture({ createSession(_sdp, signal) { return new Promise((_resolve, reject) => signal.addEventListener('abort', () => reject(new Error('aborted')))); } });
  const pending = f.control.message(start(107)); await flush(); await f.timer.tick(20_000); await pending; await f.control.completed;
  assert.equal(f.records.at(-1).finish.state, 'unconfirmed');
  assert.ok(!f.client.sent.some(event => event.type === 'pondster.ready'));
}
{
  let resolveSession, creationSignal, cleanupSignal, attachments = 0;
  const f = fixture({ createSession(_sdp, signal) {
    creationSignal = signal;
    // Simulate a provider response racing with an already-issued abort.
    return new Promise(resolve => { resolveSession = resolve; });
  }, async attach(_providerId, signal) {
    attachments++; cleanupSignal = signal;
    assert.notEqual(signal, creationSignal, 'Cleanup never reuses an aborted setup signal.');
    assert.equal(signal.aborted, false, 'A late known session can still be attached for trusted closure.');
    return f.sideband;
  } });
  const pending = f.control.message(start(110)); await flush();
  await f.timer.tick(20_000);
  assert.equal(creationSignal.aborted, true);
  resolveSession({ id: 'live_after_timeout', sdp: 'v=0\r\ns=late-after-timeout\r\n' });
  await pending; await f.control.completed;
  assert.equal(attachments, 1);
  assert.equal(cleanupSignal.aborted, false);
  assert.equal(f.sideband.sent.filter(event => event.type === 'session.close').length, 1);
  assert.ok(!f.client.sent.some(event => event.type === 'pondster.ready'));
  assert.equal(f.records.at(-1).finish.state, 'closed');
  assert.equal(f.timer.count(), 0);
}
{
  const f = fixture(); await f.control.message(start(108));
  f.sideband.emit({ type: 'session.input_transcript.delta', delta: 'Show my ', start_ms: 100, end_ms: 400 });
  f.sideband.emit({ type: 'session.input_transcript.delta', delta: 'Master Bath', start_ms: 400, end_ms: 900 });
  f.sideband.emit({ type: 'session.delegation.created', offset_ms: 850, delegation: { id: 'request-one', target: 'client' } });
  await f.timer.tick(250);
  assert.equal(f.answers[0], 'Show my Master Bath');
  assert.equal(f.sideband.sent.at(-1).delegation_id, 'request-one');
  assert.equal(f.sideband.sent.at(-1).type, 'session.commentary.append');
  assert.deepEqual(f.client.sent.at(-1), { type: 'pondster.action', action: { menu: 'Design', room: 'master-bath' } });
  f.sideband.emit({ type: 'session.input_transcript.delta', delta: 'Who is Ashley?', start_ms: 1200, end_ms: 1600 });
  f.sideband.emit({ type: 'session.delegation.created', offset_ms: 1600, delegation: { id: 'request-two', target: 'client' } });
  await f.timer.tick(250);
  assert.equal(f.answers[1], 'Who is Ashley?', 'A later delegation does not replay an overlapping earlier question.');
  f.sideband.emit({ type: 'session.delegation.created', offset_ms: 1600, delegation: { id: 'request-two', target: 'client' } });
  await f.timer.tick(250); assert.equal(f.answers.length, 2);
  await f.control.message(JSON.stringify({ type: 'pondster.text', text: 'Show the front elevation' }));
  assert.equal(f.sideband.sent.at(-1).delegation_id, null);
  const count = f.answers.length;
  await f.control.message(JSON.stringify({ type: 'pondster.text', text: 'too soon' }));
  assert.equal(f.answers.length, count);
  for (let i = 1; i < 20; i++) { await f.timer.tick(2000); await f.control.message(JSON.stringify({ type: 'pondster.text', text: `Question ${i}` })); }
  await f.timer.tick(2000); await f.control.message(JSON.stringify({ type: 'pondster.text', text: 'over session cap' }));
  assert.equal(f.answers.length, 22, 'There are at most twenty typed questions plus the two voice delegations.');
  await f.control.stop();
}
{
  const f = fixture(); await f.control.message('x'.repeat(65_537)); await f.control.completed;
  assert.equal(f.creates(), 0); assert.equal(f.records.length, 0);
}
console.log('Pondster live server: read-only SQLite admission/cookie/limits, retained owner-waiver protection; terminal create rejection versus unknown/attach failures; validated upstream request ID; provider lifecycle, delegation and cleanup passed (mocks only).');
