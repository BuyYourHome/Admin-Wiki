import assert from 'node:assert/strict';

// Deterministic Web Audio doubles: this test never opens an audio device.
function deferred() {
  let resolve, reject;
  const promise = new Promise((yes, no) => { resolve = yes; reject = no; });
  return { promise, resolve, reject };
}

function fakeClock() {
  let now = 0, sequence = 0;
  const jobs = new Map(), observers = new Set();
  function schedule(callback, delay = 0, repeat = false) {
    assert.equal(typeof callback, 'function');
    assert.ok(Number.isFinite(delay) && delay >= 0, 'Timer delays are finite and nonnegative.');
    if (repeat) assert.ok(delay > 0, 'The music scheduler cannot use a zero-delay interval.');
    const id = ++sequence;
    jobs.set(id, { callback, at: now + delay, delay, repeat });
    return id;
  }
  function move(time) { now = time; for (const observer of observers) observer(); }
  return {
    get now() { return now; },
    setInterval: (callback, delay) => schedule(callback, delay, true),
    clearInterval: id => jobs.delete(id),
    setTimeout: (callback, delay) => schedule(callback, delay),
    clearTimeout: id => jobs.delete(id),
    observe: observer => observers.add(observer),
    pending: () => jobs.size,
    intervals: () => [...jobs.values()].filter(job => job.repeat).length,
    advance(milliseconds) {
      const target = now + milliseconds;
      let iterations = 0;
      while (true) {
        const next = [...jobs].filter(([, job]) => job.at <= target)
          .sort((a, b) => a[1].at - b[1].at || a[0] - b[0])[0];
        if (!next) break;
        assert.ok(++iterations < 10000, 'Audio scheduling remains bounded.');
        const [id, job] = next;
        if (job.repeat) job.at += job.delay;
        else jobs.delete(id);
        move(job.repeat ? job.at - job.delay : job.at);
        job.callback();
      }
      move(target);
    }
  };
}

function parameter(value = 0) {
  return {
    value, events: [],
    setValueAtTime(next, time) { this.value = next; this.events.push(['set', next, time]); return this; },
    linearRampToValueAtTime(next, time) { this.value = next; this.events.push(['linear', next, time]); return this; },
    exponentialRampToValueAtTime(next, time) {
      assert.ok(next > 0, 'Exponential envelope targets must stay above zero.');
      this.value = next; this.events.push(['exponential', next, time]); return this;
    },
    cancelScheduledValues(time) { this.events.push(['cancel', time]); return this; }
  };
}

function audioContext(clock, { resumePlans = [], suspendPlans = [] } = {}) {
  const nodes = [], oscillators = [];
  let state = 'suspended';
  function node(kind) {
    const result = {
      kind, connections: new Set(), disconnects: 0,
      connect(target) { this.connections.add(target); return target; },
      disconnect() { this.disconnects++; this.connections.clear(); }
    };
    nodes.push(result);
    return result;
  }
  const context = {
    nodes, oscillators, resumeCalls: 0, suspendCalls: 0, closeCalls: 0,
    destination: { kind: 'destination' }, onstatechange: null,
    get state() { return state; },
    get currentTime() { return clock.now / 1000; },
    createGain() { return Object.assign(node('gain'), { gain: parameter(1) }); },
    createBiquadFilter() {
      return Object.assign(node('filter'), { type: 'lowpass', frequency: parameter(350), Q: parameter(1), detune: parameter() });
    },
    createOscillator() {
      const oscillator = Object.assign(node('oscillator'), {
        type: 'sine', frequency: parameter(440), detune: parameter(),
        starts: [], stops: [], stopAt: Infinity, ended: false, onended: null,
        start(time = context.currentTime) {
          assert.equal(this.starts.length, 0, 'An oscillator is started only once.');
          assert.ok(Number.isFinite(time) && time >= 0);
          this.starts.push(time);
        },
        stop(time = context.currentTime) {
          assert.ok(Number.isFinite(time) && time >= 0);
          this.stops.push(time); this.stopAt = time;
        }
      });
      oscillators.push(oscillator);
      return oscillator;
    },
    async resume() {
      this.resumeCalls++;
      const plan = resumePlans.shift();
      if (plan) await plan();
      if (state !== 'closed') { state = 'running'; this.onstatechange?.(); }
    },
    async suspend() {
      this.suspendCalls++;
      const plan = suspendPlans.shift();
      if (plan) await plan();
      if (state !== 'closed') { state = 'suspended'; this.onstatechange?.(); }
    },
    async close() { this.closeCalls++; state = 'closed'; this.onstatechange?.(); }
  };
  clock.observe(() => {
    for (const oscillator of oscillators) {
      if (!oscillator.ended && oscillator.stopAt <= context.currentTime) {
        oscillator.ended = true;
        oscillator.onended?.();
      }
    }
  });
  return context;
}

