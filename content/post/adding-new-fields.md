---
date: "2016-12-29T09:00:00-05:00"
title: "Adding New Fields to Your JSON Decoder"
tags: ["elm"]
featureimage: "/images/field-by-sven-owianowski.png"
thumbnail: "/images/field-by-sven-owianowski-with-title.png"

---

Adding and changing new fields in your JSON API is just a part of life.
We've got to have ways to deal with that!

In Elm, it's easy to add new fields with `optional` from `Json.Decode.Pipeline`.
Let's do it!

<!--more-->

## Why Keep Backwards Compatibility?

We *could* just add another field with `required`&hellip; why are we making the extra effort required to use `optional`?

Backend and frontend applications don't have to deploy at the same speed.
Especially when your backend uses a microservices-style architecture, deployment cadence can vary significantly.
Even if you deploy all the components in lockstep users will have your application cached if open in their browser, to the same effect.

By making new fields optional (and just dropping old ones) we allow for the differences in rollout.
It also makes rollbacks easier!

## Our Data, As It Stands

We're going to revisit [Count Duckula]({{<ref "debugging-json.md" >}}) (quack) for this.
As a reminder, we're starting with this JSON:

```json
{
  "id": 1,
  "name": "Count Duckula",
  "username": "feathersandfangs",
  "email": "quack@countduckula.com"
}
```

And our model and decoder look like this:

```elm
type alias User =
    { id : Int
    , name : String
    , username : String
    , email : String
    }


user : Decoder User
user =
    decode User
        |> required "id" int
        |> required "name" string
        |> required "username" string
        |> required "email" string
```

## Adding a Field

When you add or remove a field from your JSON record you can get clever with `oneOf` tricks, but it's better to use `optional` from `Json.Decode.Pipeline`.
`optional` works like `required` but takes a default value to use if the field isn't present.
Let's say we want to add "age" to our JSON:

```json
{
  "id": 1,
  "name": "Count Duckula",
  "username": "feathersandfangs",
  "email": "quack@countduckula.com",
  "age": 881
}
```

We don't want our decoder to fail if "age" is missing, so instead we'll make it optional:

```elm
import Json.Decode.Pipeline exposing (optional)


type alias User =
    { id : Int
    , name : String
    , username : String
    , email : String
    , age : Maybe Int
    }
    
    
user : Decoder User
user =
    decode User
        |> required "id" int
        |> required "name" string
        |> required "username" string
        |> required "email" string
        |> optional "age" (map Just int) Nothing
```

That last line is what we're after here, it says "wrap an `Int` in `Just` if you can, otherwise give me `Nothing`".

This sounds an awful lot like the `maybe` decoder!
If you've used that before, you might reach for it.
Don't!
Here's why: anything that fails in `maybe` returns `Nothing`.
If I had `maybe <| field "age" int` it would do the same thing as `optional`, *but only when the field was missing*.

If the data changed types unexpectedly, for example if we get a float instead, `maybe` would happily swallow that error too.
We'd have missing data when we were sent a perfectly reasonable age, from the sender's perspective.
`optional` avoids this; it will fail in ways that don't swallow the error messages.

{{< elmJsonSignup >}}
