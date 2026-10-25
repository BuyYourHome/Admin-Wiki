/** Browser speech lifecycle, kept independent of React so failure paths can be tested without audio. */
export function createPondsterVoice({ recognitionFactory, synthesis, createUtterance, onState, onQuestion, isWakeRequest, setTimer = setTimeout, clearTimer = clearTimeout, isHidden = () => false }) {
  let disposed = false, engine = null, mode = 'question', generation = 0, speechGeneration = 0;
  let starting = false, active = false, busy = false, utterance = null, idleFailures = 0;
  let startTimer, restartTimer, speechTimer;
  const state = { available: false, speechAvailable: !!(synthesis && createUtterance), session: false, listening: false, speaking: false, outputActive: false, status: 'I’m not listening. You can type me a question.', heard: '' };
  const update = patch => { if (!disposed) { Object.assign(state, patch); onState({ ...state }); } };
  const clear = timer => { if (timer !== undefined) clearTimer(timer); };
  const detach = () => {
    if (engine) { engine.onstart = engine.onend = engine.onerror = engine.onresult = null; try { engine.abort(); } catch {} }
    engine = null; active = starting = false;
    clear(startTimer); clear(restartTimer);
  };
  const cancelSpeech = () => {
    speechGeneration++; clear(speechTimer); utterance = null; busy = false;
    try { synthesis?.cancel(); } catch {}
    update({ speaking: false, outputActive: false });
  };
  const stop = (message = 'I’m not listening. You can type me a question.') => {
    generation++; state.session = false; detach(); cancelSpeech();
    update({ session: false, listening: false, status: message });
  };
  const fail = message => stop(message);
  function start() {
    if (disposed || !state.session || starting || active || busy || isHidden()) return;
    detach();
    const version = ++generation;
    const valid = () => !disposed && version === generation && state.session;
    try {
      engine = recognitionFactory();
      const current = engine;
      let heardThisAttempt = false;
      current.continuous = mode === 'wake'; current.interimResults = false; current.lang = 'en-US';
      current.onstart = () => {
        if (!valid() || busy) return;
        clear(startTimer); starting = false; active = true;
        update({ listening: true, status: mode === 'wake' ? 'I’m listening. Say “Pondster” with your question.' : 'I’m listening. Ask me one question; you don’t need to say my name.' });
      };
      current.onresult = event => {
        if (!valid() || busy) return;
        for (let index = event.resultIndex; index < event.results.length; index++) {
          const result = event.results[index];
          if (!result.isFinal) continue;
          const text = result[0].transcript.trim().slice(0, 500);
          if (!text) continue;
          heardThisAttempt = true; idleFailures = 0;
          update({ heard: text });
          if (mode === 'wake' && !isWakeRequest(text)) {
            update({ status: 'I heard you. Say “Pondster” with your question, or turn off “Keep listening” and ask me directly.' });
            continue;
          }
          if (mode === 'question') { generation++; state.session = false; detach(); update({ session: false, listening: false, status: 'I heard your question.' }); }
          onQuestion(text);
          break;
        }
      };
      current.onerror = event => {
        if (!valid() || busy) return;
        if (event.error === 'aborted') return;
        if (event.error === 'no-speech' && mode === 'wake') return; // onend reconnects, with a bounded idle limit.
        const errors = {
          'not-allowed': 'I don’t have microphone permission. Allow microphone access in your browser’s site settings, then try me again.',
          'service-not-allowed': 'Your browser has blocked my speech-recognition service. Try opening pondstr.com in Chrome or Edge, or type me a question.',
          'audio-capture': 'I can’t find an available microphone. Check your microphone and browser settings, then try me again.',
          'network': 'I can’t reach your browser’s speech service. Check your connection or try me in Chrome or Edge.',
          'no-speech': 'I didn’t hear a question. Try Ask by voice again, or type me a question.'
        };
        fail(errors[event.error] || 'Your browser couldn’t recognize your question. Try me again, or type me a question.');
      };
      current.onend = () => {
        if (!valid()) return;
        clear(startTimer); starting = active = false; update({ listening: false });
        if (busy) return;
        if (mode === 'question') { fail('I didn’t catch a question. Try Ask by voice again, or type me a question.'); return; }
        if (!heardThisAttempt && ++idleFailures >= 3) { fail('I haven’t heard a question for a while, so I’ve stopped my microphone. Tap Ask by voice when you’re ready.'); return; }
        update({ status: 'I’m reconnecting to your browser’s speech service…' });
        clear(restartTimer); restartTimer = setTimer(start, 350);
      };
      starting = true;
      update({ listening: false, status: 'I’m starting to listen. Allow microphone access if your browser asks.' });
      startTimer = setTimer(() => { if (valid() && starting) fail('Your browser hasn’t started my microphone. Check its permission prompt, or open pondstr.com in Chrome or Edge and try me again.'); }, 10000);
      current.start();
    } catch {
      fail('I couldn’t start your browser’s speech service. Try me in Chrome or Edge, or type me a question.');
    }
  }
  function speak(text) {
    if (disposed) return;
    if (!state.speechAvailable) { update({ status: 'I can’t speak in this browser. You can read my reply below.' }); return; }
    cancelSpeech();
    busy = true; generation++; detach(); update({ listening: false, speaking: false, outputActive: true, status: 'I’m preparing my spoken reply…' });
    const version = ++speechGeneration;
    const valid = () => !disposed && version === speechGeneration;
    const finish = message => {
      if (!valid()) return;
      speechGeneration++; clear(speechTimer); utterance = null; busy = false;
      update({ speaking: false, outputActive: false, status: message || 'I’ve finished speaking.' });
      if (state.session) start();
    };
    const timeout = () => {
      if (!valid()) return;
      // A failed output must not restart another listen/speak loop.
      stop('Your browser didn’t play my spoken reply. Check your sound, or try Read aloud in Chrome or Edge. You can still read my reply.');
    };
    try {
      utterance = createUtterance(text); utterance.lang = 'en-US'; utterance.rate = .98;
      const voices = synthesis.getVoices?.() || [];
      utterance.voice = voices.find(voice => voice.lang === 'en-US' && voice.localService) || voices.find(voice => /^en\b/i.test(voice.lang)) || null;
      utterance.onstart = () => {
        if (!valid()) return;
        clear(speechTimer); update({ speaking: true, status: 'I’m speaking.' });
        speechTimer = setTimer(timeout, Math.min(120000, Math.max(15000, text.length * 100)));
      };
      utterance.onend = () => finish();
      utterance.onerror = () => { if (valid()) stop('Your browser couldn’t play my spoken reply. Check your sound and try Read aloud again.'); };
      speechTimer = setTimer(timeout, 8000);
      synthesis.resume?.(); synthesis.speak(utterance);
    } catch { if (valid()) stop('I couldn’t start my spoken reply. Try Read aloud again, or read my reply below.'); }
  }
  // Construction may be exposed but unavailable in an embedded browser.
  if (recognitionFactory) {
    try { const probe = recognitionFactory(); probe.abort(); state.available = true; } catch {}
  }
  try { synthesis?.getVoices?.(); } catch {}
  update({});
  return {
    listen(nextMode = 'question') {
      if (disposed) return;
      stop();
      if (!state.available) { update({ status: 'I can’t listen in this browser. Open pondstr.com in Chrome or Edge to try voice, or type me a question here.' }); return; }
      mode = nextMode; idleFailures = 0; update({ session: true, heard: '' }); start();
    },
    stop, speak,
    cancelSpeech() { cancelSpeech(); update({ status: 'I’ve stopped speaking.' }); if (state.session) start(); },
    hide() { if (state.session || busy) stop('I stopped voice while you were away from this tab. Tap Ask by voice to start again.'); },
    destroy() { if (!disposed) { stop(); disposed = true; } }
  };
}
