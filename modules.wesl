/// --- module variant
// -> modules define types with param alias
// + type variables don't need as much special syntax
// + integrates nicely with param const ideas
// - more verbose than type parameter syntax
// - different direction than wgsl type generators?
// - module style is less familiar for most users

// ============= monoid.wesl =============
module contract Monoid { // module contract like ML's module sig
  param alias T;
  param const zero: T;
  fn combine(a: T, b: T) -> T;
}

module AddF32: Monoid = { // module implementation must satisfy contract
  param alias T = f32;
  param const zero = 0.0;
  fn combine(a: f32, b: f32) -> f32 { return a + b; }
};

// ============= reduce.wesl =============
param alias R;
param const M: Monoid with {T = R}; // with syntax for param alias on Monoid

fn reduce(a: array<R, 8>) -> R {
  var result = M::zero;
  for (var i = 0; i < 8; i++) {
    result = M::combine(result, a[i]);
  }
  return result;
}

// ============= app.wesl =============
import package::monoid::AddF32;
import package::reduce::reduce with {R = f32, M = AddF32}; // parameterize module

fn app() {
  reduceEm();
}

fn reduceEm() {
  reduce(d);
  reduce(e);
  reduce(f);
}

