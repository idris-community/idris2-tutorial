# Conclusion

In this chapter, we learned:

- A function in Idris can take an arbitrary number of arguments, separated by `->` in the function's type.

- Functions can be combined sequentially using the dot operator `(.)`, which leads to concise code.

- Functions can be partially applied by passing them fewer arguments than they expect, resulting in a new function expecting the remaining arguments. This technique is called *currying*.

- Functions can be passed as arguments to other functions, which allows us to easily combine small units of code to create more complex behavior.

- If writing a corresponding top level function would be too cumbersome, we can pass anonymous functions (*lambdas*) to higher-order functions.

- Idris allows us to define our own infix operators. These have to be written in parentheses unless they are being used in infix notation.

- Infix operators can also be partially applied. These *operator sections* have to be wrapped in parentheses, and the position of the argument determines whether it is used as the operator's first or second argument.

- Idris supports name overloading, functions can have the same names but different implementations. Idris will decide which function to use based to the types involved.

Please note, that function and operator names within an individual a module must be unique. In order to define two functions with the same name, they have to be declared in distinct modules. If Idris is not able to decide which of the two functions to use, we can help name resolution by prefixing a function with (a part of) its *namespace*:

```repl
Tutorial.Functions1> :t Prelude.not
Prelude.not : Bool -> Bool
Tutorial.Functions1> :t Functions1.not
Tutorial.Functions1.not : (Integer -> Bool) -> Integer -> Bool
```

## What's next

In the next section, we will learn how to define our own data types and how to construct and deconstruct values of these new types. We will also learn about generic types and functions.
