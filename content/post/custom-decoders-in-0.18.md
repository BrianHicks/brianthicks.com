---
title: "Create Custom JSON Decoders in Elm 0.18"
date: "2017-01-13T09:00:00-05:00"
tags: ["elm", "json"]
slug: "create-custom-json-decoders-in-elm-018"
featureimage: "/images/typewriter-by-sergey-zolkin.png"
thumbnail: "/images/typewriter-by-sergey-zolkin-with-title.png"

---

You've modeled your data exactly how it should be, and everything's working fine.
Now it's time to finish your JSON Decoder, but certain fields are strings where in your Elm code they're complex data types!
This happens most often with dates, but tagged unions have this problem too.

In 0.17 we had `customDecoder`, which could turn any `Result String a` into a `Decoder a`, but it went away in 0.18.
So… what do we do?

<!--more-->

## Rolling Our Own Custom Decoder

What we need to do, essentially, is create a function that converts some input data to a `Decoder a`.
Let's use date decoding as an example.
JSON doesn't have a way to express dates, so we have to encode dates in strings.

For example, today's date would be:

```json
"2017-01-13T09:00:00-05:00"
```

That's [ISO860](https://en.wikipedia.org/wiki/ISO_8601) format, designed to be unambiguous.
But we have to put it in a string.
Good thing we have `Date.fromString`, and can convert from this string to this result:

```elm
Date.fromString "2017-01-13T09:00:00-05:00"
-- Ok <Wed Jan 11 2017 09:00:00 GMT-0500 (EST)>
```

But that's not exactly a JSON Decoder, is it?
For that, we'll need to lift it into Decoder land by using `andThen`, `succeed`, and `fail`:

```elm
import Date exposing (Date)
import Json.Decode exposing (Decoder, string, andThen, succeed, fail)


date : Decoder Date
date =
    let
        convert : String -> Decoder Date
        convert raw =
            case Date.fromString raw of
                Ok date ->
                    succeed date

                Err error ->
                    fail error
    in
        string |> andThen convert
```

`succeed` returns a decoder that always succeeds with the given value, and `fail` returns a decoder that always fails with the given error.
We can map from `Result String a` to `Decoder a` that way.
Once you have this, you can use the `date` decoder just like any other decoder!

## In Real Life: Use `fromResult` from `Json.Decode.Extra`

Of course, this is a lot of code to write for something fairly minor.
Going the long way around lets you customize to your heart's content, but if you only need to map from `Result String a` to `Decoder a` there's a simpler option.

`Json.Decode.Extra` exposes a function `fromResult` that does this mapping for you.
The decoder above could be rewritten like this:

```elm
import Json.Decode.Extra exposing (fromResult)


date : Decoder Date
date =
    string |> andThen (Date.fromString >> fromResult)
```

So if all you need is to map a result, use `fromResult`.

And finally, a caveat: if you *actually* need to parse a date, `Json.Decode.Extra` also has a `date` decoder.
No need to reinvent the wheel.

## Wrapping Up

Now you know:

- If you need to convert from any data type to a decoder, use `andThen`, `succeed`, and `fail`.
- If you need to convert a `Result String a`, use `fromResult` from `Json.Decode.Extra`
- If you need a date, use `date` from `Json.Decode.Extra`

{{< elmSignup >}}
