export type GuideAction = { menu: 'Design' | 'Explore' | 'View' | 'Manage'; room?: string; scene?: 'day' | 'evening' | 'relax' };
export type GuideReply = { text: string; action?: GuideAction };

// Public concept names mirror lib/designs.ts; the focused tests check this list.
const rooms = [
  { id: 'kitchen', name: 'Kitchen', aliases: ['kitchen'], choices: [] as string[] },
  { id: 'media-center', name: 'Media Center', aliases: ['media center', 'media centre', 'entertainment center', 'entertainment centre', 'television', 'tv'], choices: ['Warm Ivory Cream', 'Soft Dusty Sage Green', 'Deep Muted Navy Blue', 'Medium Mushroom Taupe', 'Deep Muted Olive Green', 'Rich Charcoal Gray'] },
  { id: 'front-elevation', name: 'Front Elevation', aliases: ['front elevation', 'front exterior', 'front of the house', 'exterior', 'shutters'], choices: ['Warm welcome', 'Black shutters'] },
  { id: 'garage-barn-door', name: 'Garage Barn Door', aliases: ['garage', 'barn door'], choices: ['Warm white board & batten', 'Charcoal green board & batten', 'Limewashed brick'] },
  { id: 'adu', name: 'ADU', aliases: ['adu', 'accessory dwelling unit'], choices: [] as string[] },
  { id: 'master-bath', name: 'Master Bath', aliases: ['master bath', 'primary bath', 'main bath', 'bathroom'], choices: [] as string[] }
];
const choiceAliases: Record<string, string[]> = {
  'Warm Ivory Cream': ['warm ivory', 'ivory cream'],
  'Soft Dusty Sage Green': ['sage'],
  'Deep Muted Navy Blue': ['navy'],
  'Medium Mushroom Taupe': ['mushroom', 'taupe'],
  'Deep Muted Olive Green': ['olive'],
  'Rich Charcoal Gray': ['rich charcoal', 'charcoal gray', 'charcoal grey', 'charcoal clay'],
  'Warm welcome': ['wood shutters', 'wooden shutters'],
  'Black shutters': ['black shutter'],
  'Warm white board & batten': ['warm white', 'white board and batten'],
  'Charcoal green board & batten': ['charcoal green'],
  'Limewashed brick': ['limewash', 'limewashed']
};
const ashley = 'Ashley Morello is our realtor with Element Realty Group at Howard Hanna Allen Tate. Email ashley@elementrealtygroup.net or call 919-417-0612.';
function normalize(value: string) { return value.toLowerCase().replace(/[^a-z0-9]+/g, ' ').trim(); }
function hasPhrase(input: string, phrase: string) { return ` ${input} `.includes(` ${normalize(phrase)} `); }

