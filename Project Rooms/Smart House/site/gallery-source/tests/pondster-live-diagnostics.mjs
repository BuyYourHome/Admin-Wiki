import assert from 'node:assert/strict';
import { checkVoiceProvider, providerFailureMessage, safeNetworkCode, safeProviderFailure, VoiceProviderFailure, voiceProviderStatus } from '../worker/pondster-live-diagnostics.ts';

// Every request in this suite is mocked. A real fetch must never be a fallback.
const originalFetch = globalThis.fetch;
const originalWarn = console.warn;
const originalNow = Date.now;
const warnings = [];
const requests = [];
const CANARY = 'sk-proj-TEST-ONLY-SECRET-CANARY-DO-NOT-LOG';
const canaryMessage = `Incorrect API key provided: ${CANARY}; private upstream detail`;
globalThis.fetch = async () => { throw new Error('Unexpected network attempt in diagnostic test'); };
console.warn = (...items) => warnings.push(items);
const errorResponse = (status, code, extra = {}) => new Response(JSON.stringify({ error: { code, message: canaryMessage, ...extra } }), {
  status, headers: { 'x-request-id': 'req_mock_safe_123', 'Content-Type': 'application/json' }
});
const fakeFetch = (response) => async (url, options) => {
  requests.push({ url, options });
  assert.equal(url, 'https://api.openai.com/v1/models/gpt-live-1');
  assert.ok(!options.method || options.method === 'GET', 'Only metadata GET is permitted');
  assert.equal(options.headers.Authorization, `Bearer ${CANARY}`);
  assert.equal(options.redirect, 'manual');
  assert.ok(options.signal instanceof AbortSignal);
  return response;
};
const checkError = async (status, code, state) => {
  const result = await checkVoiceProvider(`  ${CANARY}\n`, fakeFetch(errorResponse(status, code)));
  assert.deepEqual(result, { state, httpStatus: status, code });
  assert.ok(!JSON.stringify(result).includes(CANARY));
  return result;
};
const base = (cookie = 'visitor-a') => new Response('{"available":true}', { headers: {
  'Content-Type': 'application/json', 'Cache-Control': 'no-store, private', Vary: 'Cookie',
  'Set-Cookie': `pondster_voice_visitor=${cookie}; Path=/; HttpOnly; SameSite=Strict; Secure`
} });

