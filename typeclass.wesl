/// typeclass variant
// -> contract implementations are always matched by type
// + static implementation boundary is clear (typeclasses are obviously not runtime params)
// - marker type gymnastics adds extra indirection / complexity

/// reduce.wesl
fn reduce<T, M: Monoid<T>>(a: array<T, 8>) {  // monoid as typeclass
  var result = M.zero;
  for (var i = 0; i < 8; i++) {
    result = M.combine(result, array[i]);
  }
  return result;  
}

/// app.wesl
struct AddF32;   // marker type

typeclass Monoid<f32> for AddF32 { // implementation for marker type
  const zero: f32 = 0.0;
  fn combine(a: f32, b: f32) -> f32 { a + b }
}

fn reduceEm<M: Monoid<T>() {
  reduce<M>(d);
  reduce<M>(e);
  reduce<M>(f);
}

fn app() {
  reduceEm<addF32>();     // select monoid in type parameters
}