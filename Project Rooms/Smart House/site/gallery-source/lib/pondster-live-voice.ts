/** Browser-only transport for Pondster's bounded, server-controlled Live voice. */
import { createPondsterStreamMeter } from './pondster-stream-meter';
import { isPondsterFarewell, PONDSTER_FAREWELL_ACK } from './pondster-voice-intents';
export type PondsterQuietProgress = { reason: 'checking' | 'unavailable' | 'input' | 'output' | 'work' | 'response' | 'quiet'; remainingSeconds: number | null };
export type PondsterLiveState = {
  available: boolean; connecting: boolean; active: boolean;
  status: string; heard: string; audioBlocked: boolean;
  silenceAvailable: boolean | null;
  quietReason: PondsterQuietProgress['reason']; quietSecondsRemaining: number | null;
};
export type PondsterLiveTranscript = { who: 'you' | 'Pondster'; text: string };
export type PondsterLiveAction = {
  menu: 'Design' | 'Explore' | 'View' | 'Own' | 'Contact' | 'Built By';
  room?: string; scene?: 'day' | 'evening' | 'relax';
  tour?: true;
};
type Timer = unknown;
type Visibility = Pick<Document, 'hidden' | 'addEventListener' | 'removeEventListener'>;
export type PondsterLiveVoiceOptions = {
  audioElement: HTMLAudioElement;
  onState(state: PondsterLiveState): void;
  onTranscript(transcript: PondsterLiveTranscript): void;
  onAction?(action: PondsterLiveAction): void;
  // Dependency injection keeps lifecycle tests away from real devices/network.
  getUserMedia?: () => Promise<MediaStream>;
  peerFactory?: () => RTCPeerConnection;
  controlFactory?: (url: string) => WebSocket;
  fetcher?: typeof fetch;
  streamFactory?: (tracks: MediaStreamTrack[]) => MediaStream;
  requestIdFactory?: () => string;
  now?: () => number;
  activitySamplerFactory?: (peer: RTCPeerConnection) => () => Promise<PondsterAudioActivity>;
  streamMeterFactory?: typeof createPondsterStreamMeter;
  origin?: string;
  visibilityTarget?: Visibility;
  setTimeout?: (callback: () => void, milliseconds: number) => Timer;
  clearTimeout?: (timer: Timer) => void;
};
export type PondsterLiveVoice = {
  start(): Promise<void>; stop(): void; dispose(): void;
  sendText(text: string): void; noteInteraction(): void; resumeAudio(): Promise<void>;
};
type Caption = { text: string; lastEnd: number | null; timer: Timer | null };
type Attempt = {
  id: number; stopped: boolean; started: boolean; finalized: boolean;
  mic: MediaStream | null; peer: RTCPeerConnection | null;
  channel: RTCDataChannel | null; control: WebSocket | null;
  abort: AbortController; timers: Set<Timer>;
  cancelled: Promise<symbol>; cancel(): void;
  startPromise: Promise<void>; ready(): void;
  captions: Record<'you' | 'Pondster', Caption>;
  closeSent: boolean; stopSent: boolean; startedSent: boolean;
  silenceMonitor: PondsterSilenceMonitor | null;
  streamMeter: ReturnType<typeof createPondsterStreamMeter> | null;
  busyUntil: { work: number; response: number };
};
const CANCELLED = Symbol('cancelled');
const ROOMS = new Set(['kitchen', 'media-center', 'front-elevation', 'garage-barn-door', 'adu', 'master-bath', 'hall-bath', 'spiral-staircase', 'back-deck']);
const MENUS = new Set(['Design', 'Explore', 'View', 'Own', 'Contact', 'Built By']);
const SCENES = new Set(['day', 'evening', 'relax']);
const TEXT_LIMIT = 500, CAPTION_LIMIT = 1800;
export const PONDSTER_SILENCE_MS = 30_000;
const AUDIO_POLL_MS = 250, AUDIO_QUERY_MS = 1000, AUDIO_STALE_MS = 1500, AUDIO_UNAVAILABLE_MS = 10_000, BUSY_HOLD_MS = 30_000;
// A low RMS floor distinguishes digital/room silence from audible activity.
const AUDIO_ACTIVITY_LEVEL = 0.005;
const liveNow = () => typeof performance === 'undefined' ? Date.now() : performance.now();
export type PondsterAudioActivity = { input: boolean | null; output: boolean | null };
type BusyKind = 'work' | 'response';
export type PondsterSilenceMonitor = {
  stop(): void; noteInteraction(): void; setBusy(kind: BusyKind, active: boolean, holdMs?: number): void;
};
type AudioSnapshot = { stamp: number; changedAt: number; energy: number | null; duration: number | null };

