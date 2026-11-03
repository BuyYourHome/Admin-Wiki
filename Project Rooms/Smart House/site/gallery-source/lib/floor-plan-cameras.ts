export type FloorPlanCamera = {
  id: `camera-${number}`;
  number: number;
  name: string;
  x: number;
  y: number;
  radius: number;
  startDegrees: number;
  endDegrees: number;
  sectorPath: string;
  markerPoints: string;
  badgeOffsetX: number;
  badgeOffsetY: number;
  video: string;
  poster: string;
  summary: string;
  durationSeconds: number;
};

// House Render camera map v15 (2026-11-02), 2340 × 2225. The source sector,
// marker and badge positions stay together; field radii are display sizes,
// not measured sightlines. These virtual views are concepts, not live feeds.
export const floorPlanCameras: FloorPlanCamera[] = [
  {
    id: 'camera-1', number: 1, name: 'Front gable', x: 954, y: 1930,
    radius: 260, startDegrees: 22.5, endDegrees: 157.5,
    sectorPath: 'M 954 1930 L 1194.21 2029.50 A 260 260 0 0 1 713.79 2029.50 Z',
    markerPoints: '954,1968 916,1900 992,1900',
    badgeOffsetX: 60, badgeOffsetY: -54,
    video: '/media/camera-1-virtual.mp4', poster: '/media/camera-1-poster.jpg',
    summary: 'I show a front-gable camera concept toward my front lawn and street. My current mount and this earlier video viewpoint still need reconciliation; I am not showing a live feed or measured coverage.',
    durationSeconds: 6
  },
  {
    id: 'camera-2', number: 2, name: 'Barn door', x: 1985, y: 805,
    radius: 270, startDegrees: -90, endDegrees: 90,
    sectorPath: 'M 1985 805 L 1985.00 535.00 A 270 270 0 0 1 1985.00 1075.00 Z',
    markerPoints: '2023,805 1955,767 1955,843',
    badgeOffsetX: 60, badgeOffsetY: -54,
    video: '/media/camera-2-virtual.mp4', poster: '/media/camera-2-poster.jpg',
    summary: 'I show a virtual view from my barn door camera position toward my side yard and privacy fence. My camera views are concepts, not live feeds or measured coverage.',
    durationSeconds: 6
  },
  {
    id: 'camera-3', number: 3, name: 'Deck', x: 1435, y: 540,
    radius: 520, startDegrees: 48, endDegrees: 228,
    sectorPath: 'M 1435 540 L 1782.95 926.44 A 520 520 0 0 1 1087.05 153.56 Z',
    markerPoints: '1401,568 1469,554 1441,498',
    badgeOffsetX: 60, badgeOffsetY: -54,
    video: '/media/camera-3-virtual.mp4', poster: '/media/camera-3-poster.jpg',
    summary: 'I show my selected deck concept from my diagonal garage-wall camera position. My plan arc follows that wall; my virtual view does not confirm optical coverage or a live camera feed.',
    durationSeconds: 6
  },
  {
    id: 'camera-4', number: 4, name: 'West side', x: 313, y: 665,
    radius: 260, startDegrees: 90, endDegrees: 270,
    sectorPath: 'M 313 665 L 313.00 925.00 A 260 260 0 0 1 313.00 405.00 Z',
    markerPoints: '275,665 343,627 343,703',
    badgeOffsetX: 60, badgeOffsetY: -54,
    video: '/media/camera-4-virtual.mp4', poster: '/media/camera-4-poster.jpg',
    summary: 'I show my earlier west-side camera simulation. My newest plan turns this camera toward my front road; the video has not yet been revised to that direction. I am not showing a live feed or measured coverage.',
    durationSeconds: 6
  }
];
