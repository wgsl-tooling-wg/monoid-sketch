/// typeclass variant
// -> contract implementations are always matched by type
// + static implementation boundary is clear (typeclasses are obviously not runtime params)
// - requires marker types which adds indirection and complexity

// ============= monoid.wesl =============
contract Monoid<T> {
  zero: T;
  combine(a: T, b: T) -> T;
}

struct AddF32;   // marker type
typeclass Monoid<f32> for AddF32 { // implementation for marker type
  const zero: f32 = 0.0;
  fn combine(a: f32, b: f32) -> f32 { return a + b; }
}

struct MinF32;   // marker type
typeclass Monoid<f32> for MinF32 { // implementation for marker type
  const zero: f32 = 3e38;
  fn combine(a: f32, b: f32) -> f32 { return min(a, b); }
}

// ============= reduce.wesl =============
import package::monoid::Monoid;

fn reduce<T, M: Monoid<T>>(a: array<T, 8>) {  // monoid as typeclass
  var result = M.zero;
  for (var i = 0; i < 8; i++) {
    result = M.combine(result, a[i]);
  }
  return result;  
}

// ============= app.wesl =============
import package::reduce::reduce;
import package::monoid::AddF32;

var<private> d: array<f32, 8>;
var<private> e: array<f32, 8>;
var<private> f: array<f32, 8>;

fn app() {
  reduceEm<f32, AddF32>();     // select monoid in type parameters
}

fn reduceEm<T, M: Monoid<T>>() {
  reduce<T, M>(d);
  reduce<T, M>(e);
  reduce<T, M>(f);
}