/** Only numerical audio metrics remain in memory; no audio/transcripts are collected. */
export function createPondsterAudioSampler(peer: Pick<RTCPeerConnection, 'getStats'>, now = liveNow) {
  const previous = new Map<string, AudioSnapshot>();
  const number = (value: unknown) => typeof value === 'number' && Number.isFinite(value) && value >= 0 ? value : null;
  function activity(stat: Record<string, unknown>, at: number): boolean | null {
    const stamp = number(stat.timestamp), id = stat.id;
    if (stamp === null || typeof id !== 'string') return null;
    const old = previous.get(id), energy = number(stat.totalAudioEnergy), duration = number(stat.totalSamplesDuration);
    const changedAt = !old || stamp > old.stamp ? at : old.changedAt;
    previous.set(id, { stamp, changedAt, energy, duration });
    if (previous.size > 64) previous.clear();
    if (old && (stamp < old.stamp || at - changedAt > AUDIO_STALE_MS)) return null;
    let level = number(stat.audioLevel);
    if (level !== null && level > 1) level = null;
    if (old && energy !== null && duration !== null && old.energy !== null && old.duration !== null) {
      const elapsed = duration - old.duration, used = energy - old.energy;
      if (elapsed > 0 && used >= 0) level = Math.sqrt(used / elapsed);
      // An updated report timestamp does not make a latched last-packet level fresh.
      else level = null; // Flat, reset, reordered, or inconsistent counters are unknown.
    }
    return level === null ? null : level > AUDIO_ACTIVITY_LEVEL;
  }
  const combine = (values: Array<boolean | null>) => values.some(value => value === true) ? true
    : values.length > 0 && values.every(value => value === false) ? false : null;
  return async (): Promise<PondsterAudioActivity> => {
    if (typeof peer.getStats !== 'function') return { input: null, output: null };
    const report = await peer.getStats(), at = now();
    const input: Array<boolean | null> = [], output: Array<boolean | null> = [];
    report.forEach((raw: unknown) => {
      if (!raw || typeof raw !== 'object' || Array.isArray(raw)) return;
      const stat = raw as Record<string, unknown>;
      if ((stat.kind ?? stat.mediaType) !== 'audio') return;
      if (stat.type === 'media-source') input.push(activity(stat, at));
      else if (stat.type === 'inbound-rtp') output.push(activity(stat, at));
    });
    return { input: combine(input), output: combine(output) };
  };
}

