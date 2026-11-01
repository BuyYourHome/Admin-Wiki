export type SiteControlCommand={kind:'activate'|'set'|'choose'|'check'|'uncheck'|'scroll'|'reveal'|'media';target:string;value?:string};
export function controlLabel(text:string){return text.toLowerCase().replace(/[^a-z0-9]+/g,' ').replace(/\b(?:the|my|your|optional)\b/g,' ').replace(/\s+/g,' ').trim();}
export function parseSiteControl(input:unknown):SiteControlCommand|null{
  if(!input||typeof input!=='object'||Array.isArray(input))return null;const v=input as Record<string,unknown>;
  if(!['activate','set','choose','check','uncheck','scroll','reveal','media'].includes(String(v.kind))||typeof v.target!=='string'||!v.target.trim()||v.target.length>120)return null;
  if(v.value!==undefined&&(typeof v.value!=='string'||v.value.length>500))return null;
  if(v.kind==='set'&&typeof v.value!=='string')return null;
  if(v.kind==='scroll'&&!['up','down','top','bottom'].includes(v.target))return null;
  if(v.kind==='media'&&(!['video','tour'].includes(v.target)||typeof v.value!=='string'||!/^(?:play|pause|mute|unmute|restart|enlarge|restore|close|volume:(?:100|\d{1,2})|seek:[+-]\d{1,3})$/.test(v.value)))return null;
  return {kind:v.kind as SiteControlCommand['kind'],target:v.target.trim(),...(typeof v.value==='string'?{value:v.value}:{})};
}
/** Explicit control verbs only; labels are matched as text, never selectors/code. */
export function spokenSiteControl(input:string):SiteControlCommand|null{
 const text=input.trim().replace(/^(?:(?:hey|hi|hello|okay|ok)[, ]+)?pondster[, :]+/i,'').replace(/^(?:(?:please|can you|could you|would you) )+/i,'').replace(/[?.!]$/,'').replace(/ please$/i,'');let m:RegExpMatchArray|null;
 if((m=text.match(/^(play|pause|resume|restart|replay|mute|unmute|enlarge|expand|restore|shrink|close) (?:the |my |your )?(video|film|tour)$/i)))return {kind:'media',target:m[2].toLowerCase()==='tour'?'tour':'video',value:({resume:'play',replay:'restart',expand:'enlarge',shrink:'restore'} as Record<string,string>)[m[1].toLowerCase()]??m[1].toLowerCase()};
 if((m=text.match(/^(?:show (?:the )?)?(video|film|tour) (?:full screen|full size)$/i)))return {kind:'media',target:m[1].toLowerCase()==='tour'?'tour':'video',value:'enlarge'};
 if((m=text.match(/^set (?:the )?(?:video|film) volume to (\d{1,3})(?:\s*%| percent)?$/i))&&Number(m[1])<=100)return {kind:'media',target:'video',value:'volume:'+Number(m[1])};
 if((m=text.match(/^(?:skip|seek|go) (forward|back|backward) (\d{1,3}) seconds?(?: (?:in|on) (?:the )?(?:video|film))?$/i)))return {kind:'media',target:'video',value:`seek:${m[1].toLowerCase()==='forward'?'+':'-'}${Number(m[2])}`};
 if((m=text.match(/^(?:scroll|go) (up|down|to the top|to the bottom)$/i)))return {kind:'scroll',target:m[1].toLowerCase().replace('to the ','')};
 if((m=text.match(/^scroll to (.+)$/i)))return parseSiteControl({kind:'reveal',target:m[1]});
 if((m=text.match(/^(?:click|press|tap|activate|toggle) (.+)$/i)))return parseSiteControl({kind:'activate',target:m[1]});
 if((m=text.match(/^(check|uncheck) (.+)$/i)))return parseSiteControl({kind:m[1].toLowerCase(),target:m[2]});
 if((m=text.match(/^turn (on|off) (.+)$/i)))return parseSiteControl({kind:m[1].toLowerCase()==='on'?'check':'uncheck',target:m[2]});
 if((m=text.match(/^(?:choose|select) (.+)$/i)))return parseSiteControl({kind:'choose',target:m[1]});
 if((m=text.match(/^(?:set|fill) (.+?) (?:to|with) (.+)$/i)))return parseSiteControl({kind:'set',target:m[1],value:m[2]});
 if((m=text.match(/^(?:type|write) (.+?) (?:in|into) (.+)$/i)))return parseSiteControl({kind:'set',target:m[2],value:m[1]});
 return null;
}
