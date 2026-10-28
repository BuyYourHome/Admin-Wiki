import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { stripTypeScriptTypes } from 'node:module';
import { galleries } from '../lib/designs.ts';
import { floorPlanRooms } from '../lib/floor-plan.ts';
import { houseFeatures } from '../lib/features.js';
import { getGalleryScrollTop, getSectionRevealTop } from '../lib/gallery-scroll.ts';
import { parsePondsterDestination, getPondsterDestinationId, DESTINATION_SECTIONS } from '../lib/pondster-destinations.ts';
import { galleryVoiceSelection } from '../lib/pondster-gallery.ts';

const source=await readFile(new URL('../app/page.tsx',import.meta.url),'utf8');
const oversized={targetTop:580,targetBottom:1840,headerBottom:192,viewportHeight:710,scrollY:500};
assert.equal(getSectionRevealTop(oversized),876,'A partially visible oversized voice target aligns 12px beneath the measured header.');
assert.equal(getSectionRevealTop({...oversized,targetTop:204,targetBottom:1464}),null,'An oversized target already aligned below the header stays still.');
assert.equal(getSectionRevealTop({...oversized,targetTop:260,targetBottom:500}),null,'A fully visible small voice target stays still.');
assert.equal(getSectionRevealTop({...oversized,targetTop:NaN}),null);
assert.equal(getSectionRevealTop({...oversized,headerBottom:720}),null);
const handler=source.match(/  function guideAction\(action:GuideAction\)\{[\s\S]*?\n  \}/)?.[0];
assert.ok(handler,'Exercise the real UI action handler.');
function actionHarness(saving=false){
  const navigation=[],rooms=[],scenes=[],requests=[],tours=[],pictures=[];
  const pending={current:null},next={current:0},nextTour={current:0};
  const run=new Function('parsePondsterDestination','navigate','setTourRequest','nextTourRequest','saving','galleries','setRoom','setScene','getPondsterDestinationId','nextSectionReveal','pendingSectionReveal','setSectionReveal','galleryVoiceSelection','setZoom','zoom','room',
    stripTypeScriptTypes(handler)+'\nreturn guideAction;')(
    parsePondsterDestination,menu=>{navigation.push(menu);pending.current=null;},id=>tours.push(id),nextTour,saving,galleries,
    room=>rooms.push(room),scene=>scenes.push(scene),getPondsterDestinationId,next,pending,request=>requests.push(request),galleryVoiceSelection,design=>pictures.push(design),null,'media-center');
  return{run,navigation,rooms,scenes,requests,tours,pictures,pending};
}
{
  const h=actionHarness();h.run({menu:'Contact',section:'gc'});h.run({menu:'Contact',section:'gc'});
  assert.deepEqual(h.navigation,['Contact','Contact']);
  assert.deepEqual(h.requests.map(request=>request.id),[1,2],'Same-page, same-card requests get distinct reveal intent.');
  assert.equal(getPondsterDestinationId(h.pending.current.destination),'pondster-contact-gc');
  assert.notEqual(h.requests[0],h.requests[1]);
  h.run({menu:'Contact',section:'#arbitrary-selector'});h.run({menu:'Contact',section:'gc',room:'private'});
  assert.equal(h.navigation.length,2,'Malformed actions cannot navigate or supply selectors.');
}
{
  const h=actionHarness();h.run({menu:'Design',section:'gallery',room:'media-center'});
  h.run({menu:'Design',section:'gallery',room:'media-center'});
  assert.deepEqual(h.rooms,['media-center','media-center']);
  assert.deepEqual(h.requests.map(request=>request.id),[1,2],'A voice repeat reveals the current gallery without requiring a room-state change.');
  assert.equal(getPondsterDestinationId(h.pending.current.destination),'design-gallery');
  assert.equal(h.pictures[0].id,galleries.find(item=>item.id==='media-center').designs[0].id,'A guided gallery opens its first actual choice.');
  const busy=actionHarness(true);busy.run({menu:'Design',section:'gallery',room:'master-bath'});
  assert.deepEqual(busy.rooms,[]);assert.deepEqual(busy.requests,[],'A vote in flight still prevents a gallery switch.');
}
{
  const h=actionHarness();h.run({menu:'Explore',section:'floor-plan',room:'pantry'});
  assert.deepEqual(h.rooms,[],'Floor-plan room IDs never change the design/voting gallery.');
  assert.equal(h.pending.current.destination.room,'pantry');
  h.run({menu:'Explore',scene:'evening'});
  assert.deepEqual(h.scenes,['evening']);assert.equal(getPondsterDestinationId(h.pending.current.destination),'pondster-explore-lighting');
}
{
  const h=actionHarness();h.run({menu:'View',section:'tour',tour:true});
  assert.deepEqual(h.tours,[1]);assert.deepEqual(h.requests,[],'Tour start remains the separate one-shot action, with no competing background reveal.');
  h.run({menu:'View',section:'tour'});assert.equal(h.requests.length,1);assert.deepEqual(h.tours,[1],'Showing the invitation alone cannot start playback.');
}

