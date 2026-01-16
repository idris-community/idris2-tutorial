# Generic Data Types

```idris
module Tutorial.DataTypes.GenericDataTypes

import Tutorial.DataTypes.Enumerations
```

Sometimes, a concept is general enough that we'd like to apply it not just to one type, but to all kinds of types. For instance, it would be highly inconvenient if we had to define a notion of a list over and over again for every type we might want to put in a list, a list of integers and a list of strings may have differently typed contents, but they share the same structure, and repeating that structure would lead to lots of code duplication. Instead we'd like to have a single generic list type *parameterized* by the type of value it stores.

In this section, we will explore the definition and use of generic types.

## Maybe

Suppose we want to parse a value of the `Weekday` type, described in the section on enumerations, from user input. Such a parsing function should return `Saturday` if the user provided string was `"Saturday"`, but what should it return if the input were, say, `"sdfkl332"`? We have a number of options here. For instance, we could return another "default" value, such as `Sunday`, but we must consider what behavior programmers using our library might expect. Silently continuing with such a default value in the face of invalid user input is very rarely the best option, and can lead to a lot of confusion.

If we were working in a traditional imperative language, our parsing function would probably throw an exception upon encountering such invalid input. Idris has the option to throw an exception too, through the [`idris_crash`](https://www.idris-lang.org/Idris2/prelude/docs/Builtin.html#Builtin.idris_crash) function in the *Prelude*, but we need to abandon totality to do this: our function would no longer return a value for every possible input. This is a high price to pay for something as commonplace as a parsing error.

In a language like Java, C#, or C++, our function *might* also return some sort of `null` value (leading to the dreaded `NullPointerException` if not handled properly in the consuming code). Our solution will be conceptually similar, but instead of silently returning a `null`, we will make the possibility of failure visible in the type. We'll define a custom data type, which encapsulates the possibility of failure.

Defining new data types in Idris is very cheap, in terms of the amount of code needed, so this pattern is very often encountered as a way of increasing type safety. Here's what such a bespoke type might look like for our use-case, along with the associated parsing function:

```idris
data MaybeWeekday = WD Weekday | NoWeekday

total
readWeekday : String -> MaybeWeekday
readWeekday "Monday"    = WD Monday
readWeekday "Tuesday"   = WD Tuesday
readWeekday "Wednesday" = WD Wednesday
readWeekday "Thursday"  = WD Thursday
readWeekday "Friday"    = WD Friday
readWeekday "Saturday"  = WD Saturday
readWeekday "Sunday"    = WD Sunday
readWeekday _           = NoWeekday
```

But what if we'd like also like to read a `Bool` from user input? We'd have to write another custom data type, `MaybeBool`, and so on for all the types we'd like to be able to parse from a `String`.

Idris, like many other programming languages, allows us to generalize this behavior by using *generic data types*. Here's what the *generic* version of our `MaybeWeekday` might look like:

> [!NOTE]
> While the prelude calls this type `Maybe`, we are calling it `Option` to avoid conflict. We are also altering the names of the data constructors `Some` is equivlant to `Just`, and `None` is equivalent to `Nothing`.
>
> You may recognize the name `Option` from other programming languages, for instance, Rust uses the name `Option` to refer to this concept, and C++ uses `optional`.

```idris
data Option a = Some a | None

total
readBool : String -> Option Bool
readBool "True"    = Some True
readBool "False"   = Some False
readBool _         = None
```

Let's go to the REPL and take a look at the types to get a feel for what we are working with here:

```repl
Tutorial.DataTypes.GenericDataTypes> :t Some
Tutorial.DataTypes.GenericDataTypes.Some : a -> Option a
Tutorial.DataTypes.GenericDataTypes> :t None
Tutorial.DataTypes.GenericDataTypes.None : Option a
Tutorial.DataTypes.GenericDataTypes> :t Option
Tutorial.DataTypes.GenericDataTypes.Option : Type -> Type
```

> [!NOTE]
> `Option` is what we call a *type constructor*, it is not yet a saturated type. It is, instead, a *function* from `Type` to `Type`. Only when we provide it a `Type` argument does it actually become a *type*.
>
> We say that `Option` is a type constructor *parameterized* over a *parameter* of type `Type`. While `Option` may not be a type, `Option Bool` is a type, and so is `Option Weekday`. Even `Option (Option Bool)` is a valid type.
>
> `Some` and `None` are `Option`'s *data constructors*, they are functions used to create values of type `Option a` for a given type `a`

Let's see some other use cases for `Option`. Below is a safe division operation, returning `None` on an attempt to divide by zero, instead of throwing an exception:

```idris
total
safeDiv : Integer -> Integer -> Option Integer
safeDiv n 0 = None
safeDiv n k = Some (n `div` k)
```

It is important to understand the distinction between a function returning, say, `Maybe Integer` and returning `null` in a language like Java. In the former case, the possibility of failure is visible in the types, and as a result the type checker forces the programmer to deal with the possibility of the function returning `Nothing`; you can't get an `Integer` out of a `Maybe Integer` without pattern matching on it and exposing the `Nothing`, and Idris doesn't let us forget to handle a case in a pattern match. This stands in stark contrast with the Java-esq approach, where `null` is implicitly a valid value of *every* pointer-backed type, and programmers may (and often *will*) forget to handle the `null` case, leading to unexpected and often hard to debug runtime exceptions.

## Either

While `Maybe` is very useful for quickly encoding the possibilty of failure, the one value it can provide for the failure case, `Nothing`, isn't very informative in that it doesn't encode any information about *what* went wrong. While there are many cases where this is sensible (for instance, if you are attempting to look up a value in a Map, a return value of `Nothing` can reasonably be assumed to mean the desired value wasn't present in the Map), there are many more cases where multiple things could have gone wrong and the user of or function would know to know which of the things actually did go wrong.

As an example, in the case of our `Weekday` parsing function, it might be useful later on to know the value of the invalid input string. Just like with `Maybe`/`Option` in the previous section, this concept is general enough that we want to consider other types of invalid data.

Let's build a data type to encode this:

```idris
data Validated e a = Invalid e | Valid a
```

> [!NOTE]
> `Validated` is a type constructor parameterized over *two* type parameters, `e` and `a`.
>
> It's data constructors are `Invalid`, which holds a value describing some error condition, and `Valid`, which describes the result of a successful computation.

With our new `Validated` type, we can augment our `readWeekday` function with some pretty useful error reporting:

```idris
total
readWeekdayV : String -> Validated String Weekday
readWeekdayV "Monday"    = Valid Monday
readWeekdayV "Tuesday"   = Valid Tuesday
readWeekdayV "Wednesday" = Valid Wednesday
readWeekdayV "Thursday"  = Valid Thursday
readWeekdayV "Friday"    = Valid Friday
readWeekdayV "Saturday"  = Valid Saturday
readWeekdayV "Sunday"    = Valid Sunday
readWeekdayV s           = Invalid ("Not a weekday: " ++ s)
```

> [!NOTE]
> Much like `Maybe`, this is such a general and common concept that the *Prelude* already contains a data type like `Validated`: `Either`
>
> Either's `Left` data constructor is equivalent to `Validated`'s `Invalid`, and `Right` is equivalent to `Valid`.

It is very common for functions to encode the possibility of failure by returning an `Either err val`, where `err` is the error type and `val` is the desired return type. This provides a type safe (and total!) alternative to throwing a catchable exception in an imperative language.

> [!NOTE]
> Use of `Either` does not always imply that `Left` is an error and `Right` is a success, a function returning `Either` just means that it can have two different types of results, each of which are *tagged* with the corresponding data constructor.

## List

One of the most important data structures in pure functional programming is the singly linked list, defined as follows (called `Seq` in order for it not to collide with `List`, which is of course already available from the Prelude):

```idris
data Seq a = Nil | (::) a (Seq a)
```

> [!NOTE]
> `Seq` consists of two *data constructors*:
>
> - `Nil`, representing the empty list
> - `(::)`, usually pronounced 'cons', which adds a new element of type `a` onto another list of values of type `a`.
>
> Notice how we are using operators as data constructors, this is sometimes quite useful, but it's usually more helpful to give your functions and data constructors clear names, and only use operators sparingly, when there is a compelling case to be made that they would improve readability.

If we wanted to use the `List` data constructors directly, it would look something like this:

```idris
total
ints : List Int64
ints = 1 :: 2 :: -3 :: Nil
```

However, there is a more concise way of writing the above. Idris accepts special syntax for constructing data types consisting exactly of the two constructors `Nil` and `(::)`:

```idris
total
ints2 : List Int64
ints2 = [1, 2, -3]

total
ints3 : List Int64
ints3 = []
```

The two definitions `ints` and `ints2` are treated identically by the compiler.

> [!NOTE]
> List syntax can also be used in pattern matching.

`Seq` and `List` both have another special property, each of them is defined in terms of itself, due to the cons operating taking a value and *another* `List`/`Seq` as arguments. We call such data types *recursive* data types, and as a result of their recursive nature, decomposing or consuming them typically requires recursive functions.

In a traditional imperative language, we might use a for loop, or similar construct, to iterate over the values of a `List`, but traditional loops don't exist in a lanugage without in-place mutation. Let's take a look at the recursive way of summing a list of integers:

```idris
total
intSum : List Integer -> Integer
intSum Nil       = 0
intSum (n :: ns) = n + intSum ns
```

Recursive functions can be hard to grasp at first, so we'll break this down a bit. If we invoke `intSum` with the empty list, the first pattern matches and the function returns zero immediately. If, however, we invoke `intSum` with a non-empty list - `[7,5,9]` for instance - the following happens:

1. The second pattern matches and splits the list into two parts: Its head (`7`) is bound to variable `n` and its tail (`[5,9]`) is bound to `ns`:

   ```repl
   7 + intSum [5,9]
   ```

2. In a second invocation, `intSum` is called with a new list: `[5,9]`. The second pattern matches, `n` is bound to `5`, and `ns` is bound to `[9]`:

   ```repl
   7 + (5 + intSum [9])
   ```

3. In a third invocation `intSum` is called with list `[9]`. The second pattern matches, `n` is bound to `9`, and `ns` is bound to `[]`:

   ```repl
   7 + (5 + (9 + intSum [])
   ```

4. In a fourth invocation, `intSum` is called with list `[]` and returns `0` immediately:

   ```repl
   7 + (5 + (9 + 0)
   ```

5. In the third invocation, `9` and `0` are added and `9` is returned:

   ```repl
   7 + (5 + 9)
   ```

6. In the second invocation, `5` and `9` are added and `14` is returned:

   ```repl
   7 + 14
   ```

7. Finally, our initial invocation of `intSum` adds `7` and `14`, returning `21`.

The recursive implementation of `intSum` leads to a sequence of nested calls to `intSum`, terminating once the argument is the empty list.

## Generic Functions

In order to fully appreciate the versatility of generic data types, we need to talk about generic functions. Much like generic types, they are parameterized over one or more *type parameters*.

Consider, for instance, breaking a value out of the `Option` data type. In the event it contains a `Some`, we'd like to return the stored value, while for the `None` case we'd like to provide a default value. Let's take a look at a function that implements this logic, specialized over `Integer`s:

```idris
total
integerFromOption : Integer -> Option Integer -> Integer
integerFromOption _ (Some y) = y
integerFromOption x None     = x
```

As the pattern of this section might imply, this approach isn't as general as we'd like; with a specialized implementation like this, we'd need similarly bespoke functions to break a value out of an `Option Bool`, or an `Option String`, or any other possible `Option` type. We can, of course, do better, with our generic `fromOption` function:

```idris
total
fromOption : a -> Option a -> a
fromOption _ (Some y) = y
fromOption x None     = x
```

The lower-case `a` here is once again a *type parameter*, allowing us to read the type signature as "For any type `a`, given a *value* of type `a`, and a value of type `Option a`, we can return a value of type `a`".

> [!NOTE]
> The compiler knows nothing about `a` except for the fact that it is a type, as a result we can't summon a value of `a` out of thin air like we can with an `Integer`. We *must* have a value available to deal with the `None` case.

The equivalent to `fromOption` for `Maybe` is called `fromMaybe` and is available from the `Data.Maybe` module in the *base* library.

Sometimes, even `fromOption` is not general enough. Assume we'd like to print the value of a freshly parsed `Bool`, giving some generic error message in case of a `None`. We can't use `fromOption` for this, as we have an `Option Bool` and we'd like to return a `String`. Here's one way we might accomplish this:

```idris
total
option : b -> (a -> b) -> Option a -> b
option _ f (Some y) = f y
option x _ None     = x

total
handleBool : Option Bool -> String
handleBool = option "Not a boolean value." show
```

The function `option` is parameterized over *two* type parameters. The `a` parameter represents the type of the values stored in the `Option`, while `b` is the return type of the function. If the `Option` turns out to be a `Just`, we need a way to convert the resulting `a` to a `b`, and that's done using second argument, which has the type of a function from `a` to `b`.

In Idris, lower-case identifiers in function types are treated as *type parameters*, while upper-case identifiers are treated as types or type constructors, which must be in scope.

<!-- vi: filetype=idris2:syntax=markdown
-->
