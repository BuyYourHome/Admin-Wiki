import {controlLabel,parseSiteControl,type SiteControlCommand} from './pondster-control-intent';
// Worker bindings also declare Element; keep browser operations typed as HTMLElement.
export type SiteControlResult={status:'activated'|'changed'|'not-found'|'ambiguous'|'unavailable'|'requires-click'};
const selector='button,a[href],input:not([type=hidden]),select,textarea,summary,[role=button],[role=tab],[role=radio],[role=checkbox]';
export function visibleControl(element:HTMLElement){return !element.closest('[hidden],[inert],[aria-hidden="true"]')&&element.getClientRects().length>0;}
export function controlNames(element:HTMLElement){
 const field=element as HTMLInputElement;const labels=Array.from(field.labels??[],label=>label.textContent??'');
 const names=[element.getAttribute('aria-label'),element.getAttribute('title'),...labels,element.getAttribute('placeholder'),element.id,element.getAttribute('name')];
 if(!['INPUT','TEXTAREA','SELECT'].includes(element.tagName))names.push(element.textContent,element.querySelector('strong')?.textContent??null);
 for(const id of (element.getAttribute('aria-labelledby')??'').split(/\s+/))if(id)names.push(element.ownerDocument.getElementById(id)?.textContent??null);
 return [...new Set(names.filter((v):v is string=>Boolean(v)).map(controlLabel).flatMap(name=>[name,name.replace(/ (?:on|off)$/,'')]).filter(Boolean))];
}
export function findNamedControl(elements:HTMLElement[],target:string){
 let wanted=controlLabel(target);if(!wanted)return {status:'not-found' as const};
 const named=elements.map(element=>({element,names:controlNames(element)}));
 let exact=named.filter(item=>item.names.includes(wanted)),ordinal:number|null=null;
 if(!exact.length){const match=wanted.match(/^(first|second|third|fourth|fifth|last|\d+(?:st|nd|rd|th)?) (.+)$/);if(match){ordinal=({first:0,second:1,third:2,fourth:3,fifth:4,last:-1} as Record<string,number>)[match[1]]??parseInt(match[1])-1;if(ordinal<0&&match[1]!=='last')return {status:'not-found' as const};wanted=match[2];exact=named.filter(item=>item.names.includes(wanted));}}
 const matches=exact.length?exact:named.filter(item=>item.names.some(name=>(` ${name} `).includes(` ${wanted} `)));
 if(ordinal!==null){const item=ordinal===-1?matches.at(-1):matches[ordinal];return item?{element:item.element}:{status:'not-found' as const};}
 return matches.length===1?{element:matches[0].element}: {status:matches.length?'ambiguous' as const:'not-found' as const};
}
function disabled(element:HTMLElement){return (element as HTMLButtonElement).disabled||element.matches?.(':disabled')||element.getAttribute('aria-disabled')==='true';}
function click(element:HTMLElement){const node=element as HTMLElement;node.focus?.({preventScroll:true});if(typeof node.click==='function')node.click();else element.dispatchEvent(new MouseEvent('click',{bubbles:true,composed:true}));}
export async function activateSiteControl(input:SiteControlCommand,doc:Document=document):Promise<SiteControlResult>{
 const command=parseSiteControl(input);if(!command)return {status:'unavailable'};
 const dialogs=Array.from(doc.querySelectorAll('dialog[open]')) as unknown as HTMLDialogElement[];
 const expanded=doc.querySelector('.scroll-video-stage.is-expanded') as unknown as HTMLElement|null;
 const root=dialogs.at(-1)??expanded??doc;
 const elements=(Array.from(root.querySelectorAll(selector)) as unknown as HTMLElement[]).filter(visibleControl);
 if(command.kind==='scroll'){
   const direction=command.target;const win=doc.defaultView!;const container=root===doc?win:root as HTMLDialogElement;
   const height=root===doc?win.innerHeight:(root as HTMLDialogElement).clientHeight;
   if(direction==='top'||direction==='bottom')container.scrollTo({top:direction==='top'?0:root===doc?doc.documentElement.scrollHeight:(root as HTMLDialogElement).scrollHeight,behavior:'smooth'});
   else container.scrollBy({top:(direction==='up'?-1:1)*height*.7,behavior:'smooth'});
   return {status:'activated'};
 }
 if(command.kind==='media'){
   if(command.target==='tour'){
     const labels:Record<string,string>={play:'Play my tour',pause:'Pause my tour',restart:'Replay my tour',mute:'Music',unmute:'Music',enlarge:'Full screen',restore:'Exit full screen',close:'Close my virtual tour'};
     const label=labels[command.value!];if(!label)return {status:'unavailable'};
     return activateSiteControl({kind:command.value==='mute'?'uncheck':command.value==='unmute'?'check':'activate',target:label},doc);
   }
   const videos=(Array.from(root.querySelectorAll('video')) as unknown as HTMLVideoElement[]).filter(visibleControl);
   if(videos.length!==1)return {status:videos.length?'ambiguous':'not-found'};const video=videos[0];
   if(['enlarge','restore','close'].includes(command.value!)){
     const shell=video.closest('.scroll-video-shell');
     if(shell){shell.dispatchEvent(new doc.defaultView!.CustomEvent(command.value==='enlarge'?'pondster-video-expand':'pondster-video-collapse'));return {status:'activated'};}
     if(root instanceof doc.defaultView!.HTMLDialogElement)return activateSiteControl({kind:'activate',target:command.value==='enlarge'?'Full screen':command.value==='close'?'Close my virtual tour':'Exit full screen'},doc);
     try{if(command.value==='enlarge')await video.requestFullscreen();else if(doc.fullscreenElement)await doc.exitFullscreen();return {status:'changed'};}catch{return {status:'requires-click'};}
   }
   try{const value=command.value!;if(value==='play')await video.play();else if(value==='pause')video.pause();else if(value==='mute'||value==='unmute')video.muted=value==='mute';else if(value==='restart'){video.currentTime=0;await video.play();}else if(value.startsWith('volume:'))video.volume=Number(value.slice(7))/100;else if(value.startsWith('seek:')){if(!Number.isFinite(video.duration))return {status:'unavailable'};video.currentTime=Math.max(0,Math.min(video.duration,video.currentTime+Number(value.slice(5))));}return {status:'changed'};}catch{return {status:'requires-click'};}
 }
 if(command.kind==='choose'){
   const options=elements.filter(element=>element.tagName==='SELECT').flatMap(element=>Array.from((element as unknown as HTMLSelectElement).options).filter(option=>controlLabel(option.text)===controlLabel(command.target)&&!option.disabled).map(option=>({element,option})));
   if(options.length===1)return activateSiteControl({kind:'set',target:controlNames(options[0].element)[0],value:options[0].option.text},doc);
   if(options.length>1)return {status:'ambiguous'};
 }
 const pool=command.kind==='set'?elements.filter(e=>['INPUT','SELECT','TEXTAREA'].includes(e.tagName)):command.kind==='choose'?elements.filter(e=>!e.classList.contains('vote-button')&&(e.getAttribute('role')==='radio'||e.hasAttribute('aria-pressed')||(e as HTMLInputElement).type==='radio')):elements;
 const found=findNamedControl(pool,command.target);if(!('element' in found))return found;if(!found.element)return {status:'not-found'};const element=found.element;
 if(disabled(element))return {status:'unavailable'};
 element.scrollIntoView?.({block:'center',behavior:'smooth'});
 if(command.kind==='reveal'){(element as HTMLElement).focus?.({preventScroll:true});return {status:'activated'};}
 if(command.kind==='check'||command.kind==='uncheck'){
   const state=(element as HTMLInputElement).type==='checkbox'?(element as HTMLInputElement).checked:element.getAttribute('aria-checked')??element.getAttribute('aria-pressed');
   if(state===null||state===undefined)return {status:'unavailable'};if((state===true||state==='true')!==(command.kind==='check'))click(element);return {status:'changed'};
 }
 if(command.kind==='set'){
   const field=element as HTMLInputElement|HTMLSelectElement|HTMLTextAreaElement;if(['hidden','password','file'].includes((field as HTMLInputElement).type))return {status:'requires-click'};
   if((field as HTMLInputElement).readOnly)return {status:'unavailable'};
   let value=command.value!;if(element.tagName!=='SELECT'&&(field as HTMLInputElement).maxLength>=0&&value.length>(field as HTMLInputElement).maxLength)return {status:'unavailable'};
   if((field as HTMLInputElement).type==='checkbox'){
     const desired=controlLabel(value);if(!['on','off','true','false','yes','no'].includes(desired))return {status:'unavailable'};
     if((field as HTMLInputElement).checked!==['on','true','yes'].includes(desired))click(element);return {status:'changed'};
   }
   if((field as HTMLInputElement).type==='date'){
     const date=value.match(/^(January|February|March|April|May|June|July|August|September|October|November|December) (\d{1,2})(?:st|nd|rd|th)?,? (\d{4})$/i);
     if(date){const month=['january','february','march','april','may','june','july','august','september','october','november','december'].indexOf(date[1].toLowerCase())+1;value=`${date[3]}-${String(month).padStart(2,'0')}-${date[2].padStart(2,'0')}`;}
     if(!/^\d{4}-\d{2}-\d{2}$/.test(value))return {status:'unavailable'};
   }
   if((field as HTMLInputElement).type==='time'||element.tagName==='SELECT'&&Array.from((field as HTMLSelectElement).options).every(option=>/^\d{2}:\d{2}$/.test(option.value))){
     const time=value.replaceAll('.','').match(/^(\d{1,2})(?::(\d{2}))?\s*(am|pm)?$/i);
     if(time){let hour=Number(time[1]);if(time[3])hour=hour%12+(time[3].toLowerCase()==='pm'?12:0);value=`${String(hour).padStart(2,'0')}:${time[2]??'00'}`;}
   }
   if(element.tagName==='SELECT'){const options=Array.from((field as HTMLSelectElement).options).filter(option=>!option.disabled&&(controlLabel(option.text)===controlLabel(value)||option.value===value));if(options.length!==1)return {status:options.length?'ambiguous':'not-found'};value=options[0].value;}
   if((field as HTMLInputElement).type==='range'&&/^\d+(?:\.\d+)?(?:%| percent)$/.test(value)){const range=field as HTMLInputElement;const percent=Number(value.replace(/%| percent/,''));if(percent>100)return {status:'unavailable'};value=String(Number(range.min||0)+(Number(range.max||100)-Number(range.min||0))*percent/100);}
   const proto=element.tagName==='SELECT'?doc.defaultView!.HTMLSelectElement.prototype:element.tagName==='TEXTAREA'?doc.defaultView!.HTMLTextAreaElement.prototype:doc.defaultView!.HTMLInputElement.prototype;
   Object.getOwnPropertyDescriptor(proto,'value')?.set?.call(field,value);
   const EventType=doc.defaultView!.Event;field.dispatchEvent(new EventType('input',{bubbles:true}));field.dispatchEvent(new EventType('change',{bubbles:true}));
   return {status:field.value===value&&field.checkValidity()?'changed':'unavailable'};
 }
 if(element.tagName==='A'&&!/^(?:https?:|mailto:|tel:|#|\/)/i.test(element.getAttribute('href')??''))return {status:'unavailable'};
 if(element.tagName==='INPUT'&&['file','date','time'].includes((element as HTMLInputElement).type))return {status:'requires-click'};
 click(element);return {status:'activated'};
}
