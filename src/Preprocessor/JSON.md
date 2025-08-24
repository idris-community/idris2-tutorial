# Handling mdBook JSON

```idris
module Preprocessor.JSON
  
import JSON.Derive

%language ElabReflection
```

mdBook provides all the data a preprocessor needs to do its job as JSON input on the preprocessors stdin, as a JSON array of form `[Context, Book]`. The preprocessor then sends back the modified `Book` to mdBook as JSON on its stdout. We'll need to define some marshallers so we can convert back and forth between Idris types and JSON, we'll do this using the [json](https://github.com/stefan-hoeck/idris2-json) package.

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

%runElab derive "TextDirection" [Show, Eq, ToJSON, FromJSON]
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
  multilingual : Bool
  text_direction : Maybe TextDirection

%name BookConfig bookCfg
%runElab derive "BookConfig" [Show, Eq, ToJSON, FromJSON]
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
%runElab derive "BuildConfig" [Show, Eq, ToJSON, FromJSON]
```

#### RustConfig

We really shouldn't be interacting with [`RustConfig`](https://docs.rs/mdbook/latest/mdbook/config/struct.RustConfig.html) too much, at time of writing it simply encodes which edition of Rust the auto-generated playground links for Rust code should run against. We aren't really going to be encountering rust code in this preprocessor, but well handle it faithfully for the sake of completeness.

First we need our `RustEdition` enum:

```idris
public export
data RustEdition = E2024 | E2021 | E2018 | E2015

%runElab derive "RustEdition" [Show, Eq, ToJSON, FromJSON]
```

And then our translation of the `RustConfig` struct:

```idris
public export
record RustConfig where
  constructor MkRustCfg
  edition: Maybe RustEdition

%name RustConfig rustCfg
%runElab derive "RustConfig" [Show, Eq, ToJSON, FromJSON]
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
%runElab derive "Config" [Show, Eq, ToJSON, FromJSON]
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
%runElab derive "Context" [Show, Eq, ToJSON, FromJSON]
```


## Book 

### `BookItem`

[`BookItem`](https://docs.rs/mdbook/latest/mdbook/book/enum.BookItem.html) gets a little _fun_ because it's a mutually recursive data type, so we'll have to make a forward declaration.

```idris
public export
data BookItem : Type

public export
data SectionNumber : Type where
  MkSectionNumber : List Nat -> SectionNumber

public export
record ChapterItem where
  constructor MkChapter
  name : String
  content : String
  number : Maybe SectionNumber
  sub_items : List BookItem
  path : Maybe Path
  source_path : Maybe Path
  parent_names : List String

public export
data BookItem : Type where
  Chapter : ChapterItem -> BookItem
  Seperator : BookItem
  PartTitle : String -> BookItem

%runElab derive "ChapterItem" [Show, Eq, ToJSON, FromJSON]
%runElab derive "BookItem" [Show, Eq, ToJSON, FromJSON]
```
