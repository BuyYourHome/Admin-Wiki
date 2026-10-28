import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { stripTypeScriptTypes } from 'node:module';
import { getGalleryScrollTop } from '../lib/gallery-scroll.ts';
import { galleries } from '../lib/designs.ts';

const geometry={headingTop:240,headingBottom:370,visualTop:420,headerBottom:180,viewportHeight:900,scrollY:600};
assert.equal(getGalleryScrollTop(geometry),null,'A visible heading and first visual do not jump.');
assert.equal(getGalleryScrollTop({...geometry,headingTop:100,headingBottom:230,visualTop:260,headerBottom:200,scrollY:1000}),888,'An obscured label moves below the measured sticky header.');
assert.equal(getGalleryScrollTop({...geometry,headingTop:900,headingBottom:1030,visualTop:1080,headerBottom:245,viewportHeight:844,scrollY:100}),743,'Phone selection reveals below the actual taller header.');
assert.equal(getGalleryScrollTop({...geometry,headingTop:900,headingBottom:1030,visualTop:1080,headerBottom:330,viewportHeight:844,scrollY:100}),658,'Header status/menu wrapping is measured instead of hardcoded.');
assert.equal(getGalleryScrollTop({...geometry,headingTop:700,headingBottom:790,visualTop:860,headerBottom:200,scrollY:100}),588,'A label alone near the bottom also reveals its first visual.');
assert.equal(getGalleryScrollTop({...geometry,headingTop:260,headingBottom:380,visualTop:420,headerBottom:245,viewportHeight:844}),null,'An already visible phone gallery remains still.');
assert.equal(getGalleryScrollTop({...geometry,headingTop:100,headingBottom:230,visualTop:260,headerBottom:200,scrollY:0}),null,'Already at the top cannot move farther or issue a redundant scroll.');
assert.equal(getGalleryScrollTop({...geometry,headingTop:50,headingBottom:180,visualTop:220,headerBottom:200,scrollY:100}),0,'A negative destination is clamped to the document top.');
assert.equal(getGalleryScrollTop({...geometry,visualTop:2000}),null,'An impossible whole-gallery fit does not cause a gratuitous jump.');
assert.equal(getGalleryScrollTop({...geometry,headerBottom:1000}),null);
assert.equal(getGalleryScrollTop({...geometry,headingTop:NaN}),null);
assert.equal(getGalleryScrollTop({...geometry,viewportHeight:0}),null);

// Execute the actual page selection and effect with layout/timer doubles only.
const source=await readFile(new URL('../app/page.tsx',import.meta.url),'utf8');
const selection=source.match(/  function selectGallery\(nextRoom:string\) \{[\s\S]*?\n  \}/)?.[0];
assert.ok(selection);
const pending={current:null},selected=[];
const select=new Function('room','galleries','pendingGalleryScroll','setRoom',stripTypeScriptTypes(selection)+'\nreturn selectGallery;')(
  'media-center',galleries,pending,room=>selected.push(room));
