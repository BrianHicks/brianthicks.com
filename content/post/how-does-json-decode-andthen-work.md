---
date: "2016-06-17T15:15:15-05:00"
title: "How does Json.Decode's andThen work?"
slug: "how-does-json-decode-andthen-work"
tags: ["elm"]

---

It's easy to get stuck decoding JSON. First of all you have to understand how to
write a Decoder, and then&hellip; well, then you get to `andThen`. The docs have
a terse explanation ("Helpful when one field will determine the shape of a bunch
of other fields.") and give the following example:

```elm
type Shape
    = Rectangle Float Float
    | Circle Float

shape : Decoder Shape
shape =
  ("tag" := string) `andThen` shapeInfo

shapeInfo : String -> Decoder Shape
shapeInfo tag =
  case tag of
    "rectangle" ->
        object2 Rectangle
          ("width" := float)
          ("height" := float)

    "circle" ->
        object1 Circle
          ("radius" := float)

    _ ->
        fail (tag ++ " is not a recognized tag for shapes")
```

This is *frustrating* the first time you look at it. What's important and
unimportant in the example? What shape of JSON do I even *pass in* here? But
there's hope! Once you know where to look, it's pretty simple. Let's break it
down.

<!--more-->

## The Shape Type

Walking through the example, the first thing we hit is the `Shape` type. This is
a tagged union type, meaning that a `Rectangle` and a `Circle` are both valid
`Shape`s we can process. So we can have values like these:

```elm
square : Shape
square = Rectangle 1 1

circle : Shape
circle = Circle 1
```

Note how both constructors give us a value of type `Shape`. 

(n.b. If this is new to you, the Elm documentation has a great
[introduction union types](http://guide.elm-lang.org/types/union_types.html). Go
read through that and the rest of this article will make more sense.)

## The Shape Decoder

Next we have a
[`decoder`](http://package.elm-lang.org/packages/elm-lang/core/4.0.0/Json-Decode#Decoder)
for the `Shape` type. Since `Shape` is a union type, we can infer that the
decoder should handle all the cases of the union. This is where we'll bring
[`andThen`](http://package.elm-lang.org/packages/elm-lang/core/4.0.0/Json-Decode#andThen)
in to shine. Let's take a look at that type definition first:

```elm
andThen : Decoder a -> (a -> Decoder b) -> Decoder b
```

So let's follow the type variables through the definition. So we have some type
`a` `a` (in our example, it's `String`.) We have a decoder that produces `a`
(that is, `String`.) We also have a function that takes `String` and produces a
decoder for `b` (here `Shape`). `andThen` will chain those two together to get a
full decoder. Here's that type definition with our concrete types filled in:

```elm
andThen : Decoder String -> (String -> Decoder Shape) -> Decoder Shape
```

And, wouldn't you know it, that second argument is the exact type we need here!
So we can use it in `andThen`. In the body of `shape`, we see that we're looking
for a string `"tag"`. That's our `Decoder String`, which gets passed as the
first argument to `andThen` along with `shapeInfo`. (The backtick syntax here
just means that we're using a prefix function as an infix operator. Think `map`
vs `+`.)

So now that we see how we're using `shapeInfo` (getting the tag from the JSON),
we're just a `case` away from handling our two constructors.

## Putting it All Together

So, armed with this knowledge, we can see how to can parse a JSON object using
this Decoder:

1. The string `{"tag": "circle", "radius": 1}` comes down the decoder chain.
2. The `"tag"` decoder pops out `"circle"`, which gets passed to `shapeInfo`
3. `shapeInfo` matches `"circle"` to produce the `Circle` decoder
4. Once decoded, we end up with `Circle 1`

But why do this dance at all? Why not have one `Decoder` for `Circle` and
another for `Rectangle`? Consider the following JSON:

```json
[
  {
    "tag": "circle",
    "radius": 1
  },
  {
    "tag": "rectangle",
    "width": 2,
    "height": 3
  }
]
```

But with `andThen`, mixed types in JSON become pretty easy to handle. It's just
`Decode.list circle` and you're done. Composable functions win big here!

{{<elmSignup>}}
