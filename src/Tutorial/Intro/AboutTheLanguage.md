# About the Idris Programming Language

Idris is a *pure*, *dependently typed*, *total* *functional* programming language.

Lets break that down and explore what each of those terms means on their own.

## Functional Programming

In functional programming languages, functions are *first-class constructs*, meaning that they can be assigned to variables, passed as arguments to other functions, and returned as results from functions, just like any other value in the language. Unlike in, for instance, object-oriented languages, functions are the main form of abstraction in functional programming.

Whenever we find a common pattern or (almost) identical code in several parts of a project, we try to implement an abstraction over it to avoid writing the same code multiple times. In functional programming, we do this by introducing one or more new functions implementing the required behavior, often trying to be as general as possible to maximize the versatility and re-usability of our functions.

Functional programming languages are concerned with the evaluation of functions, unlike imperative languages, which are concerned with the execution of statements.

## Pure Functional Programming

*Pure* functional programming languages come with an additional important guarantee:

Functions don't have side effects, like writing to a file or mutating global state. They can only compute a result from their arguments possibly by invoking other pure functions, *and nothing else*. Given the same input, a pure function will *always* generate the same output, this property is known as [referential transparency](https://en.wikipedia.org/wiki/Referential_transparency).

Pure functions have several advantages:

- They are easy to test by specifying (possibly randomly generated) sets of input arguments alongside the expected results.

- They are thread-safe. Since they don't mutate global state, they be used in several computations running in parallel without interfering with each other.

There are, of course, also some disadvantages:

- Some algorithms are hard to implement efficiently with only pure functions.

- Writing programs that actually *do* something (have some observable effect) is a bit tricky, but certainly possible.

## Dependent Types

Idris is a strongly, statically typed programming language. Every expression is given a *type* (for instance: integer, list of strings, boolean, function from integer to boolean, etc.), and types are verified at compile time to rule out certain common programming errors.

For instance, if a function expects an argument of type `String` (a sequence of unicode characters, such as `"Hello123"`), it is a *type error* to invoke this function with an argument of type `Integer`, and Idris will refuse to compile such an ill-typed program.

Being *statically typed* means that Idris will catch type errors at *compile time*, before it generates an executable program that can be run. This stands in contrast with *dynamically typed* languages such as Python, which check for type errors at *runtime*, while a program is already being executed. It is the goal of statically typed languages to catch as many type errors as possible before there even is a program that can be run.

Furthermore, Idris is *dependently typed*, which is one of its most characteristic properties in comparison to other programming languages. In Idris, types are *first class*: Types can be passed as arguments to functions, and functions can return types as their results. Types can also *depend* on other *values*, as one example, the return type of a function can depend on the value of one of its arguments. This is a quite abstract statement that may be difficult to grasp at first, but we will be exploring its meaning and the profound impact it has on programming through example as we move through this book.

## Total Functions

A *total* function is a pure function which is guaranteed to return a value of its return type for every possible set of inputs in a finite number of computational steps. A total function will never fail with an exception or loop infinitely, although it can still take arbitrarily long to compute its result.

Idris comes with a totality checker built-in, which allows us to verify that the functions we write are provably total. Totality in Idris is opt-in, as checking the totality of an arbitrary computer program is undecidable in the general case (a dilemma you may recognize as the [halting problem](https://en.wikipedia.org/wiki/Halting_problem)). However, if we annotate a function with the `total` keyword, and the totality checker is unable to verify that the function is, indeed, total, Idris will fail with a type error. Notably, failing to determine a function is total is not the same as judging the function to be non-total.

<!-- vi: filetype=idris2:syntax=markdown
-->
