import { basementColorSchemes, masterBathDesigns, hallBathDesigns, roomFeatures, systemFeatures } from './features.js';

export type GuideAction = { menu: 'Design' | 'Explore' | 'View' | 'Own' | 'Built By'; room?: string; scene?: 'day' | 'evening' | 'relax' };
export type GuideReply = { text: string; action?: GuideAction };

export function isPondsterWakeRequest(transcript: string) {
  return /\b(?:pondster|pond\s*star|pond\s*stir)\b/i.test(transcript);
}

// Public concept names mirror lib/designs.ts; the focused tests check this list.
const rooms = [
  { id: 'kitchen', name: 'Kitchen', aliases: ['kitchen'], choices: [] as string[] },
  { id: 'media-center', name: 'Living Room', aliases: ['living room', 'livingroom', 'media center', 'media centre', 'entertainment center', 'entertainment centre', 'television', 'tv'], choices: ['Warm Ivory Cream', 'Soft Dusty Sage Green', 'Deep Muted Navy Blue', 'Medium Mushroom Taupe', 'Deep Muted Olive Green', 'Rich Charcoal Gray'] },
  { id: 'front-elevation', name: 'Front Elevation', aliases: ['front elevation', 'front exterior', 'front of the house', 'exterior', 'shutters'], choices: ['Warm welcome', 'Black shutters'] },
  { id: 'garage-barn-door', name: 'Garage Barn Door', aliases: ['garage', 'barn door'], choices: ['Warm white board & batten', 'Charcoal green board & batten', 'Limewashed brick'] },
  { id: 'adu', name: 'ADU', aliases: ['adu', 'accessory dwelling unit'], choices: [] as string[] },
  { id: 'master-bath', name: 'Master Bath', aliases: ['master bath', 'primary bath', 'main bath', 'bathroom'], choices: masterBathDesigns.map(design => design.title) },
  { id: 'hall-bath', name: 'Hall Bath', aliases: ['hall bath', 'hall bathroom', 'hallway bath', 'hallway bathroom', 'tub and shower', 'tub shower', 'floating vanity'], choices: hallBathDesigns.map(design => design.title) },
  { id: 'spiral-staircase', name: 'Home Theatre', aliases: ['home theatre', 'home theater', 'theatre', 'theater', 'cinema', 'basement', 'spiral staircase', 'spiral stairs', 'spiral', 'staircase', 'stairs', 'stair setting', 'sequential stair lights'], choices: ['Black spiral staircase', ...basementColorSchemes.map(scheme => `Stair setting · ${scheme.title}`)] },
  { id: 'back-deck', name: 'Back Deck', aliases: ['back deck', 'rear deck', 'deck', 'courtyard'], choices: ['Oak courtyard deck'] }
];
const choiceAliases: Record<string, string[]> = {
  'Warm Ivory Cream': ['warm ivory', 'ivory cream'],
  'Soft Dusty Sage Green': ['sage'],
  'Deep Muted Navy Blue': ['navy'],
  'Medium Mushroom Taupe': ['mushroom', 'taupe'],
  'Deep Muted Olive Green': ['olive'],
  'Rich Charcoal Gray': ['rich charcoal', 'charcoal gray', 'charcoal grey', 'charcoal clay'],
  'Warm Ivory': ['ivory'],
  'Soft Dusty Blue': ['dusty blue'],
  'Deep Navy': ['navy'],
  'Forest Green': ['forest'],
  'Mushroom Taupe': ['mushroom', 'taupe'],
  'Muted Terracotta': ['terracotta'],
  'Warm welcome': ['wood shutters', 'wooden shutters'],
  'Black shutters': ['black shutter'],
  'Warm white board & batten': ['warm white', 'white board and batten'],
  'Charcoal green board & batten': ['charcoal green'],
  'Limewashed brick': ['limewash', 'limewashed'],
  ...Object.fromEntries(hallBathDesigns.map(design => [design.title, [design.title.replace('&', 'and'), design.title.replace(/^Tub & shower · /, '')]])),
  ...Object.fromEntries(basementColorSchemes.map(scheme =>
    [`Stair setting · ${scheme.title}`, [scheme.title, scheme.title.replace('&', 'and')]]
  ))
};
// Reuse established palette nicknames without changing their unscoped priority.
for (const design of hallBathDesigns) {
  const palette = design.title.replace(/^Tub & shower · /, '');
  const original = masterBathDesigns.find(item => !item.id.startsWith('bath-tub-') && item.title.endsWith(palette));
  if (original) choiceAliases[design.title].push(...(choiceAliases[original.title] ?? []));
}
const ashley = 'Ashley Morello is my realtor with Element Realty Group at Howard Hanna Allen Tate. You can reach her at ashley@elementrealtygroup.net or 919-417-0612.';
function normalize(value: string) { return value.toLowerCase().replace(/[^a-z0-9]+/g, ' ').trim(); }
function hasPhrase(input: string, phrase: string) { return ` ${input} `.includes(` ${normalize(phrase)} `); }

