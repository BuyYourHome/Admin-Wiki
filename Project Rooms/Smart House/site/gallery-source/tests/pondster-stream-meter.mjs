import assert from 'node:assert/strict';
import { createPondsterStreamMeter } from '../lib/pondster-stream-meter.ts';

// Synthetic PCM/context/stream doubles only: no browser, microphone or playback.
const flush = async () => { for (let i = 0; i < 8; i++) await Promise.resolve(); };
const unknown = { input: null, output: null };
function deferred() { let resolve, reject; const promise = new Promise((yes, no) => { resolve = yes; reject = no; }); return { promise, resolve, reject }; }
function stream(level = 0) {
  const track = { readyState: 'live', muted: false, stops: 0, stop() { this.stops++; this.readyState = 'ended'; } };
  return { level, track, getAudioTracks: () => [track] };
}
function context({ state = 'running', resumeGate, resumeFailure, closeFailure = false } = {}) {
  const value = {
    state, currentTime: 0, sampleRate: 48_000, renderQuantumSize: 128,
    sources: [], analysers: [], buffers: [], resumes: 0, closes: 0, failAt: '', destination: {},
    resume() {
      this.resumes++;
      if (resumeFailure === 'throw') throw new Error('Synthetic resume failure');
      if (resumeFailure === 'reject') return Promise.reject(new Error('Synthetic resume rejection'));
      return resumeGate?.promise ?? Promise.resolve();
    },
    close() { this.closes++; this.state = 'closed'; return closeFailure ? Promise.reject(new Error('Synthetic close rejection')) : Promise.resolve(); },
    createMediaStreamSource(input) {
      if (this.failAt === 'source') throw new Error('Synthetic source failure');
      const node = { input, disconnected: 0, connections: [],
        connect(target) { this.connections.push(target); target.input = input; if (value.failAt === 'connect') throw new Error('Synthetic connect failure'); return target; },
        disconnect() { this.disconnected++; }
      };
      this.sources.push(node); return node;
    },
    createAnalyser() {
      if (this.failAt === 'analyser') throw new Error('Synthetic analyser failure');
      let size;
      const node = { input: null, disconnected: 0, connections: [], reads: 0,
        get fftSize() { return size; }, set fftSize(next) { if (value.failAt === 'fft') throw new Error('Synthetic fft failure'); size = next; },
        getFloatTimeDomainData(buffer) {
          this.reads++; value.buffers.push(buffer);
          const level = this.input.track.muted ? 0 : this.input.level;
          buffer.forEach((_sample, i) => {
            const pulse = this.input.pulse;
            const sample = pulse && !this.input.track.muted
              ? (i >= pulse.start && i < pulse.start + pulse.length ? pulse.level : 0) : level;
            buffer[i] = i % 2 ? -sample : sample;
          });
          if (this.input.readFailure) throw new Error('Synthetic read failure');
        },
        connect(target) { this.connections.push(target); }, disconnect() { this.disconnected++; }
      };
      this.analysers.push(node); return node;
    }
  };
  return value;
}
const zeroed = ctx => assert.ok(ctx.buffers.every(buffer => buffer.every(value => value === 0)), 'Every PCM buffer is zeroed immediately after reading.');
const noFeedback = ctx => {
  assert.ok(ctx.sources.every(node => node.connections.every(target => ctx.analysers.includes(target))));
  assert.ok(ctx.analysers.every(node => node.connections.length === 0), 'No analyser/destination connection can play or feed audio back.');
};
const sampleAt = (ctx, meter, at) => { ctx.currentTime = at; return meter.sample(); };
const warm = (ctx, meter, start = 0) => {
  assert.deepEqual(sampleAt(ctx, meter, start + .25), unknown);
  assert.deepEqual(sampleAt(ctx, meter, start + .5), unknown);
};

