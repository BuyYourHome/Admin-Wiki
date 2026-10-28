import type { GuideReply } from './pondster-guide';
import { parsePondsterDestination } from './pondster-destinations';
import { galleries } from './designs';
import { floorPlanRooms } from './floor-plan';
import { PONDSTER_LOCATION_TEXT } from './pondster-identity';

function words(input:string) { return input.toLowerCase().replace(/[^a-z0-9]+/g,' ').trim(); }

/** Read a block only when explicitly asked to speak it, not for ordinary questions. */
export function isPondsterSpokenExplanationRequest(input:string) {
  const text=words(input).replace(/^(?:(?:hey|hi|hello|okay|ok) )?pondster(?: |$)/,'').trim();
  if(/\b(don t|do not|dont|no need|without|stop|avoid)\b.{0,70}\b(read|reading|narrate|narration|explain|speaking|speak)\b/.test(text))return false;
  return /^(?:(?:please|can you|could you|would you|will you) )*(?:read|narrate)\b/.test(text)
    || /\b(read|explain|say|speak)\b.{0,80}\b(aloud|out loud|verbally|to me)\b/.test(text)
    || /\b(spoken explanation|spoken details|talk me through)\b/.test(text);
}

/** Navigation goes first; speech acknowledges the destination instead of reciting it. */
export function getPondsterSpeechText(question:string, reply:GuideReply):string {
  const action=parsePondsterDestination(reply.action);
  if(!action || isPondsterSpokenExplanationRequest(question))return reply.text;
  if(action.control)return 'I’m checking that website control.';
  const section=action.section;
  if(action.menu==='Design') {
    if(action.image)return action.image==='vote'?'I’m checking your vote.':action.image==='enlarge'?'Here’s the larger picture.':action.image==='close'?'Back to my gallery.':action.image==='first'?'First picture.':action.image==='next'?'Next picture.':'Previous picture.';
    if(section==='overview' && /\b(address|location|city|town|street|where|state|coordinates|geolocation|cary|north carolina)\b/.test(words(question)))return PONDSTER_LOCATION_TEXT;
    if(action.room){const gallery=galleries.find(item=>item.id===action.room);return gallery?gallery.designs.length?`Here’s my ${gallery.name} gallery. You can vote for your favorite and change your vote anytime.`:`I’ll add my ${gallery.name} designs here.`:'Here are my design choices.';}
    return section==='overview'?'Here’s my introduction.':'Here are my design choices. You can vote for your favorite and change your vote anytime.';
  }
  if(action.menu==='Contact') {
    const labels:Record<string,string>={gc:'general contractor',plumber:'plumber',hvac:'HVAC contact',ashley:'realtor',company:'company contact',trades:'trade contacts',voice:'conversation controls'};
    return section && labels[section]?`${section==='trades'||section==='voice'?'Here are':'Here’s'} my ${labels[section]}.`:'Here’s my Contact page.';
  }
  if(action.menu==='Explore') {
    if(section==='floor-plan' && action.room){const name=floorPlanRooms.find(item=>item.id===action.room)?.name;return name?`Here are my ${name} plan details.`:'Here’s my proposed floor plan.';}
    if(action.room){const name=galleries.find(item=>item.id===action.room)?.name;return name?`Here are my ${name} details.`:'Here are my room details.';}
    const labels:Record<string,string>={'floor-plan':'proposed floor plan',house:'house features',rooms:'room features',lighting:'lighting illustration','hot-water':'hot-water plan',presence:'presence-sensing plan','bath-and-shower':'bath and shower plans','exterior-awareness':'exterior-camera plan','voice-feature':'voice feature','lighting-plans':'lighting plans','sound-screens':'sound and screens',climate:'climate plans','design-participation':'design choices','owner-experience':'future owner experience'};
    return section && labels[section]?`${['house','rooms','bath-and-shower','lighting-plans','sound-screens','climate','design-participation'].includes(section)?'Here are':'Here’s'} my ${labels[section]}.`:'Here’s my Explore page.';
  }
  if(action.menu==='View')return action.tour?'Let’s take my virtual tour.':section==='ashley'?'Meet Ashley, my realtor.':section==='viewing'?'Here’s my viewing information.':section==='notebook'?'Here’s my visual notebook.':'Here’s my View page.';
  if(action.menu==='Own')return section==='drawing'?'Here’s my preliminary deck drawing.':section==='maintenance'?'Here’s my maintenance information.':section==='handover'?'Here’s my handover information.':section==='guides'?'Here are my home guides.':'Here’s my Belong page.';
  return section==='contact'?'Here’s my company’s contact information.':'Here’s the company behind me.';
}
