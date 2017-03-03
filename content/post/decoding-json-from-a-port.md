---
date: 2017-03-06T08:00:00-06:00
title: "How do I get JSON out of a port?"
tags: ["elm"]
featureimage: "/images/port-by-charlie-hang.png"
thumbnail: "/images/port-by-charlie-hang-with-title.png"
section: "Technology"
draft: true

---

Working with ports can be awkward.
You're really limited as to what values you can send through, so how do you get objects?
Easy: write a JSON Decoder!

<!--more-->

## Hello, {You}!

Let's build a simple application that greets everyone who comes across it.

Our model looks like this:

```elm
type alias Model =
    String
```

And our update function:

```elm
type Msg
    = UpdateName String
```

With those, we can define our port.
We're just going to create a port that takes strings.

But before we get there, if you need a refresher on ports [the Elm guide](https://guide.elm-lang.org/interop/javascript.html) has got you covered.
To summarize: ports are how JavaScript values get into your Elm program.
To use them, you create a `port`, which is a function that takes a function and returns a `Sub`, and add it to your app's subscriptions.

It looks like this:

```elm
port names : (String -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions _ =
    names UpdateName


main =
    program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
```

That function in the port definition (`(String -> msg)`) is how you tell your program how to map the values.
All updates go through our `Msg` type, so we need to tell it which tag in the union to use.

Put it all together and you get this:

{{< ellie project="xKtQjxdB7Da1/0" >}}

## Objects and JSON in Ports

That works for single values, but what about when we want to pass in JSON or JavaScript objects?
Do we just have to give up and go home?
No!
Ports can accept `Json.Decode.Value`s, let's use those!

First we'll need to decide on the format of our value.
You've probably already got this, but I'm going to say ours look like `{name: "you"}`.
Easy enough to model, we can even keep using a single string as our model!

```elm
import Json.Decode exposing (..)


decoder : Decoder String
decoder =
    field "name" string
```

Next we'll need to change our port and the function we're providing in `subscription` to use a `Value` instead.
We'll also change `UpdateName` to take a `Result String String` instead, since decoding may fail:

```elm
type Msg
    = UpdateName (Result String String)


port names : (Value -> msg) -> Sub msg


subscriptions : Model -> Sub msg
subscriptions _ =
    names (decodeValue decoder >> UpdateName)
```

And&hellip; that's pretty much all we need to do, other than to update our code to use the new `Result`.
When we put it all together, it looks like this:

{{< ellie project="xKtQjxdB7Da1/1" >}}

## Done!

To sum up, to decode JSON values coming in through ports, you need to:

1. Define a decoder (`decoder` in our case)
2. Change your subscription to use `decodeValue` (or do it in your model by letting your `Msg` accept a `Value`.)
3. Handle failures and successes from JSON Decoding as normal.

{{< elmSignup >}}
