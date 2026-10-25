// Public website capabilities and owner-requested plans; not an installed specification.
const bathLayoutNote = 'In this study, I keep my granite, gold accents, cabinet layout across three planes with a 45-degree center section, cove lighting, and mirror reflections from my refined reference layout.';

export const masterBathDesigns = [
  { id: 'bath-warm-ivory', title: 'Warm Ivory', image: 'master-bath-warm-ivory.jpg', detail: `I’m trying warm ivory on my cabinets with soft mushroom walls. ${bathLayoutNote}` },
  { id: 'bath-dusty-blue', title: 'Soft Dusty Blue', image: 'master-bath-dusty-blue.jpg', detail: `I’m exploring soft dusty blue on my cabinets with warm ivory walls. ${bathLayoutNote}` },
  { id: 'bath-deep-navy', title: 'Deep Navy', image: 'master-bath-deep-navy.jpg', detail: `I’m trying deep navy on my cabinets with light warm greige walls. ${bathLayoutNote}` },
  { id: 'bath-forest-green', title: 'Forest Green', image: 'master-bath-forest-green.jpg', detail: `I’m exploring forest green on my cabinets with warm ivory walls. ${bathLayoutNote}` },
  { id: 'bath-mushroom-taupe', title: 'Mushroom Taupe', image: 'master-bath-mushroom-taupe.jpg', detail: `I’m trying mushroom taupe on my cabinets with warm white walls. ${bathLayoutNote}` },
  { id: 'bath-muted-terracotta', title: 'Muted Terracotta', image: 'master-bath-muted-terracotta.jpg', detail: `I’m exploring muted terracotta on my cabinets with warm ivory walls. ${bathLayoutNote}` }
];

export const systemFeatures = [
  { id: 'hot-water', title: 'My instant hot water', status: 'IN MY PLANS', text: 'I’m planning a natural-gas tankless water heater with whole-house recirculation, so hot water is ready when you need it.' },
  { id: 'presence', title: 'I follow your routine', status: 'IN MY PLANS', text: 'I’m planning proximity sensing for multiple people. If my living room is empty and you’re in my kitchen, I’d turn my TV toward you. I’d turn it back when you settle into my living room.' },
  { id: 'bath-and-shower', title: 'My bath, your preferences', status: 'IN MY PLANS', text: 'I’m planning voice-activated baths and showers. I’d recognize you, fill my tub at your preferred temperature, and shut off the water when it’s full. My shower would start at your command.' },
  { id: 'exterior-awareness', title: 'I keep an eye outside', status: 'IN MY PLANS', text: 'My planned exterior cameras would follow individuals around my outside spaces. When you’re inside, I’d switch my TV to surveillance mode to show the outside view.' }
];

export const houseFeatures = [
  ...systemFeatures,
  { title: 'My voice', status: 'ON MY WEBSITE', text: 'I answer to Pondster from every page, with typed questions and optional voice interaction.' },
  { title: 'My lighting moods', status: 'IN MY PLANS', text: 'I’m exploring lighting zones, scenes, and everyday controls. You can try an illustration of my lighting moods below.' },
  { title: 'My sound & screens', status: 'MY DESIGN CONCEPT', text: 'I’m exploring connected sound and screens, with a framed TV motion study in my Media Center gallery.' },
  { title: 'My climate & comfort', status: 'IN MY PLANS', text: 'I’m planning operating guides and equipment care for my comfort systems as their details are confirmed.' },
  { title: 'Your say in my design', status: 'ON MY WEBSITE', text: 'I invite you to compare my concepts, vote on available choices, and share comments as I take shape.' },
  { title: 'My owner experience', status: 'IN MY PLANS', text: 'I’m planning home guides, care information, and handover records for my future owner.' }
];

/** @type {Record<string, {status: string, features: string[]}>} */
export const roomFeatures = {
  kitchen: { status: 'IN MY PLANS', features: [
    'I’m collecting ideas for my kitchen layout and finishes.',
    'My Media Center film explores a TV that turns toward my kitchen.',
    'My planned proximity sensing would turn my TV toward my occupied kitchen when my living room is empty, then return it when you settle into my living room.',
    'My planned natural-gas tankless hot water system would recirculate hot water throughout my house, including my kitchen.',
    'I’m still gathering my kitchen designs and appliance details.'
  ] },
  'media-center': { status: 'MY DESIGN CONCEPT', features: [
    'I’m exploring a framed TV that changes from artwork to football and turns toward my kitchen.',
    'I’m planning to track multiple people with proximity devices and turn my TV between my kitchen and living room as people move.',
    'My planned exterior-camera system would let me switch my TV to surveillance mode while you’re inside.',
    'I have six cabinet-and-backdrop color combinations to compare.',
    'I’m also exploring an amber-lit home theater with a black spiral staircase as another AI concept ready for your vote.',
    'My twelve-second theater film shows moving football and amber stair lights illuminating in sequence.',
    'I keep my surrounding walls warm off-white and my floor honey-toned in my six cabinet color studies. My theater concept leaves dimensions and clearances unconfirmed.'
  ] },
  'front-elevation': { status: 'MY DESIGN CONCEPT', features: [
    'I’m comparing warm wood shutters with black shutters.',
    'I’m exploring dark and pale siding with warm exterior lighting.',
    'I’m planning exterior cameras that follow individuals around my outside spaces and show the view on my TV while you’re inside.',
    'I have two front-elevation concepts ready for your vote.'
  ] },
  'garage-barn-door': { status: 'MY DESIGN CONCEPT', features: [
    'I’m exploring a center entry section that swings inward before my full door slides left.',
    'My motion study shows a white Tesla driving out and revealing my white-marble garage floor.',
    'I’m comparing warm white board and batten, charcoal green board and batten, and limewashed brick.'
  ] },
  adu: { status: 'IN MY PLANS', features: [
    'I’m exploring an accessory dwelling unit as part of my design story.',
    'I’m still defining my layout, finishes, and equipment details.'
  ] },
  'master-bath': { status: 'MY DESIGN CONCEPT', features: [
    `I have ${masterBathDesigns.length} cabinet color studies ready for your vote: ${masterBathDesigns.map(design => design.title).join(', ')}.`,
    'I’m exploring my refined vanity layout across three cabinet planes, including a 45-degree center section, with granite, gold accents, cove lighting, and reflected details in my mirrors.',
    'I keep my sage baseline as a reference, separate from my six voting choices. My color studies are visual concepts, not manufacturer paint specifications or installed finishes.',
    'I’m planning a voice-activated bath that recognizes you, fills at your preferred temperature, and turns off the water when my tub is full.',
    'My planned shower would start at your voice command.',
    'My planned natural-gas tankless heater and recirculation loop would keep hot water ready throughout my house.',
    'I’m still confirming my actual fixtures, materials, and construction details.'
  ] },
  'spiral-staircase': { status: 'MY DESIGN CONCEPT', features: [
    'I’m exploring a black spiral staircase with amber tread and cove lighting beside my home theater.',
    'My twelve-second concept film keeps my full screen-and-staircase scene in view while my stair lights illuminate in sequence.',
    'I have one AI staircase concept ready for your vote; my dimensions, clearances, materials, and construction details still need confirmation.'
  ] },
  'back-deck': { status: 'IN MY PLANS', features: [
    'I’m exploring my back deck as an outdoor living space.',
    'I’m still collecting ideas for my layout, materials, and finishes.'
  ] }
};
