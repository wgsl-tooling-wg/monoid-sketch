// ============= monoid.wesl =============
mixin IMonoid<T> {
  zero: T; 
  combine(a: T, b: T) -> T;
}

// ============= reduce.wesl =============
import package::monoid::IMonoid;

// Abstract base reducer with template method pattern
abstract struct BaseReducer<T> : IMonoid<T> {
  // Template methods that use the abstract monoid operations
  fn reduce(a: array<T, 8>) -> T {
    var result = self.zero;
    for (var i = 0; i < 8; i++) {
      result = self.combine(result, a[i]);
    }
    return result;
  }
  // Abstract properties/methods to be implemented by subclasses
  abstract zero: T;
  abstract fn combine(a: T, b: T) -> T;
}

struct AddReducer : BaseReducer<f32> {
  override zero: f32 = 0.0;
  override fn combine(a: f32, b: f32) -> f32 { return a + b; }
}

struct MinReducer : BaseReducer<f32> {
  override zero: f32 = 3e38;
  override fn combine(a: f32, b: f32) -> f32 { return min(a, b); }
}

// ============= app.wesl =============
import package::reduce::{AddReducer, MinReducer};

var<private> d: array<f32, 8>;
var<private> e: array<f32, 8>;
var<private> f: array<f32, 8>;

fn app() {
  let addReducer = AddReducer();
  reduceEm(addReducer);
}

fn reduceEm(reducer: BaseReducer<f32>) {
  reducer.reduce(d);
  reducer.reduce(e);
  reducer.reduce(f);
}
