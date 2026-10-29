import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { createRequire, Module } from 'node:module';
import { dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import ts from 'typescript';
import React from 'react';
import { renderToStaticMarkup } from 'react-dom/server';
import { equipmentManuals } from '../lib/equipment.ts';
import { buildPondsterLiveSession } from '../lib/pondster-live-context.ts';
import { galleries } from '../lib/designs.ts';

const require = createRequire(import.meta.url);
const compilerOptions = { module: ts.ModuleKind.CommonJS, jsx: ts.JsxEmit.ReactJSX, target: ts.ScriptTarget.ES2022 };
for (const extension of ['.ts', '.tsx']) {
  require.extensions[extension] = (module, path) => module._compile(ts.transpileModule(readFileSync(path, 'utf8'), { compilerOptions }).outputText, path);
}
const EquipmentManuals = require('../app/equipment-manuals.tsx').default;
const libraryMarkup = renderToStaticMarkup(React.createElement(EquipmentManuals));

function decode(text) {
  return text.replace(/&(?:amp|lt|gt|quot|#x[\da-f]+|#\d+);/gi, entity => {
    const named = { '&amp;': '&', '&lt;': '<', '&gt;': '>', '&quot;': '"' };
    return named[entity] ?? String.fromCodePoint(Number.parseInt(entity.slice(entity[2]?.toLowerCase() === 'x' ? 3 : 2, -1), entity[2]?.toLowerCase() === 'x' ? 16 : 10));
  });
}
function attributes(text) {
  return Object.fromEntries([...text.matchAll(/([\w:-]+)="([^"]*)"/g)].map(([, name, value]) => [name, decode(value)]));
}
function links(markup) {
  return [...markup.matchAll(/<a\b([^>]*)>([\s\S]*?)<\/a>/g)].map(([, props, content]) => ({ ...attributes(props), text: decode(content.replace(/<[^>]*>/g, '')) }));
}
function countId(markup, id) {
  return [...markup.matchAll(/\bid="([^"]*)"/g)].filter(([, value]) => value === id).length;
}

assert.deepEqual(equipmentManuals.map(equipment => equipment.id).sort(), ['audio', 'cameras']);
const guides = equipmentManuals.flatMap(equipment => equipment.guides);
assert.equal(guides.length, 6, 'The selected camera and receiver equipment have six manufacturer guides.');
assert.equal(new Set(guides.map(guide => guide.url)).size, guides.length, 'A duplicate URL cannot stand in for a missing guide.');
assert.equal(countId(libraryMarkup, 'pondster-own-maintenance'), 1);
assert.match(libraryMarkup, /My equipment guides/);
const articles = new Map([...libraryMarkup.matchAll(/<article\b([^>]*)>([\s\S]*?)<\/article>/g)].map(([, props, content]) => [attributes(props).id, content]));
assert.equal(articles.size, 2, 'Each selected system has its own rendered equipment card.');
const publicFacts = buildPondsterLiveSession(galleries).instructions.split('PUBLIC WEBSITE FACTS:\n')[1];
assert.ok(publicFacts, 'Use the actual live-session public knowledge rather than source text.');

for (const equipment of equipmentManuals) {
  const cardId = `pondster-own-${equipment.id}`;
  assert.equal(countId(libraryMarkup, cardId), 1);
  const card = articles.get(cardId);
  assert.ok(card, `Render the ${equipment.id} card.`);
  const cardText = decode(card.replace(/<[^>]*>/g, ''));
  const knowledge = publicFacts.split('\n').find(line => equipment.guides.every(guide => line.includes(guide.url)));
  assert.ok(knowledge, `Keep every ${equipment.id} manual in its matching live-knowledge record.`);
  for (const fact of [equipment.model, equipment.summary, ...equipment.facts]) {
    assert.ok(cardText.includes(fact), `The ${equipment.id} card shows its shared public fact: ${fact}`);
    assert.ok(knowledge.includes(fact), `The live guide knows the same ${equipment.id} fact: ${fact}`);
  }
  assert.ok(cardText.includes(equipment.status), 'Keep the equipment-specific setup boundary visible.');
  for (const guide of equipment.guides) {
    assert.equal(new URL(guide.url).protocol, 'https:');
    assert.equal(new URL(guide.url).pathname.toLowerCase().endsWith('.pdf'), guide.format === 'PDF', 'A support landing page is not labelled as a PDF.');
    const rendered = links(card).filter(link => link.href === guide.url);
    assert.equal(rendered.length, 1, `Expose ${guide.label} exactly once in its actual card.`);
    assert.ok(rendered[0].text.includes(guide.label) && rendered[0].text.includes(guide.format), 'Visible guide text identifies the document and its real format.');
    assert.ok(rendered[0]['aria-label'].includes(guide.format) && rendered[0]['aria-label'].includes('opens in a new tab'));
    assert.ok(knowledge.includes(guide.label) && knowledge.includes(`(${guide.format})`) && knowledge.includes(guide.url), 'The same manual label, format and destination reach the live guide.');
  }
  assert.equal(links(card).filter(link => link.href === equipment.productUrl).length, 1, 'Keep the manufacturer product reference alongside the manuals.');
}
for (const link of links(libraryMarkup)) {
  assert.equal(new URL(link.href).protocol, 'https:');
  assert.equal(link.target, '_blank');
  const rel = new Set(link.rel.split(/\s+/));
  assert.ok(rel.has('noopener') && rel.has('noreferrer'), 'External manufacturer links protect their new browsing context.');
}

// Render the actual Belong branch with its real component import, without booting
// unrelated page state, browser voice controls or network-dependent components.
const pagePath = fileURLToPath(new URL('../app/page.tsx', import.meta.url));
const pageSource = readFileSync(pagePath, 'utf8');
const page = ts.createSourceFile(pagePath, pageSource, ts.ScriptTarget.Latest, true, ts.ScriptKind.TSX);
const equipmentImport = page.statements.find(statement => ts.isImportDeclaration(statement) && statement.importClause?.name?.text === 'EquipmentManuals');
assert.ok(equipmentImport, 'Belong imports the real equipment library component.');
const belongBranches = [];
function visit(node) {
  if (ts.isBinaryExpression(node) && node.operatorToken.kind === ts.SyntaxKind.AmpersandAmpersandToken && ts.isBinaryExpression(node.left)
    && node.left.operatorToken.kind === ts.SyntaxKind.EqualsEqualsEqualsToken && ts.isIdentifier(node.left.left) && node.left.left.text === 'menu'
    && ts.isStringLiteral(node.left.right) && node.left.right.text === 'Own') belongBranches.push(node.right);
  ts.forEachChild(node, visit);
}
visit(page);
assert.equal(belongBranches.length, 1, 'There is one actual Belong page branch to verify.');
const virtualPath = fileURLToPath(new URL('../app/__equipment-belong-test__.cjs', import.meta.url));
const belongModule = new Module(virtualPath);
belongModule.filename = virtualPath;
belongModule.paths = Module._nodeModulePaths(dirname(pagePath));
belongModule._compile(ts.transpileModule(`${equipmentImport.getText(page)}\nexport default function BelongEquipmentTest(){ return (${belongBranches[0].getText(page)}); }`, { compilerOptions }).outputText, virtualPath);
const belongMarkup = renderToStaticMarkup(React.createElement(belongModule.exports.default));
for (const id of ['pondster-own-maintenance', 'pondster-own-cameras', 'pondster-own-audio']) {
  assert.equal(countId(belongMarkup, id), 1, `Belong renders ${id} once; the old maintenance placeholder cannot duplicate it.`);
}
for (const guide of guides) assert.equal(links(belongMarkup).filter(link => link.href === guide.url).length, 1, 'Belong embeds the actual complete six-guide library.');
const deckLinks = links(belongMarkup).filter(link => link.href === '/documents/deck-structural-preliminary.pdf');
assert.equal(deckLinks.length, 2, 'The original public deck PDF retains its viewing and download links.');
assert.ok(deckLinks.some(link => link.download === 'deck-structural-preliminary.pdf'));
assert.match(belongMarkup, /PRELIMINARY \/ NOT FOR PERMIT/);
console.log('PASS: actual equipment and Belong renders share all six typed manufacturer guides with live knowledge; unique library/cards, safe external links and original deck PDF retained. No browser/network.');
