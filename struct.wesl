/// struct variant
// + embrace and extend existing struct concept
// - mixing data structures with behavior may be conceptually unclear

// ============= monoid.wesl =============
struct Monoid<T> { 
  zero: T;
  combine(a: T, b: T) -> T; // extend WGSL struct to allow fn on a type too
}

fn combineF32(a: f32, b: f32) -> f32 { return a + b; }
fn combineMinF32(a: f32, b: f32) -> f32 { return min(a, b); }

const addF32 = Monoid<f32>(0.0, combineF32); 
const minF32 = Monoid<f32>(3e38, combineMinF32);

// optionally, extend WGSL struct constructor syntax with named params for readability:
const altAddF32 = Monoid<f32>(
  combine = combineF32,
  zero = 0.0, 
);

// ============= reduce.wesl =============
import package::monoid::Monoid;

fn reduce<T>(a: array<T, 8>, const m: Monoid<T>) -> T { // 'const' to note that m isn't passed at runtime
  var result: T = m.zero;
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