# Summary

[The Idris 2 Programming Langauge](./Preface.md)

# Core Language Features

- [Introduction](./Tutorial/Intro.md)
  - [About The Idris Programming Language](./Tutorial/Intro/AboutTheLanguage.md)
  - [Using the REPL](./Tutorial/Intro/UsingTheRepl.md)
  - [A First Idris Program](./Tutorial/Intro/FirstIdrisProgram.md)
  - [The Shape of an Idris Definition](./Tutorial/Intro/ShapeOfADef.md)
  - [Where to Get Help](./Tutorial/Intro/WhereToGetHelp.md)
  - [Conclusion](./Tutorial/Intro/Conclusion.md)
- [Introduction To Functions](./Tutorial/Functions1.md)
  - [Functions With More Than One Argument](./Tutorial/Functions1/FunctionsWithMultipleArguments.md)
  - [Function Composition](./Tutorial/Functions1/FunctionComposition.md)
  - [Higher Order Functions](./Tutorial/Functions1/HigherOrder.md)
  - [Currying](./Tutorial/Functions1/Currying.md)
  - [Anonymous Functions](./Tutorial/Functions1/Lambdas.md)
  - [Operators](./Tutorial/Functions1/Operators.md)
  - [Introductory Function Exercises](./Tutorial/Functions1/Exercises.md)
  - [Conclusion](./Tutorial/Functions1/Conclusion.md)
- [Algebraic Data Types](./Tutorial/DataTypes.md)
  - [Enumerations](./Tutorial/DataTypes/Enumerations.md)
  - [Enumeration Exercises](./Tutorial/DataTypes/Exercises1.md)
  - [Sum Types](./Tutorial/DataTypes/SumTypes.md)
  - [Sum Type Exercises](./Tutorial/DataTypes/Exercises2.md)
  - [Records](./Tutorial/DataTypes/Records.md)
  - [Record Exercises](./Tutorial/DataTypes/Exercises3.md)
  - [Generic Data Types](./Tutorial/DataTypes/GenericDataTypes.md)
  - [Generic Data Type Exercises](./Tutorial/DataTypes/Exercises4.md)
  - [Alternative Syntax for Data Definitions](./Tutorial/DataTypes/AltSyntax.md)
  - [Conclusion](./Tutorial/DataTypes/Conclusion.md)
- [Interfaces](./Tutorial/Interfaces.md)
  - [Interface Basics](./Tutorial/Interfaces/Basics.md)
  - [Exercises](./Tutorial/Interfaces/Exercises1.md)
  - [More About Interfaces](./Tutorial/Interfaces/More.md)
  - [Exercises](./Tutorial/Interfaces/Exercises2.md)
  - [Interfaces in the Prelude](./Tutorial/Interfaces/Prelude.md)
  - [Exercises](./Tutorial/Interfaces/Exercises3.md)
  - [Conclusion](./Tutorial/Interfaces/Conclusion.md)
- [Functions Part 2](./Tutorial/Functions2.md)
  - [Let Bindings and Local Definitions](./Tutorial/Functions2/LetBindings.md)
  - [Exercises](./Tutorial/Functions2/Exercises1.md)
  - [The Truth about Function Arguments](./Tutorial/Functions2/TheTruth.md)
  - [Programming with Holes](./Tutorial/Functions2/Holes.md)
  - [Conclusion](./Tutorial/Functions2/Conclusion.md)
- [Dependent Types](./Tutorial/Dependent.md)
  - [Length-Indexed Lists](./Tutorial/Dependent/LengthIndexedLists.md)
  - [Exercises](./Tutorial/Dependent/Exercises1.md)
  - [Fin: Safe Indexing Into Vectors](./Tutorial/Dependent/Fin.md)
  - [Exercises](./Tutorial/Dependent/Exercises2.md)
  - [Compile-Time Computations](./Tutorial/Dependent/Comptime.md)
  - [Exercises](./Tutorial/Dependent/Exercises3.md)
  - [Conclusion](./Tutorial/Dependent/Conclusion.md)
- [IO: Programming with Side Effects](./Tutorial/IO.md)
  - [Pure Side Effects?](./Tutorial/IO/PureSideEffects.md)
  - [Exercises](./Tutorial/IO/Exercises1.md)
  - [Do Blocks, Desugared](./Tutorial/IO/DoUnsugared.md)
  - [Exercises](./Tutorial/IO/Exercises2.md)
  - [Working With Files](./Tutorial/IO/Files.md)
  - [Exercises](./Tutorial/IO/Exercises3.md)
  - [How `IO` is Implemented](./Tutorial/IO/Impl.md)
  - [Conclusion](./Tutorial/IO/Conclusion.md)
- [Functor and Friends](./Tutorial/Functor.md)
  - [Functor](./Tutorial/Functor/Functor.md)
  - [Exercises](./Tutorial/Functor/Exercises1.md)
  - [Applicative](./Tutorial/Functor/Applicative.md)
  - [Exercises](./Tutorial/Functor/Exercises2.md)
  - [Monad](./Tutorial/Functor/Monad.md)
  - [Exercises](./Tutorial/Functor/Exercises3.md)
  - [Background and further Reading](./Tutorial/Functor/Background.md)
  - [Conclusion](./Tutorial/Functor/Conclusion.md)
