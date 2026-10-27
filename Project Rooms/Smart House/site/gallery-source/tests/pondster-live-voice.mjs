import assert from 'node:assert/strict';
import { createPondsterLiveVoice, createPondsterAudioSampler, createPondsterSilenceMonitor, PONDSTER_SILENCE_MS } from '../lib/pondster-live-voice.ts';

// Browser, media, audio and transport doubles only: no devices or network access.
const flush = async () => { for (let index = 0; index < 16; index++) await Promise.resolve(); };
function deferred() {
  let resolve, reject;
  const promise = new Promise((yes, no) => { resolve = yes; reject = no; });
  return { promise, resolve, reject };
}

function fakeClock() {
  let now = 0, sequence = 0;
  const jobs = new Map(), delays = [];
  return {
    get now() { return now; },
    delays,
    setTimeout(callback, delay = 0) {
      assert.ok(Number.isFinite(delay) && delay >= 0);
      delays.push(delay);
      const id = ++sequence; jobs.set(id, { callback, at: now + delay }); return id;
    },
    clearTimeout(id) { jobs.delete(id); },
    pending: () => jobs.size,
    advance(milliseconds) {
      const target = now + milliseconds;
      let count = 0;
      while (true) {
        const next = [...jobs].filter(([, job]) => job.at <= target)
          .sort((left, right) => left[1].at - right[1].at || left[0] - right[0])[0];
        if (!next) break;
        assert.ok(++count < 10000, 'Voice timers remain bounded.');
        const [id, job] = next; jobs.delete(id); now = job.at; job.callback();
      }
      now = target;
    }
  };
}

function eventTarget(fields = {}) {
  const listeners = new Map();
  return Object.assign({
    addEventListener(type, callback) {
      if (!listeners.has(type)) listeners.set(type, new Set());
      listeners.get(type).add(callback);
    },
    removeEventListener(type, callback) { listeners.get(type)?.delete(callback); },
    emit(type, event = {}) {
      const payload = { type, target: this, ...event };
      this[`on${type}`]?.(payload);
      for (const callback of [...(listeners.get(type) ?? [])]) callback(payload);
    },
    listenerCount() { return [...listeners.values()].reduce((sum, set) => sum + set.size, 0); }
  }, fields);
}

function track() { return { kind: 'audio', enabled: true, stopCalls: 0, stop() { this.stopCalls++; } }; }
function stream(tracks) { return { getTracks: () => tracks, getAudioTracks: () => tracks.filter(item => item.kind === 'audio') }; }
function channel(log) {
  return eventTarget({
    label: 'oai-events', readyState: 'connecting', sent: [], closeCalls: 0,
    send(data) { assert.equal(this.readyState, 'open'); this.sent.push(JSON.parse(data)); log.push('data.send'); },
    open() { this.readyState = 'open'; this.emit('open'); },
    receive(message) { this.emit('message', { data: JSON.stringify(message) }); },
    close() { this.closeCalls++; this.readyState = 'closed'; this.emit('close'); }
  });
}
function peer(log, { iceComplete = true } = {}) {
  const events = channel(log);
  return eventTarget({
    events, channels: [], tracks: [], localDescription: null, remoteDescription: null,
    iceGatheringState: iceComplete ? 'complete' : 'gathering', connectionState: 'new', closeCalls: 0,
    addTrack(value, source) { this.tracks.push({ track: value, stream: source }); log.push('peer.addTrack'); return { track: value }; },
    createDataChannel(label) { this.channels.push(label); log.push('peer.createDataChannel'); return events; },
    async createOffer() { log.push('peer.createOffer'); return { type: 'offer', sdp: 'mock-local-offer' }; },
    async setLocalDescription(description) { log.push('peer.setLocalDescription'); this.localDescription = description; },
    async setRemoteDescription(description) { log.push('peer.setRemoteDescription'); this.remoteDescription = description; },
    close() { this.closeCalls++; this.connectionState = 'closed'; log.push('peer.close'); this.emit('connectionstatechange'); }
  });
}
function control(url, log) {
  return eventTarget({
    url, readyState: 0, sent: [], closeCalls: 0,
    send(data) { assert.equal(this.readyState, 1); this.sent.push(JSON.parse(data)); log.push('control.send'); },
    open() { this.readyState = 1; this.emit('open'); },
    receive(message) { this.emit('message', { data: JSON.stringify(message) }); },
    close() { this.closeCalls++; this.readyState = 3; this.emit('close'); }
  });
}

