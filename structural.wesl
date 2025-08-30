/// --- structural typing variant 1
// + saves a bit of formality
// + lays the groundwork for struct composition
// - conflict with WGSL nominally typed structs?

/// monoid.wesl

const addF32 = { // has the shape of a monoid, so no need to annotate with type
  zero: 0f;
  combine(a: f32, b: f32) { return a + b; };

  sentinel: -1f; // ok to add extra fields and methods 
  subgroupCombine: subgroupAdd;    
}

/// --- structural typing variant 2
// -> monoid contract is implicitly defined by use
// + less code, no need to define Monoid interface, etc.
// - does this break IDEs? 
// - types are more reliable documentation then comments

const addF32 = {
  const T = f32;
  const zero = 0.0;
  fn combine(a: f32, b: f32) -> f32 { return a + b; }
}

fn reduce(const M: *, arr: array<M.T>) -> M.T {
  var result = M.zero;
  for (var i = 0u; i < arrayLength(&arr); i = i + 1u) {
    result = M.combine(result, arr[i]);
  }
  return result;
}