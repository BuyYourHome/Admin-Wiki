import { NextRequest, NextResponse } from 'next/server';
import { and, eq, count } from 'drizzle-orm';
import { getDb } from '../../../db/index';
import { designVotes } from '../../../db/schema';
import { galleries } from '../../../lib/designs';

export const dynamic = 'force-dynamic';
const COOKIE = 'pond_design_voter';
const headers = { 'Cache-Control': 'no-store, private', 'Vary': 'Cookie' };
function voter(request: NextRequest) {
  const key = request.cookies.get(COOKIE)?.value;
  return key && /^[a-f0-9]{32}$/.test(key) ? key : null;
}
function withVoterCookie(request: NextRequest, response: NextResponse, key: string | null) {
  if (key) response.cookies.set(COOKIE, key, {httpOnly:true, secure:request.nextUrl.protocol === 'https:', sameSite:'lax', path:'/', maxAge:60*60*24*365});
  return response;
}
async function results(room: string, key: string | null) {
  const db = getDb();
  const rows = await db.select({ id: designVotes.designId, votes: count() }).from(designVotes).where(eq(designVotes.room, room)).groupBy(designVotes.designId);
  const own = key ? await db.select({ id: designVotes.designId }).from(designVotes).where(and(eq(designVotes.room, room), eq(designVotes.voterKey, key))).limit(1) : [];
  const scores = Object.fromEntries(rows.map(row => [row.id, row.votes]));
  return { scores, total: rows.reduce((total, row) => total + row.votes, 0), selected: own[0]?.id ?? null };
}
export async function GET(request: NextRequest) {
  const room = request.nextUrl.searchParams.get('room');
  if (!galleries.some(gallery => gallery.id === room)) return NextResponse.json({error:'Unknown gallery.'}, {status:400, headers});
  const key = voter(request) ?? crypto.randomUUID().replaceAll('-', '');
  try { return withVoterCookie(request, NextResponse.json(await results(room!, key), {headers}), key); }
  catch { return withVoterCookie(request, NextResponse.json({error:'Voting results are temporarily unavailable. Please try again.'}, {status:503, headers}), key); }
}
export async function POST(request: NextRequest) {
  const key = voter(request);
  const respond = (body: unknown, status = 200) => withVoterCookie(request, NextResponse.json(body, {status, headers}), key);
  const origin = request.headers.get('origin');
  if (!origin || origin !== new URL(request.url).origin) return respond({error:'Please vote from the Pondster website.'}, 403);
  if (Number(request.headers.get('content-length') ?? 0) > 1024) return respond({error:'Request too large.'}, 413);
  let body;
  try { const text = await request.text(); if (text.length > 1024) throw new Error(); body = JSON.parse(text); }
  catch { return respond({error:'Invalid vote.'}, 400); }
  const gallery = galleries.find(gallery => gallery.id === body?.room);
  if (!gallery || !gallery.designs.some(design => design.id === body?.designId)) return respond({error:'Choose an available design in this gallery.'}, 400);
  if (!key) return respond({error:'Please reload the page before voting so this browser can keep one choice per gallery.'}, 409);
  try {
    const db = getDb();
    await db.insert(designVotes).values({room:gallery.id, voterKey:key, designId:body.designId, updatedAt:Date.now()}).onConflictDoUpdate({target:[designVotes.room, designVotes.voterKey],set:{designId:body.designId, updatedAt:Date.now()}});
    return respond(await results(gallery.id, key));
  } catch { return respond({error:'Your vote could not be saved. Please try again.'}, 503); }
}
