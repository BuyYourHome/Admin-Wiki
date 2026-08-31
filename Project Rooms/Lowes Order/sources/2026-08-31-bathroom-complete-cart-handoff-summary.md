# Bathroom Fixtures Complete Cart Handoff Summary - 2026-08-31

## Source

- Source Project Room: Bathroom Fixtures
- Source task id: `01a0432b-d780-7b01-aed3-e0af40daa663`
- Durable message id: `bathroom-lowes-20260831-complete-cart-delivery-27511-v1`
- Dispatch id: `bathroom-dispatch-20260831-lowes-complete-cart-v1`
- Payload hash: `aeae2e2f20dc3dae6fa32554e4cc7266b2daf51c6207fc2711f6c2ad91997d36`
- Destination task id: `019f5845-fb96-7370-baf2-b8f00fddffae`
- Destination Project Room: Lowes Order
- Requested fulfillment ZIP: `27511`

## Authority

The durable PR-message record is authoritative. Lowes Order validated the destination task id and payload hash with `C:\Codex\Wiki Files\tools\pr-messaging\Manage-ProjectRoomMessage.ps1`, then wrote Accepted and Processing before cart work.

## Requested Items

| Model | Description | Requested quantity | Lowe's URL |
| --- | --- | ---: | --- |
| Moen S3102 | Smart shower digital valve | 1 | `https://www.lowes.com/pd/Moen-U-by-Moen-1-2-in-ID-x-1-2-in-OD-Copper-Thermostatic-Mixing-Valve/5001933693` |
| Delta R10000-MFWS | MultiChoice universal rough-in valve | 2 | `https://www.lowes.com/pd/Delta-1-2-in-ID-Od-Compression-x-1-2-in-OD-Compression-Brass-Shower-Valve/1000001598` |
| Delta R11000 | Diverter rough-in valve | 2 | `https://www.lowes.com/pd/Delta-1-2-in-Brass-Male-In-Line-Rough-in-Valve/1000068741?CAWELAID=320011480007368241` |
| Endurance Peregrine LS4260VNWR | Right-drain drop-in whirlpool tub | 1 | `https://www.lowes.com/pd/Endurance-Peregrine-41-5-in-W-x-59-75-in-L-White-Acrylic-Rectangular-Right-Hand-Drain-Drop-In-Whirlpool-Tub/50255435` |
| Delta Ashlyn T14064-SS | Valve trim | 2 | `https://www.lowes.com/pd/Delta-0-5-in-Stainless-Bathtub-Shower-Mixer/1003069500` |
| Delta Ashlyn T11964-SS | Six-setting diverter trim | 1 | `https://www.lowes.com/pd/Delta-0-5-in-Venetian-Bronze-Bathtub-Shower-Diverter/1000168673` |
| Delta Ashlyn T11864-SS | Three-setting diverter trim | 1 | `https://www.lowes.com/pd/Delta-0-5-in-Stainless-Bathtub-Shower-Diverter/5000215229` |
| Delta RP62149SS | Non-diverter tub spout | 1 | `https://www.lowes.com/pd/Delta-Chrome-Bathtub-Spout/1000038061` |
| Delta 51584-PR | ProClean slide-bar hand shower | 1 | `https://www.lowes.com/pd/Delta-Lumicoat-Chrome-Round-Handheld-Shower-Head-1-75-GPM-6-6-LPM/5014505171` |
| Delta RP101842SS | Modern stainless showerhead | 2 | `https://www.lowes.com/pd/Delta-Modern-Stainless-1-Spray-Shower-Head-1-75-GPM-6-6-LPM/5013202977` |
| Delta RP50841SS | 8-inch square raincan rainhead | 1 | `https://www.lowes.com/pd/Delta-Stainless-1-Spray-Rain-Shower-Head/1003069198` |
| Delta U4993-SS | Wall shower arm and flange | 2 | `https://www.lowes.com/pd/Delta-Universal-Showering-Components-Brushed-Nickel-5-75-in-Bathtub-Shower-Arm-0-5-ID/5002400545` |
| Delta RP61058SS | 6-inch ceiling shower arm and flange | 1 | `https://www.lowes.com/pd/Delta-0-5-in-Stainless-Steel-Universal-Shower-Arm-and-Flange/5014109799` |
| Delta 50570-SS-PR | Hand-shower wall elbow | 1 | `https://www.lowes.com/pd/Delta-Hand-Shower-Wall-Elbow/5006061731` |

## Boundaries

- Preserve unrelated cart contents.
- Do not duplicate matching items already present; adjust to requested totals.
- Choose delivery or ship-to-home fulfillment for ZIP `27511` where available.
- Do not substitute unavailable items.
- Stop at cart review.
- Do not check out, pay, add paid services, add protection plans, use financing, or change saved account/address/payment settings.
