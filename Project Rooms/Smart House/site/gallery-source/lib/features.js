// Public website capabilities and owner-requested plans; not an installed specification.
const bathLayoutNote = 'In this study, I keep my granite, gold accents, cabinet layout across three planes with a 45-degree center section, cove lighting, and mirror reflections from my refined reference layout.';
const bathTubLayoutNote = 'I keep my tub-and-shower arrangement, onyx-pattern tile, patterned window, step, gray floor, white countertop, mirror, gold fixtures, and LED lighting from my supplied image. My AI color study does not confirm paint codes or installed finishes.';

export const hallBathDesigns = [
  { id: 'bath-tub-warm-ivory', title: 'Tub & shower · Warm Ivory', image: 'master-bath-tub-warm-ivory.jpg', fullImage: true, detail: `In this design, I will feature warm ivory on my floating vanity with warm cream on my main painted wall. ${bathTubLayoutNote}` },
  { id: 'bath-tub-dusty-blue', title: 'Tub & shower · Dusty Blue', image: 'master-bath-tub-dusty-blue.jpg', fullImage: true, detail: `In this design, I will feature dusty blue on my floating vanity with pale blue-gray on my main painted wall. ${bathTubLayoutNote}` },
  { id: 'bath-tub-deep-navy', title: 'Tub & shower · Deep Navy', image: 'master-bath-tub-deep-navy.jpg', fullImage: true, detail: `In this design, I will feature deep navy on my floating vanity with warm ivory on my main painted wall. ${bathTubLayoutNote}` },
  { id: 'bath-tub-forest-green', title: 'Tub & shower · Forest Green', image: 'master-bath-tub-forest-green.jpg', fullImage: true, detail: `In this design, I will feature forest green on my floating vanity with pale sage on my main painted wall. ${bathTubLayoutNote}` },
  { id: 'bath-tub-mushroom-taupe', title: 'Tub & shower · Mushroom Taupe', image: 'master-bath-tub-mushroom-taupe.jpg', fullImage: true, detail: `In this design, I will feature mushroom taupe on my floating vanity with pale greige on my main painted wall. ${bathTubLayoutNote}` },
  { id: 'bath-tub-terracotta', title: 'Tub & shower · Terracotta', image: 'master-bath-tub-terracotta.jpg', fullImage: true, detail: `In this design, I will feature terracotta on my floating vanity with warm ivory on my main painted wall. ${bathTubLayoutNote}` }
];

export const masterBathDesigns = [
  { id: 'bath-warm-ivory', title: 'Warm Ivory', image: 'master-bath-warm-ivory.jpg', detail: `In this design, I will feature warm ivory on my cabinets with soft mushroom walls. ${bathLayoutNote}` },
  { id: 'bath-dusty-blue', title: 'Soft Dusty Blue', image: 'master-bath-dusty-blue.jpg', detail: `In this design, I will feature soft dusty blue on my cabinets with warm ivory walls. ${bathLayoutNote}` },
  { id: 'bath-deep-navy', title: 'Deep Navy', image: 'master-bath-deep-navy.jpg', detail: `In this design, I will feature deep navy on my cabinets with light warm greige walls. ${bathLayoutNote}` },
  { id: 'bath-forest-green', title: 'Forest Green', image: 'master-bath-forest-green.jpg', detail: `In this design, I will feature forest green on my cabinets with warm ivory walls. ${bathLayoutNote}` },
  { id: 'bath-mushroom-taupe', title: 'Mushroom Taupe', image: 'master-bath-mushroom-taupe.jpg', detail: `In this design, I will feature mushroom taupe on my cabinets with warm white walls. ${bathLayoutNote}` },
  { id: 'bath-muted-terracotta', title: 'Muted Terracotta', image: 'master-bath-muted-terracotta.jpg', detail: `In this design, I will feature muted terracotta on my cabinets with warm ivory walls. ${bathLayoutNote}` }
];

const basementLayoutNote = 'I keep my black spiral staircase, full screen-and-stair composition, mountain artwork, marble floor, and amber LED lighting from my reference. My AI study is a visual concept, not manufacturer paint specifications or proof of installed finishes; my stair dimensions and clearances still need confirmation.';

