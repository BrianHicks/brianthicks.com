---
date: "2016-12-12T09:00:00-06:00"
title: "Interlude: The Care and Feeding of Folds in Elm"
meta: [Elm 0.18]
showPublished: false
showModified: true
aliases:
 - /post/2016/12/12/the-care-and-feeding-of-folds-in-elm/
menu:
  functional-sets:
    weight: 5
---

Remember how [last time]({{< ref "4.md" >}}) we created `member` and `size`?
We found out that these two functions have to be implemented recursively to work with our sets.
But didn't it seem suspicious that they were so similar?
They basically both looked like this:

```elm
recursive : someArgument -> Set comparable -> Set comparable
recursive arg set =
    case set of
        Empty ->
            -- a base value

        Tree height head left right ->
            -- recursive calls
```

If it seemed like there was some underlying mechanism to these, that's because there was!
It's called a fold.

<!--more-->

## So Then, What's a Fold?

Folds go by a few different names.
You may know them as "reduce" or "inject", but the basic operation remains the same.

We take:

- A function to combine two values
- A collection of values
- An intial value

&hellip; and use the provided function to combine all the values, starting with the initial one.

A simple example is adding a bunch of numbers.
Starting with 0, we want to add each of the numbers in a list to get a total.
This would look like `sum [1, 2, 3]` to get `6`.
But we could also write it with a fold like this:

```elm
fold add 0 [1, 2, 3]
      ↑  ↑  ↑
      │  │  └ the collection
      │  └─── the initial value
      └────── the combiner function
```

So `fold add 0 [1, 2, 3]` is `6`, the same as `sum [1, 2, 3]`.
In fact, you can define `sum` with `fold` like `sum = fold add 0`&mdash;it just needs a list to operate on to give a result.

We can define `fold` like this:

```elm
fold : (item -> acc -> acc) -> acc -> List item -> acc
fold combine acc list =
    case list of
        [] ->
            acc

        item :: items ->
            fold combine (combine item acc) items
```

(n.b. `acc` is short for `accumulator`.
Also, if you're not used to reading type variables, just substitute `Int` everywhere in this post.)

This looks suspiciously like the recursive functions we wrote for sets, but with a twist: instead of defining some custom operation, we keep track of an accumulator (`acc`) that comes from a function we provide.

Let's trace this through our example `fold add 0 [1, 2, 3]`.
I've added the call to `add` and the result of that call in the comment on each line:

```elm
List.foldl add 0 [1, 2, 3] -- add 1 0 == 1
                           --       ^ initial state
List.foldl add 1 [2, 3]    -- add 2 1 == 3
                           --       ^ result of last add call
List.foldl add 3 [3]       -- add 3 3 == 6
List.foldl add 6 []        -- empty list, we're done!
```

Each time the fold recurses, the output value of the function call gets substituted in as the new accumulator value.
When we get to the base case (the empty list, here) the results bubble up to the original call to `foldl`, just like our recursive functions from last time.
So adding 1 through 3 returns 6!

## Left Right Left Right

Now, sorry.
I've lied a bit.
Or really, I haven't told the whole truth.
Folds are useful, but there's not just *one* fold, there are *two*: one for either direction.

`foldl` (which we've been working with so far) starts at the front of the collection and calls values going towards the end, while `foldr` does the opposite.
We'll demonstrate this with the cons operator, `(::)`.
Cons prepends a value to a list.
(So `1 :: [2] == [1, 2]`.)

```elm
List.foldl (::) [] [1, 2, 3] -- [3, 2, 1]

List.foldr (::) [] [1, 2, 3] -- [1, 2, 3]
```

When we fold from the left, we start with the empty list and cons 3, then 2, then 1 onto it.
Let's look at the calls:

```elm
List.foldl (::) []        [1, 2, 3] -- 1 :: []     == [1]
List.foldl (::) [1]       [2, 3]    -- 2 :: [1]    == [2, 1]
List.foldl (::) [2, 1]    [3]       -- 3 :: [2, 1] == [3, 2, 1]
List.foldl (::) [3, 2, 1] []        -- empty list, we're done!
```

But when we use `foldr`, we start from the other side:

```elm
List.foldr (::) []        [1, 2, 3] -- 3 :: []     == [3]
List.foldr (::) [3]       [1, 2]    -- 2 :: [3]    == [2, 3]
List.foldr (::) [2, 3]    [1]       -- 1 :: [2, 3] == [1, 2, 3]
List.foldr (::) [1, 2, 3] []        -- empty list, we're done!
```

## Which To Use?

If you're uncertain of which fold to use, use `foldl`.
It will process the values in the way that you'd most expect, and it's generally a little bit quicker than `foldr`.
(folding from the right usually requires finding the end of the collection, which is an additional little bit of overhead.)
So if you can write your function so that the order of operations doesn't matter, use `foldl`.

In our examples, the order of calls to `add` (AKA `(+)`) don't matter&mdash;`1+2` is the same as `2+1`&mdash;but calls to `(::)` do have an order.

Finally, if you're ever confused about what's going on in your folds, write them out call by call like I've done above.
It really helps to figure out what exactly is being called when.
I find it most helpful to do on paper or a whiteboard instead of still looking at a screen.

Pit stop complete.
Next week: implementing folds for our sets!

{{< setsSeriesSignup >}}
