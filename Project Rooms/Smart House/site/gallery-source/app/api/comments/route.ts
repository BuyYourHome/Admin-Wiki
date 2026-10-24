import { NextRequest, NextResponse } from 'next/server';
import { and, desc, eq, lt, or, sql } from 'drizzle-orm';
import { getDb } from '../../../db/index';
import { pageComments } from '../../../db/schema';
import { COMMENT_COOLDOWN_MS, COMMENT_DAILY_LIMIT, COMMENT_DAY_MS, COMMENT_PAGE_SIZE, commentCursor, isCommentPage, parseCommentCursor, validateComment } from '../../../lib/comments';

export const dynamic = 'force-dynamic';
const COOKIE = 'pond_comment_visitor';
const MAX_REQUEST_BYTES = 8192;
const headers = { 'Cache-Control': 'no-store, private', 'Vary': 'Cookie' };
const publicFields = { id: pageComments.id, page: pageComments.page, name: pageComments.name, body: pageComments.body, createdAt: pageComments.createdAt };

function visitor(request: NextRequest) {
  const value = request.cookies.get(COOKIE)?.value;
  return value && /^[a-f0-9]{32}$/.test(value) ? value : null;
}

async function boundedBody(request: NextRequest) {
  const reader = request.body?.getReader();
  if (!reader) return '';
  const decoder = new TextDecoder();
  let bytes = 0, text = '';
  try {
    while (true) {
      const chunk = await reader.read();
      if (chunk.done) return text + decoder.decode();
      bytes += chunk.value.byteLength;
      if (bytes > MAX_REQUEST_BYTES) { await reader.cancel(); return null; }
      text += decoder.decode(chunk.value, { stream: true });
    }
  } finally { reader.releaseLock(); }
}

function respond(request: NextRequest, key: string | null, body: unknown, status = 200, extraHeaders = {}) {
  const response = NextResponse.json(body, { status, headers: { ...headers, ...extraHeaders } });
  if (key) response.cookies.set(COOKIE, key, { httpOnly: true, secure: request.nextUrl.protocol === 'https:', sameSite: 'lax', path: '/', maxAge: 60 * 60 * 24 * 365 });
  return response;
}

export async function GET(request: NextRequest) {
  const page = request.nextUrl.searchParams.get('page');
  if (!isCommentPage(page)) return respond(request, null, { error: 'Unknown page.' }, 400);
  const rawCursor = request.nextUrl.searchParams.get('cursor');
  const cursor = rawCursor ? parseCommentCursor(rawCursor) : null;
  if (rawCursor && !cursor) return respond(request, null, { error: 'Invalid comment page.' }, 400);
  const key = visitor(request) ?? crypto.randomUUID().replaceAll('-', '');
  try {
    const db = getDb();
    const older = cursor ? or(lt(pageComments.createdAt, cursor.createdAt), and(eq(pageComments.createdAt, cursor.createdAt), lt(pageComments.id, cursor.id))) : undefined;
    const rows = await db.select(publicFields).from(pageComments).where(and(eq(pageComments.page, page), older)).orderBy(desc(pageComments.createdAt), desc(pageComments.id)).limit(COMMENT_PAGE_SIZE + 1);
    const comments = rows.slice(0, COMMENT_PAGE_SIZE);
    return respond(request, key, { comments, nextCursor: rows.length > COMMENT_PAGE_SIZE ? commentCursor(comments[comments.length - 1]) : null });
  } catch {
    return respond(request, key, { error: 'Comments are temporarily unavailable. Please try again.' }, 503);
  }
}

export async function POST(request: NextRequest) {
  const key = visitor(request);
  const reply = (body: unknown, status = 200, extraHeaders = {}) => respond(request, key, body, status, extraHeaders);
  // Consume bounded request bodies even for rejected headers so the worker can finish the request cleanly.
  let text: string | null;
  try { text = await boundedBody(request); }
  catch { return reply({ error: 'Invalid comment.' }, 400); }
  if (text === null) return reply({ error: 'Request too large.' }, 413);
  const origin = request.headers.get('origin');
  if (!origin || origin !== new URL(request.url).origin) return reply({ error: 'Please comment from the Pondster website.' }, 403);
  if (request.headers.get('content-type')?.split(';')[0].trim().toLowerCase() !== 'application/json') return reply({ error: 'Please submit a JSON comment.' }, 415);
  let input: unknown;
  try { input = JSON.parse(text); }
  catch { return reply({ error: 'Invalid comment.' }, 400); }
  const parsed = validateComment(input);
  if ('error' in parsed) return reply({ error: parsed.error }, 400);
  if (!key) return reply({ error: 'Please reload this page before commenting.' }, 409);
  const draft = parsed.value;
  try {
    const db = getDb();
    const existing = async () => {
      const rows = await db.select({ ...publicFields, requestId: pageComments.requestId, visitorKey: pageComments.visitorKey }).from(pageComments).where(eq(pageComments.requestId, draft.requestId)).limit(1);
      const saved = rows[0];
      if (!saved) return null;
      if (saved.visitorKey !== key || saved.page !== draft.page || saved.name !== draft.name || saved.body !== draft.body) return reply({ error: 'That submission already contains a different comment. Please refresh and try again.' }, 409);
      const { requestId: _requestId, visitorKey: _visitorKey, ...comment } = saved;
      return reply({ comment });
    };
    const savedResponse = await existing();
    if (savedResponse) return savedResponse;
    const comment = { id: crypto.randomUUID().replaceAll('-', ''), page: draft.page, name: draft.name, body: draft.body, createdAt: Date.now() };
    // One statement makes the browser-wide cooldown and daily cap atomic, including simultaneous posts.
    const inserted = await db.run(sql`INSERT INTO page_comments (id, request_id, page, visitor_key, name, body, created_at)
      SELECT ${comment.id}, ${draft.requestId}, ${draft.page}, ${key}, ${draft.name}, ${draft.body}, ${comment.createdAt}
      WHERE NOT EXISTS (SELECT 1 FROM page_comments WHERE visitor_key = ${key} AND created_at > ${comment.createdAt - COMMENT_COOLDOWN_MS})
      AND (SELECT COUNT(*) FROM page_comments WHERE visitor_key = ${key} AND created_at > ${comment.createdAt - COMMENT_DAY_MS}) < ${COMMENT_DAILY_LIMIT}
      ON CONFLICT(request_id) DO NOTHING`);
    if (!inserted.meta.changes) {
      const concurrentResponse = await existing();
      if (concurrentResponse) return concurrentResponse;
      return reply({ error: 'Please wait before commenting again. This browser allows one comment every 30 seconds and up to 20 in a day.' }, 429, { 'Retry-After': '30' });
    }
    return reply({ comment }, 201);
  } catch {
    return reply({ error: 'Your comment could not be saved. Please try again.' }, 503);
  }
}