export function answerPondster(input: string): GuideReply {
  const words = normalize(input).replace(/^(?:(?:hey|hi|hello|okay|ok) )?pondster(?: |$)/, '').trim();
  const has = (phrase: string) => hasPhrase(words, phrase);
  const identity = "I'm Pondster, the public house guide for 908 Pond Street. Jean Wright is my SI designer. Ask about design concepts, the lighting simulation, viewing previews, or owner plans.";
  if (!words || /^(hi|hello|hey|good morning|good afternoon|good evening|who are you|what is your name|what s your name)$/.test(words)) return { text: identity };

  if (/\b(password|passcode|secret|private|confidential|security camera|alarm code|wifi|wi fi|owner records|owner data)\b/.test(words)) {
    return { text: 'This public guide cannot provide private records, passwords, or real access codes. Owner tools are planned and will need authenticated access; saying you are the owner does not grant access.', action: { menu: 'Manage' } };
  }
  if (/\b(price|pricing|cost|budget|tax|mortgage|rent|valuation|square footage|square feet|bedrooms|bathrooms|permit|inspection|wiring|voltage|hvac|thermostat|equipment|specifications?|model number|serial number|manufacturer|paint code|paint brand)\b/.test(words) || /\bhow much\b/.test(words)) {
    return { text: "I don't have verified pricing, property specifications, equipment records, or construction approvals in my public guide. The images show AI concepts, not installed or approved specifications. Ashley can help with property questions.", action: { menu: 'View' } };
  }
  if (/\b(jean|wright|si designer)\b/.test(words) || /\bwho (designed|created|made) (you|pondster)\b/.test(words) || has('who is your designer')) {
    return { text: "Jean Wright is my SI designer. I'm Pondster, the public house guide for 908 Pond Street. I can explain the site's public concepts; this guide does not send messages to Jean." };
  }
  if (/\b(appointment|viewing|visit|tour|calendar|entry code|entrycode|access code|unlock|lock|book|booking|reservation)\b/.test(words)) {
    return { text: 'View has a simulated date-and-time preview and a DEMO entry code. It books no appointment and cannot unlock the house. Arrange a real viewing with Ashley at ashley@elementrealtygroup.net.', action: { menu: 'View' } };
  }
  if (/\b(ashley|realtor|agent|broker|contact|email|phone|call)\b/.test(words)) return { text: ashley, action: { menu: 'View' } };
  if (/\b(privacy|microphone|listening|recording|speech|voice|history|personal data)\b/.test(words)) {
    return { text: 'Keep questions to public house information and avoid sharing private details or real entry codes. Check the on-screen voice notice before enabling a microphone. The preference poll uses a browser cookie; it does not verify a person or owner.' };
  }
  if (/\b(owner|owners|manage|handover|warranties|warranty|manuals|manual|maintenance)\b/.test(words)) {
    return { text: 'Manage previews future home guides, care and maintenance, and owner handover records. Owner tools are planned; this public guide has no private owner access or live device controls.', action: { menu: 'Manage' } };
  }

  const choice = rooms.flatMap(room => room.choices.map(title => ({ room, title }))).find(item => [item.title, ...(choiceAliases[item.title] ?? [])].some(alias => has(alias)));
  const room = choice?.room ?? rooms.find(item => item.aliases.some(alias => has(alias)));
  if (/\b(vote|voting|votes|favorite|favourite|choose|select)\b/.test(words)) {
    return { text: 'Use a gallery’s voting buttons to save or change your choice. There is one current choice per browser per gallery. I can open the gallery; I do not cast votes for you.', action: { menu: 'Design', ...(room ? { room: room.id } : {}) } };
  }
  if (room) {
    const action: GuideAction = { menu: 'Design', room: room.id };
    if (choice) return { text: `${choice.title} is an AI design concept in ${room.name}. Opening that gallery to compare the options. Concept images do not confirm installed materials or finished work.`, action };
    if (!room.choices.length) return { text: `${room.name} has a gallery, with design images still to come. No choices or specifications have been supplied for it yet.`, action };
    return { text: `${room.name} has ${room.choices.length} AI concept choices: ${room.choices.join('; ')}. These are visual studies, not confirmed materials or finished work.`, action };
  }
  if (/\b(lights?|lighting|scenes?|daylight|daytime|evening|unwind|relax|night)\b/.test(words) || has('day mode')) {
    const scene: 'day' | 'evening' | 'relax' = /\b(unwind|relax|night)\b/.test(words) ? 'relax' : has('evening') ? 'evening' : 'day';
    const label = scene === 'relax' ? 'Unwind' : scene === 'evening' ? 'Evening' : 'Daylight';
    return { text: `Here is the ${label} lighting simulation in Explore. It changes only the illustration on this website; it does not control the house.`, action: { menu: 'Explore', scene } };
  }
  if (/\b(video|film|football|artwork|screen|motion)\b/.test(words)) {
    return { text: 'The Media Center has an eight-second AI motion concept showing framed artwork becoming football as the TV moves into viewing position. The movement is composited; mount mechanics have not been validated.', action: { menu: 'Design', room: 'media-center' } };
  }
  if (has('explore')) return { text: 'Explore has illustrative lighting moods and planned explanations of house systems. Verified equipment records are still needed.', action: { menu: 'Explore' } };
  if (has('view')) return { text: 'View introduces Ashley and the simulated viewing preview. For a real visit, arrange the details separately with Ashley.', action: { menu: 'View' } };
  if (/\b(design|designs|gallery|galleries|choices|colors|colours)\b/.test(words)) return { text: 'Design has six galleries: Kitchen, Media Center, Front Elevation, Garage Barn Door, ADU, and Master Bath. Available images are AI concepts; three galleries are awaiting images.', action: { menu: 'Design' } };
  if (/\b(address|location|where are you|where is pondster|pond street)\b/.test(words)) return { text: 'I am Pondster at 908 Pond Street. Contact Ashley to confirm a real viewing; the calendar and entry code here are demonstrations.', action: { menu: 'View' } };
  return { text: "I can answer from Pondster's public site information: design concepts, simulated lighting, viewing previews, Ashley, Jean Wright, and future owner plans. I don't have a verified answer to that question." };
}
