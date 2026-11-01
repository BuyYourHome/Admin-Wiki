'use client';
import type { Ref } from 'react';
import { houseFeatures } from '../lib/features.js';
import InteractiveFloorPlan, { type FloorPlanRoomRequest } from './interactive-floor-plan';

type Scene = 'day' | 'evening' | 'relax';
const featureSections:Record<string,string> = {
  'My instant hot water':'hot-water','I follow your routine':'presence','My bath, your preferences':'bath-and-shower',
  'I keep an eye outside':'exterior-awareness','My voice':'voice-feature','My lighting moods':'lighting-plans',
  'My sound & screens':'sound-screens','My climate & comfort':'climate','Your say in my design':'design-participation','My owner experience':'owner-experience'
};
export default function ExplorePage({ scene, onScene, floorPlanRequest, floorPlanDetailRef }: { scene: string; onScene: (scene: Scene) => void; floorPlanRequest?:FloorPlanRoomRequest; floorPlanDetailRef?:Ref<HTMLElement> }) {
  return <section className="secondary-page explore-page">
    <h1 className="single-line-page-title explore-page-title">Get to know me. <em>Like The Back Of Your Room</em></h1>
    <p className="lead">Start with my floor plan. Choose a room to see its picture and details, then get to know the features that will make me Pondster.</p>

    <InteractiveFloorPlan roomRequest={floorPlanRequest} detailRef={floorPlanDetailRef}/>

    <section id="pondster-explore-house" className="house-features" aria-labelledby="house-features-heading">
      <div className="feature-section-heading"><p className="eyebrow">THE BIG PICTURE</p><h2 id="house-features-heading">What makes me, <span className="pondster-inline-signature">Pondster</span>.</h2></div>
      <div className="house-feature-grid">{houseFeatures.map(feature => <article id={featureSections[feature.title]?`pondster-explore-${featureSections[feature.title]}`:undefined} key={feature.title}>
        <span className="feature-status">{feature.status}</span><h3>{feature.title}</h3><p>{feature.text}</p>
      </article>)}</div>
    </section>

    <section id="pondster-explore-lighting" className="lighting-features" aria-labelledby="lighting-features-heading" tabIndex={-1}>
      <div className="feature-section-heading"><p className="eyebrow">MY LIGHTING / TRY A MOOD</p><h2 id="lighting-features-heading">See how I will feel.</h2><p>My lighting will set the mood. Try my illustration below.</p></div>
      <div className="explore-demo"><div className={`illustrated-room ${scene}`} aria-label={`My illustrative room with ${scene} lighting`} role="img"><div className="window"/><div className="lamp"/><div className="sofa"/><span>MY LIGHTING CONCEPT · SIMULATION ONLY</span></div><div className="scene-options"><p className="eyebrow">TRY MY LIGHTING MOODS</p>{([['day','Daylight'],['evening','Evening'],['relax','Unwind']] as const).map(([id,label]) => <button key={id} onClick={() => onScene(id)} aria-pressed={scene===id}>{label}<span>↗</span></button>)}<p role="status">{scene==='day'?'I’m bright and neutral.':scene==='evening'?'I’m settling into a warmer evening.':'I’m keeping things soft for a quiet moment.'}</p><small>I’m only changing this illustration, with no connection to my live systems.</small></div></div>
    </section>
  </section>;
}