const flush = async () => { for (let i = 0; i < 8; i++) await Promise.resolve(); };
async function settle(clock, promise) {
  let done = false, failure;
  Promise.resolve(promise).then(() => { done = true; }, error => { failure = error; done = true; });
  for (let attempt = 0; attempt < 20 && !done; attempt++) {
    await flush();
    if (!done) clock.advance(100);
  }
  assert.ok(done, 'The lifecycle operation settles after its bounded fade or cleanup.');
  if (failure) throw failure;
}
const originalGlobals = new Map(['window', 'AudioContext', 'webkitAudioContext'].map(key => [key, Object.getOwnPropertyDescriptor(globalThis, key)]));
let defaultConstructions = 0;
const defaultClock = fakeClock(), defaultContext = audioContext(defaultClock);
function FakeBrowserAudioContext() { defaultConstructions++; return defaultContext; }
Object.defineProperty(globalThis, 'window', { configurable: true, writable: true, value: { AudioContext: FakeBrowserAudioContext } });
Object.defineProperty(globalThis, 'AudioContext', { configurable: true, writable: true, value: FakeBrowserAudioContext });
Object.defineProperty(globalThis, 'webkitAudioContext', { configurable: true, writable: true, value: undefined });

const { createTourSoundtrack } = await import('../lib/tour-soundtrack.ts');
assert.equal(defaultConstructions, 0, 'Importing the module cannot create an AudioContext.');

function setup({ resumePlans = [], suspendPlans = [], contextFactory } = {}) {
  const clock = fakeClock(), contexts = [];
  const soundtrack = createTourSoundtrack({
    contextFactory: contextFactory ?? (() => {
      const context = audioContext(clock, { resumePlans, suspendPlans }); contexts.push(context); return context;
    }),
    setInterval: clock.setInterval, clearInterval: clock.clearInterval,
    setTimeout: clock.setTimeout, clearTimeout: clock.clearTimeout
  });
  return { soundtrack, clock, contexts, context: () => contexts.at(-1) };
}

function assertQuiet(harness, message) {
  assert.equal(harness.clock.pending(), 0, `${message}: no scheduler or cleanup timers remain.`);
  for (const context of harness.contexts) {
    assert.ok(context.state === 'suspended' || context.state === 'closed', `${message}: context is suspended or closed.`);
    assert.ok(context.oscillators.every(oscillator => oscillator.stops.some(time => time <= context.currentTime + 0.1)), `${message}: every scheduled voice has been stopped.`);
  }
}

// The default browser factory stays lazy, then uses the browser's AudioContext.
{
  const soundtrack = createTourSoundtrack({
    setInterval: defaultClock.setInterval, clearInterval: defaultClock.clearInterval,
    setTimeout: defaultClock.setTimeout, clearTimeout: defaultClock.clearTimeout
  });
  assert.equal(defaultConstructions, 0, 'Creating a soundtrack cannot create an AudioContext.');
  await soundtrack.start();
  assert.equal(defaultConstructions, 1);
  await settle(defaultClock, soundtrack.dispose());
  defaultClock.advance(1000);
  assert.equal(defaultClock.pending(), 0);
}
for (const [key, descriptor] of originalGlobals) {
  if (descriptor) Object.defineProperty(globalThis, key, descriptor);
  else delete globalThis[key];
}

