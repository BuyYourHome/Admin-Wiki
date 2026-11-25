import { LIGHTING_SEED_SNAPSHOT } from './lighting-source-fallback';
import { validateProjection, type LightingSnapshot } from './lighting-source-model';

export type LightingSync = {status:'seed'|'current'|'stale'|'error';lastCheckedAt:string|null;lastSuccessAt:string|null};
export type LightingSourceState = {snapshot:LightingSnapshot;sync:LightingSync;checking:boolean;failed:boolean};
const seedState:LightingSourceState={snapshot:LIGHTING_SEED_SNAPSHOT,sync:{status:'seed',lastCheckedAt:null,lastSuccessAt:null},checking:false,failed:false};
let state=seedState;
let inFlight:Promise<LightingSourceState>|null=null;
let attemptedAt=0;
const listeners=new Set<()=>void>();

export function getLightingSourceState(){return state;}
export function getLightingServerState(){return seedState;}
export function subscribeLightingSource(listener:()=>void){listeners.add(listener);return()=>{listeners.delete(listener);};}
function update(next:LightingSourceState){state=next;for(const listener of listeners)listener();}
function date(value:unknown){return typeof value==='string'&&value.length<=64&&Number.isFinite(Date.parse(value))?value:null;}
function syncState(value:unknown):LightingSync {
  const sync=value&&typeof value==='object'?value as Record<string,unknown>:{};
  return {status:['seed','current','stale','error'].includes(String(sync.status))?sync.status as LightingSync['status']:'error',lastCheckedAt:date(sync.lastCheckedAt),lastSuccessAt:date(sync.lastSuccessAt)};
}

/** One read-only request shared by Belong and all typed/browser-voice consumers. */
export function refreshLightingSource(force=false):Promise<LightingSourceState>{
  if(inFlight)return inFlight;
  if(!force&&attemptedAt&&Date.now()-attemptedAt<5000)return Promise.resolve(state);
  attemptedAt=Date.now();update({...state,checking:true});
  const controller=new AbortController(),timeout=setTimeout(()=>controller.abort(),8000);
  const task=(async()=>{
    try{
      const response=await fetch('/api/lighting',{cache:'no-store',signal:controller.signal});
      if(!response.ok)throw new Error('Lighting reference unavailable.');
      const result=await response.json() as {snapshot?:unknown;sync?:unknown};
      const snapshot=validateProjection(result.snapshot),sync=syncState(result.sync);
      update({snapshot,sync,checking:false,failed:sync.status==='error'});
    }catch{
      // Keep the last good revision. Neither a timeout nor invalid source data may replace it.
      update({...state,checking:false,failed:true,sync:{...state.sync,status:state.sync.status==='seed'?'seed':'error'}});
    }finally{clearTimeout(timeout);}
    return state;
  })();
  inFlight=task;
  void task.finally(()=>{if(inFlight===task)inFlight=null;});
  return task;
}

export function lightingSourceStatus(value:LightingSourceState):string {
  if(value.checking)return 'Checking for the latest public lighting update.';
  if(value.failed)return value.sync.status==='seed'?'The latest check is unavailable. I’m showing a saved planning copy; it may be out of date.':'The latest check is unavailable. I’m keeping the last successfully loaded public version.';
  if(value.sync.status==='current')return 'The latest successful source check is available.';
  if(value.sync.status==='stale')return 'A newer source check is pending or unavailable. I’m showing the last successfully published version.';
  return 'I’m showing a saved planning copy while I check for updates.';
}
