import assert from 'node:assert/strict';
import { DatabaseSync } from 'node:sqlite';
import { readFileSync } from 'node:fs';
import { handleLightingMcp, publicLightingResponse, readLightingPublication, UPSERT_LIGHTING_SQL } from '../worker/lighting-source.ts';
import { renderLightingReview } from '../lib/lighting-review-html.ts';
import { generateLightingPublicWorkbook } from '../lib/lighting-public-workbook.ts';
import { unzipSync, strFromU8 } from 'fflate';

const sql = new DatabaseSync(':memory:');
sql.exec(readFileSync(new URL('../drizzle/0005_open_the_hunter.sql', import.meta.url), 'utf8'));
let beforeWrite;
const DB = { prepare(query) { return { bind(...values) { return {
  async first() { return sql.prepare(query).get(...values) ?? null; },
  async run() { const hook=beforeWrite;beforeWrite=undefined;if(hook)hook(query);const result=sql.prepare(query).run(...values);return {success:true,meta:{changes:Number(result.changes)}}; },
}; } }; } };
const env = { DB, LIGHTING_SYNC_OWNER_EMAIL: 'owner@example.test', LIGHTING_SOURCE_DRIVE_ID: 'drive_test', LIGHTING_SOURCE_ITEM_ID: 'item_test' };
const base = { source_drive_id:'drive_test', source_item_id:'item_test', source_modified_at:'2026-11-25T08:57:58Z' };
const header = 'Record ID,Room / control group,Light type,Light quantity,Switch count,Smart device qty,Smart device / model,Additional relay qty,Additional relay / model,Private note';
const row = (id,room,quantity=4,smartQty=1,smartModel='Shelly smart relay',extraQty=0,extraModel='Included in smart module') => `${id},${room},${id.startsWith('LS-')?'LED strips':'Recessed LED'},${quantity},2,${smartQty},${smartModel},${extraQty},${extraModel},private construction note`;
const csv = (rows=[row('L-011','Living room')]) => header+'\n'+rows.join('\n');
const csvRoles = (rows,roles) => header+',Load controller qty,Load controller / model,Manual remote qty,Input module qty,Input module / model\n'+rows.map((value,index)=>value+','+roles[index].join(',')).join('\n');
async function rpc(name,args={},email='owner@example.test') {
  const request = new Request('https://pondster.example/mcp',{method:'POST',headers:{'Content-Type':'application/json',...(email?{'oai-authenticated-user-email':email}:{})},body:JSON.stringify({jsonrpc:'2.0',id:1,method:'tools/call',params:{name,arguments:args}})});
  const response=await handleLightingMcp(request,env);return {status:response.status,body:await response.json()};
}
const resultValue = result => result.body.result.structuredContent;
for(const method of ['server/discover','tools/list']) {
  const response=await handleLightingMcp(new Request('https://pondster.example/mcp',{method:'POST',body:JSON.stringify({jsonrpc:'2.0',id:0,method})}),{});
  assert.equal(response.status,200,'Publisher may discover tool definitions without identity.');
  const text=await response.text();assert.doesNotMatch(text,/owner@example|drive_test|item_test/);
}
for(const email of [null,'visitor@example.test']) {
  for(const name of ['get_lighting_sync_status','sync_lighting_schedule','report_lighting_sync_failure']) assert.equal((await rpc(name,{},email)).status,403,'All callable operations require the owner.');
}
const unset=await handleLightingMcp(new Request('https://pondster.example/mcp',{method:'POST',headers:{'oai-authenticated-user-email':'owner@example.test'},body:JSON.stringify({jsonrpc:'2.0',id:1,method:'tools/call',params:{name:'get_lighting_sync_status'}})}),{DB});assert.equal(unset.status,403,'Missing owner config fails closed.');
const crossOrigin=await handleLightingMcp(new Request('https://pondster.example/mcp',{method:'POST',headers:{'Origin':'https://elsewhere.example','oai-authenticated-user-email':'owner@example.test'},body:JSON.stringify({jsonrpc:'2.0',id:1,method:'tools/call',params:{name:'get_lighting_sync_status'}})}),env);assert.equal(crossOrigin.status,403,'Browser cross-origin calls are rejected even with an identity header.');
assert.equal(resultValue(await rpc('get_lighting_sync_status')).status,'seed');
let first=await rpc('sync_lighting_schedule',{...base,source_etag:'etag-1',source_text:csvRoles([row('L-011','Living room')],[[1,'Shelly smart relay',1,0,'None']])});
assert.equal(first.status,200);assert.equal(resultValue(first).changed,true);
const firstRevision=resultValue(first).revision;
let publication=await readLightingPublication(env);
assert.equal(publication.snapshot.totals.ordinaryGroups,1);assert.equal(publication.snapshot.totals.ordinarySmartDevices,1);assert.equal(publication.snapshot.totals.ordinaryAdditionalRelays,0);
assert.equal(publication.snapshot.groups[0].loadControllerQty,1);assert.equal(publication.snapshot.groups[0].inputModuleQty,0);
assert.doesNotMatch(JSON.stringify(publication),/drive_test|item_test|etag-1|private construction/);
const same=await rpc('sync_lighting_schedule',{...base,source_etag:'etag-1'});assert.equal(resultValue(same).changed,false);assert.equal(resultValue(same).revision,firstRevision);
assert.equal((await rpc('sync_lighting_schedule',{...base,source_etag:'etag-1',source_text:csv([row('L-011','Changed room')])})).status,409,'Same source ETag cannot mean different data.');
assert.equal((await rpc('sync_lighting_schedule',{...base,source_etag:'etag-2'})).status,400,'Changed source needs actual text.');
assert.equal((await rpc('sync_lighting_schedule',{...base,source_item_id:'another',source_etag:'etag-2',source_text:csv()})).status,403);
assert.equal((await rpc('sync_lighting_schedule',{...base,source_modified_at:'2026-11-24T08:00:00Z',source_etag:'older',source_text:csv()})).status,409);
const second=await rpc('sync_lighting_schedule',{...base,source_modified_at:'2026-11-25T09:00:00Z',source_etag:'etag-2',source_text:csvRoles([row('L-011','Living room revised',5,2,'Updated smart model'),row('L-020','New hallway',2),row('LS-020','New strip zone',1,3,'2 x Shelly Plus RGBW PM; 1 x Shelly Plus i4',3,'Updated extra relay')],[[1,'Updated load controller',1,1,'Updated input module'],[1,'Shelly smart relay',1,0,'None'],[2,'Shelly Plus RGBW PM',2,1,'Shelly Plus i4']])});
assert.equal(second.status,200);assert.notEqual(resultValue(second).revision,firstRevision);
publication=await readLightingPublication(env);assert.equal(publication.snapshot.totals.ordinaryGroups,2);assert.equal(publication.snapshot.totals.fixtures,7);assert.equal(publication.snapshot.totals.primarySmartDevicesKnown,6);assert.equal(publication.snapshot.totals.additionalRelaysKnown,3);
assert.equal(publication.snapshot.totals.loadControllersKnown,4);assert.equal(publication.snapshot.totals.inputModulesKnown,2);assert.equal(publication.snapshot.totals.analogControllers,2,'An input module is not an additional RGBW load controller.');
const html=renderLightingReview(publication.snapshot);assert.match(html,/Living room revised/);assert.match(html,/New hallway/);assert.match(html,/Updated smart model/);assert.match(html,/Updated extra relay/);assert.ok(html.includes(publication.snapshot.revision));assert.doesNotMatch(html,/etag-2|drive_test/);
const workbook=unzipSync(generateLightingPublicWorkbook(publication.snapshot));
const workbookXml=Object.entries(workbook).filter(([name])=>name.endsWith('.xml')).map(([,bytes])=>strFromU8(bytes)).join('\n');
assert.match(workbookXml,/Living room revised/);assert.match(workbookXml,/Updated smart model/);assert.match(workbookXml,/Updated extra relay/);assert.match(workbookXml,/Updated input module/);assert.ok(workbookXml.includes(publication.snapshot.revision));assert.doesNotMatch(workbookXml,/etag-2|drive_test|private construction/);
const publicResponse=await publicLightingResponse(new Request('https://pondster.example/api/lighting'),env);assert.equal(publicResponse.status,200);const tag=publicResponse.headers.get('etag');
assert.equal((await publicLightingResponse(new Request('https://pondster.example/api/lighting',{headers:{'If-None-Match':tag}}),env)).status,304);
const revisionBeforeInvalid=publication.snapshot.revision;
for(const invalidText of [csv([row('L-011','C:\\Users\\private')]),csv([row('L-011','908 Pond Street')]),csv([row('L-011','Living room'),row('L-011','Duplicate')])]) {
  const response=await rpc('sync_lighting_schedule',{...base,source_modified_at:'2026-11-25T09:10:00Z',source_etag:'bad',source_text:invalidText});
  assert.equal(response.status,400);assert.equal((await readLightingPublication(env)).snapshot.revision,revisionBeforeInvalid);assert.doesNotMatch(JSON.stringify(response.body),/908 Pond|C:\\Users/);
}
let failure=await rpc('report_lighting_sync_failure',{source_drive_id:'drive_test',source_item_id:'item_test',code:'source_access'});assert.equal(failure.status,200);
publication=await readLightingPublication(env);assert.equal(publication.sync.status,'error');assert.equal(publication.snapshot.revision,revisionBeforeInvalid);
await rpc('sync_lighting_schedule',{...base,source_modified_at:'2026-11-25T09:00:00Z',source_etag:'etag-2'});assert.equal((await readLightingPublication(env)).sync.status,'current');
beforeWrite=query=>{if(query===UPSERT_LIGHTING_SQL)sql.prepare('UPDATE lighting_source_publication SET source_etag=? WHERE id=?').run('concurrent','lighting');};
const conflict=await rpc('sync_lighting_schedule',{...base,source_modified_at:'2026-11-25T09:20:00Z',source_etag:'etag-3',source_text:csv([row('L-011','Racing change')])});assert.equal(conflict.status,409,'Compare-and-swap rejects concurrent source changes.');
assert.equal((await readLightingPublication(env)).snapshot.revision,revisionBeforeInvalid);
const broken={DB:{prepare(){throw new Error('private database diagnostic');}}};
const unavailable=await publicLightingResponse(new Request('https://pondster.example/api/lighting'),broken);assert.equal(unavailable.status,503);assert.doesNotMatch(await unavailable.text(),/private database|initial-20261125/,'Read failures cannot revert to an older bundled seed.');
const oversized=new Request('https://pondster.example/mcp',{method:'POST',body:'x'.repeat(524289)});assert.equal((await handleLightingMcp(oversized,env)).status,413);
console.log('PASS lighting source server: owner authorization, atomic import, dynamic changes, privacy, replay, concurrency, readback and last-good failure behavior.');
