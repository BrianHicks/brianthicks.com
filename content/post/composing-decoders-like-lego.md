---
date: "2016-10-17T09:00:00-05:00"
title: "Composing Decoders like LEGO"
tags: ["elm"]
featureimage: "/images/lego-world-2013-by-brickset.jpg"

---

First-time Elm users have a hard time learning how to compose decoders.
People tend to get stuck on what they all mean, but it's not too hard: just think of them like LEGO.

<!--more-->

## LEGO

LEGO bricks operate on a simple principle: there are holes in the bottoms that match the studs on top.
Click the two together and you can build things.
This interface is important!
It's been [standard since 1958](http://www.bricklink.com/browseList.asp?q=&itemType=S&catID=&itemYear=1958).
It also means that [you can connect LEGO with Duplos](http://thebrickblogger.com/2010/12/lego-duplo/).
This standard interface means that you can snap together more or less every Lego brick ever sold.
Pretty impressive!

{{< figure src="/images/lego-world-2013-by-brickset.jpg"
           caption="LEGO workers load some JSON decoders onto a plane."
           attr="LEGO World 2013 by Brickset"
           attrlink="https://www.flickr.com/photos/brickset/8488933168" >}}

Elm's decoders are like that. 
It sounds like a ridiculous claim to make, but they are.
A decoder exposes a standard interface that can snap together in any way you can think up.
The docs say it best:

> Represents a way of decoding JSON values.
> If you have a `(Decoder (List String))` it will attempt to take some JSON value and turn it into a list of strings.
> These decoders are easy to put together so you can create more and more complex decoders.

Let's examine that claim.

## Decoding a List of Integers

Say we have a single integer.
Not the most complex data type in the world, but we still need to parse it.
Elm provides us a `int` decoder to begin with, so we can do the following:

```elm
Decode.decodeString Decode.int "1" == Ok 1
```

`Decode.decodeString` just takes a decoder and a string to get back a `Result`.
In this case, it's a string.
This is trivial, as it should be.
But, like LEGO we can snap them together:

```elm
Decode.decodeString (Decode.list Decode.int) "[1]" == Ok [1]
```

`Decode.list` takes another `Decode.Decoder` and returns something that will decode a list of those values.
In other words, we can snap any decoder we can think of into a list.
The same thing happens for `Decode.dict`, `Decode.object1..9`, and every other decoder.

Click&hellip; click&hellip; click&hellip; they snap together!

## Decoding a List of Users

Let's move on to a more complex example.
How about a user with an email and ID?

```elm
type alias User =
    { id : Int
    , email : String
    }
```

Let's set up a JSON decoder using `object2`.

```elm
user : Decoder User
user =
    Decode.object2
        User
        ("id" := Decode.int)
        ("email" := Decode.string)
```

Now we're using a bunch of decoders!

First `object2` takes a function that takes two arguments and applies the given decoders in order.
These decoders can, of course, be for any value.
Snap&hellip; click&hellip; 
(For more on how this works: [Decoding Large JSON objects: A Summary]({{< ref "decoding-large-json-objects.md" >}}))

Next, the `(:=)` decoder takes a path and a decoder, and applies that decoder to the field.
So above, we're saying "take the `int` decoder, and apply it to the value found at the `"id"` path."
But, as usual, we can apply any decoder here.
More clicking, getting closer&hellip;

So now we can take this `user` decoder and apply it to some string:

```elm
Decode.decodeString user "{\"id\":1,\"email\":\"test@example.com\"}"
```

We end up with `Ok { id = 1, email = "test@example.com" }`.
Our LEGO castle is complete!
But what if we need a list of users?
We can snap the `user` decoder into a `Decode.list` and we're done!

```elm
Decode.decodeString (Decode.list user) "[{\"id\":1,\"email\":\"test@example.com\"}]"
```

By the way, a pro tip: you should't use `object1..9` in your real code.
[Use `elm-decode-pipeline` instead]({{< ref "decoding-large-json-objects.md" >}}).
It lets you get rid of `(:=)`, which is one of the more confusing decoders.

## Composed!

So now you know!
Composing JSON Decoders in Elm is like building with LEGO: snap together bricks to make something bigger.
This style of function composition shows up in more places in the Elm core, but JSON Decoding shows it off well.

{{< elmSignup >}}