function setup({ mediaGate, fetchGate, remoteGate, status = { available: true }, iceComplete = true, playPlans = [], activitySamplerFactory } = {}) {
  const clock = fakeClock(), log = [], tracks = [track()], media = stream([...tracks]);
  const peers = [], controls = [], states = [], transcripts = [], actions = [], requests = [];
  let mediaCalls = 0;
  const visibility = eventTarget({ hidden: false });
  const audio = eventTarget({
    srcObject: null, playCalls: 0, pauseCalls: 0,
    async play() { this.playCalls++; const plan = playPlans.shift(); if (plan) await plan(); },
    pause() { this.pauseCalls++; }
  });
  const voice = createPondsterLiveVoice({
    audioElement: audio,
    onState: value => states.push({ ...value }),
    onTranscript: (...values) => transcripts.push(values),
    onAction: value => actions.push(value),
    getUserMedia: async () => {
      mediaCalls++;
      if (mediaGate) return mediaGate.promise;
      if (mediaCalls === 1) return media;
      const next = track(); tracks.push(next); return stream([next]);
    },
    peerFactory: () => {
      const value = peer(log, { iceComplete });
      if (remoteGate) {
        const applyAnswer = value.setRemoteDescription.bind(value);
        value.setRemoteDescription = async description => { await remoteGate.promise; await applyAnswer(description); };
      }
      peers.push(value); return value;
    },
    fetcher: async (url, options = {}) => {
      requests.push({ url, options });
      if (fetchGate) await new Promise((resolve, reject) => {
        fetchGate.promise.then(resolve, reject);
        options.signal?.addEventListener('abort', () => reject(new DOMException('Aborted', 'AbortError')), { once: true });
      });
      return { ok: true, status: 200, json: async () => status, text: async () => JSON.stringify(status) };
    },
    controlFactory: url => { const value = control(url, log); controls.push(value); return value; },
    streamFactory: values => stream(values),
    visibilityTarget: visibility,
    setTimeout: clock.setTimeout, clearTimeout: clock.clearTimeout,
    now: () => clock.now, activitySamplerFactory,
    origin: 'https://pondstr.com',
    requestIdFactory: () => '11111111-1111-4111-8111-111111111111'
  });
  return {
    voice, clock, log, tracks, media, peers, controls, states, transcripts, actions, requests, visibility, audio,
    mediaCalls: () => mediaCalls, state: () => states.at(-1),
    peer: () => peers.at(-1), control: () => controls.at(-1)
  };
}

async function settle(harness, promise, limit = 100) {
  let done = false, failure, result;
  Promise.resolve(promise).then(value => { result = value; done = true; }, error => { failure = error; done = true; });
  for (let attempt = 0; attempt < limit && !done; attempt++) {
    await flush(); if (!done) harness.clock.advance(100);
  }
  assert.ok(done, 'A voice operation settles within its bounded timeout.');
  if (failure) throw failure;
  return result;
}

async function connect(harness, start = harness.voice.start(), maxDurationSeconds = 180) {
  const result = Promise.allSettled([start]);
  await flush();
  assert.ok(harness.control(), 'An available voice session opens its same-origin control socket.');
  harness.control().open(); await flush();
  const request = harness.control().sent.find(message => message.type === 'pondster.start');
  assert.ok(request, 'Negotiation sends pondster.start on the control socket.');
  assert.equal(request.sdp, 'mock-local-offer');
  harness.control().receive({ type: 'pondster.ready', session: { id: 'session-one' }, transport: { type: 'webrtc', sdp: 'mock-remote-answer' }, maxDurationSeconds });
  await flush();
  harness.peer().events.open();
  harness.peer().events.receive({ type: 'session.started', session: { id: 'session-one' } });
  const [outcome] = await settle(harness, result);
  if (outcome.status === 'rejected') throw outcome.reason;
  return { peer: harness.peer(), control: harness.control(), events: harness.peer().events };
}

function startedAcks(socket) { return socket.sent.filter(message => message.type === 'pondster.started'); }

async function dispose(harness) {
  harness.voice.dispose(); harness.clock.advance(10000); await flush();
  assert.equal(harness.clock.pending(), 0, 'Disposal leaves no timeout jobs after the close grace period.');
  assert.ok(harness.peers.every(item => item.closeCalls > 0), 'Every created peer is closed.');
  assert.ok(harness.controls.every(item => item.closeCalls > 0), 'Every created control socket is closed.');
  assert.ok(harness.tracks.every(item => item.stopCalls > 0), 'Acquired microphone tracks are stopped.');
  assert.equal(harness.audio.srcObject, null);
  assert.equal(harness.visibility.listenerCount(), 0, 'Disposal removes the visibility listener.');
}

