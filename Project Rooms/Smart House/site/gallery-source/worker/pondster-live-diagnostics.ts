// A metadata GET checks authentication without creating a billable voice session.
// Never retain or log upstream bodies, SDP, audio, headers, or credential values.
const QUOTA_CODES = ['insufficient_quota', 'credit_balance_exhausted', 'billing_hard_limit_reached', 'monthly_spend_limit_exceeded', 'organization_spend_limit_exceeded', 'project_spend_limit_exceeded', 'organization_usage_limit_exceeded'];
const CODES = new Set(['invalid_api_key', 'invalid_request_error', 'authentication_error', 'permission_denied', 'model_not_found', 'rate_limit_exceeded', 'unsupported_country_region_territory', ...QUOTA_CODES]);
type CheckState = 'ready' | 'configuration' | 'authentication' | 'access' | 'quota' | 'rate_limit' | 'network' | 'provider_error';
export type ProviderCheck = { state: CheckState; httpStatus: number | null; code: string | null };
let cached: { key: string; until: number; result: Promise<ProviderCheck> } | null = null;

export class VoiceProviderFailure extends Error {
  readonly stage: 'create-http' | 'attach-http';
  readonly httpStatus: number;
  constructor(stage: 'create-http' | 'attach-http', status: number, code: string | null) {
    super(providerFailureMessage(status, code)); this.name = 'VoiceProviderFailure';
    this.stage = stage; this.httpStatus = status;
  }
  isDefinitiveCreateRejection() {
    return this.stage === 'create-http' && [400, 401, 403, 404, 422, 429].includes(this.httpStatus);
  }
}

export async function safeProviderFailure(response: Response, stage: 'model-access' | 'create-http' | 'attach-http') {
  let code: string | null = null;
  const reader = response.body?.getReader();
  try {
    const chunks: Uint8Array[] = []; let bytes = 0;
    if (reader) while (bytes <= 8192) {
      const item = await reader.read(); if (item.done) break;
      bytes += item.value.byteLength; if (bytes > 8192) break;
      chunks.push(item.value);
    }
    if (bytes <= 8192) {
      const buffer = new Uint8Array(bytes); let offset = 0;
      for (const chunk of chunks) { buffer.set(chunk, offset); offset += chunk.byteLength; }
      const payload = JSON.parse(new TextDecoder().decode(buffer)) as { error?: { code?: unknown; type?: unknown } };
      const candidate = typeof payload.error?.code === 'string' ? payload.error.code : payload.error?.type;
      if (typeof candidate === 'string' && CODES.has(candidate)) code = candidate;
    }
  } catch { /* Only allowlisted diagnostic fields may leave this function. */ }
  finally { try { await reader?.cancel(); } catch { /* Already consumed. */ } }
  const requestId = response.headers.get('x-request-id');
  console.warn('pondster.voice.provider', JSON.stringify({ stage, httpStatus: response.status, code,
    requestId: requestId && /^req_[A-Za-z0-9_-]{1,120}$/.test(requestId) ? requestId : null }));
  return code;
}

export function providerFailureMessage(status: number, code: string | null) {
  if (status === 401 || code === 'invalid_credential_format' || code === 'invalid_auth_header') return 'My natural voice needs its private API connection checked. You can use Browser voice or type to me.';
  if (QUOTA_CODES.includes(code ?? '')) return 'My natural voice account needs its billing or usage allowance checked. You can use Browser voice or type to me.';
  if (status === 403 || code === 'model_not_found') return 'My natural voice account needs access to its voice model checked. You can use Browser voice or type to me.';
  if (status === 429) return 'My natural voice service is busy. Please try later, use Browser voice, or type to me.';
  return 'I couldn’t start my natural voice service. You can use Browser voice or type to me.';
}

export function safeNetworkCode(error: unknown, aborted = false) {
  if (aborted) return 'network_timeout';
  const value = error && typeof error === 'object' ? error as { message?: unknown; cause?: { code?: unknown } } : null;
  const message = typeof value?.message === 'string' ? value.message : '';
  const cause = value?.cause?.code;
  if (/not a valid.*header|invalid.*header|header.*invalid|ByteString|ISO-8859|header.*character|character.*header/i.test(message) || cause === 'ERR_INVALID_CHAR') return 'invalid_auth_header';
  if (/cannot perform I\/O|different request|request context|global scope/i.test(message)) return 'request_context_failure';
  if (/cache.*not.*implement|unsupported.*cache|cache.*unsupported/i.test(message)) return 'unsupported_fetch_option';
  if (/outbound|not allowed|network.*denied|network.*blocked|blocked.*network|URL.*blocked/i.test(message)) return 'outbound_blocked';
  if (cause === 'ENOTFOUND' || cause === 'EAI_AGAIN') return 'dns_failure';
  if (cause === 'CERT_HAS_EXPIRED' || cause === 'UNABLE_TO_VERIFY_LEAF_SIGNATURE' || cause === 'DEPTH_ZERO_SELF_SIGNED_CERT') return 'tls_failure';
  return 'transport_failure';
}

export async function checkVoiceProvider(key: string, fetcher: typeof fetch = fetch): Promise<ProviderCheck> {
  if (!/^sk-[A-Za-z0-9_-]{20,1024}$/.test(key.trim())) {
    console.warn('pondster.voice.provider', JSON.stringify({ stage: 'model-access', httpStatus: null, code: 'invalid_credential_format' }));
    return { state: 'configuration', httpStatus: null, code: 'invalid_credential_format' };
  }
  const controller = new AbortController(), timeout = setTimeout(() => controller.abort(), 5000);
  let httpStatus: number | null = null;
  try {
    const response = await fetcher('https://api.openai.com/v1/models/gpt-live-1', {
      headers: { Authorization: `Bearer ${key.trim()}` }, signal: controller.signal, redirect: 'manual', cache: 'no-store'
    });
    httpStatus = response.status;
    if (response.ok) { try { await response.body?.cancel(); } catch { /* Metadata body is not needed. */ } return { state: 'ready', httpStatus: response.status, code: null }; }
    const code = await safeProviderFailure(response, 'model-access');
    const state: CheckState = response.status === 401 ? 'authentication'
      : QUOTA_CODES.includes(code ?? '') ? 'quota'
      : response.status === 403 || code === 'model_not_found' ? 'access'
      : response.status === 429 ? 'rate_limit' : 'provider_error';
    return { state, httpStatus: response.status, code };
  } catch (error) {
    const code = safeNetworkCode(error, controller.signal.aborted);
    console.warn('pondster.voice.provider', JSON.stringify({ stage: 'model-access', httpStatus, code }));
    return { state: httpStatus === null ? 'network' : 'provider_error', httpStatus, code };
  } finally { clearTimeout(timeout); }
}

export async function voiceProviderStatus(base: Response, credential: string) {
  const key = credential.trim();
  if (!cached || cached.key !== key || cached.until <= Date.now()) cached = { key, until: Date.now() + 60_000, result: checkVoiceProvider(key) };
  const check = await cached.result;
  return new Response(JSON.stringify({ available: check.state === 'ready', connectionCheck: check,
    ...(check.state === 'ready' ? {} : { message: providerFailureMessage(check.httpStatus ?? 0, check.code) }) }), { headers: base.headers });
}