// Concurrent and repeated starts share one context, resume, and scheduler.
{
  const gate = deferred(), h = setup({ resumePlans: [() => gate.promise] });
  assert.equal(h.contexts.length, 0, 'The injected context factory is lazy.');
  const first = h.soundtrack.start(), second = h.soundtrack.start();
  await flush();
  assert.equal(h.contexts.length, 1);
  assert.equal(h.context().resumeCalls, 1);
  gate.resolve(); await Promise.all([first, second]);
  const context = h.context();
  assert.ok(context.oscillators.length > 0, 'Starting schedules synthetic music voices.');
  const firstCount = context.oscillators.length, firstTimers = h.clock.pending();
  await h.soundtrack.start(); await h.soundtrack.resume();
  assert.equal(h.contexts.length, 1);
  assert.equal(context.resumeCalls, 1);
  assert.equal(context.oscillators.length, firstCount);
  assert.equal(h.clock.pending(), firstTimers);
  assert.ok(firstCount < 512, 'Start does not prebuild an unbounded composition.');
  assert.ok(context.oscillators.every(oscillator => oscillator.starts.every(time => time <= context.currentTime + 30)), 'Voices are scheduled only a bounded distance ahead.');
  assert.ok(h.clock.intervals() <= 1 && firstTimers <= 4, 'Only one bounded scheduler is active.');
  h.clock.advance(120000); await flush();
  assert.ok(context.oscillators.length > firstCount, 'The scheduler continues the composition.');
  assert.ok(context.oscillators.length < 4096, 'Two minutes of scheduling remains bounded.');
  assert.ok(context.oscillators.filter(oscillator => !oscillator.ended).length < 512, 'Finished voices do not accumulate as active audio.');
  assert.ok(h.clock.pending() <= 4);

  await settle(h.clock, h.soundtrack.pause()); h.clock.advance(1000); await flush();
  assertQuiet(h, 'Pause');
  const pausedCount = context.oscillators.length;
  h.clock.advance(30000); await flush();
  assert.equal(context.oscillators.length, pausedCount, 'Pause prevents further music scheduling.');

  await h.soundtrack.resume();
  assert.ok(h.context().oscillators.length > (h.context() === context ? pausedCount : 0), 'Resume starts music again.');
  await settle(h.clock, h.soundtrack.stop()); h.clock.advance(1000); await flush();
  assertQuiet(h, 'Stop');
  const stoppedCounts = h.contexts.map(item => item.oscillators.length);
  h.clock.advance(30000); await flush();
  assert.deepEqual(h.contexts.map(item => item.oscillators.length), stoppedCounts);

  await h.soundtrack.start();
  await settle(h.clock, h.soundtrack.dispose()); h.clock.advance(1000); await flush();
  assertQuiet(h, 'Dispose');
  assert.ok(h.contexts.every(item => item.state === 'closed'), 'Dispose closes every created AudioContext.');
  assert.ok(h.contexts.every(item => item.nodes.every(node => node.connections.size === 0)), 'Dispose disconnects the audio graph.');
  const disposedContexts = h.contexts.length, disposedCounts = h.contexts.map(item => item.oscillators.length);
  await settle(h.clock, h.soundtrack.dispose());
  await Promise.allSettled([h.soundtrack.start(), h.soundtrack.resume()]);
  h.clock.advance(30000); await flush();
  assert.equal(h.contexts.length, disposedContexts, 'Dispose is terminal.');
  assert.deepEqual(h.contexts.map(item => item.oscillators.length), disposedCounts);
  assertQuiet(h, 'Repeated disposal');
}

// Unsupported factories and blocked autoplay fail without leaving work behind.
for (const contextFactory of [() => undefined, () => { throw new Error('Web Audio is unavailable.'); }]) {
  const h = setup({ contextFactory });
  await assert.rejects(h.soundtrack.start());
  await settle(h.clock, h.soundtrack.pause());
  await settle(h.clock, h.soundtrack.stop());
  await settle(h.clock, h.soundtrack.dispose());
  assert.equal(h.clock.pending(), 0);
}
{
  const h = setup({ resumePlans: [() => Promise.reject(new Error('Autoplay blocked.'))] });
  await assert.rejects(h.soundtrack.start());
  assert.equal(h.clock.pending(), 0, 'A rejected resume does not leave a scheduler.');
  assert.ok(h.contexts.every(context => context.oscillators.length === 0), 'A rejected resume does not schedule notes.');
  await h.soundtrack.start();
  assert.ok(h.context().oscillators.length > 0, 'A later explicit start can recover from autoplay rejection.');
  await settle(h.clock, h.soundtrack.dispose()); h.clock.advance(1000); await flush();
  assertQuiet(h, 'Rejected-resume cleanup');
}

// A partly constructed graph is disconnected and closed, and a retry is clean.
for (const failureAt of ['gain', 'filter', 'connect']) {
  const clock = fakeClock(), contexts = [];
  const soundtrack = createTourSoundtrack({
    contextFactory: () => {
      const context = audioContext(clock); contexts.push(context);
      if (contexts.length === 1) {
        if (failureAt === 'gain') context.createGain = () => { throw new Error('Gain allocation failed.'); };
        if (failureAt === 'filter') context.createBiquadFilter = () => { throw new Error('Filter allocation failed.'); };
        if (failureAt === 'connect') {
          const createGain = context.createGain.bind(context);
          context.createGain = () => {
            const gain = createGain(); gain.connect = () => { throw new Error('Graph connection failed.'); }; return gain;
          };
        }
      }
      return context;
    },
    setInterval: clock.setInterval, clearInterval: clock.clearInterval,
    setTimeout: clock.setTimeout, clearTimeout: clock.clearTimeout
  });
  await assert.rejects(soundtrack.start()); await flush();
  assert.equal(contexts[0].state, 'closed', `${failureAt} failure closes the partial context.`);
  assert.ok(contexts[0].nodes.every(node => node.disconnects > 0 && node.connections.size === 0), `${failureAt} failure disconnects allocated graph nodes.`);
  assert.equal(clock.pending(), 0);
  await soundtrack.start();
  assert.equal(contexts.length, 2, 'A retry creates a fresh, complete context.');
  assert.ok(contexts[1].oscillators.length > 0);
  await settle(clock, soundtrack.dispose()); clock.advance(1000); await flush();
  assertQuiet({ clock, contexts }, `Partial ${failureAt} graph cleanup`);
}

