import assert from 'node:assert/strict';
import { createPondsterVoice } from '../lib/pondster-voice.js';

// Deterministic browser doubles: this suite never accesses a microphone or plays audio.
function fakeClock() {
  let now = 0, sequence = 0;
  const jobs = new Map();
  return {
    setTimer(callback, delay) { const id = ++sequence; jobs.set(id, { callback, at: now + delay }); return id; },
    clearTimer(id) { jobs.delete(id); },
    advance(milliseconds) {
      const target = now + milliseconds;
      let iterations = 0;
      while (true) {
        const next = [...jobs].filter(([, job]) => job.at <= target).sort((a, b) => a[1].at - b[1].at || a[0] - b[0])[0];
        if (!next) break;
        if (++iterations > 1000) throw new Error('Voice timers did not settle.');
        const [id, job] = next;
        jobs.delete(id); now = job.at; job.callback();
      }
      now = target;
    }
  };
}

function recognition() {
  return {
    continuous: false, interimResults: false, lang: '', starts: 0, aborts: 0,
    onstart: null, onend: null, onerror: null, onresult: null,
    start() { this.starts++; },
    abort() { this.aborts++; }
  };
}

function setup({ factoryThrows = false, unavailable = false, noSpeech = false, onQuestion } = {}) {
  const clock = fakeClock(), engines = [], utterances = [], states = [], questions = [];
  let hidden = false, voice;
  const synthesis = {
    cancels: 0, resumes: 0,
    cancel() { this.cancels++; },
    speak(utterance) { utterances.push(utterance); },
    resume() { this.resumes++; },
    getVoices() { return [{ lang: 'en-US', name: 'Test voice', voiceURI: 'test', default: true, localService: true }]; }
  };
  voice = createPondsterVoice({
    recognitionFactory: unavailable ? undefined : () => {
      if (factoryThrows) throw new Error('Recognition is blocked in this browser.');
      const engine = recognition(); engines.push(engine); return engine;
    },
    synthesis: noSpeech ? undefined : synthesis,
    createUtterance: noSpeech ? undefined : text => ({ text, onstart: null, onend: null, onerror: null }),
    onState: state => states.push({ ...state }),
    onQuestion: text => { questions.push({ text, session: states.at(-1)?.session }); onQuestion?.(text, voice); },
    isWakeRequest: text => /\bpondster\b/i.test(text),
    setTimer: clock.setTimer, clearTimer: clock.clearTimer,
    isHidden: () => hidden
  });
  return {
    voice, clock, engines, utterances, states, questions, synthesis,
    state: () => states.at(-1), engine: () => engines.at(-1),
    starts: () => engines.reduce((sum, engine) => sum + engine.starts, 0),
    setHidden(value) { hidden = value; }
  };
}

function final(engine, transcript) {
  engine.onresult?.({ resultIndex: 0, results: [{ isFinal: true, 0: { transcript } }] });
}
function begin(harness, mode = 'question') {
  harness.voice.listen(mode);
  const engine = harness.engine();
  assert.ok(engine, 'Listening creates a recognition engine.');
  engine.onstart?.();
  assert.equal(harness.state().listening, true);
  return engine;
}
function idle(state) {
  assert.equal(state.session, false);
  assert.equal(state.listening, false);
  assert.equal(state.speaking, false);
  assert.equal(state.outputActive, false);
}

{
  const h = setup({ factoryThrows: true });
  assert.ok(h.states.length, 'An initial state is delivered even when construction fails.');
  assert.equal(h.state().available, false);
  assert.ok(h.state().status);
  assert.doesNotThrow(() => h.voice.listen());
  assert.equal(h.questions.length, 0);
  h.voice.destroy();
  const unsupported = setup({ unavailable: true, noSpeech: true });
  assert.equal(unsupported.state().available, false);
  assert.equal(unsupported.state().speechAvailable, false);
  assert.doesNotThrow(() => unsupported.voice.speak('A typed reply remains available.'));
  assert.equal(unsupported.state().speaking, false);
  unsupported.voice.destroy();
}

{
  const h = setup();
  const engine = begin(h);
  engine.onresult?.({ resultIndex: 0, results: [{ isFinal: false, 0: { transcript: 'An unfinished question' } }] });
  assert.equal(h.questions.length, 0);
  final(engine, 'Show my kitchen choices');
  assert.deepEqual(h.questions, [{ text: 'Show my kitchen choices', session: false }]);
  assert.equal(h.state().session, false, 'One-question mode clears its session before the reply callback.');
  final(engine, 'A late second final result');
  assert.equal(h.questions.length, 1);
  h.voice.destroy();
}

