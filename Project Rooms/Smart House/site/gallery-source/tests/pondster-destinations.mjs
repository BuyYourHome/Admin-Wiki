import assert from 'node:assert/strict';
import { DESTINATION_SECTIONS, GALLERY_ROOM_IDS, FLOOR_PLAN_ROOM_IDS, parsePondsterDestination, getPondsterDestinationId } from '../lib/pondster-destinations.ts';
import { galleries } from '../lib/designs.ts';
import { floorPlanRooms } from '../lib/floor-plan.ts';
assert.deepEqual([...GALLERY_ROOM_IDS].sort(),galleries.map(room=>room.id).sort());
assert.deepEqual([...FLOOR_PLAN_ROOM_IDS].sort(),floorPlanRooms.map(room=>room.id).sort());
for(const [menu,sections] of Object.entries(DESTINATION_SECTIONS))for(const section of sections) {
  const action={menu,section,...(menu==='Explore'&&section==='room'?{room:'kitchen'}:{})};
  assert.deepEqual(parsePondsterDestination(action),action);
  assert.match(getPondsterDestinationId(action),/^(?:design-gallery|pondster-[a-z0-9-]+)$/);
}
for(const room of GALLERY_ROOM_IDS) {
  assert.deepEqual(parsePondsterDestination({menu:'Design',room}),{menu:'Design',room});
  assert.equal(getPondsterDestinationId({menu:'Design',room}),'design-gallery');
  assert.equal(getPondsterDestinationId({menu:'Explore',section:'room',room}),'pondster-explore-room-'+room);
}
for(const room of FLOOR_PLAN_ROOM_IDS) {
  const action={menu:'Explore',section:'floor-plan',room};assert.deepEqual(parsePondsterDestination(action),action);
  assert.equal(getPondsterDestinationId(action),'pondster-explore-floor-plan');
}
for(const action of [{menu:'Contact'},{menu:'Own'},{menu:'View',tour:true},{menu:'Explore',scene:'evening'},{menu:'Built By'}])assert.deepEqual(parsePondsterDestination(action),action,'Legacy valid actions remain supported.');
assert.equal(getPondsterDestinationId({menu:'View',tour:true}),'pondster-view-tour');
assert.equal(getPondsterDestinationId({menu:'Explore',scene:'evening'}),'pondster-explore-lighting');
assert.equal(getPondsterDestinationId({menu:'Contact',section:'gc'}),'pondster-contact-gc');
assert.equal(getPondsterDestinationId({menu:'Built By',section:'contact'}),'pondster-built-by-contact');
for(const section of ['drawing','maintenance','cameras','audio']){
  assert.deepEqual(parsePondsterDestination({menu:'Own',section}),{menu:'Own',section});
  assert.equal(getPondsterDestinationId({menu:'Own',section}),'pondster-own-'+section,'Public documents and manuals use exact Belong card anchors.');
}
for(const value of [null,[],false,'Contact',{}, {menu:'Belong'},{menu:'Manage'},
  {menu:'Contact',section:'drawing'},{menu:'View',section:'gc'}, {menu:'Explore',section:'cameras'}, {menu:'Contact',section:'audio'}, {menu:'Own',section:'serials'}, {menu:'Own',section:'cameras',room:'kitchen'},
  {menu:'Contact',section:'#contact-gc'},{menu:'Explore',section:'https://example.test'},
  {menu:'Explore',section:'room'}, {menu:'Explore',section:'room',room:'pantry'},
  {menu:'Design',room:'pantry'},{menu:'Contact',room:'kitchen'},
  {menu:'Design',section:'overview',room:'kitchen'}, {menu:'Explore',section:'hot-water',room:'kitchen'},
  {menu:'Explore',room:'body'},{menu:'Explore',section:'floor-plan',room:'secret-room'},
  {menu:'View',scene:'evening'},{menu:'Explore',section:'presence',scene:'evening'}, {menu:'Explore',scene:'automatic'},
  {menu:'View',tour:false},{menu:'Contact',tour:true},{menu:'View',section:'ashley',tour:true},
])assert.equal(parsePondsterDestination(value),null,JSON.stringify(value));
assert.deepEqual(parsePondsterDestination({menu:'Contact',section:'gc',selector:'body',url:'https://example.test',command:'unlock'}),{menu:'Contact',section:'gc'},'Unrecognized payload fields never reach UI navigation.');
assert.equal(getPondsterDestinationId({menu:'Contact',section:'invalid'}),null);
console.log('PASS: shared public destination/menu/room/scene/tour allowlist; fixed anchors; legacy actions; no arbitrary selectors, URLs or commands.');
