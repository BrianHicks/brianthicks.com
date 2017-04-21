---
date: "2017-02-06T09:00:00"
title: "Functional Sets, Part 9: Wrap-up"
tags: ["elm", "sets"]
featureimage: "/images/cern-reception-by-samuel-zeller.png"
thumbnail: "/images/cern-reception-by-samuel-zeller-with-title.png"
section: "Technology"

---

Our Set implementation is done!
We just have a few things to wrap up.

<!--more-->

## Get All the Posts

This was a long series!
If you'd like to go through it again, or didn't see all of the posts the first time, I've set up a way to get them by email.
You'll get them once per week, but without any interruption.

[Sign up here to get the post series in your inbox.](https://www.getdrip.com/forms/40161339/submissions/new)

## `Dict`s

There's another fun experiment you can do now: build `Dict` on top of what we've already got!

`Dict`s are sets of keys associated with values.
In fact, core's `Set` is actually `Dict comparable ()`.
All the Set functions there are wrappers over the `Dict` functions.

Since we've already got key management, you'll just need to write some code to retrieve values.
[Core's `Dict` implementation](https://github.com/elm-lang/core/blob/master/src/Dict.elm) will be a great reference (although it uses red/black trees instead of AVL trees.)
Here's how you can change the `Set` constructors to get started:

```elm
type Dict comparable a
    = Tree Int comparable a (Dict comparable a) (Dict comparable a)
    | Empty
```

## Errata

### Remove

The [implementation of `remove`]({{< ref "post/sets-union-remove.md" >}}) I wrote originally had a bug.
The tree rooted at the item for removal would be rebalanced, but the parents wouldn't be.
That means that if you removed all the items on one side of the tree, it would become more and more unbalanced.

Try this yourself by creating a set, then removing all the items in the left side.
The tree will become more and more unbalanced the more items you remove from it.
An easy replication: `List.range 1 10 |> fromList |> remove 1 |> remove 2 |> remove 3`.

We fix this by rebalancing the tree after each removal:

```elm
remove : comparable -> Set comparable -> Set comparable
remove item set =
    case set of
        Empty ->
            set

        Tree _ head left right ->
            if item < head then
                tree head (remove item left) right |> balance
            else if item > head then
                tree head left (remove item right) |> balance
            else
                union left right
```

Thanks to [Ilias Van Peer](https://ilias.xyz/) for the catch!

### Constructors

Some posts had incorrect `Set` constructors.
This happened because I changed the set internals several times while writing the posts.
I thought I got them all, but some slipped through.
These have all been corrected.

Tons of people wrote in about this. You're all awesome; thank you!

{{< setsSeriesSignup >}}
