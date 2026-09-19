# 908 Pond Str Lighting Specification

Draft for Wes's review, 2026-09-18. This is a planning specification, not purchase or installation approval.

## Authoritative Inputs

- Wes's direct typed and voice instructions in the LED lighting task on 2026-09-18.
- House plan: `C:\Users\wesbr\Downloads\Proposed 9.pdf`, one page, with area revision dates 8/26/26, 8/29/26 and 9/18/26. Northern new-garage geometry is clipped.
- Seven supplied photographs identify GLEDOPTO GL-C-015WL-D, C01W, Shelly BLU RC Button 4 US ZB, Shelly Plus i4, Shelly BLU Motion, Shelly Plus Wall Dimmer and Shelly 1PM Gen3. Quantities owned are not established.
- Workbook: `908-Pond-Str-Lighting-and-Controls-Review.xlsx`, delivered as the attachment to `DRAFT: 908 Pond Str lighting and Shelly controls - review spreadsheet`. The attachment in OfficeAssist Sent Items is the retained review copy; no binary deliverable is stored in Git.

## Confirmed Requirements

| Area | Requirement |
| --- | --- |
| Power equipment | Pantry far-right wall, where the breakers are located. Confirm enclosure space, breaker access, branch protection, routes and heat dissipation. |
| All ceiling fixtures | Treat ceiling-light positions throughout the drawing as recessed LED fixtures; investigate 24 V constant-voltage options. Exclude wall receptacles from fixture counts. |
| Kitchen upper cabinets | LED strips above and below all upper cabinets. |
| Kitchen island | Strip below countertop overhang along the side occupied by the four stools. |
| Living room | Concealed strips along three wall-to-ceiling edges; switch separately from recessed fixtures. |
| Master bath ceiling edges | Left wall and walls above sink countertops; exclude shower ceiling edges. |
| Master bath mirror | Strip backlighting behind the corner mirror. |
| Master bath shower niche | LED lighting within the niche. Two niches appear in the drawing; confirm which one or whether both are intended. |
| Spiral staircase | Light beneath every tread; animate one step at a time in ascending and descending directions. Electrical series wiring is not established by this animation requirement. |
| Spiral staircase pendant | Hanging fixture above center post, separate from tread lights; fixture and voltage undecided. |
| Master bedroom | Four ceiling-edge strip runs around bed area; exclude foyer in front of walk-in closet. |
| Walk-in closet | LED strips inside closet; exact placement unspecified. |

## Preliminary Ceiling Takeoff

| Area | Fixtures |
| --- | ---: |
| Bedroom 1 | 4 |
| Bedroom 2 | 4 |
| Master bedroom bed area | 2 |
| Master bedroom foyer | 1 |
| Walk-in closet | 3 |
| Master bath including shower and toilet | 4 |
| Guest bath main and tub | 2 |
| Guest bath toilet | 1 |
| Hall and stair approach | 6 |
| Living room | 4 |
| Kitchen main | 6 |
| Kitchen counter-side ceiling group | 5 |
| Pantry | 3 |
| Laundry | 2 |
| Existing garage | 4 |
| New garage | 4 |
| Dining ceiling point | 1 |
| Total preliminary positions | 56 |

The 55 R text objects reconcile to the room quantities before the dining point. Dining's unlettered ceiling point is included under Wes's all-ceiling-lights instruction, subject to review. One northern garage R is at the clipped sheet edge. Ceiling grouping is preliminary; the count does not establish brightness adequacy.

## Candidate Fixture And Power Implication

[Lotus LB4R24V](https://www.lotusledlights.com/product/4-round-economy-super-thin-11w-24v-lb4r24v): 4-inch, 24 V constant-voltage, 11 W, cULus, IC, airtight and wet-location rated. CCT, trim and exact dimming combination remain unselected. Manufacturer describes up to eight fixtures per 96 W Class 2 supply.

56 x 11 W = 616 W and approximately 25.67 A at 24 V, excluding all strips and the hanging fixture. With a provisional 20% capacity reserve, recessed-only capacity would be 770 W before installation derating. Therefore the earlier 600 W HLG recommendation is not a whole-house supply selection for this scope. Confirm listed supply/distribution architecture; fusing alone does not establish a Class 2 system.

## Control Assignment Basis

- [Shelly Plus i4](https://kb.shelly.cloud/knowledge-base/shelly-plus-i4): proposed wall-command inputs. This photographed model needs 110-240 VAC and has no load output; it is not i4DC.
- [Shelly BLU RC Button 4 ZB](https://us.shelly.com/products/shelly-blu-rc-button-4-zb): proposed strip-zone and secondary-location command station. Requires compatible gateway/control integration.
- [Shelly BLU Motion](https://kb.shelly.cloud/knowledge-base/shelly-blu-motion): optional closet/pantry occupancy input; two stair-end sensors proposed, with direction/latency verification before selection.
- [Shelly 1PM Gen3](https://kb.shelly.cloud/knowledge-base/shelly-1pm-gen3): candidate for on/off loads. Supports 24-30 VDC and maximum 10 A DC; not a dimmer. Verify exact unit's US installation approval and load/inrush requirements.
- [Shelly Plus Wall Dimmer](https://kb.shelly.cloud/knowledge-base/shelly-plus-wall-dimmer): AC-only, 100-120 V, up to 150 W dimmable LED/CFL. Conditional use for a compatible AC pendant or individually verified dimmable driver. Do not connect directly to the 24 V bus or phase-dim the earlier HLG-600H-24A input.
- GLEDOPTO WLED: candidate for addressable spiral-tread animation, pending exact strip IC and input integration. Not an analog strip dimmer.
- C01W: candidate for single-color analog strips. Manufacturer/app/local API are not yet established; Shelly interoperability and independent output zones are unverified.

## Switch Reading And Remaining Decisions

Workbook separates readable single-pole counts, provisional two-location/3-way readings, observed 4-way markings, and blank unresolved counts. Hall/stair S4 marks, bedroom/foyer/closet crossovers, dining grouping, kitchen switch-bank assignments, and clipped new-garage controls need confirmation. Do not total provisional or overlapping groups as a verified purchase quantity.

New strip controls and pendant controls are not drawn. Only the living-room strip's independence from recessed lights is explicitly confirmed. Other separate zones, wireless stations, and sensor quantities are proposals.

Required next inputs: corrections to switch grouping, exact strip models and wattage/length, stair tread count, closet strip location, niche extent, CCT/trim, equipment quantities, network/control-system preference, manual fallback behavior, electrician-approved wiring and source/output archive location.

Related: [[Project Rooms/LED lighting/README]], [[Project Rooms/LED lighting/working/source-inventory]], [[Project Rooms/LED lighting/working/missing-context]].
