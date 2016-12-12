---
date: "2016-12-12T09:00:00-06:00"
title: "The Care and Feeding of Folds in Elm"
tags: ["elm"]
featureimage: "/images/walrus-by-jay-ruzesky.jpeg"
thumbnail: "/images/walrus-by-jay-ruzesky-with-title.png"
section: "Technology"

---

Welcome back! 
We're in the middle of a series about implementing functional data structures in Elm.
In [part one]({{< ref "sets-intro.md" >}}) we implemented the skeleton of our sets using a binary search tree.
Last week, [part two]({{< ref "sets-member-size.md" >}}), we added membership tests and size to our set.
This week we're going to make a quick pit stop to talk about how folds work, and next week we'll implement them for our set.

<!--more-->

## What's a Fold?

Folds go by a few different names.
You may know them as "reduce" or "inject", but the basic operation remains the same.
We take a function to combine two values, an intial value, and a collection, and use the function to combine all the values in the collection.
So combining a list of numbers by summing them, for example, looks like this:

```elm
List.foldl (+) 0 [1, 2, 3] -- 6
```

Our folding function (the first argument) is `(+)`, which just takes two numbers and returns them added together.
Our initial value (the second argument) is 0.
When this code runs, we call `(+)` with each of the items in the list and keep track of our accumulated value.
Folds are usually recursive, so the calls will look like this when written out in order.
I've added the call to `(+)` and the result of that call in the comment on each line:

```elm
List.foldl (+) 0 [1, 2, 3] -- 1 + 0 == 1
List.foldl (+) 1 [2, 3]    -- 2 + 1 == 3
List.foldl (+) 3 [3]       -- 3 + 3 == 6
List.foldl (+) 6 []        -- empty list, we're done!
```

Each time the fold recurses, the output value of the function call gets substituted in as the new accumulator value.
When we get to the base case (the empty list, here) the results bubble up to the original call to `foldl`, just like our recursive functions from last week.
So adding 1 through 3 returns 6!

The signature for `foldl` is:

```elm
foldl : (a -> b -> b) -> b -> List a -> b
```

Note that the combiner function takes the current value first (here `a`) and the accumulator value (here `b`) second.

## Left Right Left Right

There are actually *two* folds, one in each direction.
`foldl` starts at the front of the collection and calls values going towards the end, while `foldr` does the opposite.
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
If you can write your function so that the order of operations doesn't matter, use `foldl`, for the same reason.
On the other hand, if you know that the order of operations matters, you'll know which to choose.

In our examples, the order of calls to `(+)` don't matter (mathematically, it's a commutative operation.)
But calls to `(::)`, on the other hand, need to respect ordering.

And if you're ever confused about what's going on in your folds, write them out call by call like I've done above.
It really helps to figure out what exactly is being called when.
I find it most helpful to do on paper (but I couldn't exactly do that here!)

Pit stop complete.
Next week: implementing folds for our sets!

{{< elmSignup >}}
