import { roomFeatures } from './features.js';

export const PLAN_WIDTH = 1140;
export const PLAN_HEIGHT = 1030;

export type FloorPlanRoom = {
  id: string;
  name: string;
  polygon: string;
  summary: string;
  features: string[];
  galleryId?: string;
  galleryLabel?: string;
};

// Navigation regions follow the supplied first-floor presentation drawing.
// The living/dining/kitchen zones share an open space; these are not new walls.
// Native CAD inches -> PDF points -> the drawing-only crop (140,245,1280,1275).
function region(points: [number, number][]) {
  return points.map(([x, y]) => `${(24 + x * 1.37).toFixed(2)},${(1116 - y * 1.37).toFixed(2)}`).join(' ');
}
function box(x1: number, y1: number, x2: number, y2: number) {
  return region([[x1,y1],[x2,y1],[x2,y2],[x1,y2]]);
}

export const floorPlanRooms: FloorPlanRoom[] = [
  {
    id: 'living-room', name: 'Living Room', polygon: box(300.9,106.5,592.9,282),
    summary: 'My living room is part of the shared living, dining and kitchen space in my proposed layout.',
    features: roomFeatures['media-center'].features,
    galleryId: 'media-center', galleryLabel: 'Visit my Living Room gallery'
  },
  {
    id: 'kitchen', name: 'Kitchen', polygon: box(438,282,592.9,405.8),
    summary: 'My proposed kitchen sits beside my dining area, with my pantry next door.',
    features: roomFeatures.kitchen.features,
    galleryId: 'kitchen', galleryLabel: 'Visit my Kitchen gallery'
  },
  {
    id: 'dining-room', name: 'Dining Room', polygon: box(300.9,282,438,405.8),
    summary: 'My dining area connects my kitchen and living room in this proposed first-floor plan.',
    features: ['I show my dining area beside my kitchen, facing my proposed deck.', 'I’m still gathering room-specific furniture and finish choices.']
  },
  {
    id: 'master-bedroom', name: 'Master Bedroom',
    polygon: region([[6.8,489.4],[231.5,489.4],[231.5,550],[187,550],[145,590],[145,640.8],[6.8,640.8]]),
    summary: 'My proposed master suite brings my bedroom, walk-in closet and master bath together.',
    features: ['I show my master bedroom beside my walk-in closet and master bath.', 'I’m still gathering bedroom-specific design choices.']
  },
  {
    id: 'master-bath', name: 'Master Bath', polygon: box(110,378,231.5,489.4),
    summary: 'My master bath sits within my proposed bedroom suite. I’m comparing vanity colors and planning personal comfort features.',
    features: roomFeatures['master-bath'].features,
    galleryId: 'master-bath', galleryLabel: 'Visit my Master Bath gallery'
  },
  {
    id: 'hall', name: 'Hall',
    polygon: region([[6.8,273.8],[300.9,273.8],[300.9,405.8],[231.5,405.8],[231.5,378],[110,378],[110,489.4],[6.8,489.4]]),
    summary: 'My hall connects the bedroom side of my proposed layout with my shared living spaces.',
    features: ['I show my hall between my bedrooms and living spaces.', 'I mark my narrow utility closet with a U on this plan.']
  },
  {
    id: 'bedroom-1', name: 'Bedroom 1', polygon: box(151,80.4,300.9,273.8),
    summary: 'I show Bedroom 1 beside Bedroom 2, with its own closet in my proposed first-floor layout.',
    features: ['I label this space Bedroom 1 on my plan.', 'I’m still gathering its furniture, lighting and finish choices.']
  },
  {
    id: 'bedroom-2', name: 'Bedroom 2', polygon: box(6.8,80.4,151,273.8),
    summary: 'I show Bedroom 2 beside Bedroom 1, with its own closet in my proposed first-floor layout.',
    features: ['I label this space Bedroom 2 on my plan.', 'I’m still gathering its furniture, lighting and finish choices.']
  },
  {
    id: 'open-deck', name: 'Open Deck', polygon: box(230.5,405.8,594.4,549.8),
    summary: 'My proposed open deck spans the space between my rear return walls.',
    features: ['I’m proposing a deck extending 12 feet from my rear wall.', 'I show my deck boards parallel to the left return wall in this plan.', ...roomFeatures['back-deck'].features],
    galleryId: 'back-deck', galleryLabel: 'Visit my Back Deck gallery'
  },
  {
    id: 'pantry', name: 'Pantry', polygon: box(592.9,304.24,742.36,405.79),
    summary: 'My proposed pantry sits beside my kitchen and above the existing garage in this drawing.',
    features: ['I show my pantry as a separate labeled space next to my kitchen.', 'I’m still gathering storage and finish details for this space.']
  },
  {
    id: 'laundry', name: 'Laundry',
    polygon: region([[594.4,405.8],[705.7,405.8],[705.7,443.4],[633.4,525.2],[594.4,525.2]]),
    summary: 'My laundry occupies the smaller room beside my proposed new garage and deck.',
    features: ['I label this space Laundry in my proposed layout.', 'I’m still confirming my laundry equipment and storage choices.']
  },
  {
    id: 'existing-garage', name: 'Existing Garage', polygon: box(592.9,103.58,742.36,304.24),
    summary: 'I distinguish my existing garage from the proposed new garage in this plan.',
    features: ['I show my existing garage beside my living room and below my pantry in this drawing.', 'I’m also exploring garage-door design concepts in a separate gallery.'],
    galleryId: 'garage-barn-door', galleryLabel: 'Explore my garage-door concepts'
  },
  {
    id: 'new-garage', name: 'New Garage',
    polygon: region([[475.4,702.2],[584.5,797],[742.4,615.4],[742.4,405.8],[705.7,405.8],[705.7,443.4],[633.4,525.2],[594.4,525.2],[594.4,565.9]]),
    summary: 'My proposed new garage is the angled space beyond my laundry and deck.',
    features: ['I show a proposed 16-foot door on the right wall of my new garage.', 'I’m exploring garage-door concepts separately; my presentation plan does not confirm their hardware or fit.'],
    galleryId: 'garage-barn-door', galleryLabel: 'Explore my garage-door concepts'
  },
  {
    id: 'walk-in-closet', name: 'Walk-in Closet',
    polygon: region([[145,640.8],[231.5,640.8],[231.5,550],[187,550],[145,590]]),
    summary: 'My walk-in closet forms part of my proposed master suite.',
    features: ['I show my walk-in closet beside my master bedroom.', 'I’m still gathering its storage layout and finish choices.']
  },
  {
    id: 'bedroom-1-closet', name: 'Bedroom 1 Closet', polygon: box(194,231,300.9,273.8),
    summary: 'I show this closet within Bedroom 1 in my proposed layout.',
    features: ['I label this space Closet on my plan.', 'I’m still gathering its storage details.']
  },
  {
    id: 'bedroom-2-closet', name: 'Bedroom 2 Closet', polygon: box(6.8,231,110,273.8),
    summary: 'I show this closet within Bedroom 2 in my proposed layout.',
    features: ['I label this space Closet on my plan.', 'I’m still gathering its storage details.']
  },
  {
    id: 'utility-closet', name: 'Utility Closet', polygon: box(151,341,171,374),
    summary: 'I mark my utility closet with a U because it is narrow in this presentation drawing.',
    features: ['I show my utility closet beside my hall.', 'I have not identified its equipment on this simplified plan.']
  }
];
