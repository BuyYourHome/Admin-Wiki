# Pond Street Shelly switch and relay review

Prepared November 24, 2026 in Smart House. Status: review-ready planning list, with unresolved quantities shown explicitly. This is not a purchase order or a wiring diagram.

Wes requested a smart controller for every independently controlled lighting group, retaining inexpensive manual wall switches where appropriate. He then confirmed, “all this work should be part of the smart house.” This review belongs to Smart House. The LED lighting room and its source workbook remain unchanged; this packet records the current source proposal, manufacturer corrections and remaining whole-house coverage.

## What the list currently accounts for

The October 23 workbook assigns **14 ordinary lighting groups plus eight LED-strip zones**. Its arrangement calls for **27 smart relays, 12 Shelly Plus RGBW PM controllers and one GLEDOPTO stair controller**. Some strip zones need multiple branches, which explains why 22 lighting groups produce more than 22 relays.

Those are **assigned-plan subtotals**. Exterior, basement, foyer and other loads identified in November have not all been reconciled to that plan. Quantities already owned were never recorded, so the net quantity to buy is unknown. Do not treat a photographed model as proof that only one is owned.

| Function | Existing proposed quantity | Current selection / purchasing treatment |
| --- | ---: | --- |
| Smart relay for ordinary fixture groups | 14 | One relay per listed group. Current candidate: Shelly 1 Gen4 **UL-certified US variant**, subject to exact unit rating and load review. The workbook names the discontinued Plus 1 UL. |
| Smart relay for assigned strip-controller branches | 13 | Workbook architecture: 12 relays switch analog-controller DC power; one switches the stair supply's AC input. Preserve as a source proposal; review the alternative below before ordering. |
| Analog white-strip controller | 12 | Shelly Plus RGBW PM, 12/24 VDC. Existing proposal retained; exact installation acceptance and channel/load mapping unresolved. |
| Addressable stair controller | 1 | GLEDOPTO GL-C-015WL-D identified in the earlier photos. Confirm the actual label, firmware and stock count before reuse. |
| Ordinary single-pole wall switches, evidenced subtotal | 12 | Seven for ordinary fixture groups plus five for strip zones. Two strip zones have unresolved switch counts. |
| Ordinary three-way wall switches, evidenced subtotal | 16 | Fourteen for ordinary groups plus two provisionally assigned to kitchen strips. |
| Ordinary four-way wall switches, evidenced subtotal | 2 | One each for hall and pantry three-location arrangements. |
| Accessible control enclosures | 9 provisional | Existing workbook allowance, not a final enclosure count; separation of mains and low-voltage equipment may require more. |
| Load suppression / contactors where required | Unresolved | Determine from the selected relay and actual driver, supply or fan; no universal allowance added. |
| LED power supplies, protection, connectors and wiring | Not finalized here | Controller counts do not establish supply or protection quantities. Strip lengths, inrush, routes and equipment acceptance remain unresolved. |

**Manual-switch subtotal: 30 evidenced/provisionally allocated devices**, plus the unresolved bathroom strip stations and the whole-house gaps below. These are switch devices, not box or gang counts. A smart relay is additional to those ordinary switches; it can sit at an approved accessible control location rather than replacing a wall switch.

## Multi-location switching

Yes: one smart relay can serve a lighting group controlled from several ordinary wall stations. With three wall locations, the conventional arrangement is **two three-way switches and one four-way switch**, plus the Shelly controller. Two locations normally need two three-way switches; four locations normally need two three-way and two four-way switches.

