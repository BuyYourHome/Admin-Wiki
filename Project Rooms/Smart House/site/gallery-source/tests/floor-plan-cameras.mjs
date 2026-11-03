import assert from 'node:assert/strict';
import { floorPlanRooms, PLAN_WIDTH, PLAN_HEIGHT } from '../lib/floor-plan.ts';
import { floorPlanCameras } from '../lib/floor-plan-cameras.ts';

// Independent registration check from the House Render v15 build pipeline:
// original PDF (1800 × 1350) -> source PNG (3000 × 2250) -> crop -> padding.
function sourcePoint([x, y]) {
  const pdfX = 164 + x * 1.37;
  const pdfTop = 1350 - (126 + (y - 100) * 1.37);
  return [pdfX * 3000 / 1800 - 105 + 130, pdfTop * 2250 / 1350 - 345 + 160];
}
function points(polygon) {
  return polygon.trim().split(/\s+/).map(pair => pair.split(',').map(Number));
}
function contains(polygon, [x, y]) {
  const vertices = points(polygon);
  let inside = false;
  for (let i = 0, j = vertices.length - 1; i < vertices.length; j = i++) {
    const [xi, yi] = vertices[i], [xj, yj] = vertices[j];
    if ((yi > y) !== (yj > y) && x < (xj - xi) * (y - yi) / (yj - yi) + xi) inside = !inside;
  }
  return inside;
}
function selectedRoom(point) {
  return [...floorPlanRooms].reverse().find(room => contains(room.polygon, point))?.id;
}
function near(actual, expected, description) {
  assert.ok(Math.abs(actual - expected) <= 0.011, `${description}: ${actual} differs from ${expected}`);
}

assert.equal(PLAN_WIDTH, 2340);
assert.equal(PLAN_HEIGHT, 2225);
assert.equal(floorPlanRooms.length, 19, 'The camera layer keeps all existing room targets.');
const expectedRoomIds = ['living-room', 'kitchen', 'dining-room', 'master-bedroom', 'master-bath', 'hall', 'hall-bath', 'spiral-stair', 'bedroom-1', 'bedroom-2', 'open-deck', 'pantry', 'laundry', 'existing-garage', 'new-garage', 'walk-in-closet', 'bedroom-1-closet', 'bedroom-2-closet', 'utility-closet'];
assert.deepEqual(floorPlanRooms.map(room => room.id), expectedRoomIds, 'Keep room identity and overlay ordering stable.');
const roomSamples = {
  'living-room': [446, 196], kitchen: [508, 344], 'dining-room': [360, 344],
  'master-bedroom': [98, 551], 'master-bath': [168, 451], hall: [60, 355],
  'hall-bath': [260, 350], 'spiral-stair': [43, 408],
  'bedroom-1': [225, 159], 'bedroom-2': [78, 159], 'open-deck': [412.5, 478],
  pantry: [669, 354], laundry: [641, 456], 'existing-garage': [669, 204],
  'new-garage': [634, 619], 'walk-in-closet': [185, 594],
  'bedroom-1-closet': [232, 253], 'bedroom-2-closet': [59, 251],
  'utility-closet': [159.6, 357]
};
assert.deepEqual(Object.keys(roomSamples).sort(), expectedRoomIds.slice().sort(), 'Every room gets an independent source-label or representative-center check.');
for (const room of floorPlanRooms) {
  const vertices = points(room.polygon);
  assert.ok(vertices.length >= 3 && vertices.every(([x, y]) => Number.isFinite(x) && Number.isFinite(y) && x >= 0 && y >= 0 && x <= PLAN_WIDTH && y <= PLAN_HEIGHT), `Keep ${room.id} inside the registered base image.`);
  const center = sourcePoint(roomSamples[room.id]);
  assert.ok(contains(room.polygon, center), `The source label/center stays inside ${room.id}.`);
  assert.equal(selectedRoom(center), room.id, `Overlays do not steal the ${room.id} label/center.`);
}

const deck = floorPlanRooms.find(room => room.id === 'open-deck');
const deckExpected = [[230.5420004593157, 412.2386944702037], [594.8641685495109, 412.2386944702037], [594.8641685495109, 517.86], [230.5420004593157, 517.86]].map(sourcePoint);
points(deck.polygon).forEach((point, index) => point.forEach((coordinate, axis) => near(coordinate, deckExpected[index][axis], 'v11 shortened deck registration')));
assert.equal(selectedRoom(sourcePoint([412.5, 540])), undefined, 'The superseded 12-foot deck strip is no longer a room target.');
assert.doesNotMatch(deck.features.join(' '), /12\s*(?:feet|foot|ft)/i, 'Do not repeat the superseded deck depth.');
assert.match(deck.features.join(' '), /dimensions.*confirmation/i, 'Keep the visual-concept measurement boundary.');

