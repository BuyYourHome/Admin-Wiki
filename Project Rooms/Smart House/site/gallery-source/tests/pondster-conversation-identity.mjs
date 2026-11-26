import assert from 'node:assert/strict';
import {DatabaseSync} from 'node:sqlite';
import {readFileSync} from 'node:fs';
import {resolveConversationIdentity} from '../lib/pondster-conversation-identity.ts';
import {firstName,nameFromReply,visitorLiveInstructions} from '../lib/pondster-visitor.ts';
import {handleLightingMcp} from '../worker/lighting-source.ts';
import {handlePondsterVisitor} from '../worker/pondster-visitors.ts';
import {callConversationEmailTool,EMAIL_START_AFTER_MS} from '../worker/pondster-conversation-email.ts';

const text=rows=>rows.map(([role,value],sequence)=>({role,text:value,sequence,created_at:1000+sequence*1000,start_ms:null,end_ms:null}));
const welcome=['pondster','Welcome back, Alex. What do you need?'],continuation=['visitor','Show me the deck.'];
const resolve=(rows,facts={},reports=[])=>resolveConversationIdentity(facts,text(rows),reports);
assert.equal(resolve([welcome]).basis,'unknown','A greeting alone does not establish who conversed.');
assert.equal(resolve([continuation],{remembered_first_name:'Alex'}).basis,'unknown','Remembered name alone is not the actual named greeting.');
assert.deepEqual(Object.fromEntries(Object.entries(resolve([welcome,continuation])).filter(([key])=>['label','basis','source'].includes(key))),{label:'Alex',basis:'assumed',source:'welcome_back_continuation'});
for(const phrase of ['You can call me Pat','My name is Pat','This is Pat talking','This is Pat speaking','This is Pat','Oh this is Pat','Oh, this is Pat','My name is Pat. Show me the lights.','My name is Pat. For example, show me the lights.']){
 const found=resolve([welcome,['visitor',phrase]]);assert.equal(found.label,'Pat',phrase);assert.equal(found.basis,'explicit',phrase);
}
assert.equal(nameFromReply('This is Jenny talking',false),'Jenny','Narrow speaking-introduction pattern.');
for(const phrase of ['Oh this is Alec','This is Alec','Oh, this is Alec'])assert.equal(nameFromReply(phrase,false),'Alec',phrase);
for(const phrase of ['This is beautiful','This is Beautiful','This is helpful','This is Helpful','This is my house','This is the kitchen','This is Home Assistant','This is Pat?','He said this is Pat','"This is Pat"','For example, this is Pat']){
 assert.equal(nameFromReply(phrase,false),null,phrase);
 assert.equal(resolve([welcome,['visitor',phrase]]).label,'Alex',phrase+' is ordinary continuation, not a replacement self-ID.');
}
for(const phrase of ['Mm. Address me as Alex’s son','Address me as Alex\'s son','You can call me Alex’s daughter']){
 const expected=phrase.includes('daughter')?'Alex’s daughter':'Alex’s son';assert.equal(nameFromReply(phrase,false),expected);assert.equal(firstName(expected),expected);assert.equal(resolve([welcome,['visitor',phrase]]).label,expected);
}
for(const invalid of ['Alex’s','Alex’s son and owner','Alex’s administrator','Alex’s son who owns this place','<script>'])assert.equal(firstName(invalid),null,invalid);
for(const phrase of ["No, I'm not Alex",'not Alex',"Don’t call me Alex","That’s not my name"]){const found=resolve([welcome,['visitor',phrase],continuation]);assert.equal(found.label,null,phrase);assert.equal(found.basis,'unknown');}
assert.equal(resolve([welcome,['visitor','The contractor is not Alex.']]).label,'Alex','A third-person statement is not the visitor rejecting the name.');
for(const phrase of ["No, I'm having trouble","No, I'm working","No, I'm cleaning","No, I'm looking around"]){assert.equal(resolve([welcome,['visitor',phrase]]).label,'Alex',phrase+' is not a new identity.');}
for(const phrase of ["My name is Alex. Actually, I am not Alex.",'My name is Alex. Don’t call me Alex.'])assert.equal(resolve([['visitor',phrase]]).label,null,'A later negative correction in one turn overrides the earlier positive declaration.');
assert.equal(resolve([['visitor','My name is Alex. Actually, I am not Alex. This is Pat talking.']]).label,'Pat');
assert.equal(nameFromReply("No, I'm Pat",false),'Pat');
for(const phrase of ["No, I'm having trouble","No, I'm working","No, I'm cleaning","I'm looking","I'm having trouble"])assert.equal(nameFromReply(phrase,false),null,phrase);
assert.equal(nameFromReply("I'm cleaning",true),null,'A pending name question still does not turn ordinary gerunds into names.');
assert.equal(resolve([['pondster','Welcome back, Alex’s son. What do you need?'],continuation]).label,'Alex’s son');
for(const phrase of ['For example, welcome back, Alex.','I might say Welcome back, Alex.','"Welcome back, Alex."'])assert.equal(resolve([['pondster',phrase],continuation]).label,null,phrase);
for(const phrase of ['"My name is Pat"','For example, my name is Pat.','He said my name is Pat.'])assert.equal(resolve([['visitor',phrase]]).label,null,phrase);
assert.equal(resolve([['pondster','My name is Pat.'],continuation]).label,null,'Pondster self-statements are not visitor identity.');
assert.equal(resolve([welcome,['visitor','My name is Pat.'],['visitor','Call me Casey.']]).label,'Casey','Separate same-role declarations retain the latest correction.');
const fragments=[
 {role:'pondster',text:'Wel',sequence:0,created_at:1000,start_ms:0,end_ms:100},
 {role:'pondster',text:'come back, ',sequence:1,created_at:1010,start_ms:100,end_ms:200},
 {role:'pondster',text:'Alex.',sequence:2,created_at:1020,start_ms:200,end_ms:300},
 {role:'visitor',text:'This is',sequence:3,created_at:2000,start_ms:500,end_ms:600},
 {role:'visitor',text:' Pat',sequence:4,created_at:2010,start_ms:600,end_ms:700},
 {role:'visitor',text:' talking',sequence:5,created_at:2020,start_ms:700,end_ms:800},
];
assert.equal(resolveConversationIdentity({},fragments.slice(0,3)).label,null);
assert.equal(resolveConversationIdentity({},[...fragments.slice(0,3),{...fragments[3],text:'Show my rooms.'}]).basis,'assumed');
assert.equal(resolveConversationIdentity({},fragments).label,'Pat','Natural fragments are joined before self-ID parsing.');
assert.equal(resolve([welcome,continuation],{},[{first_name:'Casey',source:'name_form',created_at:5000}]).label,'Casey','A later conversation-bound name form overrides an assumption.');
const instructions=visitorLiveInstructions({choice:'save',firstName:'Alex',returning:true});assert.match(instructions,/assumed conversational label/);assert.match(instructions,/never verifies identity or grants permissions/);