{
  const h = setup();
  const engine = begin(h, 'wake');
  final(engine, 'Tell me about the kitchen');
  assert.equal(h.questions.length, 0);
  assert.equal(h.state().heard, 'Tell me about the kitchen');
  assert.match(h.state().status, /Pondster|name/i, 'Ignored wake-mode speech explains how to address Pondster.');
  assert.equal(h.state().session, true);
  final(engine, 'Pondster, show the kitchen');
  assert.equal(h.questions.length, 1);
  assert.equal(h.questions[0].text, 'Pondster, show the kitchen');
  assert.equal(h.questions[0].session, true, 'Named wake mode remains a session.');
  h.voice.destroy();
}

{
  const h = setup();
  begin(h, 'wake');
  for (let attempt = 0; attempt < 2; attempt++) {
    const engine = h.engine(), status = h.state().status, before = h.starts();
    engine.onerror?.({ error: 'no-speech' });
    assert.equal(h.state().status, status, 'Wake no-speech waits for onend before reconnecting.');
    assert.equal(h.state().session, true);
    engine.onend?.();
    assert.equal(h.state().listening, false);
    h.clock.advance(349);
    assert.equal(h.starts(), before);
    h.clock.advance(1);
    assert.equal(h.starts(), before + 1, 'An idle wake attempt reconnects after 350ms.');
    h.engine().onstart?.();
  }
  h.engine().onerror?.({ error: 'no-speech' });
  h.engine().onend?.();
  idle(h.state());
  h.clock.advance(20000);
  assert.equal(h.starts(), 3, 'The third consecutive idle wake end stops further retries.');
  h.voice.destroy();
}

{
  const h = setup();
  begin(h, 'wake');
  const idleEndAndReconnect = () => {
    h.engine().onerror?.({ error: 'no-speech' });
    h.engine().onend?.();
    h.clock.advance(350);
    assert.equal(h.state().session, true);
    h.engine().onstart?.();
  };
  idleEndAndReconnect(); idleEndAndReconnect();
  final(h.engine(), 'A kitchen question without a wake name');
  assert.equal(h.questions.length, 0);
  assert.equal(h.state().heard, 'A kitchen question without a wake name');
  h.engine().onend?.(); h.clock.advance(350); h.engine().onstart?.();
  assert.equal(h.state().session, true, 'A recognized transcript resets the idle failure count, even without a wake name.');
  idleEndAndReconnect(); idleEndAndReconnect();
  h.engine().onerror?.({ error: 'no-speech' }); h.engine().onend?.();
  idle(h.state());
  h.voice.destroy();
}

{
  const messages = [];
  for (const error of ['not-allowed', 'service-not-allowed', 'audio-capture', 'network']) {
    const h = setup();
    begin(h, 'wake').onerror?.({ error });
    idle(h.state());
    assert.ok(h.state().status, `${error} has visible feedback.`);
    messages.push(h.state().status);
    const before = h.starts();
    h.voice.listen();
    assert.equal(h.starts(), before + 1, `${error} does not leave retry stuck behind the previous session.`);
    h.voice.destroy();
  }
  assert.equal(new Set(messages).size, 4, 'Permission, service policy, missing microphone, and network errors are distinguished.');
}

{
  const h = setup();
  h.voice.listen();
  h.clock.advance(9999);
  assert.equal(h.state().session, true);
  h.clock.advance(1);
  idle(h.state());
  assert.match(h.state().status, /time|start|try|respond/i);
  const before = h.starts();
  begin(h);
  assert.equal(h.starts(), before + 1, 'A silent startup timeout permits a fresh attempt.');
  h.voice.destroy();
}

{
  const h = setup();
  h.voice.listen('wake');
  const engine = h.engine(), lateStart = engine.onstart;
  h.voice.stop('Stopped before startup.');
  const stopped = { ...h.state() };
  lateStart?.(); h.clock.advance(20000);
  assert.deepEqual(h.state(), stopped, 'Stopping before onstart cannot be reversed by a late startup event.');
  h.voice.destroy();
}

{
  const h = setup();
  const engine = begin(h, 'wake');
  const late = { start: engine.onstart, end: engine.onend, error: engine.onerror, result: engine.onresult };
  h.voice.stop('Stopped by the visitor.');
  const stopped = { ...h.state() }, starts = h.starts();
  late.start?.(); late.end?.(); late.error?.({ error: 'network' });
  late.result?.({ resultIndex: 0, results: [{ isFinal: true, 0: { transcript: 'Pondster, show the kitchen' } }] });
  h.clock.advance(20000);
  assert.deepEqual(h.state(), stopped, 'Late recognition callbacks cannot change a stopped session.');
  assert.equal(h.starts(), starts);
  assert.equal(h.questions.length, 0);
  h.voice.destroy();
}

{
  const h = setup();
  const idleStatus = h.state().status;
  h.setHidden(true); h.voice.hide();
  assert.equal(h.state().status, idleStatus, 'Hiding an idle tab does not replace its existing status.');
  h.setHidden(false); begin(h, 'wake');
  const lateEnd = h.engine().onend;
  h.setHidden(true); h.voice.hide();
  idle(h.state());
  const hiddenStatus = h.state().status, starts = h.starts();
  lateEnd?.(); h.clock.advance(20000);
  assert.equal(h.state().status, hiddenStatus);
  assert.equal(h.starts(), starts, 'A hidden tab cannot restart listening.');
  h.voice.destroy();
}

