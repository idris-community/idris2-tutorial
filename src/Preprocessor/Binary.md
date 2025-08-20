# The Preprocessor Executable

```idris
module Preprocessor.Binary
  
import Data.SortedMap
import Data.String
import Data.Maybe

import System

%default total
```

```idris hide
-- Temporary definitions that refer to names that will be defined in other modules
data Book : Type
%name Book book
data Context : Type
%name Context ctx
  
(.renderer) : Context -> String

toJSON : Book -> String
```

## Argument Parsing 

mdBook will call our preprocessor binary in one of two ways, either as `mdbook-katla supports $BackendName`, to interrogate support for the given backend, or with no arguments. We need to figure out which case we are in, and extract the backend we are given the `supports` sub-command. We also need to do a little bit of error handling, for the sake of clean code, if we are passed an invalid argument (even though this executable will only be invoked by mdbook, so we shouldn't ever have an error).

First, we will need a data structure to hold our parsed arguments, which will be pretty straight forward, a two option enumeration:

```idris
data Args : Type where
  NoArguments : Args
  Supports : (backend : String) -> Args
```

Now, we need to actually parse the arguments:

```idris
parseArgs : IO (Either String Args)
parseArgs = do
  (_ :: args) <- getArgs
    | [] => pure $ Left "Somehow didn't have the executable name argument"
  case args of
    [] => pure . Right $ NoArguments
    ["supports", backend] => pure . Right $ Supports backend
    _ => pure . Left $ "Invalid arguments: \{joinBy " " args}"
```

## Error Handling

Since we are working in the context of `IO` we can """safely""" unwrap an `Either` by printing the error to the terminal and bailing out with a non zero exit code, we'll define a convenience wrapper to do that for us.

> [!TIP]
> We are using the `Interpolation` interface for the generic bound because, unlike `Show`, it displays `String`s as-is

```idris
unwrapCtx : Interpolation a => (ctx : Lazy String) -> Either a b -> IO b
unwrapCtx ctx (Left x) = do
  putStrLn "Error: \{ctx}\n  \{x}"
  exitFailure
unwrapCtx ctx (Right x) = pure x
```

## Parsing the Book Data

```idris
parseStdin : IO (Either String (Context, Book))
```


## Handling Our Two Cases

### No Arguments 

While we only support the `html` backend right now, we might want to support other backends, such as a pdf generating backend, in the future, so we'll define a map of implementations for each corresponding backends. The keys of the map will be the names of the backend, and the values will be functions from a parsed `(Context, Book)` pair to the modified `Book` to output, wrapped in an `Either` for error handling.  First, we must define our backends though.

#### HTML

```idris
html : (Context, Book) -> Either String Book
```

#### The Map

```idris
implementationMap : SortedMap String ((Context, Book) -> Either String Book)
implementationMap = fromList [ ("html", html) ]
```

### Supports Subcommand

Since the list of supported backend's was implicitly defined in `implementationMap`, we can just check to see if that map contains the matching key, then signal support or non-support to mdBook by exiting with the appropriate exit code:

```idris
supports : (backend : String) -> IO ()
supports backend = 
  if isJust $ lookup backend implementationMap
    then exitSuccess
    else exitFailure
```

## Routing From The Provided Input 

In the no arguments case, mdBook doesn't directly tell us what backend to render with. Instead, it includes that information in the `Context` element of the `(Context,Book)` pair, and there's no schematic requirement that it be different. We'll need to group the input list by backend (called `renderer` in the `Context` schema), and then call the provided function from the map.

We'll perform this function as an IO action so we can perform more detailed error handling using our `unwrapCtx` function.

```idris
routeBook : (Context, Book) -> IO Book
routeBook (ctx, book) = 
  case lookup ctx.renderer implementationMap of
    Nothing => do
      putStrLn "Book specified unsupported backend \{ctx.renderer}"
      exitFailure
    Just f => unwrapCtx "Processing Book" $ f (ctx, book) 
```

### Main Itself

Our main simply glues it all together, matching on the parsed arguments, and delegating most of the rest of the work to the appropriate implementations.

```idris
main : IO ()
main = do
  args <- parseArgs >>= unwrapCtx "Parsing Arguments"
  case args of
    Supports backend => supports backend
    NoArguments => do
      pair <- parseStdin >>= unwrapCtx "Parsing Input" 
      output <- routeBook pair
      putStr (toJSON output)
      exitSuccess
```

## Packaging Considerations
