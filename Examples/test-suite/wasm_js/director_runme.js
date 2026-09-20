const assert = require('assert');
require('./director_wrap.js')().then((m) => {
  class Callback extends m.Callback {
    wide(n) { return n + 1n; }
    call(n) { assert.strictEqual(typeof n, 'number'); return 3 * n; }
  }
  const base = new m.Callback();
  const callback = new Callback();
  assert.strictEqual(m.invoke(base, 4), 5);
  assert.strictEqual(m.invoke(callback, 4), 12);
  assert.strictEqual(m.invoke_wide(callback, 9007199254740993n), 9007199254740994n);
  const borrowed = m.borrow(base);
  assert.strictEqual(borrowed.call(2), 3);
  const owned = m.make_callback();
  assert.strictEqual(owned.call(2), 3);
  owned.delete();
  base.delete();
  callback.delete();
}).catch((error) => { console.error(error); process.exitCode = 1; });
