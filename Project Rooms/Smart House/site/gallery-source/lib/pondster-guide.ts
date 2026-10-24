export type GuideAction = { menu: 'Design' | 'Explore' | 'View' | 'Own' | 'Built By'; room?: string; scene?: 'day' | 'evening' | 'relax' };
export type GuideReply = { text: string; action?: GuideAction };

export function isPondsterWakeRequest(transcript: string) {
  return /\b(?:pondster|pond\s*star|pond\s*stir)\b/i.test(transcript);
}

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
const ashley = 'Ashley Morello is my realtor with Element Realty Group at Howard Hanna Allen Tate. You can reach her at ashley@elementrealtygroup.net or 919-417-0612.';
function normalize(value: string) { return value.toLowerCase().replace(/[^a-z0-9]+/g, ' ').trim(); }
function hasPhrase(input: string, phrase: string) { return ` ${input} `.includes(` ${normalize(phrase)} `); }

export function answerPondster(input: string): GuideReply {
  const words = normalize(input).replace(/^(?:(?:hey|hi|hello|okay|ok) )?pondster(?: |$)/, '').trim();
  const has = (phrase: string) => hasPhrase(words, phrase);
  const identity = "I'm Pondster, the voice and identity of this house. My location is confidential for now—think witness protection, with better curb appeal. Jean Wright is my SI designer. Direct your questions to me about design concepts, the lighting simulation, viewing previews, the Built By company page, or owner plans.";
  if (!words || /^(hi|hello|hey|good morning|good afternoon|good evening|who are you|what is your name|what s your name)$/.test(words)) return { text: identity };

  if (/\b(password|passcode|secret|private|confidential|security camera|alarm code|wifi|wi fi|owner records|owner data)\b/.test(words)) {
    return { text: 'I cannot provide private records, passwords, or real access codes here. My future owner tools will need authenticated access; saying you are the owner does not grant access.', action: { menu: 'Own' } };
  }
  if (/\b(price|pricing|cost|budget|tax|mortgage|rent|valuation|square footage|square feet|bedrooms|bathrooms|permit|inspection|wiring|voltage|hvac|thermostat|equipment|specifications?|model number|serial number|manufacturer|paint code|paint brand)\b/.test(words) || /\bhow much\b/.test(words)) {
    return { text: "I don't have verified pricing, property specifications, equipment records, or construction approvals to share here. My images show AI concepts, not installed or approved specifications. You can keep asking me about my public information." };
  }
  if (/\b(built by|builder|builders|developer|buy your home|buyyourhomellc|wes|wes browning)\b/.test(words) || /\bwho (built|is building|developed) (you|pondster|the house)\b/.test(words)) {
    return { text: 'Buy Your Home, LLC is the company behind me. Its website describes buying, repairing, managing, and selling homes with personal service and flexible real estate options. I can show you its overview, official website, and Wes Browning at 919-917-7466 on my Built By page.', action: { menu: 'Built By' } };
  }
  if (/\b(jean|wright|si designer)\b/.test(words) || /\bwho (designed|created|made) (you|pondster)\b/.test(words) || has('who is your designer')) {
    return { text: "Jean Wright is my SI designer. Direct your questions to me, Pondster. I can explain my public design concepts and website information. I don't send questions to Jean." };
  }
  if (/\b(appointment|viewing|visit|tour|calendar|entry code|entrycode|access code|unlock|lock|book|booking|reservation)\b/.test(words)) {
    return { text: 'I offer a simulated date-and-time preview and a DEMO entry code on my View page. I book no appointment and cannot unlock my doors. For a real visit with me, arrange the details with Ashley at ashley@elementrealtygroup.net.', action: { menu: 'View' } };
  }
  if (/\b(ashley|realtor|agent|broker|contact|email|phone|call)\b/.test(words)) return { text: ashley, action: { menu: 'View' } };
  if (/\b(privacy|microphone|listening|recording|speech|voice|history|personal data)\b/.test(words)) {
    return { text: 'Ask me about my public information, and please avoid sharing private details or real entry codes. Read my voice notice before enabling a microphone. I use a browser cookie for design preferences; it does not verify a person or owner.' };
  }
  if (/\b(owner|owners|own|manage|handover|warranties|warranty|manuals|manual|maintenance)\b/.test(words)) {
    return { text: 'I preview my future home guides, care and maintenance, and owner handover records on my Own page. I’m still planning those owner tools; I provide no private owner access or live device controls here.', action: { menu: 'Own' } };
  }

  const choice = rooms.flatMap(room => room.choices.map(title => ({ room, title }))).find(item => [item.title, ...(choiceAliases[item.title] ?? [])].some(alias => has(alias)));
  const room = choice?.room ?? rooms.find(item => item.aliases.some(alias => has(alias)));
  if (/\b(vote|voting|votes|favorite|favourite|choose|select)\b/.test(words)) {
    return { text: 'Use my gallery voting buttons to save or change your choice. I keep one current choice per browser per gallery. I can open the gallery; I do not cast votes for you.', action: { menu: 'Design', ...(room ? { room: room.id } : {}) } };
  }
  if ((room?.id === 'garage-barn-door' && /\b(video|film|animation|motion|sliding|slides|swing|swings|inward|entry|pedestrian)\b/.test(words)) || /\btesla\b/.test(words)) {
    return { text: 'I have a sixteen-second motion concept for my garage: my center entry section swings inward, closes, and then my full door assembly slides left to reveal a white Tesla Model Y. I’m sharing an illustrative AI/composited concept; my door hardware and clearances haven’t been validated.', action: { menu: 'Design', room: 'garage-barn-door' } };
  }
  if (room) {
    const action: GuideAction = { menu: 'Design', room: room.id };
    if (choice) return { text: `I have ${choice.title} as an AI design concept in my ${room.name} gallery. I’m opening it so you can compare my options. My concept images do not confirm installed materials or finished work.`, action };
    if (!room.choices.length) return { text: `My ${room.name} gallery has design images still to come. I don’t have choices or specifications to share for it yet.`, action };
    return { text: `I have ${room.choices.length} AI concept choices for my ${room.name}: ${room.choices.join('; ')}. I’m sharing visual studies, not confirmed materials or finished work.`, action };
  }
  if (/\b(lights?|lighting|scenes?|daylight|daytime|evening|unwind|relax|night)\b/.test(words) || has('day mode')) {
    const scene: 'day' | 'evening' | 'relax' = /\b(unwind|relax|night)\b/.test(words) ? 'relax' : has('evening') ? 'evening' : 'day';
    const label = scene === 'relax' ? 'Unwind' : scene === 'evening' ? 'Evening' : 'Daylight';
    return { text: `I’m showing you my ${label} lighting simulation in Explore. I change only the illustration on my website; I don’t control real house lighting here.`, action: { menu: 'Explore', scene } };
  }
  if (/\b(video|film|football|artwork|screen|motion)\b/.test(words)) {
    return { text: 'I have a ten-second AI motion concept for my Media Center, with a fixed decorative frame, a TV that turns toward my kitchen, moving football footage, and a scrolling first-person caption. I’m showing a composited scene; my mount mechanics have not been validated.', action: { menu: 'Design', room: 'media-center' } };
  }
  if (has('explore')) return { text: 'I have illustrative lighting moods in Explore, with explanations of my systems planned for later. I still need verified equipment records.', action: { menu: 'Explore' } };
  if (has('view')) return { text: 'I introduce Ashley and my simulated viewing preview on View. For a real visit with me, arrange the details separately with Ashley.', action: { menu: 'View' } };
  if (/\b(design|designs|gallery|galleries|choices|colors|colours)\b/.test(words)) return { text: 'I have six design galleries: Kitchen, Media Center, Front Elevation, Garage Barn Door, ADU, and Master Bath. I’m sharing AI concept images; three of my galleries are awaiting images.', action: { menu: 'Design' } };
  if (/\b(address|location|where are you|where is pondster)\b/.test(words)) return { text: 'I’m Pondster, the voice and identity of this house. My location is confidential for now—think witness protection, with better curb appeal. You can explore my design ideas here and find future viewing arrangements on View.', action: { menu: 'View' } };
  return { text: "I can answer from my public website information: design concepts, simulated lighting, viewing previews, Ashley, my SI designer Jean Wright, Buy Your Home, LLC, and my future owner plans. I don't have a verified answer to that question." };
}
