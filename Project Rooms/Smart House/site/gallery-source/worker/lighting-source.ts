import seedValue from '../lib/lighting-source-seed.json' with { type: 'json' };
import { parseLightingSource, validateProjection, type LightingSnapshot } from '../lib/lighting-source-model';
import {CONVERSATION_EMAIL_TOOLS,callConversationEmailTool,ConversationEmailFailure} from './pondster-conversation-email';
import {CONVERSATION_IDENTITY_TOOLS,reviewConversationIdentities} from './pondster-conversation-identities';

export type LightingEnvironment = {
  DB?: D1Database;
  LIGHTING_SYNC_OWNER_EMAIL?: string;
  LIGHTING_SOURCE_DRIVE_ID?: string;
  LIGHTING_SOURCE_ITEM_ID?: string;
};
type PublicationRow = {
  id: string; revision: string; public_json: string; source_drive_id: string; source_item_id: string;
  source_etag: string; source_modified_at: string | null; published_at: string;
  last_checked_at: string; last_success_at: string; sync_status: string; last_error_code: string | null;
};
export type LightingSyncStatus = {
  status: 'seed' | 'current' | 'stale' | 'error';
  lastCheckedAt: string | null;
  lastSuccessAt: string | null;
};
export type LightingPublication = { snapshot: LightingSnapshot; sync: LightingSyncStatus };
export const LIGHTING_SINGLETON = 'lighting';
export const MAX_LIGHTING_REQUEST_BYTES = 524_288;
const JSON_HEADERS = { 'Content-Type': 'application/json; charset=utf-8', 'Cache-Control': 'no-store, private', 'X-Content-Type-Options': 'nosniff' };
const SOURCE_ID = /^[A-Za-z0-9!_.-]{1,220}$/;
const FAILURE_CODES = new Set(['source_unavailable', 'source_access', 'source_invalid', 'writer_unavailable']);
export const SELECT_LIGHTING_SQL = 'SELECT * FROM lighting_source_publication WHERE id = ?';
export const UPSERT_LIGHTING_SQL = `INSERT INTO lighting_source_publication
  (id, revision, public_json, source_drive_id, source_item_id, source_etag, source_modified_at, published_at, last_checked_at, last_success_at, sync_status, last_error_code)
  VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'current', NULL)
  ON CONFLICT(id) DO UPDATE SET revision=excluded.revision, public_json=excluded.public_json,
    source_drive_id=excluded.source_drive_id, source_item_id=excluded.source_item_id,
    source_etag=excluded.source_etag, source_modified_at=excluded.source_modified_at,
    published_at=excluded.published_at, last_checked_at=excluded.last_checked_at,
    last_success_at=excluded.last_success_at, sync_status='current', last_error_code=NULL
  WHERE lighting_source_publication.source_etag = ?
    AND (lighting_source_publication.source_modified_at IS NULL OR
      (excluded.source_modified_at IS NOT NULL AND excluded.source_modified_at >= lighting_source_publication.source_modified_at))`;

