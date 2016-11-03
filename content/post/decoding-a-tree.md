---
date: "2016-11-07T09:00:00-06:00"
title: "Happy Little Trees: Decoding Recursive Data Structures in Elm"
draft: true

---

You know how you stay up late trying to figure out why your recursive types just. won't. decode?
I've done it too.
Wouldn't it be nice if it would, you know, just work how you wanted it to?
Fortunately, `Json.Decode.Extra.lazy` exists, so it you can get it to work right away!

<!--more-->

## Happy Little Trees

Let's use the example of a [binary search tree](https://en.wikipedia.org/wiki/Binary_search_tree).
In brief: a node in a binary search tree holds a single element, and two subtrees containing all elements greater than and less than the current value.
If there are no values greater than or less than the current value, the subtrees are empty.

Here's how it looks in Elm:

```elm
type BST comparable
    = Branch (BST comparable) comparable (BST comparable)
    | Leaf
```

For this example, however, we're going to work with a binary search tree that only contains integers.
It'll keep things just a little simpler.

```elm
type BST
    = Branch BST Int BST
    | Leaf
```

Here's what a tree with 1, 2, and 3 in it looks like:

```elm
Branch
    (Branch Leaf 1 Leaf)
    2
    (Branch Leaf 3 Leaf)
```

Which would look like this in JSON:

```json
{
    "value": 2,
    "lt": {
        "value": 1,
        "lt": null,
        "gt": null
    },
    "gt": {
        "value": 3,
        "lt": null,
        "gt": null
    }
}
```

So, how do we take that JSON and get our data structure?

## Decoding Happy Little Trees

Here's how:

```elm
bst : Decoder BST
bst =
    oneOf
        [ null Leaf
        , object3
            Branch
            ("lt" := (lazy (\_ -> bst)))
            ("value" := int)
            ("gt" := (lazy (\_ -> bst)))
        ]
```

Let's break this down.
First, I've imported everything into the current namespace with `import Json.Decode exposing (..)`.

We start off with `oneOf`.
`BST` is a union type, so we need to be able to represent both of our tags.
We'll just have one decoder for each tag in a list.

We'll we'll do `Leaf` first, as it's a little simpler.
Remember that we're just representing it as `null` here.
`Decode.null` just takes a value to represent null, and here `Leaf` works just fine.
First branch: done!

Next is `Branch`.
This is a little more complex, but it uses the normal [objectN decoder]({{< ref "decoding-large-json-objects.md" >}}).
The only *unusual* part is that we're using this `lazy` thing.
What's up with that?

Well, what happens when we try to write the decoder *without* `lazy`?
If we substitute `("lt" := bst)`, Elm wouldn't complain&hellip; but it would crash when we ran it.
(side note: [this is fixed in 0.18](https://github.com/elm-lang/elm-compiler/issues/873))
That's because we're defining the `bst` Decoder in terms of itself.
The general rule is that you need at least one lambda between a definition and the use of that definition.
We use `lazy` to get that.
`lazy` just takes a lambda that returns a decoder, and returns that decoder.
It's a handy way to define our decoders recursively.

As of Elm 0.17 `lazy` comes from [elm-community/json-extra](http://package.elm-lang.org/packages/elm-community/json-extra/1.1.0/Json-Decode-Extra#lazy), but it's being added into the standard library in 0.18.
At the time of this writing, Elm 0.18 is in beta, so pay attention to which version you're using here!

`lazy` really is the secret sauce that makes this decoder work.
Once we add it, we can use our decoder just like any other decoder, and we'll get our recursively defined type out the other side.
Try it yourself!
[Run this gist](https://gist.github.com/BrianHicks/988e31bd221d2164f984227ecbe1fa1e) and see what you get.
And use `lazy` next time you're trying to write a recursive decoder.

{{< elmSignup >}}
