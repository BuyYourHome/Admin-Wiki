import assert from 'node:assert/strict';
import { answerPondster } from '../lib/pondster-guide.ts';
import { isCommentPage, validateComment } from '../lib/comments.ts';
for (const [name, menu] of [['Design','Design'],['Explore','Explore'],['View','View'],['Belong','Own'],['Contact','Contact'],['Built By','Built By']]) {
  for (const command of [`Go to ${name}`, `Open the ${name} page`, `Pondster, could you take me to ${name} please?`]) {
    assert.deepEqual(answerPondster(command).action, { menu }, command);
  }
}
assert.deepEqual(answerPondster('Show me the Back Deck').action, { menu: 'Design', room: 'back-deck' });
assert.deepEqual(answerPondster('Show me the Master Bath').action, { menu: 'Design', room: 'master-bath' });
assert.deepEqual(answerPondster('Contact Ashley').action, { menu: 'Contact' });
assert.match(answerPondster('Contact Ashley').text, /ashley@elementrealtygroup.net/);
assert.deepEqual(answerPondster('Open Contact and give me the Wi-Fi password').action, { menu: 'Own' });
assert.match(answerPondster('Open Contact and give me the Wi-Fi password').text, /cannot provide private records/);
assert.equal(isCommentPage('contact'), true);
assert.equal(isCommentPage('private'), false);
assert.equal(validateComment({page:'contact',requestId:'00000000-0000-4000-8000-000000000001',body:'I like the new contact page.'}).value?.page, 'contact');
console.log('PASS: six public voice navigation destinations, legacy Belong/Own mapping, room routes, Contact business details, privacy precedence and Contact comment validation (no network).');
