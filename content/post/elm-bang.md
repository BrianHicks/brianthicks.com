---
date: "2016-07-25T11:35:07-05:00"
title: "Bang! And Other Infix Functions"
tags: ["elm"]

---

Elm is usually pretty clear, but there are certain things that are a little hard to search for.
One of those is the `!` operator, introduced in 0.17.
What does it do?
Where does it come from?
And even more important, when should you use it?

<!--more-->

You'll see `!` (pronounced "bang") in the return values for `update` functions, like so:

```elm
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Increment ->
            { model | counter = counter + 1 } ! [ ]
```

You can infer the type that it's returning: `(Model, Cmd Msg)`.
Even if you can do that, though, it's pretty weird the first couple times you see it.
So let's look at&hellip;

## The Type Signature

The type signature for `!` (found in [`Platform.Cmd`](http://package.elm-lang.org/packages/elm-lang/core/4.0.3/Platform-Cmd#!)) is this:

```elm
(!) : model -> List (Cmd msg) -> (model, Cmd msg)
```

Defining an operator in Elm is simple&ndash;this is all there is to it, plus the function body.
The parentheses around the name (`(!)` instead of just `!`) mean that it's an infix function.
You've seen this before!
Consider the following:

```elm
1 + 1
```

`+` is a function, right?
We're using it as an "infix" function here (meaning it's between the arguments instead of in front of them.)
But we can use it like a prefix (what we think of as "normal")  function as well.
That means that:

```elm
(+) 1 1 == 1 + 1
```

Both these statements result in `2`.
They're the same thing!
We can define `+` using the following type signature:

```elm
(+) : number -> number -> number
```

In other words, it's a function that takes two numbers and returns a number.
So let's look again at `!`: it takes a model (on the left) and a list of `Cmd` (on the right).
If we were to write it in prefix style, it looks like this:

```elm
(!) { model | counter = counter + 1 } [ ]
```

In other words, it's a shortcut for returning `(Model, Cmd Msg)`.
To be more specific, it's like returning `(model, Cmd.batch [ ])`.
And if we look at [the source](https://github.com/elm-lang/core/blob/4.0.3/src/Platform/Cmd.elm#L64-L66), that's actually *exactly* what it does.

```elm
(!) : model -> List (Cmd msg) -> (model, Cmd msg)
(!) model commands =
  (model, batch commands)
```

## Creating Your Own Infix Functions

Given the above, when and why should you create your own infix functions?
Think of it like wasabi in cooking: a little bit goes a long way.
Unless you have an operation that you need to do over and over and over, consider using a prefix function instead.
In fact, the [Elm package design guidelines](http://package.elm-lang.org/help/design-guidelines#avoid-infix-operators) recommend not introducing new operators unless absolutely necessary. 
And if you do, please be explicit about importing them, since they're hard to search for.
That is, do this:

```elm
import MyCoolModule exposing ((<*>))
```

Instead of this:

```elm
import MyCoolModule exposing (..)
```

That way it's easy to see at a glance where a given operator is coming from.

## When to Use `!`

All that said, when should one use `!`?
Short answer: in all your `update` functions!
It's a great little shortcut.
Where you used to return `(model, Cmd.none)`, you can now return `model ! [ ]`.
That said, if it's not your style, just ignore it.
The `!` operator is pure syntactic sugar.
So if you don't like it, just don't use it.

## Boom, Done!

You now know when and how to use `!`. 
The bigger win here, though, is that you now know how infix functions work!

{{< elmSignup >}}