const sql=new DatabaseSync(':memory:');for(const file of ['0002_flat_agent_brand','0003_mature_ink','0004_nappy_captain_america','0005_open_the_hunter','0006_cuddly_siren','0007_tranquil_iceman'])sql.exec(readFileSync(new URL('../drizzle/'+file+'.sql',import.meta.url),'utf8'));
function statement(query,values=[]){return{bind(...next){return statement(query,next);},async first(){return sql.prepare(query).get(...values)??null;},async all(){return{results:sql.prepare(query).all(...values)};},async run(){const result=sql.prepare(query).run(...values);return{success:true,meta:{changes:Number(result.changes)}};}};}
const DB={prepare:statement,async batch(items){sql.exec('BEGIN');try{const result=[];for(const item of items)result.push(await item.run());sql.exec('COMMIT');return result;}catch(error){sql.exec('ROLLBACK');throw error;}}};
const now=Math.max(Date.now(),EMAIL_START_AFTER_MS+3600000),expiry=now+90*86400000,profile='a'.repeat(64),ids=[crypto.randomUUID(),crypto.randomUUID()];
sql.prepare('INSERT INTO pondster_visitors(id,first_name,consent_at,expires_at) VALUES(?,?,?,?)').run(profile,'MutableToday',0,expiry);
for(const [index,id] of ids.entries()){
 sql.prepare('INSERT INTO pondster_conversations(id,visitor_id,mode,started_at,ended_at,expires_at,remembered_first_name) VALUES(?,?,?,?,?,?,?)').run(id,profile,'typed',now-600000+index,now-300000,expiry,'Alex');
 for(const event of text([welcome,index?['visitor','This is Pat talking']:continuation]))sql.prepare('INSERT INTO pondster_conversation_events(conversation_id,event_id,sequence,role,text,created_at,expires_at) VALUES(?,?,?,?,?,?,?)').run(id,crypto.randomUUID(),event.sequence,event.role,event.text,now-400000+event.sequence,expiry);
}
const before=()=>JSON.stringify({visitors:sql.prepare('SELECT * FROM pondster_visitors ORDER BY id').all(),conversations:sql.prepare('SELECT * FROM pondster_conversations ORDER BY id').all(),names:sql.prepare('SELECT * FROM pondster_visitor_name_events ORDER BY id').all()});
const original=before();
async function rpc(args={},email='owner@example.test'){const response=await handleLightingMcp(new Request('https://pondster.example/mcp',{method:'POST',headers:{...(email?{'oai-authenticated-user-email':email}:{})},body:JSON.stringify({jsonrpc:'2.0',id:1,method:'tools/call',params:{name:'review_conversation_identities',arguments:args}})}),{DB,LIGHTING_SYNC_OWNER_EMAIL:'owner@example.test'});return{status:response.status,value:await response.json()};}
for(const email of [null,'visitor@example.test'])assert.equal((await rpc({},email)).status,403,'Identity review remains owner-only.');
let page=await rpc({limit:1});assert.equal(page.status,200);const first=page.value.result.structuredContent;assert.equal(first.conversations[0].identity.label,'Alex');assert.equal(first.conversations[0].identity.basis,'assumed');assert.ok(first.next_cursor);
page=await rpc({limit:1,cursor:first.next_cursor});assert.equal(page.value.result.structuredContent.conversations[0].identity.label,'Pat');assert.equal(page.value.result.structuredContent.next_cursor,null);
assert.equal((await rpc({limit:26})).status,400);assert.equal((await rpc({cursor:'arbitrary SQL'})).status,400);assert.equal((await rpc({profile_name:'Alex'})).status,400);
assert.equal(before(),original,'Owner review never rewrites raw conversation/profile/name history or backfills legacy identity fields.');
const prepared=await callConversationEmailTool(DB,'prepare_conversation_emails',{limit:5},now),assumedEmail=prepared.prepared.find(row=>row.conversation_id===ids[0]);assert.ok(assumedEmail);
const body=(await callConversationEmailTool(DB,'read_conversation_email',{email_id:assumedEmail.email_id,body_hash:assumedEmail.body_hash},now)).chunk_text;
assert.match(body,/Guest: Alex \(assumed from the uncorrected welcome-back greeting\)/);assert.doesNotMatch(body,/Not provided|Not recorded|MutableToday|Name offered during this conversation/,'Effective guest label leads, without blank technical identity fields.');

// The same validator accepts a full relational preferred label through the existing API.
let token='';const origin='https://pondster.example';
async function visitor(body){const jobs=[];const response=await handlePondsterVisitor(new Request(origin+'/api/visitor',{method:'POST',headers:{origin,'content-type':'application/json',...(token?{cookie:token}:{})},body:JSON.stringify(body)}),{DB},{waitUntil:task=>jobs.push(task)});await Promise.all(jobs);return{response,value:await response.json()};}
let result=await visitor({action:'choose',save:true});token=result.response.headers.get('set-cookie').split(';')[0];result=await visitor({action:'name',firstName:'Alex’s son',fromForm:true,eventId:crypto.randomUUID()});assert.equal(result.response.status,200);assert.equal(result.value.visitor.firstName,'Alex’s son');
console.log('PASS: explicit/corrected vs assumed guest labels, actual named greeting plus visitor continuation, fragmented speech, relational aliases, guarded ordinary/quoted/third-party language, owner-only paginated read with no backfill, effective email guest label and API alias validation.');
