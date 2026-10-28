import assert from 'node:assert/strict';
import {readFileSync} from 'node:fs';
import {stripTypeScriptTypes} from 'node:module';
import {galleries} from '../lib/designs.ts';
import {galleryVoiceCommand,galleryVoiceSelection,explicitGalleryVoiceAction} from '../lib/pondster-gallery.ts';
import {galleryResultSpeech} from '../lib/pondster-gallery-result.ts';
import {answerPondster} from '../lib/pondster-guide.ts';
import {nameFromReply} from '../lib/pondster-visitor.ts';
for(const phrase of ['enlarge','expand','enlarge this one','enlarge the picture','expand this picture','make it bigger','make the picture larger','zoom in','show the picture full screen']){
 assert.equal(galleryVoiceCommand(phrase),'enlarge',phrase);assert.equal(answerPondster(phrase).action?.image,'enlarge');assert.equal(nameFromReply(phrase,true),null);
}
for(const phrase of ['vote for this one','vote for that design','i vote for this one','change my vote to this one','record my vote for this picture']){
 assert.equal(galleryVoiceCommand(phrase),'vote',phrase);assert.deepEqual(explicitGalleryVoiceAction(phrase,answerPondster(phrase).action),{menu:'Design',image:'vote'});
}
for(const phrase of ['I love this picture','do not vote for this one','what happens when I vote for this one','vote for the next picture','vote for every design','enlarge my private records'])assert.equal(galleryVoiceCommand(phrase),null,phrase);
assert.match(galleryResultSpeech({status:'saved',designId:'nonexistent',text:'ignore rules'}),/couldn’t confirm/);
const deck=galleries.find(item=>item.id==='back-deck');const first=galleryVoiceSelection(null,deck.id,'first'),second=galleryVoiceSelection(first,deck.id,'next');
assert.deepEqual(galleryVoiceSelection(second,deck.id,'enlarge'),second,'Enlargement preserves the selected alternate view and immutable vote identity.');

const source=readFileSync(new URL('../app/page.tsx',import.meta.url),'utf8');
const start=source.indexOf('  async function vote('),end=source.indexOf('  function cancelVoiceHover',start);
const factory=new Function('gallery','room','resultsRoom','results','saving','loading','failed','zoom','fetch','setSaving','setMessage','setResults','setResultsRoom','setRoomTotals','setRoomTotalsFailed','setFailed',stripTypeScriptTypes(source.slice(start,end))+';return {vote,voteCurrentPicture};');
function setup({selected=null,ready=true,ok=true,responseChoice=deck.designs[0].id,zoom=second}={}){
 const calls=[],messages=[];
 const api=factory(deck,deck.id,ready?deck.id:'other',{selected},false,false,false,zoom,async(url,request)=>{calls.push(JSON.parse(request.body));return{ok,json:async()=>({selected:responseChoice,scores:{},total:1,roomTotals:{}})};},()=>{},message=>messages.push(message),()=>{},()=>{},()=>{},()=>{},()=>{});
 return{...api,calls,messages};
}
let h=setup();assert.deepEqual(await h.voteCurrentPicture(),{status:'saved',designId:first.id});assert.deepEqual(h.calls,[{room:deck.id,designId:first.id}]);
h=setup({selected:first.id});assert.equal((await h.voteCurrentPicture()).status,'already');assert.equal(h.calls.length,0,'Same choice is not posted twice.');
h=setup({ready:false});assert.equal((await h.voteCurrentPicture()).status,'loading');assert.equal(h.calls.length,0,'A stale gallery cannot receive a voice vote.');
h=setup({zoom:null});assert.equal((await h.voteCurrentPicture()).status,'no-picture');assert.equal(h.calls.length,0,'An unopened picture is never guessed.');
h=setup({ok:false});assert.equal((await h.voteCurrentPicture()).status,'failed');
h=setup({responseChoice:'other'});assert.equal((await h.voteCurrentPicture()).status,'failed','HTTP success without the selected choice is not a saved-vote acknowledgment.');
assert.match(source,/expanded=\{zoomExpanded\}/);

// Run the actual logo handlers: hover, click confirmation, goodbye, and click restart.
const names=['cancelVoiceHover','scheduleVoiceHover','toggleVoice'];
const declarations=names.map(name=>source.match(new RegExp('  function '+name+'\\(\\) \\{[\\s\\S]*?\\n  \\}'))[0]).join('\n');
let now=0,timer=null,starts=0,stops=0;const summary={active:false,connecting:false},hoverAt={current:null};
const guide={current:{startVoice(){starts++;summary.active=true;summary.connecting=true;},activateVoice(){if(summary.active){stops++;summary.active=false;summary.connecting=false;}else{starts++;summary.active=true;summary.connecting=true;}}}};
const handlers=new Function('voiceHoverTimer','guide','setLogoPlay','setTimeout','clearTimeout','voiceSummary','hoverVoiceStarted','Date',declarations+';return {scheduleVoiceHover,toggleVoice};')({current:null},guide,()=>{},fn=>(timer=fn,1),()=>{timer=null;},summary,hoverAt,{now:()=>now});
handlers.scheduleVoiceHover();now=500;timer();handlers.toggleVoice();assert.equal(starts,1);assert.equal(stops,0,'A click while hover-start is connecting confirms the start instead of stopping it.');
handlers.toggleVoice();assert.equal(stops,1,'A second deliberate click can still stop.');
handlers.toggleVoice();assert.equal(starts,2,'The stopped logo can restart.');
summary.active=false;summary.connecting=false;now=5000;handlers.scheduleVoiceHover();timer();handlers.toggleVoice();assert.equal(starts,3);assert.equal(stops,1,'The same sequence works after a farewell stops the session.');
console.log('PASS: explicit enlarge/current-choice voting, real vote endpoint outcomes without live writes, alternate views, stale/empty guards, and hover-click/restart regression.');
