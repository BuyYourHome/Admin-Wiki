import assert from 'node:assert/strict';
import {readFileSync} from 'node:fs';
import {createRequire} from 'node:module';
import ts from 'typescript';
import React from 'react';
const require=createRequire(import.meta.url);
require.extensions['.tsx']=(module,path)=>module._compile(ts.transpileModule(readFileSync(path,'utf8'),{compilerOptions:{module:ts.ModuleKind.CommonJS,jsx:ts.JsxEmit.ReactJSX,target:ts.ScriptTarget.ES2022}}).outputText,path);
const svg=require('../app/pondster-logo-art.tsx').default();
assert.equal(svg.props.viewBox,'0 0 90 110','Use an unambiguous positive SVG viewport.');
const anchor=svg.props.children;
assert.equal(anchor.type,'g');assert.equal(anchor.props.transform,'translate(45 90)');
const bursts=React.Children.toArray(anchor.props.children);assert.ok(bursts.length>0);
for(const burst of bursts){
 assert.equal(burst.type,'g');assert.notEqual(burst.props.className,'logo-firework','Do not inherit the old CSS pivot animation.');
 const children=React.Children.toArray(burst.props.children),scale=children.find(child=>child.type==='animateTransform'),opacity=children.find(child=>child.type==='animate'&&child.props.attributeName==='opacity');
 assert.equal(scale?.props.type,'scale');assert.equal(scale.props.attributeType,'XML');assert.ok(opacity);
 const scales=scale.props.values.split(';').map(Number),circle=children.find(child=>child.type==='circle'),rays=children.filter(child=>child.type==='line');
 assert.ok(scales.every(value=>value>0));assert.ok(rays.length>0);assert.equal(Number(circle.props.cx),0);assert.equal(Number(circle.props.cy),0);
 for(const value of [...scales,1]){
   assert.deepEqual([45+value*Number(circle.props.cx),90+value*Number(circle.props.cy)],[45,90],'The source point cannot migrate while the burst expands.');
   for(const ray of rays){assert.ok(90+value*ray.props.y1<90&&90+value*ray.props.y2<90,'Every spark remains above the fixed launch point rather than crossing up through the exclamation.');}
 }
}
const css=readFileSync(new URL('../app/globals.css',import.meta.url),'utf8');
assert.doesNotMatch(css,/\.signature-exclamation \.logo-firework\{[^}]*transform-origin/,'Remove the negative-viewBox percentage-pivot source of the regression.');
assert.match(css,/@media\(prefers-reduced-motion:reduce\)\{\.signature-exclamation \.pondster-logo-art\{display:none\}\}/);
console.log('PASS: real SVG component keeps the launch point fixed throughout expansion; every spark stays above it, with no old CSS pivot and reduced-motion protection. No browser/network.');
