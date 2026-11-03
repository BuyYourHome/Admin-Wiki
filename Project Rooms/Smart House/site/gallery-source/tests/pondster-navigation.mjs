import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { createRequire, stripTypeScriptTypes } from 'node:module';
import ts from 'typescript';
import { galleries } from '../lib/designs.ts';
import { floorPlanRooms } from '../lib/floor-plan.ts';
import { floorPlanCameras } from '../lib/floor-plan-cameras.ts';
import { houseFeatures, roomFeatures } from '../lib/features.js';
import { getGalleryScrollTop, getSectionRevealTop } from '../lib/gallery-scroll.ts';
import { parsePondsterDestination, getPondsterDestinationId, DESTINATION_SECTIONS } from '../lib/pondster-destinations.ts';
import { galleryVoiceSelection } from '../lib/pondster-gallery.ts';
import { equipmentManuals } from '../lib/equipment.ts';
import { answerPondster } from '../lib/pondster-guide.ts';
import { designImageSource } from '../lib/design-views.ts';
import { getExploreFeatureDestination } from '../lib/explore-feature-destinations.ts';

const source=await readFile(new URL('../app/page.tsx',import.meta.url),'utf8');
const oversized={targetTop:580,targetBottom:1840,headerBottom:192,viewportHeight:710,scrollY:500};
assert.equal(getSectionRevealTop(oversized),876,'A partially visible oversized voice target aligns 12px beneath the measured header.');
assert.equal(getSectionRevealTop({...oversized,targetTop:204,targetBottom:1464}),null,'An oversized target already aligned below the header stays still.');
assert.equal(getSectionRevealTop({...oversized,targetTop:260,targetBottom:500}),null,'A fully visible small voice target stays still.');
assert.equal(getSectionRevealTop({...oversized,targetTop:NaN}),null);
assert.equal(getSectionRevealTop({...oversized,headerBottom:720}),null);
const handler=source.match(/  function guideAction\(action:GuideAction\)[^{]*\{[\s\S]*?\n  \}/)?.[0];
assert.ok(handler,'Exercise the real UI action handler.');
function actionHarness(saving=false){
  const navigation=[],rooms=[],scenes=[],requests=[],tours=[],pictures=[];
  const pending={current:null},next={current:0},nextTour={current:0};
  const run=new Function('parsePondsterDestination','navigate','setTourRequest','nextTourRequest','saving','galleries','setRoom','setScene','getPondsterDestinationId','nextSectionReveal','pendingSectionReveal','setSectionReveal','galleryVoiceSelection','setZoom','zoom','room','setZoomExpanded','voteCurrentPicture','document','activateSiteControl',
    stripTypeScriptTypes(handler)+'\nreturn guideAction;')(
    parsePondsterDestination,menu=>{navigation.push(menu);pending.current=null;},id=>tours.push(id),nextTour,saving,galleries,
    room=>rooms.push(room),scene=>scenes.push(scene),getPondsterDestinationId,next,pending,request=>requests.push(request),galleryVoiceSelection,design=>pictures.push(design),null,'media-center',()=>{},()=>Promise.resolve({status:'no-picture'}),{querySelector:()=>null},()=>Promise.resolve({status:'activated'}));
  return{run,navigation,rooms,scenes,requests,tours,pictures,pending};
}
{
  const h=actionHarness();
  for(const [question,section] of [
    ['Show me cameras','cameras'],
    ['Show me the camera spec sheet','cameras'],
    ['Show me the A/V spec sheet','audio'],
    ['Show me audio/video specifications','audio'],
    ['Show me cameras and A/V spec sheets','maintenance'],
    ['Show me the A/V spec sheet','audio'],
    ['Show me the A/V spec sheet','audio'],
    ['Show me the camera spec sheet','cameras'],
  ]){
    const action=answerPondster(question).action;
    assert.deepEqual(action,{menu:'Own',section},question);
    h.run(action);
    assert.equal(getPondsterDestinationId(h.pending.current.destination),`pondster-own-${section}`,question);
    assert.equal(h.navigation.at(-1),'Own',question);
  }
  assert.deepEqual(h.requests.map(request=>request.id),[1,2,3,4,5,6,7,8],
    'Equipment requests use the actual reveal handler even when Belong and the same card are already selected.');
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
  assert.equal(h.pictures.filter(Boolean)[0].id,galleries.find(item=>item.id==='media-center').designs[0].id,'A guided gallery opens its first actual choice after dismissing any previous viewer.');
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
  const h=actionHarness();
  for(const room of ['media-center','spiral-staircase','back-deck','front-elevation','adu','media-center'])h.run({menu:'Explore',section:'room',room});
  assert.deepEqual(h.requests.map(request=>request.id),[1,2,3,4,5,6],'Same-page Explore room changes and repeats each carry a new selection/reveal intent.');
  assert.deepEqual(h.requests.map(request=>request.destination.room),['media-center','spiral-staircase','back-deck','front-elevation','adu','media-center']);
  assert.equal(h.pictures.filter(Boolean).length,0,'Explore room requests stay in the selected floor-plan detail instead of opening the Design gallery.');
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
  const selectedPlan=destination.menu==='Explore' && destination.room?floorPlanRooms.find(item=>destination.section==='floor-plan'?item.id===destination.room:item.galleryId===destination.room):undefined;
  const target={tagName:details?'DETAILS':'SECTION',open:false,dataset:{pondsterRoom:planReady?(selectedPlan?.id??`gallery-${destination.room}`):'stale-room',pondsterGallery:planReady?(selectedPlan?.galleryId??destination.room):'stale-gallery'},
    getClientRects:()=>[{}],getBoundingClientRect:()=>{reads.push('target');return{top:metrics.top,bottom:metrics.bottom,height:metrics.bottom-metrics.top};},
    querySelectorAll:()=>[],focus(){focusCalls++;},click(){clickCalls++;}};
  const outer={...target,getBoundingClientRect(){throw new Error('An Explore room request must reveal its selected detail, not the outer plan or a removed room card.');}};
  const document={getElementById(id){assert.equal(id,getPondsterDestinationId(pending.current?.destination??destination),'Only the fixed shared-mapper ID is looked up.');return destination.menu==='Explore'&&destination.room?outer:target;}};
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
    const h=revealHarness(destination);
    Object.assign(h.metrics,{top:580,bottom:1840,header:192,height:710});h.run();h.drain();
    assert.deepEqual(h.scrolls,[{top:876,behavior:'smooth'}],'An oversized selected room detail near the bottom must reveal its top.');
    const aligned=revealHarness(destination);
    Object.assign(aligned.metrics,{top:204,bottom:1464,header:192,height:710});aligned.run();aligned.drain();
    assert.deepEqual(aligned.scrolls,[],'An already aligned oversized selected room detail must not jump again.');
  }
  const gallery=revealHarness({menu:'Design',section:'gallery',room:'media-center'});
  Object.assign(gallery.metrics,{top:580,bottom:1840,header:192,height:710});gallery.run();gallery.drain();
  assert.deepEqual(gallery.scrolls,[],'Design gallery reveals retain their existing heading/visual geometry.');
}
{
  const h=revealHarness({menu:'Explore',section:'room',room:'master-bath'});
  h.run();h.flush();assert.equal(h.scrolls.length,1,'The selected room panel is already expanded and reveals without another room-card click.');
  assert.equal(h.focusCalls(),0);
}
{
  for(const room of ['media-center','spiral-staircase','back-deck','garage-barn-door','front-elevation','adu']){
    const h=revealHarness({menu:'Explore',section:'room',room},{planReady:false});
    h.run();h.flush();assert.deepEqual(h.reads,[],'Do not measure the previous selected room for an Explore gallery-room request.');
    h.target.dataset.pondsterRoom=floorPlanRooms.find(item=>item.galleryId===room)?.id??`gallery-${room}`;
    h.flush();assert.deepEqual(h.scrolls,[],'A plan identity alone cannot satisfy a gallery-room request.');
    h.target.dataset.pondsterGallery=room;h.flush();assert.equal(h.scrolls.length,1,`Reveal ${room} after its matching detail has committed.`);
  }
  const h=revealHarness({menu:'Explore',section:'room',room:'media-center'});h.run();h.drain();
  const next={id:2,destination:{menu:'Explore',section:'room',room:'spiral-staircase'}};h.pending.current=next;
  h.run(next);h.flush();assert.equal(h.scrolls.length,1,'A same-page room change waits while the previous Living Room detail is still mounted.');
  h.target.dataset.pondsterRoom='spiral-stair';h.target.dataset.pondsterGallery='spiral-staircase';h.flush();
  assert.equal(h.scrolls.length,2,'The newly selected Home Theatre detail reveals after its own identity is ready.');
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

const files=Object.fromEntries(await Promise.all(['contact-page','explore-page','interactive-floor-plan','room-primary-image','view-page','built-by-page','equipment-manuals'].map(async name=>[name,await readFile(new URL('../app/'+name+'.tsx',import.meta.url),'utf8')])));
for(const id of ['pondster-design-overview','pondster-own-drawing'])assert.ok(source.includes('id="'+id+'"'));
assert.ok(source.includes('id={`pondster-own-${section}`}'));
assert.match(source,/import EquipmentManuals from '.\/equipment-manuals'/);
assert.match(source,/<EquipmentManuals\s*\/>/,'Belong mounts the component that owns its equipment destinations.');
assert.match(files['equipment-manuals'],/id="pondster-own-maintenance"/);
assert.match(files['equipment-manuals'],/equipmentManuals.map\(equipment => <article/);
assert.ok(files['equipment-manuals'].includes('id={`pondster-own-${equipment.id}`}'));
for(const equipment of equipmentManuals){
  assert.ok(DESTINATION_SECTIONS.Own.includes(equipment.id),'Each generated equipment card is an allowed Own destination.');
  assert.equal(getPondsterDestinationId({menu:'Own',section:equipment.id}),`pondster-own-${equipment.id}`,'The destination mapper agrees with the actual component registry and card template.');
}
for(const section of DESTINATION_SECTIONS.Own){
  const destination={menu:'Own',section},h=actionHarness();h.run(destination);
  assert.deepEqual(h.navigation,['Own']);assert.deepEqual(h.pending.current.destination,destination);
  assert.equal(getPondsterDestinationId(h.pending.current.destination),`pondster-own-${section}`);
  const reveal=revealHarness(destination);reveal.run();reveal.drain();
  assert.equal(reveal.scrolls.length,1,`Reveal the exact ${section} Belong card through the real page effect.`);
  assert.equal(reveal.focusCalls(),0);assert.equal(reveal.clickCalls(),0,'A manual reveal does not open a PDF or activate an external link.');
}
{
  const h=actionHarness();h.run({menu:'Own',section:'cameras'});h.run({menu:'Own',section:'audio'});
  assert.deepEqual(h.requests.map(request=>request.id),[1,2]);
  assert.deepEqual(h.requests.map(request=>getPondsterDestinationId(request.destination)),['pondster-own-cameras','pondster-own-audio'],'A same-page equipment change targets its own card.');
}
for(const id of ['ashley','company','trades','voice'])assert.ok(files['contact-page'].includes('id="pondster-contact-'+id+'"'));
assert.ok(files['contact-page'].includes("id={`pondster-contact-${id==='general-contractor'?'gc':id}`}"));
for(const id of ['tour','ashley','viewing','notebook'])assert.ok(files['view-page'].includes('id="pondster-view-'+id+'"'));
for(const id of ['company','contact'])assert.ok(files['built-by-page'].includes('id="pondster-built-by-'+id+'"'));
for(const id of ['house','lighting'])assert.ok(files['explore-page'].includes('id="pondster-explore-'+id+'"'));
assert.ok(!files['explore-page'].includes('room-feature-grid') && !files['explore-page'].includes('roomFeatures'),'The redundant lower room cards and content are removed.');
const featureDeclaration=files['explore-page'].match(/const featureSections:Record<string,string> = \{[\s\S]*?\n\};/)?.[0];assert.ok(featureDeclaration);
const features=new Function(stripTypeScriptTypes(featureDeclaration)+';return featureSections;')();
for(const feature of houseFeatures){assert.ok(DESTINATION_SECTIONS.Explore.includes(features[feature.title]),'Every published house-feature card has a fixed allowed destination.');}
const planSource=files['interactive-floor-plan'];
assert.match(planSource,/id="pondster-explore-floor-plan"/);assert.match(planSource,/data-pondster-room=\{selectedCamera\?\.id \?\? selectedRoom.id\}/);
assert.match(planSource,/data-pondster-gallery=\{selectedCamera \? undefined : selectedRoom.galleryId\}/);
assert.match(planSource,/id="pondster-explore-rooms"/);
assert.match(planSource,/id=\{selectedRoom.galleryId \? `pondster-explore-room-\$\{selectedRoom.galleryId\}` : undefined\}/);
const roomOptionsSource=planSource.match(/const additionalSpaces =[\s\S]*?const exploreRooms =[^\n]+;/)?.[0];assert.ok(roomOptionsSource);
const {additionalSpaces,exploreRooms}=new Function('galleries','floorPlanRooms',stripTypeScriptTypes(roomOptionsSource)+';return {additionalSpaces,exploreRooms};')(galleries,floorPlanRooms);
assert.equal(floorPlanRooms.length,19);assert.equal(new Set(exploreRooms.map(room=>room.id)).size,exploreRooms.length);
assert.deepEqual(additionalSpaces.map(room=>room.galleryId),['front-elevation','adu'],'Spaces outside the first-floor plan remain available in the same selector.');
assert.match(planSource,/floorPlanRooms.map\(room => <option/);assert.match(planSource,/additionalSpaces.map\(room => <option/);
const selectionBody=planSource.match(/  useEffect\(\(\) => \{([\s\S]*?)\n  \},\[roomRequest\?\.id,roomRequest\?\.room,roomRequest\?\.section\]\);/)?.[1];assert.ok(selectionBody);
const chooseRequested=new Function('roomRequest','floorPlanRooms','exploreRooms','setSelectedId','floorPlanCameras',selectionBody),selected=[];
chooseRequested({id:1,room:'pantry'},floorPlanRooms,exploreRooms,room=>selected.push(room),floorPlanCameras);
chooseRequested({id:2,room:'pantry'},floorPlanRooms,exploreRooms,room=>selected.push(room),floorPlanCameras);
chooseRequested({id:3,room:'private-room'},floorPlanRooms,exploreRooms,room=>selected.push(room),floorPlanCameras);
assert.deepEqual(selected,['pantry','pantry'],'Valid repeated plan requests select before reveal; unknown room IDs do not alter selection.');
for(const room of floorPlanRooms){
  const result=[];chooseRequested({id:4,section:'floor-plan',room:room.id},floorPlanRooms,exploreRooms,id=>result.push(id),floorPlanCameras);
  assert.deepEqual(result,[room.id],`The exact ${room.id} plan region remains selectable.`);
}
const featureListSource=planSource.match(/const selectedFeatures =[^\n]+;/)?.[0];assert.ok(featureListSource);
const contentFor=new Function('selectedRoom','roomFeature',featureListSource+'return selectedFeatures;');
for(const gallery of galleries){
  const result=[];chooseRequested({id:5,section:'room',room:gallery.id},floorPlanRooms,exploreRooms,id=>result.push(id));
  assert.equal(result.length,1,`The ${gallery.id} Explore route selects one detail panel.`);
  const selectedRoom=exploreRooms.find(room=>room.id===result[0]);assert.equal(selectedRoom.galleryId,gallery.id);
  const features=contentFor(selectedRoom,roomFeatures[gallery.id]);
  for(const feature of roomFeatures[gallery.id].features)assert.ok(features.includes(feature),`The selected ${gallery.id} panel retains its full former room-card content.`);
  assert.equal(new Set(features).size,features.length,'Shared plan/card bullets appear once.');
}
assert.equal((planSource.match(/<RoomPrimaryImage\b/g)??[]).length,1,'The single selected panel owns the primary picture.');
assert.match(planSource,/roomFeature.status/);assert.match(planSource,/<ul>\{selectedFeatures.map/);
assert.match(source,/floorPlanRequest=\{sectionReveal\?\.destination.menu==='Explore'/);
assert.match(files['explore-page'],/roomRequest=\{floorPlanRequest\} detailRef=\{floorPlanDetailRef\}/);

// Execute the real Explore -> selected detail -> primary-image callback chain.
// Hook doubles let this test inspect and activate actual JSX event handlers
// without a browser, microphone, network, or image download.
const require=createRequire(import.meta.url),components=new Map();
let componentState={},stateChanges=[];
const hooks={
  useEffect(){},useId(){return 'primary-image-test';},useRef(value){return {current:value};},
  useState(initial){return [initial==='living-room'&&componentState.room?componentState.room:typeof initial==='boolean'&&componentState.failed!==undefined?componentState.failed:initial,value=>stateChanges.push(value)];}
};
function component(name){
  if(components.has(name))return components.get(name);
  const module={exports:{}};
  const dependencies={react:hooks,'../lib/designs':{galleries},'../lib/design-views':{designImageSource},'../lib/features.js':{houseFeatures,roomFeatures},'../lib/floor-plan':{floorPlanRooms,PLAN_WIDTH:2340,PLAN_HEIGHT:2225},'../lib/floor-plan-cameras':{floorPlanCameras},'./camera-plan-video':{default:()=>null}};
  const load=specifier=>specifier in dependencies?dependencies[specifier]:specifier==='./room-primary-image'?{default:component('room-primary-image')}:specifier==='./interactive-floor-plan'?{default:component('interactive-floor-plan')}:require(specifier);
  new Function('require','module','exports',ts.transpileModule(files[name],{compilerOptions:{module:ts.ModuleKind.CommonJS,target:ts.ScriptTarget.ES2022,jsx:ts.JsxEmit.ReactJSX}}).outputText)(load,module,module.exports);
  components.set(name,module.exports.default);return module.exports.default;
}
function render(name,props,state={}){componentState=state;stateChanges=[];return component(name)(props);}
function elements(tree,predicate){
  const found=[];const walk=value=>{if(Array.isArray(value))value.forEach(walk);else if(value&&typeof value==='object'&&value.props){if(predicate(value))found.push(value);walk(value.props.children);}};
  walk(tree);return found;
}
{
  const defaults=[
    ['hot-water',{menu:'Explore',section:'room',room:'kitchen'},'pondster-explore-room-kitchen'],
    ['presence',{menu:'Explore',section:'room',room:'media-center'},'pondster-explore-room-media-center'],
    ['bath-and-shower',{menu:'Design',room:'hall-bath'},'design-gallery'],
    ['exterior-awareness',{menu:'Design',room:'media-center'},'design-gallery'],
    ['voice-feature',{menu:'Contact',section:'voice'},'pondster-contact-voice'],
    ['lighting-plans',{menu:'Explore',section:'lighting'},'pondster-explore-lighting'],
    ['sound-screens',{menu:'Own',section:'audio'},'pondster-own-audio'],
    ['climate',{menu:'Contact',section:'hvac'},'pondster-contact-hvac'],
    ['design-participation',{menu:'Design',section:'gallery'},'design-gallery'],
    ['owner-experience',{menu:'Own',section:'handover'},'pondster-own-handover'],
  ];
  const sectionIds=defaults.map(([sectionId])=>sectionId),requests=[],mapped=[];
  const props={scene:'day',onScene(){},onFeature:sectionId=>{
    requests.push(sectionId);const destination=getExploreFeatureDestination(sectionId);
    if(destination){const h=actionHarness();h.run(destination);mapped.push({destination,h});}
  }};
  const clickable=render('explore-page',props),cards=elements(clickable,node=>node.type==='article');
  assert.equal(cards.length,houseFeatures.length);
  const text=value=>Array.isArray(value)?value.map(text).join(''):typeof value==='string'?value:value?.props?text(value.props.children):'';
  cards.forEach((card,index)=>{
    const feature=houseFeatures[index],buttons=elements(card,node=>node.type==='button');
    assert.equal(card.props.id,`pondster-explore-${sectionIds[index]}`,'Clickable feature cards retain their fixed public reveal IDs.');
    assert.equal(buttons.length,1);assert.equal(buttons[0].props.type,'button','Feature cards use native keyboard activation.');
    assert.equal(buttons[0].props['aria-label'],`Open feature: ${feature.title}`);
    for(const value of [feature.status,feature.title,feature.text])assert.ok(text(card).includes(value),'Feature status, title and authored description remain unchanged.');
    buttons[0].props.onClick();
    const [sectionId,expected,targetId]=defaults[index],result=mapped[index];
    assert.deepEqual(result.destination,expected,`${sectionId} uses its approved configurable default.`);
    assert.deepEqual(result.h.navigation,[expected.menu]);assert.deepEqual(result.h.pending.current.destination,expected,'The real UI handler accepts the mapped feature action.');
    assert.equal(getPondsterDestinationId(result.h.pending.current.destination),targetId);
    const reveal=revealHarness(expected);reveal.run();reveal.drain();assert.equal(reveal.scrolls.length,1,`${sectionId} reveals the actual fixed target using the measured existing effect.`);
    if(expected.menu==='Design'){
      const gallery=galleries.find(item=>item.id===(expected.room??'media-center'));
      assert.equal(result.h.pictures.filter(Boolean)[0].id,gallery.designs[0].id,'Design feature links use the existing first-choice flow.');
    }else assert.equal(result.h.pictures.filter(Boolean).length,0,'Other feature destinations do not open an unrelated design viewer.');
    if(expected.menu==='Explore'&&expected.room){
      const chosen=[];chooseRequested({id:1,section:'room',room:expected.room},floorPlanRooms,exploreRooms,id=>chosen.push(id));
      assert.equal(exploreRooms.find(room=>room.id===chosen[0]).galleryId,expected.room,'Explore feature links select the matching room detail before reveal.');
    }
  });
  assert.deepEqual(requests,sectionIds,'Each card emits only its stable feature ID for the parent’s configurable destination mapping.');
  for(const unknown of ['', 'unknown-feature', '__proto__', 'constructor', 'https://example.invalid/', 'camera-feed'])assert.equal(getExploreFeatureDestination(unknown),null,'Unknown feature IDs cannot create URLs or private/device actions.');
  const changed=getExploreFeatureDestination('hot-water');changed.menu='View';assert.deepEqual(getExploreFeatureDestination('hot-water'),defaults[0][1],'Returned actions cannot mutate the central default map.');
  const plain=render('explore-page',{scene:'day',onScene(){}}),plainCards=elements(plain,node=>node.type==='article');
  for(const [index,card] of plainCards.entries()){
    assert.equal(card.props.id,cards[index].props.id);assert.equal(elements(card,node=>node.type==='button').length,0,'A feature without a navigation handler is ordinary readable content.');
    assert.equal(elements(card,node=>node.type==='h3').length,1);assert.equal(text(card),text(cards[index]));
  }
}
const savedRaf=globalThis.requestAnimationFrame;
globalThis.requestAnimationFrame=callback=>{callback();return 1;};
try{
  for(const room of exploreRooms){
    const h=actionHarness(),openGallery=galleryId=>h.run({menu:'Design',room:galleryId});
    const explore=render('explore-page',{scene:'day',onScene(){},onGallery:openGallery});
    const planProps=elements(explore,node=>node.type===component('interactive-floor-plan'))[0].props;
    assert.equal(planProps.onGallery,openGallery,'Explore forwards the existing gallery navigation callback.');
    const plan=render('interactive-floor-plan',planProps,{room:room.id});
    const mapRoom=elements(plan,node=>node.type==='polygon'&&node.props['aria-label']===`Explore my ${room.name}`)[0];
    if(mapRoom){mapRoom.props.onClick();assert.deepEqual(stateChanges,[room.id]);assert.deepEqual(h.navigation,[],'A floor-plan room click selects Explore details without opening Design.');}
    const primaryProps=elements(plan,node=>node.type===component('room-primary-image'))[0].props;
    assert.equal(primaryProps.galleryId,room.galleryId,`${room.id} retains its authored gallery mapping.`);
    const picture=render('room-primary-image',primaryProps),buttons=elements(picture,node=>node.type==='button');
    const gallery=galleries.find(item=>item.id===room.galleryId);
    if(!gallery?.designs.length){assert.equal(buttons.length,0,`${room.id} has an honest, nonclickable coming-soon placeholder.`);assert.equal(elements(picture,node=>node.type==='img').length,0);continue;}
    assert.equal(buttons.length,1);assert.equal(buttons[0].props.type,'button','Native buttons provide Enter/Space activation.');
    assert.equal(buttons[0].props['aria-label'],`Open my ${gallery.name} design gallery`);
    buttons[0].props.onClick();
    assert.deepEqual(h.navigation,['Design']);assert.deepEqual(h.rooms,[gallery.id]);
    assert.equal(h.pictures.filter(Boolean)[0].id,gallery.designs[0].id,'Open the actual first choice through the existing gallery handler.');
    assert.equal(getPondsterDestinationId(h.pending.current.destination),'design-gallery','Use the existing measured gallery reveal rather than a new scroll path.');
  }
  const props={galleryId:'garage-barn-door',roomName:'Existing Garage',onGallery(){throw new Error('A failed picture must not navigate.');}};
  const loaded=render('room-primary-image',props);elements(loaded,node=>node.type==='img')[0].props.onError();assert.deepEqual(stateChanges,[true]);
  const failed=render('room-primary-image',props,{failed:true});assert.equal(elements(failed,node=>node.type==='button').length,0);assert.equal(elements(failed,node=>node.props.className==='room-primary-placeholder').length,1);
  assert.equal(elements(render('room-primary-image',{galleryId:'not-a-gallery',roomName:'Unknown',onGallery(){}}),node=>node.type==='button').length,0);
  const standalone=render('room-primary-image',{galleryId:'garage-barn-door',roomName:'Garage'});assert.equal(elements(standalone,node=>node.type==='button').length,0);assert.equal(elements(standalone,node=>node.type==='img').length,1,'A preview without a navigation handler remains a plain image.');
}finally{if(savedRaf===undefined)delete globalThis.requestAnimationFrame;else globalThis.requestAnimationFrame=savedRaf;}
console.log('PASS: precise fixed destinations, real feature-card callbacks through the typed default map/UI handler/measured reveal, native buttons and unchanged content/IDs, unknown-feature no-op, repeated same-page requests, all plan-room primary-image gallery mappings, nonclickable missing/failed pictures, map-only detail selection, first-choice reveal, stale cleanup and independent tour one-shot; no browser/network.');
