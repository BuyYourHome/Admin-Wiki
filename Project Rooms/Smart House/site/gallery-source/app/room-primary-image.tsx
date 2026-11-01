'use client';

import { useEffect, useState } from 'react';
import { galleries } from '../lib/designs';
import { designImageSource } from '../lib/design-views';

export default function RoomPrimaryImage({ galleryId, roomName, onGallery }: { galleryId?: string; roomName: string; onGallery?: (galleryId: string) => void }) {
  const gallery = galleries.find(item => item.id === galleryId);
  const design = gallery?.designs[0];
  const [failed, setFailed] = useState(false);
  const image = design ? designImageSource(design.image) : undefined;
  useEffect(() => setFailed(false), [image]);
  const related = gallery && gallery.name !== roomName;
  const picture = image && !failed ? <img src={image} alt={`My ${roomName}: ${design!.title}${related ? `, a related ${gallery!.name} concept` : ''}`} loading="lazy" decoding="async" onError={() => setFailed(true)} /> : null;

  return <figure className="room-primary-image" aria-label={`My ${roomName} primary picture`}>
    {picture ? onGallery && gallery ? <button type="button" className="room-primary-open" aria-label={`Open my ${gallery.name} design gallery`} title={`Open my ${gallery.name} design gallery`} onClick={() => onGallery(gallery.id)}>{picture}</button> : picture
      : <div className="room-primary-placeholder"><span aria-hidden="true">▧</span><p>{failed ? 'I can’t load my picture right now.' : `I will add my ${roomName} picture here.`}</p></div>}
    <figcaption><span>{design ? related ? `MY RELATED ${gallery!.name.toUpperCase()} CONCEPT` : 'MY PRIMARY DESIGN CONCEPT' : 'MY PICTURE IS STILL TO COME'}</span>
      {design && <><strong>{design.title}</strong><p>I’m showing an illustrative design choice; my final finishes and fit still need confirmation.</p></>}
    </figcaption>
  </figure>;
}