{
  const descriptor = Object.getOwnPropertyDescriptor(globalThis, 'AudioContext');
  try {
    Object.defineProperty(globalThis, 'AudioContext', { configurable: true, value: undefined });
    const meter = createPondsterStreamMeter();
    assert.equal(meter.available, false); assert.equal(await meter.whenRunning(), false); assert.deepEqual(meter.sample(), unknown); meter.stop();
  } finally { if (descriptor) Object.defineProperty(globalThis, 'AudioContext', descriptor); else delete globalThis.AudioContext; }
  assert.equal(createPondsterStreamMeter(() => { throw new Error('Synthetic constructor failure'); }).available, false);
}
{
  const ctx = context(), meter = createPondsterStreamMeter(() => ctx), input = stream(.02), output = stream(.03);
  assert.equal(ctx.resumes, 1, 'Resume is requested synchronously during construction.');
  meter.setInput(input); meter.setOutput(output); await flush();
  assert.equal(await meter.whenRunning(), true);
  assert.ok(ctx.analysers.every(node => node.fftSize === 32768));
  assert.deepEqual(meter.sample(), unknown);
  warm(ctx, meter);
  ctx.currentTime = .68; assert.deepEqual(meter.sample(), unknown, 'Warmup includes the full PCM window and one render quantum.');
  ctx.currentTime = .75; assert.deepEqual(meter.sample(), { input: true, output: true }); zeroed(ctx);
  // A stale external RTC level has no influence on fresh stream PCM.
  input.rtcAudioLevel = output.rtcAudioLevel = .9; input.level = output.level = 0;
  ctx.currentTime = 1; assert.deepEqual(meter.sample(), { input: false, output: false }); zeroed(ctx);
  assert.deepEqual(meter.sample(), unknown, 'A frozen currentTime cannot reuse a previous PCM result.');
  input.level = .02; output.level = 0;
  ctx.currentTime = 1.25; assert.deepEqual(meter.sample(), { input: true, output: false });
  input.track.readyState = 'ended'; ctx.currentTime = 1.5;
  assert.deepEqual(meter.sample(), { input: null, output: false });
  output.track.muted = true; ctx.currentTime = 1.75; assert.deepEqual(meter.sample(), { input: null, output: false });
  noFeedback(ctx); meter.stop(); meter.stop();
  assert.equal(ctx.closes, 1); assert.equal(meter.available, false);
  assert.ok(ctx.sources.every(node => node.disconnected === 1)); assert.ok(ctx.analysers.every(node => node.disconnected === 1));
  assert.equal(input.track.stops + output.track.stops, 0, 'The stream owner alone stops its tracks.');
  assert.deepEqual(meter.sample(), unknown); zeroed(ctx);
}
{
  const ctx = context(), meter = createPondsterStreamMeter(() => ctx), input = stream(0), output = stream(.03);
  output.track.muted = true;
  meter.setInput(input); meter.setOutput(output); await flush();
  assert.equal(ctx.sources.length, 2, 'An initially muted, live WebRTC track is attached immediately.');
  warm(ctx, meter);
  ctx.currentTime = .75; assert.deepEqual(meter.sample(), { input: false, output: false }, 'Fresh rendered PCM during mute is measured directly.');
  output.track.muted = false; ctx.currentTime = 1;
  assert.deepEqual(meter.sample(), { input: false, output: true }, 'Unmuting becomes measurable without another setOutput call.');
  assert.equal(ctx.sources.length, 2); assert.equal(ctx.analysers.length, 2);
  meter.stop(); assert.equal(input.track.stops + output.track.stops, 0); zeroed(ctx);
}
{
  const gate = deferred(), ctx = context({ state: 'suspended', resumeGate: gate });
  const meter = createPondsterStreamMeter(() => ctx), input = stream(0), output = stream(0);
  let readinessSettled = false;
  const readiness = meter.whenRunning().then(result => { readinessSettled = true; return result; });
  await flush(); assert.equal(readinessSettled, false, 'Pending resume is not treated as permission to start capture.');
  meter.setInput(input); meter.setOutput(output);
  ctx.currentTime = 1; assert.deepEqual(meter.sample(), unknown, 'Suspension is never assumed to be silence.');
  ctx.state = 'running'; gate.resolve(); await flush();
  assert.equal(await readiness, true);
  warm(ctx, meter, 1);
  ctx.currentTime = 1.75; assert.deepEqual(meter.sample(), { input: false, output: false });
  ctx.state = 'suspended'; ctx.currentTime = 2; assert.deepEqual(meter.sample(), unknown);
  ctx.state = 'running'; ctx.currentTime = 3; assert.deepEqual(meter.sample(), unknown);
  warm(ctx, meter, 3);
  ctx.currentTime = 3.75; assert.deepEqual(meter.sample(), { input: false, output: false });
  meter.stop(); zeroed(ctx);
}
{
  const ctx = context(), meter = createPondsterStreamMeter(() => ctx), old = stream(.5), replacement = stream(0);
  meter.setInput(old); await flush(); warm(ctx, meter); ctx.currentTime = .75; assert.deepEqual(meter.sample(), { input: true, output: null });
  const source = ctx.sources[0], analyser = ctx.analysers[0];
  meter.setInput(replacement);
  assert.equal(source.disconnected, 1); assert.equal(analyser.disconnected, 1);
  warm(ctx, meter, .75);
  ctx.currentTime = 1.5; assert.deepEqual(meter.sample(), { input: false, output: null });
  assert.equal(analyser.reads, 1, 'A replaced analyser is never sampled again.');
  meter.stop(); meter.setOutput(stream()); assert.equal(ctx.sources.length, 2); zeroed(ctx);
  assert.equal(old.track.stops + replacement.track.stops, 0);
}
for (const resumeFailure of ['throw', 'reject']) {
  const ctx = context({ resumeFailure, closeFailure: true }), meter = createPondsterStreamMeter(() => ctx);
  await flush(); assert.equal(meter.available, false); assert.deepEqual(meter.sample(), unknown);
  assert.equal(await meter.whenRunning(), false);
  assert.equal(ctx.closes, 1); meter.stop(); assert.equal(ctx.closes, 1);
}
for (const failAt of ['source', 'analyser', 'fft', 'connect']) {
  const ctx = context(), meter = createPondsterStreamMeter(() => ctx);
  meter.setOutput(stream()); await flush(); ctx.failAt = failAt;
  assert.doesNotThrow(() => meter.setInput(stream()));
  assert.equal(meter.available, false); assert.equal(ctx.closes, 1);
  assert.ok(ctx.sources.every(node => node.disconnected === 1));
  assert.ok(ctx.analysers.every(node => node.disconnected === 1)); zeroed(ctx);
}
{
  const ctx = context(), meter = createPondsterStreamMeter(() => ctx), input = stream(.2);
  input.readFailure = true; meter.setInput(input); await flush(); warm(ctx, meter); ctx.currentTime = .75;
  assert.deepEqual(meter.sample(), unknown); assert.equal(ctx.analysers[0].reads, 1); zeroed(ctx); meter.stop();
}
{
  const ctx = context(), meter = createPondsterStreamMeter(() => ctx), input = stream(0), output = stream(0);
  // This 20ms utterance is outside the final 2048 samples. Its whole-window
  // RMS is below .005, so it specifically verifies the short-window peak.
  input.pulse = { start: 5000, length: 960, level: .02 };
  meter.setInput(input); meter.setOutput(output); await flush(); warm(ctx, meter);
  assert.deepEqual(sampleAt(ctx, meter, .75), { input: true, output: false }, 'Brief earlier speech is retained across a 250ms polling interval.');
  delete input.pulse;
  assert.deepEqual(sampleAt(ctx, meter, 1.5), unknown, 'A polling gap longer than the PCM window leaves an uncovered interval unknown.');
  assert.deepEqual(sampleAt(ctx, meter, 1.75), { input: false, output: false }, 'Fresh covered quiet is measurable after a delayed poll.');
  zeroed(ctx); noFeedback(ctx); meter.stop();
}
{
  const ctx = context(), meter = createPondsterStreamMeter(() => ctx);
  ctx.sampleRate = 192_000; meter.setInput(stream(0)); meter.setOutput(stream(0)); await flush();
  for (const at of [.25, .5, .75, 1]) assert.deepEqual(sampleAt(ctx, meter, at), unknown,
    'Sample rates whose maximum analyser window cannot cover 250ms are unknown, never quiet.');
  assert.ok(ctx.analysers.every(node => node.reads === 0)); meter.stop();
}
for (const rejected of [false, true]) {
  const gate = deferred(), ctx = context({ state: 'suspended', resumeGate: gate }), meter = createPondsterStreamMeter(() => ctx);
  const readiness = meter.whenRunning();
  const input = stream(); meter.setInput(input); meter.stop();
  assert.equal(await meter.whenRunning(), false, 'A stopped meter does not wait on an unsettled resume.');
  if (rejected) gate.reject(new Error('Late synthetic rejection')); else { ctx.state = 'running'; gate.resolve(); }
  await flush(); ctx.currentTime = 10;
  assert.equal(await readiness, false, 'Late resume settlement cannot authorize capture after stopping.');
  assert.equal(meter.available, false); assert.deepEqual(meter.sample(), unknown);
  assert.equal(ctx.closes, 1); assert.equal(ctx.resumes, 1); assert.equal(input.track.stops, 0);
  assert.ok(ctx.sources.every(node => node.disconnected === 1));
}
{
  const ctx = context({ state: 'suspended' }), meter = createPondsterStreamMeter(() => ctx);
  assert.equal(await meter.whenRunning(), false, 'A settled resume that remains suspended is denied.');
  meter.stop();
}
console.log('PASS: covered stream PCM and brief-speech peaks; polling gaps/high rates/suspended/frozen/warmup/ended unknown; replacement and partial-failure cleanup; rejected/late resume; no feedback or track ownership; buffers cleared (synthetic unit only).');
