---
date: "2016-08-15T09:00:00-05:00"
tags: ["elm"]
title: "Welding Functional Pipes"
draft: true

---

Last time we talked about [using `<|` and `|>` to build pipelines]({{< ref "values-pipes-and-arrows.md" >}}).
That's all well and good, but following the analogy from last time: what if you need pipes without the water?
Well, that's easy enough to do with function composition!

<!--more-->

## Introducing `<<` and `>>`

`<<` and `>>` are "function composition" operators.
They build the pipelines we want without having to have an initial value.
This will make more sense by looking at the type signature:

```elm
(>>) : (a -> b) -> (b -> c) -> a -> c
```

In other words, given a function from `a` to `b`, and a function from `b` to `c`, we'll get a function from `a` to `c`.
`<<` reverses the order of these arguments: `b -> c` is first, followed by `a -> b`.
That's pretty magic, though, so let's break it down.

## Currying

Mmm, curry.
Delicious.
I'm getting hungry thinking about it.

Wait!
I'm not talking about that kind of curry here!
This kind of curry is just as delicious, but much more useful for programming.

For us, currying means that applying a function to multiple arguments takes place one argument at a time.
Say we have an `add` function:

```elm
add : number -> number -> number
add x y = x + y
```

And call it with only *one* argument?

```elm
add 1
```

What do we have here?
In JavaScript, that'd be the result of calling `add(1, undefined)`, which would result in `NaN`.
But in Elm, we'll get a function that takes one number, and gives us a result.
This means that this is a perfectly reasonable thing to do:

```
add x y = x + y

add1 = add 1

add1 1 -- result: 2
```

In other words, `add 1` is the same thing as `add1 y = add 1 y`.
Pretty neat!
But how is this useful?
How about adding one to every item in a list of numbers?

```elm
nums = [1, 2, 3]

List.map (add 1) nums -- result: [2, 3, 4]
```

`List.map` only takes a function with a single argument.
But we can provide the rest of the arguments!
(Side note: if you want to combine this with the stuff from [last time]({{< ref "values-pipes-and-arrows.md" >}}), try `nums |> List.map (add 1)`)

## Welding Functions Together

So now we can understand a little more of what's going on in `>>` above.
You always see `<<` and `>>` called like this:

```elm
isEven >> not
```

We know that `isEven` is our `a -> b` function, and `not` is our `b -> c`.
(If that sounds unfamiliar to you, here's [how infix operators work]({{< ref "elm-bang.md" >}}).)
In this case, we're just negating the ouput of `isEven`.

What's next?
Well, `<<` takes *three* arguments, not two, before returning a value.
Applying this function to a number will tell us if it's odd or not!

```elm
isOdd : number -> Bool
isOdd = isEven >> not

isOdd 1 -- result: True
isOdd 2 -- result: False
```

So if functions are our pipes, and values are our water, then `>>` welds pipes together to make new pipelines!
We can keep on welding them together, too:

```elm
sqrtIsOdd = Float -> Bool
sqrtIsOdd = sqrt >> isEven >> not
```

## Left or Right?

So taken together, we have some powerful ways to compose our functions into new bigger functions.
Neat!
But one question remains: when should you use `<<` versus `>>`?

There's no hard and fast rule, but the documentation recommends using `<<` more often.
When you use `<<`, the resulting call looks more like what you'd read in English.
Since these operators are all about improving readability, this makes sense!
Compare `not << isEven` vs `isEven >> not`.
Even `sqrtIsOdd` can improves a little by defining it as `not << isEven << sqrt`.

But the one thing that you *should not do* is mix the forward- and backward-facing operators.
You'll have to think hard about how to do it without parentheses to make things explicit.
Plus, avoiding those nested parentheses is why you're using this in the first place!

{{< elmSignup >}}