- [Recursion and Folds](./Tutorial/Folds.md)
  - [Recursion](./Tutorial/Folds/Recursion.md)
  - [Exercises](./Tutorial/Folds/Exercises1.md)
  - [Notes on Totality Checking](./Tutorial/Folds/Totality.md)
  - [Exercises](./Tutorial/Folds/Exercises2.md)
  - [Interface Foldable](./Tutorial/Folds/Foldable.md)
  - [Exercises](./Tutorial/Folds/Exercises3.md)
  - [Conclusion](./Tutorial/Folds/Conclusion.md)
- [Effectful Traversals](./Tutorial/Traverse.md)
  - [Reading CSV Tables](./Tutorial/Traverse/CSV.md)
  - [Exercises](./Tutorial/Traverse/Exercises1.md)
  - [Programming with State](./Tutorial/Traverse/State.md)
  - [Exercises](./Tutorial/Traverse/Exercises2.md)
  - [The Power of Composition](./Tutorial/Traverse/Composition.md)
  - [Exercises](./Tutorial/Traverse/Exercises3.md)
  - [Conclusion](./Tutorial/Traverse/Conclusion.md)
- [Sigma Types](./Tutorial/DPair.md)
  - [Dependent Pairs](./Tutorial/DPair/DPair.md)
  - [Exercises](./Tutorial/DPair/Exercises1.md)
  - [Use Case: Nucleic Acids](./Tutorial/DPair/DNA.md)
  - [Exercises](./Tutorial/DPair/Exercises2.md)
  - [Use Case: CSV Files with a Schema](./Tutorial/DPair/CSV.md)
  - [Exercises](./Tutorial/DPair/Exercises3.md)
  - [Conclusion](./Tutorial/DPair/Conclusion.md)
- [Propositional Equality](./Tutorial/Eq.md)
  - [Equality as a Type](./Tutorial/Eq/Eq.md)
  - [Exercises](./Tutorial/Eq/Exercises1.md)
  - [Programs as Proofs](./Tutorial/Eq/ProgramsAsProofs.md)
  - [Exercises](./Tutorial/Eq/Exercises2.md)
  - [Into the Void](./Tutorial/Eq/Void.md)
  - [Exercises](./Tutorial/Eq/Exercises3.md)
  - [Rewrite Rules](./Tutorial/Eq/Rewrite.md)
  - [Exercises](./Tutorial/Eq/Exercises4.md)
  - [Conclusion](./Tutorial/Eq/Conclusion.md)
- [Predicates and Proof Search](./Tutorial/Predicates.md)
  - [Preconditions](./Tutorial/Predicates/Preconditions.md)
  - [Exercises](./Tutorial/Predicates/Exercises1.md)
  - [Contracts between Values](./Tutorial/Predicates/Contracts.md)
  - [Exercises](./Tutorial/Predicates/Exercises2.md)
  - [Use Case: Flexible Error Handling](./Tutorial/Predicates/ErrorHandling.md)
  - [Exercises](./Tutorial/Predicates/Exercises3.md)
  - [The Truth about Interfaces](./Tutorial/Predicates/Truth.md)
  - [Conclusion](./Tutorial/Predicates/Conclusion.md)
- [Primitives](./Tutorial/Prim.md)
  - [How Primitives are Implemented](./Tutorial/Prim/Prim.md)
  - [Working with Strings](./Tutorial/Prim/Strings.md)
  - [Exercises](./Tutorial/Prim/Exercises1.md)
  - [Integers](./Tutorial/Prim/Integers.md)
  - [Exercises](./Tutorial/Prim/Exercises2.md)
  - [Refined Primitives](./Tutorial/Prim/Refined.md)
  - [Exercises](./Tutorial/Prim/Exercises3.md)
  
# Idris 2 by Example

- [An MDBook Preprocessor in Idris 2](./Preprocessor.md)
  - [The Preprocessor Executable](./Preprocessor/Binary.md)

______________________________________________________________________

# Appendices

- [Getting Started with pack and Idris 2](./Appendices/Install.md)
- [Interactive Editing in Neovim](./Appendices/Neovim.md)
- [Structuring Idris Projects](./Appendices/Projects.md)
- [A Deep Dive into Quantitative Type Theory](./Appendices/QTT.md)

______________________________________________________________________

# Exercise Solutions

<!-- - [Introductory Function Exercises](./Solutions/Functions1.md) -->
<!-- - [Algebraic Data Types](./Solutions/DataTypes.md) -->
<!-- - [Interfaces](./Solutions/Interfaces.md) -->
<!-- - [Functions Part 2](./Solutions/Functions2.md) -->
<!-- - [Dependent Types](./Solutions/Dependent.md) -->
<!-- - [IO: Programming with Side Effects](./Solutions/IO.md) -->
<!-- - [Functor and Friends](./Solutions/Functor.md) -->
<!-- - [Recursion and Folds](./Solutions/Folds.md) -->
<!-- - [Effectful Traversals](./Solutions/Traverse.md) -->
<!-- - [Sigma Types](./Solutions/DPair.md) -->
<!-- - [Propositional Equality](./Solutions/Eq.md) -->
<!-- - [Predicates and Proof Search](./Solutions/Predicates.md) -->
<!-- - [Primitives](./Solutions/Prim.md) -->
