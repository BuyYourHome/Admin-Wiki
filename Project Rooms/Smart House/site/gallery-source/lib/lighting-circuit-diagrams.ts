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
  const proBlu = group.kind === 'strip' && /Pro\s+RGBWW\s*PM/i.test(group.loadControllerModel ?? '') && /BLU/i.test(group.inputModuleModel ?? '');
  const unknown = [group.loadControllerQty, group.inputModuleQty, group.manualRemoteQty].some(value => value === null) || (proBlu && (group.pwmOutputQty === null || !group.pwmOutputPlan));
  const local = group.manualSwitches !== null && group.manualRemoteQty !== null && group.manualSwitches >= group.manualRemoteQty ? group.manualSwitches - group.manualRemoteQty : null;
  const flow = group.inputModuleQty === null ? 'Input arrangement still to confirm' : group.inputModuleQty > 0 ? 'Remote inputs send local network commands to the load controller.' : 'No separate network input module is assigned.';
  const stages = [
    ...(group.manualRemoteQty !== 0 ? [box('Ordinary remote controls', group.manualRemoteQty, 'Manual switches or buttons assigned to remote inputs.')] : []),
    ...(group.inputModuleQty !== 0 ? [box('Input devices / wall stations', group.inputModuleQty, model(group.inputModuleModel, group.inputModuleQty))] : []),
    box('Load controllers', group.loadControllerQty, model(group.loadControllerModel, group.loadControllerQty)),
    box('Fixtures / loads', group.quantity, html(group.loadType)),
  ];
  const topology = proBlu ? `<div class="control-plan-parallel" data-control-topology="parallel-blu-native" aria-label="Two independent control paths into the same powered Pro">
    <div class="control-plan-paths">
      <div class="control-plan-path" data-control-path="bluetooth">${box('Bluetooth wall station', group.inputModuleQty, model(group.inputModuleModel, group.inputModuleQty))}<p class="control-plan-path-label">Bluetooth commands &rarr; same Pro</p></div>
      <div class="control-plan-path" data-control-path="native-manual">${box('Wired ordinary manual switch', group.manualRemoteQty, 'Separate low-voltage control input native to the Pro; not wired through the BLU station.')}<p class="control-plan-path-label">Native low-voltage input &rarr; same Pro</p></div>
    </div>
    <div class="control-plan-target">${box('Shared load controllers', group.loadControllerQty, model(group.loadControllerModel, group.loadControllerQty))}<p class="control-plan-path-label">Pro performs the PWM dimming.</p></div>
    <div class="control-plan-outputs">${box('Assigned separate PWM outputs', group.pwmOutputQty, group.pwmOutputPlan ? html(group.pwmOutputPlan) : 'Output allocation is unresolved.')}<p class="control-plan-path-label">PWM outputs &rarr; strips</p>${box('Strip loads / runs', group.quantity, html(group.loadType))}</div>
  </div>` : `<div class="control-plan-flow" data-control-topology="ac-input-network" style="--control-plan-stages:${stages.length}" aria-label="Control relationship for ${html(group.id)}">${stages.join('<span class="control-plan-arrow" aria-hidden="true">&rarr;</span>')}</div>`;
  return `<article class="control-plan" id="control-plan-${html(group.id)}" aria-labelledby="control-plan-heading-${html(group.id)}">
    <div class="control-plan-title"><h3 id="control-plan-heading-${html(group.id)}">${html(group.id)} · ${html(group.room)}</h3><span>${unknown ? 'Assignments incomplete' : 'Planning configuration'}</span></div>
    <p>${html(group.loadType)} · ${number(group.manualSwitches)} recorded control locations</p>
    ${topology}
    <p class="control-plan-command">${proBlu ? 'The Bluetooth station and wired ordinary switch are parallel control paths into the same powered Pro. Both controls must coordinate every source-assigned PWM output; verify that mapping before use. Never parallel PWM outputs.' : `${flow} Local control locations assigned to the primary controller: ${number(local)}. A wall dimmer includes its own face control; a module may instead use a separate ordinary local switch.`}</p>
    ${proBlu ? `<p class="control-plan-note">This allocation assumes single-color, single-channel constant-voltage analog strips at the source-stated ${number(group.voltage)} V DC. Actual strip type and physical runs still need confirmation; an RGB or CCT choice needs a new channel allocation.</p>` : ''}
    ${group.kind === 'strip' && !proBlu ? `<p class="control-plan-note"><strong>PWM output allocation:</strong> ${number(group.pwmOutputQty)}. ${group.pwmOutputPlan ? html(group.pwmOutputPlan) : group.pwmOutputQty === 0 ? 'Not applicable to this arrangement.' : 'Output plan remains unresolved.'}</p>` : ''}
    <div class="control-plan-foot"><p><strong>Ordinary manual controls:</strong> ${number(group.manualRemoteQty)}. <strong>Input devices / wall stations:</strong> ${number(group.inputModuleQty)}.</p><p><strong>Total primary / input smart devices:</strong> ${number(group.smartDeviceQty)}. ${model(group.smartDeviceModel, group.smartDeviceQty)}</p><p><strong>Additional load relays:</strong> ${number(group.additionalRelayQty)}. ${model(group.additionalRelayModel, group.additionalRelayQty)}</p></div>
    ${group.additionalRelayQty !== null && group.additionalRelayQty > 0 ? '<p class="control-plan-note">The separate power-control stage needs its own load and wiring review; its placement is not specified by this role diagram.</p>' : ''}
  </article>`;
}

