import {parseSiteControl,type SiteControlCommand} from './pondster-control-intent';
/** Public controls only: labels never become selectors, external URLs or private tools. */
export const DESTINATION_SECTIONS = {
  Design: ['overview','gallery'],
  Explore: ['house','room','rooms','floor-plan','lighting','hot-water','presence','bath-and-shower','exterior-awareness','voice-feature','lighting-plans','sound-screens','climate','design-participation','owner-experience'],
  View: ['tour','ashley','viewing','notebook'],
  Own: ['drawing','guides','maintenance','handover'],
  Contact: ['gc','plumber','hvac','ashley','company','voice','trades'],
  'Built By': ['company','contact'],
} as const;
export type PondsterMenu = keyof typeof DESTINATION_SECTIONS;
export type PondsterSection = typeof DESTINATION_SECTIONS[PondsterMenu][number];
export type PondsterDestination = { menu:PondsterMenu; section?:PondsterSection; room?:string; scene?:'day'|'evening'|'relax'; tour?:true; image?:'first'|'next'|'previous'|'close'|'enlarge'|'vote';control?:SiteControlCommand };
export const GALLERY_ROOM_IDS = ['kitchen','media-center','front-elevation','garage-barn-door','adu','master-bath','hall-bath','spiral-staircase','back-deck'] as const;
export const FLOOR_PLAN_ROOM_IDS = ['living-room','kitchen','dining-room','master-bedroom','master-bath','hall','hall-bath','spiral-stair','bedroom-1','bedroom-2','open-deck','pantry','laundry','existing-garage','new-garage','walk-in-closet','bedroom-1-closet','bedroom-2-closet','utility-closet'] as const;
const menuSet = new Set<string>(Object.keys(DESTINATION_SECTIONS));
const gallerySet = new Set<string>(GALLERY_ROOM_IDS), planSet = new Set<string>(FLOOR_PLAN_ROOM_IDS);

export function parsePondsterDestination(value:unknown):PondsterDestination|null {
  if(!value || typeof value!=='object' || Array.isArray(value))return null;
  const input=value as Record<string,unknown>;
  if(typeof input.menu!=='string' || !menuSet.has(input.menu))return null;
  const menu=input.menu as PondsterMenu;
  if(input.control!==undefined){const control=parseSiteControl(input.control);if(!control||['section','room','scene','tour','image'].some(key=>input[key]!==undefined))return null;return {menu,control};}
  if(input.section!==undefined && (typeof input.section!=='string' || !(DESTINATION_SECTIONS[menu] as readonly string[]).includes(input.section)))return null;
  const section=input.section as PondsterSection|undefined;
  if(input.room!==undefined) {
    const rooms=menu==='Explore' && section==='floor-plan'?planSet:gallerySet;
    if(typeof input.room!=='string' || !rooms.has(input.room) || (menu!=='Design' && menu!=='Explore'))return null;
    if(menu==='Design' && section!==undefined && section!=='gallery')return null;
    if(menu==='Explore' && section!==undefined && section!=='room' && section!=='floor-plan')return null;
  }
  if(menu==='Explore' && section==='room' && input.room===undefined)return null;
  if(input.scene!==undefined && (menu!=='Explore' || !['day','evening','relax'].includes(input.scene as string) || (section!==undefined && section!=='lighting')))return null;
  if(input.tour!==undefined && (input.tour!==true || menu!=='View' || (section!==undefined && section!=='tour')))return null;
  if(input.image!==undefined && (menu!=='Design'||!['first','next','previous','close','enlarge','vote'].includes(input.image as string)||(section!==undefined&&section!=='gallery')))return null;
  if(input.image==='vote'&&(input.room!==undefined||section!==undefined))return null;
  return {menu,...(section!==undefined?{section}:{}),...(typeof input.room==='string'?{room:input.room}:{}),
    ...(input.scene!==undefined?{scene:input.scene as PondsterDestination['scene']}:{}),...(input.tour===true?{tour:true}:{}),...(input.image!==undefined?{image:input.image as PondsterDestination['image']}:{})};
}

/** Only fixed application-owned anchors are returned. Floor-plan room selection is separate. */
export function getPondsterDestinationId(value:PondsterDestination):string|null {
  const action=parsePondsterDestination(value);
  if(!action)return null;
  const section=action.section ?? (action.menu==='Design' && action.room?'gallery'
    : action.menu==='Explore' && action.scene?'lighting':action.menu==='Explore' && action.room?'room'
    : action.menu==='View' && action.tour?'tour':null);
  if(!section)return null;
  if(action.menu==='Design' && section==='gallery')return 'design-gallery';
  if(action.menu==='Explore' && section==='room')return 'pondster-explore-room-'+action.room;
  const slug=action.menu==='Built By'?'built-by':action.menu.toLowerCase();
  return 'pondster-'+slug+'-'+section;
}
