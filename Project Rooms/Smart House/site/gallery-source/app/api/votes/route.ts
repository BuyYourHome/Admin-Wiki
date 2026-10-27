import { NextRequest, NextResponse } from 'next/server';
import { and, eq, count } from 'drizzle-orm';
import { getDb } from '../../../db/index';
import { designVotes } from '../../../db/schema';
import { galleries } from '../../../lib/designs';
import { visibleVotes } from '../../../lib/visible-votes';

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
  const rows = await db.select({ room: designVotes.room, id: designVotes.designId, votes: count() }).from(designVotes).groupBy(designVotes.room, designVotes.designId);
  const own = key ? await db.select({ id: designVotes.designId }).from(designVotes).where(and(eq(designVotes.room, room), eq(designVotes.voterKey, key))).limit(1) : [];
  const activeDesignIds = galleries.find(gallery => gallery.id === room)?.designs.map(design => design.id) ?? [];
  const roomTotals = Object.fromEntries(galleries.map(gallery => [
    gallery.id,
    visibleVotes(rows.filter(row => row.room === gallery.id), null, gallery.designs.map(design => design.id)).total
  ]));
  return { ...visibleVotes(rows.filter(row => row.room === room), own[0]?.id ?? null, activeDesignIds), roomTotals };
}
export async function GET(request: NextRequest) {
  const room = request.nextUrl.searchParams.get('room');
  if (!galleries.some(gallery => gallery.id === room)) return NextResponse.json({error:'I don’t recognize that gallery.'}, {status:400, headers});
  const key = voter(request) ?? crypto.randomUUID().replaceAll('-', '');
  try { return withVoterCookie(request, NextResponse.json(await results(room!, key), {headers}), key); }
  catch { return withVoterCookie(request, NextResponse.json({error:'I can’t load the voting results right now. Please try again.'}, {status:503, headers}), key); }
}
export async function POST(request: NextRequest) {
  const key = voter(request);
  const respond = (body: unknown, status = 200) => withVoterCookie(request, NextResponse.json(body, {status, headers}), key);
  const origin = request.headers.get('origin');
  if (!origin || origin !== new URL(request.url).origin) return respond({error:'I can only accept votes from my website.'}, 403);
  if (Number(request.headers.get('content-length') ?? 0) > 1024) return respond({error:'I can’t accept a request that large.'}, 413);
  let body;
  try { const text = await request.text(); if (text.length > 1024) throw new Error(); body = JSON.parse(text); }
  catch { return respond({error:'I couldn’t read your vote.'}, 400); }
  const gallery = galleries.find(gallery => gallery.id === body?.room);
  if (!gallery || !gallery.designs.some(design => design.id === body?.designId)) return respond({error:'I need an available design from this gallery to save your vote.'}, 400);
  if (!key) return respond({error:'Please reload the page so I can keep one choice per browser in each gallery.'}, 409);
  try {
    const db = getDb();
    await db.insert(designVotes).values({room:gallery.id, voterKey:key, designId:body.designId, updatedAt:Date.now()}).onConflictDoUpdate({target:[designVotes.room, designVotes.voterKey],set:{designId:body.designId, updatedAt:Date.now()}});
    return respond(await results(gallery.id, key));
  } catch { return respond({error:'I couldn’t save your vote. Please try again.'}, 503); }
}
