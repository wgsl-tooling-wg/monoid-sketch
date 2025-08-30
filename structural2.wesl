/// structural typing variant 2
// -> monoid contract is implicitly defined by use, no fixed definition
// + less code, no need to define Monoid interface, etc.
// - harder for IDEs to provide type hints and autocomplete 
// - types are more reliable documentation than comments

// ============= monoid.wesl =============

// no explicit Monoid contract, it's defined implicitly by use in reduce()

const addF32 = {
  type T = f32; // allow 'type' as compile time field 
  const zero = 0.0;
  fn combine(a: f32, b: f32) -> f32 { return a + b; }
}

const minF32 = {
  type T = f32;
  const zero = 3e38;
  fn combine(a: f32, b: f32) -> f32 { return min(a, b); }
}

// ============= reduce.wesl =============
// matching M will be structural based on the fields used (T, zero, combine)
fn reduce(const M: *, arr: array<M.T, 8>) -> M.T { // * as any type. 
  var result = M.zero;
  for (var i = 0; i < 8; i++) {
    result = M.combine(result, arr[i]);
  }
  return result;
}

// ============= app.wesl =============
import package::reduce::reduce;
import package::monoid::addF32;

var<private> d: array<f32, 8>;
var<private> e: array<f32, 8>;
var<private> f: array<f32, 8>;

fn app() {
  reduceEm(addF32);
}

/**
 - accepts any m that follows the monoid contract .T, .zero, .combine
*/
fn reduceEm(const m: *) {
  reduce(m, d);
  reduce(m, e);
  reduce(m, f);
}