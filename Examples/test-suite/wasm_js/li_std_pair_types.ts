import createModule = require('./li_std_pair_wrap');
async function check() {
  const m = await createModule();
  const pair: [number, number] = m.makeIntPair(3, 4);
  const value: number = m.product2(pair);
  m.product3(m.makeIntPairPtr(1, 2));
  // @ts-expect-error Pair pointer arguments require a proxy.
  m.product3([1, 2]);
  // @ts-expect-error Pair input elements are numeric.
  m.product1([1, 'wrong']);
  return value;
}
