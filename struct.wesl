/// --- struct syntax variant
// + embrace and extend existing struct concept
// - conceptually separate data record format from behavior contracts?

struct Monoid<T> { 
  zero: T;
  combine(a: T, b: T) -> T; // struct can define behavior on a type too
}

fn combineF32(a: f32, b: f32) { return a + b; }
const addF32 = Monoid<f32>(0f, combineF32); 

// optionally, extend constructor syntax with named params for readability:
const addF32 = Monoid<f32>(
  combine = combineF32,
  zero = 0f, 
);