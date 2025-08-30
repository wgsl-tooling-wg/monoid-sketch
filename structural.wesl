/// --- structural typing variant 1
// -> allow types to satisfy contracts by having matching fields. 
//   (structural typing instead of nominal typing)
// + saves a bit of formality
// + lays the groundwork for struct composition
// - conflict with WGSL nominally typed structs?

// ============= monoid.wesl =============
contract Monoid<T> { // define the monoid contract
  zero: T;
  combine(a: T, b: T) -> T;
}

const addF32 = { // has the shape of a monoid, so no need to annotate with type
  zero: 0.0;
  combine(a: f32, b: f32) { return a + b; };

  sentinel: -1.0; // ok to add extra fields and functions w/ structural typing
  subgroupCombine: subgroupAdd; // reference a WGSL fn
}

const minF32 = { // has the shape of a monoid, so no need to annotate with type
  zero: 3e38,
  combine(a: f32, b: f32) { return min(a, b); }
}


// ============= reduce.wesl =============
import package::monoid::Monoid;

fn reduce<T>(a: array<T, 8>, const m: Monoid<T>) -> T { // 'const' to note that m isn't passed at runtime
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