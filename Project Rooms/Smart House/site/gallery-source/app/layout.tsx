import type { Metadata } from 'next';
import './globals.css';
export const metadata: Metadata = { title:'Pondster · A little mystery, for now', description:'Meet Pondster, a home with a voice, starting anonymously for now. Explore and vote on design ideas, meet realtor Ashley Morello, and ask about Jean Wright, the SI designer.' };
export default function Layout({children}:{children:React.ReactNode}) { return <html lang="en"><body>{children}</body></html>; }
