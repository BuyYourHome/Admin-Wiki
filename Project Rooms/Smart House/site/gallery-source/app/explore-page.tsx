'use client';
import { galleries } from '../lib/designs';
import { houseFeatures, roomFeatures } from '../lib/features.js';
import InteractiveFloorPlan from './interactive-floor-plan';
import RoomPrimaryImage from './room-primary-image';

type Scene = 'day' | 'evening' | 'relax';
export default function ExplorePage({ scene, onScene }: { scene: string; onScene: (scene: Scene) => void }) {
  return <section className="secondary-page explore-page">
    <h1 className="single-line-page-title explore-page-title">Get to know me. <em>Like The Back Of Your Room</em></h1>
    <p className="lead">Start with my floor plan. Choose a room to see its picture and details, then get to know the features that will make me Pondster.</p>

    <InteractiveFloorPlan/>

    <section className="house-features" aria-labelledby="house-features-heading">
      <div className="feature-section-heading"><p className="eyebrow">THE BIG PICTURE</p><h2 id="house-features-heading">What makes me, <span className="pondster-inline-signature">Pondster</span>.</h2></div>
      <div className="house-feature-grid">{houseFeatures.map(feature => <article key={feature.title}>
        <span className="feature-status">{feature.status}</span><h3>{feature.title}</h3><p>{feature.text}</p>
      </article>)}</div>
    </section>

    <section className="room-features" aria-labelledby="room-features-heading">
      <div className="feature-section-heading"><p className="eyebrow">MY FEATURES / SPACE BY SPACE</p><h2 id="room-features-heading">Take a look around me.</h2><p>I’m sharing design concepts and plans here. My materials, dimensions, equipment, and construction details still need confirmation.</p></div>
      <div className="room-feature-grid">{galleries.map((gallery,index) => {
        const feature = roomFeatures[gallery.id];
        return <article className="room-feature-card" key={gallery.id}>
          <div className="room-feature-top"><span className="feature-number">{String(index+1).padStart(2,'0')}</span><span className="feature-status">{feature.status}</span></div>
          <details className="room-feature-details">
            <summary><h3>My {gallery.name}</h3><span className="room-feature-prompt">My picture &amp; details <span aria-hidden="true">+</span></span></summary>
            <RoomPrimaryImage galleryId={gallery.id} roomName={gallery.name}/>
            <ul>{feature.features.map(text => <li key={text}>{text}</li>)}</ul>
          </details>
        </article>;
      })}</div>
    </section>

    <section id="lighting-features" className="lighting-features" aria-labelledby="lighting-features-heading" tabIndex={-1}>
      <div className="feature-section-heading"><p className="eyebrow">MY LIGHTING / TRY A MOOD</p><h2 id="lighting-features-heading">See how I will feel.</h2><p>My lighting will set the mood. Try my illustration below.</p></div>
      <div className="explore-demo"><div className={`illustrated-room ${scene}`} aria-label={`My illustrative room with ${scene} lighting`} role="img"><div className="window"/><div className="lamp"/><div className="sofa"/><span>MY LIGHTING CONCEPT · SIMULATION ONLY</span></div><div className="scene-options"><p className="eyebrow">TRY MY LIGHTING MOODS</p>{([['day','Daylight'],['evening','Evening'],['relax','Unwind']] as const).map(([id,label]) => <button key={id} onClick={() => onScene(id)} aria-pressed={scene===id}>{label}<span>↗</span></button>)}<p role="status">{scene==='day'?'I’m bright and neutral.':scene==='evening'?'I’m settling into a warmer evening.':'I’m keeping things soft for a quiet moment.'}</p><small>I’m only changing this illustration, with no connection to my live systems.</small></div></div>
    </section>
  </section>;
}
