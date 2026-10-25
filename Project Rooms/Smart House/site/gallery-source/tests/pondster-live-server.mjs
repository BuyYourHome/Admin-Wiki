import assert from 'node:assert/strict';
import { DatabaseSync } from 'node:sqlite';
import { readFileSync } from 'node:fs';
import { createPondsterLiveControl, d1VoiceStore, handlePondsterLiveControl, hashVoiceVisitor, voiceStatus, VOICE_DURATION_SECONDS } from '../worker/pondster-live.ts';

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
sqlite.close();

const visitor = 'a'.repeat(32);
const secret = 'mock-only-key-not-used-for-network';
assert.match(await hashVoiceVisitor(visitor, secret), /^[a-f0-9]{64}$/);
assert.notEqual(await hashVoiceVisitor(visitor, secret), await hashVoiceVisitor(visitor, `${secret}changed`));
const status = voiceStatus(new Request('https://pondstr.test/api/voice/status'), {});
assert.deepEqual(await status.json(), { available: false });
assert.match(status.headers.get('set-cookie'), /HttpOnly; SameSite=Strict.*Secure/);
const baseHeaders = { Origin: 'https://pondstr.test', Upgrade: 'websocket', Cookie: `pondster_voice_visitor=${visitor}` };
const context = { waitUntil() {} };
const unreachable = () => { throw new Error('No provider or configuration call was expected.'); };
assert.equal((await handlePondsterLiveControl(new Request('https://pondstr.test/api/voice/control', { headers: { ...baseHeaders, Origin: 'https://elsewhere.test' } }), {}, context, unreachable, unreachable)).status, 403);
assert.equal((await handlePondsterLiveControl(new Request('https://pondstr.test/api/voice/control', { headers: baseHeaders }), {}, context, unreachable, unreachable)).status, 503);

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
  const stopped = f.control.stop(); await flush(); await f.timer.tick(2000); await stopped;
  assert.equal(f.records.at(-1).finish.state, 'unconfirmed');
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
console.log('Pondster live server: SQLite quotas, private status, provider lifecycle, bounded text, delegation and cleanup passed (mocks only).');
