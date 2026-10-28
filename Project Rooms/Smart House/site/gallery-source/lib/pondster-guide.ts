import { floorPlanRooms } from './floor-plan';
import { basementColorSchemes, masterBathDesigns, hallBathDesigns, roomFeatures, systemFeatures, houseFeatures } from './features.js';

import type { PondsterDestination } from './pondster-destinations';
import { PONDSTER_LOCATION_TEXT } from './pondster-identity';
import { galleryVoiceCommand } from './pondster-gallery';
import {spokenSiteControl} from './pondster-control-intent';
export type GuideAction = PondsterDestination;
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
  { id: 'back-deck', name: 'Back Deck', aliases: ['back deck', 'backdeck', 'rear deck', 'deck', 'courtyard'], choices: ['Barn door stain'] }
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

const planAliases: Record<string,string[]> = { 'master-bedroom':['primary bedroom','main bedroom','master suite'], 'walk-in-closet':['walk in closet'], 'dining-room':['dining area'], 'spiral-stair':['spiral staircase','spiral stairs'], 'open-deck':['back deck'], 'existing-garage':['current garage'], 'new-garage':['proposed garage'] };

export function answerPondster(input: string): GuideReply {
  const words = normalize(input).replace(/\bh\s*v\s*a\s*c\b/g, 'hvac').replace(/^(?:(?:hey|hi|hello|okay|ok) )?pondster(?: |$)/, '').trim();
  const has = (phrase: string) => hasPhrase(words, phrase);
  const planMatches = floorPlanRooms.filter(item => has(item.name) || (planAliases[item.id] ?? []).some(alias => has(alias)))
    .sort((a,b) => b.name.length-a.name.length).filter((item,_,items) => !items.some(other => other !== item && hasPhrase(normalize(other.name),item.name)));
  const planMentionPosition=(item:{id:string;name:string})=>Math.min(...[item.name,...(planAliases[item.id] ?? [])].filter(alias=>has(alias)).map(alias=>words.indexOf(normalize(alias))));
  const interiorPlacement = planMatches.length > 0 && /\b(planning|plan|put|putting|place|placing|position|positioning)\b/.test(words);
  const informational = /\b(tell|describe|explain|about|how|what|which|will|can|does|is|are|do)\b/.test(words);
  const roomInformation = informational && !/\b(show|open|see|look|pictures?|pics?|photos?|images?|compare|vote|voting|choices?|designs?|galler(?:y|ies)|colou?rs?|palettes?|schemes?|finishes)\b/.test(words);
  const tubContext = /\b(tubs?|showers?|bathtub|floating vanity)\b/.test(words);
  const bathOperation = /\b(start|stop|fill|run|turn on|turn off|shut off|temperature|preferred|recognize|voice|activate|activated)\b/.test(words);
  const tubDesignRequest = tubContext && !bathOperation && (hallBathDesigns.some(design => (choiceAliases[design.title] ?? []).some(alias => has(alias)))
    || /\b(show|compare|designs?|galler(?:y|ies)|colou?rs?|palettes?|schemes?|choices?|finishes|features?|vote|voting|floating vanity)\b/.test(words));
  const identity = "I'm Pondster, the voice and identity of this house. " + PONDSTER_LOCATION_TEXT + ' Jean Wright is my SI designer. Direct your questions to me about my future features, design concepts, lighting simulation, viewing previews, Built By company page, or owner experience.';
  if (!words || /^(hi|hello|hey|good morning|good afternoon|good evening)$/.test(words)) return { text: identity };
  if (/^(who are you|what is your name|what s your name)$/.test(words)) return { text: identity, action: { menu: 'Design', section: 'overview' } };

  if (/\b(password|passcode|secret|private (?:records?|information|data|details?|profiles?|codes?)|confidential (?:records?|information|data|details?)|live camera feed|camera footage|surveillance feed|saved profile|personal profile|alarm code|wifi|wi fi|owner records|owner data)\b/.test(words)) {
    return { text: 'I cannot provide private records, passwords, or real access codes here. My future owner tools will need authenticated access; saying you are the owner does not grant access.', action: { menu: 'Own' } };
  }
  const image=galleryVoiceCommand(words);
  if(image)return {text:image==='vote'?'I’ll submit the design picture you are viewing and check whether your vote is saved.':image==='enlarge'?'I’m enlarging the current picture.':image==='close'?'I’m returning to my gallery.':image==='first'?'Here’s my first gallery picture.':image==='next'?'Here’s my next gallery picture.':'Here’s my previous gallery picture.',action:{menu:'Design',image}};
  const control=spokenSiteControl(input);
  if(control)return {text:'I’ll use that website control and check the result.',action:{menu:'Design',control}};
  const publicCityQuestion = /\b(where|what part|which part|what area|are you|is pondster|is (?:the|this|your|my) (?:house|home|property))\b.{0,50}\b(cary|north carolina)\b/.test(words);
  if (publicCityQuestion || /\b(address|location|street|city|town|neighborhood|zip|postal|geolocation|coordinates|latitude|longitude|what state|which state)\b/.test(words) || (/\b(where are you|where is pondster|where is the house|where is your house|where is this property)\b/.test(words) && !interiorPlacement)) return { text: PONDSTER_LOCATION_TEXT + ' My introduction shares my public location; Ashley confirms real viewing arrangements.', action: { menu: 'Design', section: 'overview' } };
  const propertyCount = /\b(?:how many|number of|count of|total(?: number of)?) (?:bedrooms?|bathrooms?|beds?|baths?|rooms?)\b/.test(words)
    || /\b(?:one|two|three|four|five|six|seven|eight|nine|ten|\d+) (?:bedrooms?|bathrooms?)\b/.test(words);
  const knownMountQuestion = informational && /\b(tv|television|mount|mm max1|mmmax1)\b/.test(words)
    && /\b(mount|mm max1|mmmax1|face|faces|facing|turn|turns|turning|position|positioned|swivel|kitchen)\b/.test(words)
    && !/\b(manufactur(?:er|ers|es|ed)|brand|serial number|installed|approved|water heater|tankless|hvac|heat pump)\b/.test(words);
  const unknownEquipment = /\b(manufactur(?:er|ers|es|ed)|serial number|paint code|paint brand)\b/.test(words)
    || (!knownMountQuestion && /\b(model number|model|brand)\b/.test(words) && /\b(equipment|appliances?|fixtures?|heater|hvac|heat pump|shower|tv|television|mount|cameras?)\b/.test(words))
    || (/\b(installed|fitted|approved|as built|completed|already have|actually have)\b/.test(words)
      && /\b(equipment|appliances?|fixtures?|heater|hvac|thermostat|shower|tub|bath|tv|mount|cameras?|systems?|materials?|finishes|paint)\b/.test(words));
  const unverifiedDetail = propertyCount || unknownEquipment
    || /\b(price|pricing|cost|budget|tax|mortgage|rent|valuation|square footage|square feet|permit|inspection|wiring|voltage|thermostat|specifications?|dimensions?|measurements?)\b/.test(words)
    || /\bhow (?:much|far|wide|deep|long|tall)\b/.test(words);
  const tradeMentions = ([
    {key:'gc',terms:/\b(gc|general contractor|glasgow|glasgowdb)\b/},
    {key:'hvac',terms:/\b(hvac|true service|trueserviceinc)\b/},
    {key:'plumber',terms:/\b(plumber|plumbing|executive plumbing|executiveplumbingcompany)\b/},
  ] as const).flatMap(({key,terms})=>{const match=terms.exec(words);return match?[{key,index:match.index}]:[];}).sort((a,b)=>a.index-b.index);
  const trade = tradeMentions.length > 0 ? tradeMentions[0].key : (/\b(contractors|trade contacts|trades)\b/.test(words)?'all':null);
  const tradeContactQuestion = /\b(who|contact|website|web site|url|link|contractors?|company|vendor|selected|hire|hired|phone|email|call)\b/.test(words);
  const hvacSystemTopic = trade === 'hvac' && /\b(systems?|plans?|features?|heating|cooling|comfort|automations?)\b/.test(words) && !tradeContactQuestion;
  const tradeQuestion = tradeContactQuestion || (!hvacSystemTopic && /\b(show|open|find|tell|describe|read|narrate|information|info|details?|about)\b/.test(words));
  if (trade && tradeQuestion && !unverifiedDetail && !/\b(address|location|where)\b/.test(words)) {
    const contacts = {
      gc: 'My selected general contractor is Glasgow Design Build: https://glasgowdb.com/.',
      hvac: 'My selected HVAC contractor is True Service Inc.: https://www.trueserviceinc.com/.',
      plumber: 'My selected plumber is Executive Plumbing Company: https://www.executiveplumbingcompany.com/.',
    };
    return { text: (trade === 'all' ? Object.values(contacts).join(' ') : tradeMentions.map(item=>contacts[item.key]).join(' ')) + ' I can show you their public websites on my Contact page.', action: { menu: 'Contact', section: trade === 'all' ? 'trades' : trade } };
  }
  if (unverifiedDetail) {
    return { text: "I don't have verified pricing, property specifications, equipment records, or construction approvals to share here. My images show AI concepts, not installed or approved specifications. You can keep asking me about my public information." };
  }
  if (knownMountQuestion && !/\b(show|open|compare|vote|video|film|animation|galler(?:y|ies)|colou?rs?)\b/.test(words)) {
    return { text: 'My selected TV mount is the manual MM-MAX1, positioned by hand. The automatic turning in my AI motion film is illustrative; my selected mount’s fit and clearances still need validation.', action: { menu: 'Explore', section: 'room', room: 'media-center' } };
  }
  if (/\b(bathrooms|baths)\b/.test(words) && roomInformation) {
    return { text: 'My Master Bath and Hall Bath have separate design studies. ' + roomFeatures['master-bath'].features.slice(0,2).join(' ') + ' ' + roomFeatures['hall-bath'].features.slice(1,3).join(' ') + ' These are my design concepts, not a verified whole-house bathroom count or installed specifications.', action: { menu: 'Explore', section: 'room', room: 'master-bath' } };
  }
  const layoutQuestion = /\b(floor plan|floorplan|proposed layout|first floor|where|next to|beside|adjoin|near|connect|relative to|open plan|open space|open to)\b/.test(words);
  if (layoutQuestion && /\bbedrooms?\b/.test(words) && /\b(labels?|labeled|labelled|plan|layout)\b/.test(words)) {
    const labels = floorPlanRooms.filter(item => ['master-bedroom','bedroom-1','bedroom-2'].includes(item.id)).map(item => item.name);
    return { text: 'In my first-floor drawing, I label ' + labels.join(', ') + '. Those plan labels do not confirm my whole-house bedroom count or completed construction.', action: { menu: 'Explore', section: 'floor-plan' } };
  }
  if (layoutQuestion || (roomInformation && planMatches.some(item => !item.galleryId))) {
    const matches = planMatches;
    if (matches.length) return { text: matches.slice(0,3).map(item => item.summary).join(' ') + ' I’m describing my planned layout, not measured or approved construction.', action: { menu: 'Explore', section: 'floor-plan', room: [...matches].sort((a,b)=>planMentionPosition(a)-planMentionPosition(b))[0]!.id } };
    if (/\b(floor plan|floorplan|proposed layout|first floor)\b/.test(words)) return { text: 'I show my first-floor layout in Explore, with my living, dining and kitchen spaces, bedroom-suite labels, pantry, laundry, garages and deck. It is a presentation plan, not a verified whole-house room count or approved construction drawing.', action: { menu: 'Explore', section: 'floor-plan' } };
  }
  if (/^(?:(?:show(?: me)?|open)(?: (?:my|your|the))? )?(?:deck structural drawing|preliminary deck drawing)(?: please)?$/.test(words)) {
    return { text: 'I have a preliminary deck structural drawing on my Belong page: /documents/deck-structural-preliminary.pdf. I’m sharing it as a preliminary design reference, not approved construction plans or confirmed specifications.', action: { menu: 'Own', section: 'drawing' } };
  }
  if (has('visual notebook')) return { text: 'I’m opening my visual notebook on View so you can browse my AI design studies.', action: {menu:'View',section:'notebook'} };
  if (/\b(view|viewing page)\b/.test(words) && /\b(ashley|realtor)\b/.test(words)) return {text:ashley,action:{menu:'View',section:'ashley'}};
  if (/\b(company|buy your home|buyyourhomellc)\b/.test(words) && /\b(contact|phone|call|email|website|web site)\b/.test(words) && !/\b(wes|built by)\b/.test(words)) return {text:'Buy Your Home, LLC is the company behind me. My company’s public contact is Wes Browning at 919-917-7466, and its website is https://www.buyyourhomellc.com/.',action:{menu:'Contact',section:'company'}};
  const virtualTour = has('virtual tour') || has('virtual design tour') || has('virtualtour')
    || /\b(?:show me|take me|look|walk me) (?:around|through)(?: (?:my|your|the|this))? (?:house|home)\b/.test(words)
    || /\b(?:take me on|give me|start|begin|launch|play|show(?: me)?|open)(?: (?:my|your|the|a))? tour\b/.test(words);
  if (virtualTour) return { text: 'I’m opening my virtual design tour. I show one view per room using my concept films and vote-leading design images. My tour controls let you choose sound or full screen.', action: { menu: 'View', section: 'tour', tour: true } };
  const menuCommand = words.match(/\b(?:go to|open|show(?: me)?|take me to|navigate to)\s+(?:my\s+|the\s+)?(built by|contact|explore|design|view|belong|own|manage)(?:\s+(?:page|menu))?(?:\s+(?:please|now|for me))?$/);
  if (menuCommand) {
    const destinations: Record<string, GuideAction['menu']> = { design: 'Design', explore: 'Explore', view: 'View', belong: 'Own', own: 'Own', manage: 'Own', contact: 'Contact', 'built by': 'Built By' };
    const menu = destinations[menuCommand[1]];
    return { text: `I’m opening my ${menu === 'Own' ? 'Belong' : menu} page.`, action: { menu } };
  }
  const systemId = /\b(tankless|hot water|water heater|recirculation|recirculating|circulating system)\b/.test(words) ? 'hot-water'
    : /\b(proximity|occupancy|presence|multiple people)\b/.test(words) || (/\b(tv|television)\b/.test(words) && /\b(kitchen|living room)\b/.test(words) && /\b(automatic|automatically|people|empty|occupied|swing|swings|turn|turns)\b/.test(words)) ? 'presence'
    : !tubDesignRequest && (/\b(showers?|tubs?|bathtub)\b/.test(words) || (/\bbaths?\b/.test(words) && /\b(voice|activated|command|fill|temperature|preferred|stop|full)\b/.test(words))) ? 'bath-and-shower'
    : /\b(cameras?|surveillance)\b/.test(words) ? 'exterior-awareness' : null;
  if (systemId) {
    const feature = systemFeatures.find(item => item.id === systemId)!;
    return { text: `${feature.text} These are my future features; my equipment and integrations still need confirmation. I can’t operate these systems or show live camera feeds from this website.`, action: { menu: 'Explore', section: systemId } };
  }
  const namedFeatureRoom = rooms.some(item=>has(item.name) || item.aliases.some(alias=>has(alias)));
  const publicFeature = [
    {section:'sound-screens' as const,title:'My sound & screens',match:!namedFeatureRoom && /\b(sound|audio|speakers|screens?)\b/.test(words) && !/\b(video|film|animation)\b/.test(words)},
    {section:'lighting-plans' as const,title:'My lighting moods',match:/\blighting\b/.test(words) && /\b(plans?|future|features?)\b/.test(words) && !/\b(evening|relax|unwind|day|night)\b/.test(words)},
    {section:'voice-feature' as const,title:'My voice',match:has('explore') && /\bvoice\b/.test(words)},
    {section:'design-participation' as const,title:'Your say in my design',match:/\b(participate|have a say|help shape|design input)\b/.test(words)},
    {section:'owner-experience' as const,title:'My owner experience',match:has('explore') && /\b(owner experience|handover)\b/.test(words)},
  ].find(item=>item.match);
  if (publicFeature) {
    const feature=houseFeatures.find(item=>item.title===publicFeature.title)!;
    return {text:feature.text+' I’m sharing my stated plans and public website features, not proof of installed equipment.',action:{menu:'Explore',section:publicFeature.section}};
  }
  if (/\b(smart|intelligent|automations?|capabilities|abilities)\b/.test(words) || has('what makes you special') || has('what makes you different') || has('what can you do') || has('tell me about pondster') || has('tell me about yourself') || has('tell me about you') || has('tell me about the house') || has('tell me about your house') || has('describe yourself') || (/\bequipment\b/.test(words) && informational)) {
    return { text: systemFeatures.map(feature => feature.text).join(' ') + ' ' + (houseFeatures.find(feature => feature.title === 'My voice')?.text ?? '') + ' These are my stated future features; my equipment and integrations still need confirmation, and this public website cannot operate my house systems.', action: { menu: 'Explore', section: 'house' } };
  }
  if (/\b(hvac|heating|cooling|climate|comfort)\b/.test(words)) {
    return { text: (houseFeatures.find(feature => feature.title === 'My climate & comfort')?.text ?? '') + ' My installed HVAC equipment, manufacturer and technical specifications are not verified here.', action: { menu: 'Explore', section: 'climate' } };
  }
  if (/\b(built by|builder|builders|developer|buy your home|buyyourhomellc|wes|wes browning|company behind you|company behind me|company building you)\b/.test(words) || /\bwho (built|is building|developed) (you|pondster|the house)\b/.test(words)) {
    return { text: 'Buy Your Home, LLC is the company behind me. Its website describes buying, repairing, managing, and selling homes with personal service and flexible real estate options. I can show you its overview, official website, and Wes Browning at 919-917-7466 on my Built By page.', action: { menu: 'Built By', section: /\b(wes|phone|call)\b/.test(words) ? 'contact' : 'company' } };
  }
  if (/\b(jean|wright|si designer)\b/.test(words) || /\bwho (designed|created|made) (you|pondster)\b/.test(words) || has('who is your designer')) {
    return { text: "Jean Wright is my SI designer. Direct your questions to me, Pondster. I can explain my public design concepts and website information. I don't send questions to Jean.", action: { menu: 'Design', section: 'overview' } };
  }
  if (/\b(appointment|viewing|visit|tour|calendar|entry code|entrycode|access code|unlock|lock|book|booking|reservation)\b/.test(words)) {
    return { text: 'I offer a simulated date-and-time preview and a DEMO entry code on my View page. I book no appointment and cannot unlock my doors. For a real visit with me, arrange the details with Ashley at ashley@elementrealtygroup.net.', action: { menu: 'View', section: 'viewing' } };
  }
  if (/\b(ashley|realtor|agent|broker|contact|email|phone|call)\b/.test(words)) return { text: ashley + ' My Contact page also has my conversation controls and my company’s public contact details.', action: { menu: 'Contact', section: 'ashley' } };
  if (/\b(privacy|microphone|listening|recording|speech|voice|history|personal data|talk to you|ask you a question)\b/.test(words)) {
    return { text: 'Ask me about my public information, and please avoid sharing private details or real entry codes. Read my voice notice before enabling a microphone. I use a browser cookie for design preferences; it does not verify a person or owner.'  , action: { menu: 'Contact', section: 'voice' } };
  }
  if (/\b(owner|owners|own|belong|manage|handover|warranties|warranty|manuals|manual|maintenance)\b/.test(words)) {
    return { text: 'I will provide home guides, care and maintenance information, and owner handover records. My Belong page previews those future tools; I provide no private owner access or live device controls here.', action: { menu: 'Own', section: /\b(handover|transfer)\b/.test(words) ? 'handover' : /\b(maintenance|care|warranty|warranties)\b/.test(words) ? 'maintenance' : 'guides' } };
  }

  const explicitRoom = rooms.find(item => has(item.name))
    ?? (has('Barn door stain') ? rooms.find(item => item.id === 'back-deck') : undefined)
    ?? rooms.find(item => item.id === 'hall-bath' && item.aliases.some(alias => has(alias)))
    ?? (tubDesignRequest ? rooms.find(item => item.id === 'hall-bath') : rooms.find(item => item.aliases.some(alias => has(alias))));
  const candidates = (explicitRoom ? [explicitRoom] : rooms).flatMap(room => room.choices.map(title => ({ room, title })));
  const choice = [...candidates].sort((a, b) => b.title.length - a.title.length).find(item => has(item.title) || has(item.title.replace('&', 'and')))
    ?? candidates.find(item => (choiceAliases[item.title] ?? []).some(alias => has(alias)));
  const room = explicitRoom ?? choice?.room;
  if (/\b(vote|voting|votes|favorite|favourite|choose|select)\b/.test(words)) {
    return { text: 'Open a design picture and say “vote for this one” to save that choice, or use its voting button. You can change your vote. I keep one current choice per browser per gallery.', action: { menu: 'Design', ...(room ? { room: room.id } : {}) } };
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
    if (/\bfeatures?\b/.test(words) || (roomInformation && !choice)) return { text: `${roomFeatures[room.id].features.join(' ')} These are my future features and design concepts; my final specifications still need confirmation.`, action: { menu: 'Explore', section: 'room', room: room.id } };
    const action: GuideAction = { menu: 'Design', room: room.id };
    if (choice) return { text: `I have ${choice.title} as an AI design concept in my ${room.name} gallery. I’m opening it so you can compare my options. My concept images do not confirm installed materials or finished work.`, action };
    if (!room.choices.length) return { text: `I will add design images to my ${room.name} gallery. I don’t have choices or specifications to share for it yet.`, action };
    return { text: `I have ${room.choices.length} AI concept choice${room.choices.length === 1 ? '' : 's'} for my ${room.name}: ${room.choices.join('; ')}. I’m sharing visual studies, not confirmed materials or finished work.`, action };
  }
  if (/\b(lights?|lighting|scenes?|daylight|daytime|evening|unwind|relax|night)\b/.test(words) || has('day mode')) {
    const scene: 'day' | 'evening' | 'relax' = /\b(unwind|relax|night)\b/.test(words) ? 'relax' : has('evening') ? 'evening' : 'day';
    const label = scene === 'relax' ? 'Unwind' : scene === 'evening' ? 'Evening' : 'Daylight';
    return { text: `I’m showing you my ${label} lighting simulation in Explore. I change only the illustration on my website; I don’t control real house lighting here.`, action: { menu: 'Explore', section: 'lighting', scene } };
  }
  if (/\b(video|film|football|artwork|screen|motion)\b/.test(words)) {
    return { text: 'I will feature a framed TV with my selected manual MM-MAX1 mount, positioned by hand. My ten-second AI film shows a fixed decorative frame, a TV turning toward my kitchen, moving football, and a scrolling caption. The automatic motion is illustrative; my selected mount’s fit and clearances still need validation.', action: { menu: 'Design', room: 'media-center' } };
  }
  if (has('explore') || /\b(features?|room by room)\b/.test(words)) return { text: 'In Explore, I show my house-wide plans: ' + houseFeatures.map(feature => feature.title).join('; ') + '. I also show my room features, first-floor layout and an interactive illustration of my lighting moods. My plans and AI concepts do not confirm installed equipment or approved construction.', action: { menu: 'Explore', section: /\broom by room\b/.test(words) ? 'rooms' : 'house' } };
  if (has('view')) return { text: 'I introduce Ashley and my simulated viewing preview on View. For a real visit with me, arrange the details separately with Ashley.', action: { menu: 'View', section: 'viewing' } };
  if (/\b(design|designs|gallery|galleries|choices|colors|colours)\b/.test(words)) return { text: `I have ${rooms.length} design galleries: ${rooms.map(room => room.name).join(', ')}. I share AI concept images where choices are available and will add images for my other galleries.`, action: { menu: 'Design', section: 'gallery' } };
  return { text: "I can answer from my public website information: future features, design concepts, simulated lighting, viewing previews, Ashley, my SI designer Jean Wright, Buy Your Home, LLC, and my future owner experience. I don't have a verified answer to that question." };
}
