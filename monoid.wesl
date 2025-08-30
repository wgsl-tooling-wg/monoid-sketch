/// base version
// -> 'contract' defines Monoid interface
// -> construct Monoid implementations with 'const' syntax
// -> 'const' parameter syntax to clarify comptime vs runtime params
// -> simple generic type parameters
// -> nominal typing

// ============= monoid.wesl =============
contract Monoid<T> { // define the monoid contract
  zero: T;
  combine(a: T, b: T) -> T;
}

const addF32: Monoid<f32> = { // a monoid for adding f32 values
  zero: 0.0;
  combine(a: f32, b: f32) { return a + b; }
}

const minF32: Monoid<f32> = { // a monoid for finding the minimum of f32 values
  zero: 3e38;
  combine(a: f32, b: f32) { return min(a, b); }
}

// ============= reduce.wesl =============
import package::monoid::Monoid;

fn reduce<T>(a: array<T, 8>, const m: Monoid<T>) { // 'const' to note that m isn't passed at runtime
  var result = m.zero;
  for (var i = 0; i < 8; i++) {
    result = m.combine(result, a[i]);
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

fn reduceEm(m: Monoid<f32>) {
  reduce(d, m);
  reduce(e, m);
  reduce(f, m);
}