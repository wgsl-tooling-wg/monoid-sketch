// very Julia inspired

// ============= monoid.wesl =============
contract Monoid<T> { }

contract fn zero<T>(m: Monoid<T>) -> T;
contract fn combine<T>(m: Monoid<T>, a: T, b: T) -> T;


// Concrete implementation for Add
struct AddF32: Monoid<f32> { }
fn zero(m: AddF32) -> f32 { return 0.0 }
fn combine(m: AddF32, a: f32, b: f32) -> f32  { return a + b; }

// Generic implementations for min!
struct Min<T>: Monoid<T> { }
fn zero(m: Min<f32>) -> f32 { return 0.0 }
fn combine(m: Min<f32>, a: f32, b: f32) -> f32  { return min(a, b); }
fn zero(m: Min<vec2f>) -> vec2f { return vec2f() }
fn combine(m: Min<vec2f>, a: vec2f, b: vec2f) -> f32  { return min(a, b); }

// ============= reduce.wesl =============
fn reduce<T, M: Monoid<T>>(a: array<T, 8>, m: Monoid<T>) {
  var result = zero(m);
  for (var i = 0; i < 8; i++) {
    result = combine(m, result, a[i]);
        //   ^^^^^^ Hooray free standing WGSL-y functions :D
  }
  return result;  
}

// ============= app.wesl =============
import package::reduce::reduce;
import package::monoid::{AddF32, Min};

var<private> d: array<f32, 8>;
var<private> e: array<f32, 8>;
var<private> f: array<f32, 8>;
var<private> g: array<vec2f, 8>;

fn app() {
  reduceEm(AddF32());

  reduce(g, Min<vec2f>());
  //            ^^^^^^ I think we have to specify this, because WGSL type inference is not very Hindley–Milner 
}

fn reduceEm<T>(m: Monoid<T>) {
  reduce(d, m);
  reduce(e, m);
  reduce(f, m);
}
