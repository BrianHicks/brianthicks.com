---
date: "2016-08-08T09:00:00-05:00"
tags: ["elm"]
title: "Values, Pipes, and Arrows"

---

Say you've got a bunch of functions, and you want to use them together.
This is a common situation, but it can get a little&hellip; messy.
Let's take an example from the Elm docs:

```elm
scale 2 (move (10,10) (filled blue (ngon 5 30)))
```

This is, well, just OK.
A little parentheses go a long way, but this is just unclear.
You have to follow them very closely to figure out the evaluation order.
Editor highlighting can help, but wouldn't it be better to get rid of the problem?
But how do we do that?

<!--more-->

## No More Parentheses

We're going to take this in several steps.
First, let's remove the parentheses with `<|`:

```elm
scale 2 <| move (10,10) <| filled blue <| ngon 5 30
```

So what's going on here?
You can think of the `<|` operator as a pipe.
(In fact, [Elixir *calls* it the pipe operator](http://elixir-lang.org/getting-started/enumerables-and-streams.html#the-pipe-operator).)
Values move through it like water moves through real-life pipes.
So we're setting up a processing facility!

{{< figure src="/images/pipes-by-dennis-hill.jpg"
           attr="Photo by Dennis Hill"
           attrlink="https://flic.kr/p/ekMBqL" >}}

How does this help us with determining evaluation order?
The result of the call to `ngon 5 30` is a value, which we pass (with `<|`) to `filled blue`.
This is exactly the same as calling `filled blue (ngon 5 30)`.
This can help clear up what's happening in your code.
For example, when you're using `Html.App.map` to map one view's value to the parent:

```elm
view : Model -> Html Msg
view model =
    App.map ParentMsg <| Child.view model.child
```

This is simplified, but serves to prove the point.
It's clear in this example that the output of the child view is wrapped with `Html.map`
But this is not limited to just images and HTML; you can use it with any function in Elm!

## Arrows Pointing The Way

We still have a problem with our code: it's going "backwards"!
We (English speakers) read left-to-right, but our code is going right-to-left.
What if we just&hellip; reverse it?

```elm
ngon 5 30 |> filled blue |> move (10,10) |> scale 2
```

That's even clearer, right?
The `|>` operator is like `<|`, but goes left-to-right instead of right-to-left.
The way the arrow points is the direction that values "travel".
If you'll recall from [last time]({{< ref "elm-bang.md" >}}), we can get the definitions of these infix functions (AKA operators) in the docs:

```elm
(|>) : a -> (a -> b) -> b

(<|) : (a -> b) -> a -> b
```

These say that `|>` is expecting a value on the left side, and a function on the right.
It's just the opposite for `<|`.
So not only do we have pipes, we have *directional* pipes.
We can control which way the data flows through our program.

Before we finish, there is *one* more step in making our usage "idiomatic": formatting.

```elm
ngon 5 30
    |> filled blue
    |> move (10,10)
    |> scale 2
```

You can add newlines between your operators.
In fact, you'll usually see these operator pipelines written this way.
And indeed, the [elm docs](http://package.elm-lang.org/packages/elm-lang/core/4.0.4/Basics#|>) use this as the final rewritten form.

## One More Thing: Names?

So we have `<|` and `|>`.
These are wonderfully useful, and sharp tools to have in your toolbox.
But what do we call them?

The docs refer to `<|` as the "backward function application" operator, and `|>` as the "forward function application" operator.
These names are correct, but they're a mouthful!

Similar concepts exist in other programming languages.
As I mentioned earlier, Elixir only has `|>` and refers to it as the "pipe" operator.
[Craig Buchek](http://craigbuchek.com/home) tells me that [F# has both](https://msdn.microsoft.com/en-us/visualfsharpdocs/conceptual/symbol-and-operator-reference-%5bfsharp%5d), and that they're called "forward pipe" and "backward pipe" operators.
In the "not-called-pipe" category, [Haskell's `$`](http://hackage.haskell.org/package/base-4.7.0.1/docs/Prelude.html#g:10) does the same thing as `<|` and is called the "application operator".

The majority consensus seems to be to call it the "pipe" operator, so that's what I normally do.
But you may hear these called "forward application" and "backward application" as well.

## Done!

Now you now how to get rid of all those extra parentheses around your function calls (and how to talk about what you're doing.)
You also know how to create pipelines to process your values and clean up your code.
Next time you have a handful of functions to apply in order, you'll know how to do it!

{{< elmSignup >}}