function seed(): LightingSnapshot { return validateProjection(seedValue); }
function publicState(row: PublicationRow | null): LightingPublication {
  if (!row) return { snapshot: seed(), sync: { status: 'seed', lastCheckedAt: null, lastSuccessAt: null } };
  const snapshot = validateProjection(JSON.parse(row.public_json));
  if (snapshot.revision !== row.revision) throw new Error('invalid stored publication');
  const overdue = Date.now() - Date.parse(row.last_success_at) > 26 * 60 * 60 * 1000;
  return { snapshot, sync: { status: row.sync_status === 'error' ? 'error' : overdue ? 'stale' : 'current', lastCheckedAt: row.last_checked_at, lastSuccessAt: row.last_success_at } };
}
async function readRow(env: LightingEnvironment): Promise<PublicationRow | null> {
  if (!env.DB) throw new Error('storage unavailable');
  return env.DB.prepare(SELECT_LIGHTING_SQL).bind(LIGHTING_SINGLETON).first<PublicationRow>();
}
export async function readLightingPublication(env: LightingEnvironment): Promise<LightingPublication> {
  // A missing row is an honest first-publication seed. A failed read is not.
  return publicState(await readRow(env));
}
export async function readLightingSnapshot(env: LightingEnvironment): Promise<LightingSnapshot> {
  return (await readLightingPublication(env)).snapshot;
}
export async function publicLightingResponse(request: Request, env: LightingEnvironment): Promise<Response> {
  let publication: LightingPublication;
  try { publication = await readLightingPublication(env); }
  catch { return new Response(JSON.stringify({ error: 'The current lighting reference is temporarily unavailable. Please try again.' }), { status: 503, headers: JSON_HEADERS }); }
  const tag = `"${publication.snapshot.revision}-${publication.sync.status}-${publication.sync.lastCheckedAt ?? 'seed'}"`;
  const headers = { 'Content-Type': 'application/json; charset=utf-8', 'Cache-Control': 'public, max-age=30, must-revalidate', ETag: tag, 'X-Content-Type-Options': 'nosniff' };
  return request.headers.get('if-none-match') === tag ? new Response(null, { status: 304, headers }) : new Response(JSON.stringify(publication), { headers });
}
function authorized(request: Request, env: LightingEnvironment): boolean {
  const owner = env.LIGHTING_SYNC_OWNER_EMAIL?.trim().toLowerCase();
  const caller = request.headers.get('oai-authenticated-user-email')?.trim().toLowerCase();
  return Boolean(owner && caller && caller === owner);
}
function configuredSource(env: LightingEnvironment) {
  const drive = env.LIGHTING_SOURCE_DRIVE_ID?.trim(), item = env.LIGHTING_SOURCE_ITEM_ID?.trim();
  if (!drive || !item || !SOURCE_ID.test(drive) || !SOURCE_ID.test(item)) throw new SyncFailure('configuration', 'The lighting source is not configured.', 503);
  return { drive, item };
}
class SyncFailure extends Error {
  code: string;
  status: number;
  constructor(code: string, message: string, status = 400) { super(message); this.code = code; this.status = status; }
}
function object(value: unknown): Record<string, unknown> {
  if (!value || typeof value !== 'object' || Array.isArray(value)) throw new SyncFailure('invalid_input', 'Expected an object.');
  return value as Record<string, unknown>;
}
function exactKeys(value: Record<string, unknown>, allowed: string[]) {
  if (Object.keys(value).some(key => !allowed.includes(key))) throw new SyncFailure('invalid_input', 'Unsupported fields.');
}
function sourceArguments(value: Record<string, unknown>, env: LightingEnvironment) {
  const source = configuredSource(env);
  if (value.source_drive_id !== source.drive || value.source_item_id !== source.item) throw new SyncFailure('source_mismatch', 'Only the configured lighting master can be imported.', 403);
  return source;
}
function sourceDate(value: unknown): string | null {
  if (value === null) return null;
  if (typeof value !== 'string' || value.length > 40 || !/^\d{4}-\d\d-\d\dT/.test(value) || !Number.isFinite(Date.parse(value))) throw new SyncFailure('invalid_input', 'Invalid source modification timestamp.');
  const normalized = new Date(value).toISOString();
  if (Date.parse(normalized) > Date.now() + 300_000) throw new SyncFailure('invalid_input', 'The source modification timestamp is in the future.');
  return normalized;
}
async function revisionFor(snapshot: LightingSnapshot) {
  const data = JSON.stringify({ schemaVersion: snapshot.schemaVersion, sourceModifiedAt: snapshot.sourceModifiedAt, groups: snapshot.groups, totals: snapshot.totals });
  const hash = await crypto.subtle.digest('SHA-256', new TextEncoder().encode(data));
  return Array.from(new Uint8Array(hash), byte => byte.toString(16).padStart(2, '0')).join('');
}
function changed(result: D1Result) { return Number(result.meta?.changes ?? 0) > 0; }

