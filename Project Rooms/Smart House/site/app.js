'use strict';
const scenes = {
  day: ['Let the day in.', 'A bright, neutral setting for exploring the space.', 'Daylight'],
  evening: ['Ease into the evening.', 'A warmer visual setting for a quieter end to the day.', 'Evening'],
  relax: ['Make room to unwind.', 'A softly lit concept for relaxed time at home.', 'Unwind']
};
document.querySelectorAll('button[data-scene]').forEach(button => {
  button.addEventListener('click', () => {
    const key = button.dataset.scene;
    const [title, description, label] = scenes[key];
    const room = document.querySelector('.room');
    room.dataset.scene = key;
    room.setAttribute('aria-label', `Illustrative room with ${label.toLowerCase()} lighting`);
    document.querySelector('#scene-title').textContent = title;
    document.querySelector('#scene-description').textContent = description;
    document.querySelector('#scene-status').textContent = `${label} preview selected. Simulation only.`;
    document.querySelectorAll('button[data-scene]').forEach(item => item.setAttribute('aria-pressed', String(item === button)));
  });
});
