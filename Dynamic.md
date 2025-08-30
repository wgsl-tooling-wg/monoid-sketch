To enable dynamic dispatch for one of these schemes:
- We might mark an interface that 
  is to be dynamcially dispatched with an annotation, like `@dynamic`.
- First, we need to identify the universe of types that 
  will be dynamically dispatched for a given interface.
- Then, if there's more than one type, we need to rewrite every call to
  functions in that interface that function to instead call
  call a selector function that takes a selector parameter in addition to the normal function arguments.
- The selector function would use if conditions based on the selector 
  to decide which implementation to call.
- To identify the universe of implementations for a dynamic function, 
  - a first version could use reachability analysis from the root module 
    to identify all implementations or that interface.

```rs
/// monoid.wesl
@dynamic                // mark as dynamic
contract Monoid<T> { 
  zero: T;
  combine(a: T, b: T) -> T;
}

const addF32: Monoid<f32> = { // a monoid for adding f32 values
  zero: 0f;
  combine(a: f32, b: f32) { return a + b; }
}
```

Then the transpiler would rewrite to add selectors and selector functions:

```rs
// Instances get a selector field 
const addF32: Monoid<f32> = {
  zero: 0f;
  combine(a: f32, b: f32) { return a + b; }
  _selector: 1
}

const minF32: Monoid<f32> = {
  zero: 1e38;
  combine(a: f32, b: f32) { return min(a, b); }
  _selector: 2
}

// Generate a selector function
fn selectCombine(selector: u32, a: f32, b: f32) -> f32 {
  if (selector === 1) { return addF32(a,b); }
  if (selector === 2) { return minF32(a,b); }
}

// Calls are rewritten to pass the selector field and use the selector function
fn reduce(a: Array<T, 8>, m: Monoid) {
  // original:
  //  m.combine(result, a[i)
  selectCombine(m._selector, result, a[i]);
}

```

Later
- more advanced controls might be desirable, e.g. to 
  mark dymaic types explicitly rather than relying on reachability
```rs
@dynamic(minF32, maxF32) 
contract Monoid<T> { ... }
```