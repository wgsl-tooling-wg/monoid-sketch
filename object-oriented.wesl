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
    var result = self.zero();
    for (var i = 0; i < 8; i++) {
      result = self.combine(result, a[i]);
    }
    return result;
  }
  // Abstract methods to be implemented by subclasses
  abstract fn zero() -> T;
  abstract fn combine(a: T, b: T) -> T;
}

struct AddReducer : BaseReducer<f32> {
  override fn zero() -> f32 { return 0.0; }
  override fn combine(a: f32, b: f32) -> f32 { return a + b; }
}

struct MinReducer : BaseReducer<f32> {
  override fn zero() -> f32 { return 3e38; }
  override fn combine(a: f32, b: f32) -> f32 { return min(a, b); }
}

// ============= app.wesl =============