// Construction is side-effect free; a single start negotiates the new protocol.
{
  const h = setup();
  assert.equal(h.mediaCalls(), 0); assert.equal(h.peers.length, 0);
  assert.equal(h.controls.length, 0); assert.equal(h.requests.length, 0);
  assert.equal(h.state().active, false); assert.equal(h.state().connecting, false);
  h.voice.sendText('Ignored before a session.');
  const first = h.voice.start(), second = h.voice.start();
  assert.equal(first, second, 'Concurrent starts share the same attempt.');
  await flush();
  assert.equal(h.mediaCalls(), 1); assert.equal(h.peers.length, 1); assert.equal(h.controls.length, 1);
  assert.equal(h.requests.length, 1);
  assert.equal(new URL(h.requests[0].url, 'https://pondstr.com').href, 'https://pondstr.com/api/voice/status', 'Startup uses authoritative admission without making optional model metadata a prerequisite.');
  assert.equal(h.requests[0].options.method, 'GET');
  assert.equal(h.requests[0].options.credentials, 'same-origin');
  assert.equal(h.control().url, 'wss://pondstr.com/api/voice/control');
  assert.deepEqual(h.peer().channels, ['oai-events']);
  assert.ok(h.log.indexOf('peer.createDataChannel') < h.log.indexOf('peer.createOffer'));
  h.control().open(); await flush();
  assert.deepEqual(h.control().sent, [{ type: 'pondster.start', requestId: '11111111-1111-4111-8111-111111111111', sdp: 'mock-local-offer' }]);
  h.control().receive({ type: 'pondster.ready', session: { id: 'session-one' }, transport: { type: 'webrtc', sdp: 'mock-remote-answer' }, maxDurationSeconds: 180 });
  await flush();
  assert.deepEqual(h.peer().remoteDescription, { type: 'answer', sdp: 'mock-remote-answer' });
  assert.equal(h.state().active, false, 'A server answer alone cannot activate voice.');
  assert.equal(h.state().connecting, true);
  assert.deepEqual(startedAcks(h.control()), [], 'The browser cannot acknowledge startup before provider session.started.');
  h.peer().events.open(); h.peer().events.receive({ type: 'session.started' });
  await settle(h, Promise.all([first, second]));
  assert.equal(h.state().active, true); assert.equal(h.state().connecting, false);
  assert.deepEqual(startedAcks(h.control()), [{ type: 'pondster.started' }], 'Readiness sends exactly one fixed control acknowledgement.');
  assert.deepEqual(h.peer().events.sent, [], 'The acknowledgement does not use the provider data channel.');
  h.peer().events.receive({ type: 'session.started' });
  h.control().receive({ type: 'pondster.ready', session: { id: 'session-one' }, transport: { type: 'webrtc', sdp: 'mock-remote-answer' } });
  await flush();
  await h.voice.start();
  assert.deepEqual(startedAcks(h.control()), [{ type: 'pondster.started' }], 'Duplicate started/ready events and repeated Start never resend readiness.');
  assert.equal(h.mediaCalls(), 1); assert.equal(h.peers.length, 1); assert.equal(h.controls.length, 1);
  assert.equal(h.requests.length, 1, 'An already active session is not renegotiated.');
  await dispose(h);
}

// Provider startup cannot acknowledge an unfinished, cancelled, or failed answer application.
for (const outcome of ['ready', 'cancelled', 'failed']) {
  const gate = deferred(), h = setup({ remoteGate: gate });
  const result = Promise.allSettled([h.voice.start()]); await flush();
  const socket = h.control(); socket.open(); await flush();
  socket.receive({ type: 'pondster.ready', session: { id: 'session-one' }, transport: { type: 'webrtc', sdp: 'mock-remote-answer' } });
  await flush();
  h.peer().events.open(); h.peer().events.receive({ type: 'session.started' }); await flush();
  assert.deepEqual(startedAcks(socket), [], 'Provider session.started alone cannot bypass pending setRemoteDescription.');
  if (outcome === 'cancelled') h.voice.stop();
  if (outcome === 'failed') gate.reject(new Error('The answer could not be applied.'));
  else gate.resolve();
  const [finished] = await settle(h, result);
  if (outcome === 'ready') {
    assert.equal(finished.status, 'fulfilled');
    assert.deepEqual(startedAcks(socket), [{ type: 'pondster.started' }]);
  } else {
    assert.equal(finished.status, outcome === 'failed' ? 'rejected' : 'fulfilled');
    h.peer().events.receive({ type: 'session.started' });
    socket.receive({ type: 'pondster.ready', session: { id: 'session-one' }, transport: { type: 'webrtc', sdp: 'mock-remote-answer' } });
    await flush();
    assert.deepEqual(startedAcks(socket), [], 'A cancelled or failed attempt cannot acknowledge late startup events.');
    assert.equal(h.state().active, false); assert.ok(h.tracks.every(item => item.stopCalls > 0));
  }
  await dispose(h);
}

