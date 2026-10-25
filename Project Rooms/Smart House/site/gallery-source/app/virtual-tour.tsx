'use client';

import { useEffect, useRef, useState } from 'react';
import { galleries } from '../lib/designs';
import { buildTourScenes, type TourScene } from '../lib/virtual-tour';
import { createTourSoundtrack } from '../lib/tour-soundtrack';

type RoomResults = Record<string, { scores: Record<string, number>; total: number } | null>;
const availableRooms = galleries.filter(room => room.designs.length > 0);
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
  const dialog = useRef<HTMLDialogElement>(null);
  const video = useRef<HTMLVideoElement>(null);
  const soundtrack = useRef<ReturnType<typeof createTourSoundtrack> | null>(null);
  const request = useRef<AbortController | null>(null);
  const returnFocus = useRef<HTMLButtonElement>(null);
  const generation = useRef(0);
  const position = useRef(0);
  const clock = useRef(0);
  const currentId = useRef('');
  const playback = useRef({ open: false, playing: false, serial: 0 });
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

  function close() {
    generation.current += 1;
    request.current?.abort();
    playback.current.open = false;
    changePlaying(false);
    setOpen(false);
    silence();
    if (document.fullscreenElement === dialog.current) void document.exitFullscreen().catch(() => {});
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
    if (music) {
      try {
        soundtrack.current ??= createTourSoundtrack();
        void soundtrack.current.start().catch(() => { if (generation.current === turn) musicError(); });
      } catch { musicError(); }
    }
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
      if (failed) setLoadNote('I couldn’t check every vote total. I’ve labeled those scenes as featured previews.');
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
    if (!open && element?.open) { element.close(); returnFocus.current?.focus({ preventScroll: true }); }
    if (!open) return;
    const previous = document.body.style.overflow;
    document.body.style.overflow = 'hidden';
    return () => { document.body.style.overflow = previous; };
  }, [open]);

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
    const hidden = () => {
      if (document.hidden) { changePlaying(false); silence(); }
    };
    document.addEventListener('visibilitychange', hidden);
    return () => { document.removeEventListener('visibilitychange', hidden); playback.current.open = false; playback.current.serial += 1; generation.current += 1; request.current?.abort(); void soundtrack.current?.dispose(); };
  }, []);

  async function fullScreen() {
    try {
      if (document.fullscreenElement === dialog.current) await document.exitFullscreen();
      else if (dialog.current?.requestFullscreen) await dialog.current.requestFullscreen();
      else setNotice('My tour already fills this viewing window. This browser doesn’t offer full screen.');
    } catch { setNotice('This browser couldn’t enter full screen. You can keep watching here.'); }
  }

  return <>
    <section className="virtual-tour-invitation" aria-labelledby="tour-invite-heading">
      <div className="tour-cover">
        <img src={`/concepts/${cover.image}`} alt="My exterior design concept at dusk" loading="lazy" decoding="async"/>
        <div className="tour-cover-copy"><p className="eyebrow">MY VIRTUAL DESIGN TOUR</p><h2 id="tour-invite-heading">Let me show<br/><em>you around.</em></h2><p>I bring your favorite designs together, with moving moments and a little music.</p><button ref={returnFocus} className="tour-start" onClick={start}><span aria-hidden="true">▶</span> Take my virtual tour <span aria-hidden="true">↗</span></button></div>
        <span className="tour-cover-tag">MY CONCEPTS · YOUR FAVORITES</span>
      </div>
      <div className="tour-invitation-footer"><div><p className="eyebrow">I FOLLOW THE VOTES</p><p>I check the latest votes when you start and show my leading design in each available space. I also share my Media Center and Garage motion studies.</p></div><div><span>{availableRooms.length} spaces · 2 films · automatic scenes</span><p>I’m an AI design tour, not a recording of completed work. My other rooms will join as their images arrive. If designs tie, I show the first one listed; without votes, I show a featured preview.</p><label className="tour-music-choice"><input type="checkbox" checked={music} onChange={event => setMusic(event.target.checked)}/> Include my gentle instrumental soundtrack</label></div></div>
    </section>
    <dialog ref={dialog} className="virtual-tour-dialog" aria-labelledby="virtual-tour-heading" onCancel={event => { event.preventDefault(); close(); }} onClose={() => { if (open) close(); }}>
      <div className="tour-toolbar"><div><p className="eyebrow">PONDSTER / MY VIRTUAL DESIGN TOUR</p><h2 id="virtual-tour-heading">{complete ? 'Thanks for looking around.' : loading ? 'I’m gathering your favorites…' : scene?.roomName ?? 'Come explore with me.'}</h2></div><button className="tour-close" onClick={close} aria-label="Close my virtual tour">Close <span aria-hidden="true">×</span></button></div>
      {loading ? <div className="tour-loading" role="status"><span aria-hidden="true">P</span><p>I’m checking my latest votes and lining up my scenes.</p></div> : scene ? <>
        <div className={`tour-stage ${ready ? 'is-ready' : ''}`} aria-label={`${scene.roomName}: ${scene.title}`}>
          {isVideo ? <video key={scene.id} ref={video} muted playsInline controls preload="auto" poster={scene.poster ?? scene.image} aria-label={scene.description} onLoadedData={event => { if (currentMedia(scene.id, event.currentTarget)) setReady(true); }} onCanPlay={event => { if (currentMedia(scene.id, event.currentTarget)) setReady(true); }} onEnded={event => { if (currentMedia(scene.id, event.currentTarget) && event.currentTarget === video.current) go(index + 1); }} onError={event => { if (!currentMedia(scene.id, event.currentTarget)) return; setVideoFailed(true); setReady(false); setNotice('My film couldn’t play, so I’m showing my selected design instead.'); }} onPause={event => { const target = event.currentTarget; if (currentMedia(scene.id, target) && target === video.current && target.paused && !target.ended && target.currentTime > 0 && playback.current.playing) changePlaying(false); }} onPlay={event => { const target = event.currentTarget; if (currentMedia(scene.id, target) && target === video.current && !target.paused && !document.hidden && !playback.current.playing) changePlaying(true); }}><source src={scene.video} type="video/mp4"/></video> : <img key={`${scene.id}-still`} src={scene.image} alt={`${scene.roomName} — ${scene.designTitle}, my AI design concept`} onLoad={event => { if (currentMedia(scene.id, event.currentTarget)) setReady(true); }} onError={event => { if (!currentMedia(scene.id, event.currentTarget)) return; setReady(true); setNotice('My image couldn’t load. You can skip ahead or let my tour continue.'); }}/>}
          {complete && <div className="tour-finished"><p className="eyebrow">MY NEXT CHAPTER IS TAKING SHAPE.</p><h3>Thanks for visiting <em>me.</em></h3><p>Your votes help shape my possibilities.</p><button onClick={() => { go(0); changePlaying(true); }}>Watch my tour again ↻</button></div>}
        </div>
        <div className="tour-progress" role="progressbar" aria-label="Scene progress" aria-valuemin={0} aria-valuemax={100} aria-valuenow={Math.round(progress)}><span style={{ width: `${progress}%` }}/></div>
        <div className="tour-scene-caption" aria-live="polite"><div><p className="eyebrow">{selectionLabel(scene)}</p><h3>{scene.title}</h3><p>{scene.description}</p></div><span className="tour-scene-count">{index + 1}<small> / {scenes.length} SCENES</small></span></div>
        <div className="tour-controls" aria-label="My tour playback controls"><div><button onClick={() => go(index - 1)} disabled={index === 0 && !complete} aria-label="Previous scene">← <span>Previous</span></button><button className="tour-play" onClick={togglePlay} aria-label={complete ? 'Replay my tour' : playing ? 'Pause my tour' : 'Play my tour'}>{complete ? '↻ Replay' : playing ? 'Ⅱ Pause' : '▶ Play'}</button><button onClick={() => go(index + 1)} disabled={complete} aria-label="Next scene"><span>Next</span> →</button></div><div><button onClick={toggleMusic} aria-pressed={music}>Music {music ? 'on ♫' : 'off'}</button><button onClick={fullScreen}>Full screen ↗</button></div></div>
        <div className="tour-scenes" aria-label="Choose a tour scene">{scenes.map((item, number) => <button key={item.id} aria-current={number === index ? 'step' : undefined} onClick={() => go(number)} aria-label={`Scene ${number + 1}: ${item.roomName}, ${item.kind === 'motion' ? 'motion study' : item.designTitle}`}><span>{String(number + 1).padStart(2, '0')}</span>{item.roomName}{item.kind === 'motion' && <small>FILM</small>}</button>)}</div>
        <p className="tour-player-note">I’m sharing AI design studies, not photographs of completed spaces or a measured walkthrough. My motion films illustrate movement separately from your chosen finishes. I pause when you leave this tab.</p>
        {scene.sourceCredit && <p className="tour-source-credit">{scene.sourceCredit} <a href={scene.sourceUrl} target="_blank" rel="noopener noreferrer">Original footage ↗</a> {scene.sourceNotice} <a href={scene.sourceNoticeUrl} target="_blank" rel="noopener noreferrer">Source use notice ↗</a></p>}
      </> : <div className="tour-loading"><p>I’m still gathering my scenes. Please visit my Design galleries.</p></div>}
      <p className="tour-notice" role="status">{notice || loadNote}</p>
    </dialog>
  </>;
}
