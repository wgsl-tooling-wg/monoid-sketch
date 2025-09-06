# Monoid implementation styles for WESL

This repo contains an exploration of ideas for abstraction mechanisms 
for behavior contracts in WESL by sketching contracts and
implementations of Monoid in various styles.

## Goal
We'd like to introduce a mechanism for behavior
contracts in WESL. 
A motivating example is the Monoid abstraction,
a widely useful primitive in GPU programming that's applicable
to algorithms like reduce and scan.

What other model problems should we consider?

## Monoid Example
A monoid has 2 components:
- a `zero` element (the identity element)
- a `combine` function that is associative (like plus or min on the element type)

## Parametric and ad-hoc Polymorphism
Programmers should be able to make functions 
that can use any monoid (parametric polymorphism). 

Note that there may be multiple monoid implementations 
available for a single element type (ad-hoc polymorphism).
For example, AddF32 and MinF32 are both monoids on f32 elements.
Programmers should be able to write their own monoids,
and programmers will need a way to select which monoid to use.

## Style Variations
- [instance](./instance.wesl) version with explicit monoid instances.
  - The other versions are compared against this version.
- [object-oriented](./object-oriented.wesl) monoids as mixins,
    inspired by Java/C++ inheritance.
- [typeclass](./typeclass.wesl) monoids as pure behavior typeclasses,
    inspired by haskell/rust typeclasses.
- [context](./context.wesl) monoids as typeclass instances via context.
    inspired by kotlin/scala context.
- [modules-functors](./modules-functors.wesl) monoids as modules
    with module functors, inspired by ml/ocaml.

### Bonus variations
- [struct](./struct.wesl) 
    extend WGSL's struct syntax to define monoids.
- [structural](./structural.wesl)
    use structural rather than nominal typing to define monoids, 
    inspired by typescript or go.
- [structural2](./structural2.wesl) 
    even further with the structural typing approach,
    inspired by zig.
- [modules](./modules.wesl) 
    simple enriched WESL modules to define monoids.
- [multiple-dispatch](./multiple-dispatch.wesl) 
    static function overloading approach
    inspired by julia.

## Implementation
Graphics programming is performance sensitive, so we'll
normally use monomorphization 
(generating specialized code for each behavior+type variation). 

Separate compilation isn't required for WGSL/WESL transpilation,
we can do whole program analysis before generating target code.
But it's important to bound the effort to analyze each file
so that the language server can do its work quickly.

## Future features of interest
We should aim for behavior contract designs to be compatible with 
potential future features that might make it into wesl/wgsl someday.

- Dynamic dispatch should be possible to add for occasional
use in the future. 
See [dynamic](./Dynamic.md) for a quick sketch on implementing 
dynamic dispatch.

- Operator overloading has been requested, 
e.g., for complex numbers or 64 bit types.

## Design background
As noted in [Who are WESL Programmers](https://wesl-lang.dev/spec/Designing#who-are-wesl-programmers), 
we want WESL to be easy to pick up, easy to read, and close to WGSL.
Of course, as we add new features for the WebGPU community, 
all those attributes will be harder to maintain. I'd suggest we aim for:
- primarily **one way to do it**
  - e.g., if we're choosing between type parameters (`fn foo<M: Monoid>`) 
    or module param types (`param alias M = Monoid`), let's pick one
    and not do both.
  - of course, we can later find a new best approach, 
    and keep both ways alive for a transition period. But let's
    aim to always have one recommended way.
- consistent, generally applicable, **orthogonal features**
  - if we think one of next year's features might overlap with this year's 
    features, let's do a rough feasibility sketch 
    to make sure it plausibly fits with this year's plan.
    of course, it's impractical to design the entire language at once, but 
    we can sketch.
    e.g., we might consider whether function overloading, 
    operator overloading, or dynamic dispatch would fit with our behavior
    contract plans.

