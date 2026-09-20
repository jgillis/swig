const assert = require('assert');
require('./overload_wrap.js')().then((m) => {
  assert.strictEqual(m.choose(2), 3);
  assert.strictEqual(m.choose('a'), 'a!');
  assert.strictEqual(m.default_value(), 7);
  assert.strictEqual(m.default_long(), 8);
  assert.strictEqual(m.default_wide(), 9n);
  const d = new m.Derived();
  assert.strictEqual(d.value, 4);
  assert.strictEqual(d.base(), 17);
  assert.strictEqual(m.identify(d), 17);
  assert.strictEqual(m.identify(23), 23);
  d.delete();
}).catch((error) => { console.error(error); process.exitCode = 1; });
