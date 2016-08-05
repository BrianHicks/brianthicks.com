---
date: "2016-08-08T09:00:00-05:00"
tags: ["elm"]
title: "Values, Pipes, and Arrows"
draft: true

---

Say you've got a bunch of functions, and you want to use them together.
This is a common situation, but it can get a little&hellip; messy.
Let's take an example from the Elm docs:

```elm
scale 2 (move (10,10) (filled blue (ngon 5 30)))
```

This is, well, just OK.
It definitely could be clearer.
So how do we do that?

<!--more-->

## No More Parentheses

We're going to take this in several steps.
First, let's remove the parentheses with `<|`:

```elm
scale 2 <| move (10,10) <| filled blue <| ngon 5 30
```

So what's going on here?
You can think of the `<|` operator as a pipe.
Values move through it like water moves through real-life pipes.
So we're setting up a processing facility!

The result of the call to `ngon 5 30` is a value, which we pass to `filled blue`.
This is exactly the same as calling `filled blue (ngon 5 30)`.
This can help clear up what's happening in your code.
For example, when you're using `Html.App.map` to map one views value to the parent:

```elm
view : Model -> Html Msg
view model =
    App.map ParentMsg <| Child.view model.child
```

This is simplified, but serves to prove the point.
It's clear in this example that the output of the child view is wrapped with `Html.map`

## Arrows Pointing The Way

We still have a problem with our code: it's going "backwards"!
We (English speakers) read left-to-right, but our code is going right-to-left.
What if we just&hellip; reverse it?

```elm
ngon 5 30 |> filled blue |> move (10,10) |> scale 2
```

That's even clearer, right?
The `|>` operator like to `<|`, but goes left-to-right instead of right-to-left.
The way the arrow points is the direction that values "travel".

One more step: formatting!

```elm
ngon 5 30
    |> filled blue
    |> move (10,10)
    |> scale 2
```

You can add newlines between your operators.
In fact, you'll usually see these operator pipelines written this way.
And indeed, the [elm docs](http://package.elm-lang.org/packages/elm-lang/core/4.0.4/Basics#|>) use this as the final rewritten form.

We can see a "real life" example of this in [Duplicating Scientists in Elm: Stop Sharing State]({{< ref "duplicating-scientists-in-elm-stop-sharing-state.md" >}}):

```elm
view : Model -> Html Msg
view model =
    Html.div []
        [ Html.ul 
            []
            (model.scientists
                |> Dict.values
                |> List.map itemView)
        , lookupByID model.selected model.scientists
            |> detailView
        ]
```

We're passing values around to different functions by using these operators.

## One More Thing: Names?

So we have `<|` and `|>`.
These are wonderful functions, and sharp tools to have in your toolbox.
But what do we call them?

The docs refer to `<|` as the "backward function application" operator, and `|>` as the "forward function application" opertor.
These names are correct, but they're a mouthful!
Because of this, I usually refer to them as "backward application" and "forward application" or "pipe" operators.

## Finished

Now you now how to get rid of all those extra parentheses around your function calls.
You also know how to create pipelines to process your values and clean up your code.
Next time you have a handful of functions to apply in order, you'll know how to do it!

{{< elmSignup >}}
