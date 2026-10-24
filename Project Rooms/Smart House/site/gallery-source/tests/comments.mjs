import assert from 'node:assert/strict';
import { randomUUID } from 'node:crypto';
import { commentCursor, parseCommentCursor, validateComment } from '../lib/comments.ts';

const draft = (extra = {}) => ({ page: 'design', requestId: randomUUID(), body: 'A local preview test comment.', ...extra });
assert.equal(validateComment(draft()).value.name, 'Guest');
assert.equal(validateComment(draft({ name: '  Visitor  ', body: '  One\r\nTwo  ' })).value.body, 'One\nTwo');
assert.ok(validateComment(draft({ name: 'A'.repeat(60), body: 'a'.repeat(1000) })).value);
for (const input of [null, [], draft({ page: 'private' }), draft({ requestId: 'invalid' }), draft({ name: 'a'.repeat(61) }), draft({ name: 'a\nb' }), draft({ name: 123 }), draft({ body: '' }), draft({ body: ' \n ' }), draft({ body: 'x'.repeat(1001) }), draft({ body: '\u0000' }), draft({ body: 123 }), draft({ website: 'https://spam.invalid' })]) {
  assert.ok(validateComment(input).error);
}
const cursor = { id: 'a'.repeat(32), createdAt: 1792850000000 };
assert.deepEqual(parseCommentCursor(commentCursor(cursor)), cursor);
assert.equal(parseCommentCursor('NaN.aaaa'), null);
assert.equal(parseCommentCursor('9999999999999999.' + 'a'.repeat(32)), null);
console.log('PASS: comment validation, Guest default, length boundaries, honeypot, and cursor parsing.');

if (!process.argv[2]) {
  console.log('Pass a local preview URL to run persistence, isolation, idempotency, cooldown, and pagination checks.');
  process.exit(0);
}
const base = new URL(process.argv[2]);
if (!['127.0.0.1', 'localhost'].includes(base.hostname) || base.protocol !== 'http:') throw new Error('Write tests are restricted to an HTTP local preview.');
const browser = { cookie: '' };
async function call(method, body, { page = 'design', cursor, origin = base.origin, session = browser, contentType = 'application/json', raw } = {}) {
  const url = new URL('/api/comments', base);
  url.searchParams.set('page', page);
  if (cursor) url.searchParams.set('cursor', cursor);
  const response = await fetch(url, {
    method,
    headers: { ...(method === 'POST' ? { 'Content-Type': contentType, Origin: origin } : {}), ...(session?.cookie ? { Cookie: session.cookie } : {}) },
    ...(method === 'POST' ? { body: raw ?? JSON.stringify(body) } : {})
  });
  const cookie = response.headers.get('set-cookie');
  if (cookie && session) session.cookie = cookie.split(';')[0];
  const text = await response.text();
  let data;
  try { data = JSON.parse(text); }
  catch { throw new Error(`${method} ${url.pathname}${url.search} returned non-JSON HTTP ${response.status} (request length ${(raw ?? JSON.stringify(body) ?? '').length}): ${text.slice(0, 180)}`); }
  return { status: response.status, data, cookie, retryAfter: response.headers.get('retry-after') };
}

const initial = await call('GET');
assert.equal(initial.status, 200);
assert.match(browser.cookie, /^pond_comment_visitor=[a-f0-9]{32}$/);
assert.match(initial.cookie, /HttpOnly/i);
assert.match(initial.cookie, /SameSite=Lax/i);
assert.equal((await call('GET', null, { page: 'unknown' })).status, 400);
assert.equal((await call('GET', null, { cursor: 'invalid' })).status, 400);
assert.equal((await call('POST', draft(), { origin: 'https://unrelated.invalid' })).status, 403);
assert.equal((await call('POST', draft(), { contentType: 'text/plain' })).status, 415);
assert.equal((await call('POST', draft(), { raw: '{invalid' })).status, 400);
assert.equal((await call('POST', null, { raw: 'x'.repeat(8193) })).status, 413);
assert.equal((await call('POST', draft(), { session: null })).status, 409);
assert.equal((await call('POST', draft({ website: 'robot' }))).status, 400);
assert.equal((await call('POST', draft({ body: ' ' }))).status, 400);
assert.equal((await call('POST', draft({ body: 'x'.repeat(1001) }))).status, 400);
const payload = draft({ body: `<script>not executable ${randomUUID()}</script>` });
const first = await call('POST', payload);
assert.equal(first.status, 201);
assert.equal(first.data.comment.name, 'Guest');
assert.equal(first.data.comment.body, payload.body);
assert.deepEqual(Object.keys(first.data.comment).sort(), ['body', 'createdAt', 'id', 'name', 'page']);
const repeat = await call('POST', payload);
assert.equal(repeat.status, 200);
assert.deepEqual(repeat.data.comment, first.data.comment);
assert.equal((await call('POST', { ...payload, body: 'Changed retry' })).status, 409);
const cooldown = await call('POST', draft({ page: 'view' }));
assert.equal(cooldown.status, 429);
assert.equal(cooldown.retryAfter, '30');
const persisted = await call('GET');
assert.ok(persisted.data.comments.some(comment => comment.id === first.data.comment.id));
for (const page of ['explore', 'view', 'own', 'built-by']) {
  const isolated = await call('GET', null, { page });
  assert.equal(isolated.status, 200);
  assert.ok(isolated.data.comments.every(comment => comment.page === page));
  assert.ok(!isolated.data.comments.some(comment => comment.id === first.data.comment.id));
}

const other = { cookie: '' };
await call('GET', null, { session: other });
assert.notEqual(other.cookie, browser.cookie);
assert.equal((await call('POST', payload, { session: other })).status, 409);
const simultaneous = await Promise.all([call('POST', draft(), { session: other }), call('POST', draft(), { session: other })]);
assert.deepEqual(simultaneous.map(result => result.status).sort(), [201, 429]);

// Separate local visitor cookies fill one page without waiting out the per-browser cooldown.
const marker = randomUUID();
const posted = [];
for (let i = 0; i < 21; i++) {
  const session = { cookie: '' };
  await call('GET', null, { page: 'built-by', session });
  const result = await call('POST', draft({ page: 'built-by', name: 'Preview visitor', body: `${marker} ${i}` }), { session });
  assert.equal(result.status, 201);
  posted.push(result.data.comment.id);
}
const firstPage = await call('GET', null, { page: 'built-by' });
assert.equal(firstPage.data.comments.length, 20);
assert.ok(firstPage.data.nextCursor);
const secondPage = await call('GET', null, { page: 'built-by', cursor: firstPage.data.nextCursor });
assert.equal(secondPage.status, 200);
const both = [...firstPage.data.comments, ...secondPage.data.comments];
assert.equal(new Set(both.map(comment => comment.id)).size, both.length);
for (const id of posted) assert.ok(both.some(comment => comment.id === id));
for (let i = 1; i < both.length; i++) {
  const previous = both[i - 1], current = both[i];
  assert.ok(previous.createdAt > current.createdAt || (previous.createdAt === current.createdAt && previous.id > current.id));
}
assert.ok(both.every(comment => Object.keys(comment).sort().join(',') === 'body,createdAt,id,name,page'));
console.log('PASS: local-only durable comments, public field filtering, page isolation, literal text, origin/body checks, lost-response retry deduplication, concurrent cooldown, visitor isolation, and newest-first pagination.');
