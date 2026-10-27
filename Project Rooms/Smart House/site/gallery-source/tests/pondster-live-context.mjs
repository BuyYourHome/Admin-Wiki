import assert from 'node:assert/strict';
import { buildPondsterLiveSession, PONDSTER_LIVE_GREETING } from '../lib/pondster-live-context.ts';
import { galleries } from '../lib/designs.ts';

const session = buildPondsterLiveSession(galleries);
assert.equal(session.model, 'gpt-live-1');
assert.equal(session.audio.output.voice, 'vesper');
assert.equal(session.store, false);
assert.match(session.instructions, /Belong page offers my preliminary deck structural drawing at \/documents\/deck-structural-preliminary\.pdf/);
assert.match(session.instructions, /preliminary design reference, not approved construction plans/);
assert.deepEqual(session.delegation, { type: 'client' });
assert.deepEqual(session.input, [{ role: 'developer', content: [{ type: 'input_text', text: PONDSTER_LIVE_GREETING }] }]);
assert.match(PONDSTER_LIVE_GREETING, /Hello, I’m Pondster\. What would you like to know about me\?/);
assert.match(PONDSTER_LIVE_GREETING, /once.*pause and listen.*do not repeat/);
assert.deepEqual(session.client.data_channel.allowed_client_events, ['session.close']);
assert.ok(session.client.data_channel.allowed_server_events.every(event => typeof event.type === 'string'));
assert.ok(!session.client.data_channel.allowed_server_events.some(event => event.type === 'session.delegation.created'));
assert.match(session.instructions, /public voice and identity/);
assert.match(session.instructions, /Jean Wright is my SI designer/);
assert.match(session.instructions, /location is confidential/);
assert.match(session.instructions, /not Codex/);
assert.match(session.instructions, /No appointment is booked/);
assert.match(session.instructions, /cannot operate house devices/);
assert.match(session.instructions, /virtual design tour/);
assert.match(session.instructions, /complete explicit farewell.*website detects.*closes microphone, playback and the existing session/);
assert.match(session.instructions, /do not invent a close tool or protocol event/);
assert.match(session.instructions, /explicit navigation or tour request.*show me the virtual tour.*generate <\|SpawnThinking\|>.*start the existing tour/);
assert.match(session.instructions, /Do not claim that my virtual tour is unavailable/);
for(const fact of ['Glasgow Design Build is my general contractor, https://glasgowdb.com/',
  'True Service Inc. is my HVAC contractor, https://www.trueserviceinc.com/',
  'Executive Plumbing Company is my plumber, https://www.executiveplumbingcompany.com/'])assert.ok(session.instructions.includes(fact));
assert.match(session.instructions,/project roles come from Wes’s instruction, not an inference/);
assert.match(session.instructions, /ashley@elementrealtygroup\.net/);
assert.doesNotMatch(session.instructions, /908|Pond Street|26-BYH|C:\\|\.codex|Wiki Files|sk-[A-Za-z0-9]/);
for (const gallery of galleries) {
  assert.ok(session.instructions.includes(gallery.name));
  for (const design of gallery.designs) assert.ok(session.instructions.includes(design.title));
}
assert.deepEqual(buildPondsterLiveSession(galleries), session);
console.log('PASS: server-owned GPT-Live configuration, trusted answer channel, current public catalog, confidential location, planned-device boundaries, and no private source context.');
