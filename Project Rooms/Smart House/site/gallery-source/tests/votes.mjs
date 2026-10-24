import assert from 'node:assert/strict';
const base = new URL(process.argv[2] ?? 'http://127.0.0.1:19081');
if (!['127.0.0.1','localhost'].includes(base.hostname)) throw new Error('Write tests are restricted to a local preview.');
const browser={cookie:''};
async function call(method,body,origin=base.origin,session=browser){
 const response=await fetch(new URL('/api/votes?room=garage-barn-door',base),{method,headers:{...(method==='POST'?{'Content-Type':'application/json',Origin:origin}:{}),...(session?.cookie?{Cookie:session.cookie}:{})},...(body?{body:JSON.stringify(body)}:{})});
 const set=response.headers.get('set-cookie');if(set&&session)session.cookie=set.split(';')[0];
 return {status:response.status,data:await response.json(),setCookie:set};
}
const before=await call('GET');assert.equal(before.status,200);assert.equal(before.data.selected,null);assert.match(browser.cookie,/^pond_design_voter=[a-f0-9]{32}$/);assert.match(before.setCookie,/HttpOnly/i);
const initialCookie=browser.cookie;
const missing=await call('POST',{room:'garage-barn-door',designId:'garage-06'},base.origin,null);assert.equal(missing.status,409);assert.match(missing.data.error,/reload/i);assert.equal(missing.setCookie,null);
const first=await call('POST',{room:'garage-barn-door',designId:'garage-06'});assert.equal(first.status,200);assert.equal(first.data.total,before.data.total+1);assert.equal(first.data.selected,'garage-06');assert.equal(browser.cookie,initialCookie);
const repeat=await call('POST',{room:'garage-barn-door',designId:'garage-06'});assert.equal(repeat.status,200);assert.equal(repeat.data.total,first.data.total);
const changed=await call('POST',{room:'garage-barn-door',designId:'garage-07'});assert.equal(changed.status,200);assert.equal(changed.data.total,first.data.total);assert.equal(changed.data.selected,'garage-07');assert.equal(changed.data.scores['garage-06']??0,before.data.scores['garage-06']??0);
const stored=await call('GET');assert.equal(stored.data.selected,'garage-07');
const visitorSession={cookie:''};
const visitor=await call('GET',null,base.origin,visitorSession);assert.equal(visitor.data.selected,null);assert.equal(visitor.data.total,first.data.total);assert.ok(visitorSession.cookie);assert.notEqual(visitorSession.cookie,browser.cookie);
const visitorVote=await call('POST',{room:'garage-barn-door',designId:'garage-08'},base.origin,visitorSession);assert.equal(visitorVote.status,200);assert.equal(visitorVote.data.total,first.data.total+1);assert.equal(visitorVote.data.selected,'garage-08');
const isolated=await call('GET');assert.equal(isolated.data.selected,'garage-07');assert.equal(isolated.data.total,visitorVote.data.total);
const invalid=await call('POST',{room:'garage-barn-door',designId:'front-23'});assert.equal(invalid.status,400);assert.equal(browser.cookie,initialCookie);assert.ok(invalid.setCookie);
const empty=await call('POST',{room:'kitchen',designId:'invented'});assert.equal(empty.status,400);
const cross=await call('POST',{room:'garage-barn-door',designId:'garage-08'},'https://unrelated.invalid');assert.equal(cross.status,403);
console.log('PASS: GET voter initialization, missing-cookie rejection, persisted vote, repeat-vote deduplication, vote changes, visitor isolation, cookie preservation on errors, unknown choices, empty galleries, and cross-origin rejection.');
