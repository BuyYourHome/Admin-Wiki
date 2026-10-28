import {galleries} from './designs';
export type GalleryUiResult={status:'saved'|'already'|'no-picture'|'loading'|'failed';designId?:string};
export type PondsterUiResult=GalleryUiResult|{status:'activated'|'changed'|'not-found'|'ambiguous'|'unavailable'|'requires-click'};
export function actionResultSpeech(value:unknown,kind:'vote'|'control'='vote'){
 if(kind==='vote')return galleryResultSpeech(value);
 const status=(value as {status?:unknown}|null)?.status;
 return status==='activated'?'I’ve activated that control.':status==='changed'?'I’ve changed that setting.':status==='ambiguous'?'More than one control matches. Use its full label, or say first or second with the label.':status==='requires-click'?'Your browser needs you to tap or click that control.':status==='not-found'?'I can’t find that control in the current view. Open its page or use the label shown on screen.':'That control isn’t available right now. Please check the page.';
}
/** Only allowlisted UI outcomes and public titles become trusted spoken feedback. */
export function galleryResultSpeech(value:unknown):string {
  const result=value as Partial<GalleryUiResult>|null;
  const design=typeof result?.designId==='string'?galleries.flatMap(room=>room.designs).find(item=>item.id===result.designId):undefined;
  if(result?.status==='saved'&&design)return `I’ve saved your vote for ${design.title}. You can change your vote anytime.`;
  if(result?.status==='already'&&design)return `${design.title} is already your choice. Show another design to change your vote.`;
  if(result?.status==='no-picture')return 'Open one of my design pictures first, then say “vote for this one.”';
  if(result?.status==='loading')return 'My vote totals are still loading or a vote is being saved. Please try again in a moment.';
  return 'I couldn’t confirm your vote. Please check the voting button and try again.';
}
