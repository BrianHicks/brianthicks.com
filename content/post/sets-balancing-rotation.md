---
date: "2016-11-21T09:00:00-06:00"
title: "Functional Sets, Part 2: Rotation"
tags: ["elm"]
featureimage: "/images/stars-by-warlen-g-vasco.jpeg"
thumbnail: "/images/stars-by-warlen-g-vasco-with-title.png"
section: "Technology"
draft: true

---

[Last time]({{< ref "sets-intro.md" >}}) we started making a set using a binary search tree.
Let's continue by adding more functionality to our set!
We're going to improve it by making sure our set stays in proper order.

<!--more-->

## Quick Recap

Our sets are [binary search trees](https://en.wikipedia.org/wiki/Binary_search_tree) under the covers.
We've modeled this data structure in our Elm code like this:

```elm
type Set comparable
    = Set comparable (Set comparable) (Set comparable)
    | Empty
```

We can create empty sets using `empty`, sets with a single item using `singleton`, and bigger sets by using `insert` or `fromList`.

## Off Balance

Unfortunately, all is not well in set land&hellip;
Our `insert` function behaves badly under certain conditions.
The simplest place this happens is when you try to create a set from a list that's already in order.
When we run `fromList [1, 2, 3, 4, 5]` we'd want to get this:

{{< figure src="/images/sets/one-through-five-balanced.png"
           caption="A balanced tree containing the numbers 1 through 5." >}}
           
But instead, we get:

{{< figure src="/images/sets/one-through-five-unbalanced.png"
           caption="An unbalanced tree, the result of our naive insert implementation" >}}

In a small set, this doesn't make a huge difference.
But it means that the functions we'll implement going forward won't be as fast as they could be on larger sets.
A binary search tree ought to have `O(log n)` search performance, but in this case we'd get `O(n)`.
That means if we inserted 1 through 1000 in order right now, we'd have to perform 1000 operations to see if `1000` is in the set.
If we balanced the tree, we would only have to perform around ten!
This seems like something we might want to fix, so let's do that.

## AVL Trees

Fortunately for us, tons of smart people have thought about this problem.
We have to choose from red-black trees, scapegoat trees, splay trees, treaps&hellip;
But we're going to use AVL Trees.

[AVL trees](https://en.wikipedia.org/wiki/AVL_tree) take their name from their inventors: Adelson-Velsky and Landis.
To create one, we'll need to keep track of the height of each tree.
An empty set is height 0, a singleton is height 1, and anything else is the height of it's tallest subtree plus 1.
When we `insert`, we'll look at the new heights of the trees after insertion.
If the difference between them is greater than 1, we'll rotate!

We'll change our implementation of `Set` to look like this:

```elm
type Set comparable
    = Tree Int comparable (Set comparable) (Set comparable)
    | Empty
```

The `Int` as the new first field of `Tree` will hold the tree's height.
We'll need to get and set this field, so first let's write a function to retrieve the height of the tree.
It looks like this:

```elm
height : Set comparable -> Int
height set =
    case set of
        Empty ->
            0

        Tree height _ _ _ ->
            height
```

An empty set is height 0, of course.
Everything else will be whatever height we've pre-calculated.
We don't want to recaculate it every time, because it would be extra work and break our `O(log n)` performance.
We'll do *that* in a new constructor:

```elm
tree : comparable -> Set comparable -> Set comparable -> Set comparable
tree head left right =
    Tree
        (max (height left) (height right) |> (+) 1)
        head
        left
        right
```

`tree` takes a head and two subtrees, and returns the new tree with the right height.
The calculation here is like I said above: we add one to the height of the tallest subtree.

There are a couple more minor changes here (`singleton` now sets height to `1`.)
The big change we'll need is to make `insert` use the new `tree` constructor to keep our heights correct:

```elm
insert : comparable -> Set comparable -> Set comparable
insert item set =
    case set of
        Empty ->
            singleton item

        Tree _ head left right ->
            if item < head then
                tree head (insert item left) right
            else if item > head then
                tree head left (insert item right)
            else
                set
```

That's pretty much all we'll need to do to the set the stage!
There's an embedded Elm program at the bottom of this post that will let you play around with making your own sets.

But first, we need a way to balance our trees&hellip;

## Rotation

Wikipedia has an *amazing* GIF to explain tree rotation:

{{< figure src="/images/sets/Tree_rotation_animation_250x250.gif"
           caption="A Tree Rotating Left and Right"
           attr="Wikipedia"
           attrlink="https://en.wikipedia.org/wiki/File:Tree_rotation_animation_250x250.gif" >}}
           
In words: to rotate left, we have to have a tree with a non-empty subtree as it's right subtree.
For the sake of clarity, we're going to call the original head `head` and the subtree's head `subHead`.

Remember how all the values to the left of a subtree are less than the head, and the values to the right are greater?
Well, that means that the left subtree of the right subtree contains values *between* the two heads!
We'll use that nifty little property to our advantage here.
Let's refer to the left subtree of the original tree as `lessThans`, and the left and right subtrees of the subtree as `betweens` and `greaterThans`.

Now, armed with our terms, we can rotate left.
We'll be creating a new `Tree`, with `subHead` as the head.
The left subtree will be another new tree, with `head` as the head, `lessThans` as the left subtree, and `betweens` as the right subtree.
Last, we attach `greaterThans` as the right subtree.
To rotate right, we do the opposite.

Whew!
That's a ton of words to describe something that's fairly succinct in code:

```elm
rotl : Set comparable -> Set comparable
rotl set =
    case set of
        Tree _ head lessThans (Tree _ subHead betweens greaterThans) ->
            tree subHead (tree head lessThans betweens) greaterThans

        _ ->
            set


rotr : Set comparable -> Set comparable
rotr set =
    case set of
        Tree _ head (Tree _ subHead lessThans betweens) greaterThans ->
            tree subHead lessThans (tree head betweens greaterThans)

        _ ->
            set
```

We always put `lessThans`, `betweens` and `greaterThans` in order in the source.
If these ever get out of order, we're going to be breaking our guarantees about structure.

Note that we don't need `insert` at all to rotate!
This is helpful, since we'll rotate as part of balancing, and we have to balance when we insert.
If we had to call `insert` in the rotation, we'd end up in an infinite loop.
`O(infinity)` is quite a bit higher than `O(log n)`!

## Make Your Own Trees

Getting all this in your head can be difficult.
It helps me to visualize these things, when I can, so I wrote a program to do that.
Purple circles indicate empty sets.
The "height balance" of a tree is the height of the right subtree minus the height of the left.
Do note that the program interprets all values as strings, so `a` through `z` may work better than numbers if you want to try a large number of values.

Next week we'll apply these rotations automatically when we insert.
See you then!

### Things to try:

- Enter 1, 2, and 3 as the values.
  Rotate the tree and see how that works.
- Enter 2, 3, 1 in order.
  Hey, the insert code does what we said it would!
- Enter a through z.
  Trace the operations you'd take to get to any given letter.

{{< elmEmbed src="/scripts/sets/naiveInsertRotate.js" name="NaiveInsertRotate" >}}

{{< elmSignup >}}
