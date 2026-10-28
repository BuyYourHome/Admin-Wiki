import assert from 'node:assert/strict';
import {DatabaseSync} from 'node:sqlite';
import {readFileSync} from 'node:fs';
import {handlePondsterVisitor,visitorProfile,naturalConversationRecorder,expireVisitorHistory,RETENTION_MS} from '../worker/pondster-visitors.ts';
import {firstName,nameFromReply,visitorGreeting,visitorLiveInstructions} from '../lib/pondster-visitor.ts';
import {buildPondsterLiveSession} from '../lib/pondster-live-context.ts';
import {createPondsterLiveControl} from '../worker/pondster-live.ts';
const sqlite=new DatabaseSync(':memory:');
sqlite.exec(readFileSync(new URL('../drizzle/0003_mature_ink.sql',import.meta.url),'utf8'));
function statement(sql,values=[]){return{bind(...args){return statement(sql,args);},async first(){return sqlite.prepare(sql).get(...values)??null;},async all(){return{results:sqlite.prepare(sql).all(...values)};},async run(){const result=sqlite.prepare(sql).run(...values);return{success:true,meta:{changes:Number(result.changes)}};}};}
const db={prepare:statement,async batch(statements){sqlite.exec('BEGIN');try{const results=[];for(const s of statements)results.push(await s.run());sqlite.exec('COMMIT');return results;}catch(error){sqlite.exec('ROLLBACK');throw error;}}};
const origin='https://pondstr.example',jobs=[];const ctx={waitUntil:task=>jobs.push(task)};
let token='';
async function call(body,options={}){
  const headers={...(token?{cookie:token}:{}),...(body?{'content-type':'application/json',origin}:{}),...options.headers};
  const response=await handlePondsterVisitor(new Request(origin+'/api/visitor'+(options.query||''),{method:body?'POST':'GET',headers,...(body?{body:JSON.stringify(body)}:{})}),{DB:db},ctx);
  await Promise.all(jobs.splice(0));
  const value=await response.json();return{response,value};
}
const count=table=>sqlite.prepare(`SELECT COUNT(*) AS n FROM ${table}`).get().n;
const one=sql=>sqlite.prepare(sql).get();
assert.equal(RETENTION_MS,90*86400000);
assert.equal(firstName('Ada Lovelace'),'Ada','Keep only the first name.');
assert.equal(firstName('<script>'),null);assert.equal(firstName('A'.repeat(33)),null);
assert.equal(firstName('Élodie'),'Élodie');assert.equal(firstName('Anne-Marie'),'Anne-Marie');
for(const question of ['HVAC','General contractor','Living Room','Show the kitchen','No thanks','I’m interested','Take me on a tour'])assert.equal(nameFromReply(question,true),null,question);
assert.equal(nameFromReply('Ada',true),'Ada');assert.equal(nameFromReply('Ada',false),null);
assert.equal(nameFromReply('My name is Ada Lovelace',false),'Ada');
assert.equal(nameFromReply('You can call me Élodie',false),'Élodie');
const firstGreeting=visitorGreeting({choice:'save',firstName:null,returning:false});
assert.match(firstGreeting,/I’m Pondster.*first name/);
const returning={choice:'save',firstName:'Ada',returning:true};
assert.equal(visitorGreeting(returning),'Welcome back, Ada. What do you need?');
assert.doesNotMatch(visitorGreeting(returning),/Pondster|saved|record/i);
assert.doesNotMatch(firstGreeting,/saved|record/i,'No spoken storage announcement.');
assert.match(visitorLiveInstructions(returning),/not verified identity/);
assert.match(visitorLiveInstructions(returning),/wait for confirmation/);
assert.match(visitorLiveInstructions({...returning,choice:'private'}),/never claim to remember a name on a later visit/);
const live=buildPondsterLiveSession([],returning);
assert.equal(live.store,false);assert.equal(live.audio.output.voice,'vesper');assert.match(live.input[0].content[0].text,/Welcome back, Ada/);

