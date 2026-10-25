/** Original, quiet instrumental music synthesized locally; nothing is downloaded. */
export type TourSoundtrack = {
  start(): Promise<void>;
  resume(): Promise<void>;
  pause(): Promise<void>;
  stop(): Promise<void>;
  dispose(): Promise<void>;
};

type Timer = unknown;
export type TourSoundtrackOptions = {
  contextFactory?: () => AudioContext;
  setInterval?: (callback: () => void, milliseconds: number) => Timer;
  clearInterval?: (timer: Timer) => void;
  setTimeout?: (callback: () => void, milliseconds: number) => Timer;
  clearTimeout?: (timer: Timer) => void;
};
type Voice = { oscillator: OscillatorNode; gain: GainNode; end: number };

const STEP = 0.9;
const CHORDS = [[50, 57, 61, 64], [47, 54, 57, 62], [43, 50, 54, 59], [45, 52, 57, 59]];
const MELODY = [69, 73, 76, 73, 71, 69, 66, 64, 66, 69, 73, 69, 71, 69, 66, 64];

function browserContext(): AudioContext {
  const browser = globalThis as typeof globalThis & { webkitAudioContext?: typeof AudioContext };
  const Constructor = browser.AudioContext || browser.webkitAudioContext;
  if (!Constructor) throw new Error('My soundtrack is not supported in this browser. You can continue my tour without music.');
  return new Constructor({ latencyHint: 'playback' });
}

