# Minimal Haskell

## Resources

- [Haskell Documentation](https://www.haskell.org/documentation/)
- [Haskell on Wikibooks](https://en.wikibooks.org/wiki/Haskell)
- [Haskell at SE-EDU](https://se-education.org/learningresources/contents/haskell/Haskell.html)
- [Haskell Programming Full Course 2024 by BekBrace](https://www.youtube.com/watch?v=TklkNLihQ_A)
- [Haskell Tutorial by Derek Banas](https://www.youtube.com/watch?v=02_H3LjqMr8)
- [Functional Programming in Haskell by Graham Hutton](https://www.youtube.com/playlist?list=PLF1Z-APd9zK7usPMx3LGMZEHrECUGodd3)
- [Advanced Functional Programming in Haskell by Graham Hutton](https://www.youtube.com/playlist?list=PLF1Z-APd9zK5uFc8FKr_di9bfsYv8-lbc)

This notes aim at providing a succint Haskell introduction. They were taken while studying the references above, in special [Haskell at SE-EDU](https://se-education.org/learningresources/contents/haskell/Haskell.html).

## Installation

### Stack

The recommended way for running Haskell is through [Stack](https://docs.haskellstack.org/en/stable/), as dependency management and project compilation is made easy. Fortunatelly it provides a user installer without need of administration rights, which should be available for Majordome/Kompanion users. Advanced usage (require admin rights) include the full [GHCup](https://www.haskell.org/downloads/) installation, which is not covered here.

**Note:** if you installed Stack manually, set environment variable `STACK_ROOT` to some folder of your choice so Stack will install everything within this folder (and not under Windows `%USERHOME\AppData` or some equivalent path in other systems). You might also wish to change `config.yaml` in that folder to have your new projects configured with your name and other parameters.

### Running from a container

Use the snippet below for creating a `Containerfile for a start, or pull an image directly from [Docker Hub](https://hub.docker.com/) if you prefer.

```dockerfile
FROM haskell:9.2

WORKDIR /opt/work
```

For building and running the container proceed as follows:

```bash
# Build from the provided container:
podman build -t learn-haskell -f Containerfile .

# Run from current working directory:
podman run -it -v $(realpath $(pwd)):/opt/work:Z learn-haskell
```

## Learning path

*WIP*

## Hello, world!

Haskell is a purely functional programming language with strong, static, inferred typing. Below one finds a `Hello, world!` program within a `main` function:

```haskell
main :: IO ()
main = do
    putStrLn "Hello, Haskell!"
```

## Using GHCi

From a terminal run `stack ghci` for an interative session detached from any project. The compiler/interpreter provides prompts for performing some actions while interacting with Haskell code and libraries. The access to these commands starts with a colon `:` and for a full list you can query with `:?`. Common commands include:

- `:` (a plain semi-colon without anything further) repeats the last command issued with `:`
- `:l` (short for `:load`) loads a given `.hs` file; if no file is provided, restarts a fresh session

## Creating a stack project

```bash
# Create a new project and enter its directory:
stack new kinetics-oxidation-iron
cd kinetics-oxidation-iron

# Build and execute the project (notice the `-exe`):
stack build
stack exec kinetics-oxidation-iron-exe
```

```bash
stack exec kinetics-oxidation-iron-exe -- '<command arguments here>'
```

| | |
|---|---|
| .stack-work                   | Stack managed
| app                           | As you progress
| src                           | As you progress
| test                          | As you progress
| .gitignore                    | As you progress
| CHANGELOG.md                  | As you progress
| kinetics-oxidation-iron.cabal | Stack managed
| LICENSE                       | Check on creation
| package.yaml                  | Stack managed / user editable
| README.md                     | As you progress
| Setup.hs                      | Leave as is
| stack.yaml                    | Leave as is
| stack.yaml.lock               | Leave as is
