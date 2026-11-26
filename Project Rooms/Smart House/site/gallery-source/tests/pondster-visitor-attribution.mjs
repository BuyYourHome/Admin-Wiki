import assert from 'node:assert/strict';
import {DatabaseSync} from 'node:sqlite';
import {readFileSync} from 'node:fs';
import {handlePondsterVisitor,visitorProfile,naturalConversationRecorder,expireVisitorHistory,RETENTION_MS} from '../worker/pondster-visitors.ts';

const sqlite=new DatabaseSync(':memory:');
for(const file of ['0003_mature_ink','0004_nappy_captain_america'])sqlite.exec(readFileSync(new URL('../drizzle/'+file+'.sql',import.meta.url),'utf8'));
const legacyProfile='0'.repeat(64),legacyConversation='00000000-0000-4000-8000-000000000001',deadline=Date.now()+RETENTION_MS;
sqlite.prepare('INSERT INTO pondster_visitors(id,first_name,consent_at,expires_at) VALUES(?,?,?,?)').run(legacyProfile,'Current',0,deadline);
sqlite.prepare('INSERT INTO pondster_conversations(id,visitor_id,mode,started_at,expires_at) VALUES(?,?,?,?,?)').run(legacyConversation,legacyProfile,'typed',1,deadline);
sqlite.exec(readFileSync(new URL('../drizzle/0006_cuddly_siren.sql',import.meta.url),'utf8'));
sqlite.exec(readFileSync(new URL('../drizzle/0007_tranquil_iceman.sql',import.meta.url),'utf8'));
const row=id=>sqlite.prepare('SELECT * FROM pondster_conversations WHERE id=?').get(id);
assert.equal(row(legacyConversation).remembered_first_name,null);assert.equal(row(legacyConversation).first_self_reported_name,null);assert.equal(row(legacyConversation).first_self_reported_at,null,'Migration never backfills a historical identity from the current profile.');
function statement(sql,values=[]){return{bind(...args){return statement(sql,args);},async first(){return sqlite.prepare(sql).get(...values)??null;},async run(){const r=sqlite.prepare(sql).run(...values);return{success:true,meta:{changes:Number(r.changes)}};}};}
const db={prepare:statement,async batch(items){sqlite.exec('BEGIN');try{const rows=[];for(const item of items)rows.push(await item.run());sqlite.exec('COMMIT');return rows;}catch(error){sqlite.exec('ROLLBACK');throw error;}}};
const origin='https://pondstr.example';let token='';
async function call(body){const tasks=[];const response=await handlePondsterVisitor(new Request(origin+'/api/visitor',{method:body?'POST':'GET',headers:{...(token?{cookie:token}:{}),...(body?{origin,'content-type':'application/json'}:{})},...(body?{body:JSON.stringify(body)}:{})}),{DB:db},{waitUntil:task=>tasks.push(task)});await Promise.all(tasks);return{status:response.status,value:await response.json(),cookie:response.headers.get('set-cookie')?.split(';')[0]};}
const count=()=>sqlite.prepare('SELECT COUNT(*) AS n FROM pondster_visitor_name_events').get().n;
const history=id=>sqlite.prepare('SELECT * FROM pondster_visitor_name_events WHERE conversation_id=? ORDER BY rowid').all(id);
let response=await call({action:'choose',save:true,default:true});token=response.cookie;const firstToken=token;
const profile=()=>visitorProfile(new Request(origin,{headers:{cookie:token}}),db);
assert.equal((await call({action:'name',firstName:'Wes',fromForm:true,eventId:crypto.randomUUID()})).status,200);
const a=(await call({action:'begin',mode:'typed'})).value.conversationId;
assert.equal(row(a).remembered_first_name,'Wes');assert.equal(row(a).first_self_reported_name,null,'A remembered browser name is not a new explicit self-report.');
const wesReport={action:'name',firstName:'Wes',conversationId:a,eventId:crypto.randomUUID()};assert.equal((await call(wesReport)).status,200);
assert.equal(row(a).first_self_reported_name,'Wes');assert.ok(row(a).first_self_reported_at>0);
assert.equal(history(a)[0].source,'typed_reply');assert.equal(history(a)[0].previous_first_name,'Wes','A same-name report still establishes explicit attribution for this conversation.');
const b=(await call({action:'begin',mode:'browser'})).value.conversationId;
const alexReport={action:'name',firstName:'Alex',conversationId:b,eventId:crypto.randomUUID()};assert.equal((await call(alexReport)).status,200);
const firstAt=row(b).first_self_reported_at;
assert.equal((await call({action:'name',firstName:'Jamie',conversationId:b,eventId:crypto.randomUUID()})).status,200);
assert.equal(row(a).remembered_first_name,'Wes');assert.equal(row(a).first_self_reported_name,'Wes');
assert.equal(row(b).remembered_first_name,'Wes');assert.equal(row(b).first_self_reported_name,'Alex');assert.equal(row(b).first_self_reported_at,firstAt,'Later corrections do not overwrite the immutable first report.');
assert.deepEqual(history(b).map(event=>[event.previous_first_name,event.first_name,event.source]),[['Wes','Alex','browser_reply'],['Alex','Jamie','browser_reply']]);
const beforeReplay=count();response=await call(alexReport);assert.equal(response.value.visitor.firstName,'Jamie');assert.equal(count(),beforeReplay,'An idempotent retry adds no name event and cannot roll back a later profile name.');
assert.equal((await call({...alexReport,firstName:'Marisol'})).status,503);assert.equal((await profile()).first_name,'Jamie','Conflicting reuse of a request ID changes nothing.');
assert.equal((await call({action:'name',firstName:'Casey',fromForm:true,eventId:crypto.randomUUID()})).status,200);
assert.equal(row(a).first_self_reported_name,'Wes');assert.equal(row(b).first_self_reported_name,'Alex');
assert.equal(sqlite.prepare('SELECT conversation_id FROM pondster_visitor_name_events ORDER BY rowid DESC LIMIT 1').get().conversation_id,null,'A profile-only form event does not guess a conversation.');
await call({action:'end',conversationId:b});const beforeClosed=count();assert.equal((await call({action:'name',firstName:'Closed',conversationId:b,eventId:crypto.randomUUID()})).status,409);assert.equal(count(),beforeClosed);

