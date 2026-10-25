'use client';

import { useEffect, useRef, useState } from 'react';
import { galleries } from '../lib/designs';
import { buildTourScenes, type TourScene } from '../lib/virtual-tour';
import { createTourSoundtrack } from '../lib/tour-soundtrack';

type RoomResults = Record<string, { scores: Record<string, number>; total: number } | null>;
const availableRooms = galleries.filter(room => room.designs.length > 0);
const filmCount = buildTourScenes(galleries, {}).filter(scene => scene.kind === 'motion').length;
const cover = galleries.find(room => room.id === 'front-elevation')!.designs[0];

function selectionLabel(scene: TourScene) {
  if (scene.kind === 'motion') return 'MY MOTION STUDY · FINISHES MAY DIFFER';
  if (scene.status === 'unavailable') return 'MY FEATURED PREVIEW · VOTES UNAVAILABLE';
  if (scene.status === 'no-votes') return 'MY FEATURED PREVIEW · VOTING IS OPEN';
  return `${scene.status === 'tied' ? 'MY JOINT LEADING DESIGN' : 'MY LEADING DESIGN'} · ${scene.votes} ${scene.votes === 1 ? 'VOTE' : 'VOTES'}`;
}

export default function VirtualTour({ onStart }: { onStart?: () => void }) {
  const [open, setOpen] = useState(false);
  const [loading, setLoading] = useState(false);
  const [scenes, setScenes] = useState<TourScene[]>([]);
  const [index, setIndex] = useState(0);
  const [playing, setPlaying] = useState(false);
  const [music, setMusic] = useState(true);
  const [complete, setComplete] = useState(false);
  const [ready, setReady] = useState(false);
  const [videoFailed, setVideoFailed] = useState(false);
  const [elapsed, setElapsed] = useState(0);
  const [notice, setNotice] = useState('');
  const [loadNote, setLoadNote] = useState('');
  const [nativeFullscreen, setNativeFullscreen] = useState(false);
  const dialog = useRef<HTMLDialogElement>(null);
  const closeButton = useRef<HTMLButtonElement>(null);
  const video = useRef<HTMLVideoElement>(null);
  const soundtrack = useRef<ReturnType<typeof createTourSoundtrack> | null>(null);
  const request = useRef<AbortController | null>(null);
  const returnFocus = useRef<HTMLButtonElement>(null);
  const generation = useRef(0);
  const position = useRef(0);
  const clock = useRef(0);
  const currentId = useRef('');
  const playback = useRef({ open: false, playing: false, serial: 0 });
  const wasNativeFullscreen = useRef(false);
  const keepOpenAfterFullscreenExit = useRef(false);
  const fullscreenTarget = useRef<HTMLElement | null>(null);
  const fullscreenRequestId = useRef(0);
  const scene = scenes[index];
  currentId.current = scene?.id ?? '';
  const isVideo = !!scene?.video && !videoFailed;
  const duration = isVideo ? scene.durationSeconds : 8;
  const progress = complete ? 100 : Math.min(100, elapsed / duration * 100);

  function changePlaying(value: boolean) {
    playback.current.serial += 1;
    playback.current.playing = value;
    setPlaying(value);
  }

  function currentMedia(id: string, element: HTMLMediaElement | HTMLImageElement) {
    return playback.current.open && currentId.current === id && element.isConnected;
  }

  function silence() { void soundtrack.current?.pause(); video.current?.pause(); }

  function restoreFocus() { returnFocus.current?.focus({ preventScroll: true }); }

  function close() {
    generation.current += 1;
    request.current?.abort();
    playback.current.open = false;
    changePlaying(false);
    setOpen(false);
    fullscreenRequestId.current += 1;
    wasNativeFullscreen.current = false;
    keepOpenAfterFullscreenExit.current = false;
    setNativeFullscreen(false);
    silence();
    const element = dialog.current;
    if (element?.open) element.close();
    restoreFocus();
    const target = fullscreenTarget.current;
    if (target && document.fullscreenElement === target) {
      keepOpenAfterFullscreenExit.current = true;
      void document.exitFullscreen().catch(() => { keepOpenAfterFullscreenExit.current = false; }).finally(restoreFocus);
    } else fullscreenTarget.current = null;
  }

  function enterFullscreen(turn: number, explainFallback = false) {
    // A modal dialog cannot be the Fullscreen API target. Keep the dialog in
    // the top layer and fullscreen the document underneath it instead.
    const element = document.documentElement;
    const fallback = () => {
      if (explainFallback && generation.current === turn && playback.current.open) setNotice('I’m showing my tour across this viewing window.');
    };
    if (document.fullscreenElement) {
      if (document.fullscreenElement === fullscreenTarget.current) {
        wasNativeFullscreen.current = true;
        setNativeFullscreen(true);
      } else fallback();
      return;
    }
    if (!element.requestFullscreen) { fallback(); return; }
    const attempt = ++fullscreenRequestId.current;
    fullscreenTarget.current = element;
    try {
      // Keep this call in the Start/Full screen gesture, before vote loading.
      void element.requestFullscreen().then(() => {
        if ((!playback.current.open || fullscreenTarget.current !== element) && document.fullscreenElement === element) void document.exitFullscreen().catch(() => {});
      }).catch(() => {
        if (fullscreenRequestId.current === attempt && document.fullscreenElement !== element) fullscreenTarget.current = null;
        fallback();
      });
    } catch {
      if (fullscreenRequestId.current === attempt) fullscreenTarget.current = null;
      fallback();
    }
  }

  function musicError() {
    setMusic(false);
    setNotice('I couldn’t start my music in this browser. You can still enjoy my tour.');
  }

  async function start() {
    const turn = ++generation.current;
    request.current?.abort();
    const controller = new AbortController();
    request.current = controller;
    onStart?.();
    playback.current.open = true;
    setOpen(true); setLoading(true); setScenes([]); setIndex(0); setElapsed(0);
    setComplete(false); setReady(false); setVideoFailed(false); setNotice(''); setLoadNote(''); changePlaying(true);
    position.current = 0;
    const element = dialog.current;
    if (element && !element.open) element.showModal();
    closeButton.current?.focus({ preventScroll: true });
    if (music) {
      try {
        soundtrack.current ??= createTourSoundtrack();
        void soundtrack.current.start().catch(() => { if (generation.current === turn) musicError(); });
      } catch { musicError(); }
    }
    enterFullscreen(turn);
    const timeout = window.setTimeout(() => controller.abort(), 8000);
    try {
      const results: RoomResults = {};
      await Promise.all(availableRooms.map(async room => {
        try {
          const response = await fetch(`/api/votes?room=${encodeURIComponent(room.id)}`, { cache: 'no-store', signal: controller.signal });
          if (!response.ok) throw new Error('Unavailable votes');
          results[room.id] = await response.json();
        } catch { results[room.id] = null; }
      }));
      if (generation.current !== turn) return;
      const next = buildTourScenes(galleries, results);
      setScenes(next); setLoading(false);
      const failed = Object.values(results).some(value => value === null);
      if (failed) setLoadNote('I couldn’t check every vote total. Any affected still is labeled as a featured preview.');
      if (!next.length) { changePlaying(false); setNotice('I’m still gathering my tour images. Please visit my Design galleries.'); }
    } finally { window.clearTimeout(timeout); }
  }

  function go(next: number) {
    if (!scenes.length) return;
    if (next === index && !complete) return;
    playback.current.serial += 1;
    if (next >= scenes.length) { setComplete(true); changePlaying(false); video.current?.pause(); position.current = duration; setElapsed(duration); return; }
    currentId.current = scenes[Math.max(0, next)].id;
    video.current?.pause();
    setIndex(Math.max(0, next)); setComplete(false); setReady(false); setVideoFailed(false); setNotice('');
    position.current = 0; setElapsed(0);
  }

  function togglePlay() {
    const nextPlaying = complete || !playback.current.playing;
    if (complete) go(0);
    changePlaying(nextPlaying);
    if (nextPlaying && music) {
      try { soundtrack.current ??= createTourSoundtrack(); void soundtrack.current.start().catch(musicError); }
      catch { musicError(); }
    }
  }

  function toggleMusic() {
    const next = !music; setMusic(next);
    if (!next) void soundtrack.current?.pause();
    else if (playing) {
      try { soundtrack.current ??= createTourSoundtrack(); void soundtrack.current.start().catch(musicError); }
      catch { musicError(); }
    }
  }

  useEffect(() => {
    const element = dialog.current;
    if (open && element && !element.open) element.showModal();
    if (!open && element?.open) { element.close(); restoreFocus(); }
    if (!open) return;
    const previous = document.body.style.overflow;
    document.body.style.overflow = 'hidden';
    return () => { document.body.style.overflow = previous; };
  }, [open]);

  useEffect(() => {
    const fullscreenChanged = () => {
      const active = !!fullscreenTarget.current && document.fullscreenElement === fullscreenTarget.current;
      const wasActive = wasNativeFullscreen.current;
      wasNativeFullscreen.current = active;
      setNativeFullscreen(active);
      if (!active) {
        const keepOpen = keepOpenAfterFullscreenExit.current;
        keepOpenAfterFullscreenExit.current = false;
        if (wasActive) {
          fullscreenTarget.current = null;
          if (playback.current.open && !keepOpen) close();
        }
      }
    };
    document.addEventListener('fullscreenchange', fullscreenChanged);
    return () => { document.removeEventListener('fullscreenchange', fullscreenChanged); };
  }, []);

  useEffect(() => {
    if (open && playing && music) {
      // The initial Start or Music click unlocks audio before asynchronous vote loading.
      void soundtrack.current?.resume().catch(musicError);
    } else void soundtrack.current?.pause();
  }, [open, playing, music]);

  useEffect(() => {
    if (!open || !scene || !isVideo) return;
    const element = video.current;
    if (!element) return;
    if (element.readyState >= 2) setReady(true);
    const serial = playback.current.serial;
    if (playing) void element.play().catch(error => {
      if (currentId.current !== scene.id || video.current !== element || !playback.current.open || !playback.current.playing || playback.current.serial !== serial || error?.name === 'AbortError') return;
      changePlaying(false);
      setNotice('Press Play to continue my tour. Your browser paused automatic video playback.');
    });
    else element.pause();
  }, [open, scene?.id, playing, isVideo]);

  useEffect(() => {
    if (!open || !scene || ready || !playing) return;
    const id = scene.id;
    const timeout = window.setTimeout(() => {
      if (currentId.current !== id) return;
      if (isVideo) { setVideoFailed(true); setReady(false); setNotice('My film couldn’t load, so I’m showing my selected design instead.'); }
      else { setReady(true); setNotice('My image couldn’t load. You can skip ahead or let my tour continue.'); }
    }, 10000);
    return () => window.clearTimeout(timeout);
  }, [open, scene?.id, ready, isVideo, playing]);

  useEffect(() => {
    if (!open || !playing || !scene || !ready || complete) return;
    clock.current = performance.now();
    const timer = window.setInterval(() => {
      const now = performance.now();
      if (isVideo) {
        const element = video.current;
        if (element && !element.paused) {
          setElapsed(element.currentTime);
          // A stalled network cannot trap the tour indefinitely.
          if (now - clock.current > (scene.durationSeconds + 15) * 1000) {
            setVideoFailed(true); setReady(false); position.current = 0; setElapsed(0);
            setNotice('My film stopped loading, so I’m continuing with my selected design.');
          }
        }
      } else {
        position.current += (now - clock.current) / 1000;
        clock.current = now; setElapsed(position.current);
        if (position.current >= 8) go(index + 1);
      }
    }, 150);
    return () => window.clearInterval(timer);
  }, [open, playing, scene?.id, ready, complete, isVideo, index]);

  useEffect(() => {
    const element = dialog.current;
    const hidden = () => {
      if (document.hidden) { changePlaying(false); silence(); }
    };
    document.addEventListener('visibilitychange', hidden);
    return () => {
      document.removeEventListener('visibilitychange', hidden);
      playback.current.open = false; playback.current.serial += 1; generation.current += 1;
      request.current?.abort(); void soundtrack.current?.dispose();
      if (element?.open) element.close();
      if (fullscreenTarget.current && document.fullscreenElement === fullscreenTarget.current) void document.exitFullscreen().catch(() => {});
      restoreFocus();
    };
  }, []);

  async function fullScreen() {
    if (fullscreenTarget.current && document.fullscreenElement === fullscreenTarget.current) {
      keepOpenAfterFullscreenExit.current = true;
      try { await document.exitFullscreen(); }
      catch { keepOpenAfterFullscreenExit.current = false; }
    } else enterFullscreen(generation.current, true);
  }

  return <>
    <section className="virtual-tour-invitation" aria-labelledby="tour-invite-heading">
      <div className="tour-cover">
        <img src={`/concepts/${cover.image}`} alt="My exterior design concept at dusk" loading="lazy" decoding="async"/>
        <div className="tour-cover-copy"><p className="eyebrow">MY VIRTUAL DESIGN TOUR</p><h2 id="tour-invite-heading">Let me show<br/><em>you around.</em></h2><p>I show one view per room: my film when I have one, otherwise my leading design, with a little music.</p><button ref={returnFocus} className="tour-start" onClick={start}><span aria-hidden="true">▶</span> Take my virtual tour <span aria-hidden="true">↗</span></button></div>
        <span className="tour-cover-tag">MY CONCEPTS · YOUR FAVORITES</span>
      </div>
      <div className="tour-invitation-footer"><div><p className="eyebrow">ONE VIEW OF EACH ROOM</p><p>I show my film when a gallery has one. Otherwise, I check the latest votes when you start and show that room’s leading design.</p></div><div><span>{availableRooms.length} spaces · {filmCount} films · automatic scenes</span><p>I’m an AI design tour, not a recording of completed work. My other rooms will join as their images arrive. If still designs tie, I show the first one listed; without votes, I show a featured preview. My films keep their original finishes.</p><label className="tour-music-choice"><input type="checkbox" checked={music} onChange={event => setMusic(event.target.checked)}/> Include my gentle instrumental soundtrack</label></div></div>
    </section>
    <dialog ref={dialog} className="virtual-tour-dialog" aria-labelledby="virtual-tour-heading" onCancel={event => { event.preventDefault(); close(); }} onClose={() => { if (playback.current.open) close(); }}>
      <div className="tour-toolbar"><div><p className="eyebrow">PONDSTER / MY VIRTUAL DESIGN TOUR</p><h2 id="virtual-tour-heading">{complete ? 'Thanks for looking around.' : loading ? 'I’m gathering my views…' : scene?.roomName ?? 'Come explore with me.'}</h2></div>{scene && !loading && <span className="tour-scene-count">{index + 1}<small> / {scenes.length} ROOMS</small></span>}<button ref={closeButton} className="tour-close" onClick={close} aria-label="Close my virtual tour">Close <span aria-hidden="true">×</span></button></div>
      {loading ? <div className="tour-loading" role="status"><span aria-hidden="true">P</span><p>I’m checking my latest votes and lining up my scenes.</p></div> : scene ? <>
        <div className={`tour-stage ${ready ? 'is-ready' : ''}`} aria-label={`${scene.roomName}: ${scene.title}`}>
          {isVideo ? <video key={scene.id} ref={video} muted playsInline preload="auto" poster={scene.poster ?? scene.image} aria-label={scene.description} onLoadedData={event => { if (currentMedia(scene.id, event.currentTarget)) setReady(true); }} onCanPlay={event => { if (currentMedia(scene.id, event.currentTarget)) setReady(true); }} onEnded={event => { if (currentMedia(scene.id, event.currentTarget) && event.currentTarget === video.current) go(index + 1); }} onError={event => { if (!currentMedia(scene.id, event.currentTarget)) return; setVideoFailed(true); setReady(false); setNotice('My film couldn’t play, so I’m showing my selected design instead.'); }} onPause={event => { const target = event.currentTarget; if (currentMedia(scene.id, target) && target === video.current && target.paused && !target.ended && target.currentTime > 0 && playback.current.playing) changePlaying(false); }} onPlay={event => { const target = event.currentTarget; if (currentMedia(scene.id, target) && target === video.current && !target.paused && !document.hidden && !playback.current.playing) changePlaying(true); }}><source src={scene.video} type="video/mp4"/></video> : <img key={`${scene.id}-still`} src={scene.image} alt={`${scene.roomName} — ${scene.designTitle}, my AI design concept`} onLoad={event => { if (currentMedia(scene.id, event.currentTarget)) setReady(true); }} onError={event => { if (!currentMedia(scene.id, event.currentTarget)) return; setReady(true); setNotice('My image couldn’t load. You can skip ahead or let my tour continue.'); }}/>}
          {complete && <div className="tour-finished"><p className="eyebrow">MY NEXT CHAPTER IS TAKING SHAPE.</p><h3>Thanks for visiting <em>me.</em></h3><p>Your votes help shape my possibilities.</p><button onClick={() => { go(0); changePlaying(true); }}>Watch my tour again ↻</button></div>}
        </div>
        <div className="tour-player-dock">
          <details className="tour-details"><summary><span aria-live="polite"><small>{selectionLabel(scene)}</small><strong>{scene.title}</strong></span><span>About my room <b aria-hidden="true">⌃</b></span></summary><div className="tour-details-content">
            <p className="tour-scene-description">{scene.description}</p>
            {scene.sourceCredit && <p className="tour-source-credit">{scene.sourceCredit} <a href={scene.sourceUrl} target="_blank" rel="noopener noreferrer">Original footage ↗</a> {scene.sourceNotice} <a href={scene.sourceNoticeUrl} target="_blank" rel="noopener noreferrer">Source use notice ↗</a></p>}
            <div className="tour-scenes" aria-label="Choose a room in my tour">{scenes.map((item, number) => <button key={item.id} aria-current={number === index ? 'step' : undefined} onClick={() => go(number)} aria-label={`Room ${number + 1}: ${item.roomName}, ${item.kind === 'motion' ? 'motion study' : item.designTitle}`}><span>{String(number + 1).padStart(2, '0')}</span>{item.roomName}{item.kind === 'motion' && <small>FILM</small>}</button>)}</div>
            <p className="tour-player-note">I show one view per room: my film when available, otherwise my leading design. My films keep their original finishes. I’m sharing AI studies, not a measured walkthrough or completed spaces. I pause when you leave this tab.</p>
          </div></details>
          <p className="tour-notice" role="status">{notice || loadNote}</p>
          <div className="tour-progress" role="progressbar" aria-label="Room progress" aria-valuemin={0} aria-valuemax={100} aria-valuenow={Math.round(progress)}><span style={{ width: `${progress}%` }}/></div>
          <div className="tour-controls" aria-label="My tour playback controls"><div><button onClick={() => go(index - 1)} disabled={index === 0 && !complete} aria-label="Previous room">← <span>Previous</span></button><button className="tour-play" onClick={togglePlay} aria-label={complete ? 'Replay my tour' : playing ? 'Pause my tour' : 'Play my tour'}>{complete ? '↻ Replay' : playing ? 'Ⅱ Pause' : '▶ Play'}</button><button onClick={() => go(index + 1)} disabled={complete} aria-label="Next room"><span>Next</span> →</button></div><div><button onClick={toggleMusic} aria-pressed={music}>Music {music ? 'on ♫' : 'off'}</button><button onClick={fullScreen} aria-pressed={nativeFullscreen}>{nativeFullscreen ? 'Exit full screen ↙' : 'Full screen ↗'}</button></div></div>
        </div>
      </> : <div className="tour-loading"><p>I’m still gathering my scenes. Please visit my Design galleries.</p></div>}
      {!scene && <p className="tour-empty-notice" role="status">{notice || loadNote}</p>}
    </dialog>
  </>;
}
