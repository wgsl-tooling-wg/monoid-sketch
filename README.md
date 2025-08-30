# Monoid implementation styles for WESL

This repo contains an exploration of ideas for abstract interfaces 
for WESL by sketching implementations of a Monoid in various styles.

## Goal
We'd like to introduce a mechanism for behavior
contracts in WESL. 
A motivating example is the Monoid abstraction,
a widely useful primitive in GPU programming that's applicable
to algorithms like reduce and scan.

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
- [monoid](./monoid.wesl) a 'vanilla' version with explicit syntax.
  - The other versions are compared against this version.
    Only the notable style differences are shown.
- [struct](./struct.wesl) considers whether we could extend WGSL's struct syntax to define monoids.
- [structural](./structural.wesl) considers using structural rather than nominal typing to define monoids, inspired by typescript or go.
- [structural2](./structural2.wesl) even further with the structural typing approach,
  inspired by zig.
- [modules](./modules.wesl) considers enriched WESL modules to define monoids.
- [modules-functors](./modules-functors.wesl) extends the modules example 
  with module functors, inspired by ml/ocaml.
- [typeclass](./typeclass.wesl) considers defining monoids as typeclasses,
  inspired by haskell/rust typeclasses.
- [context](./context.wesl) considers using a context mechanism for monoid.
  inspired by kotlin/scala context.

## Implementation
Graphics programming is performance sensitive, so we'll
normally use monomorphization (generating specialized code for each type). 

Dynamic dispatch should be possible to add for occasional
use in the future. 
See [dynamic](./Dynamic.md) for a quick sketch on implementing 
dynamic dispatch.

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