// Resuming during the short pause fade cancels its stale suspension and timer.
{
  const h = setup();
  await h.soundtrack.start();
  const context = h.context(), before = context.oscillators.length;
  const pausing = h.soundtrack.pause();
  assert.equal(h.clock.intervals(), 0, 'Pause clears scheduling before the fade completes.');
  await h.soundtrack.resume();
  await settle(h.clock, pausing);
  h.clock.advance(5000); await flush();
  assert.equal(context.state, 'running', 'An old fade cannot suspend the resumed soundtrack.');
  assert.ok(context.oscillators.length > before);
  assert.equal(h.clock.intervals(), 1);
  await settle(h.clock, h.soundtrack.dispose()); h.clock.advance(1000); await flush();
  assertQuiet(h, 'Rapid pause/resume cleanup');
}

// The browser can finish an earlier suspend after a new gesture has resumed it.
// The new start must wait out that suspend and resume again, including when its
// first gesture-time resume transiently rejects during the pending suspension.
for (const transientResumeFailure of [false, true]) {
  const gate = deferred();
  const h = setup({
    suspendPlans: [() => gate.promise],
    resumePlans: transientResumeFailure
      ? [() => Promise.resolve(), () => Promise.reject(new Error('Resume raced with suspend.'))]
      : []
  });
  await h.soundtrack.start();
  const context = h.context();
  const pausing = h.soundtrack.pause();
  h.clock.advance(50); await flush();
  assert.equal(context.suspendCalls, 1, 'The pause fade has requested browser suspension.');
  assert.equal(context.state, 'running', 'The browser can still report running while suspend is pending.');
  const resumesBefore = context.resumeCalls;
  const restarting = h.soundtrack.resume();
  const outcome = Promise.allSettled([restarting]);
  await flush();
  assert.ok(context.resumeCalls > resumesBefore, 'The new gesture invokes resume synchronously, even while the browser reports running.');
  assert.equal(context.state, 'running');
  gate.resolve();
  await settle(h.clock, Promise.all([pausing, outcome]));
  const [result] = await outcome;
  assert.equal(result.status, 'fulfilled', transientResumeFailure
    ? 'A transient gesture-time resume rejection recovers after pending suspension finishes.'
    : 'The new start succeeds after the old suspend finishes.');
  assert.ok(context.resumeCalls >= resumesBefore + 2, 'The new start resumes again after the earlier suspension finishes.');
  assert.equal(context.state, 'running', 'The earlier suspension cannot leave the resumed soundtrack paused.');
  assert.equal(h.clock.intervals(), 1);
  const notesBefore = context.oscillators.length;
  h.clock.advance(5000); await flush();
  assert.ok(context.oscillators.length > notesBefore, 'Music scheduling continues after the suspend/resume race.');
  await settle(h.clock, h.soundtrack.dispose()); h.clock.advance(1000); await flush();
  assertQuiet(h, 'Pending-suspend race cleanup');
}

// A late browser resume cannot revive a paused, stopped, or disposed soundtrack.
for (const action of ['pause', 'stop', 'dispose']) {
  const gate = deferred(), h = setup({ resumePlans: [() => gate.promise] });
  const starting = h.soundtrack.start();
  const startResult = Promise.allSettled([starting]);
  await flush();
  assert.equal(h.context().resumeCalls, 1);
  const ending = h.soundtrack[action]();
  await flush();
  gate.resolve();
  await settle(h.clock, Promise.all([startResult, ending]));
  h.clock.advance(30000); await flush();
  assert.equal(h.context().oscillators.length, 0, `A stale resume after ${action} cannot schedule notes.`);
  assertQuiet(h, `Stale resume after ${action}`);
  await settle(h.clock, h.soundtrack.dispose()); h.clock.advance(1000); await flush();
}

console.log('PASS: lazy Web Audio creation; bounded idempotent scheduling; pause, resume, stop and terminal disposal; graph and timer cleanup; unsupported audio and rejected autoplay; pending-suspend race recovery; stale-resume cancellation.');
