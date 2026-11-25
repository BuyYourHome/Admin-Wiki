'use client';
import { useEffect, useSyncExternalStore } from 'react';
import { getLightingSourceState, getLightingServerState, refreshLightingSource, subscribeLightingSource } from '../lib/lighting-source-client';

export function useLightingSource(active=true){
  const source=useSyncExternalStore(subscribeLightingSource,getLightingSourceState,getLightingServerState);
  useEffect(()=>{
    if(!active)return;
    const refresh=()=>{if(!document.hidden)void refreshLightingSource();};
    refresh();
    const timer=window.setInterval(refresh,60_000);
    window.addEventListener('focus',refresh);document.addEventListener('visibilitychange',refresh);
    return()=>{window.clearInterval(timer);window.removeEventListener('focus',refresh);document.removeEventListener('visibilitychange',refresh);};
  },[active]);
  return source;
}
