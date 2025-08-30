/// --- context variant
// -> '# context' syntax 
// -> monoid parameter goes into context rather than parameter, can be inferred
// + context inference makes things concise 
// + context extends to passing struct instance through nested fns (prop drilling).
// - context style is less familiar to most users

fn reduce<T #Monoid(m)>(a: array<T, 8>) { // monoid as context
  var result = m.zero;
  for (var i = 0; i < 8; i++) {
    result = m.combine(result, array[i]);
  }
  return result;  
}

fn reduceEm<T #Monoid>() {  // monoid type in context is in scope for reduce calls 
  reduce(d);
  reduce(e);
  reduce(f);
}

fn app() {
  reduceEm<addF32>();     // select monoid in type parameters
}

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
  foo<grid>();
}

fn foo<#Grid> { bar(); }
fn bar<#Grid> { zap(); }
fn zap<#Grid> { zee(); }

fn zee<#Grid(g)> { g.globalIndex; }