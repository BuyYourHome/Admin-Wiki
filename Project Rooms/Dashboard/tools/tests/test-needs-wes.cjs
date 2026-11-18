const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');

class Element {
  constructor(tag) {
    this.tag = tag;
    this.children = [];
    this.listeners = {};
    this.textContent = '';
  }
  append(...items) { this.children.push(...items); }
  replaceChildren() { this.children = []; }
  querySelector(tag) { return this.children.find(child => child.tag === tag); }
  addEventListener(name, fn) { this.listeners[name] = fn; }
  setAttribute() {}
  *descendants() {
    for (const child of this.children) {
      yield child;
      yield* child.descendants();
    }
  }
}

(async () => {
  const site = path.join(__dirname, '../../site');
  const html = fs.readFileSync(path.join(site, 'index.html'), 'utf8');
  const nodes = Object.fromEntries([...html.matchAll(/\bid="(wes\w+)"/g)].map(([, id]) => [id, new Element('root')]));
  const item = (classification, state) => ({
    classification, state, messageId: classification, emailApprovalId: classification,
    destinationRoom: 'Email Monitor', destinationMachine: 'OFFICEASSIST'
  });
  let data = {
    ok: true, emailApprovalFeed: 'available', items: [
      item('wes-decision', 'Approval needed'),
      item('approved-awaiting-send', 'Approved, awaiting send'),
      item('system-blocker', 'Email send blocked')
    ]
  };
  vm.runInNewContext(fs.readFileSync(path.join(site, 'needs-wes.js'), 'utf8'), {
    document: { getElementById: id => nodes[id], createElement: tag => new Element(tag) },
    fetch: async (_, options) => {
      assert.equal(options.method, undefined, 'Dashboard status is read-only');
      return data ? { ok: true, json: async () => data } : { ok: false, status: 503 };
    }
  });
  await new Promise(resolve => setImmediate(resolve));

  const descendants = id => [...nodes[id].descendants()];
  assert.match(nodes.wesAttentionStatus.textContent, /1 pending decision\b/);
  assert.equal(nodes.wesApprovedSection.hidden, false);
  assert.equal(nodes.wesApprovedSummary.textContent, 'Approved, awaiting send (1)');
  assert.equal(nodes.wesSystemSummary.textContent, 'System and workflow blockers (1)');
  assert.match(descendants('wesAttentionGroups').find(node => node.tag === 'textarea').value, /Review email approval wes-decision/);
  for (const target of ['wesApprovedGroups', 'wesSystemGroups']) {
    assert.ok(descendants(target).every(node => node.tag !== 'button'));
  }

  data = { ok: true, emailApprovalFeed: 'not-initialized', items: [] };
  await nodes.wesAttentionRefresh.listeners.click();
  assert.equal(nodes.wesApprovedSection.hidden, true);
  assert.equal(nodes.wesEmailApprovalStatus.hidden, false);
  assert.match(nodes.wesEmailApprovalStatus.textContent, /does not confirm/);

  data = null;
  await nodes.wesAttentionRefresh.listeners.click();
  assert.match(nodes.wesAttentionStatus.textContent, /unknown, not empty/);
  assert.equal(nodes.wesApprovedSection.hidden, true);
  assert.equal(nodes.wesAttentionRefresh.disabled, false);
  console.log('Passed: approval, awaiting-send, and blocker groups; read-only review; unknown and uninitialized states.');
})().catch(error => { console.error(error); process.exitCode = 1; });