// A failed readiness send follows the existing startup failure and cleanup path.
{
  const h = setup(), result = Promise.allSettled([h.voice.start()]); await flush();
  const socket = h.control(), originalSend = socket.send.bind(socket);
  socket.send = data => {
    if (JSON.parse(data).type === 'pondster.started') throw new Error('Control send failed.');
    originalSend(data);
  };
  socket.open(); await flush();
  socket.receive({ type: 'pondster.ready', session: { id: 'session-one' }, transport: { type: 'webrtc', sdp: 'mock-remote-answer' } });
  await flush(); h.peer().events.open(); h.peer().events.receive({ type: 'session.started' });
  const [finished] = await settle(h, result);
  assert.equal(finished.status, 'rejected'); assert.equal(h.state().active, false);
  assert.deepEqual(startedAcks(socket), []);
  assert.ok(socket.sent.some(message => message.type === 'pondster.stop'));
  assert.ok(h.tracks.every(item => item.stopCalls > 0)); assert.equal(h.audio.srcObject, null);
  await dispose(h);
}

// ICE gathering is bounded at eight seconds and can continue with the local SDP.
{
  const h = setup({ iceComplete: false });
  const starting = h.voice.start(); await flush();
  assert.equal(h.controls.length, 0);
  assert.ok(h.clock.delays.some(delay => delay > 0 && delay <= 8000));
  h.clock.advance(7999); await flush(); assert.equal(h.controls.length, 0);
  h.clock.advance(1); await flush(); assert.equal(h.controls.length, 1);
  assert.equal(h.peer().listenerCount(), 0, 'ICE timeout removes its temporary event listener.');
  await connect(h, starting); await dispose(h);
}

// Stop wins pending permission and aborts pending status requests.
{
  const gate = deferred(), h = setup({ mediaGate: gate });
  const result = Promise.allSettled([h.voice.start()]); await flush();
  assert.equal(h.mediaCalls(), 1);
  h.voice.stop();
  assert.equal(h.state().active, false); assert.equal(h.state().connecting, false);
  assert.ok(h.audio.pauseCalls > 0); assert.equal(h.audio.srcObject, null);
  gate.resolve(h.media); await settle(h, result); await flush();
  assert.ok(h.tracks.every(item => item.stopCalls > 0), 'Tracks granted after Stop are immediately released.');
  assert.equal(h.peers.length, 0); assert.equal(h.controls.length, 0);
  await dispose(h);
}
{
  const gate = deferred(), h = setup({ fetchGate: gate });
  const result = Promise.allSettled([h.voice.start()]); await flush();
  assert.equal(h.requests.length, 1);
  h.voice.stop();
  assert.equal(h.requests[0].options.signal.aborted, true, 'Stop aborts the status fetch.');
  await settle(h, result);
  assert.equal(h.mediaCalls(), 0); assert.equal(h.peers.length, 0);
  // No microphone was acquired in this case.
  h.voice.dispose(); h.clock.advance(2000); await flush();
  assert.equal(h.clock.pending(), 0);
}

// Capture and playback stop immediately; only the close handshake gets a grace period.
{
  const h = setup(); const { peer: oldPeer, control: socket, events } = await connect(h);
  const remote = track(); oldPeer.emit('track', { track: remote, streams: [stream([remote])] }); await flush();
  assert.ok(h.audio.srcObject);
  h.voice.stop();
  assert.ok(h.tracks.every(item => item.stopCalls > 0));
  assert.ok(h.audio.pauseCalls > 0); assert.equal(h.audio.srcObject, null);
  assert.equal(h.state().active, false);
  assert.ok(socket.sent.some(message => message.type === 'pondster.stop'));
  assert.deepEqual(events.sent, [{ type: 'session.close' }]);
  assert.equal(oldPeer.closeCalls, 0, 'The open data channel can drain the close acknowledgement.');
  h.clock.advance(5000); await flush();
  assert.equal(oldPeer.closeCalls, 0, 'WebRTC stays open for a close acknowledgement beyond two seconds.');
  assert.equal(events.readyState, 'open'); assert.equal(socket.readyState, 1);
  assert.equal(h.audio.srcObject, null); assert.ok(h.tracks.every(item => item.stopCalls > 0));
  events.receive({ type: 'session.closed' }); await flush();
  assert.equal(oldPeer.closeCalls, 1);
  assert.equal(socket.closeCalls, 1);
  assert.equal(h.clock.pending(), 0);
  await dispose(h);
}
{
  const h = setup(); const { peer: oldPeer, control: socket, events } = await connect(h);
  h.voice.stop();
  const stoppedState = { ...h.state() };
  h.clock.advance(9999); await flush();
  assert.equal(oldPeer.closeCalls, 0); assert.equal(events.readyState, 'open'); assert.equal(socket.readyState, 1);
  assert.equal(h.audio.srcObject, null); assert.ok(h.tracks.every(item => item.stopCalls > 0));
  h.clock.advance(1); await flush();
  assert.equal(oldPeer.closeCalls, 1, 'An unacknowledged close releases its transports after ten seconds.');
  assert.equal(events.readyState, 'closed'); assert.equal(socket.readyState, 3);
  assert.deepEqual(h.state(), stoppedState, 'The local drain timeout does not report provider-confirmed closure.');
  assert.deepEqual(events.sent, [{ type: 'session.close' }], 'A drain timeout never fabricates session.closed.');
  assert.ok(!socket.sent.some(message => message.type === 'session.closed'));
  await dispose(h);
}