export const basementColorSchemes = [
  { slug: 'soft-ivory', title: 'Soft Ivory', image: 'basement-soft-ivory.jpg', detail: `In this design, I will feature ivory walls and ceiling, pale brick, and a taupe sofa in my basement. ${basementLayoutNote}` },
  { slug: 'midnight-navy', title: 'Midnight Navy', image: 'basement-midnight-navy.jpg', detail: `In this design, I will feature deep navy walls and ceiling, warm ivory brick, and a slate blue sofa in my basement. ${basementLayoutNote}` },
  { slug: 'forest-green', title: 'Forest Green', image: 'basement-forest-green.jpg', detail: `In this design, I will feature forest green walls, an ivory ceiling, sage brick, and a moss sofa in my basement. ${basementLayoutNote}` },
  { slug: 'charcoal-copper', title: 'Charcoal & Copper', image: 'basement-charcoal-copper.jpg', detail: `In this design, I will feature charcoal walls and ceiling, greige brick, and a camel sofa with copper tones in my basement. ${basementLayoutNote}` },
  { slug: 'mushroom-clay', title: 'Mushroom & Clay', image: 'basement-mushroom-clay.jpg', detail: `In this design, I will feature mushroom taupe walls, an ivory ceiling, muted clay brick, and a clay sofa in my basement. ${basementLayoutNote}` },
  { slug: 'coastal-blue', title: 'Coastal Blue', image: 'basement-coastal-blue.jpg', detail: `In this design, I will feature dusty blue walls, a white ceiling, whitewashed brick, and a blue gray sofa in my basement. ${basementLayoutNote}` }
];

export const systemFeatures = [
  { id: 'hot-water', title: 'My instant hot water', status: 'IN MY PLANS', text: 'I will feature a natural-gas tankless water heater with whole-house recirculation to keep hot water ready when you need it.' },
  { id: 'presence', title: 'I follow your routine', status: 'IN MY PLANS', text: 'I will use proximity sensing for multiple people to support my room automations. My TV will use my selected manual MM-MAX1 mount, positioned by hand.' },
  { id: 'bath-and-shower', title: 'My bath, your preferences', status: 'IN MY PLANS', text: 'I will feature voice-activated baths and showers. I will recognize you, fill my tub at your preferred temperature, and shut off the water when it’s full. My shower will start at your command.' },
  { id: 'exterior-awareness', title: 'I keep an eye outside', status: 'IN MY PLANS', text: 'My exterior cameras will follow individuals around my outside spaces. When you’re inside, I will switch my TV to surveillance mode to show the outside view.' }
];

export const houseFeatures = [
  ...systemFeatures,
  { title: 'My voice', status: 'ON MY WEBSITE', text: 'I answer to Pondster from every page, with typed questions and optional voice interaction.' },
  { title: 'My lighting moods', status: 'IN MY PLANS', text: 'I will feature lighting zones, scenes, and everyday controls. You can try an illustration of my lighting moods below.' },
  { title: 'My sound & screens', status: 'MY DESIGN CONCEPT', text: 'I will feature connected sound and screens. My Living Room will use my selected manual MM-MAX1 TV mount; my films illustrate framed-TV motion and my amber-lit Home Theatre.' },
  { title: 'My climate & comfort', status: 'IN MY PLANS', text: 'I will provide operating guides and equipment care for my comfort systems as their details are confirmed.' },
  { title: 'Your say in my design', status: 'ON MY WEBSITE', text: 'I invite you to compare my concepts, vote on available choices, and share comments as I take shape.' },
  { title: 'My owner experience', status: 'IN MY PLANS', text: 'I will provide home guides, care information, and handover records for my future owner.' }
];

