'use client';
import { useEffect, useRef, useState } from 'react';
import { galleries, type Design } from '../lib/designs';
import ViewPage from './view-page';
import BuiltByPage from './built-by-page';
import PondsterGuide from './pondster-guide';
import Comments from './comments';
import ScrollVideo from './scroll-video';
import TheaterMotion from './theater-motion';
import ExplorePage from './explore-page';
import PondsterLogoArt from './pondster-logo-art';
import type { GuideAction } from '../lib/pondster-guide';

type VoteResults = { scores:Record<string,number>; total:number; selected:string|null };
const empty:VoteResults = {scores:{},total:0,selected:null};
const menus = ['Design','Explore','View','Own','Built By'] as const;
const menuHash = (menu:string) => menu.toLowerCase().replace(/\s+/g,'-');
type Menu = typeof menus[number];
export default function Home() {
  const [menu,setMenu] = useState<Menu>('Design');
  const [room,setRoom] = useState('media-center');
  const [results,setResults] = useState<VoteResults>(empty);
  const [loading,setLoading] = useState(true);
  const [saving,setSaving] = useState(false);
  const [message,setMessage] = useState('');
  const [failed,setFailed] = useState(false);
  const [retry,setRetry] = useState(0);
  const [zoom,setZoom] = useState<Design|null>(null);
  const [scene,setScene] = useState('day');
  const [guideOpen,setGuideOpen] = useState(false);
  const [showLighting,setShowLighting] = useState(false);
  const [logoPlay,setLogoPlay] = useState(0);
  const dialog = useRef<HTMLDialogElement>(null);
  const gallery = galleries.find(gallery => gallery.id === room)!;
  useEffect(() => {
    const sync = () => { const raw = location.hash.slice(1).toLowerCase(); const value = raw === 'manage' ? 'own' : raw; const next = menus.find(item => menuHash(item) === value); if(next) setMenu(next); };
    sync(); window.addEventListener('hashchange',sync); return () => window.removeEventListener('hashchange',sync);
  },[]);
  useEffect(() => {
    const controller = new AbortController();
    setLoading(true);setMessage('');setFailed(false);setResults(empty);
    if (!gallery.designs.length) {setLoading(false);return () => controller.abort();}
    fetch(`/api/votes?room=${encodeURIComponent(room)}`,{cache:'no-store',signal:controller.signal}).then(async response => {const data=await response.json() as VoteResults & {error?:string};if(!response.ok)throw new Error(data.error);return data;}).then(data=>setResults(data)).catch(error=>{if(error.name!=='AbortError'){setMessage('I can’t load the vote totals right now.');setFailed(true);}}).finally(()=>{if(!controller.signal.aborted)setLoading(false);});
    return () => controller.abort();
  },[room,retry]);
  useEffect(() => {if(zoom && !dialog.current?.open)dialog.current?.showModal();if(!zoom && dialog.current?.open)dialog.current.close();},[zoom]);
  useEffect(() => {if(menu!=='Explore' || !showLighting)return;const frame=requestAnimationFrame(()=>{const target=document.getElementById('lighting-features');target?.scrollIntoView({block:'start'});target?.focus({preventScroll:true});setShowLighting(false);});return ()=>cancelAnimationFrame(frame);},[menu,showLighting]);
  async function vote(designId:string) {
    if(saving)return;setSaving(true);setMessage('');
    try { const response=await fetch('/api/votes',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({room,designId})});const data=await response.json() as VoteResults & {error?:string};if(!response.ok)throw new Error(data.error);setResults(data);setFailed(false);setMessage('I’ve saved your choice. Thank you for helping shape my design.'); }
    catch(error){setMessage(error instanceof Error ? error.message : 'I couldn’t save your vote. Please try again.');}
    finally{setSaving(false);}
  }
  function navigate(next:Menu){setMenu(next);}
  function guideAction(action:GuideAction){setMenu(action.menu);location.hash=menuHash(action.menu);if(action.room&&!saving)setRoom(action.room);if(action.scene){setScene(action.scene);setShowLighting(true);}}
  return <>
    <a className="skip" href="#main">Skip to content</a>
    <header className="header"><a className="brand" href="#design" onClick={()=>navigate('Design')} aria-label="Pondster home" onMouseEnter={()=>setLogoPlay(value=>value+1)} onFocus={()=>setLogoPlay(value=>value+1)}><PondsterLogoArt key={logoPlay}/><span className="monogram" aria-hidden="true">P<small>HOME</small></span><span className="brand-copy"><strong className="brand-name">Pondster</strong><small>I’m a home with a voice.</small></span></a><nav aria-label="Main menu">{menus.map(item=><a key={item} href={`#${menuHash(item)}`} onClick={()=>navigate(item)} aria-current={menu===item?'page':undefined}>{item}</a>)}</nav><span className="development">I’M A HOME IN THE MAKING</span></header>
    <main id="main">
      {menu==='Design' && <>
        <section className="intro"><div><p className="eyebrow">PONDSTER / MY DESIGN NOTEBOOK</p><h1>I’m taking shape.<br/><em>Have a say.</em></h1></div><div className="intro-note"><p>I’m exploring ideas for each space. Browse my designs, vote for the ones you love, and help me decide what feels right.</p><span>Explore my {galleries.length} galleries.</span></div></section>
        <section className="pondster-welcome" aria-label="Meet Pondster"><div><span className="eyebrow">MY NAME. MY VOICE.</span><p>I’m Pondster, the voice and identity of this house. Ask me about the design ideas and follow my story as it takes shape. My location is confidential for now—think witness protection, with better curb appeal. Jean Wright is my SI designer.</p></div><button onClick={()=>setGuideOpen(true)}>Talk to me <span aria-hidden="true">↗</span></button></section>
        <section className="design-workspace" aria-label="My design galleries"><aside className="room-nav"><p className="eyebrow">EXPLORE MY ROOMS</p><div role="group" aria-label="Rooms">{galleries.map((item,index)=><button key={item.id} onClick={()=>{if(!saving)setRoom(item.id);}} disabled={saving} aria-pressed={room===item.id}><span className="room-number">0{index+1}</span><span>{item.name}<small>{item.designs.length?`${item.designs.length} ${item.designs.length===1?'design':'designs'}`:'Coming soon'}</small></span><b aria-hidden="true">↗</b></button>)}</div><div className="notebook-note"><span>I’M EXPLORING POSSIBILITIES.</span><p>I use AI concepts to explore how I could look. These aren’t measured plans or photos of my completed spaces.</p></div></aside>
        <div className="gallery-area"><div className="gallery-heading"><div><p className="eyebrow">DESIGN GALLERY / {String(galleries.indexOf(gallery)+1).padStart(2,'0')}</p><h2>{gallery.name}</h2><p>{gallery.summary}</p></div>{gallery.designs.length>0 && <span className="vote-total">{loading?'I’m loading votes…':failed?'I can’t load totals':`${results.total} ${results.total===1?'vote':'votes'}`}<small>COMMUNITY PREFERENCES</small></span>}</div>
        {room==='media-center' && <figure className="media-feature"><div className="media-feature-intro"><div><p className="eyebrow">MY MEDIA CENTER / IN MOTION</p><h3>Watch me go from art to game time.</h3></div><span>MY 10-SECOND CONCEPT FILM</span></div><ScrollVideo label="My Media Center" ratio="16 / 9"><video controls autoPlay muted playsInline loop preload="metadata" poster="/media/media-center-art-poster.png" aria-label="My Media Center concept: my decorative frame stays fixed while my TV turns toward my kitchen and artwork becomes moving football" aria-describedby="media-motion-caption"><source src="/media/media-center-kitchen-view.mp4" type="video/mp4"/>Your browser can’t play my video here. <a href="/media/media-center-kitchen-view.mp4">Open my video file</a>.</video></ScrollVideo><figcaption id="media-motion-caption"><span>MY AI MOTION CONCEPT</span>I’m showing an illustrative AI concept: my decorative frame stays fixed while my TV turns toward my kitchen and its artwork becomes moving football. My mount mechanics haven’t been validated.<p className="media-source">Football footage: U.S. Marine Corps / Sgt. James Stanfield, via <a href="https://www.dvidshub.net/video/947000/125th-army-navy-football-game-b-roll" target="_blank" rel="noopener noreferrer">DVIDS</a>.<br/>The appearance of U.S. Department of War (DoW) visual information does not imply or constitute DoW endorsement. <a href="https://www.dvidshub.net/about/copyright" target="_blank" rel="noopener noreferrer">Source use notice ↗</a></p></figcaption></figure>}
        {room==='spiral-staircase' && <TheaterMotion/>}
        {room==='garage-barn-door' && <figure className="media-feature garage-media-feature">
          <div className="media-feature-intro"><div><p className="eyebrow">MY GARAGE BARN DOOR / IN MOTION</p><h3>Watch me open up.</h3></div><span>MY 25-SECOND CONCEPT FILM</span></div>
          <ScrollVideo label="My Garage Barn Door" ratio="5 / 2"><video controls autoPlay muted playsInline loop preload="metadata" poster="/media/garage-barn-door-drive-out-poster.jpg" aria-label="My garage barn-door concept: my center entry section swings inward, my full door slides left, and a white Tesla drives out to reveal my white-marble garage floor" aria-describedby="garage-motion-caption">
            <source src="/media/garage-barn-door-tesla-drive-out.mp4" type="video/mp4"/>Your browser can’t play my video here. <a href="/media/garage-barn-door-tesla-drive-out.mp4">Open my video file</a>.
          </video></ScrollVideo>
          <figcaption id="garage-motion-caption"><span>MY AI MOTION CONCEPT</span>My center entry section swings inward and closes before my full door slides left. I’m showing a white Tesla driving out and across the scene to the left, leaving my white-marble garage floor in view. This is my illustrative AI/composited concept; my hardware, clearances, and the car’s turning path haven’t been validated.</figcaption>
        </figure>}
        {gallery.designs.length ? <><div className={`design-grid ${gallery.designs.length===1?'single':gallery.designs.length===2?'pair':''}`}>{gallery.designs.map((design,index)=>{const votes=results.scores[design.id]??0;const percent=results.total?Math.round(votes/results.total*100):0;const chosen=results.selected===design.id;return <article key={design.id} aria-labelledby={`vote-title-${design.id}`} className={`design-card ${chosen?'chosen':''} ${design.fullImage?'full-scene':''}`}><button className={`vote-button ${chosen?'selected':''}`} disabled={saving||loading||failed||chosen} aria-pressed={chosen} onClick={()=>vote(design.id)}><span className="vote-button-copy"><strong id={`vote-title-${design.id}`}>{design.title}</strong><small>{saving?'I’m saving…':chosen?'✓ Your choice':results.selected?'Change your vote':'Vote for my design'}</small></span><span className="vote-button-icon" aria-hidden="true">{chosen?'':'♡'}</span></button><button className="image-open" onClick={()=>setZoom(design)} aria-label={`Enlarge ${design.title}`}><img src={`/concepts/${design.image}`} alt={`My AI design concept: ${design.title}`} loading={index < 3 ? "eager" : "lazy"} decoding="async" /><span>VIEW FULL IMAGE ↗</span></button><div className="card-content"><span className="option-label">CONCEPT {String(index+1).padStart(2,'0')}</span><p>{design.detail}</p><div className="result-line"><span>{loading?'I’m loading…':failed?'I can’t load totals':`${votes} ${votes===1?'vote':'votes'}`}</span><span>{!loading&&!failed?`${percent}%`:''}</span></div><div className="result-track" aria-hidden="true"><i style={{width:`${percent}%`}} /></div></div></article>;})}</div><p className="vote-explainer">I don’t ask you to sign in. I keep one current choice per gallery in this browser; pick another design to change it. Other browsers or cleared cookies can vote again. I use votes as preferences, not final selections.</p><div className="vote-feedback" role="status" aria-live="polite">{message}{failed && <button className="text-button" onClick={()=>setRetry(retry+1)}>Try again</button>}</div></> : <div className="empty-gallery"><span className="empty-icon" aria-hidden="true">▧</span><p className="eyebrow">I’M STILL EXPLORING</p><h3>Designs for my {gallery.name} are coming.</h3><p>I haven’t added design images here yet. When I do, you can browse my options and vote for your favorite.</p><span className="pending-tag">I’m waiting for images</span></div>}
        {room==='media-center' && <TheaterMotion/>}
        </div></section>
        <section className="design-footer"><span>MY DESIGN IS A CONVERSATION.</span><p>Come back as I explore new rooms and choices.</p><span>MY LOCATION IS CONFIDENTIAL</span></section>
      </>}
      {menu==='Explore' && <ExplorePage scene={scene} onScene={setScene} onDesign={nextRoom=>{if(!saving){setRoom(nextRoom);navigate('Design');location.hash='design';}}}/>}
      {menu==='View' && <ViewPage onImage={setZoom} onDesign={()=>navigate('Design')} onTourStart={()=>setGuideOpen(false)}/>}
      {menu==='Built By' && <BuiltByPage/>}
      {menu==='Own' && <section className="secondary-page manage"><p className="eyebrow">OWN / MY FUTURE OWNER EXPERIENCE</p><h1>I come<br/><em>with answers.</em></h1><p className="lead">I’m planning a place for my home guides, care information, and handover records. Ask me from any page for public guidance while my owner tools take shape.</p><div className="knowledge-grid">{[['Home guides','How my systems work and where you can find them.'],['Care & maintenance','My manuals, warranties, and equipment-specific schedules.'],['Owner handover','My records and account checklist for the next chapter.']].map(([title,description])=><article key={title}><span className="pending-tag">PLANNED</span><h3>{title}</h3><p>{description}</p></article>)}</div><div className="manage-notice"><strong>My owner tools aren’t ready yet.</strong><p>I’ll need separate, authenticated owner access before I can show private records or offer live controls. I’m not connected to my house systems through this public site.</p></div></section>}
      <Comments key={menu} page={menuHash(menu)} title={menu} onAsk={()=>setGuideOpen(true)}/>
    </main><footer><span>MY LOCATION IS CONFIDENTIAL</span><p>My SI designer: Jean Wright · Buy Your Home</p><span>I’m sharing concepts · No live controls</span></footer>
    <PondsterGuide open={guideOpen} onOpenChange={setGuideOpen} onAction={guideAction}/>
    <dialog ref={dialog} onCancel={()=>setZoom(null)} onClose={()=>setZoom(null)} className="lightbox">{zoom && <><button className="close-zoom" onClick={()=>setZoom(null)} aria-label="Close image">Close ×</button><img src={`/concepts/${zoom.image}`} alt={`My AI design concept: ${zoom.title}`}/><div><h2>{zoom.title}</h2><p>I’m showing an AI concept for my design, not a measured plan or a photo of completed work.</p></div></>}</dialog>
  </>;
}
