'use client';
import type {ReactNode} from 'react';
export type GalleryVoiceControls={active:boolean;status:string;onToggle:()=>void;onControls:()=>void};
export type GalleryMediaControlsProps={name:string;canBrowse:boolean;counter:ReactNode;onPrevious:()=>void;onNext:()=>void;vote?:ReactNode;voteAction?:{label:string;onClick:()=>void};voice?:GalleryVoiceControls;onClose?:()=>void};
export default function GalleryMediaControls({name,canBrowse,counter,onPrevious,onNext,vote,voteAction,voice,onClose}:GalleryMediaControlsProps){
  return <div className="gallery-media-controls">
    <div className="gallery-viewer-navigation" role="group" aria-label="Gallery picture navigation">
      <button type="button" disabled={!canBrowse} onClick={onPrevious} aria-label={`Previous picture in ${name}`}>← Previous</button>
      <div className="gallery-viewer-counter" role="status" aria-live="polite" aria-atomic="true">{counter}</div>
      <button type="button" disabled={!canBrowse} onClick={onNext} aria-label={`Next picture in ${name}`}>Next →</button>
    </div>
    {(vote||voteAction)&&<div className="gallery-viewer-voting">{vote??<button type="button" className="vote-button" onClick={voteAction!.onClick}>{voteAction!.label}</button>}</div>}
    <div className="gallery-media-voice">
      {voice&&<><button type="button" onClick={voice.onToggle} aria-pressed={voice.active}>{voice.active?'Stop voice':'Start voice'}</button><button type="button" onClick={voice.onControls}>Voice controls ↗</button><span role="status">{voice.status}</span></>}
      {onClose&&<button type="button" onClick={onClose}>Back to my gallery ↓</button>}
    </div>
  </div>;
}