// The Voice-controls form can use the exact current natural attempt ID, checked by the server.
const notices=[],writerProfile=await profile(),writer=naturalConversationRecorder(db,writerProfile,text=>notices.push(text)),naturalId=crypto.randomUUID();await writer.start(naturalId);
assert.equal(row(naturalId).remembered_first_name,'Casey');
assert.equal((await call({action:'name',firstName:'Blaire',fromForm:true,conversationId:naturalId,eventId:crypto.randomUUID()})).status,200);
assert.equal(row(naturalId).first_self_reported_name,'Blaire');assert.equal(history(naturalId)[0].source,'name_form');
assert.equal(await writer.name('Who is your HVAC contractor?'),null);assert.equal(writer.currentVisitor().firstName,'Blaire','The recorder refreshes an external form update without rewriting its stale startup name.');
const stable='natural:'+naturalId+':100:500';await writer.name('My name is Blaire',stable);const beforeNaturalRetry=count();await writer.name('My name is Blaire',stable);assert.equal(count(),beforeNaturalRetry);
await writer.name('Call me Morgan','natural:'+naturalId+':600:900');
assert.equal(history(naturalId).at(-1).previous_first_name,'Blaire');assert.equal(history(naturalId).at(-1).source,'natural_reply');
assert.equal(row(naturalId).remembered_first_name,'Casey');assert.equal(row(naturalId).first_self_reported_name,'Blaire');
const afterMorgan=count(),replayed=await Promise.all([writer.name('My name is Blaire',stable),writer.name('My name is Blaire',stable)]);
assert.equal(count(),afterMorgan);assert.equal(writer.currentVisitor().firstName,'Morgan','Same-time replay of the same spoken input cannot revert a later name.');
assert.ok(replayed.every(text=>!text.includes('Blaire')),'A replay cannot produce a stale-name greeting after a later correction.');
assert.ok(history(naturalId).every(event=>event.expires_at===writerProfile.expires_at));
await writer.finish();assert.equal((await call({action:'name',firstName:'Closed',fromForm:true,conversationId:naturalId,eventId:crypto.randomUUID()})).status,409);

