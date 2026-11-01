import { firstName, nameFromReply, visitorGreeting, type PondsterVisitor } from '../lib/pondster-visitor';

const COOKIE='pondster_conversation_preference';
export const RETENTION_MS=90*24*60*60*1000;
const TOKEN=/^[a-f0-9]{64}$/;
const ID=/^[a-f0-9-]{36}$/;
type Profile={id:string;first_name:string|null;consent_at:number;created_at:number;saving_enabled:number;preference_basis:string;introduced_at:number|null;expires_at:number};
type Conversation={id:string;visitor_id:string;mode:string;expires_at:number};
export type VisitorEnvironment={DB?:D1Database};
function cookie(request:Request){return request.headers.get('cookie')?.split(';').map(part=>part.trim()).find(part=>part.startsWith(COOKIE+'='))?.slice(COOKIE.length+1)??null;}
async function digest(token:string){return Array.from(new Uint8Array(await crypto.subtle.digest('SHA-256',new TextEncoder().encode(token))),byte=>byte.toString(16).padStart(2,'0')).join('');}
export async function visitorProfile(request:Request,db:D1Database,now=Date.now()):Promise<Profile|null>{
  const token=cookie(request);if(!token||!TOKEN.test(token))return null;
  return db.prepare('SELECT id,first_name,consent_at,created_at,saving_enabled,preference_basis,introduced_at,expires_at FROM pondster_visitors WHERE id=? AND expires_at>?').bind(await digest(token),now).first<Profile>();
}
function publicProfile(profile:Profile|null,privateChoice=false):PondsterVisitor{return profile?.saving_enabled===1?{choice:'save',firstName:profile.first_name,returning:profile.introduced_at!==null}:{choice:privateChoice||profile?.saving_enabled===0?'private':'unknown',firstName:null,returning:false};}
export async function expireVisitorHistory(db:D1Database,now=Date.now()){
  // Schema is migration-owned. Bounded housekeeping; expired rows are never read.
  await db.batch([
    db.prepare('DELETE FROM pondster_conversation_events WHERE rowid IN (SELECT rowid FROM pondster_conversation_events WHERE expires_at<=? LIMIT 5000)').bind(now),
    db.prepare('DELETE FROM pondster_conversations WHERE id IN (SELECT id FROM pondster_conversations WHERE expires_at<=? LIMIT 500)').bind(now),
    db.prepare('DELETE FROM pondster_visitors WHERE id IN (SELECT id FROM pondster_visitors WHERE expires_at<=? LIMIT 500)').bind(now),
  ]);
}
export async function beginSavedConversation(db:D1Database,profile:Profile,id:string,mode:'natural'|'browser'|'typed',now=Date.now()){
  const inserted=await db.prepare(`INSERT INTO pondster_conversations(id,visitor_id,mode,started_at,expires_at)
    SELECT ?,?,?,?,? WHERE EXISTS(SELECT 1 FROM pondster_visitors WHERE id=? AND expires_at>? AND saving_enabled=1)
    AND (SELECT COUNT(*) FROM pondster_conversations WHERE visitor_id=? AND started_at>?)<100
    AND (SELECT COUNT(*) FROM pondster_conversations WHERE started_at>?)<1000`).bind(id,profile.id,mode,now,profile.expires_at,profile.id,now,profile.id,now-86400000,now-86400000).run();
  if(!inserted.meta.changes)throw new Error('history unavailable');
  return {id,visitor_id:profile.id,mode,expires_at:profile.expires_at};
}
export async function appendConversationEvent(db:D1Database,conversation:Conversation,event:{id:string;role:'visitor'|'pondster';text:string;start?:number;end?:number},now=Date.now()){
  if(!event.text||event.text.length>8000||!event.id||event.id.length>256)throw new Error('invalid transcript fragment');
  const result=await db.prepare(`INSERT INTO pondster_conversation_events(conversation_id,event_id,sequence,role,text,start_ms,end_ms,created_at,expires_at)
    SELECT ?,?,COALESCE((SELECT MAX(sequence)+1 FROM pondster_conversation_events WHERE conversation_id=?),0),?,?,?,?,?,?
    WHERE EXISTS(SELECT 1 FROM pondster_visitors WHERE id=? AND expires_at>? AND saving_enabled=1)
    AND EXISTS(SELECT 1 FROM pondster_conversations WHERE id=? AND visitor_id=? AND expires_at>?)
    AND (SELECT COUNT(*) FROM pondster_conversation_events WHERE conversation_id=?)<5000
    AND COALESCE((SELECT SUM(LENGTH(text)) FROM pondster_conversation_events WHERE conversation_id=?),0)+?<=1000000
    ON CONFLICT(conversation_id,event_id) DO NOTHING`).bind(conversation.id,event.id,conversation.id,event.role,event.text,event.start??null,event.end??null,now,conversation.expires_at,conversation.visitor_id,now,conversation.id,conversation.visitor_id,now,conversation.id,conversation.id,event.text.length).run();
  if(!result.meta.changes){
    const duplicate=await db.prepare('SELECT 1 AS present FROM pondster_conversation_events WHERE conversation_id=? AND event_id=?').bind(conversation.id,event.id).first();
    if(!duplicate)throw new Error('history limit or expired consent');
  }
}
async function saveName(db:D1Database,profile:Profile,name:string,now=Date.now()){
  const result=await db.prepare('UPDATE pondster_visitors SET first_name=? WHERE id=? AND expires_at>? AND saving_enabled=1').bind(name,profile.id,now).run();
  if(!result.meta.changes)throw new Error('expired consent');profile.first_name=name;
}
async function introduced(db:D1Database,profile:Profile,now=Date.now()){
  await db.prepare('UPDATE pondster_visitors SET introduced_at=COALESCE(introduced_at,?) WHERE id=? AND expires_at>? AND saving_enabled=1').bind(now,profile.id,now).run();profile.introduced_at??=now;
}
async function boundedJson(request:Request){
  const reader=request.body?.getReader();if(!reader)throw new Error('body');let size=0,text='';const decoder=new TextDecoder();
  try{while(true){const chunk=await reader.read();if(chunk.done)break;size+=chunk.value.byteLength;if(size>20000){await reader.cancel();throw new Error('body');}text+=decoder.decode(chunk.value,{stream:true});}return JSON.parse(text+decoder.decode()) as Record<string,unknown>;}finally{reader.releaseLock();}
}
export async function handlePondsterVisitor(request:Request,env:VisitorEnvironment,ctx:{waitUntil:(task:Promise<unknown>)=>void}){
  const url=new URL(request.url),origin=request.headers.get('origin');
  const reply=(body:unknown,status=200,token?:string)=>{
    const headers=new Headers({'Content-Type':'application/json','Cache-Control':'no-store, private','Vary':'Cookie','X-Content-Type-Options':'nosniff'});
    if(token!==undefined)headers.set('Set-Cookie',`${COOKIE}=${token}; Path=/; HttpOnly; SameSite=Strict; Max-Age=${token?RETENTION_MS/1000:0}${url.protocol==='https:'?'; Secure':''}`);
    return new Response(JSON.stringify(body),{status,headers});
  };
  if(origin&&origin!==url.origin)return reply({error:'I can only use conversation preferences on my website.'},403);
  if(!env.DB)return reply({error:'My private conversation saving is unavailable.'},503);
  const db=env.DB;
  ctx.waitUntil(expireVisitorHistory(db).catch(()=>{}));
  try{
    let profile=await visitorProfile(request,db);
    if(request.method==='GET')return reply({visitor:publicProfile(profile,cookie(request)==='private')});
    if(request.method!=='POST')return reply({error:'I need a conversation preference request.'},405);
    if(origin!==url.origin)return reply({error:'I can only accept changes from my website.'},403);
    if(request.headers.get('content-type')?.split(';')[0].trim()!=='application/json')return reply({error:'I need a JSON preference.'},415);
    let input:Record<string,unknown>;try{input=await boundedJson(request);}catch{return reply({error:'I couldn’t read that request.'},400);}
    if(!input||typeof input!=='object'||Array.isArray(input))return reply({error:'I couldn’t read that request.'},400);
    if(input.action==='reset')return reply({visitor:publicProfile(null)},200,'');
    if(input.action==='choose'){
      if(input.save===false){
        if(profile)await db.prepare('UPDATE pondster_visitors SET saving_enabled=0 WHERE id=?').bind(profile.id).run();
        return reply({visitor:publicProfile(null,true)},200,'private');
      }
      if(input.save!==true)return reply({error:'Please choose whether to save text.'},400);
      if(profile?.saving_enabled===1)return reply({visitor:publicProfile(profile)});
      const token=crypto.randomUUID().replaceAll('-','')+crypto.randomUUID().replaceAll('-',''),now=Date.now();
      profile={id:await digest(token),first_name:null,consent_at:input.default===true?0:now,created_at:now,saving_enabled:1,preference_basis:input.default===true?'default_notice':'explicit_save',introduced_at:null,expires_at:now+RETENTION_MS};
      const inserted=await db.prepare('INSERT INTO pondster_visitors(id,consent_at,created_at,saving_enabled,preference_basis,expires_at) SELECT ?,?,?,?,?,? WHERE (SELECT COUNT(*) FROM pondster_visitors WHERE created_at>? OR (created_at=0 AND consent_at>?))<1000').bind(profile.id,profile.consent_at,now,1,profile.preference_basis,profile.expires_at,now-86400000,now-86400000).run();
      if(!inserted.meta.changes)return reply({error:'I can’t save a new conversation profile right now. You can continue without saving.'},429);
      return reply({visitor:publicProfile(profile)},201,token);
    }
    if(!profile||profile.saving_enabled!==1)return reply({error:'Text saving is off or expired on this browser. You can enable future saving in my Voice controls.'},409);
    if(input.action==='name'){
      const name=firstName(input.firstName);if(!name)return reply({error:'Please use a first name, up to 32 letters.'},400);
      await saveName(db,profile,name);return reply({visitor:publicProfile(profile)});
    }
    if(input.action==='introduced'){
      const greeting=visitorGreeting(publicProfile(profile));
      if(typeof input.conversationId!=='string'||!ID.test(input.conversationId))return reply({error:'I need the current conversation.'},400);
      const conversation=await db.prepare("SELECT id,visitor_id,mode,expires_at FROM pondster_conversations WHERE id=? AND visitor_id=? AND expires_at>? AND mode IN ('typed','browser')").bind(input.conversationId,profile.id,Date.now()).first<Conversation>();
      if(!conversation)return reply({error:'That conversation is no longer available.'},409);
      await appendConversationEvent(db,conversation,{id:'greeting',role:'pondster',text:greeting});
      await introduced(db,profile);return reply({visitor:publicProfile(profile),greeting});
    }
    if(input.action==='end'){
      if(typeof input.conversationId!=='string'||!ID.test(input.conversationId))return reply({error:'I need the current conversation.'},400);
      await db.prepare('UPDATE pondster_conversations SET ended_at=? WHERE id=? AND visitor_id=?').bind(Date.now(),input.conversationId,profile.id).run();return reply({ended:true});
    }
    if(input.action==='begin'){
      if(input.mode!=='browser'&&input.mode!=='typed')return reply({error:'I don’t recognize that conversation mode.'},400);
      const id=crypto.randomUUID();await beginSavedConversation(db,profile,id,input.mode);
      return reply({conversationId:id,visitor:publicProfile(profile),greeting:visitorGreeting(publicProfile(profile))},201);
    }
    if(input.action==='turn'){
      if(typeof input.conversationId!=='string'||!ID.test(input.conversationId)||typeof input.eventId!=='string'||!ID.test(input.eventId)
        ||typeof input.question!=='string'||!input.question.trim()||input.question.length>1000||typeof input.answer!=='string'||!input.answer||input.answer.length>4000)return reply({error:'I couldn’t save that text exchange.'},400);
      const conversation=await db.prepare("SELECT id,visitor_id,mode,expires_at FROM pondster_conversations WHERE id=? AND visitor_id=? AND expires_at>? AND mode IN ('typed','browser')").bind(input.conversationId,profile.id,Date.now()).first<Conversation>();
      if(!conversation)return reply({error:'That saved conversation is no longer available.'},409);
      await appendConversationEvent(db,conversation,{id:input.eventId+':in',role:'visitor',text:input.question});
      await appendConversationEvent(db,conversation,{id:input.eventId+':out',role:'pondster',text:input.answer});
      return reply({saved:true});
    }
    return reply({error:'I don’t recognize that preference change.'},400);
  }catch{return reply({error:'I can’t save conversation text right now. Please choose again or continue without saving.'},503);}
}

