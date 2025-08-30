/// --- module variant
// -> modules define types as param const with `@Type`
// + type variables don't need as much special syntax
// + integrates nicely with param const ideas
// - more verbose than type parameter syntax
// - different direction than wgsl type generators?
// - module style is less familiar for most users

// monoid.wesl
module contract Monoid {
  param alias T;
  param const zero: T;
  fn combine(a: T, b: T) -> T;
}

module AddF32: Monoid = {
  param alias T = f32;
  param const zero = 0.0;
  fn combine(a: f32, b: f32) -> f32 { return a + b; }
};

/// reduce.wesl
param alias R;
param const M: Monoid with {T = R};

fn reduce(array: array<f32, 8>) -> f32 {
  var result = M::zero;
  for (var i = 0; i < 8; i++) {
    result = M::combine(result, array[i]);
  }
  return result;
}

/// app.wesl
import package::monoid::AddF32;
import package::reduce::reduce with {R = f32, M = AddF32};

fn app() {
  reduceEm();
}

fn reduceEm() {
  reduce(d);
  reduce(e);
  reduce(f);
}

