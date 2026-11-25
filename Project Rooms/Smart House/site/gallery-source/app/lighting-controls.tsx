'use client';
import { lightingDocuments } from '../lib/lighting-controls';
import type { LightingGroup, LightingSnapshot } from '../lib/lighting-source-model';
import { lightingSourceStatus, refreshLightingSource, type LightingSourceState } from '../lib/lighting-source-client';
import { useLightingSource } from './use-lighting-source';
import './lighting-controls.css';

function count(value:number|null){return value===null?'Unresolved':String(value);}
function subtotal(groups:LightingGroup[],field:'smartDeviceQty'|'additionalRelayQty'|'loadControllerQty'|'inputModuleQty'|'manualRemoteQty'){
  const known=groups.reduce((sum,group)=>sum+(group[field]??0),0),unknown=groups.filter(group=>group[field]===null).length;
  return `${known} recorded${unknown?`; ${unknown} groups unresolved`:''}`;
}
function sourceDate(value:string|null){return value?new Date(value).toLocaleString('en-US',{dateStyle:'medium',timeStyle:'short',timeZone:'UTC'})+' UTC':'Unavailable';}

export function LightingControlsView({source,onRefresh}:{source:LightingSourceState;onRefresh?:()=>void}){
  const {snapshot}=source,t=snapshot.totals;
  const ordinary=snapshot.groups.filter(group=>group.kind==='fixture'),strips=snapshot.groups.filter(group=>group.kind==='strip');
  const recessed=snapshot.groups.find(group=>group.id==='L-011'),perimeter=snapshot.groups.find(group=>group.id==='LS-011');
  function groupTable(groups:LightingGroup[],label:string){return <div className="lighting-table-scroll" tabIndex={0} role="region" aria-label={label}>
    <table><caption>{label}. Proposed quantities; unresolved is different from zero. Scroll across for device roles.</caption><thead><tr><th scope="col">Group</th><th scope="col">Room / load</th><th scope="col">Lights / loads</th><th scope="col">Control locations</th><th scope="col">Load controllers</th><th scope="col">Ordinary remotes</th><th scope="col">Input modules</th><th scope="col">Total smart devices</th><th scope="col">Additional load relays</th></tr></thead>
      <tbody>{groups.map(group=><tr key={group.id}><th scope="row">{group.id}</th><td>{group.room}<br/><span className="lighting-document-date">{group.loadType}</span></td><td>{count(group.quantity)}</td><td>{count(group.manualSwitches)}</td><td>{count(group.loadControllerQty)}<br/><span className="lighting-document-date">{group.loadControllerModel??(group.loadControllerQty===0?'Not required':'Model unresolved')}</span></td><td>{count(group.manualRemoteQty)}</td><td>{count(group.inputModuleQty)}<br/><span className="lighting-document-date">{group.inputModuleModel??(group.inputModuleQty===0?'Not required':'Model unresolved')}</span></td><td>{count(group.smartDeviceQty)}<br/><span className="lighting-document-date">{group.smartDeviceModel??(group.smartDeviceQty===0?'Not required':'Model unresolved')}</span></td><td>{count(group.additionalRelayQty)}<br/><span className="lighting-document-date">{group.additionalRelayModel??(group.additionalRelayQty===0?'None additional':'Model unresolved')}</span></td></tr>)}</tbody>
    </table>
  </div>;}
  return <section className="lighting-guides" aria-labelledby="lighting-controls-heading" data-lighting-revision={snapshot.revision}>
    <h2 id="lighting-controls-heading">My lighting and smart controls</h2>
    <p>I keep my public lighting schedule and Shelly review here. They follow my source workbook, with room assignments and equipment still to confirm.</p>
    <div className="lighting-sync-status" role="status" aria-live="polite">
      <p>{lightingSourceStatus(source)}</p>
      <p>Source updated: <time dateTime={snapshot.sourceModifiedAt??undefined}>{sourceDate(snapshot.sourceModifiedAt)}</time>.</p>
      <p>Published: <time dateTime={snapshot.publishedAt}>{sourceDate(snapshot.publishedAt)}</time>. Last successful source check: {sourceDate(source.sync.lastSuccessAt)}.</p>
      <details className="lighting-version-details"><summary>Source details</summary><p>Reference: {snapshot.revision.slice(0,8)}.</p></details>
      {onRefresh&&<button type="button" className="text-link" disabled={source.checking} onClick={onRefresh}>Check for lighting updates</button>}
    </div>
    <div className="knowledge-grid lighting-document-grid">
      <article id="pondster-own-lighting-schedule" aria-labelledby="lighting-schedule-heading">
        <h3 id="lighting-schedule-heading">My circuit schedule</h3>
        <p>I have {t.ordinaryGroups} ordinary lighting groups and {t.stripZones} strip-lighting zones in this public schedule. Lighting-group IDs describe separate controls; they are not my breaker numbers.</p>
        {recessed&&<p><strong>{recessed.id}:</strong> {recessed.room}; {count(recessed.quantity)} fixture positions, {count(recessed.smartDeviceQty)} total smart devices and {count(recessed.additionalRelayQty)} additional load relays. {perimeter&&<><strong>{perimeter.id}</strong> is the separate strip group.</>}</p>}
        <p>My <strong>Circuit schedule</strong> extract separates load controllers, ordinary manual remotes, input modules and additional load relays. Control locations include the primary local control; ordinary remotes are counted separately. Input modules count as smart devices, not load relays.</p>
        <p><a className="solid-link" href={lightingDocuments.schedule} download="pondster-lighting-public-extract.xlsx">Download my public schedule extract (Excel)</a></p>
        <details className="lighting-zone-details" open><summary>My ordinary lighting groups ({ordinary.length})</summary>{groupTable(ordinary,'Ordinary lighting groups')}</details>
        <details className="lighting-zone-details" open><summary>My LED-strip zones ({strips.length})</summary>{groupTable(strips,'LED-strip zones')}</details>
        {snapshot.groups.some(group=>group.kind==='other')&&<details className="lighting-zone-details"><summary>Other loads still under review</summary>{groupTable(snapshot.groups.filter(group=>group.kind==='other'),'Other loads and unresolved assignments')}</details>}
      </article>
      <article id="pondster-own-shelly-review" aria-labelledby="shelly-review-heading">
        <h3 id="shelly-review-heading">My Shelly controls review</h3>
        <p>A suitable smart load controller may already perform the relay function. I count its integral relay as part of that device, rather than buying it twice.</p>
        <p>Ordinary lighting: <strong>{subtotal(ordinary,'smartDeviceQty')} total smart devices; {subtotal(ordinary,'additionalRelayQty')} additional load relays</strong>. The proposed roles are {subtotal(ordinary,'loadControllerQty')} load controllers and {subtotal(ordinary,'inputModuleQty')} input modules.</p>
        <p>My strip-light proposal records {subtotal(strips,'loadControllerQty')} load controllers, {subtotal(strips,'inputModuleQty')} input modules and {subtotal(strips,'additionalRelayQty')} additional load relays. These quantities depend on the selected controller and input arrangement, not simply the number of wall switches.</p>
        <p>Ordinary manual remotes across all listed loads: {subtotal(snapshot.groups,'manualRemoteQty')}. Those switches are distinct from the primary local control and the smart input modules.</p>
        <p>Across all listed loads, {t.unresolvedSmartDeviceGroups} groups have an unresolved smart-device quantity and {t.unresolvedAdditionalRelayGroups} have an unresolved additional-relay quantity. Unknown stock quantities are separate from these requirements.</p>
        <p><a className="solid-link" href={lightingDocuments.review} target="_blank" rel="noopener noreferrer">Read my current Shelly review</a></p>
      </article>
    </div>
    <p>These are planning subtotals, not confirmation of installed equipment or final purchases. Room coverage, wiring, fixture compatibility and stock on hand still need reconciliation. The public extract is read-only and does not operate my lights or breakers.</p>
  </section>;
}

export default function LightingControls({snapshot}:{snapshot?:LightingSnapshot}={}){
  const live=useLightingSource(!snapshot),source=snapshot?{...live,snapshot}:live;
  return <LightingControlsView source={source} onRefresh={snapshot?undefined:()=>{void refreshLightingSource(true);}}/>;
}
