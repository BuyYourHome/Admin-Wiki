import type { Metadata } from 'next';
import './globals.css';
export const metadata: Metadata = { title:'Pondster · A home with a voice · 908 Pond Street', description:'Meet Pondster, the home at 908 Pond Street. Explore and vote on design ideas, meet realtor Ashley Morello, and ask about Jean Wright, the SI designer.' };
export default function Layout({children}:{children:React.ReactNode}) { return <html lang="en"><body>{children}</body></html>; }
