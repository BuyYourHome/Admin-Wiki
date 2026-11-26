import {firstName,nameFromReply} from './pondster-visitor';

export type ConversationIdentityEvent={sequence:number;role:string;text:string;created_at:number;start_ms?:number|null;end_ms?:number|null};
export type ConversationNameReport={first_name:string;created_at:number;source:string};
export type ConversationIdentityFacts={remembered_first_name?:string|null;first_self_reported_name?:string|null;first_self_reported_at?:number|null};
export type ConversationIdentity={label:string|null;basis:'explicit'|'assumed'|'unknown';source:'visitor_text'|'conversation_name_report'|'stored_first_report'|'welcome_back_continuation'|'none';at:number|null;evidence:Array<{kind:string;at:number;text:string}>};
type Turn={role:string;text:string;at:number;order:number};
function turns(events:ConversationIdentityEvent[]):Turn[]{const result:Turn[]=[];let prior:ConversationIdentityEvent|undefined;for(const event of [...events].sort((a,b)=>a.sequence-b.sequence||a.created_at-b.created_at)){const previous=result.at(-1),fragmented=typeof event.start_ms==='number'&&typeof prior?.end_ms==='number'&&event.start_ms-prior.end_ms<1500&&event.created_at-prior.created_at<5000;if(previous?.role===event.role&&fragmented){previous.text+=event.text;previous.at=Math.max(previous.at,event.created_at);}else result.push({role:event.role,text:event.text,at:event.created_at,order:event.sequence});prior=event;}return result;}
function quotedOrExample(value:string){return /^["“”‘'«»]/.test(value.trim())||/^(?:for example|as an example|pretend|roleplay|role play|he said|she said|they said|quote|quoted|say the words)\b/i.test(value.trim());}
function rejection(text:string,label:string|null){
  const value=text.toLowerCase().replace(/[’']/g,"'");
  const direct=value.replace(/^(?:(?:no|actually|sorry|well|uh|um|mm|please)\b[, .]*\s*)+/i,'');
  if(/^(?:(?:that(?:'s| is)|this (?:is|isn't)|you (?:have|got))\s+)?(?:not my name|wrong name|not who i am|not me)\b/.test(direct)||/^(?:i am|i'm|im) (?:someone|somebody) else\b/.test(direct))return true;
  if(!label)return false;const name=label.toLowerCase().replace(/[’']/g,"'").replace(/[.*+?^${}()|[\]\\]/g,'\\$&');
  return new RegExp(`^(?:(?:i am|i'm|im|this is) not\\s+${name}(?:\\b|$)|not\\s+${name}(?:\\b|$)|(?:don't|do not|dont) call me\\s+${name}(?:\\b|$))`,'i').test(direct);
}
function selfReport(text:string,awaiting:boolean){
  if(quotedOrExample(text))return null;
  return nameFromReply(text.trim(),awaiting);
}

/** Derived display labels only. This function never consults a mutable profile or grants access. */
export function resolveConversationIdentity(facts:ConversationIdentityFacts,events:ConversationIdentityEvent[],reports:ConversationNameReport[]=[]):ConversationIdentity{
  type Action={at:number;priority:number;order:number;kind:'turn'|'report'|'stored';turn?:Turn;label?:string;source?:string};
  const actions:Action[]=turns(events).map(turn=>({at:turn.at,priority:2,order:turn.order,kind:'turn',turn}));
  const stored=firstName(facts.first_self_reported_name);
  if(stored&&typeof facts.first_self_reported_at==='number')actions.push({at:facts.first_self_reported_at,priority:0,order:0,kind:'stored',label:stored});
  for(const [index,report] of reports.entries()){const label=firstName(report.first_name);if(label&&Number.isFinite(report.created_at)&&['name_form','natural_reply','typed_reply','browser_reply'].includes(report.source))actions.push({at:report.created_at,priority:report.source==='name_form'?3:1,order:index,kind:'report',label,source:report.source});}
  actions.sort((a,b)=>a.at-b.at||a.priority-b.priority||a.order-b.order);
  let result:ConversationIdentity={label:null,basis:'unknown',source:'none',at:null,evidence:[]};
  let greeting:{label:string;at:number;text:string}|null=null,awaiting=false;
  const denied=new Set<string>();
  const evidence=(kind:string,at:number,text:string)=>{result.evidence.push({kind,at,text:text.slice(0,160)});if(result.evidence.length>8)result.evidence.shift();};
  for(const action of actions){
    if(action.kind!=='turn'){
      result={...result,label:action.label!,basis:'explicit',source:action.kind==='stored'?'stored_first_report':'conversation_name_report',at:action.at};greeting=null;awaiting=false;evidence(action.kind==='stored'?'stored_first_report':action.source??'name_report',action.at,action.label!);continue;
    }
    const turn=action.turn!,text=turn.text.trim();if(!text)continue;
    if(turn.role==='pondster'){
      const welcome=text.match(/^(?:(?:hi|hello|hey|well|oh)[,.! ]+)?welcome\s+back\s*[,!]?\s+([\p{L}\p{M}’'\-]+(?:[’']s\s+(?:son|daughter|wife|husband|partner|brother|sister|mother|father|parent|nephew|niece|friend|colleague|guest))?)(?=[,.!?]|$)/iu);
      const label=welcome?firstName(welcome[1]):null;
      if(label&&!denied.has(label.toLowerCase()))greeting={label,at:turn.at,text:welcome![0]};
      awaiting=/\b(?:how would you like me to (?:address|call) you|what(?: is|'s|’s) your (?:first )?name)\b/i.test(text);
      continue;
    }
    if(turn.role!=='visitor')continue;
    const clauses=quotedOrExample(text)?[text]:text.split(/(?<=[.!?])\s+|\n+/);
    for(const clause of clauses){
      if(!clause.trim()||/^(?:mm|hmm|um|uh)[.! ]*$/i.test(clause.trim()))continue;
      const rejected=!quotedOrExample(clause)&&rejection(clause,greeting?.label??result.label??facts.remembered_first_name??null);
      const explicit=selfReport(clause,awaiting);
      if(explicit){result={...result,label:explicit,basis:'explicit',source:'visitor_text',at:turn.at};greeting=null;awaiting=false;evidence('visitor_self_report',turn.at,clause);continue;}
      if(rejected){const old=greeting?.label??result.label;if(old)denied.add(old.toLowerCase());result={...result,label:null,basis:'unknown',source:'none',at:turn.at};greeting=null;awaiting=false;evidence('name_rejected',turn.at,clause);continue;}
      if(greeting&&result.basis!=='explicit'){result={...result,label:greeting.label,basis:'assumed',source:'welcome_back_continuation',at:turn.at};evidence('named_welcome_back',greeting.at,greeting.text);evidence('visitor_continued',turn.at,clause);greeting=null;}
      awaiting=false;
      if(quotedOrExample(clause))break;
    }
  }
  return result;
}
