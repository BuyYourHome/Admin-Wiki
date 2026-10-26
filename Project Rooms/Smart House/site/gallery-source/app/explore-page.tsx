'use client';
import { galleries } from '../lib/designs';
import { houseFeatures, roomFeatures } from '../lib/features.js';

type Scene = 'day' | 'evening' | 'relax';
export default function ExplorePage({ scene, onScene, onDesign }: { scene: string; onScene: (scene: Scene) => void; onDesign: (room: string) => void }) {
  return <section className="secondary-page explore-page">
    <p className="eyebrow">EXPLORE / GET TO KNOW ME</p>
    <h1>Get to know me.<br/><em>Like The Back Of Your Room</em></h1>
    <p className="lead">I’m Pondster. Here are my house-wide ideas and the features I’m exploring in each space as I take shape.</p>

    <section className="house-features" aria-labelledby="house-features-heading">
      <div className="feature-section-heading"><p className="eyebrow">THE BIG PICTURE</p><h2 id="house-features-heading">What makes me, me.</h2></div>
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
          <h3>My {gallery.name}</h3>
          <ul>{feature.features.map(text => <li key={text}>{text}</li>)}</ul>
          <button className="feature-gallery-link" onClick={() => onDesign(gallery.id)}>Visit my {gallery.name} gallery <span aria-hidden="true">↗</span></button>
        </article>;
      })}</div>
    </section>

    <section id="lighting-features" className="lighting-features" aria-labelledby="lighting-features-heading" tabIndex={-1}>
      <div className="feature-section-heading"><p className="eyebrow">MY LIGHTING / TRY A MOOD</p><h2 id="lighting-features-heading">See how I could feel.</h2><p>Let me show you how light could change the feel of a space.</p></div>
      <div className="explore-demo"><div className={`illustrated-room ${scene}`} aria-label={`My illustrative room with ${scene} lighting`} role="img"><div className="window"/><div className="lamp"/><div className="sofa"/><span>MY LIGHTING CONCEPT · SIMULATION ONLY</span></div><div className="scene-options"><p className="eyebrow">TRY MY LIGHTING MOODS</p>{([['day','Daylight'],['evening','Evening'],['relax','Unwind']] as const).map(([id,label]) => <button key={id} onClick={() => onScene(id)} aria-pressed={scene===id}>{label}<span>↗</span></button>)}<p role="status">{scene==='day'?'I’m bright and neutral.':scene==='evening'?'I’m settling into a warmer evening.':'I’m keeping things soft for a quiet moment.'}</p><small>I’m only changing this illustration, with no connection to my live systems.</small></div></div>
    </section>
  </section>;
}
