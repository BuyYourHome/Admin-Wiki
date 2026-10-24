import type { Metadata } from 'next';
import './globals.css';
export const metadata: Metadata = { title:'908 Pond Street · Design a place to call home', description:'Explore Pond Street design galleries, compare ideas, and vote for your favorites.' };
export default function Layout({children}:{children:React.ReactNode}) { return <html lang="en"><body>{children}</body></html>; }
