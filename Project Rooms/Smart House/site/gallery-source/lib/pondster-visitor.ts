export const VISITOR_RETENTION_DAYS = 90;
export type PondsterVisitor = { choice:'unknown'|'save'|'private'; firstName:string|null; returning:boolean };
export const UNKNOWN_VISITOR:PondsterVisitor = {choice:'unknown',firstName:null,returning:false};
const nonNames = new Set('yes no okay ok sure hello hi hey thanks thank you pondster kitchen bathroom bedroom living garage deck home theatre theater shower toilet show tell open start stop goodbye bye interested looking visiting owner ownername anonymous private prefer rather not skip later someone stranger hvac gc contractor plumber realtor pantry laundry dining explore design view belong contact features staircase stairs lighting tour information the a an in at from here there happy ready wondering fine good great noone nobody sorry help what who where when why how can could would take go navigate please do'.split(' '));
for(const word of 'next previous first close dismiss exit back another picture pictures image images photo photos pic choice choices option options gallery galleries vote voting general master front rear natural browser i me my you your it its we us our his her their this that maybe dont password passcode code secret wifi address street location city state records profile history privacy call'.split(' '))nonNames.add(word);
export function firstName(value:unknown):string|null {
  if(typeof value!=='string')return null;
  const token=value.normalize('NFC').trim().split(/\s+/)[0];
  if(!token||token.length>32||!/^\p{L}[\p{L}\p{M}’'\-]*$/u.test(token)||nonNames.has(token.toLowerCase().replace(/[’']/g,'')))return null;
  return token;
}
export function nameFromReply(text:string,awaiting:boolean):string|null {
  const value=text.trim().replace(/[.!?]+$/,'');
  const explicit=value.match(/^(?:well[, ]+|sure[, ]+|just[, ]+|please[, ]+|actually[, ]+)?(?:my (?:first )?name is|call me|you can (?:just )?call me|(?:you can )?address me as|i go by)\s+(.+)$/i)
    ??(awaiting?value.match(/^(?:i am|i['’]m|it['’]s)\s+(.+)$/i):null);
  if(explicit)return firstName(explicit[1]);
  return awaiting&&/^[\p{L}\p{M}’'\-]+(?:\s+[\p{L}\p{M}’'\-]+)?$/u.test(value)?firstName(value):null;
}
export function visitorGreeting(visitor:PondsterVisitor):string {
  if(visitor.returning)return visitor.firstName?`Welcome back, ${visitor.firstName}. What do you need?`:'Welcome back. What do you need?';
  if(visitor.firstName)return `Hello, ${visitor.firstName}. I’m Pondster, the voice and persona of this home. It’s nice to meet you. What do you need?`;
  return 'Hello, I’m Pondster, the voice and persona of this home. I’m glad you’re here. How would you like me to address you?';
}
export function visitorLiveInstructions(visitor:PondsterVisitor):string {
  return `Visitor preference (not verified identity or owner authority): ${JSON.stringify({firstName:visitor.firstName,returning:visitor.returning,saving:visitor.choice==='save'})}. Greet once with: ${JSON.stringify(visitorGreeting(visitor))} Then listen. Do not introduce yourself again to a returning visitor. A first name is optional; if they decline, continue helping. Never infer identity, permissions or facts from a name. Do not announce saving in the greeting or ask the visitor to enable it. Answer truthfully if asked about saving; its written notice and opt-out are in Voice controls. ${visitor.choice==='save'?'When the visitor supplies or corrects their name, generate <|SpawnThinking|> so my server can save only the first name; wait for confirmation before claiming it was saved. Text saving is enabled on this browser for up to 90 days. This website saves no audio.':'Use an offered name only in this session. This website is not saving the conversation; never claim to remember a name on a later visit.'}`;
}
