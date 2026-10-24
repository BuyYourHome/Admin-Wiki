// Public website capabilities and supplied design concepts; not an installed specification.
export const houseFeatures = [
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
    'I’m still gathering my kitchen designs and appliance details.'
  ] },
  'media-center': { status: 'MY DESIGN CONCEPT', features: [
    'I’m exploring a framed TV that changes from artwork to football and turns toward my kitchen.',
    'I have six cabinet-and-backdrop color combinations to compare.',
    'I keep my surrounding walls warm off-white and my floor honey-toned in these studies.'
  ] },
  'front-elevation': { status: 'MY DESIGN CONCEPT', features: [
    'I’m comparing warm wood shutters with black shutters.',
    'I’m exploring dark and pale siding with warm exterior lighting.',
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
  'master-bath': { status: 'IN MY PLANS', features: [
    'I’m exploring materials and fixtures for my master bath.',
    'I’m still collecting my fixture choices and finish concepts.'
  ] },
  'spiral-staircase': { status: 'IN MY PLANS', features: [
    'I’m exploring a spiral staircase to connect my spaces.',
    'I’m still defining my stair design, materials, and dimensions.'
  ] },
  'back-deck': { status: 'IN MY PLANS', features: [
    'I’m exploring my back deck as an outdoor living space.',
    'I’m still collecting ideas for my layout, materials, and finishes.'
  ] }
};
