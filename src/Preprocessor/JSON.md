# Handling mdBook JSON

```idris
module Preprocessor.JSON
  

import JSON.Simple.Derive
import JSON.Simple.Option
import Derive.Prelude

%default total

%language ElabReflection
```

mdBook provides all the data a preprocessor needs to do its job as JSON input on the preprocessors stdin, as a JSON array of form `[Context, Book]`. The preprocessor then sends back the modified `Book` to mdBook as JSON on its stdout. We'll need to define some marshallers so we can convert back and forth between Idris types and JSON, we'll do this using the [json-simple](https://github.com/stefan-hoeck/idris2-json) package.

## Basic Considerations

Rust and Idris are different languages, and the dominant derivable encoding libraries for JSON in them have different defaults. In particular, languages with sum types tend to have a bit of disagreement about how to encode sum types by default into JSON by default. On the Rust side, serde uses what it refers to as "[externally tagged](https://serde.rs/enum-representations.html)" representation for sum types. This corresponds to [`ObjectWithASingleField`](https://stefan-hoeck.github.io/idris2-pack-db/docs/json-simple/docs/docs/JSON.Simple.Option.html#JSON.Simple.Option.ObjectWithSingleField) in json-simple, which is not it's [default setting](https://stefan-hoeck.github.io/idris2-pack-db/docs/json-simple/docs/docs/JSON.Simple.Option.html#JSON.Simple.Option.defaultTaggedObject). We'll need to define our own options and use [`customFromJSON`](https://stefan-hoeck.github.io/idris2-pack-db/docs/json-simple/docs/docs/Derive.FromJSON.Simple.html#Derive.FromJSON.Simple.customFromJSON) and [`customToJSON`](https://stefan-hoeck.github.io/idris2-pack-db/docs/json-simple/docs/docs/Derive.ToJSON.Simple.html#Derive.ToJSON.Simple.customToJSON) in our derives:

```idris
export
serde : Options
serde = { sum := ObjectWithSingleField, replaceMissingKeysWithNull := True } defaultOptions
  
ne : String -> String
ne "non_exhaustive" = "__non_exhaustive"
ne x = x

export
serdeNE : Options
serdeNE = {fieldNameModifier := ne} serde

kebabCase : String -> String
kebabCase = pack . map convertChar . unpack
  where
    convertChar : Char -> Char
    convertChar '_' = '-'
    convertChar c = c

export
serdeKebab : Options
serdeKebab = {fieldNameModifier := kebabCase} serde
```

## The `PreprocessorContext` Type

mdBook provides us meta-information about the active project through a JSON Serialization of its [`PreprocessorContext`](https://docs.rs/mdbook/latest/mdbook/preprocess/struct.PreprocessorContext.html) type. Since we are processing this from idris, we do have to make some alterations. 

For example, Idris does not currently include a dedicated type for file system paths, so we'll have to handle `root` as a `String` under the hood, but we'll go ahead and define a type alias to make it easier to read and to switch out later if we want to:

```idris
public export
Path : Type
Path = String
```

### The `Config` Zoo

`PreprocessorContext` contains a `config : Config` field, where `Config` is a wrapper around three separate sub-configs, we'll implement these all in turn and wrap them up in our final `Config` type.

#### BookConfig

`BookConfig` relies on a `TextDirection` enum, so we'll define that first:

```idris
public export
data TextDirection = LeftToRight | RightToLeft

%runElab derive "TextDirection" [Show, Eq, customToJSON Export serde, customFromJSON Public serde]
```

Now we can define `BookConfig` as a nearly 1-to-1 translation of its [mdBook equivalent](https://docs.rs/mdbook/latest/mdbook/config/struct.BookConfig.html):

```idris
public export
record BookConfig where
  constructor MkBookCfg
  title : Maybe String
  authors : List String
  description : Maybe String
  src : Path
  text_direction : Maybe TextDirection

%name BookConfig bookCfg
%runElab derive "BookConfig" [Show, Eq, customToJSON Export serde, customFromJSON Export serde]
```

#### BuildConfig

`BuildConfig` doesn't contain any special types, so we'll just provide a 1-to-1 translation of its [mdBook equivalent](https://docs.rs/mdbook/latest/mdbook/config/struct.BuildConfig.html):

```idris
public export
record BuildConfig where
  constructor MkBuildCfg
  build_dir : Path
  create_missing : Bool
  use_default_preprocessors : Bool
  extra_watch_dirs: List Path

%name BuildConfig buildCfg
%runElab derive "BuildConfig" [Show, Eq, customToJSON Export serdeKebab, customFromJSON Export serdeKebab]
```

#### RustConfig

We really shouldn't be interacting with [`RustConfig`](https://docs.rs/mdbook/latest/mdbook/config/struct.RustConfig.html) too much, at time of writing it simply encodes which edition of Rust the auto-generated playground links for Rust code should run against. We aren't really going to be encountering rust code in this preprocessor, but well handle it faithfully for the sake of completeness.

First we need our `RustEdition` enum:

```idris
public export
data RustEdition = E2024 | E2021 | E2018 | E2015

%runElab derive "RustEdition" [Show, Eq, customToJSON Export serde, customFromJSON Export serde]
```

And then our translation of the `RustConfig` struct:

```idris
public export
record RustConfig where
  constructor MkRustCfg
  edition: Maybe RustEdition

%name RustConfig rustCfg
%runElab derive "RustConfig" [Show, Eq, customToJSON Export serde, customFromJSON Export serde]
```

#### Config

Now that we have all our subtypes implemented, its an easy matter to glue them all together into our final [`Config`](https://docs.rs/mdbook/latest/mdbook/config/struct.Config.html) type:

```idris
public export
record Config where
  constructor MkCfg
  book : BookConfig
  build : BuildConfig
  rust : RustConfig

%name Config cfg
%runElab derive "Config" [Show, Eq, customToJSON Export serde, customFromJSON Export serde]
```

### `Context` Proper

```idris
public export
record Context where
  constructor MkCtx
  root : Path
  config : Config
  renderer : String
  mdbook_version: String

%name Context ctx
%runElab derive "Context" [Show, Eq, customToJSON Export serde, customFromJSON Export serde]
```


## Book 

### `BookItem`

[`BookItem`](https://docs.rs/mdbook/latest/mdbook/book/enum.BookItem.html) gets a little _fun_ because it's a mutually recursive data type, so we'll have to make some forward declarations:

```idris
public export
data BookItem : Type
public export
record ChapterItem

public export
record ChapterItem where
  constructor MkChapter
  name : String
  content : String
  number : Maybe (List Bits32)
  sub_items : List BookItem
  path : Maybe Path
  source_path : Maybe Path
  parent_names : List String

%name ChapterItem chapterItem

public export
data BookItem : Type where
  Chapter : ChapterItem -> BookItem
  Seperator : BookItem
  PartTitle : String -> BookItem

%name BookItem bookItem
```

We'll have to do something a little bit special to apply the JSON derives here, since these are mutually recursive data types, and Idris is a strictly declare-before-use language, we'll run into issues if we try to derive the normal way. Instead we will want to use [elab-util](https://github.com/stefan-hoeck/idris2-elab-util)'s [`deriveMutual`](https://stefan-hoeck.github.io/idris2-pack-db/docs/elab-util/docs/docs/Language.Reflection.Derive.html#Language.Reflection.Derive.deriveMutual):

```idris
%runElab deriveMutual ["ChapterItem", "BookItem"] [Show, Eq, customToJSON Export serde, customFromJSON Export serde]
```

## `Book` Proper

With everything else written, we only need to provide an equivalent of [`Book`](https://docs.rs/mdbook/latest/mdbook/book/struct.Book.html):

```idris
public export
record Book where
  constructor MkBook
  sections: List BookItem
  -- FIXME: For some reason we need this in here to get json-simple to behave and not just reduce this type to a list
  non_exhaustive: Maybe Bool

%name Book book
%runElab derive "Book" [Show, Eq, customToJSON Export serdeNE, customFromJSON Export serdeNE]
```

## Interactive Testing

```idris
exampleBookConfig : BookConfig
exampleBookConfig = MkBookCfg
  { title = Just "Idris 2 Book"
  , authors = ["Me", "You"]
  , description = Just "A Book"
  , src = "."
  , text_direction = Nothing
  }

exampleBuildConfig : BuildConfig
exampleBuildConfig = MkBuildCfg
  { build_dir = "."
  , create_missing = True
  , use_default_preprocessors = True
  , extra_watch_dirs = []
  }

exampleRustConfig : RustConfig
exampleRustConfig = MkRustCfg Nothing

exampleConfig : Config
exampleConfig = MkCfg
  { book = exampleBookConfig
  , build = exampleBuildConfig
  , rust = exampleRustConfig
  }

exampleContext : Context
exampleContext = MkCtx 
  { root = "."
  , config = exampleConfig
  , renderer = "html" 
  , mdbook_version = "0.0.0"
  } 
  
exampleChapter : BookItem
exampleChapter = Chapter $ MkChapter
  { name = "Name"
  , content = "Content"
  , number = Just [1, 2, 3]
  , sub_items = []
  , path = Nothing
  , source_path = Nothing
  , parent_names = []
  }

exampleBook : Book
exampleBook = MkBook [ exampleChapter, Seperator ] Nothing

examplePair : (Context, Book) 
examplePair = (exampleContext, exampleBook)

example : IO ()
example = do
  let output = encode examplePair
  putStrLn output
```