/** One server-owned text writer per natural conversation. Reflected audio is ignored. */
export function naturalConversationRecorder(db:D1Database,profile:Profile,onNotice:(message:string)=>void,now=Date.now){
  let conversation:Conversation|null=null,healthy=true,awaitingName=profile.introduced_at===null&&!profile.first_name;
  let queue=Promise.resolve();const initial=publicProfile(profile);
  const fail=()=>{if(healthy){healthy=false;onNotice('I can’t save more text from this conversation. You can keep talking without saving.');}};
  const enqueue=(task:()=>Promise<unknown>)=>{queue=queue.then(async()=>{if(healthy)await task();}).catch(fail);return queue;};
  return {
    visitor:initial,
    currentVisitor(){return publicProfile(profile);},
    async start(id:string){conversation=await beginSavedConversation(db,profile,id,'natural',now());},
    greetingSent(){return enqueue(()=>introduced(db,profile,now()));},
    event(event:Record<string,unknown>){
      if(!conversation||!healthy||!['session.input_transcript.delta','session.output_transcript.delta'].includes(String(event.type)))return;
      if(typeof event.delta!=='string'||!event.delta||typeof event.event_id!=='string'||typeof event.start_ms!=='number'||!Number.isFinite(event.start_ms)||event.start_ms<0
        ||typeof event.end_ms!=='number'||!Number.isFinite(event.end_ms)||event.end_ms<event.start_ms){fail();return;}
      const saved=conversation,fragment={id:event.event_id,role:event.type==='session.input_transcript.delta'?'visitor' as const:'pondster' as const,text:event.delta,start:event.start_ms,end:event.end_ms};
      return enqueue(()=>appendConversationEvent(db,saved,fragment,now()));
    },
    text(text:string){if(!conversation)return;const saved=conversation;return enqueue(()=>appendConversationEvent(db,saved,{id:crypto.randomUUID(),role:'visitor',text},now()));},
    async name(text:string){
      const name=nameFromReply(text,awaitingName);if(!name)return null;awaitingName=false;
      await enqueue(()=>saveName(db,profile,name,now()));
      return healthy?`Nice to meet you, ${name}. What can I help you with?`:'I couldn’t save your name. You can keep talking without saving.';
    },
    async finish(){await queue;if(conversation)await db.prepare('UPDATE pondster_conversations SET ended_at=? WHERE id=?').bind(now(),conversation.id).run().catch(()=>{});},
  };
}
