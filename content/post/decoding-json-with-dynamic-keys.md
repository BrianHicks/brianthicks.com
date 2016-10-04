---
date: "2016-10-03T09:00:00-05:00"
title: "Decoding JSON With Dynamic Keys"
tags: ["elm"]
featureimage: "TODO"
draft: true

---

Sometimes JSON just doesn't play nice with our nice type systems. Consuming JSON
from a wide variety of sources can be challenging. Even when working with an
internal team you can be dealing with strange encodings. One common pattern is a
JSON object with dynamic keys. How we deal with this depends on the semantics of
the data, but it breaks down into two distinct patterns.

<!--more-->

There are two ways to deal with dynamic keys in your JSON, depending on what's
in the values. If your JSON always has the same value types (like a mapping of
names to set attributes), we can decode to a Dict. If the values change between
keys, we can use `oneOf` until we get a result or fail. Let's get started.

## Different Keys, Same Values

A JSON object whose values all have the same shape is the easiest situation to
deal with, hands down. You'll just need to use `Decode.dict` to wrap your value
Decoder, and you'll get back a Dict with your keys as strings and your values
decoded into the type you specify.

Say we have the following JSON&hellip; describing pies!

```json
{
    "cherry": {
        "filling": "cherries and love",
        "goodWithIceCream": true,
        "madeBy": "my grandmother"
     },
     "odd": {
         "filling": "rocks, I think?",
         "goodWithIceCream": false,
         "madeBy": "a child, maybe?"
     }
}
```

First we'll need to write a little decoder for this Pie (using
elm-decode-pipeline, of course.)

```elm
type alias Pie =
    { filling : String
    , goodWithIceCream : Bool
    , madeBy : String
    }


pie : Decoder Pie
pie =
    decode Pie
        |> required "filling" Decode.string
        |> required "goodWithIceCream" Decode.bool
        |> required "madeBy" Decode.string
```

Next, we'll wrap it in `Decode.dict` to tell the Decoder that while the keys may
be strings, the values are `Pie`s. When we run it through `Decode.decodeString`,
we get a nice result:

```elm
Dict.fromList
    [ ( "cherry"
      , { filling = "cherries and love"
        , goodWithIceCream = True
        , madeBy = "my grandmother"
        }
      )
    , ( "odd"
      , { filling = "rocks, I think?"
        , goodWithIceCream = False
        , madeBy = "a child, maybe?"
        }
      )
    ]
```

Hooray! We've decoded our value, next problem please!

## Free-For-All!

So what if our keys and values don't correlate in any way? What if… someone sent
a cake in our JSON? Chaos! But we still need to handle it.

I've added a cake into our JSON. Now it looks like:

```json
{
    "cherry": {
        "filling": "cherries and love",
        "goodWithIceCream": true,
        "madeBy": "my grandmother"
     },
     "odd": {
         "filling": "rocks, I think?",
         "goodWithIceCream": false,
         "madeBy": "a child, maybe?"
     },
     "super-chocolate": {
         "flavor": "german chocolate with chocolate shavings",
         "forABirthday": false,
         "madeBy": "the charming bakery up the street"
     }
}
```

If we run this through our decoder from earlier, we get an error! We'll need to
create a decoder for cakes (which I'm going to gloss but you can see them in
[the GitHub repo for this post](https://github.com/BrianHicks/elm-json-dynamic-keys).)
We'll just jump straight to the good bit: we need to handle either a cake or a
pie. That sounds like a job for a union type!

```elm
type BakedGood
    = PieValue Pie
    | CakeValue Cake


bakedGood : Decoder BakedGood
bakedGood =
    Decode.oneOf
        [ Decode.map PieValue pie
        , Decode.map CakeValue cake
        ]
```

`Decode.oneOf` here takes a number of decoders and returns the first one that
doesn't give an error (or returns an error overall.) We're also using
`Decode.map` to map from our type aliases `Pie` and `Cake` to their values in
the `BakedGood` union type. When we run this, we once again get a dictionary,
but this time of strings to `BakedGood`s.

```elm
Dict.fromList
    [ ( "cherry"
      , PieValue
            { filling = "cherries and love"
            , goodWithIceCream = True
            , madeBy = "my grandmother"
            }
      )
    , ( "odd"
      , PieValue
            { filling = "rocks, I think?"
            , goodWithIceCream = False
            , madeBy = "a child, maybe?"
            }
      )
    , ( "super-chocolate"
      , CakeValue
            { flavor = "german chocolate with chocolate shavings"
            , forABirthday = False
            , madeBy = "the charming bakery up the street"
            }
      )
    ]
```

## Done!

To summarize: if the values for your dynamic keys are always the same, you can
use `Decode.dict` to create a dictionary. If they vary in more creative ways,
use `oneOf` to figure out what you're dealing with and get it into a proper
value.

But, if you have the choice, design your JSON return values so that you don't
have to do these workarounds.

{{< elmSignup >}}
