---
date: "2016-10-31T00:00:00-05:00"
title: "JSON Schema Changes: A Halloween Horror Story"
tags: ["elm"]
featureimage: "/images/spooky-railroad-by-andrea-boldizsar.jpg"
thumbnail: "/images/spooky-railroad-by-andrea-boldizsar-with-title.png"
section: "Technology"

---

You're hacking along on your JSON decoder. Life is rosy, the birds are singing,
the sun is shining, but then&hellip; you get an email: JSON Schema change.

(lightning cracks, a vampire cackles in the distance)

So how do you deal with that? You're not just gonna give up, but your data model
is already pretty set. Are you going to have to change everything?

<!--more-->

## Our JSON

Let's take our JSON User from when we talked
about [debugging JSON]({{<ref "debugging-json.md" >}}) and extend it. As a
reminder, here's the JSON we have:

```json
{
  "id": 1,
  "name": "Count Duckula",
  "username": "feathersandfangs",
  "email": "quack@countduckula.com"
}
```

And here's the record we want to decode to:

```elm
type alias User =
    { id : Int
    , name : String
    , username : String
    , email : String
    }
```

Last time we came up with a pretty simple decoder for this structure.

```elm
userDecoder : Decode.Decoder User
userDecoder =
    Decode.object4
        User
        ("id" := Decode.int)
        ("name" := Decode.string)
        ("username" := Decode.string)
        ("email" := Decode.string)
```

There's a secret to dealing with any schema change. Remember that your JSON
Decoder is the gateway from the input you get to the data structure you want.
These two things don't have to match exactly! Let's look at some common
scenarios:

## Shape Shifting Data? Get 'em All With `oneOf`

What if your data is a shapeshifter? It can change&hellip; into a list!
(lightning cracks again)

This one is pretty easy. Anywhere you were using `Decode.decodeString
userDecoder input`, you just wrap in a
list. [Composing JSON]({{< ref "composing-decoders-like-lego.md" >}}) for the
win! But what if you still might be getting a single user? `Decode.oneOf` and
`Decode.map `to the rescue!

```elm
userDecoderList : Decode.Decoder (List User)
userDecoderList =
    Decode.oneOf
        [ userDecoder |> Decode.map (\user -> [ user ]) 
        , Decode.list userDecoder
        ]
```

Let's step through this. The decoder will first try and decode a single user. If
that's successful, the function will be called to wrap the data in a list.
(Briefly: `Decode.map` takes a function from one type to another and uses it to
transform a successful decode.)

If the single user case fails, the decoder will try and decode a list of users.
We don't need to transform this with a `Decode.map` because this decoder returns
`List User` in the first place.

The point here: you can use `Decode.oneOf` to handle any cases to ensure
backwards (and forwards) compatibility with your input JSON.

## Spooky Paths in the Woods? Find your way with `at`

Are you haunted by namespaces? What do you do when someone decides to move your
fields into a sub-structure? Let's see what happens if someone were to move
`username` and `email` into `login`:

```json
{
  "id": 1,
  "name": "Count Duckula",
  "login": {
      "username": "feathersandfangs",
      "email": "quack@countduckula.com"
  }
}
```

Our answer to this is `Decode.at`. Here's how to use it:

```elm
userDecoder : Decode.Decoder User
userDecoder =
    Decode.object4
        User
        ("id" := Decode.int)
        ("name" := Decode.string)
        (Decode.at ["login", "username"] Decode.string)
        (Decode.at ["login", "email"] Decode.string)
```

`at` takes a list of strings (you can think of it as a path to your value) and a
decoder. In other words, where `(:=)` gets a single path, `at` can get any
number you like. In fact, `"x" := Decode.string` does the same thing as `at
["x"] Decode.string`.

## Creepy Twins? Join Those Fields With a Sub Decoder

But what if someone changes the shape of the user? Say, moving `name` into
`first_name` and `last_name`?

```elm
userDecoder : Decode.Decoder User
userDecoder =
    let
        name =
            Decode.object2
                (\first last -> first ++ " " ++ last)
                ("first_name" := Decode.string)
                ("last_name" := Decode.string)
    in
        Decode.object4
            User
            ("id" := Decode.int)
            name
            ("username" := Decode.string)
            ("email" := Decode.string)
```

Normally
[we would prefer the pipeline style]({{< ref "decoding-large-json-objects.md" >}}) but
here `objectN` makes a lot of sense! When you want to combine a few fields,
write the function that combines the values (or use one from the standard
libarary) and then provide your decoders. You can even use `at`, as above!

(Side note: if your software models names like
this,
[have second thoughts about that](https://www.kalzumeus.com/2010/06/17/falsehoods-programmers-believe-about-names/))

## Happy Halloween!

To sum up:

- Use `oneOf` when you're not sure what shape your data will take
- Use `at` to get a field at an abritrary path
- Transform the data you have into the data you want with `map`

Use these to slay the monsters in your JSON!

{{< elmSignup >}}