assert.deepEqual((await call()).value,{visitor:{choice:'unknown',firstName:null,returning:false}});
assert.equal(count('pondster_visitors'),0);
assert.equal((await call({action:'name',firstName:'Ada'})).response.status,409);
let result=await call({action:'choose',save:false});token=result.response.headers.get('set-cookie').split(';')[0];
assert.equal((await call()).value.visitor.choice,'private');assert.equal(count('pondster_visitors'),0,'No profile without opt-in.');
result=await call({action:'choose',save:true},{headers:{origin:'https://other.example'}});assert.equal(result.response.status,403);
result=await call({action:'choose',save:true});assert.equal(result.response.status,201);
token=result.response.headers.get('set-cookie').split(';')[0];
assert.match(result.response.headers.get('set-cookie'),/HttpOnly; SameSite=Strict.*Secure/);
assert.equal(count('pondster_visitors'),1);
assert.ok(!one('SELECT id FROM pondster_visitors').id.includes(token.split('=')[1]),'The browser token is hashed in storage.');
const firstToken=token;
result=await call({action:'begin',mode:'typed'});const conversationId=result.value.conversationId;
assert.equal(result.response.status,201);assert.match(result.value.greeting,/I’m Pondster/);
result=await call({action:'introduced',conversationId});assert.equal(result.value.visitor.returning,true);
assert.match(result.value.greeting,/first name/);
result=await call({action:'name',firstName:'Ada Lovelace'});assert.equal(result.value.visitor.firstName,'Ada');
const exchange={action:'turn',conversationId,eventId:crypto.randomUUID(),question:'Who is your general contractor?',answer:'Here’s my general contractor.'};
assert.equal((await call(exchange)).value.saved,true);const before=count('pondster_conversation_events');
await call(exchange);assert.equal(count('pondster_conversation_events'),before,'Same event ID deduplicates retries.');
assert.equal((await call({action:'name',firstName:'<script>'})).response.status,400);
result=await call(undefined,{query:'?conversationId='+conversationId});
assert.deepEqual(Object.keys(result.value),['visitor'],'Public GET never returns transcripts or conversation IDs.');
assert.equal(result.value.visitor.firstName,'Ada');
assert.match(result.response.headers.get('cache-control'),/no-store, private/);
result=await call({action:'begin',mode:'browser'});assert.equal(result.value.greeting,'Welcome back, Ada. What do you need?');

const profile=await visitorProfile(new Request(origin,{headers:{cookie:token}}),db);
const notices=[];const writer=naturalConversationRecorder(db,profile,message=>notices.push(message));
const naturalId=crypto.randomUUID();await writer.start(naturalId);await writer.greetingSent();
for(const event of [
 {type:'session.input_transcript.delta',event_id:'in-1',delta:'My name is',start_ms:0,end_ms:200},
 {type:'session.input_transcript.delta',event_id:'in-2',delta:' Élodie',start_ms:200,end_ms:500},
 {type:'session.output_transcript.delta',event_id:'out-1',delta:'Hello,',start_ms:600,end_ms:800},
 {type:'session.output_transcript.delta',event_id:'out-2',delta:' Élodie. Élodie.',start_ms:800,end_ms:1000},
])await writer.event(event);
await writer.event({type:'session.input_transcript.delta',event_id:'in-1',delta:'My name is',start_ms:0,end_ms:200});
await writer.event({type:'session.input_audio.append',audio:'never-save-this-audio'});
await writer.event({type:'session.output_audio.delta',delta:'never-save-this-audio'});
assert.equal(await writer.name('HVAC'),null);assert.match(await writer.name('My name is Élodie'),/Nice to meet you, Élodie/);
assert.equal(writer.currentVisitor().firstName,'Élodie');await writer.text('Typed during voice');await writer.finish();
const events=sqlite.prepare('SELECT * FROM pondster_conversation_events WHERE conversation_id=? ORDER BY sequence').all(naturalId);
assert.deepEqual(events.map(event=>event.text),['My name is',' Élodie','Hello,',' Élodie. Élodie.','Typed during voice']);
assert.deepEqual(events.slice(0,4).map(event=>[event.start_ms,event.end_ms]),[[0,200],[200,500],[600,800],[800,1000]]);
assert.ok(events.every(event=>event.expires_at<=profile.expires_at));assert.equal(notices.length,0);
assert.ok(sqlite.prepare('SELECT ended_at FROM pondster_conversations WHERE id=?').get(naturalId).ended_at);