/** Start only after media readiness. Unknown meters never become quiet time. */
export function createPondsterSilenceMonitor(options: {
  sample: () => Promise<PondsterAudioActivity>;
  onSilence(): void; onAvailability(value: boolean): void;
  onProgress?(progress: PondsterQuietProgress): void; onUnavailable?(): void;
  now?: () => number;
  setTimeout?: (callback: () => void, milliseconds: number) => Timer;
  clearTimeout?: (timer: Timer) => void;
}): PondsterSilenceMonitor {
  const now = options.now ?? liveNow;
  const later = options.setTimeout ?? ((fn, ms) => globalThis.setTimeout(fn, ms));
  const clear = options.clearTimeout ?? (timer => globalThis.clearTimeout(timer as ReturnType<typeof setTimeout>));
  const until = { work: 0, response: 0 };
  let stopped = false, version = 0, quietSince: number | null = null, unknownSince: number | null = null, known: boolean | null = null, lastSampleAt: number | null = null;
  let lastProgress = '';
  let poll: Timer | null = null, query: Timer | null = null;
  const availability = (value: boolean) => { if (known !== value) { known = value; options.onAvailability(value); } };
  const progress = (reason: PondsterQuietProgress['reason'], remainingSeconds: number | null = null) => {
    const key = `${reason}:${remainingSeconds}`;
    if (lastProgress !== key) { lastProgress = key; options.onProgress?.({ reason, remainingSeconds }); }
  };
  function stop() {
    stopped = true; version++; quietSince = null;
    if (poll !== null) clear(poll);
    if (query !== null) clear(query);
    poll = query = null;
  }
  function schedule() {
    if (stopped) return;
    const remaining = quietSince === null ? AUDIO_POLL_MS : Math.max(1, PONDSTER_SILENCE_MS - (now() - quietSince));
    poll = later(() => { poll = null; check(); }, Math.min(AUDIO_POLL_MS, remaining));
  }
  function check() {
    if (stopped) return;
    const current = ++version;
    // getStats has no cancellation API. Disable this meter on timeout, ignore its
    // eventual result, and never overlap another query with the hung request.
    query = later(() => { if (!stopped && current === version) { stop(); availability(false); progress('unavailable'); options.onUnavailable?.(); } }, AUDIO_QUERY_MS);
    const receive = (value: PondsterAudioActivity) => {
      if (stopped || current !== version) return;
      if (query !== null) clear(query);
      query = null;
      const at = now();
      if (value.output === true) until.response = 0;
      const timely = lastSampleAt === null || at - lastSampleAt <= AUDIO_STALE_MS;
      lastSampleAt = at;
      const measured = timely && typeof value.input === 'boolean' && typeof value.output === 'boolean';
      availability(measured);
      if (!measured) {
        quietSince = null; unknownSince ??= at; progress('unavailable');
        if (at - unknownSince >= AUDIO_UNAVAILABLE_MS) { stop(); options.onUnavailable?.(); return; }
      } else {
        unknownSince = null;
        const busy = value.output ? 'output' : value.input ? 'input' : at < until.work ? 'work' : at < until.response ? 'response' : null;
        if (busy) { quietSince = null; progress(busy); }
        else {
          quietSince ??= at;
          progress('quiet', Math.max(0, Math.ceil((PONDSTER_SILENCE_MS - (at - quietSince)) / 1000)));
          if (at - quietSince >= PONDSTER_SILENCE_MS) { stop(); options.onSilence(); return; }
        }
      }
      schedule();
    };
    try { Promise.resolve(options.sample()).then(receive, () => receive({ input: null, output: null })); }
    catch { receive({ input: null, output: null }); }
  }
  check();
  return {
    stop,
    noteInteraction() { if (!stopped) { quietSince = now(); progress('quiet', 30); } },
    setBusy(kind, active, holdMs = BUSY_HOLD_MS) {
      if (stopped) return;
      if (!active && until[kind] === 0) return;
      until[kind] = active ? now() + Math.max(0, Math.min(BUSY_HOLD_MS, holdMs)) : 0;
      quietSince = null;
      if (active) progress(kind);
    },
  };
}

