---
date: "2017-01-23T09:00:00-06:00"
title: "Functional Sets, Part 7: Filter, Diff, and Intersect"
tags: ["elm"]
featureimage: "/images/coffee-by-thomas-martinsen.png"
thumbnail: "/images/coffee-by-thomas-martinsen-with-title.png"
section: "Technology"
draft: true

---

This week in [the Sets series]({{< ref "post/sets-intro.md" >}}), we're going to look at `filter.`
It does the same thing as `List.filter`, except using our sets.
We'll have it take a function that checks whether we should include a value, and use the output of that function to filter the values from the set.

<!--more-->

Of course, we can't just remove values at random without unbalancing our sets, so we'll use `foldl`:

```elm
filter : (comparable -> Bool) -> Set comparable -> Set comparable
filter cmp set =
    foldl
        (\item acc ->
            if cmp item then
                insert item acc
            else
                acc
        )
        empty
        set
```

In this, we're just inserting the item into a new set if the comparator function returns `True`, otherwise we'll skip adding it and just return the accumulator value.
Easy enough!

We could also implement this in reverse: we'd start with the accumulator as our initial value and [use `remove`]({{< ref "post/sets-union-remove.md" >}}) if the comparator function didn't match.
Both approaches are equally valid, but one is probably faster.
If we were doing a real implementation we would want to benchmark.

So how do we use `filter`?
Say we had a set with the numbers 1 through 10:

```elm
numbers : Set Int
numbers =
    List.range 1 10 |> fromList
```

If we wanted to get only the even numbers from that set, we'd use `filter` like this:

```elm
evens : Set Int
evens =
    filter (\i -> i % 2 == 0) numbers
```

Side note: I've been using point-free style before, and we could here too!
But it's not really appropriate, and actually looks worse.
Check it out:

```elm
evens : Set Int
evens =
    filter (flip (%) 2 >> (==) 0) numbers
```

A little bit goes a long way with point-free style.
Remember that next time you're feeling especially clever!

## Bonus: `partition`

Now that we have `filter`, it's really easy to add `partition`.
We use this when we want to split a set in two according to some criteria.

```elm
partition : (comparable -> Bool) -> Set comparable -> ( Set comparable, Set comparable )
partition cmp set =
    foldl
        (\item ( yes, no ) ->
            if cmp item then
                ( insert item yes, no )
            else
                ( yes, insert item no )
        )
        ( empty, empty )
        set
```

## `intersect`

How about we do something more *interesting* with `filter`?
We can implement two more combination functions, `intersect` and `diff`.
Let's do `intersect` first.

Last week we implemented `union`.
We can represent that operation as a Venn diagram.
The two circles below represent our two sets, with the shared area representing shared values.
When we take a union of the two sets, we get everything contained in both sets.

![union, in a Venn diagram](/images/sets/union.png)

Taking the intersection of the two sets, on the other hand, means taking all the values that the two sets have *in common*.
In our Venn diagram, this is the area where the two circles overlap.

![intersect, in a Venn diagram](/images/sets/intersect.png)

```elm
intersect : Set comparable -> Set comparable -> Set comparable
intersect a b =
    filter (\item -> member item a) b
```

We use `filter` to implement `intersect`.
We select which items to include by using `member`.
All these little helper-looking functions are really starting to add up!
This can read "if this member of set b is also a member of set a, include it."
That works out to the intersection of the sets!

```elm
intersect (fromList [1, 2]) (fromList [2, 3]) == fromList [2]
```

## `diff`

But what if we want only the values in one set or the other, instead of both?
That's a `diff` operation.
`diff` removes all the items in the second set from the first set.

![diff, in a Venn diagram](/images/sets/diff.png)

Do note that we're implementing an *asymmetric diff*.
That means that we're only removing values from *one* set.
In some set implementations, this is referred to as subtraction (where `union` is addition.)
Photoshop and other image manipulations usually refer to these terms this way.
They refer to diff as a *symmetric diff*, which removes any items in common between the two sets, and leaves only items unique to one or the other.

Elm's built-in Set implement uses asymmetric diffs, with the right-hand set removing values from the left-hand set.
We'll do that too!

```elm

diff : Set comparable -> Set comparable -> Set comparable
diff a b =
    filter (\item -> not <| member item b) a
```

This is essentially the same as `intersect`, but with an added `not`.
We're checking if an item is a member of `b`.
If so, we don't include it.

It ends up working like this:

```elm
diff (fromList [1, 2]) (fromList [2, 3]) == fromList [1]
```

## Wrap Up

So we've learned:

- `filter` (like every other collection operation) can be implemented in terms of folds.
- `partition` does the same thing, but keeps the items that fell through the filter in a separate set.
- `intersect` and `diff` are implemented in terms of `filter`.
   We wouldn't *have* to do this (we could implement using folds every time) but using `filter` makes things much cleaner.

After this, we have one major piece of the API left: mapping.
See you then!

{{< elmSignup >}}