{
  const h = setup();
  h.voice.speak('A reply whose audio never starts.');
  assert.equal(h.state().outputActive, true);
  assert.equal(h.state().speaking, false, 'Preparing an utterance does not claim that audio has started.');
  h.clock.advance(7999);
  assert.equal(h.state().outputActive, true);
  assert.equal(h.state().speaking, false);
  h.clock.advance(1);
  assert.equal(h.state().outputActive, false, 'Speech startup is bounded to eight seconds.');
  assert.equal(h.state().speaking, false, 'Speech startup is bounded to eight seconds.');
  begin(h);
  h.voice.destroy();
}

for (const [text, duration] of [['Short reply.', 15000], ['x'.repeat(200), 20000], ['x'.repeat(2000), 120000]]) {
  const h = setup();
  h.voice.speak(text);
  assert.equal(h.state().outputActive, true);
  assert.equal(h.state().speaking, false);
  h.utterances.at(-1).onstart?.();
  assert.equal(h.state().speaking, true);
  h.clock.advance(duration - 1);
  assert.equal(h.state().speaking, true);
  h.clock.advance(1);
  assert.equal(h.state().outputActive, false);
  assert.equal(h.state().speaking, false, 'Speech duration watchdog uses the bounded text-based timeout.');
  begin(h);
  h.voice.destroy();
}

for (const speechEndsFirst of [false, true]) {
  const h = setup({ onQuestion: (_text, voice) => voice.speak('Here is my answer.') });
  const engine = begin(h, 'wake');
  const recognitionEnd = engine.onend;
  final(engine, 'Pondster, show my design ideas');
  assert.equal(h.state().outputActive, true);
  assert.equal(h.state().speaking, false);
  const utterance = h.utterances.at(-1);
  assert.ok(utterance, 'The synchronous question callback can start speech.');
  utterance.onstart?.();
  assert.equal(h.state().speaking, true);
  if (speechEndsFirst) { utterance.onend?.(); recognitionEnd?.(); }
  else { recognitionEnd?.(); utterance.onend?.(); }
  h.clock.advance(1000);
  assert.equal(h.starts(), 2, `Recognition resumes exactly once when ${speechEndsFirst ? 'speech' : 'recognition'} ends first.`);
  assert.equal(h.state().session, true);
  h.voice.destroy();
}

{
  const h = setup();
  h.voice.speak('An audio reply that fails.');
  const utterance = h.utterances.at(-1);
  utterance.onstart?.();
  utterance.onerror?.({ error: 'synthesis-failed' });
  assert.equal(h.state().speaking, false);
  assert.ok(h.state().status, 'A current speech failure gives visible feedback.');
  begin(h);
  h.voice.destroy();
}

{
  const h = setup();
  h.voice.speak('Old reply.');
  const old = h.utterances.at(-1);
  h.voice.cancelSpeech();
  assert.equal(h.state().outputActive, false);
  assert.equal(h.state().speaking, false);
  h.voice.speak('My new reply.');
  const current = { ...h.state() };
  old.onstart?.(); old.onend?.(); old.onerror?.({ error: 'canceled' });
  assert.deepEqual(h.state(), current, 'An old cancelled utterance cannot overwrite a new speech session.');
  h.voice.stop('Voice is stopped.');
  const newest = h.utterances.at(-1), stopped = { ...h.state() };
  newest.onstart?.(); newest.onend?.(); newest.onerror?.({ error: 'interrupted' });
  assert.deepEqual(h.state(), stopped, 'Stop ignores late speech events.');
  h.voice.destroy();
}

{
  const h = setup();
  const engine = begin(h, 'wake');
  const callbacks = { start: engine.onstart, end: engine.onend, error: engine.onerror, result: engine.onresult };
  h.voice.speak('A pending reply.');
  const utterance = h.utterances.at(-1);
  h.voice.destroy();
  const count = h.states.length, starts = h.starts();
  callbacks.start?.(); callbacks.end?.(); callbacks.error?.({ error: 'network' });
  callbacks.result?.({ resultIndex: 0, results: [{ isFinal: true, 0: { transcript: 'Pondster, show the kitchen' } }] });
  utterance.onstart?.(); utterance.onend?.(); utterance.onerror?.({ error: 'canceled' });
  h.clock.advance(150000);
  assert.equal(h.states.length, count, 'Destroy suppresses every late callback and timer update.');
  assert.equal(h.starts(), starts);
  assert.equal(h.questions.length, 0);
}

console.log('PASS: Pondster voice constructor fallback, direct questions, wake feedback and bounded idle retries, distinct browser errors, truthful speech startup, timeouts, stale-event cancellation, hidden tabs, both speech/recognition end orders, and cleanup; no microphone or audio used.');