try {
  let invalidFetches = 0;
  const invalidCredentials = [`OPENAI_API_KEY=${CANARY}`, `${CANARY.slice(0, 12)}\n${CANARY.slice(12)}`, `${CANARY}\u03c0`, `"${CANARY}"`, 'sk-short'];
  const noInvalidFetch = async () => { invalidFetches++; throw new Error('Invalid credentials must not reach fetch'); };
  for (const credential of invalidCredentials) {
    const result = await checkVoiceProvider(credential, noInvalidFetch);
    assert.deepEqual(result, { state: 'configuration', httpStatus: null, code: 'invalid_credential_format' });
    assert.ok(!JSON.stringify(result).includes(CANARY));
  }
  globalThis.fetch = noInvalidFetch;
  const invalidPublic = await voiceProviderStatus(base(), `OPENAI_API_KEY=${CANARY}`);
  const invalidPublicText = await invalidPublic.text();
  assert.equal(JSON.parse(invalidPublicText).connectionCheck.state, 'configuration');
  assert.match(JSON.parse(invalidPublicText).message, /private API connection/);
  assert.ok(!invalidPublicText.includes(CANARY));
  assert.equal(invalidFetches, 0, 'Malformed wrappers, embedded newlines and Unicode never reach the network');

  assert.deepEqual(await checkVoiceProvider(` ${CANARY} `, fakeFetch(new Response('{"id":"gpt-live-1"}'))), {
    state: 'ready', httpStatus: 200, code: null
  });
  const warningsBeforeCleanup = warnings.length;
  assert.deepEqual(await checkVoiceProvider(CANARY, fakeFetch({ ok: true, status: 200, body: { async cancel() { throw new Error(canaryMessage); } } })), {
    state: 'ready', httpStatus: 200, code: null
  });
  assert.equal(warnings.length, warningsBeforeCleanup, 'Successful metadata does not become a network failure when unused-body cleanup rejects');

  const unknownToken = 'sk-UNKNOWN-SECRET-ALSO-REDACT';
  const bearerToken = 'opaque-BEARER-SECRET';

  await checkError(401, 'invalid_api_key', 'authentication');
  assert.match(providerFailureMessage(401, 'invalid_api_key'), /private API connection/);
  await checkError(403, 'permission_denied', 'access');
  await checkError(404, 'model_not_found', 'access');
  assert.match(providerFailureMessage(403, 'permission_denied'), /access to its voice model/);

  const quotaCodes = ['insufficient_quota', 'credit_balance_exhausted', 'billing_hard_limit_reached', 'monthly_spend_limit_exceeded',
    'organization_spend_limit_exceeded', 'project_spend_limit_exceeded', 'organization_usage_limit_exceeded'];
  for (const code of quotaCodes) {
    await checkError(429, code, 'quota');
    assert.match(providerFailureMessage(429, code), /billing or usage allowance/);
  }
  await checkError(429, 'rate_limit_exceeded', 'rate_limit');
  assert.match(providerFailureMessage(429, 'rate_limit_exceeded'), /service is busy/);

  const redirectResponse = () => new Response(JSON.stringify({ error: { code: 'unexpected_redirect', message: canaryMessage } }), {
    status: 302, headers: { Location: `https://external.invalid/${CANARY}/private-location-marker` }
  });
  const requestsBeforeRedirect = requests.length;
  assert.deepEqual(await checkVoiceProvider(CANARY, fakeFetch(redirectResponse())), { state: 'provider_error', httpStatus: 302, code: null });
  assert.equal(requests.length, requestsBeforeRedirect + 1, 'A redirect is explicitly rejected without a follow-up request');

  const malformed = await checkVoiceProvider(CANARY, fakeFetch(new Response(`not-json ${CANARY}`, { status: 502 })));
  assert.deepEqual(malformed, { state: 'provider_error', httpStatus: 502, code: null });
  const unknown = await checkVoiceProvider(CANARY, fakeFetch(errorResponse(500, CANARY, { type: CANARY })));
  assert.deepEqual(unknown, { state: 'provider_error', httpStatus: 500, code: null });
  assert.equal(await safeProviderFailure(errorResponse(400, null, { type: 'invalid_request_error' }), 'create-http'), 'invalid_request_error');

  let cancelled = false;
  const oversized = new ReadableStream({
    start(controller) { controller.enqueue(new TextEncoder().encode(JSON.stringify({ error: { code: 'invalid_api_key', message: CANARY.repeat(200) } }))); },
    cancel() { cancelled = true; }
  });
  assert.equal(await safeProviderFailure(new Response(oversized, { status: 401, headers: { 'x-request-id': CANARY } }), 'create-http'), null);
  assert.equal(cancelled, true, 'Oversized upstream bodies are canceled without retaining a parsed payload');
  const lastLog = JSON.parse(warnings.at(-1)[1]);
  assert.equal(lastLog.requestId, null, 'An unexpected request-ID value is not echoed');

  const failure = new VoiceProviderFailure(401, 'invalid_api_key');
  assert.equal(failure.name, 'VoiceProviderFailure');
  assert.match(failure.message, /private API connection/);
  assert.ok(!failure.message.includes(CANARY));

  const network = await checkVoiceProvider(CANARY, async () => { throw new Error(canaryMessage); });
  assert.deepEqual(network, { state: 'network', httpStatus: null, code: 'transport_failure' });
  const postResponseFailure = await checkVoiceProvider(CANARY, fakeFetch({ ok: false, status: 502, get body() { throw new Error(canaryMessage); } }));
  assert.deepEqual(postResponseFailure, { state: 'provider_error', httpStatus: 502, code: 'transport_failure' });
  const networkCases = [
    [new TypeError(`Invalid header character ${CANARY}`), 'invalid_auth_header'],
    [new Error(canaryMessage, { cause: { code: 'ERR_INVALID_CHAR', detail: CANARY } }), 'invalid_auth_header'],
    [new Error(`Cannot perform I/O on behalf of a different request ${CANARY}`), 'request_context_failure'],
    [new Error(`Unsupported cache option ${CANARY}`), 'unsupported_fetch_option'],
    [new Error(`Outbound network denied ${CANARY}`), 'outbound_blocked'],
    [new Error(canaryMessage, { cause: { code: 'ENOTFOUND', detail: CANARY } }), 'dns_failure'],
    [new Error(canaryMessage, { cause: { code: 'EAI_AGAIN', detail: CANARY } }), 'dns_failure'],
    [new Error(canaryMessage, { cause: { code: 'CERT_HAS_EXPIRED', detail: CANARY } }), 'tls_failure'],
    [new Error(canaryMessage, { cause: { code: 'UNABLE_TO_VERIFY_LEAF_SIGNATURE', detail: CANARY } }), 'tls_failure'],
    [new Error(canaryMessage, { cause: { code: 'DEPTH_ZERO_SELF_SIGNED_CERT', detail: CANARY } }), 'tls_failure']
  ];
  for (const [error, code] of networkCases) {
    assert.equal(safeNetworkCode(error), code);
    const result = await checkVoiceProvider(CANARY, async () => { throw error; });
    assert.deepEqual(result, { state: 'network', httpStatus: null, code });
    assert.ok(!JSON.stringify(result).includes(CANARY));
  }
  assert.equal(safeNetworkCode(new Error(`Invalid header ${CANARY}`), true), 'network_timeout');
  assert.equal(safeNetworkCode(CANARY), 'transport_failure');
  const originalSetTimeout = globalThis.setTimeout, originalClearTimeout = globalThis.clearTimeout;
  let timeoutCallback, timeoutCleared = false;
  try {
    globalThis.setTimeout = (callback, ms) => { assert.equal(ms, 5000); timeoutCallback = callback; return 123; };
    globalThis.clearTimeout = timer => { assert.equal(timer, 123); timeoutCleared = true; };
    const pending = checkVoiceProvider(CANARY, async (_url, options) => new Promise((_resolve, reject) => {
      options.signal.addEventListener('abort', () => reject(new Error(canaryMessage)), { once: true });
    }));
    timeoutCallback();
    assert.deepEqual(await pending, { state: 'network', httpStatus: null, code: 'network_timeout' });
    assert.equal(timeoutCleared, true);
  } finally {
    globalThis.setTimeout = originalSetTimeout;
    globalThis.clearTimeout = originalClearTimeout;
  }

  // Concurrent requests share one metadata GET for 60s, without sharing visitors' cookies.
  let now = 1_800_000_000_000, calls = 0;
  Date.now = () => now;
  globalThis.fetch = async (url, options) => { calls++; return fakeFetch(new Response('{}'))(url, options); };
  const [first, second] = await Promise.all([voiceProviderStatus(base('a'), ` ${CANARY} `), voiceProviderStatus(base('b'), CANARY)]);
  assert.equal(calls, 1);
  assert.deepEqual(await first.json(), { available: true, connectionCheck: { state: 'ready', httpStatus: 200, code: null } });
  assert.match(first.headers.get('set-cookie'), /voice_visitor=a;/);
  assert.match(second.headers.get('set-cookie'), /voice_visitor=b/);
  assert.equal(first.headers.get('cache-control'), 'no-store, private');
  assert.equal(first.headers.get('vary'), 'Cookie');
  now += 60_001;
  const refreshed = await voiceProviderStatus(base(), CANARY);
  assert.equal(calls, 2, 'Expired metadata checks are fetched again');
  await refreshed.body.cancel();

  // A public failure exposes only the fixed message and whitelisted metadata, never upstream text.
  globalThis.fetch = async (url, options) => {
    calls++;
    assert.equal(url, 'https://api.openai.com/v1/models/gpt-live-1');
    assert.equal(options.headers.Authorization, `Bearer ${CANARY}-different-cache-key`);
    return errorResponse(401, 'invalid_api_key');
  };
  const rejected = await voiceProviderStatus(base(), `${CANARY}-different-cache-key`);
  const publicText = await rejected.text();
  assert.deepEqual(JSON.parse(publicText), { available: false, connectionCheck: { state: 'authentication', httpStatus: 401, code: 'invalid_api_key' }, message: providerFailureMessage(401, 'invalid_api_key') });
  assert.ok(!publicText.includes(CANARY));
  assert.ok(!publicText.includes('private upstream detail'));
  let redirectFetches = 0;
  globalThis.fetch = async (url, options) => {
    redirectFetches++;
    assert.equal(url, 'https://api.openai.com/v1/models/gpt-live-1');
    assert.equal(options.redirect, 'manual');
    return redirectResponse();
  };
  const redirectPublic = await voiceProviderStatus(base(), `${CANARY}-redirect-cache-key`);
  const redirectText = await redirectPublic.text();
  assert.deepEqual(JSON.parse(redirectText).connectionCheck, { state: 'provider_error', httpStatus: 302, code: null });
  assert.equal(redirectPublic.headers.get('location'), null);
  assert.equal(redirectFetches, 1);
  for (const secret of [CANARY, 'external.invalid', 'private-location-marker']) {
    assert.ok(!redirectText.includes(secret));
    assert.ok(!JSON.stringify(warnings).includes(secret));
  }
  globalThis.fetch = async () => { throw new TypeError(`${CANARY} Bearer ${bearerToken}; ${unknownToken} private-detail-marker`); };
  const transportPublic = await voiceProviderStatus(base(), `${CANARY}-transport-detail-cache-key`);
  const transportText = await transportPublic.text();
  const transportJson = JSON.parse(transportText);
  assert.deepEqual(Object.keys(transportJson).sort(), ['available', 'connectionCheck', 'message']);
  assert.deepEqual(Object.keys(transportJson.connectionCheck).sort(), ['code', 'httpStatus', 'state']);
  for (const secret of [CANARY, unknownToken, bearerToken, 'private-detail-marker']) assert.ok(!transportText.includes(secret));
  assert.ok(!JSON.stringify(warnings).includes(CANARY), 'No warning may contain the canary key, echoed body or transport exception');
  assert.ok(!JSON.stringify(warnings).includes(unknownToken));
  assert.ok(!JSON.stringify(warnings).includes(bearerToken));
  for (const [tag, fields] of warnings) {
    assert.equal(tag, 'pondster.voice.provider');
    const log = JSON.parse(fields);
    const expectedFields = log.requestId === undefined ? ['code', 'httpStatus', 'stage'] : ['code', 'httpStatus', 'requestId', 'stage'];
    assert.deepEqual(Object.keys(log).sort(), expectedFields);
    assert.ok(fields.length < 512);
  }
  assert.ok(requests.every(request => !request.url.includes('/live/sessions')));
  console.log('PASS: metadata-only readiness and cleanup; invalid credentials never fetch; fixed network labels only; no exception details or secret echo; auth/access/quota/rate classification; redirects rejected; malformed/oversized bodies; timeout; 60s cache and private headers (mocks only).');
} finally {
  globalThis.fetch = originalFetch;
  console.warn = originalWarn;
  Date.now = originalNow;
}