function validAction(value: unknown): PondsterLiveAction | null {
  if (!value || typeof value !== 'object') return null;
  const action = value as Record<string, unknown>;
  if (typeof action.menu !== 'string' || !MENUS.has(action.menu)) return null;
  if (action.room !== undefined && (typeof action.room !== 'string' || !ROOMS.has(action.room))) return null;
  if (action.scene !== undefined && (typeof action.scene !== 'string' || !SCENES.has(action.scene))) return null;
  if (action.tour !== undefined && (action.tour !== true || action.menu !== 'View')) return null;
  return { menu: action.menu as PondsterLiveAction['menu'],
    ...(action.room === undefined ? {} : { room: action.room as string }),
    ...(action.scene === undefined ? {} : { scene: action.scene as PondsterLiveAction['scene'] }),
    ...(action.tour === true ? { tour: true } : {}) };
}

/** Construction never opens a connection or asks for a microphone. Call start from a click. */
export function createPondsterLiveVoice(options: PondsterLiveVoiceOptions): PondsterLiveVoice {
  const now = options.now ?? liveNow;
  const later = options.setTimeout || ((fn, ms) => globalThis.setTimeout(fn, ms));
  const clearLater = options.clearTimeout || (timer => globalThis.clearTimeout(timer as ReturnType<typeof setTimeout>));
  const visibility = options.visibilityTarget || (typeof document === 'undefined' ? undefined : document);
  const audio = options.audioElement;
  const fetcher = options.fetcher || ((...args: Parameters<typeof fetch>) => globalThis.fetch(...args));
  const getMic = options.getUserMedia || (() => navigator.mediaDevices.getUserMedia({ audio: true, video: false }));
  const peerFactory = options.peerFactory || (() => new RTCPeerConnection());
  const controlFactory = options.controlFactory || (url => new WebSocket(url));
  const streamFactory = options.streamFactory || (tracks => new MediaStream(tracks));
  const supported = Boolean((options.getUserMedia || (typeof navigator !== 'undefined' && typeof navigator.mediaDevices?.getUserMedia === 'function'))
    && (options.peerFactory || typeof RTCPeerConnection !== 'undefined')
    && (options.controlFactory || typeof WebSocket !== 'undefined'));
  let state: PondsterLiveState = { available: supported, connecting: false, active: false,
    status: supported ? 'Start my live voice when you are ready.' : 'My live voice is unavailable in this browser. You can type to me instead.',
    heard: '', audioBlocked: false, silenceAvailable: null, quietReason: 'checking', quietSecondsRemaining: null };
  let current: Attempt | null = null, disposed = false, sequence = 0;
  const attempts = new Set<Attempt>();

  function notify(patch: Partial<PondsterLiveState>) {
    state = { ...state, ...patch };
    options.onState({ ...state });
  }
  function live(a: Attempt) { return !disposed && current === a && !a.stopped; }
  function timer(a: Attempt, fn: () => void, ms: number): Timer {
    const handle = later(() => { a.timers.delete(handle); fn(); }, ms);
    a.timers.add(handle); return handle;
  }
  function clearTimer(a: Attempt, handle: Timer | null) {
    if (handle !== null) { clearLater(handle); a.timers.delete(handle); }
  }
  function stopTracks(stream: MediaStream | null) {
    stream?.getTracks().forEach(track => { try { track.stop(); } catch { /* already ended */ } });
  }
  function silence() {
    audio.pause(); audio.srcObject = null;
  }
  function send(channel: { readyState: string | number; send(data: string): void } | null, message: object) {
    if (!channel || (channel.readyState !== 'open' && channel.readyState !== 1)) return false;
    try { channel.send(JSON.stringify(message)); return true; } catch { return false; }
  }
  function sendClose(a: Attempt) {
    if (!a.stopSent) a.stopSent = send(a.control, { type: 'pondster.stop' });
    if (!a.closeSent) a.closeSent = send(a.channel, { type: 'session.close' });
  }
  function finish(a: Attempt) {
    if (a.finalized) return;
    a.finalized = true;
    a.silenceMonitor?.stop();
    a.streamMeter?.stop();
    for (const handle of a.timers) clearLater(handle);
    a.timers.clear();
    if (a.channel) {
      a.channel.onopen = a.channel.onmessage = a.channel.onerror = a.channel.onclose = null;
      try { a.channel.close(); } catch { /* connection already released */ }
    }
    if (a.control) {
      a.control.onopen = a.control.onmessage = a.control.onerror = a.control.onclose = null;
      try { a.control.close(); } catch { /* connection already released */ }
    }
    if (a.peer) {
      a.peer.ontrack = a.peer.onconnectionstatechange = null;
      try { a.peer.close(); } catch { /* connection already released */ }
    }
    stopTracks(a.mic); attempts.delete(a);
  }
  function flush(a: Attempt, who: 'you' | 'Pondster', allowFarewell = true) {
    const caption = a.captions[who];
    clearTimer(a, caption.timer); caption.timer = null;
    const text = caption.text.trim(); caption.text = ''; caption.lastEnd = null;
    if (text && live(a)) {
      options.onTranscript({ who, text });
      if (allowFarewell && who === 'you' && isPondsterFarewell(text)) end(a, PONDSTER_FAREWELL_ACK);
    }
  }
  function end(a: Attempt, status: string, available = state.available) {
    if (a.stopped) return;
    if (live(a)) { flush(a, 'you', false); flush(a, 'Pondster', false); }
    a.stopped = true; a.cancel(); a.abort.abort();
    a.silenceMonitor?.stop(); a.streamMeter?.stop();
    for (const handle of a.timers) clearLater(handle);
    a.timers.clear(); stopTracks(a.mic);
    if (current === a) {
      current = null; silence();
      notify({ connecting: false, active: false, audioBlocked: false, quietSecondsRemaining: null, status, available });
    }
    // Capture/playback ends now; transports retain a ten-second close-handshake drain.
    // Reaching this local cleanup bound does not confirm provider finalization.
    sendClose(a);
    if (!a.peer && !a.control) finish(a);
    else timer(a, () => finish(a), 10000);
  }
  function fail(a: Attempt, status: string, unavailable = false) {
    if (live(a)) end(a, status, unavailable ? false : state.available);
  }
  async function guard<T>(a: Attempt, promise: Promise<T>): Promise<T> {
    const result = await Promise.race([promise, a.cancelled]);
    if (result === CANCELLED || !live(a)) throw CANCELLED;
    return result as T;
  }
  function caption(a: Attempt, who: 'you' | 'Pondster', event: Record<string, unknown>) {
    if (typeof event.delta !== 'string' || !event.delta) return;
    const buffer = a.captions[who];
    const start = typeof event.start_ms === 'number' ? event.start_ms : null;
    if (buffer.text && start !== null && buffer.lastEnd !== null && start - buffer.lastEnd > 900) {
      flush(a, who);
      if (!live(a)) return;
    }
    buffer.text = (buffer.text + event.delta).slice(-CAPTION_LIMIT);
    buffer.lastEnd = typeof event.end_ms === 'number' ? event.end_ms : null;
    if (who === 'you') notify({ heard: buffer.text.trim().slice(-TEXT_LIMIT) });
    clearTimer(a, buffer.timer);
    buffer.timer = timer(a, () => { buffer.timer = null; flush(a, who); }, 350);
  }
  async function play(a: Attempt) {
    if (!live(a)) return;
    try {
      audio.muted = false;
      await audio.play();
      if (live(a)) notify({ audioBlocked: false, status: a.started ? 'I’m listening. You can speak naturally.' : 'Connecting my live voice…' });
    } catch {
      if (live(a)) notify({ audioBlocked: true, status: 'Tap Play my voice to hear me. You can still type to me.' });
    }
  }
  function receive(a: Attempt, raw: unknown, control: boolean) {
    if (typeof raw !== 'string' || raw.length > 64000) return;
    let event: Record<string, unknown>;
    try { event = JSON.parse(raw); } catch { return; }
    if (!event || typeof event !== 'object') return;
    if (event.type === 'session.closed') {
      if (live(a)) end(a, 'My live voice session ended. You can start again or type to me.');
      finish(a); return;
    }
    if (a.stopped) return;
    if (!live(a)) return;
    if (control) {
      if (event.type === 'pondster.busy') {
        const kind = event.kind;
        if ((kind === 'work' || kind === 'response') && typeof event.active === 'boolean'
          && typeof event.holdMs === 'number' && Number.isFinite(event.holdMs) && event.holdMs >= 0) {
          const hold = Math.min(BUSY_HOLD_MS, event.holdMs);
          a.busyUntil[kind] = event.active ? now() + hold : 0;
          a.silenceMonitor?.setBusy(kind, event.active, hold);
        }
      } else if (event.type === 'pondster.ready') a.ready();
      else if (event.type === 'pondster.action') {
        const action = validAction(event.action); if (action) options.onAction?.(action);
      } else if (event.type === 'pondster.error') {
        // Only our same-origin service can supply this public, bounded error message.
        const message = typeof event.message === 'string' ? event.message.trim().slice(0, 240) : '';
        fail(a, message || 'My live voice is unavailable right now. You can type to me instead.', true);
      } else if (event.type === 'pondster.ended') {
        end(a, 'My live voice session ended. You can start again or type to me.'); finish(a);
      }
      return;
    }
    if (event.type === 'session.started') { a.started = true; a.ready(); }
    else if (event.type === 'session.input_transcript.delta') caption(a, 'you', event);
    else if (event.type === 'session.output_transcript.delta') caption(a, 'Pondster', event);
    else if (event.type === 'error') fail(a, 'My live voice was interrupted. You can start again or type to me.');
  }
  async function ice(a: Attempt, peer: RTCPeerConnection) {
    if (peer.iceGatheringState === 'complete') return;
    await guard(a, new Promise<void>(resolve => {
      let done = false;
      const finishIce = () => { if (done) return; done = true; peer.removeEventListener('icegatheringstatechange', changed); clearTimer(a, timeout); resolve(); };
      const changed = () => { if (peer.iceGatheringState === 'complete') finishIce(); };
      const timeout = timer(a, finishIce, 8000);
      peer.addEventListener('icegatheringstatechange', changed);
      a.cancelled.then(finishIce); changed();
    }));
  }
  async function run(a: Attempt) {
    try {
      // Admission gates capture; optional model metadata is not a voice-session health check.
      const response = await guard(a, fetcher('/api/voice/status', { method: 'GET', cache: 'no-store', credentials: 'same-origin', signal: a.abort.signal }));
      if (!response.ok) throw new Error('unavailable');
      const status = await guard(a, response.json()) as { available?: unknown; message?: unknown };
      if (status?.available !== true) {
        fail(a, typeof status?.message === 'string' && status.message.length <= 240 ? status.message : 'My live voice is not connected yet. You can type to me instead.', true); return;
      }
      if (a.streamMeter?.available && typeof a.streamMeter.whenRunning === 'function') {
        let readyTimeout: Timer | null = null;
        const playbackReady = await guard(a, Promise.race([
          a.streamMeter.whenRunning(),
          new Promise<boolean>(resolve => { readyTimeout = timer(a, () => resolve(false), 1500); }),
        ]));
        clearTimer(a, readyTimeout);
        if (!playbackReady) { fail(a, 'Please click my logo to enable voice playback in this browser.'); return; }
      }
      notify({ available: true, status: 'Allow your microphone to talk with me.' });
      // Stop can win this await; a late permission grant must not retain capture.
      const micPromise = getMic().then(stream => { if (!live(a)) stopTracks(stream); return stream; });
      a.mic = await guard(a, micPromise);
      a.streamMeter?.setInput(a.mic);
      const peer = a.peer = peerFactory();
      const channel = a.channel = peer.createDataChannel('oai-events');
      channel.onmessage = event => receive(a, event.data, false);
      channel.onopen = () => { if (a.stopped) sendClose(a); };
      channel.onclose = () => { if (live(a)) fail(a, 'My live voice connection closed. You can start again or type to me.'); else finish(a); };
      channel.onerror = () => { if (live(a)) fail(a, 'My live voice connection failed. You can type to me instead.'); };
      peer.ontrack = event => {
        if (!live(a)) { event.track.stop(); return; }
        const remote = event.streams[0] || streamFactory([event.track]);
        audio.srcObject = remote; a.streamMeter?.setOutput(remote);
        void play(a);
      };
      peer.onconnectionstatechange = () => {
        if (live(a) && ['failed', 'closed', 'disconnected'].includes(peer.connectionState)) fail(a, 'My live voice connection was interrupted. You can start again or type to me.');
      };
      for (const track of a.mic.getTracks()) peer.addTrack(track, a.mic);
      await guard(a, peer.setLocalDescription(await guard(a, peer.createOffer())));
      await ice(a, peer);
      const sdp = peer.localDescription?.sdp;
      if (!sdp) throw new Error('offer');
      const origin = options.origin || (typeof location === 'undefined' ? '' : location.origin);
      const url = new URL('/api/voice/control', origin);
      if (url.protocol !== 'https:' && url.protocol !== 'http:') throw new Error('origin');
      url.protocol = url.protocol === 'https:' ? 'wss:' : 'ws:';
      const socket = a.control = controlFactory(url.toString());
      const requestId = options.requestIdFactory?.() || globalThis.crypto.randomUUID();
      const serverReady = new Promise<Record<string, unknown>>((resolve, reject) => {
        const timeout = timer(a, () => reject(new Error('timeout')), 20000);
        socket.onopen = () => {
          if (!live(a)) { sendClose(a); return; }
          if (!send(socket, { type: 'pondster.start', requestId, sdp })) reject(new Error('control'));
        };
        socket.onmessage = event => {
          if (typeof event.data === 'string' && event.data.length <= 64000) {
            try {
              const message = JSON.parse(event.data);
              if (message?.type === 'pondster.ready' && live(a)) { clearTimer(a, timeout); resolve(message); }
            } catch { /* ignore malformed messages */ }
          }
          receive(a, event.data, true);
        };
        socket.onclose = () => {
          reject(new Error('control'));
          if (live(a)) fail(a, 'My live voice connection closed. You can start again or type to me.');
          else finish(a);
        };
        socket.onerror = () => { reject(new Error('control')); if (live(a)) fail(a, 'My live voice connection failed. You can type to me instead.'); };
      });
      const ready = await guard(a, serverReady);
      const transport = ready.transport as { type?: unknown; sdp?: unknown } | undefined;
      const session = ready.session as { id?: unknown } | undefined;
      if (!session || typeof session.id !== 'string' || !session.id || transport?.type !== 'webrtc' || typeof transport.sdp !== 'string' || !transport.sdp) throw new Error('answer');
      const started = new Promise<void>((resolve, reject) => {
        const timeout = timer(a, () => reject(new Error('timeout')), 15000);
        a.ready = () => { if (a.started) { clearTimer(a, timeout); resolve(); } };
        a.ready();
      });
      // Observe cancellation immediately, even if applying the answer itself fails.
      const startedWait = guard(a, started);
      void startedWait.catch(() => {});
      await guard(a, peer.setRemoteDescription({ type: 'answer', sdp: transport.sdp }));
      await startedWait;
      if (!live(a)) return;
      a.silenceMonitor = createPondsterSilenceMonitor({
        sample: options.activitySamplerFactory?.(peer) ?? (a.streamMeter?.available
          ? async () => a.streamMeter!.sample() : createPondsterAudioSampler(peer, now)),
        now, setTimeout: later, clearTimeout: clearLater,
        onAvailability: value => { if (live(a)) notify({ silenceAvailable: value }); },
        onProgress: value => { if (live(a)) notify({ quietReason: value.reason, quietSecondsRemaining: value.remainingSeconds }); },
        onUnavailable: () => { if (live(a)) end(a, 'I can’t monitor silence in this connection, so I’ve stopped my microphone and voice. You can try again or type to me.'); },
        onSilence: () => { if (live(a)) end(a, 'I’ve ended our conversation after thirty seconds of silence. You can start again or type to me.'); },
      });
      for (const kind of ['work', 'response'] as const) {
        if (a.busyUntil[kind] > now()) a.silenceMonitor.setBusy(kind, true, a.busyUntil[kind] - now());
      }
      if (!a.startedSent) {
        if (!send(a.control, { type: 'pondster.started' })) throw new Error('control');
        a.startedSent = true;
      }
      notify({ connecting: false, active: true,
        status: state.audioBlocked ? 'Tap Play my voice to hear me. You can still type to me.' : 'I’m listening. You can speak naturally.' });
    } catch (error) {
      if (error === CANCELLED || !live(a)) return;
      const denied = error instanceof Error && (error.name === 'NotAllowedError' || error.name === 'PermissionDeniedError');
      const message = denied ? 'Microphone access was not allowed. You can change your browser permission or type to me.'
        : 'My live voice could not connect. Please try again, or type to me.';
      fail(a, message);
      throw new Error(message);
    }
  }
  function start(): Promise<void> {
    if (disposed) return Promise.reject(new Error('My live voice has been closed.'));
    if (current) return current.startPromise;
    if (!supported) { notify({ available: false }); return Promise.reject(new Error(state.status)); }
    if (visibility?.hidden) return Promise.reject(new Error('Open this tab before starting my live voice.'));
    let cancel!: () => void;
    const cancelled = new Promise<symbol>(resolve => { cancel = () => resolve(CANCELLED); });
    const a: Attempt = { id: ++sequence, stopped: false, started: false, finalized: false,
      mic: null, peer: null, channel: null, control: null, abort: new AbortController(), timers: new Set(),
      cancelled, cancel, startPromise: Promise.resolve(), ready: () => {},
      captions: { you: { text: '', lastEnd: null, timer: null }, Pondster: { text: '', lastEnd: null, timer: null } },
      closeSent: false, stopSent: false, startedSent: false, silenceMonitor: null,
      streamMeter: options.activitySamplerFactory ? null : (options.streamMeterFactory ?? createPondsterStreamMeter)(),
      busyUntil: { work: 0, response: 0 } };
    current = a; attempts.add(a);
    notify({ connecting: true, active: false, heard: '', audioBlocked: false, silenceAvailable: null, quietReason: 'checking', quietSecondsRemaining: null, status: 'Connecting my live voice…' });
    a.startPromise = run(a); return a.startPromise;
  }
  function stop() { if (current) end(current, 'My microphone and live voice are off. You can type to me.'); }
  function hidden() { if (visibility?.hidden) stop(); }
  visibility?.addEventListener('visibilitychange', hidden);
  options.onState({ ...state });
  return {
    start, stop,
    dispose() {
      if (disposed) return;
      stop(); disposed = true;
      visibility?.removeEventListener('visibilitychange', hidden);
      // Stopped attempts retain only their bounded close handshake, never capture or playback.
    },
    sendText(text) {
      const value = text.trim().slice(0, TEXT_LIMIT), a = current;
      if (!value || !a || !live(a) || !a.started) return;
      if (send(a.control, { type: 'pondster.text', text: value })) {
        a.silenceMonitor?.noteInteraction();
        notify({ heard: value }); options.onTranscript({ who: 'you', text: value });
      } else fail(a, 'My live voice connection closed. You can type to me instead.');
    },
    noteInteraction() { const a = current; if (a && live(a) && a.started) a.silenceMonitor?.noteInteraction(); },
    async resumeAudio() { const a = current; if (a && live(a)) await play(a); }
  };
}
