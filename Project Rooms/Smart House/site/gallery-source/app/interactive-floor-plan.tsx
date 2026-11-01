'use client';

import { useEffect, useId, useRef, useState, type Ref } from 'react';
import { galleries } from '../lib/designs';
import { roomFeatures } from '../lib/features.js';
import { floorPlanRooms, PLAN_HEIGHT, PLAN_WIDTH } from '../lib/floor-plan';
import RoomPrimaryImage from './room-primary-image';

const additionalSpaces = galleries.filter(gallery => !floorPlanRooms.some(room => room.galleryId === gallery.id))
  .map(gallery => ({ id:`gallery-${gallery.id}`, name:gallery.name, galleryId:gallery.id, summary:gallery.summary, features:[] as string[] }));
const exploreRooms = [...floorPlanRooms, ...additionalSpaces];

export type FloorPlanRoomRequest = { id:number; room:string; section?:'room'|'floor-plan' };
export default function InteractiveFloorPlan({ roomRequest, detailRef }: { roomRequest?:FloorPlanRoomRequest; detailRef?:Ref<HTMLElement> }) {
  const instanceId = useId();
  const headingId = `${instanceId}-plan-heading`;
  const detailHeadingId = `${instanceId}-room-heading`;
  const detailId = `${instanceId}-room-details`;
  const selectId = `${instanceId}-room-select`;
  const [selectedId, setSelectedId] = useState('living-room');
  const [zoom, setZoom] = useState(1);
  const selectedRoom = exploreRooms.find(room => room.id === selectedId) ?? floorPlanRooms[0];
  const roomFeature = selectedRoom.galleryId ? roomFeatures[selectedRoom.galleryId] : undefined;
  const selectedFeatures = [...new Set([...selectedRoom.features, ...(roomFeature?.features ?? [])])];
  const detailHeading = useRef<HTMLHeadingElement>(null);
  const viewport = useRef<HTMLDivElement>(null);
  const roomSelect = useRef<HTMLSelectElement>(null);
  const roomShapes = useRef(new Map<string, SVGPolygonElement>());
  useEffect(() => {
    if(!roomRequest)return;
    const requestedRoom = roomRequest.section === 'room'
      ? exploreRooms.find(room => room.galleryId === roomRequest.room)
      : floorPlanRooms.find(room => room.id === roomRequest.room);
    if(requestedRoom)setSelectedId(requestedRoom.id);
  },[roomRequest?.id,roomRequest?.room,roomRequest?.section]);

  function chooseRoom(roomId: string) {
    setSelectedId(roomId);
    requestAnimationFrame(() => {
      detailHeading.current?.focus({ preventScroll: true });
      detailHeading.current?.scrollIntoView({ block: 'nearest', inline: 'nearest' });
    });
  }

  function returnToPlan() {
    const shape = roomShapes.current.get(selectedRoom.id);
    if (shape) shape.focus({ preventScroll: true });
    else roomSelect.current?.focus({ preventScroll: true });
    viewport.current?.scrollIntoView({ block: 'nearest', inline: 'nearest' });
    shape?.scrollIntoView({ block: 'nearest', inline: 'nearest' });
  }

  function changeZoom(change: number) {
    setZoom(current => Math.max(1, Math.min(2.5, Math.round((current + change) * 100) / 100)));
  }

  return <section id="pondster-explore-floor-plan" className="floor-plan" aria-labelledby={headingId}>
    <div className="floor-plan-heading">
      <span className="floor-plan-status">MY FIRST-FLOOR LAYOUT</span>
      <h2 id={headingId}>My first-floor plan</h2>
      <p className="floor-plan-intro">Tap or click one of my rooms, or choose it by name, to explore its details. I’m sharing a planned layout; my dimensions and construction details still need confirmation.</p>
    </div>

    <div className="floor-plan-layout">
      <div className="floor-plan-map">
        <div id="pondster-explore-rooms" className="floor-plan-tools">
          <div className="floor-plan-select">
            <label htmlFor={selectId}>Choose one of my rooms</label>
            <select ref={roomSelect} id={selectId} value={selectedRoom.id} onChange={event => chooseRoom(event.target.value)} aria-controls={detailId}>
              {floorPlanRooms.map(room => <option key={room.id} value={room.id}>{room.name}</option>)}
              {additionalSpaces.length > 0 && <optgroup label="More of my spaces">{additionalSpaces.map(room => <option key={room.id} value={room.id}>{room.name}</option>)}</optgroup>}
            </select>
          </div>
          <div className="floor-plan-zoom" role="group" aria-label="Zoom my floor plan">
            <button type="button" onClick={() => changeZoom(-0.25)} disabled={zoom <= 1} aria-label="Zoom out my floor plan">−</button>
            <output aria-live="polite" aria-label="My floor plan zoom">{Math.round(zoom * 100)}%</output>
            <button type="button" onClick={() => changeZoom(0.25)} disabled={zoom >= 2.5} aria-label="Zoom in my floor plan">+</button>
          </div>
        </div>

        <div ref={viewport} className="floor-plan-viewport" tabIndex={0} role="region" aria-label="My interactive floor plan; zoom in and scroll to look closer">
          <div className="floor-plan-canvas" style={{ width: `${zoom * 100}%`, maxWidth: `${zoom * 720}px` }}>
            <svg className="floor-plan-svg" viewBox={`0 0 ${PLAN_WIDTH} ${PLAN_HEIGHT}`} width={PLAN_WIDTH} height={PLAN_HEIGHT} role="group" aria-label="Select a room in my first-floor plan">
              <image href="/plans/proposed-first-floor.png" x="0" y="0" width={PLAN_WIDTH} height={PLAN_HEIGHT} aria-hidden="true" />
              {floorPlanRooms.map(room => <polygon
                key={room.id}
                ref={node => { if (node) roomShapes.current.set(room.id, node); else roomShapes.current.delete(room.id); }}
                className={`floor-plan-room${selectedRoom.id === room.id ? ' is-selected' : ''}`}
                points={room.polygon}
                role="button"
                tabIndex={0}
                aria-label={`Explore my ${room.name}`}
                aria-pressed={selectedRoom.id === room.id}
                aria-controls={detailId}
                onClick={() => chooseRoom(room.id)}
                onKeyDown={event => {
                  if (event.key === 'Enter' || event.key === ' ') {
                    event.preventDefault();
                    chooseRoom(room.id);
                  }
                }}
              ><title>{`Explore my ${room.name}`}</title></polygon>)}
            </svg>
          </div>
        </div>
        <button type="button" className="floor-plan-open-details" onClick={() => chooseRoom(selectedRoom.id)}>See my {selectedRoom.name} details <span aria-hidden="true">↓</span></button>
      </div>

      <section ref={detailRef} id={detailId} className="floor-plan-details" data-pondster-room={selectedRoom.id} data-pondster-gallery={selectedRoom.galleryId} aria-labelledby={detailHeadingId}>
        <div id={selectedRoom.galleryId ? `pondster-explore-room-${selectedRoom.galleryId}` : undefined}>
        {roomFeature && <span className="feature-status">{roomFeature.status}</span>}
        <h3 ref={detailHeading} id={detailHeadingId} className="floor-plan-detail-heading" tabIndex={-1}>My {selectedRoom.name}</h3>
        <RoomPrimaryImage key={selectedRoom.id} galleryId={selectedRoom.galleryId} roomName={selectedRoom.name}/>
        <p>{selectedRoom.summary}</p>
        <ul>{selectedFeatures.map(feature => <li key={feature}>{feature}</li>)}</ul>
        </div>
        <div className="floor-plan-detail-actions">
          <button type="button" className="floor-plan-back" onClick={returnToPlan}>Back to my plan <span aria-hidden="true">↑</span></button>
        </div>
      </section>
    </div>
  </section>;
}
