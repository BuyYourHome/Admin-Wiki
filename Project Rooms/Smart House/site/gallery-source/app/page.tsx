'use client';
import { useEffect, useRef, useState } from 'react';
import { galleries, allDesigns, type Design } from '../lib/designs';

type VoteResults = { scores:Record<string,number>; total:number; selected:string|null };
const empty:VoteResults = {scores:{},total:0,selected:null};
const menus = ['Design','Explore','View','Manage'] as const;
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
  const dialog = useRef<HTMLDialogElement>(null);
  const gallery = galleries.find(gallery => gallery.id === room)!;
  useEffect(() => {
    const sync = () => { const value = location.hash.slice(1).toLowerCase(); const next = menus.find(item => item.toLowerCase() === value); if(next) setMenu(next); };
    sync(); window.addEventListener('hashchange',sync); return () => window.removeEventListener('hashchange',sync);
  },[]);
  useEffect(() => {
    const controller = new AbortController();
    setLoading(true);setMessage('');setFailed(false);setResults(empty);
    if (!gallery.designs.length) {setLoading(false);return () => controller.abort();}
    fetch(`/api/votes?room=${encodeURIComponent(room)}`,{cache:'no-store',signal:controller.signal}).then(async response => {const data=await response.json() as VoteResults & {error?:string};if(!response.ok)throw new Error(data.error);return data;}).then(data=>setResults(data)).catch(error=>{if(error.name!=='AbortError'){setMessage('Vote totals are unavailable right now.');setFailed(true);}}).finally(()=>{if(!controller.signal.aborted)setLoading(false);});
    return () => controller.abort();
  },[room,retry]);
  useEffect(() => {if(zoom && !dialog.current?.open)dialog.current?.showModal();if(!zoom && dialog.current?.open)dialog.current.close();},[zoom]);
  async function vote(designId:string) {
    if(saving)return;setSaving(true);setMessage('');
    try { const response=await fetch('/api/votes',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({room,designId})});const data=await response.json() as VoteResults & {error?:string};if(!response.ok)throw new Error(data.error);setResults(data);setFailed(false);setMessage('Your choice is saved. Thank you for helping shape Pond Street.'); }
    catch(error){setMessage(error instanceof Error ? error.message : 'Your vote could not be saved. Please try again.');}
    finally{setSaving(false);}
  }
  function navigate(next:Menu){setMenu(next);}
  return <>
    <a className="skip" href="#main">Skip to content</a>
    <header className="header"><a className="brand" href="#design" onClick={()=>navigate('Design')} aria-label="Pond Street home"><span className="monogram">P<small>908</small></span><span>POND STREET<small>A home, thoughtfully connected.</small></span></a><nav aria-label="Main menu">{menus.map(item=><a key={item} href={`#${item.toLowerCase()}`} onClick={()=>navigate(item)} aria-current={menu===item?'page':undefined}>{item}</a>)}</nav><span className="development">A HOME IN THE MAKING</span></header>
    <main id="main">
      {menu==='Design' && <>
        <section className="intro"><div><p className="eyebrow">908 POND STREET / THE DESIGN NOTEBOOK</p><h1>A home takes shape.<br/><em>Have a say.</em></h1></div><div className="intro-note"><p>Good design starts with possibilities. Explore the ideas for each space and vote for the ones you love.</p><span>Six galleries. One evolving home.</span></div></section>
        <section className="design-workspace" aria-label="Design galleries"><aside className="room-nav"><p className="eyebrow">CHOOSE A GALLERY</p><div role="group" aria-label="Rooms">{galleries.map((item,index)=><button key={item.id} onClick={()=>{if(!saving)setRoom(item.id);}} disabled={saving} aria-pressed={room===item.id}><span className="room-number">0{index+1}</span><span>{item.name}<small>{item.designs.length?`${item.designs.length} ${item.designs.length===1?'design':'designs'}`:'Coming soon'}</small></span><b aria-hidden="true">↗</b></button>)}</div><div className="notebook-note"><span>THESE ARE IDEAS, NOT PROMISES.</span><p>AI visual concepts help us explore a direction. They are not measured plans or photographs of completed work.</p></div></aside>
        <div className="gallery-area"><div className="gallery-heading"><div><p className="eyebrow">DESIGN GALLERY / {String(galleries.indexOf(gallery)+1).padStart(2,'0')}</p><h2>{gallery.name}</h2><p>{gallery.summary}</p></div>{gallery.designs.length>0 && <span className="vote-total">{loading?'Loading votes…':failed?'Totals unavailable':`${results.total} ${results.total===1?'vote':'votes'}`}<small>COMMUNITY PREFERENCES</small></span>}</div>
        {gallery.designs.length ? <><div className={`design-grid ${gallery.designs.length===1?'single':gallery.designs.length===2?'pair':''}`}>{gallery.designs.map((design,index)=>{const votes=results.scores[design.id]??0;const percent=results.total?Math.round(votes/results.total*100):0;const chosen=results.selected===design.id;return <article key={design.id} className={`design-card ${chosen?'chosen':''}`}><button className="image-open" onClick={()=>setZoom(design)} aria-label={`Enlarge ${design.title}`}><img src={`/concepts/${design.image}`} alt={`AI design concept: ${design.title}`} loading={index < 3 ? "eager" : "lazy"} decoding="async" /><span>VIEW FULL IMAGE ↗</span></button><div className="card-content"><span className="option-label">CONCEPT {String(index+1).padStart(2,'0')}</span><h3>{design.title}</h3><p>{design.detail}</p><div className="result-line"><span>{loading?'Loading…':failed?'Totals unavailable':`${votes} ${votes===1?'vote':'votes'}`}</span><span>{!loading&&!failed?`${percent}%`:''}</span></div><div className="result-track" aria-hidden="true"><i style={{width:`${percent}%`}} /></div><button className={`vote-button ${chosen?'selected':''}`} disabled={saving||loading||failed||chosen} onClick={()=>vote(design.id)}>{saving?'Saving…':chosen?'✓ Your choice':results.selected?'Change my vote':'Vote for this design'}<span aria-hidden="true">{chosen?'':'♡'}</span></button></div></article>;})}</div><p className="vote-explainer">No sign-in needed. One current choice per gallery in this browser; choose another design to change your vote. Other browsers or cleared cookies can vote again. Votes show preferences, not final selections.</p><div className="vote-feedback" role="status" aria-live="polite">{message}{failed && <button className="text-button" onClick={()=>setRetry(retry+1)}>Try again</button>}</div></> : <div className="empty-gallery"><span className="empty-icon" aria-hidden="true">▧</span><p className="eyebrow">A BLANK PAGE, FOR NOW</p><h3>{gallery.name} designs are coming.</h3><p>Once design images are added, you’ll be able to browse the options and vote for your favorite here.</p><span className="pending-tag">Awaiting design images</span></div>}
        </div></section>
        <section className="design-footer"><span>DESIGN IS A CONVERSATION.</span><p>Come back as new rooms and choices take shape.</p><span>908 / POND STREET</span></section>
      </>}
      {menu==='Explore' && <section className="secondary-page"><p className="eyebrow">EXPLORE / THE CONNECTED HOUSE</p><h1>Get to know<br/><em>the possibilities.</em></h1><p className="lead">A simple illustration of how light can change the feeling of a space.</p><div className="explore-demo"><div className={`illustrated-room ${scene}`} aria-label={`Illustrative room with ${scene} lighting`} role="img"><div className="window"/><div className="lamp"/><div className="sofa"/><span>ILLUSTRATIVE SPACE · SIMULATION ONLY</span></div><div className="scene-options"><p className="eyebrow">TRY A LIGHTING MOOD</p>{[['day','Daylight'],['evening','Evening'],['relax','Unwind']].map(([id,label])=><button key={id} onClick={()=>setScene(id)} aria-pressed={scene===id}>{label}<span>↗</span></button>)}<p role="status">{scene==='day'?'Bright and neutral.':scene==='evening'?'A warmer end to the day.':'Soft light for a quiet moment.'}</p><small>This demonstration does not control the house.</small></div></div><div className="knowledge-grid">{[['Lighting','Zones, scenes, and everyday controls.'],['Climate & comfort','Operating guides and equipment-specific care.'],['Sound & screens','Connected experiences, explained.']].map(([title,description])=><article key={title}><h3>{title}</h3><p>{description}</p><small>Details to follow verified house records.</small></article>)}</div></section>}
      {menu==='View' && <section className="secondary-page"><p className="eyebrow">VIEW / THE VISUAL NOTEBOOK</p><h1>See the<br/><em>ideas together.</em></h1><p className="lead">Available interior and exterior visual concepts. These are AI design studies, not completed-work photographs.</p><div className="visual-grid">{allDesigns.map(design=><article key={design.id}><button className="image-open" onClick={()=>setZoom(design)} aria-label={`Enlarge ${design.title}`}><img src={`/concepts/${design.image}`} alt={`AI design concept: ${design.title}`} loading="lazy" decoding="async"/><span>VIEW FULL IMAGE ↗</span></button><p className="eyebrow">{design.room}</p><h3>{design.title}</h3></article>)}</div><a className="solid-link" href="#design" onClick={()=>navigate('Design')}>Compare and vote in Design ↗</a></section>}
      {menu==='Manage' && <section className="secondary-page manage"><p className="eyebrow">MANAGE / THE FUTURE OWNER EXPERIENCE</p><h1>A house that<br/><em>comes with answers.</em></h1><p className="lead">A future place for the information that belongs with the home.</p><div className="knowledge-grid">{[['Home guides','How each system works and where to find it.'],['Care & maintenance','Manuals, warranties, and equipment-specific schedules.'],['Owner handover','The records and account checklist for the next chapter.']].map(([title,description])=><article key={title}><span className="pending-tag">PLANNED</span><h3>{title}</h3><p>{description}</p></article>)}</div><div className="manage-notice"><strong>Owner tools are not available yet.</strong><p>Private records and live controls will need separate, authenticated owner access. This public page does not connect to house systems.</p></div></section>}
    </main><footer><span>908 POND STREET</span><p>A home in the making · Buy Your Home</p><span>Design concepts · No live device connections</span></footer>
    <dialog ref={dialog} onCancel={()=>setZoom(null)} onClose={()=>setZoom(null)} className="lightbox">{zoom && <><button className="close-zoom" onClick={()=>setZoom(null)} aria-label="Close image">Close ×</button><img src={`/concepts/${zoom.image}`} alt={`AI design concept: ${zoom.title}`}/><div><h2>{zoom.title}</h2><p>AI visual concept · Not a measured plan or completed-work photograph.</p></div></>}</dialog>
  </>;
}