// Text and actions travel only over control; the data channel never sends commentary.
{
  const h = setup(); const { control: socket, events } = await connect(h);
  h.voice.sendText('  Show my kitchen choices.  ');
  assert.deepEqual(socket.sent.at(-1), { type: 'pondster.text', text: 'Show my kitchen choices.' });
  assert.deepEqual(h.transcripts.at(-1), [{ who: 'you', text: 'Show my kitchen choices.' }]);
  h.voice.sendText('x'.repeat(4000)); assert.equal(socket.sent.at(-1).text.length, 500);
  const sent = socket.sent.length; h.voice.sendText('  '); assert.equal(socket.sent.length, sent);
  socket.receive({ type: 'pondster.action', action: { menu: 'Explore', room: 'kitchen', scene: 'evening', ignored: true } });
  assert.deepEqual(h.actions, [{ menu: 'Explore', room: 'kitchen', scene: 'evening' }]);
  for (const action of [{ menu: 'Admin' }, { menu: 'Explore', room: 'private-room' }, { menu: 'Explore', scene: 'unlock' }]) socket.receive({ type: 'pondster.action', action });
  events.receive({ type: 'pondster.action', action: { menu: 'Own' } });
  assert.equal(h.actions.length, 1, 'Only allowlisted actions from control reach the UI.');
  assert.deepEqual(events.sent, [], 'Client replies/commentary are never sent on the event data channel.');
  await dispose(h);
}

// Captions accumulate per speaker, debounce within 400ms, and retain bounded text.
{
  const h = setup(); const { events } = await connect(h);
  events.receive({ type: 'session.input_transcript.delta', delta: 'Show ', start_ms: 0, end_ms: 100 });
  events.receive({ type: 'session.input_transcript.delta', delta: 'my kitchen', start_ms: 100, end_ms: 200 });
  events.receive({ type: 'session.output_transcript.delta', delta: 'Here are ', start_ms: 0, end_ms: 100 });
  events.receive({ type: 'session.output_transcript.delta', delta: 'my ideas.', start_ms: 100, end_ms: 200 });
  assert.equal(h.state().heard, 'Show my kitchen'); assert.equal(h.transcripts.length, 0);
  h.clock.advance(349); await flush(); assert.equal(h.transcripts.length, 0);
  h.clock.advance(1); await flush();
  assert.deepEqual(h.transcripts.map(values => values[0]), [{ who: 'you', text: 'Show my kitchen' }, { who: 'Pondster', text: 'Here are my ideas.' }]);
  events.receive({ type: 'session.input_transcript.delta', delta: 'a'.repeat(6000) });
  events.receive({ type: 'session.output_transcript.delta', delta: 'b'.repeat(6000) });
  assert.ok(h.state().heard.length <= 500);
  h.clock.advance(400); await flush();
  assert.ok(h.transcripts.every(values => values[0].text.length <= 1800));
  const count = h.transcripts.length;
  events.emit('message', { data: '{invalid JSON' });
  events.emit('message', { data: JSON.stringify({ type: 'session.input_transcript.delta', delta: 'z'.repeat(65000) }) });
  h.clock.advance(400); await flush(); assert.equal(h.transcripts.length, count);
  await dispose(h);
}

