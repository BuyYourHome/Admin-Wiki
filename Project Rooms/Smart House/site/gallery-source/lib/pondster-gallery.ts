import { galleries, type Design } from './designs';
import { galleryPictures, movePicture, pictureIndex, pictureSelection } from './design-views';
import { parsePondsterDestination } from './pondster-destinations';
export type GalleryVoiceCommand='first'|'next'|'previous'|'close'|'enlarge'|'vote';
export function galleryVoiceCommand(words:string):GalleryVoiceCommand|null {
  const command=words.replace(/^(?:(?:please|can you|could you|would you) )*/,'').replace(/ please$/,'');
  if(/^(?:(?:enlarge|expand)(?: (?:this|that|the|my)(?: (?:one|picture|image|photo|view))?)?|zoom in(?: on (?:this|that|the) (?:picture|image|photo))?|make (?:this|that|it|the (?:picture|image|photo)) (?:bigger|larger|full screen)|(?:show|open) (?:this|that|the) (?:picture|image|photo) (?:full size|full screen)|full screen|full size)$/.test(command))return 'enlarge';
  if(/^(?:(?:i )?vote (?:for|on) (?:this|that|the current|the displayed)(?: (?:one|choice|design|picture|image|option))?|(?:save|cast|record) my vote for (?:this|that)(?: (?:one|choice|design|picture|image|option))?|(?:change|switch) my vote to (?:this|that)(?: (?:one|choice|design|picture|image|option))?)$/.test(command))return 'vote';
  if(/^(?:next one|another one|show me another (?:one|picture|image))$/.test(words))return 'next';
  if(/^(?:previous one|back|go back|go back one)$/.test(words))return 'previous';
  if(/^(?:first one|show me the first one)$/.test(words))return 'first';
  if(/^(?:close|close it|close this)$/.test(words))return 'close';
  if(/^(?:(?:please|can you|could you) )*(?:close|dismiss|exit) (?:this |the )?(?:picture|image|photo|viewer|gallery viewer)(?: please)?$/.test(words)||/^(?:back|return) to (?:the )?gallery$/.test(words))return 'close';
  const match=words.match(/^(?:(?:please|can you|could you) )*(?:(?:show|open|display|go to|move to|take me to|show me) (?:the )?)?(next|previous|first)(?: (?:picture|pic|image|photo|choice|design|option)(?: in (?:this|the|my) gallery)?)?(?: please)?$/);
  if(match)return match[1] as GalleryVoiceCommand;
  return /^(?:go )?back (?:one )?(?:picture|image|choice|design)$/.test(words)?'previous':null;
}
export function galleryVoiceSelection(current:Design|null,room:string,command:GalleryVoiceCommand):Design|null {
  if(command==='close')return null;
  const gallery=galleries.find(item=>item.id===room);
  const pictures=galleryPictures(gallery?.designs??[]);if(!pictures.length)return null;
  const index=current?pictureIndex(pictures,current):-1;
  if(command==='vote')return current;
  if(command==='enlarge')return pictureSelection(pictures[index<0?0:index]);
  return pictureSelection(pictures[command==='first'?0:index<0?(command==='previous'?pictures.length-1:0):movePicture(index,command==='next'?1:-1,pictures.length)]);
}

/** Narrow deterministic fallback when speech acknowledges a picture but omits delegation. */
export function explicitGalleryVoiceAction(text:string,value:unknown){
  const action=parsePondsterDestination(value);if(action?.menu!=='Design')return null;
  const words=text.toLowerCase().replace(/[^a-z0-9]+/g,' ').trim().replace(/^(?:(?:hey|hi|hello|okay|ok) )?pondster(?: |$)/,'').trim();
  if(action.image&&galleryVoiceCommand(words)===action.image)return action;
  if(!action.room||words.length>500||/\b(no|not|don t|do not|cancel|actually|instead|and|or|then)\b/.test(words)
    ||! /^(?:(?:please|can you|could you|would you) )*(?:show|open|display|take me to|go to|pull up|let me see|can i see|could i see|let s see|let s look at|i would like to see)\b/.test(words))return null;
  // The authored guide resolves aliases. Reuse its allowlisted room rather
  // than maintaining a second, narrower list of room names in the fallback.
  return galleries.some(item=>item.id===action.room)?action:null;
}