// Source facts from camera-geometry.json and camera-overlay.svg in House Render
// camera-plans/908-Pond-Camera-Views-v15-20261102, independent of app rendering.
const cameraFacts = [
  [1, 'Front gable', 954, 1930, 260, 22.5, 157.5, '954,1968 916,1900 992,1900'],
  [2, 'Barn door', 1985, 805, 270, -90, 90, '2023,805 1955,767 1955,843'],
  [3, 'Deck', 1435, 540, 520, 48, 228, '1401,568 1469,554 1441,498'],
  [4, 'West side', 313, 665, 260, 90, 270, '275,665 343,627 343,703']
];
assert.equal(floorPlanCameras.length, 4);
const allIds = [...floorPlanRooms, ...floorPlanCameras].map(target => target.id);
assert.equal(new Set(allIds).size, allIds.length, 'Camera IDs cannot collide with room IDs or each other.');
for (const [index, camera] of floorPlanCameras.entries()) {
  const [number, name, x, y, radius, start, end, marker] = cameraFacts[index];
  assert.deepEqual([camera.number, camera.name, camera.x, camera.y, camera.radius, camera.startDegrees, camera.endDegrees, camera.markerPoints], [number, name, x, y, radius, start, end, marker]);
  assert.equal(camera.id, `camera-${number}`);
  assert.equal(camera.video, `/media/camera-${number}-virtual.mp4`);
  assert.equal(camera.poster, `/media/camera-${number}-poster.jpg`);
  assert.equal(camera.durationSeconds, 6);
  assert.equal(camera.badgeOffsetX, 60);
  assert.equal(camera.badgeOffsetY, -54);
  assert.match(camera.summary, /^I /, 'Camera copy stays in Pondster’s voice.');
  assert.match(camera.summary, /concept|virtual|simulation/i);
  assert.match(camera.summary, /not.*live|does not.*live/i, 'A concept is never described as a live camera feed.');
  const path = camera.sectorPath.match(/^M ([\d.]+) ([\d.]+) L ([\d.]+) ([\d.]+) A ([\d.]+) ([\d.]+) 0 ([01]) 1 ([\d.]+) ([\d.]+) Z$/);
  assert.ok(path, `Camera ${number} has a closed SVG field sector.`);
  const [, mx, my, sx, sy, rx, ry, large, ex, ey] = path.map((value, item) => item ? Number(value) : value);
  assert.deepEqual([mx, my, rx, ry], [x, y, radius, radius]);
  const span = ((end - start) + 360) % 360;
  assert.equal(large, span > 180 ? 1 : 0);
  near(sx, x + radius * Math.cos(start * Math.PI / 180), 'source sector start X');
  near(sy, y + radius * Math.sin(start * Math.PI / 180), 'source sector start Y');
  near(ex, x + radius * Math.cos(end * Math.PI / 180), 'source sector end X');
  near(ey, y + radius * Math.sin(end * Math.PI / 180), 'source sector end Y');
  const samples = [[x, y], ...points(marker), [x + camera.badgeOffsetX, y + camera.badgeOffsetY]];
  for (let step = 0; step <= 100; step++) {
    const angle = (start + span * step / 100) * Math.PI / 180;
    samples.push([x + radius * Math.cos(angle), y + radius * Math.sin(angle)]);
  }
  assert.ok(samples.every(([px, py]) => px >= 0 && py >= 0 && px <= PLAN_WIDTH && py <= PLAN_HEIGHT), `Camera ${number}'s complete arc, marker and badge stay on the new canvas.`);
}
assert.equal(floorPlanCameras[0].y > sourcePoint([300.9, 106.5])[1], true, 'Camera 1 is mounted outside the front facade.');
assert.equal(floorPlanCameras[2].endDegrees - floorPlanCameras[2].startDegrees, 180, 'Camera 3 retains its wall-aligned semicircle.');
console.log('PASS: 19 registered source-label room targets, bounds and overlay priority; v11 shortened deck; four source-matched camera arcs/markers, media IDs and complete field bounds.');
