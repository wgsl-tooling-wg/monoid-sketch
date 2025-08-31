/// functor variant (ML/OCaml style)
// -> functors (module functions) for parameterized modules  
// + clear abstraction boundaries - functors are explicitly parameterized
// + type-safe composition of modules
// - even more verbose than base module approach
// - requires understanding functor concept

// ============= stdlib.wesl =============
contract Type<t: type> {
  type t: t; // t is being exposed by this contract
}

module F32: Numeric + Type<f32> {
  type t = f32;
  // rest of impl, would be special cased as built in type
}

// ============= monoid.wesl =============
contract Monoid {
  type t; // t is an opaque type here
  const zero: t;
  fn combine(a: t, b: t) -> t;
}

// Module implementation must satisfy both Monoid AND Type<F32> contracts
// Implementation details are hidden by the specifying the two contracts as the module return type
module Add<T: Numeric>: Monoid + Type<T::t> { 
  import T::(+);
  alias t = T::t;
  const zero: t = T::zero;
  fn combine(a: t, b: t) -> t { return a + b; }
}

// Module implementation must satisfy contract
// The impl states that MinF32 must satisfy the Monoid contract
// but all module members are exposed.
module Min<T: Numeric> impl Monoid {
  alias t = T::t;
  const zero: t = T::MAX_VALUE;
  fn combine(a: t, b: t) -> t { return T::min(a, b); }
}

// ============= reduce.wesl =============
// Functor: module function that takes Monoid module and returns a module with reduce function
module MakeReducer<M: Monoid> {
  fn reduce(a: array<M::t, 8>) -> M::t {
    var result = M::zero;
    for (var i = 0; i < 8; i++) {
      result = M::combine(result, a[i]);
    }
    return result;
  }
}

// ============= app.wesl =============
import package::monoid::{Add, Min};
import package::reduce::MakeReducer;

// Apply functor to create specialized reducer modules
// Note that these are specialised once.
alias AddReducer = MakeReducer<Add<F32>>;
alias MinReducer = MakeReducer<Min<F32>>;

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