select('media-center');assert.equal(pending.current,null);assert.deepEqual(selected,[],'Current gallery activation does not schedule a jump.');
select('kitchen');assert.deepEqual(pending.current,{room:'kitchen'});assert.deepEqual(selected,['kitchen']);
select('unrecognized-room');assert.deepEqual(selected,['kitchen']);
assert.match(source,/onClick=\{\(\)=>\{if\(!saving\)selectGallery\(item.id\);\}\} disabled=\{saving\}/,'Pointer saving guard is unchanged.');
assert.match(source,/if\(action.room&&!saving\)\{if\(action.menu==='Design'\)selectGallery\(action.room\);else setRoom\(action.room\);\}/,'Deliberate voice gallery selection shares the reveal path and preserves its caller guard.');
assert.match(source,/function navigate\(next:Menu\)\{pendingGalleryScroll.current=null;/,'Navigation immediately cancels pending reveals.');
assert.match(source,/aria-pressed=\{room===item.id\} aria-controls="design-gallery"/);
assert.match(source,/id="design-gallery" className="gallery-area" role="region" aria-labelledby="design-gallery-title"/);

const marker=source.indexOf('    const request = pendingGalleryScroll.current;');
const prefix='  useEffect(() => {';
const effectStart=source.lastIndexOf(prefix,marker);
const effectEnd=source.indexOf('  },[menu,room]);',marker);
assert.ok(marker>=0 && effectStart>=0 && effectEnd>marker);
const effect=stripTypeScriptTypes('function revealEffect(){'+source.slice(effectStart+prefix.length,effectEnd)+'\n}');
const executeEffect=new Function('pendingGalleryScroll','menu','room','requestAnimationFrame','cancelAnimationFrame',
  'galleryArea','galleryHeading','stickyHeader','window','getGalleryScrollTop',effect+'\nreturn revealEffect();');
function harness({request={room:'kitchen'},reduce=false}={}) {
  const pending={current:request},jobs=new Map(),scrolls=[];
  let id=0,focusCalls=0;
  const metrics={headingTop:900,headingBottom:1020,visualTop:1030,headerBottom:200,viewportHeight:844,scrollY:500};
  const hidden={getClientRects:()=>[],getBoundingClientRect:()=>({top:0,height:300})};
  const visual={getClientRects:()=>[{}],getBoundingClientRect:()=>({top:metrics.visualTop,height:300}),focus(){focusCalls++;}};
  const area={current:{querySelectorAll:()=>[hidden,visual]}};
  const heading={current:{getBoundingClientRect:()=>({top:metrics.headingTop,bottom:metrics.headingBottom}),focus(){focusCalls++;}}};
  const header={current:{getBoundingClientRect:()=>({bottom:metrics.headerBottom})}};
  const window={get innerHeight(){return metrics.viewportHeight;},get scrollY(){return metrics.scrollY;},
    matchMedia(query){assert.equal(query,'(prefers-reduced-motion: reduce)');return{matches:reduce};},scrollTo:value=>scrolls.push(value)};
  const run=(menu='Design',room='kitchen')=>executeEffect(pending,menu,room,
    fn=>{const next=++id;jobs.set(next,fn);return next;},key=>jobs.delete(key),area,heading,header,window,getGalleryScrollTop);
  const flush=()=>{for(const [key,fn] of [...jobs]){jobs.delete(key);fn();}};
  return{pending,jobs,scrolls,metrics,run,flush,focusCalls:()=>focusCalls};
}
{
  const h=harness({request:null});h.run();h.flush();
  assert.deepEqual(h.scrolls,[]);assert.equal(h.jobs.size,0,'Initial or result-only renders have no deliberate request.');
}
{
  const h=harness();h.run();h.metrics.headerBottom=245;h.flush();
  assert.deepEqual(h.scrolls,[{top:1143,behavior:'smooth'}],'The RAF measures the final header after render.');
  assert.equal(h.pending.current,null);h.run();h.flush();assert.equal(h.scrolls.length,1,'Consumed requests cannot repeat on vote/results updates.');
  assert.equal(h.focusCalls(),0,'Selection preserves native keyboard focus.');
}
{
  const h=harness({reduce:true});h.run();h.flush();assert.equal(h.scrolls[0].behavior,'auto');
}
{
  const h=harness();Object.assign(h.metrics,{headingTop:260,headingBottom:380,visualTop:420,headerBottom:245});
  h.run();h.flush();assert.deepEqual(h.scrolls,[],'Visible content consumes the request without scrolling.');
}
{
  const h=harness();const cleanup=h.run();assert.equal(h.jobs.size,1);cleanup();h.run('View');h.flush();
  assert.deepEqual(h.scrolls,[]);assert.equal(h.pending.current,null,'Leaving Design cancels a pending reveal and prevents return-page replay.');
}
{
  const h=harness();h.run();const replacement={room:'back-deck'};h.pending.current=replacement;h.flush();
  assert.deepEqual(h.scrolls,[]);assert.equal(h.pending.current,replacement,'A stale RAF cannot consume a newer selection.');
  h.run('Design','back-deck');h.flush();assert.equal(h.scrolls.length,1);
}
assert.ok(!effect.includes('.focus('));
assert.ok(source.slice(effectStart,effectEnd).includes('menu,room')===false,'Scroll effect reads layout only, with dependency list limited to menu and room.');
console.log('PASS: deliberate gallery-only reveal, dynamic sticky header, visible no-op, first visual, reduced motion, saving guard, native focus, stale RAF/navigation cleanup and no initial/vote replay; no browser/network.');
