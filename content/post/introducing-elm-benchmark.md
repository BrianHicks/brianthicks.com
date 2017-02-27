---
date: "2017-02-27T09:00:00-06:00"
title: "Introducing elm-benchmark"
tags: ["elm"]
featureimage: "/images/bench-by-will-paterson.png"
thumbnail: "/images/bench-by-will-paterson-with-title.png"
section: "Technology"

---

After the [sets series]({{< ref "sets-intro.md" >}}) finished, I got really curious&hellip;
How fast were these sets, exactly?
I had to shave a lot of yaks to answer that question, but to sum up: Elm now has a [benchmarking library](http://package.elm-lang.org/packages/BrianHicks/elm-benchmark/latest)!
Let's take a look at how to use it!

<!--more-->

## Our First Benchmark

The basic building blocks of `elm-benchmark` are [`benchmark` through `benchmark8`](http://package.elm-lang.org/packages/BrianHicks/elm-benchmark/1.0.1/Benchmark#benchmark).
The number refers to the *arity* of a function (the number of arguments).
So a benchmark for `Dict.get` (`get : comparable -> Dict comparable b -> Maybe b`) would look like this:

```elm
import Benchmark exposing (Benchmark)
import Dict


get : Benchmark
get =
    Benchmark.benchmark2 "Dict.get" Dict.get "a" (Dict.singleton "a" 1)
```

All the benchmarking functions take a name as their first argument.
For a single benchmark this can look pretty silly, but you'll usually have a bunch of benchmarks and need to know which is which.

To run this benchmark, we'll use [`Benchmark.Runner.program`](http://package.elm-lang.org/packages/BrianHicks/elm-benchmark/1.0.1/Benchmark-Runner#program).
It takes any `Benchmark` and runs it in the browser, once compiled.

```elm
import Benchmark.Runner exposing (BenchmarkProgram, program)


main : BenchmarkProgram
main =
    program get
```

([Run this example on Ellie](https://ellie-app.com/vTDNPCLyZ5a1/1))

## Adding More Benchmarks

One benchmark is all well and good, but you'll usually want more than that.
For that, we'll use `describe`.
Like `benchmark`, it takes a name as the first argument.
*Unlike* `benchmark`, it takes a list of `Benchmark` and produces a `Benchmark`.
This works just like [elm-test's `describe`](http://package.elm-lang.org/packages/elm-community/elm-test/3.1.0/Test#describe).
You can compose these groups as deeply as you like.

Assuming we've written a few more benchmarks (let's say `insert` and `remove`), we can use `describe` like this:

```elm
suite : Benchmark
suite =
    Benchmark.describe "Dict"
        [ get
        , insert
        , remove
        ]
```

Of course, there's nothing preventing us from embedding those benchmark functions directly:

```elm
suite : Benchmark
suite =
    let
        source =
            Dict.singleton "a"
    in
        Benchmark.describe "Dict"
            [ Benchmark.benchmark2 "get" Dict.get "a" source
            , Benchmark.benchmark3 "insert" Dict.insert "b" 2 source
            , Benchmark.benchmark2 "remove" Dict.remove "a" source
            ]
```

([Run this example on Ellie](https://ellie-app.com/vTJDQ4Ltd2a1/0))

This lets us share benchmark fixtures.
Thanks to Elm's immutability guarantees, we can do this without influencing our measurements.

`benchmark` and `describe` cover 90% of what you'll typically use.
But in cases like `Skinney/elm-array-exploration` and `BrianHicks/elm-avl-exploration` we need one more thing:

## Comparing Two Implementations

`compare` acts a little like `benchmark` and a little like `describe`.
It takes a name as the first argument, but then it takes two benchmarks to compare head-to-head.
Here's how we do that for `get`:

```elm
insert : Benchmark
insert =
    Benchmark.compare "get"
        (Benchmark.benchmark2 "Dict" Dict.get "a" (Dict.singleton "a" 1))
        (Benchmark.benchmark2 "Dict.AVL" AVL.get "a" (AVL.singleton "a" 1))

```

([Run this example on Ellie](https://ellie-app.com/vTJDQ4Ltd2a1/1))

When you run this, `elm-benchmark` will run both of these benchmarks, then compare their results.

With these three kinds of functions, we can describe whole suites.
Check out [`elm-avl-exploration`'s main suite](https://github.com/BrianHicks/elm-avl-exploration/blob/master/benchmarks/Main.elm) or [any of the examples in `elm-benchmark`](https://github.com/BrianHicks/elm-benchmark/tree/master/examples) to get a better feel for how to compose these together.

As a last word, be aware that the first release of `elm-benchmark` doesn't have every single feature under the sun, and it may have some issues.
You can help out by benchmarking your code and reporting any issues
You can get help by [opening an issue against `elm-benchmark`](https://github.com/BrianHicks/elm-benchmark/issues) and/or by asking in the #elm-benchmark room in the [Elm Slack](http://elmlang.herokuapp.com/).

Have fun!

{{< elmSignup >}}
