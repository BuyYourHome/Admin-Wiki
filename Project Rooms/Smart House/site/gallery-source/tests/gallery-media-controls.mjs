import assert from 'node:assert/strict';
import {readFileSync} from 'node:fs';
import {createRequire,stripTypeScriptTypes} from 'node:module';
import ts from 'typescript';
import React from 'react';
import {renderToStaticMarkup} from 'react-dom/server';
import {galleries} from '../lib/designs.ts';
const require=createRequire(import.meta.url);
// Transpile real TSX components in this test process only; no browser/network.
for(const extension of ['.ts','.tsx'])require.extensions[extension]=(module,path)=>{
 module._compile(ts.transpileModule(readFileSync(path,'utf8'),{compilerOptions:{module:ts.ModuleKind.CommonJS,jsx:ts.JsxEmit.ReactJSX,target:ts.ScriptTarget.ES2022}}).outputText,path);
};
const Controls=require('../app/gallery-media-controls.tsx').default;
const Viewer=require('../app/gallery-image-viewer.tsx').default;
const Video=require('../app/scroll-video.tsx').default;
let previous=0,next=0,votes=0,toggles=0,controls=0;
const voice={active:true,status:'Voice on',onToggle:()=>toggles++,onControls:()=>controls++};
const media={name:'Living Room',canBrowse:true,counter:'Concept film',onPrevious:()=>previous++,onNext:()=>next++,voteAction:{label:'Choose a design & vote',onClick:()=>votes++},voice};
const buttons=[];
function visit(node){if(!node||typeof node!=='object')return;if(node.type==='button')buttons.push(node);React.Children.forEach(node.props?.children,visit);}
visit(Controls(media));
for(const label of ['Previous','Next','Choose a design','Stop voice','Voice controls']){
 const button=buttons.find(item=>renderToStaticMarkup(item).includes(label));assert.ok(button,label);button.props.onClick();
}
assert.deepEqual([previous,next,votes,toggles,controls],[1,1,1,1,1]);
const design=galleries.find(item=>item.id==='media-center').designs[0];
const html=renderToStaticMarkup(React.createElement(Viewer,{design,onChange(){},onClose(){},voice,voting:{selected:null,disabled:false,saving:false,onVote(){}}}));
assert.match(html,/<dialog[\s\S]*Vote for my design[\s\S]*Voice controls/,'Voting and clickable voice controls are inside the modal, not behind it.');
assert.match(html,/Previous picture in Living Room/);assert.match(html,/Next picture in Living Room/);
const film=renderToStaticMarkup(React.createElement(Video,{label:'Film',ratio:'16 / 9',media},React.createElement('video',{controls:true})));
assert.match(film,/Choose a design &amp; vote/);assert.match(film,/Voice controls/);assert.match(film,/Next picture/);

const source=readFileSync(new URL('../app/page.tsx',import.meta.url),'utf8');
const start=source.indexOf('  function openDesignImage('),end=source.indexOf('  function openVoiceControls',start);
let room=null,zoom=null;
const open=new Function('galleries','setRoom','setZoom',stripTypeScriptTypes(source.slice(start,end))+';return openDesignImage;')(galleries,value=>room=value,value=>zoom=value);
open(design);assert.equal(room,'media-center');assert.equal(zoom.id,design.id);
const deck=galleries.find(item=>item.id==='back-deck').designs[0];open(deck);assert.equal(room,'back-deck');assert.equal(zoom.id,deck.id,'Opening outside Design selects the owning vote gallery.');
const handler=source.match(/onOpenChange=\{(nextOpen=>\{[^\n]+?\})\} onAction/)[1];
const destinations=[];const onOpen=new Function('menu','openContact','navigate','return '+handler);
onOpen('Design',()=>{},value=>destinations.push(value))(false);assert.deepEqual(destinations,[],'Starting voice keeps the current gallery visible.');
onOpen('Contact',()=>{},value=>destinations.push(value))(false);assert.deepEqual(destinations,['View']);
console.log('PASS: real photo/video controls, accessible modal-contained voice and vote buttons, callbacks, cross-page gallery ownership, and voice startup preserving Design. No microphone, provider calls, or votes written.');
