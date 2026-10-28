import { galleries, type Design } from './designs';
import { galleryPictures, movePicture, pictureIndex, pictureSelection } from './design-views';
export type GalleryVoiceCommand='first'|'next'|'previous'|'close';
export function galleryVoiceCommand(words:string):GalleryVoiceCommand|null {
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
  return pictureSelection(pictures[command==='first'||index<0?0:movePicture(index,command==='next'?1:-1,pictures.length)]);
}