// Autoplay denial is visible and a later gesture can enable the remote audio.
{
  const blocked = new DOMException('Playback needs a gesture.', 'NotAllowedError');
  const h = setup({ playPlans: [() => Promise.reject(blocked)] });
  const { peer: current } = await connect(h);
  const remote = track(); current.emit('track', { track: remote, streams: [] }); await flush();
  assert.ok(h.audio.srcObject, 'A stream is built from a remote track when no stream accompanies it.');
  assert.equal(h.state().audioBlocked, true); assert.match(h.state().status, /play my voice/i);
  await h.voice.resumeAudio();
  assert.equal(h.state().audioBlocked, false); assert.equal(h.audio.playCalls, 2);
  await dispose(h);
}

// Stale callbacks from a draining session cannot change a newer live attempt.
{
  const h = setup(); const old = await connect(h);
  const stale = { data: old.events.onmessage, control: old.control.onmessage, track: old.peer.ontrack, connection: old.peer.onconnectionstatechange };
  h.voice.stop();
  const fresh = await connect(h);
  assert.deepEqual(startedAcks(old.control), [{ type: 'pondster.started' }]);
  assert.deepEqual(startedAcks(fresh.control), [{ type: 'pondster.started' }], 'A new session gets one new readiness acknowledgement.');
  const state = { ...h.state() }, transcriptCount = h.transcripts.length, actionCount = h.actions.length;
  stale.data?.({ data: JSON.stringify({ type: 'session.started' }) });
  stale.data?.({ data: JSON.stringify({ type: 'session.input_transcript.delta', delta: 'stale words' }) });
  stale.control?.({ data: JSON.stringify({ type: 'pondster.error', message: 'Old failure' }) });
  stale.control?.({ data: JSON.stringify({ type: 'pondster.action', action: { menu: 'Own' } }) });
  const late = track(); stale.track?.({ track: late, streams: [stream([late])] });
  old.peer.connectionState = 'failed'; stale.connection?.();
  h.clock.advance(10000); await flush();
  assert.deepEqual(h.state(), state); assert.equal(h.transcripts.length, transcriptCount); assert.equal(h.actions.length, actionCount);
  assert.ok(late.stopCalls > 0, 'A stale remote track is stopped.');
  assert.equal(fresh.peer.closeCalls, 0); assert.equal(h.tracks.at(-1).stopCalls, 0);
  assert.equal(h.controls.length, 2, 'Stale events never reconnect automatically.');
  assert.deepEqual(startedAcks(old.control), [{ type: 'pondster.started' }], 'Stopped-session callbacks never resend readiness.');
  assert.deepEqual(startedAcks(fresh.control), [{ type: 'pondster.started' }]);
  await dispose(h);
}

// Unsupported availability, server errors, ended sessions, and lost control stop cleanly.
for (const status of [{ available: false }, { available: 'true' }, {}]) {
  const h = setup({ status }); await settle(h, h.voice.start());
  assert.equal(h.state().available, false); assert.equal(h.mediaCalls(), 0);
  assert.equal(h.peers.length, 0); assert.equal(h.controls.length, 0);
  assert.match(h.state().status, /type|not connected|unavailable/i);
  h.voice.dispose(); h.clock.advance(2000); await flush(); assert.equal(h.clock.pending(), 0);
}
for (const event of [{ type: 'pondster.error', message: 'Voice service is unavailable today.' }, { type: 'pondster.ended' }, null]) {
  const h = setup(); const { control: socket } = await connect(h);
  if (event) socket.receive(event); else socket.close();
  await flush();
  assert.equal(h.state().active, false); assert.ok(h.tracks.every(item => item.stopCalls > 0));
  if (event?.type === 'pondster.error') { assert.equal(h.state().available, false); assert.match(h.state().status, /unavailable today/i); }
  h.clock.advance(182000); await flush(); assert.equal(h.controls.length, 1);
  await dispose(h);
}
{
  const h = setup(); const { peer: current } = await connect(h);
  current.connectionState = 'disconnected'; current.emit('connectionstatechange');
  assert.equal(h.state().active, false, 'Losing the media connection ends the session.');
  assert.ok(h.tracks.every(item => item.stopCalls > 0), 'A disconnected peer cannot retain microphone capture.');
  assert.equal(h.audio.srcObject, null);
  h.clock.advance(182000); await flush(); assert.equal(h.controls.length, 1, 'A disconnected peer does not reconnect automatically.');
  await dispose(h);
}

// A hidden tab ends capture, and the service-provided duration is capped at three minutes.
{
  const h = setup(); await connect(h);
  h.visibility.hidden = true; h.visibility.emit('visibilitychange');
  assert.equal(h.state().active, false); assert.ok(h.tracks.every(item => item.stopCalls > 0));
  await assert.rejects(h.voice.start(), /tab/i);
  await dispose(h);
}
{
  const h = setup(); await connect(h, undefined, 999);
  h.clock.advance(179999); await flush(); assert.equal(h.state().active, true);
  h.clock.advance(1); await flush(); assert.equal(h.state().active, false);
  assert.ok(h.tracks.every(item => item.stopCalls > 0)); assert.match(h.state().status, /three.minute|ended/i);
  await dispose(h);
  const count = h.mediaCalls(); await assert.rejects(h.voice.start(), /closed/i); assert.equal(h.mediaCalls(), count);
}