async function syncLighting(value: Record<string, unknown>, env: LightingEnvironment) {
  exactKeys(value, ['source_drive_id', 'source_item_id', 'source_etag', 'source_modified_at', 'source_text']);
  const source = sourceArguments(value, env);
  if (!env.DB) throw new SyncFailure('storage_unavailable', 'The lighting store is unavailable.', 503);
  const etag = value.source_etag;
  if (typeof etag !== 'string' || !etag.trim() || etag.length > 512 || /[\r\n\u0000-\u001f]/.test(etag)) throw new SyncFailure('invalid_input', 'A bounded source revision is required.');
  const modifiedAt = sourceDate(value.source_modified_at);
  const previous = await readRow(env);
  const now = new Date().toISOString();
  if (previous && (previous.source_drive_id !== source.drive || previous.source_item_id !== source.item)) throw new SyncFailure('source_mismatch', 'The saved source differs from the configured master.', 409);
  if (previous?.source_modified_at && (!modifiedAt || modifiedAt < previous.source_modified_at)) throw new SyncFailure('older_source', 'An older source cannot replace the published lighting reference.', 409);
  if (previous?.source_etag === etag && value.source_text === undefined) {
    const result = await env.DB.prepare("UPDATE lighting_source_publication SET last_checked_at=?, last_success_at=?, sync_status='current', last_error_code=NULL WHERE id=? AND source_etag=?").bind(now, now, LIGHTING_SINGLETON, etag).run();
    if (!changed(result)) throw new SyncFailure('publication_conflict', 'The publication changed during this check. Read status again.', 409);
    return { changed: false, revision: previous.revision, sync: { status: 'current', lastCheckedAt: now, lastSuccessAt: now } };
  }
  if (typeof value.source_text !== 'string' || !value.source_text.trim() || new TextEncoder().encode(value.source_text).byteLength > 400_000) throw new SyncFailure('source_required', 'A changed source revision requires the bounded extracted workbook text.');
  let projection: LightingSnapshot;
  try { projection = parseLightingSource(value.source_text, { sourceModifiedAt: modifiedAt, publishedAt: now, revision: 'pending' }); }
  catch { throw new SyncFailure('source_invalid', 'The workbook did not pass the lighting schema and privacy checks. The previous publication was retained.'); }
  const revision = await revisionFor(projection);
  if (previous?.source_etag === etag && previous.revision !== revision) throw new SyncFailure('revision_mismatch', 'The same source revision cannot contain different lighting data.', 409);
  const samePublic = previous?.revision === revision;
  projection = validateProjection({ ...projection, revision, publishedAt: samePublic ? previous.published_at : now });
  const result = await env.DB.prepare(UPSERT_LIGHTING_SQL).bind(LIGHTING_SINGLETON, revision, JSON.stringify(projection), source.drive, source.item, etag, modifiedAt, projection.publishedAt, now, now, previous?.source_etag ?? '').run();
  if (!changed(result)) throw new SyncFailure('publication_conflict', 'The publication changed during this import. Read status again.', 409);
  const saved = await readRow(env);
  if (!saved || saved.revision !== revision || saved.source_etag !== etag) throw new SyncFailure('readback_failed', 'The import could not be verified. Read status before retrying.', 503);
  return { changed: !samePublic, revision, sync: publicState(saved).sync };
}
async function ownerStatus(env: LightingEnvironment) {
  const source = configuredSource(env), row = await readRow(env);
  const state = publicState(row);
  return { ...state.sync, revision: state.snapshot.revision, source_drive_id: source.drive, source_item_id: source.item,
    source_url: `https://graph.microsoft.com/v1.0/drives/${encodeURIComponent(source.drive)}/items/${encodeURIComponent(source.item)}`,
    source_etag: row?.source_etag ?? null, source_modified_at: row?.source_modified_at ?? null, last_error_code: row?.last_error_code ?? null };
}
async function reportFailure(value: Record<string, unknown>, env: LightingEnvironment) {
  exactKeys(value, ['source_drive_id', 'source_item_id', 'code']);
  sourceArguments(value, env);
  if (typeof value.code !== 'string' || !FAILURE_CODES.has(value.code)) throw new SyncFailure('invalid_input', 'Unsupported failure category.');
  if (!env.DB) throw new SyncFailure('storage_unavailable', 'The lighting store is unavailable.', 503);
  await env.DB.prepare("UPDATE lighting_source_publication SET last_checked_at=?, sync_status='error', last_error_code=? WHERE id=?").bind(new Date().toISOString(), value.code, LIGHTING_SINGLETON).run();
  return { retainedLastGood: true, ...(await ownerStatus(env)) };
}
const SOURCE_PROPERTIES = { source_drive_id: { type: 'string' }, source_item_id: { type: 'string' } };
export const LIGHTING_MCP_TOOLS = [
  { name: 'get_lighting_sync_status', description: 'Owner-only: read the configured lighting master reference, last source revision and publication status. Use its exact source_url with the SharePoint connector.', annotations: { readOnlyHint: true }, inputSchema: { type: 'object', properties: {}, additionalProperties: false } },
  { name: 'sync_lighting_schedule', description: 'Owner-only: validate extracted text from the configured SharePoint lighting workbook and atomically refresh the public lighting reference. First import or a changed source_etag requires source_text. Unchanged ETag may omit text. Never invent or narrate missing cells.', annotations: { readOnlyHint: false, destructiveHint: false, idempotentHint: true, openWorldHint: false }, inputSchema: { type: 'object', properties: { ...SOURCE_PROPERTIES, source_etag: { type: 'string', maxLength: 512 }, source_modified_at: { type: ['string', 'null'] }, source_text: { type: 'string', maxLength: 400000 } }, required: ['source_drive_id', 'source_item_id', 'source_etag', 'source_modified_at'], additionalProperties: false } },
  { name: 'report_lighting_sync_failure', description: 'Owner-only: record a safe failure category while retaining the last good public lighting reference. Never send raw source text, secrets or provider errors.', annotations: { readOnlyHint: false, destructiveHint: false, idempotentHint: true, openWorldHint: false }, inputSchema: { type: 'object', properties: { ...SOURCE_PROPERTIES, code: { type: 'string', enum: [...FAILURE_CODES] } }, required: ['source_drive_id', 'source_item_id', 'code'], additionalProperties: false } },
];
async function boundedJson(request: Request): Promise<unknown> {
  if (Number(request.headers.get('content-length') ?? 0) > MAX_LIGHTING_REQUEST_BYTES) throw new SyncFailure('too_large', 'Request too large.', 413);
  const reader = request.body?.getReader();
  if (!reader) throw new SyncFailure('invalid_json', 'A JSON-RPC request is required.');
  const chunks: Uint8Array[] = []; let size = 0;
  try {
    while (true) { const chunk = await reader.read(); if (chunk.done) break; size += chunk.value.byteLength; if (size > MAX_LIGHTING_REQUEST_BYTES) { await reader.cancel(); throw new SyncFailure('too_large', 'Request too large.', 413); } chunks.push(chunk.value); }
  } finally { reader.releaseLock(); }
  const bytes = new Uint8Array(size); let offset = 0; for (const chunk of chunks) { bytes.set(chunk, offset); offset += chunk.length; }
  try { return JSON.parse(new TextDecoder().decode(bytes)); } catch { throw new SyncFailure('invalid_json', 'Invalid JSON-RPC request.'); }
}
export async function handleLightingMcp(request: Request, env: LightingEnvironment): Promise<Response> {
  if (request.method !== 'POST') return new Response(JSON.stringify({ error: 'Use JSON-RPC POST.' }), { status: 405, headers: { ...JSON_HEADERS, Allow: 'POST' } });
  let id: string | number | null = null;
  const reply = (result: unknown, status = 200) => new Response(JSON.stringify({ jsonrpc: '2.0', id, result }), { status, headers: JSON_HEADERS });
  try {
    const input = object(await boundedJson(request));
    id = typeof input.id === 'string' || typeof input.id === 'number' ? input.id : null;
    if (input.jsonrpc !== '2.0' || typeof input.method !== 'string') throw new SyncFailure('invalid_rpc', 'Invalid JSON-RPC request.');
    // Discovery carries no private configuration and must work for the Site publisher.
    if (input.method === 'server/discover') return reply({ supportedVersions: ['2026-07-28'], capabilities: { tools: {} } });
    if (input.method === 'tools/list') return reply({ tools: [...LIGHTING_MCP_TOOLS,...CONVERSATION_EMAIL_TOOLS,...CONVERSATION_IDENTITY_TOOLS] });
    if (input.method !== 'tools/call') return new Response(JSON.stringify({ jsonrpc: '2.0', id, error: { code: -32601, message: 'Method not found.' } }), { headers: JSON_HEADERS });
    const origin = request.headers.get('origin');
    if (origin && origin !== new URL(request.url).origin) throw new SyncFailure('forbidden', 'Cross-origin browser lighting operations are not allowed.', 403);
    if (!authorized(request, env)) throw new SyncFailure('forbidden', 'This lighting operation is available only to the Site owner.', 403);
    const params = object(input.params), args = object(params.arguments ?? {});
    let result: unknown;
    if (params.name === 'get_lighting_sync_status') { exactKeys(args, []); result = await ownerStatus(env); }
    else if (params.name === 'sync_lighting_schedule') result = await syncLighting(args, env);
    else if (params.name === 'report_lighting_sync_failure') result = await reportFailure(args, env);
    else if (CONVERSATION_EMAIL_TOOLS.some(tool=>tool.name===params.name)) result=await callConversationEmailTool(env.DB,params.name as string,args);
    else if(params.name==='review_conversation_identities')result=await reviewConversationIdentities(env.DB,args);
    else throw new SyncFailure('unknown_tool', 'Unknown lighting operation.');
    return reply({ structuredContent: result, content: [{ type: 'text', text: JSON.stringify(result) }] });
  } catch (failure) {
    const known = failure instanceof SyncFailure ? failure : failure instanceof ConversationEmailFailure?new SyncFailure(failure.code,failure.message,failure.status):new SyncFailure('storage_unavailable', 'The lighting operation could not complete. The last good publication was retained.', 503);
    return reply({ isError: true, structuredContent: { error: known.code, message: known.message }, content: [{ type: 'text', text: known.message }] }, known.status);
  }
}