The planning requirement is that the Shelly stays powered and the manual switch network operates its input. Shelly documents Edge/flip input behavior, which toggles the output when the input changes. A relay module is not a drop-in three-way/SPDT switch. The existing line, neutral, travelers and load locations must support the selected arrangement; this packet does not establish that wiring. [Shelly switch behavior](https://shelly-api-docs.shelly.cloud/gen2/ComponentsAndServices/Switch/), [Plus 1 interface guide](https://www.shelly.com/blogs/documentation/shelly-plus-1-web-interface-guide).

Count **independently controlled lighting groups**, not breaker handles, wall locations or individual fixtures. Breaker 16 serves several separately operated loads. One module on that entire breaker would not meet the room-by-room requirement.

## Ordinary lighting groups in the current workbook

Each row currently allocates one smart relay. The names and fixture counts are the workbook's proposed grouping, not confirmation of installed loads or wiring. “Guest bath” is the workbook's wording and needs reconciliation with the site's Hall Bath naming.

| Workbook ID | Group | Fixtures | Manual switches currently allocated | Smart relay functions |
| --- | --- | ---: | --- | ---: |
| L-003 | Walk-in closet | 1 | 1 single-pole | 1 |
| L-004 | Master bath main / vanity | 3 | 1 single-pole | 1 |
| L-006 | Master bath toilet-room fan / light | 1 | 2 three-way | 1, subject to motor/load suitability |
| L-007 | Guest bath main / tub / vanity | 3 | 1 single-pole | 1 |
| L-008 | Guest bath toilet room | 1 | 1 single-pole | 1 |
| L-009 | Hall / bedroom corridor | 6 | 2 three-way + 1 four-way | 1 |
| L-010 | Spiral stair center pendant | 1 | 2 three-way | 1 |
| L-011 | Living-room recessed lights | 4 | 2 three-way | 1 |
| L-012 | Kitchen recessed lights | 6 | 2 three-way | 1 |
| L-013 | Dining lights | 4 | 1 single-pole | 1 |
| L-014 | Pantry lights | 3 | 2 three-way + 1 four-way | 1 |
| L-015 | Laundry lights | 2 | 2 three-way | 1 |
| L-016 | Existing garage lights | 4 | 1 single-pole | 1 |
| L-017 | New garage lights | 7 | 1 single-pole | 1 |
| **Subtotal** | **14 groups** | **46** | **7 single-pole + 14 three-way + 2 four-way** | **14** |

The 46 fixtures reconcile to 42 recessed fixtures, one vanity fixture, one LED panel, one pendant and one integrated fan/light. A lighting relay is not a fan-speed controller. A combined fan/light may need separate control functions if its loads are intended to operate separately.

## LED-strip zones in the current workbook

The newer workbook uses a **12 V strip basis**, superseding the September 24 V draft. Lengths and wattages below are allowances. Controller splits come from the workbook's approximately 94 W branch budget, not from measured final runs.

| Workbook ID | Zone | Allowance W | Strip controllers | Relay functions in source proposal | Manual station evidence |
| --- | --- | ---: | --- | ---: | --- |
| LS-001 | Master bedroom perimeter | 118.8 | 2 RGBW PM | 2 | 1 single-pole, provisional |
| LS-005 | Master bath / niche / mirror | 109.2 | 2 RGBW PM | 2 | Unresolved |
| LS-007 | Guest bath shelves / vanity | 32.4 | 1 RGBW PM | 1 | Unresolved |
| LS-010 | Spiral stair treads | 142.6464 | 1 GLEDOPTO | 1 | 1 single-pole, provisional |
| LS-011 | Living-room perimeter | 145.8 | 2 RGBW PM | 2 | 1 single-pole, provisional |
| LS-012 | Kitchen cabinets / island | 91.8 | 1 RGBW PM | 1 | 2 stations; three-way interpretation provisional |
| LS-018 | Bedroom 1 perimeter | 108 | 2 RGBW PM | 2 | 1 single-pole, provisional |
| LS-019 | Bedroom 2 perimeter | 108 | 2 RGBW PM | 2 | 1 single-pole, provisional |
| **Subtotal** | **8 zones** | **856.6464** | **12 RGBW PM + 1 GLEDOPTO** | **13** | **5 single-pole + 2 three-way evidenced; two zones unresolved** |

L-012 and LS-012 are separate lighting groups. L-007 and LS-007 are also separate; similar numbers do not mean they share switches. All branches within one strip zone need coordinated manual and automation behavior.

The source architecture keeps the smart relays powered while switching the strip-controller supply. It proposes power-on ON behavior at the analog controllers. Shelly documents power-restoration choices, but that does not prove the installed assembly will resume at the desired brightness, delay or group state. Those behaviors require a representative bench test. The RGBW PM's published limit is 4 A per output and 10 A total; do not parallel PWM outputs. [RGBW PM specifications](https://kb.shelly.cloud/knowledge-base/shelly-plus-rgbw-pm), [power-restoration settings](https://www.shelly.com/blogs/documentation/shelly-plus-rgbw-pm-web-interface-guide).

The stair branch is different: addressable tread animation uses the GLEDOPTO, and its source allowance is about 143 W / 11.9 A at 12 V. The workbook therefore switches the dedicated supply's AC input rather than putting that whole DC load through a 10 A relay. Actual supply inrush and controller/injection limits still need confirmation.

## Manufacturer corrections and equipment already identified

Manufacturer pages checked November 24, 2026. The following models were identified in the earlier photo review; **all owned quantities remain unknown**. A proposed model in the workbook is not evidence that it has been purchased.

| Identified equipment | Useful role | Treatment in this list |
| --- | --- | --- |
| Shelly 1PM Gen3 | On/off control and metering for suitable loads | Conditional reuse for an ordinary lighting group after exact unit/load acceptance. It has no potential-free output. Contrary to an older worksheet statement, it accepts AC **or 24–30 VDC** supply; an AC-powered 1PM cannot replace a dry-contact relay switching an independent 12 V bus. [Official specifications](https://kb.shelly.cloud/knowledge-base/shelly-1pm-gen3). |
| Shelly Plus i4, AC model | Four wall-command inputs | No load relay. Optional scene/input device; not required at every wall station in the direct-input proposal. [Official specifications](https://kb.shelly.cloud/knowledge-base/shelly-plus-i4). |
| Shelly Plus Wall Dimmer | A compatible dimmable AC lighting group | Potential substitution, not an additional relay by default. Rated for 100–120 VAC and up to 150 W compatible dimmable LED/CFL; not for direct 12 V strip control or fan speed. Multi-location compatibility must be checked separately. [Official specifications](https://kb.shelly.cloud/knowledge-base/shelly-plus-wall-dimmer). |
| Shelly BLU RC Button 4 US ZB | Optional extra scene-control locations | Retain for future locations rather than counting one at every existing wired station. Actual owned variant and integration must be confirmed. |
| Shelly BLU Motion | Optional occupancy input | Sensor, not a lighting-load controller. No quantity assigned. Stair direction and latency remain to be demonstrated. |
| GLEDOPTO GL-C-015WL-D | Proposed addressable stair controller | Existing stair function may use owned equipment; exact count and suitability still unverified. |
| C01W | Possible analog-strip controller | No substitution credited: manufacturer, local-control interface and compatibility are unverified. |

The Plus RGBW PM and Plus 1 UL appear in the proposed schedule but are not established as owned stock.

**Relay model update:** the former Plus 1 UL is discontinued. The current candidate for new dry-contact relay purchases is the **Shelly 1 Gen4 UL-certified US variant**. Its US product page has a 15 A title but a generic 16 A/EU model table; the supplied US label and installation documentation must resolve that discrepancy before an order or final load assignment. Do not substitute a generic non-UL model by name alone. [Discontinued Plus 1 UL listing](https://us.shelly.com/products/shelly-plus-1-ul-certified), [current Gen4 UL US listing](https://us.shelly.com/products/shelly-1-gen4-ul-certified).

The earlier Plus 1 UL documentation specifies potential-free contacts and 15 A AC / 10 A DC limits. Those legacy values do not automatically establish the successor's installation limits. LED-driver, supply and fan loads also require inrush/load review; steady-state watts alone are insufficient. [Legacy relay specifications](https://kb.shelly.cloud/knowledge-base/shelly-plus-1-ul).

That documentation calls for an RC snubber with inductive loads, including LED drivers and fans. Resolve the selected load's suppression or contactor needs from its own instructions; leave the accessory quantity open and do not copy an AC snubber recommendation indiscriminately to switched DC branches.

US installation approval of the Plus RGBW PM, the decoupler below and the exact owned controllers was not established from the manufacturer documents reviewed. Published EU/UK/AU declarations do not establish US UL/NRTL listing. This is an equipment-selection gap for the review, not a claim that the products are prohibited.

## An alternative worth reviewing before ordering strip relays

Shelly's **120 V Decoupler**, available in one- and four-channel versions, is documented as compatible with the Plus RGBW PM. It isolates a wall-switch signal into a low-voltage control input. It is neither a smart controller nor a lighting-load relay. [Official decoupler documentation](https://us.shelly.com/blogs/documentation/shelly-1-channel-decoupler-120v-shelly-4-channel-decoupler-120v).

Planning inference: this could let the RGBW PM stay powered for automation while ordinary switches operate its attached inputs, avoiding controller reboot whenever a light is turned on. The RGBW PM already supplies the smart function; a second smart relay might not be needed on every analog branch.

**No quantity reduction is made yet.** In Light profile, RGBW PM has separately attached inputs for its four outputs, and some zones span two controllers. The required isolated input channels and same-zone switching must be mapped before choosing one- versus four-channel decouplers or removing the 12 analog-branch relays. Do not assume one decoupler drives several devices or all their inputs. This alternative does not establish compatibility with the separate GLEDOPTO stair arrangement. [RGBW PM input behavior](https://kb.shelly.cloud/knowledge-base/shelly-plus-rgbw-pm-web-interface-guide).

## Whole-house coverage still to reconcile

These loads are present in the newer private breaker notes or were left unassigned in the workbook. They belong in the final whole-house control list, but additional relay quantities would be guesses until their independently switched groups are identified.

| Load / location | Existing evidence | Schedule treatment |
| --- | --- | --- |
| Garage outdoor lights | Breaker 4 | Add control-group mapping; not established as the indoor garage groups. |
| Front exterior light | Breaker 1 | Identify its switch group and load; do not combine with all living-room loads. |
| Backyard outdoor lights | Breaker 16 | Identify group count and load. |
| Foyer light | Breaker 1 | Determine whether already represented by a workbook group. |
| Light in front of stairs | Breaker 16 | Reconcile to hall/stair group before counting another relay. |
| Office fan and lights | Breaker 16 | Identify separate fan/light commands and appropriate load controls. |
| Basement recessed lights | Breaker 8, also serving sump pump | Map lighting groups; keep sump-pump supply outside the lighting-control function. |
| Right kitchen light | Added to breaker 16 on November 23 | Determine whether included in L-012 or a separate group. No confirmed left-kitchen-light assignment exists. |
| Back bedrooms 2 and 3 lights | Breaker 16 | Reconcile room numbering to workbook Bedrooms 1 and 2; do not automatically duplicate or merge them. |
| Master Bath fan | Breaker 16 | Reconcile to L-006 integrated fan/light; avoid double-counting the same fan. |
| Bedroom fan light kits | L-018 / L-019 fan groups unassigned | Confirm whether light kits exist and require separate controls. |
| Master-bedroom foyer switched receptacles | L-002, no relay assigned | Determine actual lamp/load purpose; exclude general receptacle loads from a lighting-only relay assumption. |
| TV accents / arch and shelves / optional closet strips | Unassigned in workbook | Confirm included scope, independent zones, strip type and loads; excluded from the subtotals above. |

## What is needed to turn this into the final purchase list

1. Count the actual stock by exact model and US certification label. Then calculate net purchases as approved requirement minus suitable reusable stock; do not deduct an unknown quantity.
2. Walk through each independent light group and each physical switch station. Reconcile the coverage table, bathroom strip switches and room numbering.
3. Resolve analog-strip control architecture: source power-switched proposal versus continuously powered controllers with isolated inputs. Bench-check manual operation with Wi-Fi/HA unavailable, automation from OFF, power recovery, brightness and synchronized branches. The stair sequence needs its own top/bottom-sensor and recovery test.
4. Confirm fixture/driver loads, supply inrush, fan separation, neutral/traveler availability, enclosure space and exact equipment acceptance with the responsible installer before fixing quantities and SKUs. No final conductor, fuse, box-fill or terminal design is provided here.

The planning list and uncertainty register are complete for the records currently available. The physical stock count and unrecorded switch groups prevent an honest final whole-house net shopping quantity.

## Source record

- Current workbook: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\26-BYH -908 Pond St\Owning\Planning\908-Pond-Electrical-Circuit-Schedule.xlsx`, modified October 23, 2026; SHA-256 `8c3750aaa51628456b13380f5a4f485442fad0982203140263d64026ea75b6d4`. Read-only audit of `Control specifications`, `Circuit schedule`, `Strip equipment` and `12V LED loads`; no recalculation or source edits.
- Later field labels: [[Project Rooms/Smart House/working/electrical-circuit-labels]], through November 23. A breaker label is not an independent lighting-zone map.
- Earlier model/photo inventory: [[Project Rooms/LED lighting/outputs/908-pond-lighting-specification]], read-only. Its 56-position / 24 V draft does not override the newer workbook.
- Older eight-controller/eight-relay minimum, one-controller-per-zone wording and 30 W control overhead remain stale in parts of the workbook. This packet uses the later detailed branch rows, not those older summaries. Current 46-fixture arithmetic does reconcile; historical discrepancy notes are not new errors.
- Work retained in Smart House under Wes's November 24 instruction. No LED lighting files, source workbook, Home Assistant configuration or public site changed.
