import { parsePondsterDestination } from './pondster-destinations';
import { equipmentManuals } from './equipment';

const documentWords = new Set((
  'a an the my your this that these those selected public official manufacturer manufacturers product products equipment device devices system systems camera cameras security surveillance eufy nvr poe recorder recorders sony str ta an1000 stran1000 an 1000 s4 s4max max av a v audio video visual audiovisual sound screen screens receiver receivers user owner owners manual manuals guide guides documentation instruction instructions operating operation quickstart spec specs specification specifications specsheet specsheets data sheet sheets datasheet datasheets document documents information info details reference references card cards page pages library and plus for of about on in to with me please now '
  + equipmentManuals.flatMap(equipment => [equipment.model, ...equipment.guides.map(guide => guide.label)]).join(' ').toLowerCase().replace(/[^a-z0-9]+/g, ' ').replace(/\bquick start\b/g, 'quickstart')
).split(/\s+/).filter(Boolean));

/** Filter the authored guide's public equipment destination; do not classify equipment again. */
export function explicitEquipmentVoiceAction(text: string, value: unknown) {
  const action = parsePondsterDestination(value);
  if (action?.menu !== 'Own' || !['cameras', 'audio', 'maintenance'].includes(action.section ?? '')) return null;
  if (text.length > 500 || /["“”«»]|(?:^|[\s([:])['‘]|['’](?:$|[\s)\],:])/.test(text)) return null;
  const words = text.toLowerCase().replace(/[^a-z0-9]+/g, ' ').trim()
    .replace(/^(?:(?:hey|hi|hello|okay|ok) )?pondster(?: |$)/, '').trim();
  if (/\b(no|not|don t|do not|doesn t|didn t|never|cancel|stop|instead|actually|rather|unless|without|except|wait|then|or|but|also)\b/.test(words)) return null;
  const prefix = words.match(/^(?:(?:please|can you|could you|would you|will you) )*(?:show(?: me)?|open|display|view|take me to|go to|pull up|bring up|find(?: me)?|let me see|can i see|could i see|let s see|let s look at|i would like to see|i d like to see|where (?:is|are)|where can i (?:find|see))\b/);
  if (!prefix) return null;
  // Accept only document/equipment noun phrases after the one navigation verb.
  // This filters the already-resolved destination, without choosing a model or
  // allowing unknown trailing actions to consume the entire voice utterance.
  const subject = words.slice(prefix[0].length).trim().replace(/\bquick start\b/g, 'quickstart');
  if (!subject || subject.split(/\s+/).some(word => !documentWords.has(word))) return null;
  return action;
}
