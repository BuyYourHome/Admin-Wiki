import assert from 'node:assert/strict';
import { answerPondster } from '../lib/pondster-guide.ts';
import { parsePondsterDestination, getPondsterDestinationId } from '../lib/pondster-destinations.ts';
import { getPondsterSpeechText } from '../lib/pondster-speech.ts';
import { buildPondsterLiveSession } from '../lib/pondster-live-context.ts';
import { floorPlanCameras } from '../lib/floor-plan-cameras.ts';
import { galleries } from '../lib/designs.ts';

const requests = [
  ['Show camera 1', 'camera-1'], ['Show me the front gable camera', 'camera-1'],
  ['Open camera two', 'camera-2'], ['Show the barn door camera', 'camera-2'],
  ['Pondster, show camera 3', 'camera-3'], ['Show the deck camera', 'camera-3'],
  ['Play camera3 video', 'camera-3'], ['Where is the back deck camera?', 'camera-3'],
  ['Show the fourth camera', 'camera-4'], ['Show the west side camera', 'camera-4'],
  ['Show the west wall camera view', 'camera-4'], ['Please show cam4', 'camera-4'],
];
for (const [question, room] of requests) {
  const camera = floorPlanCameras.find(item => item.id === room);
  const reply = answerPondster(question);
  const expected = { menu: 'Explore', section: 'floor-plan', room };
  assert.deepEqual(reply.action, expected, question);
  assert.deepEqual(parsePondsterDestination(reply.action), expected);
  assert.equal(getPondsterDestinationId(reply.action), 'pondster-explore-floor-plan');
  assert.ok(reply.text.includes(camera.name) && reply.text.includes(camera.summary), question);
  assert.match(reply.text, /concept simulation.*does not confirm installed equipment, accurate optical coverage or a live connection/);
  assert.equal(getPondsterSpeechText(question, reply), `Here’s my Camera ${camera.number} — ${camera.name} concept view.`);
  assert.equal(getPondsterSpeechText('Read the camera description aloud', reply), reply.text);
}
for (const camera of floorPlanCameras) {
  for (const destination of [
    { menu: 'Design', room: camera.id },
    { menu: 'Explore', section: 'room', room: camera.id },
    { menu: 'Own', section: 'cameras', room: camera.id },
  ]) assert.equal(parsePondsterDestination(destination), null, JSON.stringify(destination));
}
assert.equal(parsePondsterDestination({ menu: 'Explore', section: 'floor-plan', room: 'camera-5' }), null);
assert.deepEqual(answerPondster('Show my camera plan').action, { menu: 'Explore', section: 'floor-plan' });
for (const question of ['Show cameras', 'Show camera manuals', 'Show camera 3 manual', 'Show the deck camera spec sheet', 'Show camera3 specifications']) {
  assert.deepEqual(answerPondster(question).action, { menu: 'Own', section: 'cameras' }, question);
}
assert.deepEqual(answerPondster('Show cameras and the A/V spec sheet').action, { menu: 'Own', section: 'maintenance' });
for (const question of ['Show me the back deck', 'Show me the back deck gallery']) {
  assert.equal(answerPondster(question).action?.menu, 'Design', question);
  assert.equal(answerPondster(question).action?.room, 'back-deck', question);
}
assert.deepEqual(answerPondster('Show exterior camera features').action, { menu: 'Explore', section: 'exterior-awareness' });
for (const question of [
  'Show camera 0', 'Show camera 5', 'Show camera eleven', 'Show the fifth camera',
  'Show the backyard camera view', 'Show camera 3 from the bedroom',
  'Do not show camera 3', 'Can you not show camera 3?', 'Show "camera 3"',
  'Show camera 3 and camera 4', 'Show camera 3 and enable recording',
  'Show camera 3 increase volume', 'Show camera 3 then open the A/V specs',
  'Show my installed camera 3', 'Show camera 3 wiring', 'Show camera 3 settings',
]) {
  assert.notEqual(answerPondster(question).action?.section, 'floor-plan', question);
}
for (const question of ['Show camera 3 live', 'Show live camera 3', 'Show footage from camera 3', 'Show camera 3 stream', 'Show camera 3 password']) {
  const reply = answerPondster(question);
  assert.deepEqual(reply.action, { menu: 'Own' }, question);
  assert.match(reply.text, /cannot provide private records/);
}
for (const question of ['Show camera 3 street address', 'Give camera 3 coordinates']) {
  const reply = answerPondster(question);
  assert.deepEqual(reply.action, { menu: 'Design', section: 'overview' }, question);
  assert.match(reply.text, /Cary, North Carolina.*exact street address.*private/);
}

const { instructions } = buildPondsterLiveSession(galleries);
const cameraFacts = instructions.split('\n').filter(line => line.startsWith('Concept camera — '));
assert.deepEqual(cameraFacts, floorPlanCameras.map(camera => `Concept camera — Camera ${camera.number} — ${camera.name}: ${camera.summary} My ${camera.durationSeconds}-second virtual video is ${camera.video}.`));
assert.match(instructions, /Camera 1 and Camera 4 videos use earlier perspectives.*concept simulations, not an exact match to the plan, measured optical coverage, installed equipment or live feeds/);
assert.match(instructions, /A numbered or named camera view takes precedence over my equipment card/);
assert.match(instructions, /camera manual or manufacturer-specification requests still reveal the Belong camera card/);
assert.match(instructions, /Show me the back deck gallery.*Design Back Deck gallery/);
for (const camera of floorPlanCameras) {
  assert.ok(instructions.includes(camera.video));
  assert.ok(!instructions.includes(camera.sectorPath));
  assert.ok(!instructions.includes(camera.markerPoints));
}
assert.doesNotMatch(instructions, /908|Pond Street|C:\\|\.codex|Wiki Files/);
console.log('PASS: four camera concepts resolve through validated floor-plan targets and brief speech; equipment/gallery precedence, unknown/private/live boundaries and summary-only public knowledge remain intact.');
