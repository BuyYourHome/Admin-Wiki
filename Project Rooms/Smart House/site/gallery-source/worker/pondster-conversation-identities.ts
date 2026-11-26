import {resolveConversationIdentity,type ConversationIdentityEvent,type ConversationNameReport,type ConversationIdentityFacts} from '../lib/pondster-conversation-identity';
import {ConversationEmailFailure} from './pondster-conversation-email';

type Conversation=ConversationIdentityFacts&{id:string;mode:string;started_at:number;ended_at:number|null};
function invalid(message:string):never{throw new ConversationEmailFailure('invalid_input',message);}
/** Private owner review. This performs no profile or historical-data updates. */
export async function reviewConversationIdentities(db:D1Database|undefined,args:Record<string,unknown>,now=Date.now()){
  if(!db)throw new ConversationEmailFailure('storage_unavailable','Private conversation review is unavailable.',503);
  if(Object.keys(args).some(key=>!['limit','cursor'].includes(key)))invalid('Unsupported identity review fields.');
  const limit=args.limit??25;if(typeof limit!=='number'||!Number.isInteger(limit)||limit<1||limit>25)invalid('Review between 1 and 25 conversations.');
  let after=-1,afterId='';
  if(args.cursor!==undefined){if(typeof args.cursor!=='string'||args.cursor.length>100)invalid('Invalid identity review cursor.');const cursor=args.cursor.match(/^(\d{1,16})\|([a-f0-9-]{36})$/i);if(!cursor||!Number.isSafeInteger(Number(cursor[1])))invalid('Invalid identity review cursor.');after=Number(cursor[1]);afterId=cursor[2];}
  try{
    const found=await db.prepare('SELECT id,mode,started_at,ended_at,remembered_first_name,first_self_reported_name,first_self_reported_at FROM pondster_conversations WHERE expires_at>? AND (started_at>? OR (started_at=? AND id>?)) ORDER BY started_at,id LIMIT ?').bind(now,after,after,afterId,limit+1).all<Conversation>();
    const rows=found.results??[],reviews=[];
    for(const conversation of rows.slice(0,limit)){
      const captured=await db.prepare('SELECT sequence,role,text,created_at,start_ms,end_ms FROM pondster_conversation_events WHERE conversation_id=? AND expires_at>? ORDER BY sequence,created_at,event_id LIMIT 5001').bind(conversation.id,now).all<ConversationIdentityEvent>();
      const events=captured.results??[],bounded=events.length<=5000&&events.reduce((n,event)=>n+event.text.length,0)<=1_050_000;
      const recorded=await db.prepare('SELECT first_name,created_at,source FROM pondster_visitor_name_events WHERE conversation_id=? AND expires_at>? ORDER BY created_at DESC,rowid DESC LIMIT 101').bind(conversation.id,now).all<ConversationNameReport>();
      const reports=(recorded.results??[]).slice(0,100).reverse();
      reviews.push({conversation_id:conversation.id,mode:conversation.mode,started_at:new Date(conversation.started_at).toISOString(),ended_at:conversation.ended_at===null?null:new Date(conversation.ended_at).toISOString(),
        identity:bounded?resolveConversationIdentity(conversation,events,reports):{label:null,basis:'unknown',source:'none',at:null,evidence:[]},
        remembered_name_at_start:conversation.remembered_first_name??null,first_self_reported_name:conversation.first_self_reported_name??null,
        captured_event_count:events.length,source_bounds_exceeded:!bounded,name_reports_truncated:(recorded.results?.length??0)>100});
    }
    const last=rows[Math.min(limit,rows.length)-1];
    return{conversations:reviews,next_cursor:rows.length>limit&&last?`${last.started_at}|${last.id}`:null,interpretation:'Derived conversational labels only. Explicit visitor self-identification or a conversation-bound name report overrides an assumed name. An actual named welcome-back greeting followed by uncorrected visitor continuation is assumed, never verified identity or owner authority. A greeting alone, remembered profile name alone or current browser profile does not establish the guest. No historical fields were rewritten.'};
  }catch(error){if(error instanceof ConversationEmailFailure)throw error;throw new ConversationEmailFailure('storage_unavailable','Private conversation review could not complete.',503);}
}
export const CONVERSATION_IDENTITY_TOOLS=[{name:'review_conversation_identities',description:'Owner-only: review up to 25 unexpired conversations with derived effective guest labels and bounded captured evidence. Distinguishes explicit self-identification, uncorrected named welcome-back assumptions and unknown guests; never changes profiles, history, permissions or owner authority. Use next_cursor to continue.',annotations:{readOnlyHint:true},inputSchema:{type:'object',properties:{limit:{type:'integer',minimum:1,maximum:25},cursor:{type:'string',maxLength:100}},additionalProperties:false}}];
