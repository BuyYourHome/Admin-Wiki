import assert from 'node:assert/strict';
const base = new URL(process.argv[2] ?? 'http://127.0.0.1:19081');
if (!['127.0.0.1','localhost'].includes(base.hostname)) throw new Error('Write tests are restricted to a local preview.');
const browser={cookie:''};
async function call(method,body,origin=base.origin,session=browser,room='garage-barn-door'){
 const response=await fetch(new URL(`/api/votes?room=${encodeURIComponent(room)}`,base),{method,headers:{...(method==='POST'?{'Content-Type':'application/json',Origin:origin}:{}),...(session?.cookie?{Cookie:session.cookie}:{})},...(body?{body:JSON.stringify(body)}:{})});
 const set=response.headers.get('set-cookie');if(set&&session)session.cookie=set.split(';')[0];
 const text=await response.text(),type=response.headers.get('content-type')??'';
 // Vite can reject this deliberate cross-origin probe before the JSON route runs.
 const middlewareForbidden=method==='POST'&&origin!==base.origin&&response.status===403&&/^text\/plain\b/i.test(type)&&text.trim()==='Forbidden';
 if(middlewareForbidden)return {status:response.status,data:{error:'Forbidden'},setCookie:set};
 assert.match(type,/\bapplication\/(?:[a-z0-9.+-]+\+)?json\b/i,`Expected JSON for ${method} ${room}; received HTTP ${response.status}: ${text.slice(0,120)}`);
 return {status:response.status,data:JSON.parse(text),setCookie:set};
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
const bathBefore=await call('GET',null,base.origin,browser,'master-bath');assert.equal(bathBefore.status,200);assert.equal(bathBefore.data.selected,null);
for(const designId of ['bath-warm-ivory','bath-dusty-blue','bath-deep-navy','bath-forest-green','bath-mushroom-taupe','bath-muted-terracotta']){
 const saved=await call('POST',{room:'master-bath',designId});assert.equal(saved.status,200,`The Master Bath allowlist accepts ${designId}`);assert.equal(saved.data.selected,designId);assert.equal(saved.data.total,bathBefore.data.total+1,'Changing the bath color keeps one vote in this browser.');
}
const bathStored=await call('GET',null,base.origin,browser,'master-bath');assert.equal(bathStored.data.selected,'bath-muted-terracotta');
const baseline=await call('POST',{room:'master-bath',designId:'bath-sage-baseline'});assert.equal(baseline.status,400,'The baseline is not a seventh vote.');
const wrongRoom=await call('POST',{room:'master-bath',designId:'media-01'});assert.equal(wrongRoom.status,400);
const garageStillStored=await call('GET');assert.equal(garageStillStored.data.selected,'garage-07','Bath votes do not alter a garage choice.');
console.log('PASS: GET voter initialization, missing-cookie rejection, persisted vote, repeat-vote deduplication, vote changes, visitor isolation, cookie preservation on errors, six Master Bath choices, baseline/cross-gallery rejection, unknown choices, empty galleries, and cross-origin rejection.');
