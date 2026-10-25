/** Browser-only transport for Pondster's bounded, server-controlled Live voice. */
export type PondsterLiveState = {
  available: boolean; connecting: boolean; active: boolean;
  status: string; heard: string; audioBlocked: boolean;
};
export type PondsterLiveTranscript = { who: 'you' | 'Pondster'; text: string };
export type PondsterLiveAction = {
  menu: 'Design' | 'Explore' | 'View' | 'Own' | 'Built By';
  room?: string; scene?: 'day' | 'evening' | 'relax';
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
  origin?: string;
  visibilityTarget?: Visibility;
  setTimeout?: (callback: () => void, milliseconds: number) => Timer;
  clearTimeout?: (timer: Timer) => void;
};
export type PondsterLiveVoice = {
  start(): Promise<void>; stop(): void; dispose(): void;
  sendText(text: string): void; resumeAudio(): Promise<void>;
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
  closeSent: boolean; stopSent: boolean;
};
const CANCELLED = Symbol('cancelled');
const ROOMS = new Set(['kitchen', 'media-center', 'front-elevation', 'garage-barn-door', 'adu', 'master-bath', 'spiral-staircase', 'back-deck']);
const MENUS = new Set(['Design', 'Explore', 'View', 'Own', 'Built By']);
const SCENES = new Set(['day', 'evening', 'relax']);
const TEXT_LIMIT = 500, CAPTION_LIMIT = 1800;

function validAction(value: unknown): PondsterLiveAction | null {
  if (!value || typeof value !== 'object') return null;
  const action = value as Record<string, unknown>;
  if (typeof action.menu !== 'string' || !MENUS.has(action.menu)) return null;
  if (action.room !== undefined && (typeof action.room !== 'string' || !ROOMS.has(action.room))) return null;
  if (action.scene !== undefined && (typeof action.scene !== 'string' || !SCENES.has(action.scene))) return null;
  return { menu: action.menu as PondsterLiveAction['menu'],
    ...(action.room === undefined ? {} : { room: action.room as string }),
    ...(action.scene === undefined ? {} : { scene: action.scene as PondsterLiveAction['scene'] }) };
}

/** Construction never opens a connection or asks for a microphone. Call start from a click. */
export function createPondsterLiveVoice(options: PondsterLiveVoiceOptions): PondsterLiveVoice {
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
    heard: '', audioBlocked: false };
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
  function flush(a: Attempt, who: 'you' | 'Pondster') {
    const caption = a.captions[who];
    clearTimer(a, caption.timer); caption.timer = null;
    const text = caption.text.trim(); caption.text = ''; caption.lastEnd = null;
    if (text && live(a)) options.onTranscript({ who, text });
  }
  function end(a: Attempt, status: string, available = state.available) {
    if (a.stopped) return;
    if (live(a)) { flush(a, 'you'); flush(a, 'Pondster'); }
    a.stopped = true; a.cancel(); a.abort.abort();
    for (const handle of a.timers) clearLater(handle);
    a.timers.clear(); stopTracks(a.mic);
    if (current === a) {
      current = null; silence();
      notify({ connecting: false, active: false, audioBlocked: false, status, available });
    }
    // Capture/playback ends now; only control events drain, with a hard two-second bound.
    sendClose(a);
    if (!a.peer && !a.control) finish(a);
    else timer(a, () => finish(a), 2000);
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
    if (buffer.text && start !== null && buffer.lastEnd !== null && start - buffer.lastEnd > 900) flush(a, who);
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
      if (event.type === 'pondster.ready') a.ready();
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
      const response = await guard(a, fetcher('/api/voice/status', { method: 'GET', cache: 'no-store', credentials: 'same-origin', signal: a.abort.signal }));
      if (!response.ok) throw new Error('unavailable');
      const status = await guard(a, response.json()) as { available?: unknown };
      if (status?.available !== true) {
        fail(a, 'My live voice is not connected yet. You can type to me instead.', true); return;
      }
      notify({ available: true, status: 'Allow your microphone to talk with me.' });
      // Stop can win this await; a late permission grant must not retain capture.
      const micPromise = getMic().then(stream => { if (!live(a)) stopTracks(stream); return stream; });
      a.mic = await guard(a, micPromise);
      const peer = a.peer = peerFactory();
      const channel = a.channel = peer.createDataChannel('oai-events');
      channel.onmessage = event => receive(a, event.data, false);
      channel.onopen = () => { if (a.stopped) sendClose(a); };
      channel.onclose = () => { if (live(a)) fail(a, 'My live voice connection closed. You can start again or type to me.'); else finish(a); };
      channel.onerror = () => { if (live(a)) fail(a, 'My live voice connection failed. You can type to me instead.'); };
      peer.ontrack = event => {
        if (!live(a)) { event.track.stop(); return; }
        audio.srcObject = event.streams[0] || streamFactory([event.track]);
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
      const duration = typeof ready.maxDurationSeconds === 'number' && Number.isFinite(ready.maxDurationSeconds)
        ? Math.max(1, Math.min(180, ready.maxDurationSeconds)) : 180;
      timer(a, () => end(a, 'My three-minute live voice session has ended. You can start again or type to me.'), duration * 1000);
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
      closeSent: false, stopSent: false };
    current = a; attempts.add(a);
    notify({ connecting: true, active: false, heard: '', audioBlocked: false, status: 'Connecting my live voice…' });
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
        notify({ heard: value }); options.onTranscript({ who: 'you', text: value });
      } else fail(a, 'My live voice connection closed. You can type to me instead.');
    },
    async resumeAudio() { const a = current; if (a && live(a)) await play(a); }
  };
}
