---
date: "2017-08-30T11:58:28-05:00"
title: "Breaking Out of Deeply Nested JSON Objects"
tags: ["elm"]
featureimage: "/images/breaking-out-of-deeply-nested-json-objects.png"
thumbnail: "/images/breaking-out-of-deeply-nested-json-objects-with-title.png"
section: "Technology"

---

A reader of [the JSON Survival Kit](/json-survival-kit/) wrote me with a question (lightly edited):

> I've got a JSON string that works fine in JavaScript:
> 
>
>     {
>       "Site1": {
>         "PC1": {
>           "ip": "x.x.x.x",
>           "version": "3"
>         },
>         "PC2": {
>           "ip": "x.x.x.x",
>           "version": "3"
>         }
>       },
>       "Site2": {
>         "PC1": {
>           "ip": "x.x.x.x",
>           "version": "3"
>         },
>         "PC2": {
>           "ip": "x.x.x.x",
>           "version": "3"
>         }
>       }
>     }
>
> I really can't figure out how to parse this&ndash;will your book help with nested JSON where the keys are different 2 or 3 levels deep?
>
> If not, then I'll just give up on Elm&ndash;as this is the first project that I'm trying to do, and something as basic as this, I'm finding impossible.

As [I've written about here before]({{< ref "composing-decoders-like-lego.md" >}}) (and in chapter 1 of *The JSON Survival Kit*), the big mindset shift you need to use `Json.Decode` successfully is to think of your decoders like bricks.
You can have one brick alone, and combine them to build whatever you like!

<!--more-->

## Fixing the Problems We Have Now

We can see three basic levels of this object: sites, then computers, then the details of those computers.
The innermost object is the easiest here, so we'll start there.
It's an object with two fields which don't change.
Let's call it `machine` and define a record to go with it:

```elm
import Json.Decode exposing (map2, string)


type alias Machine =
    { ip : String
    , version : String
    }


machine : Decoder Machine
machine =
    map2 Machine
        (field "ip" string)
        (field "version" string)
```

After that, we have a mapping of machine names to their metadata.
This is another easy place to get stuck!
When you get started in Elm, you tend to think of records as JavaScript objects.
Despite the similarities, you can't do this with Elm's records.
They're flexible, but don't combine key-value and structural semantics the way JavaScript objects do.

Elm *does*, however, have a first-class representation of key-value data structure: `Dict`.
Even better, `Json.Decode.dict` provides an easy way for us to map the keys of a JSON object into a `Dict`, if only we give it a decoder for the value:

```elm
import Dict exposing (Dict)
import Json.Decode exposing (dict)


machines : Decoder (Dict String Machine)
machines =
    dict machine
```

We'll do the same thing for the sites:

```elm
sites : Decoder (Dict String (Dict String Machine))
sites =
    dict machines
```

That's it!
We can also make this a little smaller by defining `sites` as `dict (dict machine)` and removing `machines`.

## Moving Beyond This JSON Object

To get this to work for your own problem, you first need to [change your mindset to think in small combined JSON blocks instead of a huge blob]({{< ref "composing-decoders-like-lego.md" >}}).
Seriously, this is the most important thing to do!
You can follow any other advice mechanically and not understand the result without getting this.

Before I did anything else, I formatted the JSON to get a feel for the structure.
I like to use [`jq`](https://stedolan.github.io/jq/) for this, but the tool itself doesn't matter as much as the formatting.
You want to be able to look at the *structure* of your JSON object, *not the keys themselves*.
This is because `Json.Decode` works with the structure of your data, not necessarily the values, and you'll need to think in terms of that structure to write a decoder.

After you get that structure start with the innermost object.
If the innermost object changes a lot, start with the one that changes the least.
Write the decoder for something smaller and you can compose around it instead of starting with an enormous blob.
Then put that little bit into the next largest object, and the next, and so on until you're done.

Sometimes the object that changes the least is the outermost object!
If that's the case, it may make sense to decode the inner values with `Json.Decode.value`.
It will encode `Value`, which you can't use directly.
But, it's a useful placeholder to verify that you're doing the right thing as you break down your structure.

{{< elmSignup >}}
