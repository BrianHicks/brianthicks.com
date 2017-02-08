---
date: "2017-01-30T09:00:00-06:00"
title: "Functional Sets, Part 8: Map"
tags: ["elm", "sets"]
featureimage: "/images/map-by-jean-fredric-fortier.png"
thumbnail: "/images/map-by-jean-fredric-fortier-with-title.png"
section: "Technology"

---

Now that we have [filter and friends]({{< ref "post/sets-filter.md" >}}), we're almost done with our [`Set` implementation]({{< ref "post/sets-intro.md" >}}).
Once we have `map`, we'll be done!

<!--more-->

`map` applies a function to every item in a collection.
Say we have a list containing the numbers one through five.
We can use `List.map` to double every number:

```elm
List.range 1 5 |> List.map ((*) 2) -- [2, 4, 6, 8, 10]
```

We're going to make `map` for our sets.
So, given the same list (but converted to a set) we should get:

```elm
Set.fromList (List.range 1 5)
    |> Set.map ((*) 2) -- {2, 4, 6, 8, 10}
```

Let's do this…
What if we deconstruct the set piece by piece like we [did with member]({{< ref "post/sets-member-size.md" >}})?
That way, we'd apply the function exactly once to each item, and get a new set!

Not so fast!
What about functions that return the same value?
What if we got `always 1`?
When applied to the set from earlier we would get a set with `1`, five times.
That won't work!
Sets always have unique values, so we need a different approach.

`foldl` comes to our rescue here again.
Since it moves values through a function to an accumulator piece by piece, we can build a new Set as we go.
We'll start with an empty list as our accumulator value, then `insert` the mapped values one at a time.
If we get any duplicates, they'll be removed as we go.

Here's how it looks:

```elm
map : (comparable -> comparable2) -> Set comparable -> Set comparable2
map fn set =
    foldl
        (\item acc -> insert (fn item) acc)
        empty
        set
```

It works just like we said above:

```elm
Set.fromList (List.range 1 5)
    |> Set.map ((*) 2) -- {2, 4, 6, 8, 10}
```

And if we use a function that returns duplicate values, they're deduplicated automatically:

```elm
Set.fromList (List.range 1 5)
    |> Set.map (always 1) -- {1}
```

And… that's it!
That's the whole Set API!
If you've been following along this whole time, you should know a lot more about how to implement data structures in Elm.
We'll be back next week to sum up and sneak a peek at how we can extend our Sets to be Dicts.

{{< setsSeriesSignup >}}
