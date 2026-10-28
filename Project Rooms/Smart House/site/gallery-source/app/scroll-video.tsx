'use client';

import { useCallback, useEffect, useRef, useState, type ReactNode } from 'react';
import GalleryMediaControls,{type GalleryMediaControlsProps} from './gallery-media-controls';

export default function ScrollVideo({ label, ratio, children,media }: { label: string; ratio: string; children: ReactNode;media?:GalleryMediaControlsProps }) {
  const shell = useRef<HTMLDivElement>(null);
  const stage = useRef<HTMLDivElement>(null);
  const dismissed = useRef(false);
  const [expanded, setExpanded] = useState(false);

  const dismiss = useCallback((returnFocus = false) => {
    dismissed.current = true;
    setExpanded(false);
    if (returnFocus) shell.current?.querySelector('video')?.focus({ preventScroll: true });
  }, []);

  useEffect(() => {
    let frame = 0;
    const measure = () => {
      frame = 0;
      if (!shell.current || document.fullscreenElement) return;
      const rect = shell.current.getBoundingClientRect();
      const height = window.visualViewport?.height ?? window.innerHeight;
      const inView = rect.width > 0 && rect.top < height * .66 && rect.bottom > height * .24;
      if (!inView) dismissed.current = false;
      // Keep the listening/stop controls visible if Pondster is already open.
      setExpanded(inView && !dismissed.current && !document.querySelector('#pondster-panel'));
    };
    const schedule = () => { if (!frame) frame = window.requestAnimationFrame(measure); };
    window.addEventListener('scroll', schedule, { passive: true });
    window.addEventListener('resize', schedule);
    window.visualViewport?.addEventListener('resize', schedule);
    schedule();
    return () => {
      window.removeEventListener('scroll', schedule);
      window.removeEventListener('resize', schedule);
      window.visualViewport?.removeEventListener('resize', schedule);
      window.cancelAnimationFrame(frame);
    };
  }, []);

  useEffect(() => {
    if (!expanded) return;
    const onKey = (event: KeyboardEvent) => {
      if (event.key === 'Escape' && !document.fullscreenElement) { event.preventDefault(); dismiss(true); }
    };
    const onFocus = (event: FocusEvent) => {
      if (event.target instanceof Node && !stage.current?.contains(event.target)) dismiss();
    };
    document.documentElement.classList.add('has-expanded-scroll-video');
    document.addEventListener('keydown', onKey);
    document.addEventListener('focusin', onFocus);
    return () => {
      document.documentElement.classList.remove('has-expanded-scroll-video');
      document.removeEventListener('keydown', onKey);
      document.removeEventListener('focusin', onFocus);
    };
  }, [expanded, dismiss]);

  return <><div ref={shell} className="scroll-video-shell" style={{ aspectRatio: ratio }} data-expanded={expanded ? 'true' : 'false'}>
    <div ref={stage} className={`scroll-video-stage${expanded ? ' is-expanded' : ''}${media?' has-media-controls':''}`} role="group" aria-label={label}>
      {children}
      {expanded&&media&&<GalleryMediaControls {...media} onClose={()=>dismiss(true)}/>}
      {expanded && !media && <>
        <div className="scroll-video-toolbar"><span>{label}</span><button type="button" onClick={() => dismiss(true)}>Back to my gallery <span aria-hidden="true">↓</span></button></div>
        <p className="scroll-video-hint">Scroll to keep exploring my designs.</p>
      </>}
    </div>
  </div>{!expanded&&media&&<GalleryMediaControls {...media}/>}</>;
}