// Advance asynchronous sampling without letting the synthetic clock outrun its
// promise continuations. No test ever accesses a real microphone or connection.
async function tick(clock, milliseconds) {
  while (milliseconds > 0) { const step = Math.min(250, milliseconds); clock.advance(step); await flush(); milliseconds -= step; }
}
function silenceFixture(sample = async () => ({ input: false, output: false })) {
  const clock = fakeClock(), ended = [], available = [];
  const monitor = createPondsterSilenceMonitor({ sample, now: () => clock.now,
    setTimeout: clock.setTimeout, clearTimeout: clock.clearTimeout,
    onSilence: () => ended.push(clock.now), onAvailability: value => available.push(value) });
  return { clock, monitor, ended, available };
}
{
  const h = silenceFixture(); await flush();
  await tick(h.clock, PONDSTER_SILENCE_MS - 1);
  assert.deepEqual(h.ended, []);
  await tick(h.clock, 1);
  assert.deepEqual(h.ended, [PONDSTER_SILENCE_MS], 'Exactly thirty seconds from the first BOTH-quiet snapshot ends the monitor.');
  assert.deepEqual(h.available, [true]); assert.equal(h.clock.pending(), 0);
}
for (const direction of ['input', 'output']) {
  let speaking = true;
  const h = silenceFixture(async () => ({ input: direction === 'input' && speaking, output: direction === 'output' && speaking }));
  await flush(); await tick(h.clock, 45_000);
  assert.deepEqual(h.ended, [], 'Speech longer than thirty seconds remains active without any transcript events.');
  speaking = false; await tick(h.clock, 250);
  const quiet = h.clock.now;
  await tick(h.clock, 29_999); assert.deepEqual(h.ended, []);
  await tick(h.clock, 1); assert.deepEqual(h.ended, [quiet + 30_000]);
}
{
  const h = silenceFixture(); await flush(); await tick(h.clock, 29_000);
  h.monitor.noteInteraction();
  await tick(h.clock, 29_999); assert.deepEqual(h.ended, []);
  await tick(h.clock, 1); assert.deepEqual(h.ended, [59_000], 'Real typing resets the quiet deadline.');
}
{
  let output = false;
  const h = silenceFixture(async () => ({ input: false, output })); await flush();
  h.monitor.setBusy('work', true, 30_000); h.monitor.setBusy('response', true, 30_000);
  output = true; await tick(h.clock, 250); output = false;
  await tick(h.clock, 10_000);
  h.monitor.setBusy('work', false); await tick(h.clock, 250);
  const quiet = h.clock.now;
  await tick(h.clock, 29_999); assert.deepEqual(h.ended, [], 'Output activity clears response wait but not still-pending work.');
  await tick(h.clock, 1); assert.deepEqual(h.ended, [quiet + 30_000]);
}
{
  const h = silenceFixture(); await flush();
  h.monitor.setBusy('response', true, 999_999);
  await tick(h.clock, 59_999); assert.deepEqual(h.ended, []);
  await tick(h.clock, 1); assert.deepEqual(h.ended, [60_000], 'A response-wait hint is capped; it cannot hold silence indefinitely.');
}
{
  const h = silenceFixture(async () => ({ input: false, output: null })); await flush();
  await tick(h.clock, 60_000);
  assert.deepEqual(h.ended, []); assert.deepEqual(h.available, [false], 'Unmeasured output is never interpreted as silence.');
  h.monitor.stop(); assert.equal(h.clock.pending(), 0);
}
{
  const pending = deferred(); let samples = 0;
  const h = silenceFixture(() => { samples++; return pending.promise; });
  await tick(h.clock, 999); assert.equal(samples, 1);
  await tick(h.clock, 1);
  assert.deepEqual(h.available, [false]); assert.equal(h.clock.pending(), 0);
  pending.resolve({ input: false, output: false }); await flush(); await tick(h.clock, 60_000);
  assert.equal(samples, 1, 'A hung getStats request is never overlapped.');
  assert.deepEqual(h.ended, [], 'A timed-out stats result cannot later close the session.');
}
{
  const pending = deferred(), h = silenceFixture(() => pending.promise);
  h.monitor.stop(); pending.resolve({ input: false, output: false }); await flush();
  assert.deepEqual(h.available, []); assert.deepEqual(h.ended, []); assert.equal(h.clock.pending(), 0, 'Stopped meters ignore stale promises and retain no timer.');
}
{
  let at = 0;
  const records = [
    { id: 'mic', type: 'media-source', kind: 'audio', timestamp: 0, audioLevel: 0, totalAudioEnergy: 0, totalSamplesDuration: 1 },
    { id: 'voice', type: 'inbound-rtp', kind: 'audio', timestamp: 0, audioLevel: 0, totalAudioEnergy: 0, totalSamplesDuration: 1 },
  ];
  const sample = createPondsterAudioSampler({ async getStats() { return new Map(records.map(item => [item.id, { ...item }])); } }, () => at);
  assert.deepEqual(await sample(), { input: false, output: false });
  at = 250; records.forEach(item => { item.timestamp = at; item.totalSamplesDuration += .25; }); records[0].totalAudioEnergy += .0001;
  assert.deepEqual(await sample(), { input: true, output: false }, 'Interval RMS detects real microphone energy even with audioLevel zero.');
  at = 500; records.forEach(item => { item.timestamp = at; item.totalSamplesDuration += .25; }); records[1].totalAudioEnergy += .0004;
  assert.deepEqual(await sample(), { input: false, output: true }, 'Interval RMS independently detects Pondster output.');
  at = 750; records.forEach(item => { item.timestamp = at; item.audioLevel = .9; });
  assert.deepEqual(await sample(), { input: true, output: true }, 'Flat energy counters must preserve a positive reported audio level.');
  at = 1000; records.forEach(item => { item.timestamp = at; delete item.audioLevel; });
  assert.deepEqual(await sample(), { input: null, output: null }, 'Flat counters without a reported audio level cannot establish silence.');
  at += 1501;
  assert.deepEqual(await sample(), { input: null, output: null }, 'Stale snapshots cannot establish silence.');
  at += 250; records.forEach(item => { item.timestamp = at; item.totalAudioEnergy = 0; item.totalSamplesDuration = 0; });
  assert.deepEqual(await sample(), { input: null, output: null }, 'Reset energy counters are unknown for their first interval.');
  assert.deepEqual(await createPondsterAudioSampler({})(), { input: null, output: null });
}
for (const interaction of ['typing', 'submitted']) {
  const h = setup({ activitySamplerFactory: () => async () => ({ input: false, output: false }) });
  assert.equal(h.state().silenceAvailable, null);
  await connect(h); await flush(); assert.equal(h.state().silenceAvailable, true);
  await tick(h.clock, 29_000);
  if (interaction === 'typing') h.voice.noteInteraction();
  else h.voice.sendText('Tell me about the deck');
  await tick(h.clock, 29_999); assert.equal(h.state().active, true);
  await tick(h.clock, 1);
  assert.equal(h.state().active, false); assert.match(h.state().status, /thirty seconds of silence/);
  assert.ok(h.tracks.every(item => item.stopCalls > 0)); assert.equal(h.audio.srcObject, null);
  assert.ok(h.control().sent.some(message => message.type === 'pondster.stop'));
  assert.equal(h.peer().closeCalls, 0, 'Silence stops capture immediately while the normal finalization drain remains open.');
  h.clock.advance(10_000); await flush(); await dispose(h);
}
{
  const h = setup({ activitySamplerFactory: () => async () => ({ input: false, output: false }) });
  await connect(h); await tick(h.clock, 29_000);
  h.control().receive({ type: 'pondster.busy', kind: 'work', active: true, holdMs: 30_000 });
  await tick(h.clock, 20_000);
  assert.equal(h.state().active, true, 'Trusted queued work suspends the otherwise-expiring quiet deadline.');
  h.control().receive({ type: 'pondster.busy', kind: 'work', active: false, holdMs: 30_000 });
  await tick(h.clock, 250);
  await tick(h.clock, 29_999); assert.equal(h.state().active, true);
  await tick(h.clock, 1); assert.equal(h.state().active, false);
  await dispose(h);
}
{
  const h = setup(); await connect(h); await tick(h.clock, 60_000);
  assert.equal(h.state().silenceAvailable, false); assert.equal(h.state().active, true, 'Unsupported metrics retain the honest three-minute fallback.');
  h.control().receive({ type: 'pondster.action', action: { menu: 'Contact' } });
  assert.deepEqual(h.actions.at(-1), { menu: 'Contact' });
  await dispose(h);
}

console.log('PASS: Live voice lifecycle and greeting; measured both-direction audio silence at30s; speech/typing resets; bounded trusted waits; unsupported/stale/hung stats; immediate stop and10s drain; Contact compatibility; privacy-safe mocks only.');
