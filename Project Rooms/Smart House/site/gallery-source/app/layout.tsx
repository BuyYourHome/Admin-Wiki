import { PONDSTER_CITY } from '../lib/pondster-identity';
import type { Metadata } from 'next';
import './globals.css';
export const metadata: Metadata = { title:`Pondster · I’m a home in ${PONDSTER_CITY}`, description:`I’m Pondster, a home in ${PONDSTER_CITY}. My exact street address stays private. Meet Ashley, my realtor, explore my design ideas, and ask me your questions. Jean Wright is my SI designer.` };
export default function Layout({children}:{children:React.ReactNode}) { return <html lang="en"><body>{children}</body></html>; }
