---
date: "2017-09-05T21:39:54-05:00"
title: "Breaking Down Decoders From the Bottom Up"
tags: ["elm"]
featureimage: "/images/breaking-down-decoders-from-the-bottom-up.png"
thumbnail: "/images/breaking-down-decoders-from-the-bottom-up-with-title.png"
section: "Technology"
---

Last week, we covered [how to break down decoders by starting from the innermost, or topmost, part]({{< ref "breaking-out-of-deeply-nested-json-objects.md" >}}).
But what if you're having trouble breaking things down from the top?
(Or you're dealing with a *really* complex JSON schema?)

This week, let's look at it from a different perspective: the outermost structure in (or the bottom up!)

<!--more-->

Remember, we're dealing with this JSON:

```json
{
  "Site1": {
    "PC1": {
      "ip": "x.x.x.x",
      "version": "3"
    },
    "PC2": {
      "ip": "x.x.x.x",
      "version": "3"
    }
  },
  "Site2": {
    "PC1": {
      "ip": "x.x.x.x",
      "version": "3"
    },
    "PC2": {
      "ip": "x.x.x.x",
      "version": "3"
    }
  }
}
```

When we looked at it before, we started from the innermost value.
I told you then that it's a good approach because the structure typically doesn't change too much.
But sometimes it's way too difficult to see the whole structure at once, and you want to let the compiler guide your steps.

In that case, we can use `Json.Decode.value`!
The documentation for `value` describes it likes this:

> Do not do anything with a JSON value, just bring it into Elm as a Value.
> This can be useful if you have particularly crazy data that you would like to deal with later.
> Or if you are going to send it out a port and do not care about its structure.

Hey!
That fits us!
We want to be able to just decode our first level, and not worry about the rest.
So let's do that!
(and as an aside: I'm not a huge fan of calling things "crazy" so we're going to be referring to them as "unusual" or "weird" here.)

`value` is just a `Decoder Value`, where `Value` is an opaque type (meaning we can't see into it, like a frosted glass window.)
We already know that we have a `Dict` with site names, so let's tell Elm that we're expecting those keys but don't particularly care about the values:

```elm
sites : Decoder (Dict String Value)
sites =
    dict value
```

Now when we try to decode, we get a dictionary of keys to values:

```elm
decodeString sites ourSitesBlob 
  == Ok (Dict.fromList 
       [ ("Site1", { PC1 = { ip = "x.x.x.x", version = "3" }, PC2 = { ip = "x.x.x.x", version = "3" } })
       , ("Site2", { PC1 = { ip = "x.x.x.x", version = "3" }, PC2 = { ip = "x.x.x.x", version = "3" } })
       ])
```

Now, you might look at this and go "well, hey, why can't I just use those things? I can see them!"
But remember that we haven't told Elm what types they are!
The compiler can't validate that we're using these in a way that makes sense, so we need to attach that info using decoders.
However, there *is* a benefit to being able to see our remaining structure: it gives us our next step!

We already knew that we had another mapping of names to metadata, but now we can see that.
Using this information, let's add another layer!

```elm
sites : Decoder (Dict String (Dict String Value))
sites =
    dict (dict value)
```

When we decode it, we get:

```elm
decodeString sites ourSitesBlob 
  == Ok (Dict.fromList 
       [ ("Site1"
         , Dict.fromList 
           [ ( "PC1", { ip = "x.x.x.x", version = "3" } )
           , ( "PC2", { ip = "x.x.x.x", version = "3" } )
           ]
         )
       , ( "Site2"
         , Dict.fromList 
           [ ( "PC1", { ip = "x.x.x.x", version = "3" } )
           , ( "PC2", { ip = "x.x.x.x", version = "3" } ) 
           ]
         )
       ])
```

Our unknown `Value`s have shrunk down, and we can see that we're almost done!
Now we just need the last step: our `machine` decoder from before:

```elm
type alias Machine =
    { ip : String
    , version : String
    }


machine : Decoder Machine
machine =
    map2 Machine
        (field "ip" string)
        (field "version" string)
```

With that, we can define our final decoder without using `value`:

```elm
sites : Decoder (Dict String (Dict String Machine))
sites =
    dict (dict machine)
```

And we're done!

## Now It's Your Turn!

Now you want to apply this to your own projects, right?
To break down a JSON object from the bottom up, you'll need to:

1. Decode the information *one* level at a time, filling in `value` for levels you haven't reached yet.
2. Use the REPL or tests to verify that you're decoding successfully.
3. Refine any remaining `value`s with steps 1 and 2 until you're done!

If you get stuck, you're probably trying to tackle too much at once!
Break down the part you're trying to do into the smallest possible unit and solve that, and build back up from there.

You'll know you're making progress if, after each step, your `Value` objects get smaller.

And remember, [think with building blocks, not huge blobs]({{< ref "composing-decoders-like-lego.md" >}})!

{{< elmSignup >}}
