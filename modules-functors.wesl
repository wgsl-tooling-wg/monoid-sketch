/// functor variant (ML/OCaml style)
// -> functors (module functions) for parameterized modules  
// + clear abstraction boundaries - functors are explicitly parameterized
// + type-safe composition of modules
// - even more verbose than base module approach
// - requires understanding functor concept

// ============= monoid.wesl =============
module contract Monoid { // module contract like ML's module type/signature
  type T;
  const zero: T;
  fn combine(a: T, b: T) -> T;
}

module AddF32: Monoid = { // module implementation must satisfy contract
  alias T = f32;
  const zero: T = 0.0;
  fn combine(a: f32, b: f32) -> f32 { return a + b; }
};

module MinF32: Monoid = {
  alias T = f32;
  const zero: T = 3e38;
  fn combine(a: f32, b: f32) -> f32 { return min(a, b); }
};

// ============= reduce.wesl =============
// Functor: module function that takes Monoid module and returns a module with reduce function
module MakeReducer<M: Monoid> {
  fn reduce(a: array<M::T, 8>) -> M::T {
    var result = M::zero;
    for (var i = 0; i < 8; i++) {
      result = M::combine(result, a[i]);
    }
    return result;
  }
}

// ============= app.wesl =============
import package::monoid::{AddF32, MinF32};
import package::reduce::MakeReducer;

// Apply functor to create specialized reducer modules
// Note that these are specialised once.
alias AddReducer = MakeReducer<AddF32>;
alias MinReducer = MakeReducer<MinF32>;

var<private> d: array<f32, 8>;
var<private> e: array<f32, 8>;
var<private> f: array<f32, 8>;

fn app() {
  reduceEm();
}

fn reduceEm() {
  AddReducer::reduce(d);  // use add monoid
  MinReducer::reduce(e);  // use min monoid  
  MinReducer::reduce(f);  // use min monoid again
}
