import assert from 'node:assert/strict';
import { buildPondsterLiveSession } from '../lib/pondster-live-context.ts';
import { galleries } from '../lib/designs.ts';

const session = buildPondsterLiveSession(galleries);
assert.equal(session.model, 'gpt-live-1');
assert.equal(session.audio.output.voice, 'marin');
assert.equal(session.store, false);
assert.deepEqual(session.delegation, { type: 'client' });
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
assert.match(session.instructions, /ashley@elementrealtygroup\.net/);
assert.doesNotMatch(session.instructions, /908|Pond Street|26-BYH|C:\\|\.codex|Wiki Files|sk-[A-Za-z0-9]/);
for (const gallery of galleries) {
  assert.ok(session.instructions.includes(gallery.name));
  for (const design of gallery.designs) assert.ok(session.instructions.includes(design.title));
}
assert.deepEqual(buildPondsterLiveSession(galleries), session);
console.log('PASS: server-owned GPT-Live configuration, trusted answer channel, current public catalog, confidential location, planned-device boundaries, and no private source context.');
