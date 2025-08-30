# Monoid implementation styles for WESL

This repo contains an exploration of ideas for
interfaces / typeclasses 
for WESL by sketching implementations
of a Monoid in various styles.

## Goal
We'd like to introduce a mechanism for behavior
contracts in WESL. 
A motivating example is the binary operation aka monoid,
useful for operations like reduce and scan.

## Monoid Example
The binary operation has 2 elements:
- a `zero` element
- a `combine` function like plus or min on the element type

Programmers should be able to make functions 
that can use any monoid.

Note that there may be multiple versions of a the combine operation available for an element type.
For example, AddF32 and MinF32 are both monoids on f32 elements.
Programmers will need a way to select which monoid to use.

Graphics programming is performance sensitive, so we'll
normally monomorphize, 
but dynamic dispatch should be possible to add for occasional
use in the future.

## Variations

- [monoid](./monoid.wesl) a 'vanilla' version that supports 
monoids in relatively straightforward way with explicit syntax.
  - the other versions are compared against this version.
   only the notable style differences are shown.
- [struct](./struct.wesl) considers whether we could extend WGSL's struct syntax to define monoids.
- [structural](./structural.wesl) considers using structural rather than nominal typing to define monoids.
- [modules](./modules.wesl) considers enriched modules to define monoids.
- [typeclass](./typeclass.wesl) considers defining monoids as typeclasses.
- [context](./context.wesl) considers using a context mechanism for monoid.
