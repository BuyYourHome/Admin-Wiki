import type { Metadata } from 'next';
import './globals.css';
export const metadata: Metadata = { title:'Pondster · I’m a house with a voice', description:'I’m Pondster, the voice and identity of this house. My location is confidential for now. Meet Ashley, my realtor, explore my design ideas, and ask me your questions. Jean Wright is my SI designer.' };
export default function Layout({children}:{children:React.ReactNode}) { return <html lang="en"><body>{children}</body></html>; }
