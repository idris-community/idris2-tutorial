# A First Idris Program

```idris
module Tutorial.Intro.FirstIdrisProgram
```

We will often start up a REPL for tinkering with small parts of the Idris language, for reading some documentation, or for inspecting the content of an Idris module, but now we will write a minimal Idris program to get started with the language. Here comes the mandatory *Hello World*:

```idris
main : IO ()
main = putStrLn "Hello World!"
```

We will inspect the code above in some detail in a moment, but first we'd like to compile and run it. From this project's root directory, run the following:

```sh
pack -o hello exec src/Tutorial/Intro/FirstIdrisProgram.md
```

This will create executable `hello` in directory `build/exec`, which can be invoked from the command-line like so (without the dollar prefix; this is used here to distinguish the terminal command from its output):

```sh
$ build/exec/hello
Hello World!
```

The pack program requires an `.ipkg` to be in scope (in the current directory or one of its parent directories) from which it will get other settings like the source directory to use (`src` in our case). The optional `-o` option gives the name of the executable to be generated. Pack comes up with a name of its own it this is missing. Type `pack help` for a list of available command-line options and commands, and `pack help <cmd>` for getting help for a specific command.

As an alternative, you can also load this source file in a REPL session and invoke function `main` from there:

```sh
pack repl src/Tutorial/Intro/FirstIdrisProgram.md
```

```repl
Tutorial.Intro> :exec main
Hello World!
```

Go ahead and try both ways of building and running function `main` on your system!

<!-- vi: filetype=idris2:syntax=markdown
-->
