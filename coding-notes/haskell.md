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

## Creating a stack project

Actual production projects require a build framework for managing dependencies and versions; using Stack is the *to-go* solution for this end. The following provides a minimal example of how to proceed with project creation:

```bash
projectName="super-haskell-project"

# Create a new project and enter its directory:
stack new ${projectName}
cd ${projectName}

# Build and execute the project (notice the `-exe`):
stack build
stack exec ${projectName}-exe
```

If the executable accepts command-line arguments, these can be provided after `--` as follows:

```bash
stack exec ${projectName}-exe -- '<command arguments here>'
```

You can modify `${projectName}-exe` name in `${projectName}.cabal`. For practicing, try moving the *Hello, world!* provided above into a Stack project of its own! It's a huge overkill, but try it!

## Using GHCi

From a terminal run `stack ghci` for an interative session detached from any project. The compiler/interpreter provides prompts for performing some actions while interacting with Haskell code and libraries. The access to these commands starts with a colon `:` and for a full list you can query with `:?`. Common commands include:

- `:` (a plain semi-colon without anything further) repeats the last command issued with `:`
- `:l` (short for `:load`) loads a given `.hs` file; if no file is provided, restarts a fresh session
- `:t` (short for ... `:type`), used as illustrated below for inspecting a variable/function type:

```haskell
ghci> a = 5
ghci> :t a
a :: Num a => a
ghci>
ghci> squared x = x * x
ghci> :t squared
squared :: Num a => a -> a
```

It is also useful to known that `Ctrl+L` cleans up the current CLI view.

## Learn by example

```haskell
a :: Int
a = 5

b :: Integer
b = product [1..1000]

-- Fractions are also lazy-evaluated:
c :: Fractional
c = 3/4

-- Because `pi` is a built-in:
myPi :: Double
myPi = 3.141592654
```

```haskell
-- arc :: (Double -> (Double -> Double))
arc :: Double -> Double -> Double
arc theta r = theta * r

-- Using type classes (generic):
arc :: Num a => a -> a -> a
arc theta r = theta * r

-- Currying of arc:
circ r = arc (2.0*pi) r

-- Even without the final argument:
oneFourthCirc = arc (pi/2)

-- Is round-off playing here:
isTwo = (circ 2.0) / pi == 2

```

```haskell
hypotenuse :: Double -> Double -> Double
hypotenuse b c = sqrt $ square b + square c
    where square x = x * x

main :: IO ()
main = do
    putStrLn (show $ hypotenuse 3 4)
    putStrLn (show $ (hypotenuse 3) 4)
```

```haskell
sumIt :: Num a => (a, a) -> a
sumIt (a, b) = a + b

sumIt :: Num a => a -> a -> a
sumIt a b = a + b
```

```haskell
-- Data types start with capital letters
data RGB = Red | Green | Blue

-- Pattern matching is more idiomatic in Haskell
judgementalColor Red   = "Those communists!"
judgementalColor Green = "Oh, Greta!"
judgementalColor Blue  = "Far right is here!"
```

```haskell
-- Derive show and equality type classes
data RGB = Red | Green | Blue
    deriving (Show, Eq)

judgementalColorBis color
    | color == Red = "Those communists!"
    | otherwise    = "I missed those!"
```

```haskell
data HttpRequest = Get String | Post String | Ping

handleRequest :: HttpRequest -> String
handleRequest (Get content)  = "You asked for " ++ content
handleRequest (Post content) = "You, hacker! BANNED " ++ content
handleRequest Ping = "Dunno!"

-- handleRequest (Get "milk!")
-- handleRequest (Post "chalk!")
-- handleRequest Ping
```

```haskell
-- define box as a record type
data Terrain = Terrain { width :: Double, depth :: Double, price :: Double }
    deriving (Show)

area :: Terrain -> Double
area (Terrain { width = w, depth = d}) = w * d

value :: Terrain -> Double
value property = (area property) * (price property)

terrain = Terrain { width = 20, depth = 10, price = 1000 }
pricier = Terrain 20 10 2000

-- This won't work in the same context: multiple declarations of `price`!
-- data Banana = Banana { weight :: Double, price :: Double }
--     deriving (Show)
```

```haskell

```

```haskell

```

```haskell

```