/** Logical roles come only from the same approved projection used by the workbook extract. */
export function renderLightingCircuitDiagrams(snapshot: LightingSnapshot): string {
  return `<section class="control-plans" aria-labelledby="control-plans-heading">
    <style>
      .control-plans{margin-top:2.5rem}.control-plan{border:1px solid #c8d0c8;border-radius:12px;padding:1.15rem;margin:1.25rem 0;background:#fff;break-inside:avoid;scroll-margin-top:1rem}.control-plan-title{display:flex;align-items:baseline;justify-content:space-between;gap:1rem}.control-plan-title h3{margin:0}.control-plan-title span{font-size:.8rem;color:#59665c}.control-plan-flow{display:flex;align-items:stretch;gap:.4rem;margin:1rem 0}.control-plan-box{flex:1;min-width:0;border:1px solid #c8d0c8;border-top:4px solid #496b55;border-radius:6px;padding:.8rem;background:#f4f7f2}.control-plan-arrow{align-self:center;font-size:1.3rem;color:#496b55}.control-plan-box h4{font-size:.8rem;margin:0 0 .4rem;color:#35483b}.control-plan-box p{font-size:.85rem;margin:.3rem 0;overflow-wrap:anywhere}.control-plan-box .control-plan-count{font-size:1.5rem;font-weight:700;color:#244632}.control-plan-command,.control-plan-note{font-size:.85rem;color:#526255}.control-plan-foot{border-top:1px solid #dce1d8;padding-top:.6rem}.control-plan-foot p{font-size:.85rem;margin:.35rem 0}.control-plan-parallel{display:grid;grid-template-columns:minmax(0,1fr) minmax(0,1fr) minmax(0,1.3fr);gap:.75rem;margin:1rem 0;align-items:center}.control-plan-paths{display:grid;gap:.8rem}.control-plan-path-label{font-size:.85rem;font-weight:600;color:#354f41;margin:.4rem 0}.control-plan-target,.control-plan-outputs{min-width:0}@media(max-width:650px){.control-plan-flow{flex-direction:column}.control-plan-parallel{grid-template-columns:minmax(0,1fr)}.control-plan-arrow{transform:rotate(90deg)}.control-plan-title{display:block}.control-plan-title span{display:block;margin-top:.3rem}}@media print{.control-plan{box-shadow:none;border-radius:0}.control-plan-flow{flex-direction:row}.control-plan-parallel{grid-template-columns:repeat(3,minmax(0,1fr))}.control-plan-arrow{transform:none}.control-plan-box{background:#fff}.control-plans h2{break-after:avoid}}
    </style>
    <h2 id="control-plans-heading">My circuit control diagrams</h2>
    <p>I use the current workbook assignments below for every listed group. These show device roles and control relationships; conductor routing and electrical connections need a separate installation drawing. An unresolved quantity remains unresolved.</p>
    <p>One load controller may include its own relay or dimming electronics. An i4 is an input module; a BLU station sends Bluetooth commands. Neither is another load relay. The separate AC and 12-volt LED examples illustrate different arrangements; each group below keeps its own source counts and output allocation.</p>
    ${snapshot.groups.map(circuit).join('\n')}
  </section>`;
}
