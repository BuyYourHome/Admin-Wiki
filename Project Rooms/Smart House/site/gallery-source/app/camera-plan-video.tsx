'use client';

import { useEffect, useId, useRef, useState, type KeyboardEvent } from 'react';
import { floorPlanCameras, type FloorPlanCamera } from '../lib/floor-plan-cameras';
import useHorizontalSwipe from './use-horizontal-swipe';
import type { GalleryVoiceControls } from './gallery-media-controls';

export default function CameraPlanVideo({ camera, onCamera, voice }: { camera: FloorPlanCamera; onCamera: (id: string) => void; voice?: GalleryVoiceControls }) {
  const [expanded, setExpanded] = useState(false);
  const [failed, setFailed] = useState(false);
  const dialog = useRef<HTMLDialogElement>(null);
  const video = useRef<HTMLVideoElement>(null);
  const opener = useRef<HTMLElement | null>(null);
  const closeButton = useRef<HTMLButtonElement>(null);
  const enlargeButton = useRef<HTMLButtonElement>(null);
  const titleId = useId();
  const captionId = useId();
  const index = floorPlanCameras.findIndex(item => item.id === camera.id);
  function advance(direction: -1 | 1) {
    onCamera(floorPlanCameras[(index + direction + floorPlanCameras.length) % floorPlanCameras.length].id);
  }
  const swipe = useHorizontalSwipe<HTMLDivElement>({
    onPrevious: () => advance(-1), onNext: () => advance(1),
    enabled: floorPlanCameras.length > 1, resetKey: `${camera.id}:${expanded}`,
  });

  useEffect(() => { setFailed(false); }, [camera.id, expanded]);
  useEffect(() => {
    const node = video.current;
    return () => { node?.pause(); };
  }, [camera.id, expanded]);
  useEffect(() => {
    const node = dialog.current;
    if (!node) return;
    if (expanded && !node.open) {
      node.showModal(); closeButton.current?.focus({ preventScroll: true });
    } else if (!expanded) {
      if (node.open) node.close();
      const target = opener.current; opener.current = null;
      if (target) {
        const focusTarget = target.isConnected ? target : enlargeButton.current;
        focusTarget?.focus({ preventScroll: true });
      }
    }
  }, [expanded]);
  useEffect(() => {
    const node = dialog.current;
    return () => { if (node?.open) node.close(); };
  }, []);
  function close() {
    setExpanded(false);
  }
  function open() {
    opener.current = enlargeButton.current;
    setExpanded(true);
  }
  function keyboard(event: KeyboardEvent<HTMLDialogElement>) {
    if (event.altKey || event.ctrlKey || event.metaKey || event.shiftKey) return;
    if (event.target instanceof HTMLElement && event.target.closest('video,input,textarea,select,[contenteditable="true"]')) return;
    if (event.key === 'ArrowLeft' || event.key === 'ArrowRight') {
      event.preventDefault(); event.stopPropagation(); advance(event.key === 'ArrowLeft' ? -1 : 1);
    }
  }
  const controls = <div className="camera-view-controls" role="group" aria-label="My camera views">
    <button type="button" onClick={() => advance(-1)} aria-label="Previous camera view">← Previous</button>
    <span role="status" aria-live="polite">Camera {camera.number} of {floorPlanCameras.length}</span>
    <button type="button" onClick={() => advance(1)} aria-label="Next camera view">Next →</button>
  </div>;
  const movie = <div className="camera-video-stage" {...swipe}>
    <video key={`${camera.id}:${expanded}`} ref={video} controls autoPlay muted playsInline loop preload="metadata" poster={camera.poster}
      aria-label={`My Camera ${camera.number} ${camera.name} virtual demonstration`} aria-describedby={captionId}
      onError={() => setFailed(true)}><source src={camera.video} type="video/mp4" /></video>
    {failed && <p className="camera-video-error" role="status">I can’t play this camera demonstration right now. Try another view or return to my plan.</p>}
  </div>;
  const caption = <p id={captionId} className="camera-video-caption">I’m showing a virtual camera demonstration, not a live feed or verified coverage. {camera.number === 1 ? 'My current camera mount and this earlier viewpoint still need to be reconciled.' : camera.number === 4 ? 'This video uses an earlier west-side viewpoint; my newest plan turns this view toward the front road.' : 'My camera fields illustrate direction; walls, roofs and foliage can block the view.'}</p>;
  const voiceControls = voice && <div className="camera-view-voice"><button type="button" aria-pressed={voice.active} onClick={voice.onToggle}>{voice.active ? 'Stop voice' : 'Start voice'}</button><button type="button" onClick={() => { close(); voice.onControls(); }}>Voice controls ↗</button><span role="status">{voice.status}</span></div>;

  return <figure className="camera-plan-video">
    {!expanded && <>{movie}{controls}<button ref={enlargeButton} type="button" className="camera-view-enlarge" onClick={open}>Enlarge my Camera {camera.number} view ↗</button>{voiceControls}{caption}</>}
    <dialog ref={dialog} className="camera-view-dialog" aria-labelledby={titleId} aria-describedby={captionId}
      onKeyDown={keyboard} onCancel={event => { event.preventDefault(); close(); }} onClose={() => { if (expanded) close(); }}>
      {expanded && <><header className="camera-view-toolbar"><h2 id={titleId}>My Camera {camera.number}: {camera.name}</h2><button ref={closeButton} type="button" onClick={close} aria-label="Close camera view">Back to my plan ×</button></header>{movie}<div className="camera-view-actions">{controls}{voiceControls}</div>{caption}</>}
    </dialog>
  </figure>;
}
