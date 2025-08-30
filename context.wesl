/// context variant
// -> extend type parameters syntax to allow context type contracts with `#`
// -> context implementations can be runtime instances
// + context inference makes things concise
// + context extends to passing struct instance through nested fns (prop drilling).
// - context style is less familiar to most users

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

// T type parameter, Monoid<T> as context parameter
fn reduce<T#Monoid as m>(a: array<T, 8>) -> T { 
  var result = m.zero;
  for (var i = 0; i < 8; i++) {
    result = m.combine(result, a[i]);
  }
  return result;  
}

// ============= app.wesl =============
import package::reduce::reduce;
import package::monoid::{addF32, minF32};

var<private> d: array<f32, 8>;
var<private> e: array<f32, 8>;
var<private> f: array<f32, 8>;

fn app() {
  reduceEm<#addF32>();     // select monoid as context parameters
}

fn reduceEm<#Monoid>() {  // Monoid<T> in context scope, reduce calls don't need annotation
  reduce(d);
  reduce(e);
  reduce<#minF32>(f); // though you can select a different monoid
}

// -------------------

// context is also handy for passing structs to nested fns

struct Grid {
  globalIndex: vec3u;
  numWorkgroups: vec3u;
  workgroupId: vec3u;
  localIndex: u32;
  subgroupId: u32;
  subgroupSize: u32;
}

@compute
fn app(@global_invocation_index globalIndex) {
  let grid = Grid(globalIndex, ...);
  foobar<grid>();
}

fn foobar<#Grid>() {
  foo(); // context type inference conveniently fills in context
  bar();
  zap();
  zee();
}

fn foo<#Grid>() { bar(); }
fn bar<#Grid>() { zap(); }
fn zap<#Grid>() { zee(); }

fn zee<#Grid(g)> { g.globalIndex; }