/** @type {Record<string, {status: string, features: string[]}>} */
export const roomFeatures = {
  kitchen: { status: 'IN MY PLANS', features: [
    'I will bring my kitchen layout and finishes together.',
    'My Living Room will feature my selected manual MM-MAX1 TV mount for positioning toward my kitchen.',
    'I will use proximity sensing for multiple people to support my room automations; my TV mount will be positioned by hand.',
    'My natural-gas tankless hot water system will recirculate hot water throughout my house, including my kitchen.',
    'I will add my kitchen design images as they become available. My appliance details still need confirmation.'
  ] },
  'media-center': { status: 'MY DESIGN CONCEPT', features: [
    'I will feature a framed TV for artwork and football with my selected manual MM-MAX1 mount.',
    'I will use proximity sensing for multiple people to support my room automations. My MM-MAX1 TV mount will be positioned manually.',
    'My exterior-camera system will let me switch my TV to surveillance mode while you’re inside.',
    'I have six cabinet-and-backdrop color combinations ready for your vote in my Living Room.',
    'My ten-second illustrative film shows artwork changing to football as my framed TV turns toward my kitchen. Its motion does not demonstrate automatic operation of my selected manual MM-MAX1 mount.',
    'I keep my surrounding walls warm off-white and my floor honey-toned in these six cabinet studies. My images are visual concepts, not manufacturer paint specifications or proof of installed finishes.'
  ] },
  'front-elevation': { status: 'MY DESIGN CONCEPT', features: [
    'I will feature a welcoming front elevation, with warm wood and black shutters as my two design options.',
    'I will feature dark and pale siding with warm exterior lighting.',
    'I will feature exterior cameras that follow individuals around my outside spaces and show the view on my TV while you’re inside.',
    'I have two front-elevation concepts ready for your vote.'
  ] },
  'garage-barn-door': { status: 'MY DESIGN CONCEPT', features: [
    'I will feature a center entry section that swings inward before my full door slides left. My hardware and clearances still need validation.',
    'My motion study shows a white Tesla driving out and revealing my white-marble garage floor.',
    'I will finish my garage exterior in the selected design: warm white board and batten, charcoal green board and batten, or limewashed brick.'
  ] },
  adu: { status: 'IN MY PLANS', features: [
    'I will include an accessory dwelling unit as part of my design story.',
    'My ADU layout, finishes, and equipment details remain to be specified.'
  ] },
  'master-bath': { status: 'MY DESIGN CONCEPT', features: [
    `I have ${masterBathDesigns.length} cabinet color studies ready for your vote: ${masterBathDesigns.map(design => design.title).join(', ')}.`,
    'I will feature my refined vanity layout across three cabinet planes, including a 45-degree center section, with granite, gold accents, cove lighting, and reflected details in my mirrors.',
    'I keep my sage baseline as a reference, separate from my six voting choices. My color studies are visual concepts, not manufacturer paint specifications or installed finishes.',
    'I will feature a voice-activated bath that recognizes you, fills at your preferred temperature, and turns off the water when my tub is full.',
    'My shower will start at your voice command.',
    'My natural-gas tankless heater and recirculation loop will keep hot water ready throughout my house.',
    'My actual fixtures, materials, and construction details still need confirmation.'
  ] },
  'hall-bath': { status: 'MY DESIGN CONCEPT', features: [
    `I have ${hallBathDesigns.length} Hall Bath tub-and-shower color studies ready for your vote: ${hallBathDesigns.map(design => design.title).join(', ')}.`,
    'I will feature the selected color design on my floating vanity and main painted wall in my Hall Bath.',
    'I keep my tub-and-shower arrangement, onyx-pattern tile, patterned window, step, gray floor, white countertop, mirror, gold fixtures, and LED lighting from my supplied image.',
    'My Hall Bath studies are visual concepts, not manufacturer paint specifications or proof of installed finishes. My dimensions, fixtures, and construction details still need confirmation.'
  ] },
  'spiral-staircase': { status: 'MY DESIGN CONCEPT', features: [
    'I will feature a Home Theatre with a black spiral staircase, amber tread lights, and cove lighting.',
    `I have my original black staircase concept and ${basementColorSchemes.length} full-scene Home Theatre color settings ready for your vote: ${basementColorSchemes.map(scheme => scheme.title).join(', ')}.`,
    'I keep my black staircase, mountain artwork, marble floor, and amber LEDs as I compare colors around my screen and stairs.',
    'My twelve-second concept film keeps my full screen-and-staircase scene in view while my stair lights illuminate in sequence. I keep its original amber palette; it does not change to match a winning color.',
    'My color studies are visual concepts, not manufacturer paint specifications or proof of installed finishes. My dimensions, clearances, materials, and construction details still need confirmation.'
  ] },
  'back-deck': { status: 'DESIGN CONCEPT', features: [
    'I will feature my back deck as an outdoor living space. My oak courtyard concept has one voting choice with an overview and a closer view.',
    'In this concept, my warm wood tones, railings and broad central steps open onto my courtyard. My dimensions, materials and final construction details still need verification.'
  ] }
};
