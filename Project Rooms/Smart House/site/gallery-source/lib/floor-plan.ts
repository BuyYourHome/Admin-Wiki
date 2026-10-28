import { roomFeatures } from './features.js';

export const PLAN_WIDTH = 1190;
export const PLAN_HEIGHT = 1030;

export type FloorPlanRoom = {
  id: string;
  name: string;
  polygon: string;
  summary: string;
  features: string[];
  galleryId?: string;
};

// Navigation regions follow the supplied first-floor presentation drawing.
// The living/dining/kitchen zones share an open space; these are not new walls.
// Native CAD inches -> PDF points -> the v9 drawing-only crop (140,245,1330,1275).
function region(points: [number, number][]) {
  return points.map(([x, y]) => `${(24 + x * 1.37).toFixed(2)},${(1116 - y * 1.37).toFixed(2)}`).join(' ');
}
function box(x1: number, y1: number, x2: number, y2: number) {
  return region([[x1,y1],[x2,y1],[x2,y2],[x1,y2]]);
}

export const floorPlanRooms: FloorPlanRoom[] = [
  {
    id: 'living-room', name: 'Living Room', polygon: box(300.9,106.5,592.9,282),
    summary: 'My living room will share an open space with my dining area and kitchen, as shown in my planned layout.',
    features: roomFeatures['media-center'].features,
    galleryId: 'media-center'
  },
  {
    id: 'kitchen', name: 'Kitchen', polygon: box(438,282,592.9,405.8),
    summary: 'My kitchen will sit beside my dining area, with my pantry next door, as shown in my planned layout.',
    features: roomFeatures.kitchen.features,
    galleryId: 'kitchen'
  },
  {
    id: 'dining-room', name: 'Dining Room', polygon: box(300.9,282,438,405.8),
    summary: 'My dining area will connect my kitchen and living room, as shown in my first-floor plan.',
    features: ['My dining area will sit beside my kitchen and face my future deck.', 'I will add my dining furniture and finish selections here.']
  },
  {
    id: 'master-bedroom', name: 'Master Bedroom',
    polygon: region([[6.8,489.4],[231.5,489.4],[231.5,550],[187,550],[145,590],[145,640.8],[6.8,640.8]]),
    summary: 'My master suite will bring my bedroom, walk-in closet and master bath together, as shown in my planned layout.',
    features: ['My master bedroom will sit beside my walk-in closet and master bath.', 'I will add my bedroom design selections here.']
  },
  {
    id: 'master-bath', name: 'Master Bath', polygon: box(110,378,231.5,489.4),
    summary: 'My master bath will be part of my bedroom suite, with my vanity layout and personal comfort features described below.',
    features: roomFeatures['master-bath'].features,
    galleryId: 'master-bath'
  },
  {
    id: 'hall', name: 'Hall',
    polygon: region([[6.8,273.8],[300.9,273.8],[300.9,309.54],[203.42,309.54],[203.42,331.80],[230.12,358.50],[230.12,378],[110,378],[110,489.4],[6.8,489.4],[6.8,483],[70,483],[70,402],[6.8,402]]),
    summary: 'My hall will connect my bedrooms with my shared living spaces, as shown in my planned layout.',
    features: ['I show my hall between my bedrooms and living spaces.', 'I mark my narrow utility closet with a U on this plan.']
  },
  {
    id: 'hall-bath', name: 'Hall Bath',
    polygon: region([[203.42,314.04],[296.92,314.04],[296.92,405.29],[237.16,405.29],[237.16,373.66],[230.12,373.66],[230.12,358.50],[203.42,331.80]]),
    summary: 'My Hall Bath will sit beside my hall and dining area, as shown in my planned layout.',
    features: roomFeatures['hall-bath'].features,
    galleryId: 'hall-bath'
  },
  {
    id: 'spiral-stair', name: 'Spiral Stair', polygon: box(7,402,70,483),
    summary: 'My spiral stair will sit beside my hall, as shown in my first-floor plan.',
    features: ['I show my stair and its shape in my plan.', 'I will feature my Home Theatre stair concepts here; their final connections, clearances and construction details still need confirmation.'],
    galleryId: 'spiral-staircase'
  },
  {
    id: 'bedroom-1', name: 'Bedroom 1', polygon: box(151,80.4,300.9,273.8),
    summary: 'I show Bedroom 1 beside Bedroom 2, with its own closet in my first-floor layout.',
    features: ['I label this space Bedroom 1 on my plan.', 'I will add its furniture, lighting and finish selections here.']
  },
  {
    id: 'bedroom-2', name: 'Bedroom 2', polygon: box(6.8,80.4,151,273.8),
    summary: 'I show Bedroom 2 beside Bedroom 1, with its own closet in my first-floor layout.',
    features: ['I label this space Bedroom 2 on my plan.', 'I will add its furniture, lighting and finish selections here.']
  },
  {
    id: 'open-deck', name: 'Open Deck', polygon: box(230.5420004593157,412.2386944702037,594.8641685495109,556.2386944702037),
    summary: 'My open deck will span the space between my rear return walls, as shown in my planned layout.',
    features: ['My future deck will extend 12 feet from the exterior face of my rear wall.', 'My deck boards will run parallel to my left return wall.', ...roomFeatures['back-deck'].features],
    galleryId: 'back-deck'
  },
  {
    id: 'pantry', name: 'Pantry', polygon: box(592.9,304.24,742.36,405.79),
    summary: 'My pantry will sit beside my kitchen and above my existing garage in this layout drawing.',
    features: ['I show my pantry as a separate labeled space next to my kitchen.', 'I will add my pantry storage and finish selections here.']
  },
  {
    id: 'laundry', name: 'Laundry',
    polygon: region([[594.4,405.8],[705.7,405.8],[705.7,443.4],[633.4,525.2],[594.4,525.2]]),
    summary: 'My laundry will occupy the smaller room beside my new garage and deck, as shown in my planned layout.',
    features: ['I label this space Laundry in my layout.', 'I will add my laundry equipment and storage selections here.']
  },
  {
    id: 'existing-garage', name: 'Existing Garage', polygon: box(592.9,103.58,742.36,304.24),
    summary: 'I distinguish my existing garage from my planned new garage in this plan.',
    features: ['I show my existing garage beside my living room and below my pantry in this drawing.', 'I will feature my garage-door concepts here; their hardware and fit still need confirmation.'],
    galleryId: 'garage-barn-door'
  },
  {
    id: 'new-garage', name: 'New Garage',
    polygon: region([[475.4,702.2],[584.5,797],[742.4,615.4],[742.4,405.8],[705.7,405.8],[705.7,443.4],[633.4,525.2],[594.4,525.2],[594.4,565.9]]),
    summary: 'My new garage will occupy the angled space beyond my laundry and deck, as shown in my planned layout.',
    features: ['My new garage will have a 16-foot door on its right wall.', 'I will feature my garage-door concepts here; my presentation plan does not confirm their hardware or fit.'],
    galleryId: 'garage-barn-door'
  },
  {
    id: 'walk-in-closet', name: 'Walk-in Closet',
    polygon: region([[145,640.8],[231.5,640.8],[231.5,550],[187,550],[145,590]]),
    summary: 'My walk-in closet will be part of my master suite, as shown in my planned layout.',
    features: ['My walk-in closet will sit beside my master bedroom.', 'I will add its storage layout and finish selections here.']
  },
  {
    id: 'bedroom-1-closet', name: 'Bedroom 1 Closet', polygon: box(194,231,300.9,273.8),
    summary: 'I show this closet within Bedroom 1 in my layout.',
    features: ['I label this space Closet on my plan.', 'I will add its storage details here.']
  },
  {
    id: 'bedroom-2-closet', name: 'Bedroom 2 Closet', polygon: box(6.8,231,110,273.8),
    summary: 'I show this closet within Bedroom 2 in my layout.',
    features: ['I label this space Closet on my plan.', 'I will add its storage details here.']
  },
  {
    id: 'utility-closet', name: 'Utility Closet', polygon: box(151,341,171,374),
    summary: 'I mark my utility closet with a U because it is narrow in this presentation drawing.',
    features: ['I show my utility closet beside my hall.', 'I have not identified its equipment on this simplified plan.']
  }
];