const marker=source.indexOf('    const request=sectionReveal;');
const prefix='  useEffect(() => {';
const effectStart=source.lastIndexOf(prefix,marker),effectEnd=source.indexOf('  },[menu,room,sectionReveal]);',marker);
assert.ok(marker>=0 && effectStart>=0 && effectEnd>marker);
const effect=stripTypeScriptTypes('function revealEffect(){'+source.slice(effectStart+prefix.length,effectEnd)+'\n}');
const runEffect=new Function('sectionReveal','pendingSectionReveal','menu','room','getPondsterDestinationId','requestAnimationFrame','cancelAnimationFrame','document','floorPlanDetails','galleryHeading','stickyHeader','window','getGalleryScrollTop','getSectionRevealTop','setSectionReveal',effect+'\nreturn revealEffect();');
function revealHarness(destination={menu:'Contact',section:'gc'},{reduce=false,visible=false,details=false,planReady=true}={}){
  const request={id:1,destination},pending={current:request},jobs=new Map(),scrolls=[],finished=[],reads=[];
  let next=0,focusCalls=0,clickCalls=0;
  const metrics={top:visible?300:900,bottom:visible?600:1200,header:200,scrollY:500,height:844};
  const target={tagName:details?'DETAILS':'ARTICLE',open:false,dataset:{pondsterRoom:planReady?destination.room:'living-room'},
    getClientRects:()=>[{}],getBoundingClientRect:()=>{reads.push('target');return{top:metrics.top,bottom:metrics.bottom,height:metrics.bottom-metrics.top};},
    querySelectorAll:()=>[],focus(){focusCalls++;},click(){clickCalls++;}};
  const outer={...target,getBoundingClientRect(){throw new Error('A requested plan room must reveal its selected detail, not the outer plan.');}};
  const targetId=getPondsterDestinationId(destination);
  const document={getElementById(id){assert.equal(id,targetId,'Only the fixed shared-mapper ID is looked up.');return destination.section==='floor-plan'&&destination.room?outer:target;}};
  const window={get innerHeight(){return metrics.height;},get scrollY(){return metrics.scrollY;},
    matchMedia(query){assert.equal(query,'(prefers-reduced-motion: reduce)');return{matches:reduce};},scrollTo:value=>scrolls.push(value)};
  const run=(current=request,menu=destination.menu,room=destination.room??'media-center')=>runEffect(current,pending,menu,room,getPondsterDestinationId,
    fn=>{const id=++next;jobs.set(id,fn);return id;},id=>jobs.delete(id),document,{current:target},{current:target},
    {current:{getBoundingClientRect:()=>({bottom:metrics.header})}},window,getGalleryScrollTop,getSectionRevealTop,value=>finished.push(value));
  const flush=()=>{for(const[id,fn]of[...jobs]){jobs.delete(id);fn();}};
  const drain=()=>{let count=0;while(jobs.size){assert.ok(++count<=8,'Readiness retries stay bounded.');flush();}return count;};
  return{request,pending,jobs,scrolls,finished,metrics,target,reads,run,flush,drain,focusCalls:()=>focusCalls,clickCalls:()=>clickCalls};
}
{
  const h=revealHarness();h.run();h.metrics.header=245;h.drain();
  assert.deepEqual(h.scrolls,[{top:1143,behavior:'smooth'}],'The GC card is measured after the sticky header finishes wrapping.');
  assert.equal(h.pending.current,null);assert.deepEqual(h.finished,[null]);
  assert.equal(h.focusCalls(),0);assert.equal(h.clickCalls(),0,'Reveals neither steal focus nor activate links.');
  h.run(null);h.drain();assert.equal(h.scrolls.length,1,'Initial, vote and result renders without new intent never replay a reveal.');
}
{
  const h=revealHarness(undefined,{visible:true});h.run();h.drain();assert.deepEqual(h.scrolls,[],'An already visible card stays still.');
  const reduced=revealHarness(undefined,{reduce:true});reduced.run();reduced.drain();assert.equal(reduced.scrolls[0].behavior,'auto');
}
{
  for(const destination of [{menu:'Explore',section:'floor-plan',room:'pantry'},{menu:'Explore',section:'room',room:'master-bath'}]){
    const h=revealHarness(destination,{details:destination.section==='room'});
    Object.assign(h.metrics,{top:580,bottom:1840,header:192,height:710});h.run();h.drain();
    assert.deepEqual(h.scrolls,[{top:876,behavior:'smooth'}],'An oversized selected plan detail or room card near the bottom must reveal its top.');
    const aligned=revealHarness(destination,{details:destination.section==='room'});
    Object.assign(aligned.metrics,{top:204,bottom:1464,header:192,height:710});aligned.run();aligned.drain();
    assert.deepEqual(aligned.scrolls,[],'An already aligned oversized plan detail or room card must not jump again.');
  }
  const gallery=revealHarness({menu:'Design',section:'gallery',room:'media-center'});
  Object.assign(gallery.metrics,{top:580,bottom:1840,header:192,height:710});gallery.run();gallery.drain();
  assert.deepEqual(gallery.scrolls,[],'Design gallery reveals retain their existing heading/visual geometry.');
}
{
  const h=revealHarness({menu:'Explore',section:'room',room:'master-bath'},{details:true});
  h.run();h.flush();assert.equal(h.target.open,true);assert.deepEqual(h.scrolls,[],'Expand the requested native details before measuring its contents.');
  h.flush();assert.equal(h.scrolls.length,1);assert.equal(h.focusCalls(),0);
}
{
  const h=revealHarness({menu:'Explore',section:'floor-plan',room:'pantry'},{planReady:false});
  const cleanup=h.run();h.flush();assert.deepEqual(h.reads,[]);assert.deepEqual(h.scrolls,[],'Do not measure stale Living Room details for a pantry request.');
  h.target.dataset.pondsterRoom='pantry';h.flush();assert.equal(h.scrolls.length,1);cleanup();
  const waiting=revealHarness({menu:'Explore',section:'floor-plan',room:'pantry'},{planReady:false});
  const cancel=waiting.run();waiting.flush();cancel();assert.equal(waiting.jobs.size,0,'Cleanup cancels the latest readiness RAF, not only the first frame.');
  const missing=revealHarness({menu:'Explore',section:'floor-plan',room:'pantry'},{planReady:false});missing.run();
  assert.equal(missing.drain(),7);assert.equal(missing.pending.current,null);assert.deepEqual(missing.scrolls,[],'An unready target expires without measuring or jumping elsewhere.');
}
{
  const h=revealHarness();h.run();const newer={id:2,destination:{menu:'Contact',section:'hvac'}};h.pending.current=newer;h.flush();
  assert.deepEqual(h.scrolls,[]);assert.equal(h.pending.current,newer,'Stale work cannot consume a newer request.');
  const away=revealHarness();const cleanup=away.run();away.pending.current=null;cleanup();away.flush();assert.deepEqual(away.scrolls,[],'Navigation/unmount cancels pending reveal work.');
}
assert.ok(!effect.includes('.focus(') && !effect.includes('.click('));
assert.ok(!source.includes('setShowLighting'),'Lighting uses this reveal path instead of a competing focus/scroll effect.');
assert.match(source,/pendingSectionReveal.current=null;setSectionReveal\(null\);setTourRequest\(null\);setMenu\(next\)/);

