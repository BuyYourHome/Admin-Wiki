import ScrollVideo from './scroll-video';

export default function TheaterMotion() {
  return <figure className="media-feature theater-media-feature">
    <div className="media-feature-intro"><div><p className="eyebrow">MY HOME THEATRE / IN MOTION</p><h3>My screen comes alive. My stairs light the way.</h3></div><span>MY 12-SECOND CONCEPT FILM</span></div>
    <ScrollVideo label="My Home Theatre and spiral staircase" ratio="1672 / 940">
      <video controls autoPlay muted playsInline loop preload="metadata" poster="/media/theater-stair-lights-poster.jpg" aria-label="My Home Theatre concept: moving football on my screen and sequential amber lights on my black spiral staircase" aria-describedby="theater-motion-caption">
        <source src="/media/theater-football-sequential-stair-lights.mp4" type="video/mp4"/>
        Your browser can’t play my video here. <a href="/media/theater-football-sequential-stair-lights.mp4">Open my video file</a>.
      </video>
    </ScrollVideo>
    <figcaption id="theater-motion-caption"><span>MY AI MOTION CONCEPT</span>I’m exploring moving football on my Home Theatre screen while my amber stair lights illuminate in sequence. I keep my full staircase-and-screen scene in view. My film keeps its original amber palette; it does not change to match a winning color. My film illustrates a design idea; my staircase, lighting, dimensions, and clearances still need validation.
      <p className="media-source">Football credit shown in my film: U.S. Marine Corps / Sgt. James Stanfield, via <a href="https://www.dvidshub.net/video/947000/125th-army-navy-football-game-b-roll" target="_blank" rel="noopener noreferrer">DVIDS</a>.<br/>The appearance of U.S. Department of War (DoW) visual information does not imply or constitute DoW endorsement. <a href="https://www.dvidshub.net/about/copyright" target="_blank" rel="noopener noreferrer">Source use notice ↗</a></p>
    </figcaption>
  </figure>;
}
