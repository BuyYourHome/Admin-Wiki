'use client';

import { useEffect, useId, useRef, type KeyboardEvent } from 'react';
import { galleries, type Design } from '../lib/designs';
import { designImageSource, galleryPictures, movePicture, pictureIndex, pictureSelection } from '../lib/design-views';
import GalleryMediaControls,{type GalleryVoiceControls} from './gallery-media-controls';

type Props = { design: Design | null; onChange: (design: Design) => void; onClose: () => void; voting?:{selected:string|null;disabled:boolean;saving:boolean;onVote:(id:string)=>void};voice?:GalleryVoiceControls };

export default function GalleryImageViewer({ design, onChange, onClose, voting,voice }: Props) {
  const dialog = useRef<HTMLDialogElement>(null);
  const closeButton = useRef<HTMLButtonElement>(null);
  const opener = useRef<HTMLElement | null>(null);
  const titleId = useId();
  const descriptionId = useId();
  const isOpen = Boolean(design);
  // A notebook image can share its filename with another room. Its unique
  // voting ID, rather than the currently selected room, identifies this gallery.
  const gallery = design ? galleries.find(item => item.designs.some(itemDesign => itemDesign.id === design.id)) : undefined;
  const pictures = galleryPictures(gallery?.designs ?? (design ? [design] : []));
  const index = design ? pictureIndex(pictures, design) : -1;
  const picture = pictures[index];
  const canBrowse = pictures.length > 1 && index >= 0;

  function restoreFocus() {
    const target = opener.current;
    opener.current = null;
    if (target?.isConnected) target.focus({ preventScroll: true });
  }

  useEffect(() => {
    const node = dialog.current;
    if (!node) return;
    if (isOpen && !node.open) {
      opener.current = document.activeElement instanceof HTMLElement ? document.activeElement : null;
      node.showModal();
      closeButton.current?.focus({ preventScroll: true });
    } else if (!isOpen && node.open) {
      node.close();
      restoreFocus();
    }
  }, [isOpen]);

  useEffect(() => {
    const node = dialog.current;
    return () => { if (node?.open) node.close(); restoreFocus(); };
  }, []);

  function advance(direction: -1 | 1) {
    if (!canBrowse) return;
    onChange(pictureSelection(pictures[movePicture(index, direction, pictures.length)]));
  }

  function onKeyDown(event: KeyboardEvent<HTMLDialogElement>) {
    if (event.altKey || event.ctrlKey || event.metaKey || event.shiftKey || !canBrowse) return;
    if (event.key !== 'ArrowLeft' && event.key !== 'ArrowRight') return;
    const target = event.target;
    if (target instanceof HTMLElement && (target.isContentEditable || target.closest('input, textarea, select, [contenteditable="true"]'))) return;
    event.preventDefault();
    event.stopPropagation();
    advance(event.key === 'ArrowLeft' ? -1 : 1);
  }

  return <dialog ref={dialog} className="lightbox gallery-image-viewer" aria-labelledby={titleId} aria-describedby={descriptionId}
    onKeyDown={onKeyDown} onCancel={event => { event.preventDefault(); onClose(); }} onClose={() => { restoreFocus(); onClose(); }}>
    {design && <>
      <header className="gallery-viewer-toolbar">
        <div className="gallery-viewer-heading"><p className="eyebrow">MY {gallery ? `${gallery.name.toUpperCase()} GALLERY` : 'DESIGN IMAGE'}</p><h2 id={titleId}>{design.title}</h2></div>
        <button ref={closeButton} type="button" className="gallery-viewer-close" onClick={onClose} aria-label="Close image">Close <span aria-hidden="true">×</span></button>
      </header>
      <div className="gallery-viewer-image"><img key={`${design.id}:${picture?.image ?? design.image}`} src={designImageSource(picture?.image ?? design.image)} alt={`My AI design concept: ${design.title}${design.views?.length ? `, ${picture?.label ?? ''}` : ''}`} decoding="async" /></div>
      <GalleryMediaControls name={gallery?.name??'My design'} canBrowse={canBrowse} onPrevious={()=>advance(-1)} onNext={()=>advance(1)} voice={voice}
        counter={<><span className="gallery-viewer-announcement">{design.title}. {design.views?.length ? `${picture?.label ?? ''}. ` : ''}</span><span>{gallery?.name??'My design'}{design.views?.length?` · ${picture?.label??''}`:''}</span><strong>Picture {index+1} of {pictures.length}</strong></>}
        vote={voting?<><button type="button" className="vote-button" disabled={voting.disabled||voting.selected===design.id} aria-pressed={voting.selected===design.id} onClick={()=>voting.onVote(design.id)}><strong>{design.title}</strong><small>{voting.saving?'I’m saving…':voting.selected===design.id?'✓ Your choice':voting.selected?'Change your vote':'Vote for my design'}</small></button><span>I keep one choice per gallery. You can change your vote.</span></>:undefined}/>
      <p className="gallery-viewer-caption" id={descriptionId}>I’m showing an AI concept for my design, not a measured plan or a photo of completed work.</p>
    </>}
  </dialog>;
}
