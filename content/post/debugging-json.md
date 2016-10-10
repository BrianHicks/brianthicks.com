---
date: "2016-10-10T09:00:00-05:00"
title: "Debugging JSON"
tags: ["elm"]
featureimage: "/images/vw-beetle-by-scott-umstattd.jpeg"

---

A recurring theme in the Elm community (and this blog) is that JSON is kind of
difficult to get started with. This makes sense, since it's all about dealing
with data that other people provide for us. It's hard to debug what's happening
with JSON decoders since they're often used in HTTP response decoders. So today
we're going to talk about some general advice: how do you even debug JSON?

<!--more-->

## The Pattern

Peter Damoc
suggests
[one approach on the elm-discuss mailing list](https://groups.google.com/forum/#!searchin/elm-discuss/JSON%7Csort:relevance/elm-discuss/2ViXhO5R2b4/N6eQx3R-BAAJ).
His approach takes two steps:

1. Debug the decoder with fake (but valid) data.
2. Retrieve data from a live source

I think this makes a lot of sense, especially if we think about it as a problem
of decoupling! If you don't know how your server is going to act, it makes sense
to take care of the responses you can expect before you tune your requests. That
way, when you're working with HTTP you don't have to worry about unknown
responses.
#
## Our Goal

We're going to show this off by deserializing some data
from
[Typicode's JSON Placeholder API](https://groups.google.com/forum/#!searchin/elm-discuss/JSON%7Csort:relevance/elm-discuss/2ViXhO5R2b4/N6eQx3R-BAAJ).
We're going to decode part of a user (`/users/{id}`) into the following model:

```elm
type alias User =
    { id : Int
    , name : String
    , username : String
    , email : String
    }
```

## Fake Data

Let's get started with step 1: load some fake (but valid) data. I've retrieved
this by running `curl http://jsonplaceholder.typicode.com/users/1 | pbcopy` and
pasting the result into my Elm module:

```elm
fake : String
fake =
    """{
  "id": 1,
  "name": "Leanne Graham",
  "username": "Bret",
  "email": "Sincere@april.biz",
  "address": {
    "street": "Kulas Light",
    "suite": "Apt. 556",
    "city": "Gwenborough",
    "zipcode": "92998-3874",
    "geo": {
      "lat": "-37.3159",
      "lng": "81.1496"
    }
  },
  "phone": "1-770-736-8031 x56442",
  "website": "hildegard.org",
  "company": {
    "name": "Romaguera-Crona",
    "catchPhrase": "Multi-layered client-server neural-net",
    "bs": "harness real-time e-markets"
  }
}"""
```

Cool! So what's next? Well, we've got to write the JSON decoder and test it,
then get those messages into our application. We know that we'll soon want this
to go in something that takes an `Int` for the user ID and returns a `Cmd Msg`.
The function we'll need to write ends up looking something like this:

```elm
loadUser : Int -> Cmd Msg
loadUser _ =
    Decode.decodeString userDecoder fake
        |> Task.fromResult
        |> Task.perform LoadingFailed UserLoaded
```

`LoadingFailed` and `UserLoaded` handle a failed and a successful result,
respectively. We're
using
[Kris Jenkins' RemoteData pattern](http://blog.jenkster.com/2016/06/how-elm-slays-a-ui-antipattern.html) here
to make sure we handle our errors. This pattern helps make sure your application
never gets in an undefined state,
like
[Richard Feldman recommended in his elm-conf talk]({{< ref "two-talking-maybes-is-maybe-too-many.md" >}}).
[Check out the GitHub Project](https://github.com/brianhicks/elm-debugging-json)
or for more details how we're defining
these.
[There's also a live demo!](https://brianhicks.github.io/elm-debugging-json/)
But now we can define our JSON decoder!

```elm
userDecoder : Decode.Decoder User
userDecoder =
    Decode.object4
        User
        ("id" := Decode.int)
        ("name" := Decode.string)
        ("username" := Decode.string)
        ("mail" := Decode.string)
```

Unfortunately, it looks like I've got an error! Since we're displaying those, we
get it right away:

```
UnexpectedPayload: Expecting an object with a field named `mail` but instead got [snip]
```

We can look through our fake response to see what happened. We'll find that the
field is indeed "email", not "mail". Other errors will give you similar helpful
messages. As usual in Elm debugging, just follow the messages until your decoder
works!

## Real Data

Now that our decoder works (hooray!) we can just swap out our fake `loadUser`
function for a real one. Mine ended up looking like this:

```elm
loadUser : Int -> Cmd Msg
loadUser i =
    let
        url =
            "http://jsonplaceholder.typicode.com/users/" ++ (toString i)
    in
        Task.perform LoadingFailed UserLoaded (Http.get userDecoder url)
```

Since we've already made sure our JSON decoder works, we can now deal with
everything else in isolation. Making our HTTP request is now a matter of
communication, instead of both communication and deserialization.

## Done!

Now you know! To debug your JSON decoders, separate your deserialization layer
from your HTTP requests and you'll have a much easier (and quicker) time of it!

{{< elmSignup >}}
