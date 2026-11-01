'use client';

import { useState } from 'react';
import type { Design } from '../lib/designs';
import { designImageSource, designPictures, movePicture, pictureSelection } from '../lib/design-views';
import styles from './design-card-images.module.css';

export default function DesignCardImages({ design, onOpen, priority = false }: { design: Design; onOpen: (design: Design) => void; priority?: boolean }) {
  const [index, setIndex] = useState(0);
  const pictures = designPictures(design);
  const picture = pictures[index] ?? pictures[0];
  const multiple = pictures.length > 1;
  return <div className={styles.frame}>
    <button className="image-open" onClick={() => onOpen(pictureSelection(picture))} aria-label={`Enlarge ${design.title}${multiple ? `: ${picture.label}` : ''}`}>
      <img key={picture.image} src={designImageSource(picture.image)} alt={`My AI design concept: ${design.title}${multiple ? `, ${picture.label}` : ''}`} style={design.fullImage ? { objectFit: 'contain' } : undefined} loading={priority ? 'eager' : 'lazy'} decoding="async"/>
      <span>{multiple ? `VIEW ${pictures.length} VIEWS` : 'VIEW FULL IMAGE'} ↗</span>
    </button>
    {multiple && <div className={styles.controls} role="group" aria-label={`Views of ${design.title}; one design choice`}>
      <button type="button" onClick={() => setIndex(current => movePicture(current, -1, pictures.length))} aria-label={`Previous view of ${design.title}`}>←</button>
      <p role="status" aria-live="polite" aria-atomic="true"><strong>{picture.label}</strong><span>View {index + 1} of {pictures.length} · one design</span></p>
      <button type="button" onClick={() => setIndex(current => movePicture(current, 1, pictures.length))} aria-label={`Next view of ${design.title}`}>→</button>
    </div>}
  </div>;
}
