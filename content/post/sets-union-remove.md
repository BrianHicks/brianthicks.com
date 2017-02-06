---
date: "2017-01-16T09:00:00-06:00"
title: "Functional Sets, Part 6: Union and Remove"
tags: ["elm", "sets"]
featureimage: "/images/union-station-by-tatiana-latino.jpeg"
thumbnail: "/images/union-station-by-tatiana-latino-with-title.png"
section: "Technology"

---

With [folds]({{< ref "sets-folds.md" >}}) done, our [sets]({{< ref "sets-intro.md" >}}) are shaping up.
Folds unlock some more interesting things for us.
Namely: unions!

<!--more-->

## Union &ndash; Two Sets Into One

The union of two set is the set of all the items in both.
So if we have a set with 1 and 2, and a set with 2 and 3, the union of the two sets is 1, 2, and 3.
What we want, in code, is:

```elm
union (fromList [1, 2]) (fromList [2, 3]) == fromList [1, 2, 3]
```

So how would we go about that?
How about we `insert` all the items from the first list into the second?
Since `insert` will deduplicate for us, we won't have to rewrite any logic!
We can combine `insert` with `fold` to get our implementation.

```elm
union : Set comparable -> Set comparable -> Set comparable
union =
    foldl insert
```

Seriously, that's the whole thing.
I'm just as surprised as you!
It was quite a shock when I replaced the version I wrote before `foldl` with that tiny thing and the tests all passed.
So what's going on here?
Why is this so simple?

Remember how fold takes an accumulator value?
So far we've only used base values like an empty list or the number 0.
But there's nothing that prevents us from using a more complex value here!

We'll use the first set passed in as the accumulator value.
Then `foldl` walks over all the items of the second set and insert them into the first.
The result is the union of the two sets!

By the way: yes, I used point-free style again here.
If you want to do without:

```elm
union : Set comparable -> Set comparable -> Set comparable
union a b =
    foldl insert a b
```

But if you do it in point-free style, you don't have to worry about what to call the two sets.
Bonus!

## Removing Items

Now that we can get the union of two sets, we can remove items.
This seems counterintuitive at first.
Why would we need to join two sets to remove an item?
Isn't that the opposite of what we want to do?
Let's see!

We want this call to look like:

```elm
remove 1 (fromList [1, 2]) == singleton 2
```

If the set is empty or doesn't contain the value, we shouldn't do anything.
Otherwise, we should return a new set without the value in it.

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

This looks like [member]({{< ref "sets-member-size.md" >}})!
When we have an empty subtree, we return it unchanged.
When we find a tree where the head is not equal to the item we're looking for, we try and remove from the relevant subtree.
And finally, if the head we're looking at *is* the one we're looking for, we have to construct a new tree without it.

In this case, we can't return an `Empty`, because the subtrees might have values in them.
We also can't return a `Tree`, because we don't have a head.
So we use our newly-minted `union` function to combine the left and right subtrees into a new `Set`.
The function calls then bubble up like normal, and we're done.

**Update**: You also have to rebalance the parent trees after removal, or the set becomes unbalanced.
Try this yourself by removing the `balance` calls above and creating a set, then removing all the items in the left side.
The tree will become more and more unbalanced the more items you remove from it.
An easy replication: `List.range 1 10 |> fromList |> remove 1 |> remove 2 |> remove 3`.

Thanks to [Ilias Van Peer](https://ilias.xyz/) for the catch!

## Union'd and Remove'd!

So this week, we've seen:

- Exactly how terse a fold can make a function.
  We specify what function we want to combine values with and our work is done.
  (This is the second week in a row we've seen this. It's important!)
- How to remove an item from a tree: make a new tree without that item.

Next week we're going to make another useful function: `filter`.
We'll use it to do some more set operations!

{{< elmSignup >}}
