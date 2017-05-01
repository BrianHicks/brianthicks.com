---
date: "2017-05-02T09:00:00-06:00"
title: "Sending Dates Through Elm Ports"
featureimage: ""
thumbnail: ""
section: "Technology"
tags: ["elm"]
draft: true

---

So you're sending dates through ports in your Elm application, and things are getting pretty confusing.
You send in a date, and you get&hellip;

```elm
Err "Expecting a String a _.date but instead got \"2017-05-01T12:45:00.000Z\""
```

Wait, what?
Isn't that a string already?
What's going wrong here?

<!--more-->

## How Not To Do It

Let's examine this with a simple model and decoder.

```elm
import Date exposing (Date)
import Json.Decode exposing (Decoder, Value, map, decodeValue)
import Json.Decode.Extra exposing (date)


type alias Model =
    Result String Date
    
    
decoder : Decoder Date
decoder =
    date
```

We'll set everything else up like we did [last time]({{< ref "decoding-json-from-a-port.md" >}}):

```elm
type Msg
    = UpdateModel (Result String Date)
    
    
port dates : (Value -> msg) -> Sub msg


subscriptions : Model -> Sub msg
subscriptions _ =
    names (decodeValue decoder >> UpdateModel)
```

Everything else just updates the model with whatever value we get, and display the raw value we're getting back.
Here we go!

{{< ellie project="34XcD5HD9Bza1/0" >}}

And&hellip; an error.
What are we doing wrong?
The code type checks.
Ought it not just run?

## The Right Way

So, what's going on here?
In short, check out how we're sending our date over:

```javascript
app.ports.dates.send(new Date);
```

We're just giving a date to Elm, which we get as a `Value`.
`Value`s are handy, but they're basically implemented as wrappers around plain ol' JavaScript objects.
That means that this is a valid value for `Value`, but not one that we can handle.
Whoops!

The solution: use a value we *can* handle.
Let's serialize the date instead of passing it raw.
We can do that with the handy `toISOString()` method, which formats the date in [ISO8601](https://en.wikipedia.org/wiki/ISO_8601)/[RFC3339](https://tools.ietf.org/html/rfc3339) format.

```javascript
var date = new Date();
app.ports.dates.send(date.toISOString());
```

Tada!

{{< ellie project="34XcD5HD9Bza1/1" >}}

Now the date successfully deserializes and we can use it in our program.

## And Done!

Whenever you're working with ports, be sure to send only values that can be decoded by the JSON Decoder.
This rarely limits you as much as you think it will (dates being probably the biggest frustration.)
If it helps, you can serialize your object as a JSON string before sending it down the pipe.
But in common cases, you should be able to find a `toString`-style method to call on your JavaScript object.
When you're dealing with dates, that's `toISOString`.

No go forth and Elmify!

{{< elmSignup >}}
