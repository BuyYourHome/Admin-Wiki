/** Ephemeral PCM activity only. This meter never plays, retains or uploads audio. */
export type PondsterStreamMeter = {
  readonly available: boolean;
  whenRunning(): Promise<boolean>;
  setInput(stream: MediaStream): void;
  setOutput(stream: MediaStream): void;
  sample(): { input: boolean | null; output: boolean | null };
  stop(): void;
};

const FFT_SIZE = 32768, MIN_COVERAGE_SECONDS = 0.25, ACTIVITY_LEVEL = 0.005;
type Slot = { stream: MediaStream; source: MediaStreamAudioSourceNode; analyser: AnalyserNode;
  buffer: Float32Array<ArrayBuffer>; attachedAt: number };
type Direction = 'input' | 'output';

export function createPondsterStreamMeter(contextFactory?: () => AudioContext): PondsterStreamMeter {
  let context: AudioContext | null = null, stopped = false, closeRequested = false;
  let resumePromise: Promise<void> | null = null;
  let runningSince: number | null = null, lastSampleAt: number | null = null;
  const slots: Record<Direction, Slot | null> = { input: null, output: null };
  const time = () => {
    const value = context?.currentTime;
    return typeof value === 'number' && Number.isFinite(value) && value >= 0 ? value : null;
  };
  function release(slot: Slot | null) {
    if (!slot) return;
    slot.buffer.fill(0);
    try { slot.source.disconnect(); } catch { /* Closing the context also releases its graph. */ }
    try { slot.analyser.disconnect(); } catch { /* Already disconnected. */ }
  }
  function stop() {
    if (stopped) return;
    stopped = true; runningSince = lastSampleAt = null;
    release(slots.input); release(slots.output); slots.input = slots.output = null;
    if (context && !closeRequested) {
      closeRequested = true;
      try { if (context.state !== 'closed') void Promise.resolve(context.close()).catch(() => {}); } catch { /* No uncaught cleanup error. */ }
    }
  }
  function live(stream: MediaStream) {
    try {
      const tracks = stream.getAudioTracks();
      return tracks.length > 0 && tracks.every(track => track.readyState === 'live');
    } catch { return false; }
  }
  function attach(direction: Direction, stream: MediaStream) {
    if (stopped || !context || context.state === 'closed') return;
    release(slots[direction]); slots[direction] = null;
    const at = time();
    if (at === null || !live(stream)) return;
    let source: MediaStreamAudioSourceNode | null = null, analyser: AnalyserNode | null = null;
    try {
      source = context.createMediaStreamSource(stream);
      analyser = context.createAnalyser(); analyser.fftSize = FFT_SIZE;
      const buffer = new Float32Array(FFT_SIZE);
      source.connect(analyser);
      slots[direction] = { stream, source, analyser, buffer, attachedAt: at };
    } catch {
      try { source?.disconnect(); } catch { /* Partial construction. */ }
      try { analyser?.disconnect(); } catch { /* Partial construction. */ }
      stop();
    }
  }
  function read(slot: Slot | null, at: number, warmupSeconds: number, blockSize: number): boolean | null {
    if (!slot || !live(slot.stream) || at - slot.attachedAt < warmupSeconds) return null;
    try {
      slot.analyser.getFloatTimeDomainData(slot.buffer);
      // Keep brief speech anywhere in the covered interval from being diluted
      // by the rest of the large, mostly silent analysis window.
      let energy = 0, count = 0, peakMeanEnergy = 0;
      for (let index = 0; index < slot.buffer.length; index++) {
        const value = slot.buffer[index];
        if (!Number.isFinite(value)) return null;
        energy += value * value; count++;
        if (count === blockSize || index === slot.buffer.length - 1) {
          peakMeanEnergy = Math.max(peakMeanEnergy, energy / count);
          energy = 0; count = 0;
        }
      }
      return Math.sqrt(peakMeanEnergy) > ACTIVITY_LEVEL;
    } catch { return null; }
    finally { slot.buffer.fill(0); }
  }
  try {
    context = contextFactory ? contextFactory() : new globalThis.AudioContext();
    if (context.state === 'closed') stop();
    else {
      if (context.state === 'running') runningSince = time();
      lastSampleAt = time();
      // Request resume synchronously in the owner's explicit gesture. Settlement
      // never reattaches a stream or resurrects a stopped meter.
      resumePromise = Promise.resolve(context.resume()).then(() => {
        if (!stopped && context?.state === 'running') { runningSince = time(); lastSampleAt = time(); }
      }, stop);
    }
  } catch { stop(); }
  return {
    get available() { return !stopped && context !== null && context.state !== 'closed'; },
    async whenRunning() {
      if (stopped || !context || !resumePromise) return false;
      await resumePromise;
      return !stopped && context.state === 'running';
    },
    setInput(stream) { attach('input', stream); },
    setOutput(stream) { attach('output', stream); },
    sample() {
      const unknown = { input: null, output: null };
      if (stopped || !context) return unknown;
      const at = time();
      if (context.state !== 'running' || at === null) { runningSince = null; lastSampleAt = at; return unknown; }
      if (runningSince === null) { runningSince = at; lastSampleAt = at; return unknown; }
      if (lastSampleAt !== null && at <= lastSampleAt) {
        if (at < lastSampleAt) runningSince = at;
        lastSampleAt = at; return unknown;
      }
      const previousSampleAt = lastSampleAt;
      lastSampleAt = at;
      const quantum = 'renderQuantumSize' in context && typeof context.renderQuantumSize === 'number'
        && Number.isFinite(context.renderQuantumSize) && context.renderQuantumSize > 0 ? context.renderQuantumSize : 128;
      const windowSeconds = FFT_SIZE / context.sampleRate;
      const warmupSeconds = (FFT_SIZE + quantum) / context.sampleRate;
      // A delayed poll or unsupported sample rate must not turn an uncovered
      // interval into measured silence.
      if (!Number.isFinite(windowSeconds) || windowSeconds < MIN_COVERAGE_SECONDS
        || at - runningSince < warmupSeconds
        || (previousSampleAt !== null && at - previousSampleAt > windowSeconds)) return unknown;
      const blockSize = Math.max(1, Math.round(context.sampleRate * 0.01));
      return { input: read(slots.input, at, warmupSeconds, blockSize), output: read(slots.output, at, warmupSeconds, blockSize) };
    },
    stop,
  };
}
