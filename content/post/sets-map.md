---
date: "2017-01-30T09:00:00-06:00"
title: "Functional Sets, Part 8: Map"
tags: ["elm"]
featureimage: "/images/map-by-jean-fredric-fortier.png"
thumbnail: "/images/map-by-jean-fredric-fortier-with-title.png"
section: "Technology"
draft: true

---

With [filter and friends finished]({{< ref "post/sets-filter.md" >}}), our [`Set` implementation]({{< ref "post/sets-intro.md" >}}) is almost finished!
Once we have `map`, we'll be done!

<!--more-->

If you're unfamiliar with `map`, it's used to apply a function to every item in a collection.
Say we have a set with the numbers one through five.
We can use `map` to double every number:

```elm
Set.fromList (List.range 1 5)
    |> Set.map ((*) 2) -- [2, 4, 6, 8, 10]
```

How do we make this for our Sets?
What if we deconstruct our set, piece by piece, like we [did with member]({{< ref "post/sets-member-size.md" >}})?
That way, we'd apply the function exactly once to each item, and get a new set!

But… what about functions that return the same value?
What if our map function was `always 1`?
If we applied that function to every item, we would have a set with 5 ones in it!
That won't work since Sets always have unique values.

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

This looks like `filter` and every other collection operator we've made since `foldl`.
Since we can make every

And… that's it!
That's the whole Set API!
If you've been following along this whole time, you now know a lot more about how to implement data structures in Elm.
We'll be back next week to sum up and sneak a peek at how we can extend our Sets to be Dicts.

{{< elmSignup >}}
