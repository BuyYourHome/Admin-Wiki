/** Open the destination and all containing disclosures before checking layout. */
export function openTargetDisclosures(target:HTMLElement):boolean {
  const ancestors:HTMLDetailsElement[]=[];
  for(let element:HTMLElement|null=target;element;element=element.parentElement) {
    if(element.tagName==='DETAILS')ancestors.push(element as HTMLDetailsElement);
  }
  let changed=false;
  for(const details of ancestors.reverse())if(!details.open){details.open=true;changed=true;}
  // Only authored essential subsections opt in. Other nested cards keep their state.
  for(const details of target.querySelectorAll<HTMLDetailsElement>('details[data-pondster-open-with-target]'))if(!details.open){details.open=true;changed=true;}
  return changed;
}
