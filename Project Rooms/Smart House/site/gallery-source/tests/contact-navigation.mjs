import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { answerPondster } from '../lib/pondster-guide.ts';
import { isCommentPage, validateComment } from '../lib/comments.ts';
const pageSource = await readFile(new URL('../app/page.tsx', import.meta.url), 'utf8');
const menuSource = pageSource.match(/const menus = \[([^\]]+)\] as const;/)?.[1];
assert.ok(menuSource, 'The main menu declaration is present.');
assert.deepEqual([...menuSource.matchAll(/'([^']+)'/g)].map(match => match[1]),
  ['Design', 'Explore', 'View', 'Own', 'Built By', 'Contact'], 'Contact is the final main menu item.');
// Exercise the actual plain-JavaScript header handlers with a deterministic timer.
const handlerNames = ['cancelVoiceHover', 'scheduleVoiceHover', 'toggleVoice'];
const handlerDeclarations = handlerNames.map(name => {
  const match = pageSource.match(new RegExp('  function '+name+'\\(\\) \\{[\\s\\S]*?\\n  \\}'));
  assert.ok(match, 'The scoped header handler exists: '+name);
  return match[0];
});
let hoverNow = 0, hoverId = 0, voiceStarts = 0, voiceToggles = 0, animations = 0;
const hoverTimers = new Map(), hoverTimer = {current:null};
const hoverGuide = {current:{startVoice(){voiceStarts++;},activateVoice(){voiceToggles++;}}};
const hover = new Function('voiceHoverTimer','guide','setLogoPlay','setTimeout','clearTimeout','voiceSummary','hoverVoiceStarted','Date',
  handlerDeclarations.join('\n')+'\nreturn {cancelVoiceHover,scheduleVoiceHover,toggleVoice};')(
  hoverTimer,hoverGuide,update=>{animations=update(animations);},
  (fn,ms)=>{const id=++hoverId;hoverTimers.set(id,{fn,at:hoverNow+ms});return id;},
  id=>hoverTimers.delete(id),{active:false,connecting:false},{current:null},{now:()=>hoverNow});
function advanceHover(ms) {
  hoverNow+=ms;
  for(const [id,timer] of [...hoverTimers])if(timer.at<=hoverNow){hoverTimers.delete(id);timer.fn();}
}
hover.scheduleVoiceHover();advanceHover(499);assert.equal(voiceStarts,0);
advanceHover(1);assert.equal(voiceStarts,1,'Only a full 500 ms mouse dwell requests idempotent start.');
advanceHover(60_000);assert.equal(voiceStarts,1,'Remaining over the logo after quiet-off cannot restart voice.');
hover.scheduleVoiceHover();advanceHover(100);hover.cancelVoiceHover();advanceHover(500);
assert.equal(voiceStarts,1,'Mouseleave cancels a pending dwell.');
hover.scheduleVoiceHover();advanceHover(100);hover.toggleVoice();advanceHover(500);
assert.equal(voiceStarts,1);assert.equal(voiceToggles,1,'Fast clicks cancel hover and keep the existing toggle.');
hover.scheduleVoiceHover();hover.cancelVoiceHover();assert.equal(hoverTimers.size,0,'Unmount cleanup can cancel all pending hover work.');
assert.match(pageSource,/onMouseEnter=\{scheduleVoiceHover\} onMouseLeave=\{cancelVoiceHover\} onFocus=\{\(\)=>setLogoPlay\(value=>value\+1\)\}/,'Keyboard focus animates only; it does not start voice.');
assert.match(pageSource,/useEffect\(\(\)=>\(\)=>cancelVoiceHover\(\),\[\]\)/);
assert.equal((pageSource.match(/\.startVoice\(/g)||[]).length,1,'Only the dwell callback can request hover start; no active-state restart effect exists.');
const activePredicate = pageSource.match(/const voiceIsLive = ([^;]+);/)?.[1];
assert.ok(activePredicate);
const isLive = new Function('voiceSummary','return '+activePredicate);
assert.equal(isLive({active:false,connecting:false}),false);
assert.equal(isLive({active:true,connecting:true}),false,'Connecting is not announced as listening.');
assert.equal(isLive({active:true,connecting:false}),true);
assert.match(pageSource,/voiceIsLive\?'voice-is-live'/);
assert.ok(pageSource.includes('<small>{voiceIsLive?"A home You can Relate to - I\'m listening!":"A Home You can Relate to. Talk to me!"}</small>'));
assert.match(pageSource,/aria-pressed=\{voiceSummary\.active\}/,'Connecting still exposes the Stop toggle.');
assert.match(pageSource,/id="pondster-header-voice-status" aria-live="off"/,'The visible quiet countdown stays out of repeated live announcements.');
const viewSource = await readFile(new URL('../app/view-page.tsx', import.meta.url), 'utf8');
assert.match(pageSource, /action\.tour===true&&action\.menu==='View'\)\{setTourRequest\(\+\+nextTourRequest\.current\);return;/, 'Only an explicit View-tour action creates a new one-shot request, without a competing section reveal.');
assert.match(pageSource, /<ViewPage tourRequest=\{tourRequest\} onTourRequestHandled=\{\(\)=>setTourRequest\(null\)\}/);
assert.match(pageSource, /onTourStart=\{cancelVoiceHover\} voice=\{viewerVoice\}/, 'Voice stays available in the tour and exposes its own controls.');
assert.match(viewSource, /if\(tourRequest===null \|\| consumedTourRequest\.current===tourRequest\)return;/, 'Ordinary View mounts and already-consumed requests do not start a tour.');
const consumedAt = viewSource.indexOf('consumedTourRequest.current=tourRequest;');
const handledAt = viewSource.indexOf('onTourRequestHandled?.();');
const clickedAt = viewSource.indexOf("page.current?.querySelector<HTMLButtonElement>('.virtual-tour-invitation button.tour-start')?.click();");
assert.ok(consumedAt>=0 && handledAt>consumedAt && clickedAt>handledAt, 'The scoped existing Start button is invoked only after consuming the request, before voice-stop rerenders.');
for (const [name, menu] of [['Design','Design'],['Explore','Explore'],['View','View'],['Belong','Own'],['Built By','Built By'],['Contact','Contact']]) {
  for (const command of [`Go to ${name}`, `Open the ${name} page`, `Pondster, could you take me to ${name} please?`]) {
    assert.deepEqual(answerPondster(command).action, { menu }, command);
  }
}
assert.deepEqual(answerPondster('Show me the Back Deck').action, { menu: 'Design', room: 'back-deck' });
assert.deepEqual(answerPondster('Show me the Master Bath').action, { menu: 'Design', room: 'master-bath' });
assert.deepEqual(answerPondster('Contact Ashley').action, { menu: 'Contact', section: 'ashley' });
assert.match(answerPondster('Contact Ashley').text, /ashley@elementrealtygroup.net/);
assert.deepEqual(answerPondster('Open Contact and give me the Wi-Fi password').action, { menu: 'Own' });
assert.match(answerPondster('Open Contact and give me the Wi-Fi password').text, /cannot provide private records/);
assert.equal(isCommentPage('contact'), true);
assert.equal(isCommentPage('private'), false);
assert.equal(validateComment({page:'contact',requestId:'00000000-0000-4000-8000-000000000001',body:'I like the new contact page.'}).value?.page, 'contact');
console.log('PASS: hover dwell/cancellation and live-only tagline, Contact-last menu order, six public voice navigation destinations, legacy Belong/Own mapping, room routes, Contact business details, privacy precedence and Contact comment validation (no network).');