token='';response=await call({action:'choose',save:true});token=response.cookie;const outsider=await profile(),beforeForeign=count();
assert.equal((await call({action:'name',firstName:'Foreign',conversationId:a,eventId:crypto.randomUUID()})).status,409);assert.equal(count(),beforeForeign);assert.equal((await profile()).first_name,null);
token=firstToken;
const opted=naturalConversationRecorder(db,await profile(),text=>notices.push(text)),optedId=crypto.randomUUID();await opted.start(optedId);
await call({action:'choose',save:false});const beforeOff=count();await opted.name('My name is Never');assert.equal(count(),beforeOff);assert.equal(opted.currentVisitor().choice,'private');
assert.equal((await call({action:'name',firstName:'Never',conversationId:optedId,eventId:crypto.randomUUID()})).status,409);await opted.finish();
response=await call();assert.deepEqual(Object.keys(response.value),['visitor']);assert.equal(response.value.visitor.firstName,null,'Public GET still returns only the current browser preference, never history or snapshots.');
assert.equal(row(legacyConversation).first_self_reported_name,null,'Later writes do not backfill historical attribution.');

// Bounded expiry must drain child history before removing its conversation/profile.
const expiredId='e'.repeat(64),expiredConversation=crypto.randomUUID();
sqlite.prepare('INSERT INTO pondster_visitors(id,consent_at,expires_at) VALUES(?,?,?)').run(expiredId,0,1);
sqlite.prepare('INSERT INTO pondster_conversations(id,visitor_id,mode,started_at,expires_at) VALUES(?,?,?,?,?)').run(expiredConversation,expiredId,'typed',0,1);
const insert=sqlite.prepare('INSERT INTO pondster_visitor_name_events(id,request_id,visitor_id,conversation_id,first_name,source,created_at,expires_at) VALUES(?,?,?,?,?,?,?,?)');
sqlite.exec('BEGIN');for(let n=0;n<5001;n++)insert.run('expiry-'+n,'expiry-'+n,expiredId,expiredConversation,'Name','name_form',0,1);sqlite.exec('COMMIT');
await expireVisitorHistory(db,2);assert.ok(row(expiredConversation));assert.ok(sqlite.prepare('SELECT id FROM pondster_visitors WHERE id=?').get(expiredId),'An expired parent remains while a bounded child batch is not yet drained.');
await expireVisitorHistory(db,2);assert.equal(row(expiredConversation),undefined);assert.equal(sqlite.prepare('SELECT id FROM pondster_visitors WHERE id=?').get(expiredId),undefined);
await expireVisitorHistory(db,Math.max(deadline,writerProfile.expires_at,outsider.expires_at)+1);assert.equal(count(),0);assert.equal(row(a),undefined);
const ui=readFileSync(new URL('../app/pondster-guide.tsx',import.meta.url),'utf8');assert.match(ui,/currentConversationId\(\)\?\?localConversation.current\?\.id/);assert.match(ui,/fromForm:true/);
console.log('PASS: additive legacy-null migration, immutable remembered/first-explicit names, timestamped per-chat corrections, request replay isolation, current natural form binding, external-name refresh, ownership/ended/opt-out checks, no public history and child-first bounded retention. SQLite only.');
