---
name: gccdiag
description: "Use gccdiag when you need to quickly check a certain c/c++ file compiles, using the exact arguments from the project compile_commands.json"
---

The program searches the current folder folders above it in the hierarchy for a "compile_commands.json" file, until it finds the first match. This file is then parsed as the compilation database.

The program can also be configured by reading a ".gccdiag" or "_gccdiag" file in the current working directory or above, as well as the global one in $XDG_CONFIG_HOME/gccdiag/ This file contains a JSON dict with up to three keys: "additional_args", "default_args", "args_to_ignore", which correspond to flags listed above.
```

Usage: gccdiag [OPTIONS] <SOURCES>...

Arguments:
  <SOURCES>...
          Path to one or more source files

Options:
  -c, --compiler <COMPILER>
          Compiler path to replace the value in db. If not given, the compiler will be inferred from the compilation database

  -a, --add-args <ADD_ARGS>
          Compiler args to add when calling (empty by default)

  -d, --default-args <DEFAULT_ARGS>
          Default args to use if the file isn't found in `compile_commands.json`; if empty, the compiler isn't invoked

  -i, --ignore-args <IGNORE_ARGS>
          Compiler args to omit when calling (supports glob patterns like "-O*", "-f*")

  -C, --cwd <CWD>
          Working directory to run the compiler in

  -s, --sarif
          Tell GCC to use sarif output

  -h, --help
          Print help (see a summary with '-h')
```

For example:

```
gccdiag main.c
gccdiag src/*.cpp # Can compile multiple files at once
```
