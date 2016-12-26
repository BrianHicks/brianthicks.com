---
date: "2016-12-26T09:00:00-06:00"
title: "Banish Type Tedium with JSON to Elm"
tags: ["elm"]
featureimage: "/images/boiler-by-jaime-spaniol.png"
thumbnail: "/images/boiler-by-jaime-spaniol-with-title.png"
section: "Technology"

---

When you're writing JSON decoders, it's helpful to understand what's going on.
When you're up in the clouds with your JSON workflow doing all sorts of fancy and advanced stuff, it's great!

But what about when you don't need all the fancy stuff?
(Or you're just getting started?)
Meh.

It's a hassle to write decoders, objects, and encoders for every single field by hand.
It feels like tedious boilerplate.
Pass.

But really, you don't have to do it all by hand.
Please meet JSON to Elm.

<!--more-->

![A Screenshot of the JSON to Elm Interface](/images/jsonToElm.png)

[JSON to Elm](http://json2elm.com) from Noah Hall of NoRedInk can generate a base decoder from a sample JSON object.

Once you have your decoder, you can paste it into your project and then customize.
It's a great jump start to getting your object decoders off the ground.

That said, when you're using JSON to Elm you'll need to be aware of a few things:

First, as of the time of this post JSON to Elm generates 0.17 compatible code.
In particular, it uses `(:=)` instead of `field`.
There's a switch at the top which lets you turn on `Json.Decode.Pipeline` generation.
You [nearly always want this anyway]({{< ref "decoding-large-json-objects.md" >}}), so go ahead and flip it on to avoid the 0.17-and-prior API.

The program also only takes a single JSON value.
This means that it doesn't know what the proper value of `null` fields is.
In these cases, it will provide a placeholder value that you need to fill in.

Last, JSON to Elm also doesn't introspect values inside values, particularly strings.
That means that if you want to parse dates or the Gravatar ID we made above, you'll have to substitute in the proper parser yourself.

Please note that these things are not failings of JSON to Elm.
Modeling data in JSON is hard, and we have a very limited set of values to encode into.
That said, JSON to Elm is a super useful tool and can speed up your development workflow significantly.
Give it a try!

{{< elmJsonSignup >}}
