import createModule = require('./overload_wrap');
async function check() {
  const m = await createModule();
  const n: number = m.choose(2);
  const s: string = m.choose('a');
  const d = new m.Derived();
  const b: number = d.base();
  const combined = new m.Combined();
  const left: number = m.Combined.left_static();
  const right: number = combined.right();
  const throughBase: number = m.read_right(combined);
  const w: bigint = m.default_wide();
  // @ts-expect-error There is no boolean overload.
  m.choose(true);
  return [n, s, b, w, left, right, throughBase];
}