/** Construct freely; start/resume must first be called from a visitor's click. */
export function createTourSoundtrack(options: TourSoundtrackOptions = {}): TourSoundtrack {
  const contextFactory = options.contextFactory || browserContext;
  const every = options.setInterval || ((callback, delay) => globalThis.setInterval(callback, delay));
  const clearEvery = options.clearInterval || (timer => globalThis.clearInterval(timer as ReturnType<typeof setInterval>));
  const later = options.setTimeout || ((callback, delay) => globalThis.setTimeout(callback, delay));
  const clearLater = options.clearTimeout || (timer => globalThis.clearTimeout(timer as ReturnType<typeof setTimeout>));
  let context: AudioContext | null = null, master: GainNode | null = null, tone: BiquadFilterNode | null = null;
  let disposed = false, wanted = false, playing = false, generation = 0, step = 0, nextTime = 0;
  let ticker: Timer = null, fadeTimer: Timer = null, finishFade: (() => void) | null = null;
  let pendingStart: Promise<void> | null = null;
  let pendingSuspend: Promise<void> | null = null;
  const voices = new Set<Voice>();

  function clearTicker() { if (ticker !== null) clearEvery(ticker); ticker = null; }
  function cancelFade() {
    if (fadeTimer !== null) clearLater(fadeTimer);
    fadeTimer = null;
    const finish = finishFade; finishFade = null; finish?.();
  }
  function remove(voice: Voice, stop = false) {
    if (!voices.delete(voice)) return;
    voice.oscillator.onended = null;
    if (stop) { try { voice.oscillator.stop(); } catch {} }
    voice.oscillator.disconnect(); voice.gain.disconnect();
  }
  function silence() {
    if (context && master) {
      master.gain.cancelScheduledValues(context.currentTime);
      master.gain.setValueAtTime(0, context.currentTime);
    }
    for (const voice of voices) remove(voice, true);
  }
  function suspendContext(current: AudioContext): Promise<void> {
    if (pendingSuspend) return pendingSuspend;
    let request: Promise<void>;
    try { request = current.suspend(); } catch { return Promise.resolve(); }
    const settling = Promise.resolve(request).catch(() => {}).finally(() => {
      if (pendingSuspend === settling) pendingSuspend = null;
    });
    pendingSuspend = settling;
    return settling;
  }
  function ensureContext() {
    if (context) return context;
    const created = contextFactory();
    context = created;
    try {
      master = created.createGain(); master.gain.value = 0;
      tone = created.createBiquadFilter(); tone.type = 'lowpass'; tone.frequency.value = 1400; tone.Q.value = 0.35;
      tone.connect(master); master.connect(created.destination);
    } catch (error) {
      tone?.disconnect(); master?.disconnect(); tone = master = null; context = null;
      try { void created.close().catch(() => {}); } catch {}
      throw error;
    }
    created.onstatechange = () => {
      if (context === created && created.state !== 'running' && playing) {
        playing = false; clearTicker(); silence();
      }
    };
    return created;
  }
  function note(midi: number, when: number, duration: number, level: number, melody = false) {
    if (!context || !tone) return;
    const oscillator = context.createOscillator(), gain = context.createGain();
    oscillator.type = melody ? 'triangle' : 'sine';
    oscillator.frequency.setValueAtTime(440 * 2 ** ((midi - 69) / 12), when);
    const attack = Math.min(melody ? 0.12 : 1.1, duration * 0.25), end = when + duration;
    gain.gain.setValueAtTime(0, when);
    gain.gain.linearRampToValueAtTime(level, when + attack);
    gain.gain.exponentialRampToValueAtTime(0.0001, Math.max(when + attack + 0.01, end - Math.min(0.8, duration * 0.35)));
    gain.gain.linearRampToValueAtTime(0, end);
    oscillator.connect(gain); gain.connect(tone);
    const voice = { oscillator, gain, end }; voices.add(voice);
    oscillator.onended = () => remove(voice);
    oscillator.start(when); oscillator.stop(end + 0.02);
  }
  function bed(when: number, remaining = 8) {
    for (const pitch of CHORDS[Math.floor(step / 8) % CHORDS.length]) note(pitch, when, remaining * STEP - 0.04, 0.045);
  }
  function schedule() {
    if (!playing || !wanted || !context || context.state !== 'running') return;
    const now = context.currentTime;
    for (const voice of voices) if (voice.end + 0.1 < now) remove(voice, true);
    // Never backfill a long throttled/background interval with a burst of notes.
    if (nextTime < now - 0.1) { nextTime = now + 0.06; if (step % 8) bed(nextTime, 8 - step % 8); }
    let count = 0;
    while (nextTime < now + 0.45 && count++ < 2) {
      if (step % 8 === 0) bed(nextTime);
      if (step % 2 === 0) note(MELODY[Math.floor(step / 2) % MELODY.length], nextTime, STEP * 1.8, 0.027, true);
      step = (step + 1) % 32; nextTime += STEP;
    }
  }
  function start(): Promise<void> {
    if (disposed) return Promise.reject(new Error('My soundtrack has been closed.'));
    wanted = true;
    if (playing && context?.state === 'running') return Promise.resolve();
    if (pendingStart) return pendingStart;
    const version = ++generation;
    cancelFade(); silence();
    let current: AudioContext, resumed: Promise<void>;
    try {
      current = ensureContext();
      // Invoke resume synchronously in the click call stack, before awaiting anything.
      const suspension = pendingSuspend;
      try { resumed = current.resume(); }
      catch (error) { if (!suspension) throw error; resumed = Promise.resolve(); }
      if (suspension) {
        // A prior pause can still complete after this gesture's first resume.
        // Resume once more only after that suspension has settled.
        resumed = Promise.all([suspension, Promise.resolve(resumed).catch(() => {})]).then(() => {
          if (disposed || version !== generation || !wanted) return;
          return current.resume();
        });
      }
    } catch (error) { wanted = false; return Promise.reject(error); }
    const attempt = Promise.resolve(resumed).then(async () => {
      if (disposed || version !== generation || !wanted) {
        if (!disposed && !wanted && current === context && current.state === 'running') await suspendContext(current);
        return;
      }
      if (current.state !== 'running') throw new Error('The audio context did not start.');
      master!.gain.cancelScheduledValues(current.currentTime);
      master!.gain.setValueAtTime(0, current.currentTime);
      master!.gain.linearRampToValueAtTime(0.24, current.currentTime + 0.28);
      nextTime = current.currentTime + 0.06; playing = true;
      if (step % 8) bed(nextTime, 8 - step % 8);
      schedule(); clearTicker(); ticker = every(schedule, 100);
    }).catch(() => {
      if (disposed || version !== generation) return;
      wanted = playing = false; clearTicker(); silence();
      throw new Error('I couldn’t start my music. Try my music control again, or continue my tour without sound.');
    }).finally(() => { if (pendingStart === attempt) pendingStart = null; });
    pendingStart = attempt;
    return attempt;
  }
  function pause(reset = false): Promise<void> {
    wanted = playing = false; const version = ++generation; pendingStart = null;
    clearTicker(); cancelFade(); if (reset) step = 0;
    const current = context;
    if (!current || current.state === 'closed') { silence(); return Promise.resolve(); }
    if (current.state !== 'running') { silence(); return suspendContext(current); }
    const now = current.currentTime;
    master!.gain.cancelScheduledValues(now); master!.gain.setValueAtTime(master!.gain.value, now);
    master!.gain.linearRampToValueAtTime(0, now + 0.04);
    for (const voice of voices) { try { voice.oscillator.stop(now + 0.045); } catch {} }
    return new Promise(resolve => {
      finishFade = resolve;
      fadeTimer = later(() => {
        fadeTimer = null; finishFade = null;
        if (disposed || wanted || version !== generation) { resolve(); return; }
        silence(); suspendContext(current).then(resolve);
      }, 50);
    });
  }
  async function dispose() {
    if (disposed) return;
    disposed = true; wanted = playing = false; generation++; pendingStart = null;
    clearTicker(); cancelFade(); silence();
    const current = context; context = null;
    if (current) current.onstatechange = null;
    tone?.disconnect(); master?.disconnect(); tone = master = null;
    if (current && current.state !== 'closed') await current.close().catch(() => {});
  }
  return { start, resume: start, pause: () => pause(), stop: () => pause(true), dispose };
}
