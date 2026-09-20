import createModule = require('./stl_references_wrap');
async function check() {
  const m = await createModule();
  const store = new m.Store();
  const vector = store.vector_ref();
  const map = store.map_ref();
  const pair = store.pair_ref();
  m.mutate_vector(vector);
  m.mutate_vector_pointer(store.vector_pointer());
  m.mutate_map(map);
  m.mutate_map_pointer(store.map_pointer());
  m.mutate_pair(pair);
  m.mutate_pair_pointer(store.pair_pointer());
  const values: number[] = store.vector_snapshot();
  const mapping: Map<number, number> = store.map_snapshot();
  const tuple: [number, number] = store.pair_snapshot();
  // @ts-expect-error Mutable references require native container proxies.
  m.mutate_vector([1, 2]);
  // @ts-expect-error Mutable pointers require native container proxies.
  m.mutate_vector_pointer([1, 2]);
  // @ts-expect-error Native JavaScript maps cannot receive C++ reference mutation.
  m.mutate_map(new Map<number, number>());
  // @ts-expect-error Native JavaScript tuples cannot receive C++ reference mutation.
  m.mutate_pair([1, 2]);
  // @ts-expect-error Proxy element types remain precise.
  vector.push_back('wrong');
  // @ts-expect-error Map proxy key types remain precise.
  map.set('wrong', 1);
  return [values, mapping, tuple];
}