export function answerPondster(input: string): GuideReply {
  const words = normalize(input).replace(/^(?:(?:hey|hi|hello|okay|ok) )?pondster(?: |$)/, '').trim();
  const has = (phrase: string) => hasPhrase(words, phrase);
  const tubContext = /\b(tubs?|showers?|bathtub|floating vanity)\b/.test(words);
  const bathOperation = /\b(start|stop|fill|run|turn on|turn off|shut off|temperature|preferred|recognize|voice|activate|activated)\b/.test(words);
  const tubDesignRequest = tubContext && !bathOperation && (hallBathDesigns.some(design => (choiceAliases[design.title] ?? []).some(alias => has(alias)))
    || /\b(show|compare|designs?|galler(?:y|ies)|colou?rs?|palettes?|schemes?|choices?|finishes|features?|vote|voting|floating vanity)\b/.test(words));
  const identity = "I'm Pondster, the voice and identity of this house. My location is confidential for now—think witness protection, with better curb appeal. Jean Wright is my SI designer. Direct your questions to me about my future features, design concepts, lighting simulation, viewing previews, Built By company page, or owner experience.";
  if (!words || /^(hi|hello|hey|good morning|good afternoon|good evening|who are you|what is your name|what s your name)$/.test(words)) return { text: identity };

  if (/\b(password|passcode|secret|private|confidential|live camera feed|camera footage|surveillance feed|saved profile|personal profile|alarm code|wifi|wi fi|owner records|owner data)\b/.test(words)) {
    return { text: 'I cannot provide private records, passwords, or real access codes here. My future owner tools will need authenticated access; saying you are the owner does not grant access.', action: { menu: 'Own' } };
  }
  if (/\b(price|pricing|cost|budget|tax|mortgage|rent|valuation|square footage|square feet|bedrooms|bathrooms|permit|inspection|wiring|voltage|hvac|thermostat|equipment|specifications?|model number|serial number|manufacturer|paint code|paint brand)\b/.test(words) || /\bhow much\b/.test(words)) {
    return { text: "I don't have verified pricing, property specifications, equipment records, or construction approvals to share here. My images show AI concepts, not installed or approved specifications. You can keep asking me about my public information." };
  }
  const systemId = /\b(tankless|hot water|water heater|recirculation|recirculating|circulating system)\b/.test(words) ? 'hot-water'
    : /\b(proximity|occupancy|presence|multiple people)\b/.test(words) || (/\b(tv|television)\b/.test(words) && /\b(kitchen|living room)\b/.test(words) && /\b(automatic|automatically|people|empty|occupied|swing|swings|turn|turns)\b/.test(words)) ? 'presence'
    : !tubDesignRequest && (/\b(showers?|tubs?|bathtub)\b/.test(words) || (/\bbaths?\b/.test(words) && /\b(voice|activated|command|fill|temperature|preferred|stop|full)\b/.test(words))) ? 'bath-and-shower'
    : /\b(cameras?|surveillance)\b/.test(words) ? 'exterior-awareness' : null;
  if (systemId) {
    const feature = systemFeatures.find(item => item.id === systemId)!;
    return { text: `${feature.text} These are my future features; my equipment and integrations still need confirmation. I can’t operate these systems or show live camera feeds from this website.`, action: { menu: 'Explore' } };
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
  if (/\b(owner|owners|own|belong|manage|handover|warranties|warranty|manuals|manual|maintenance)\b/.test(words)) {
    return { text: 'I will provide home guides, care and maintenance information, and owner handover records. My Belong page previews those future tools; I provide no private owner access or live device controls here.', action: { menu: 'Own' } };
  }

  const explicitRoom = rooms.find(item => has(item.name))
    ?? rooms.find(item => item.id === 'hall-bath' && item.aliases.some(alias => has(alias)))
    ?? (tubDesignRequest ? rooms.find(item => item.id === 'hall-bath') : rooms.find(item => item.aliases.some(alias => has(alias))));
  const candidates = (explicitRoom ? [explicitRoom] : rooms).flatMap(room => room.choices.map(title => ({ room, title })));
  const choice = [...candidates].sort((a, b) => b.title.length - a.title.length).find(item => has(item.title) || has(item.title.replace('&', 'and')))
    ?? candidates.find(item => (choiceAliases[item.title] ?? []).some(alias => has(alias)));
  const room = explicitRoom ?? choice?.room;
  if (/\b(vote|voting|votes|favorite|favourite|choose|select)\b/.test(words)) {
    return { text: 'Use my gallery voting buttons to save or change your choice. I keep one current choice per browser per gallery. I can open the gallery; I do not cast votes for you.', action: { menu: 'Design', ...(room ? { room: room.id } : {}) } };
  }
  if ((room?.id === 'garage-barn-door' && /\b(video|film|animation|motion|sliding|slides|swing|swings|inward|entry|pedestrian)\b/.test(words)) || /\btesla\b/.test(words)) {
    return { text: 'I will feature a garage center entry section that swings inward and closes before my full door slides left. My twenty-five-second film shows a white Tesla driving out and across the scene to the left, revealing my white-marble garage floor. This is my illustrative AI/composited concept; my hardware, clearances, and the car’s turning path haven’t been validated.', action: { menu: 'Design', room: 'garage-barn-door' } };
  }
  if (room?.id === 'spiral-staircase' && /\b(video|film|animation|motion|lights|football)\b/.test(words)) {
    return { text: 'I will feature a Home Theatre screen with amber stair lights that illuminate in sequence. My twelve-second concept film shows moving football and keeps its original amber palette; it does not change to match a winning color. My full-scene AI motion concept leaves my staircase, lighting, dimensions, and clearances to be validated.', action: { menu: 'Design', room: 'spiral-staircase' } };
  }
  if (room?.id === 'media-center' && /\b(video|film|animation|motion|football)\b/.test(words)) {
    return { text: 'I will feature a framed TV with my selected manual MM-MAX1 mount, positioned by hand. My ten-second AI film shows a fixed decorative frame, a TV turning toward my kitchen, moving football, and a scrolling caption. The automatic motion is illustrative; my selected mount’s fit and clearances still need validation.', action: { menu: 'Design', room: 'media-center' } };
  }
  if (room) {
    if (/\bfeatures?\b/.test(words)) return { text: `${roomFeatures[room.id].features.join(' ')} These are my future features and design concepts; my final specifications still need confirmation.`, action: { menu: 'Explore' } };
    const action: GuideAction = { menu: 'Design', room: room.id };
    if (choice) return { text: `I have ${choice.title} as an AI design concept in my ${room.name} gallery. I’m opening it so you can compare my options. My concept images do not confirm installed materials or finished work.`, action };
    if (!room.choices.length) return { text: `I will add design images to my ${room.name} gallery. I don’t have choices or specifications to share for it yet.`, action };
    return { text: `I have ${room.choices.length} AI concept choice${room.choices.length === 1 ? '' : 's'} for my ${room.name}: ${room.choices.join('; ')}. I’m sharing visual studies, not confirmed materials or finished work.`, action };
  }
  if (/\b(lights?|lighting|scenes?|daylight|daytime|evening|unwind|relax|night)\b/.test(words) || has('day mode')) {
    const scene: 'day' | 'evening' | 'relax' = /\b(unwind|relax|night)\b/.test(words) ? 'relax' : has('evening') ? 'evening' : 'day';
    const label = scene === 'relax' ? 'Unwind' : scene === 'evening' ? 'Evening' : 'Daylight';
    return { text: `I’m showing you my ${label} lighting simulation in Explore. I change only the illustration on my website; I don’t control real house lighting here.`, action: { menu: 'Explore', scene } };
  }
  if (/\b(video|film|football|artwork|screen|motion)\b/.test(words)) {
    return { text: 'I will feature a framed TV with my selected manual MM-MAX1 mount, positioned by hand. My ten-second AI film shows a fixed decorative frame, a TV turning toward my kitchen, moving football, and a scrolling caption. The automatic motion is illustrative; my selected mount’s fit and clearances still need validation.', action: { menu: 'Design', room: 'media-center' } };
  }
  if (has('explore') || /\b(features?|room by room)\b/.test(words)) return { text: 'I show the features I will bring to my house and each of my spaces on Explore, alongside my design concepts. You can also try my illustrative lighting moods. My equipment and construction details still need confirmation.', action: { menu: 'Explore' } };
  if (has('view')) return { text: 'I introduce Ashley and my simulated viewing preview on View. For a real visit with me, arrange the details separately with Ashley.', action: { menu: 'View' } };
  if (/\b(design|designs|gallery|galleries|choices|colors|colours)\b/.test(words)) return { text: `I have ${rooms.length} design galleries: ${rooms.map(room => room.name).join(', ')}. I share AI concept images where choices are available and will add images for my other galleries.`, action: { menu: 'Design' } };
  if (/\b(address|location|where are you|where is pondster)\b/.test(words)) return { text: 'I’m Pondster, the voice and identity of this house. My location is confidential for now—think witness protection, with better curb appeal. You can explore my design ideas here and find future viewing arrangements on View.', action: { menu: 'View' } };
  return { text: "I can answer from my public website information: future features, design concepts, simulated lighting, viewing previews, Ashley, my SI designer Jean Wright, Buy Your Home, LLC, and my future owner experience. I don't have a verified answer to that question." };
}
