import type { LightingGroup, LightingSnapshot } from './lighting-source-model';

const html = (value: string) => value.replace(/[&<>"']/g, character => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[character]!));
const number = (value: number | null) => value === null ? 'Unresolved' : String(value);
function model(value: string | null, quantity: number | null) {
  return value ? html(value) : quantity === 0 ? 'None additional' : 'Model still to confirm';
}
function box(title: string, quantity: number | null, description: string) {
  return `<div class="control-plan-box"><h4>${title}</h4><p class="control-plan-count">${number(quantity)}</p><p>${description}</p></div>`;
}
function circuit(group: LightingGroup) {
  const unknown = [group.loadControllerQty, group.inputModuleQty, group.manualRemoteQty].some(value => value === null);
  const local = group.manualSwitches !== null && group.manualRemoteQty !== null && group.manualSwitches >= group.manualRemoteQty ? group.manualSwitches - group.manualRemoteQty : null;
  const flow = group.inputModuleQty === null ? 'Input arrangement still to confirm' : group.inputModuleQty > 0 ? 'Remote inputs send local network commands to the load controller.' : 'No separate network input module is assigned.';
  const stages = [
    ...(group.manualRemoteQty !== 0 ? [box('Ordinary remote controls', group.manualRemoteQty, 'Manual switches or buttons assigned to remote inputs.')] : []),
    ...(group.inputModuleQty !== 0 ? [box('Input modules', group.inputModuleQty, model(group.inputModuleModel, group.inputModuleQty))] : []),
    box('Load controllers', group.loadControllerQty, model(group.loadControllerModel, group.loadControllerQty)),
    box('Fixtures / loads', group.quantity, html(group.loadType)),
  ];
  return `<article class="control-plan" id="control-plan-${html(group.id)}" aria-labelledby="control-plan-heading-${html(group.id)}">
    <div class="control-plan-title"><h3 id="control-plan-heading-${html(group.id)}">${html(group.id)} · ${html(group.room)}</h3><span>${unknown ? 'Assignments incomplete' : 'Planning configuration'}</span></div>
    <p>${html(group.loadType)} · ${number(group.manualSwitches)} recorded control locations</p>
    <div class="control-plan-flow" style="--control-plan-stages:${stages.length}" aria-label="Control relationship for ${html(group.id)}">${stages.join('<span class="control-plan-arrow" aria-hidden="true">&rarr;</span>')}</div>
    <p class="control-plan-command">${flow} Local control locations assigned to the primary controller: ${number(local)}. A wall dimmer includes its own face control; a module may instead use a separate ordinary local switch.</p>
    <div class="control-plan-foot"><p><strong>Ordinary remotes:</strong> ${number(group.manualRemoteQty)}. <strong>Input modules:</strong> ${number(group.inputModuleQty)}.</p><p><strong>Total primary / input smart devices:</strong> ${number(group.smartDeviceQty)}. ${model(group.smartDeviceModel, group.smartDeviceQty)}</p><p><strong>Additional load relays:</strong> ${number(group.additionalRelayQty)}. ${model(group.additionalRelayModel, group.additionalRelayQty)}</p></div>
    ${group.additionalRelayQty !== null && group.additionalRelayQty > 0 ? '<p class="control-plan-note">The separate power-control stage needs its own load and wiring review; its placement is not specified by this role diagram.</p>' : ''}
  </article>`;
}

/** Logical roles come only from the same approved projection used by the workbook extract. */
export function renderLightingCircuitDiagrams(snapshot: LightingSnapshot): string {
  return `<section class="control-plans" aria-labelledby="control-plans-heading">
    <style>
      .control-plans{margin-top:2.5rem}.control-plan{border:1px solid #c8d0c8;border-radius:12px;padding:1.15rem;margin:1.25rem 0;background:#fff;break-inside:avoid;scroll-margin-top:1rem}.control-plan-title{display:flex;align-items:baseline;justify-content:space-between;gap:1rem}.control-plan-title h3{margin:0}.control-plan-title span{font-size:.8rem;color:#59665c}.control-plan-flow{display:flex;align-items:stretch;gap:.4rem;margin:1rem 0}.control-plan-box{flex:1;min-width:0;border:1px solid #c8d0c8;border-top:4px solid #496b55;border-radius:6px;padding:.8rem;background:#f4f7f2}.control-plan-arrow{align-self:center;font-size:1.3rem;color:#496b55}.control-plan-box h4{font-size:.8rem;margin:0 0 .4rem;color:#35483b}.control-plan-box p{font-size:.85rem;margin:.3rem 0;overflow-wrap:anywhere}.control-plan-box .control-plan-count{font-size:1.5rem;font-weight:700;color:#244632}.control-plan-command,.control-plan-note{font-size:.85rem;color:#526255}.control-plan-foot{border-top:1px solid #dce1d8;padding-top:.6rem}.control-plan-foot p{font-size:.85rem;margin:.35rem 0}@media(max-width:650px){.control-plan-flow{flex-direction:column}.control-plan-arrow{transform:rotate(90deg)}.control-plan-title{display:block}.control-plan-title span{display:block;margin-top:.3rem}}@media print{.control-plan{box-shadow:none;border-radius:0}.control-plan-flow{flex-direction:row}.control-plan-arrow{transform:none}.control-plan-box{background:#fff}.control-plans h2{break-after:avoid}}
    </style>
    <h2 id="control-plans-heading">My circuit control diagrams</h2>
    <p>I use the current workbook assignments below for every listed group. These show device roles and control relationships; conductor routing and electrical connections need a separate installation drawing. An unresolved quantity remains unresolved.</p>
    <p>One load controller may include its own relay or dimming electronics. An i4 is an input module and has no load output. The separate six-location example illustrates that distinction; each group below keeps its own counts.</p>
    ${snapshot.groups.map(circuit).join('\n')}
  </section>`;
}