const files=Object.fromEntries(await Promise.all(['contact-page','explore-page','interactive-floor-plan','view-page','built-by-page'].map(async name=>[name,await readFile(new URL('../app/'+name+'.tsx',import.meta.url),'utf8')])));
for(const id of ['pondster-design-overview','pondster-own-drawing'])assert.ok(source.includes('id="'+id+'"'));
for(const section of ['guides','maintenance','handover'])assert.ok(source.includes("['"+section+"',"));
assert.ok(source.includes('id={`pondster-own-${section}`}'));
for(const id of ['ashley','company','trades','voice'])assert.ok(files['contact-page'].includes('id="pondster-contact-'+id+'"'));
assert.ok(files['contact-page'].includes("id={`pondster-contact-${id==='general-contractor'?'gc':id}`}"));
for(const id of ['tour','ashley','viewing','notebook'])assert.ok(files['view-page'].includes('id="pondster-view-'+id+'"'));
for(const id of ['company','contact'])assert.ok(files['built-by-page'].includes('id="pondster-built-by-'+id+'"'));
for(const id of ['house','rooms','lighting'])assert.ok(files['explore-page'].includes('id="pondster-explore-'+id+'"'));
assert.match(files['explore-page'],/<details id=\{`pondster-explore-room-\$\{gallery.id\}`\}/);
const featureDeclaration=files['explore-page'].match(/const featureSections:Record<string,string> = \{[\s\S]*?\n\};/)?.[0];assert.ok(featureDeclaration);
const features=new Function(stripTypeScriptTypes(featureDeclaration)+';return featureSections;')();
for(const feature of houseFeatures){assert.ok(DESTINATION_SECTIONS.Explore.includes(features[feature.title]),'Every published house-feature card has a fixed allowed destination.');}
const planSource=files['interactive-floor-plan'];
assert.match(planSource,/id="pondster-explore-floor-plan"/);assert.match(planSource,/data-pondster-room=\{selectedRoom.id\}/);
const selectionBody=planSource.match(/  useEffect\(\(\) => \{([\s\S]*?)\n  \},\[roomRequest\?\.id,roomRequest\?\.room\]\);/)?.[1];assert.ok(selectionBody);
const chooseRequested=new Function('roomRequest','floorPlanRooms','setSelectedId',selectionBody),selected=[];
chooseRequested({id:1,room:'pantry'},floorPlanRooms,room=>selected.push(room));
chooseRequested({id:2,room:'pantry'},floorPlanRooms,room=>selected.push(room));
chooseRequested({id:3,room:'private-room'},floorPlanRooms,room=>selected.push(room));
assert.deepEqual(selected,['pantry','pantry'],'Valid repeated plan requests select before reveal; unknown room IDs do not alter selection.');
assert.match(source,/floorPlanRequest=\{sectionReveal\?\.destination.menu==='Explore'/);
assert.match(files['explore-page'],/roomRequest=\{floorPlanRequest\} detailRef=\{floorPlanDetailRef\}/);
console.log('PASS: precise fixed destinations, repeated same-target/gallery requests, GC card/header geometry, native details expansion, committed plan-room readiness, reduced motion, visible no-op, stale cleanup, focus preservation and independent tour one-shot; no browser/network.');