// A new browser cannot read or append to someone else's conversation.
token='';assert.equal((await call()).value.visitor.firstName,null);
assert.equal((await call(exchange)).response.status,409);
result=await call({action:'choose',save:true});token=result.response.headers.get('set-cookie').split(';')[0];
assert.equal((await call(exchange)).response.status,409);
assert.equal((await call({action:'begin',mode:'natural'})).response.status,400,'Only the trusted natural server may create that recording mode.');
result=await call({action:'reset'});token=result.response.headers.get('set-cookie').split(';')[0];
assert.equal((await call()).value.visitor.choice,'unknown');assert.equal((await call()).value.visitor.firstName,null);
assert.equal(count('pondster_visitors'),2,'Start fresh disassociates this browser without exposing or overwriting the previous profile.');

// Exercise the actual control-to-sideband recorder wiring without network/audio.
class Socket extends EventTarget{
  sent=[];
  send(raw){const event=JSON.parse(raw);this.sent.push(event);if(event.type==='session.close')queueMicrotask(()=>this.emit({type:'session.closed',usage:{seconds:1}}));}
  close(){}
  emit(value){this.dispatchEvent(new MessageEvent('message',{data:JSON.stringify(value)}));}
}
const client=new Socket(),sideband=new Socket();
const connected=naturalConversationRecorder(db,profile,message=>notices.push(message));
const connectedId=crypto.randomUUID();
const control=createPondsterLiveControl({client,history:connected,visitorKey:'synthetic',
  store:{async reserve(){return true;},async activate(){},async finish(){}},
  async createSession(){await connected.start(connectedId);return{id:'live_synthetic',sdp:'v=0\r\ns=synthetic\r\n'};},
  async attach(){return sideband;},greetingInstructions:()=>visitorLiveInstructions(connected.visitor),
  answer(){return{text:'Here is my public answer.'};},
});
await control.message(JSON.stringify({type:'pondster.start',requestId:connectedId,sdp:'v=0\r\ns=synthetic\r\n'}));
await control.message(JSON.stringify({type:'pondster.started'}));
assert.match(sideband.sent[0].content,/Welcome back, Élodie/);
await control.message(JSON.stringify({type:'pondster.text',text:'My name is Bea'}));
assert.equal(client.sent.findLast(event=>event.type==='pondster.visitor').visitor.firstName,'Bea');
assert.match(sideband.sent.findLast(event=>event.type==='session.commentary.append').content,/Nice to meet you, Bea/);
sideband.emit({type:'session.output_transcript.delta',event_id:'connected-out',delta:'Nice to meet you, Bea.',start_ms:0,end_ms:1000});
await control.stop();
assert.deepEqual(sqlite.prepare('SELECT role,text FROM pondster_conversation_events WHERE conversation_id=? ORDER BY sequence').all(connectedId).map(row=>({...row})),[
 {role:'visitor',text:'My name is Bea'},{role:'pondster',text:'Nice to meet you, Bea.'}
]);

token=firstToken;await expireVisitorHistory(db,profile.expires_at+1);
assert.equal(await visitorProfile(new Request(origin,{headers:{cookie:token}}),db,profile.expires_at+1),null);
assert.equal(count('pondster_conversation_events'),0);assert.equal(count('pondster_conversations'),0);
assert.equal(sqlite.prepare('SELECT COUNT(*) AS n FROM pondster_visitors WHERE id=?').get(profile.id).n,0);

// The disclosure lives exclusively in Voice controls, never a header or greeting.
const guide=readFileSync(new URL('../app/pondster-guide.tsx',import.meta.url),'utf8');
assert.ok(guide.indexOf('className="pondster-preferences"')>guide.indexOf('className="pondster-voice"'));
const page=readFileSync(new URL('../app/page.tsx',import.meta.url),'utf8');
assert.doesNotMatch(page,/save our text|saved conversations|conversation saving preferences/i);
console.log('PASS: consent/private mode, 90-day expiry and deletion, first-name greeting/return, browser isolation/reset, no public transcript reader, exact deduplicated natural text/timing, no audio, and notice only in Voice controls (in-memory SQLite, no provider).');
