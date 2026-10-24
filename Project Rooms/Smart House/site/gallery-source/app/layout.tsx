import type { Metadata } from 'next';
import './globals.css';
export const metadata: Metadata = { title:'Pondster · A house with a voice', description:'Pondster is the voice and identity of this house. Its location is confidential for now. Ask Pondster your questions, explore and vote on design ideas, and meet realtor Ashley Morello. SI designer: Jean Wright.' };
export default function Layout({children}:{children:React.ReactNode}) { return <html lang="en"><body>{children}</body></html>; }
