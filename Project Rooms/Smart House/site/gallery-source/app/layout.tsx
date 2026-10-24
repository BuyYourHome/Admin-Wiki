import type { Metadata } from 'next';
import './globals.css';
export const metadata: Metadata = { title:'Pondster · A little mystery, for now', description:'Meet Pondster, a home with a voice, starting anonymously for now. Ask Pondster your questions, explore and vote on design ideas, and meet realtor Ashley Morello. SI designer: Dean Wright.' };
export default function Layout({children}:{children:React.ReactNode}) { return <html lang="en"><body>{children}</body></html>; }
