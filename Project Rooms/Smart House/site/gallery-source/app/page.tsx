'use client';
import { useEffect, useRef, useState } from 'react';
import { galleries, type Design } from '../lib/designs';
import ViewPage from './view-page';
import BuiltByPage from './built-by-page';
import ContactPage from './contact-page';
import PondsterGuide, { type PondsterGuideHandle, type PondsterVoiceSummary } from './pondster-guide';
import Comments from './comments';
import ScrollVideo from './scroll-video';
import TheaterMotion from './theater-motion';
import ExplorePage from './explore-page';
import PondsterLogoArt from './pondster-logo-art';
import GalleryImageViewer from './gallery-image-viewer';
import DesignCardImages from './design-card-images';
import type { GuideAction } from '../lib/pondster-guide';
import { getGalleryScrollTop, getSectionRevealTop } from '../lib/gallery-scroll';
import { getPondsterDestinationId, parsePondsterDestination, type PondsterDestination } from '../lib/pondster-destinations';

type VoteResults = { scores:Record<string,number>; total:number; selected:string|null; roomTotals:Record<string,number> };
const empty:VoteResults = {scores:{},total:0,selected:null,roomTotals:{}};
const menus = ['Design','Explore','View','Own','Built By','Contact'] as const;
const menuHash = (menu:string) => menu === 'Own' ? 'belong' : menu.toLowerCase().replace(/\s+/g,'-');
const menuLabel = (menu:string) => menu === 'Own' ? 'Belong' : menu;
type Menu = typeof menus[number];
type SectionReveal = { id:number; destination:PondsterDestination };
export default function Home() {
  const [menu,setMenu] = useState<Menu>('View');
  const [room,setRoom] = useState('media-center');
  const [results,setResults] = useState<VoteResults>(empty);
  const [roomTotals,setRoomTotals] = useState<Record<string,number>>({});
  const [roomTotalsLoading,setRoomTotalsLoading] = useState(true);
  const [roomTotalsFailed,setRoomTotalsFailed] = useState(false);
  const [loading,setLoading] = useState(true);
  const [saving,setSaving] = useState(false);
  const [message,setMessage] = useState('');
  const [failed,setFailed] = useState(false);
  const [retry,setRetry] = useState(0);
  const [zoom,setZoom] = useState<Design|null>(null);
  const [scene,setScene] = useState('day');
  const [tourRequest,setTourRequest] = useState<number|null>(null);
  const nextTourRequest = useRef(0);
  const [voiceSummary,setVoiceSummary] = useState<PondsterVoiceSummary>({active:false,status:'Voice off. Hover or click my logo to talk.'});
  const guide=useRef<PondsterGuideHandle>(null);
  const logo=useRef<HTMLButtonElement>(null);
  const stickyHeader=useRef<HTMLElement>(null);
  const galleryArea=useRef<HTMLDivElement>(null);
  const galleryHeading=useRef<HTMLDivElement>(null);
  const pendingGalleryScroll=useRef<{room:string}|null>(null);
  const [sectionReveal,setSectionReveal] = useState<SectionReveal|null>(null);
  const pendingSectionReveal=useRef<SectionReveal|null>(null);
  const nextSectionReveal=useRef(0);
  const floorPlanDetails=useRef<HTMLElement>(null);
  const [logoPlay,setLogoPlay] = useState(0);
  const voiceHoverTimer = useRef<ReturnType<typeof setTimeout>|null>(null);
  const voiceIsLive = voiceSummary.active&&!voiceSummary.connecting;
  useEffect(()=>()=>cancelVoiceHover(),[]);
  const gallery = galleries.find(gallery => gallery.id === room)!;
  useEffect(() => {
    const sync = () => { const raw = location.hash.slice(1).toLowerCase(); if(raw === 'main') return; const value = raw === 'manage' || raw === 'own' ? 'belong' : raw; const next = menus.find(item => menuHash(item) === value) ?? 'View'; if(pendingSectionReveal.current && pendingSectionReveal.current.destination.menu!==next){pendingSectionReveal.current=null;setSectionReveal(null);}setMenu(next);if(next!=='View')setTourRequest(null); };
    sync(); window.addEventListener('hashchange',sync); return () => window.removeEventListener('hashchange',sync);
  },[]);
  useEffect(() => {
    const controller = new AbortController();
    setLoading(true);setMessage('');setFailed(false);setResults(empty);
    setRoomTotalsLoading(true);setRoomTotalsFailed(false);
    fetch(`/api/votes?room=${encodeURIComponent(room)}`,{cache:'no-store',signal:controller.signal}).then(async response => {const data=await response.json() as VoteResults & {error?:string};if(!response.ok)throw new Error(data.error);return data;}).then(data=>{if(controller.signal.aborted)return;setResults(data);setRoomTotals(data.roomTotals);setRoomTotalsFailed(false);}).catch(error=>{if(error.name!=='AbortError'){setMessage('I can’t load the vote totals right now.');setFailed(true);setRoomTotalsFailed(true);}}).finally(()=>{if(!controller.signal.aborted){setLoading(false);setRoomTotalsLoading(false);}});
    return () => controller.abort();
  },[room,retry]);
  useEffect(() => {
    const request = pendingGalleryScroll.current;
    if(menu!=='Design'){pendingGalleryScroll.current=null;return;}
    if(!request || request.room!==room)return;
    const frame=requestAnimationFrame(()=>{
      if(pendingGalleryScroll.current!==request)return;
      pendingGalleryScroll.current=null;
      const area=galleryArea.current, heading=galleryHeading.current;
      if(!area || !heading)return;
      const visual=[...area.querySelectorAll<HTMLElement>('video, img, .empty-gallery')]
        .find(element=>element.getClientRects().length>0 && element.getBoundingClientRect().height>0);
      const bounds=heading.getBoundingClientRect();
      const top=getGalleryScrollTop({headingTop:bounds.top,headingBottom:bounds.bottom,
        visualTop:visual?.getBoundingClientRect().top ?? null,
        headerBottom:stickyHeader.current?.getBoundingClientRect().bottom ?? 0,
        viewportHeight:window.innerHeight,scrollY:window.scrollY});
      if(top===null)return;
      const reduceMotion=typeof window.matchMedia==='function' && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
      window.scrollTo({top,behavior:reduceMotion?'auto':'smooth'});
    });
    return()=>cancelAnimationFrame(frame);
  },[menu,room]);
  useEffect(() => {
    const request=sectionReveal;
    if(!request || pendingSectionReveal.current!==request || request.destination.menu!==menu)return;
    const destination=request.destination, targetId=getPondsterDestinationId(destination);
    if(!targetId || (menu==='Design' && destination.room && destination.room!==room))return;
    let frame=0, attempts=0;
    const finish=()=>{if(pendingSectionReveal.current===request){pendingSectionReveal.current=null;setSectionReveal(null);}};
    const reveal=()=>{
      if(pendingSectionReveal.current!==request)return;
      if(++attempts>6){finish();return;}
      let target=document.getElementById(targetId);
      if(menu==='Explore' && destination.section==='floor-plan' && destination.room){
        target=floorPlanDetails.current;
        if(target?.dataset.pondsterRoom!==destination.room){frame=requestAnimationFrame(reveal);return;}
      }
      if(!target || !target.getClientRects().length || target.getBoundingClientRect().height<=0){frame=requestAnimationFrame(reveal);return;}
      if(target.tagName==='DETAILS' && !(target as HTMLDetailsElement).open){
        (target as HTMLDetailsElement).open=true;frame=requestAnimationFrame(reveal);return;
      }
      const isGallery=targetId==='design-gallery';
      const heading=isGallery?galleryHeading.current:target;
      if(!heading){finish();return;}
      const visual=isGallery?[...target.querySelectorAll<HTMLElement>('video, img, .empty-gallery')]
        .find(element=>element.getClientRects().length>0 && element.getBoundingClientRect().height>0):undefined;
      const bounds=heading.getBoundingClientRect();
      const headerBottom=stickyHeader.current?.getBoundingClientRect().bottom ?? 0;
      const top=isGallery?getGalleryScrollTop({headingTop:bounds.top,headingBottom:bounds.bottom,
        visualTop:visual?.getBoundingClientRect().top ?? null,
        headerBottom,viewportHeight:window.innerHeight,scrollY:window.scrollY})
        :getSectionRevealTop({targetTop:bounds.top,targetBottom:bounds.bottom,
          headerBottom,viewportHeight:window.innerHeight,scrollY:window.scrollY});
      finish();
      if(top===null)return;
      const reduceMotion=typeof window.matchMedia==='function' && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
      window.scrollTo({top,behavior:reduceMotion?'auto':'smooth'});
    };
    frame=requestAnimationFrame(reveal);
    return()=>cancelAnimationFrame(frame);
  },[menu,room,sectionReveal]);
  async function vote(designId:string) {
    if(saving)return;setSaving(true);setMessage('');
    try { const response=await fetch('/api/votes',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({room,designId})});const data=await response.json() as VoteResults & {error?:string};if(!response.ok)throw new Error(data.error);setResults(data);setRoomTotals(data.roomTotals);setRoomTotalsFailed(false);setFailed(false);setMessage('I’ve saved your choice. Thank you for helping shape my design.'); }
    catch(error){setMessage(error instanceof Error ? error.message : 'I couldn’t save your vote. Please try again.');}
    finally{setSaving(false);}
  }
  function cancelVoiceHover() {
    if(voiceHoverTimer.current!==null){clearTimeout(voiceHoverTimer.current);voiceHoverTimer.current=null;}
  }
  function scheduleVoiceHover() {
    setLogoPlay(value=>value+1);
    cancelVoiceHover();
    voiceHoverTimer.current=setTimeout(()=>{
      voiceHoverTimer.current=null;
      guide.current?.startVoice();
    },500);
  }
  function toggleVoice() {
    cancelVoiceHover();
    guide.current?.activateVoice();
  }
  function selectGallery(nextRoom:string) {
    if(nextRoom===room || !galleries.some(item=>item.id===nextRoom))return;
    pendingSectionReveal.current=null;setSectionReveal(null);
    pendingGalleryScroll.current={room:nextRoom};
    setRoom(nextRoom);
  }
  function navigate(next:Menu){pendingGalleryScroll.current=null;pendingSectionReveal.current=null;setSectionReveal(null);setTourRequest(null);setMenu(next);location.hash=menuHash(next);}
  function openContact(){navigate('Contact');requestAnimationFrame(()=>guide.current?.focusText());}
  function guideAction(action:GuideAction){
    const destination=parsePondsterDestination(action);
    if(!destination)return;
    navigate(action.menu);
    if(action.tour===true&&action.menu==='View'){setTourRequest(++nextTourRequest.current);return;}
    const isPlan=destination.menu==='Explore' && destination.section==='floor-plan';
    if(action.room && !isPlan){
      if(saving && action.menu==='Design')return;
      if(!saving && galleries.some(item=>item.id===action.room))setRoom(action.room);
    }
    if(action.scene)setScene(action.scene);
    if(getPondsterDestinationId(destination)){
      const request={id:++nextSectionReveal.current,destination};
      pendingSectionReveal.current=request;setSectionReveal(request);
    }
  }
  return <>
    <a className="skip" href="#main">Skip to content</a>
    <header ref={stickyHeader} className={`header ${voiceIsLive?'voice-is-live':''}`}><div className="header-brand"><button ref={logo} type="button" className="brand" onClick={toggleVoice} aria-label={voiceSummary.active?'Stop Pondster voice':'Start talking with Pondster'} title={voiceSummary.active?'Click my logo to stop voice.':'Hover or click my logo to talk. Find text and voice controls in Contact.'} aria-pressed={voiceSummary.active} aria-describedby="pondster-header-voice-status" onMouseEnter={scheduleVoiceHover} onMouseLeave={cancelVoiceHover} onFocus={()=>setLogoPlay(value=>value+1)}><PondsterLogoArt key={logoPlay}/><span className="monogram" aria-hidden="true"><span className="monogram-your">Your</span><small>HOME</small></span><span className="brand-copy"><strong className="brand-name">Pondster<span className="signature-i-am" aria-hidden="true">I Am</span></strong><small>{voiceIsLive?"A home You can Relate to - I'm listening!":"A Home You can Relate to. Talk to me!"}</small></span></button><div className={`header-voice-status ${voiceIsLive?'is-active':''}`}><span id="pondster-header-voice-status" aria-live="off">{voiceSummary.status}</span><span className="visually-hidden" role="status" aria-live="polite">{voiceSummary.connecting?"Pondster voice is connecting.":voiceIsLive?"Pondster voice is on.":voiceSummary.status}</span><a href="#contact" onClick={openContact}>Voice controls ↗</a></div></div><nav aria-label="Main menu">{menus.map(item=><a key={item} href={`#${menuHash(item)}`} onClick={()=>navigate(item)} aria-current={menu===item?'page':undefined}>{menuLabel(item)}</a>)}</nav><span className="development">I’M A HOME IN THE MAKING</span></header>
    <main id="main">
      {menu==='Design' && <>
        <section id="pondster-design-overview" className="intro"><div><h1>Virtually - A Reality <br className="design-title-break"/><em>Have a say.</em></h1></div><div className="intro-note"><p>I will bring each space to life. Browse my designs, vote for the ones you love, and help me choose the finishes that feel right.</p><span>Explore my {galleries.length} galleries.</span></div></section>
        <section className="pondster-welcome" aria-label="Meet Pondster"><div><p>I’m Pondster, the voice and persona of this house. Ask me about the design ideas and follow my story as it takes shape. My location is confidential for now—think witness protection, with better curb appeal. Jean Wright is my SI designer.</p></div><button onClick={openContact}>Talk to me <span aria-hidden="true">↗</span></button></section>
        <section className="design-workspace" aria-label="My design galleries"><aside className="room-nav"><p className="eyebrow">EXPLORE MY ROOMS</p><div role="group" aria-label="Rooms">{galleries.map((item,index)=>{const total=roomTotals[item.id] ?? (item.designs.length===0?0:undefined);return <button key={item.id} onClick={()=>{if(!saving)selectGallery(item.id);}} disabled={saving} aria-pressed={room===item.id} aria-controls="design-gallery"><span className="room-number">0{index+1}</span><span>{item.name}<small>{item.designs.length?`${item.designs.length} ${item.designs.length===1?'design':'designs'}`:'Coming soon'}</small><span className="room-vote-count" title={roomTotalsFailed && total!==undefined?'Last loaded vote count; I couldn’t refresh it.':undefined}>{total!==undefined?`${total} ${total===1?'vote':'votes'} cast`:roomTotalsLoading?'Loading votes…':'Votes unavailable'}</span></span><b aria-hidden="true">↗</b></button>;})}</div><div className="notebook-note"><span>MY FUTURE, IN DESIGN.</span><p>I use AI concepts to show my future features. These aren’t measured plans or photos of my completed spaces.</p></div></aside>
        <div ref={galleryArea} id="design-gallery" className="gallery-area" role="region" aria-labelledby="design-gallery-title"><div ref={galleryHeading} className="gallery-heading"><div><p className="eyebrow">DESIGN GALLERY / {String(galleries.indexOf(gallery)+1).padStart(2,'0')}</p><h2 id="design-gallery-title">{gallery.name}</h2><p>{gallery.summary}</p></div>{gallery.designs.length>0 && <span className="vote-total">{loading?'I’m loading votes…':failed?'I can’t load totals':`${results.total} ${results.total===1?'vote':'votes'}`}<small>COMMUNITY PREFERENCES</small></span>}</div>
        {room==='media-center' && <figure className="media-feature"><div className="media-feature-intro"><div><p className="eyebrow">MY LIVING ROOM / IN MOTION</p><h3>Watch me go from art to game time.</h3></div><span>MY 10-SECOND CONCEPT FILM</span></div><ScrollVideo label="My Living Room" ratio="16 / 9"><video controls autoPlay muted playsInline loop preload="metadata" poster="/media/media-center-art-poster.png" aria-label="My illustrative Living Room film shows my TV turning toward my kitchen; my selected MM-MAX1 mount will be positioned manually" aria-describedby="media-motion-caption"><source src="/media/media-center-kitchen-view.mp4" type="video/mp4"/>Your browser can’t play my video here. <a href="/media/media-center-kitchen-view.mp4">Open my video file</a>.</video></ScrollVideo><figcaption id="media-motion-caption"><span>MY AI MOTION CONCEPT</span>I will feature my selected manual MM-MAX1 TV mount, positioned by hand. My illustrative AI film keeps my decorative frame fixed while my TV turns toward my kitchen and its artwork becomes moving football. The automatic motion is illustrative; my selected mount’s fit and clearances still need validation.<p className="media-source">Football footage: U.S. Marine Corps / Sgt. James Stanfield, via <a href="https://www.dvidshub.net/video/947000/125th-army-navy-football-game-b-roll" target="_blank" rel="noopener noreferrer">DVIDS</a>.<br/>The appearance of U.S. Department of War (DoW) visual information does not imply or constitute DoW endorsement. <a href="https://www.dvidshub.net/about/copyright" target="_blank" rel="noopener noreferrer">Source use notice ↗</a></p></figcaption></figure>}
        {room==='spiral-staircase' && <TheaterMotion/>}
        {room==='garage-barn-door' && <figure className="media-feature garage-media-feature">
          <div className="media-feature-intro"><div><p className="eyebrow">MY GARAGE BARN DOOR / IN MOTION</p><h3>Watch me open up.</h3></div><span>MY 25-SECOND CONCEPT FILM</span></div>
          <ScrollVideo label="My Garage Barn Door" ratio="5 / 2"><video controls autoPlay muted playsInline loop preload="metadata" poster="/media/garage-barn-door-drive-out-poster.jpg" aria-label="My garage barn-door concept: my center entry section swings inward, my full door slides left, and a white Tesla drives out to reveal my white-marble garage floor" aria-describedby="garage-motion-caption">
            <source src="/media/garage-barn-door-tesla-drive-out.mp4" type="video/mp4"/>Your browser can’t play my video here. <a href="/media/garage-barn-door-tesla-drive-out.mp4">Open my video file</a>.
          </video></ScrollVideo>
          <figcaption id="garage-motion-caption"><span>MY AI MOTION CONCEPT</span>I will feature a center entry section that swings inward and closes before my full door slides left. My film shows a white Tesla driving out and across the scene to the left, leaving my white-marble garage floor in view. This is my illustrative AI/composited concept; my hardware, clearances, and the car’s turning path haven’t been validated.</figcaption>
        </figure>}
        {gallery.designs.length ? <><div className={`design-grid ${gallery.designs.length===1?'single':gallery.designs.length===2?'pair':''}`}>{gallery.designs.map((design,index)=>{const votes=results.scores[design.id]??0;const percent=results.total?Math.round(votes/results.total*100):0;const chosen=results.selected===design.id;return <article key={design.id} aria-labelledby={`vote-title-${design.id}`} className={`design-card ${chosen?'chosen':''} ${design.fullImage?'full-scene':''}`}><button className={`vote-button ${chosen?'selected':''}`} disabled={saving||loading||failed||chosen} aria-pressed={chosen} onClick={()=>vote(design.id)}><span className="vote-button-copy"><strong id={`vote-title-${design.id}`}>{design.title}</strong><small>{saving?'I’m saving…':chosen?'✓ Your choice':results.selected?'Change your vote':'Vote for my design'}</small></span><span className="vote-button-icon" aria-hidden="true">{chosen?'':'♡'}</span></button><DesignCardImages design={design} onOpen={setZoom} priority={index<3}/><div className="card-content"><span className="option-label">CONCEPT {String(index+1).padStart(2,'0')}</span><p>{design.detail}</p><div className="result-line"><span>{loading?'I’m loading…':failed?'I can’t load totals':`${votes} ${votes===1?'vote':'votes'}`}</span><span>{!loading&&!failed?`${percent}%`:''}</span></div><div className="result-track" aria-hidden="true"><i style={{width:`${percent}%`}} /></div></div></article>;})}</div><p className="vote-explainer">I don’t ask you to sign in. I keep one current choice per gallery in this browser; pick another design to change it. Other browsers or cleared cookies can vote again. I use votes as preferences, not final selections.</p><div className="vote-feedback" role="status" aria-live="polite">{message}{failed && <button className="text-button" onClick={()=>setRetry(retry+1)}>Try again</button>}</div></> : <div className="empty-gallery"><span className="empty-icon" aria-hidden="true">▧</span><p className="eyebrow">MY DESIGNS WILL FOLLOW</p><h3>I will add designs for my {gallery.name}.</h3><p>My design images will appear here. You will be able to browse my options and vote for your favorite.</p><span className="pending-tag">My images are coming</span></div>}

        </div></section>
        <section className="design-footer"><span>MY DESIGN IS A CONVERSATION.</span><p>Come back as I add new rooms and choices.</p><span>MY LOCATION IS CONFIDENTIAL</span></section>
      </>}
      {menu==='Explore' && <ExplorePage scene={scene} onScene={setScene} floorPlanRequest={sectionReveal?.destination.menu==='Explore' && sectionReveal.destination.section==='floor-plan' && sectionReveal.destination.room?{id:sectionReveal.id,room:sectionReveal.destination.room}:undefined} floorPlanDetailRef={floorPlanDetails}/>}
      {menu==='View' && <ViewPage tourRequest={tourRequest} onTourRequestHandled={()=>setTourRequest(null)} onImage={setZoom} onDesign={()=>navigate('Design')} onTourStart={()=>guide.current?.stopVoice()}/>}
      {menu==='Built By' && <BuiltByPage/>}
      {menu==='Own' && <section className="secondary-page manage"><h1 className="single-line-page-title">I come <em>with answers.</em></h1><p className="lead">I will provide a place for my home guides, care information, and handover records. Ask me from any page for public guidance while my owner tools take shape.</p><article id="pondster-own-drawing" className="manage-notice" aria-labelledby="deck-structural-heading"><h2 id="deck-structural-heading">My preliminary deck structural drawing</h2><p>I’m sharing my deck’s preliminary structural design reference. The drawing is marked <strong>PRELIMINARY / NOT FOR PERMIT</strong> and remains a design reference for review.</p><p><a className="solid-link" href="/documents/deck-structural-preliminary.pdf" target="_blank" rel="noopener noreferrer">View my drawing (PDF) ↗</a></p><a href="/documents/deck-structural-preliminary.pdf" download="deck-structural-preliminary.pdf">Download my drawing (PDF)</a></article><div className="knowledge-grid">{[['guides','Home guides','How my systems will work and where you will find them.'],['maintenance','Care & maintenance','My manuals, warranties, and equipment-specific schedules.'],['handover','Owner handover','My records and account checklist for the next chapter.']].map(([section,title,description])=><article id={`pondster-own-${section}`} key={section}><span className="pending-tag">PLANNED</span><h3>{title}</h3><p>{description}</p></article>)}</div><div className="manage-notice"><strong>My owner tools aren’t ready yet.</strong><p>I’ll need separate, authenticated owner access before I can show private records or offer live controls. I’m not connected to my house systems through this public site.</p></div></section>}
      <ContactPage active={menu==='Contact'} comments={menu==='Contact'?<Comments key={menu} page="contact" title="Contact" onAsk={openContact}/>:null}><PondsterGuide ref={guide} open={menu==='Contact'} onOpenChange={nextOpen=>nextOpen?openContact():navigate('View')} onAction={guideAction} onReturnFocus={()=>logo.current?.focus()} onVoiceState={setVoiceSummary}/></ContactPage>
      {menu!=='Contact'&&<Comments key={menu} page={menu==='Own'?'own':menuHash(menu)} title={menuLabel(menu)} onAsk={openContact}/>}
    </main><footer><span>MY LOCATION IS CONFIDENTIAL</span><p>My SI designer: Jean Wright · Buy Your Home</p><span>I’m sharing concepts · No live controls</span></footer>
    <GalleryImageViewer design={zoom} onChange={setZoom} onClose={()=>setZoom(null)}/>
  </>;
}
