---
date: "2016-08-22T09:37:36-05:00"
title: "Decoding Large JSON Objects: A Summary"
tags: ["elm"]
featureimage: "/images/tractor-by-xavi-moll.jpeg"

---

There have been several recent questions on the elm-discuss mailing list about decoding large JSON objects.
The problem: Elm's decoders provide for decoding objects with up to 8 fields, but what happens when you need more?
The solution here is, unfortunately, not super obvious.

<!--more-->

## The Problem

Let's flesh out the problem a little bit more.
Say we're working with [Users from the GitHub API](https://developer.github.com/v3/users/).
We have a *bunch* of fields here:

```json
{
  "login": "octocat",
  "id": 1,
  "avatar_url": "https://github.com/images/error/octocat_happy.gif",
  "gravatar_id": "",
  "url": "https://api.github.com/users/octocat",
  "html_url": "https://github.com/octocat",
  "followers_url": "https://api.github.com/users/octocat/followers",
  "following_url": "https://api.github.com/users/octocat/following{/other_user}",
  "gists_url": "https://api.github.com/users/octocat/gists{/gist_id}",
  "starred_url": "https://api.github.com/users/octocat/starred{/owner}{/repo}",
  "subscriptions_url": "https://api.github.com/users/octocat/subscriptions",
  "organizations_url": "https://api.github.com/users/octocat/orgs",
  "repos_url": "https://api.github.com/users/octocat/repos",
  "events_url": "https://api.github.com/users/octocat/events{/privacy}",
  "received_events_url": "https://api.github.com/users/octocat/received_events",
  "type": "User",
  "site_admin": false,
  "name": "monalisa octocat",
  "company": "GitHub",
  "blog": "https://github.com/blog",
  "location": "San Francisco",
  "email": "octocat@github.com",
  "hireable": false,
  "bio": "There once was...",
  "public_repos": 2,
  "public_gists": 1,
  "followers": 20,
  "following": 0,
  "created_at": "2008-01-14T04:33:35Z",
  "updated_at": "2008-01-14T04:33:35Z"
}
```

If this object had fewer fields, we could use like this:

```elm
import Json.Decode as Decode

type alias User =
    { login : String
    , id : Int,
    , name : String
    }

user : Decode.Decoder User
user =
    Decoder.object3 User
        ("login" := Decode.string)
        ("id" := Decode.int)
        ("name" := Decode.string)
```

But since this record has 30 fields, what do we do?
We only have `object*` up to [`object8`](http://package.elm-lang.org/packages/elm-lang/core/4.0.5/Json-Decode#object8).
Even if we did have `object30` would we want to use that `:=` syntax to keep everything in order?

## Three Solutions

There are a couple of solutions to this.
We'll go over them in order of how easy the solutions are.
These examples are going to use only a couple fields of the object to aid readability.
This leads to our first suggestion:

### Use Fewer Fields

The object above is *really* comprehensive.
I've implemented several apps against GitHub's API and have never had to use more than a handful of the fields returned by any of their responses.
Elm's decoders don't need to decode every field in the object.
They don't even need to decode them in the order *from the JSON*.
(See in the example above how "name" is the third field in our record, but the 18th in the JSON.)
This will also cut your API surface area and make your code easier to maintain.

{{< figure src="/images/tractor-by-xavi-moll.jpeg"
           caption="This tractor worked too many fields, and just look what happened."
           attr="Photo by Xavi Moll"
           attrlink="https://twitter.com/xmollv" >}}

So try hard to use only what you need.
But if you find yourself stuck needing an object with more than 8 fields:

### `Json.Decode.Extra` from `elm-community/json-extra`

We have to make a pitstop here to look at incremental decoding.
When you define a record, you also get a record constructor for free!
It will have the the same thing as the type, so in our `User` example above: `User : String -> Int -> String -> User`.

Remember [our discussion on currying]({{< ref "welding-functional-pipes.md" >}}#currying)?
We know from there that if we call `User` with just a `String`, we'll have `Int -> String -> User` left over.
We can use that to our advantage to make a pipeline using `apply` from `Json.Decode.Extra`!
In this example, we'll use `(|:)`, which is the infix version of `apply`.

```elm
import Json.Decode as Decode exposing ((:=))
import Json.Decode.Extra exposing ((|:))

user : Decode.Decoder User
user =
    Decode.succeed User
        |: ("login" := Decode.string)
        |: ("id" := Decode.int)
        |: ("name" := Decode.string)
```

If you want to dive deeper into how this works, the [documentation for `(|:)`](http://package.elm-lang.org/packages/elm-community/json-extra/1.0.0/Json-Decode-Extra#|:) has a great explanation.
But we're not quite done here yet.

We're now importing two custom infix operators.
But that's two more than I'd like.
They're not self-documenting, so they make your app harder to maintain.
We also have a mysterious call to `Decode.succeed` in the top of the function.
`succeed` is just turning our record constructor into a JSON decoder, but that's not super obvious.
All this means one more step!

### `Json.Decode.Pipeline`

[NoRedInk's elm-style-guide](https://github.com/NoRedInk/elm-style-guide#always-use-jsondecodepipeline-instead-of-objectn) recommends using their [`Json.Decode.Pipeline`](http://package.elm-lang.org/packages/NoRedInk/elm-decode-pipeline/2.0.0/).
It's a good recommendation, since it will clean up our code that last little bit.
So how do we use it?

When we think of transforming values, `|>` comes to mind.
It's a built-in operator function, so there are no extra imports to worry about.
If you're not familiar with `|>`, you can think of it [like a pipe that values can flow through]({{< ref "values-pipes-and-arrows.md" >}}).
Let's use this with `Json.Decode.Pipeline` to improve our decoder:

```elm
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (required, decode)

user : Decode.Decoder User
user =
    decode User
        |> required "login" Decode.string
        |> required "id" Decode.int
        |> required "name" Decode.string
```

This is much clearer, at least to my eye.
I can see at first glance that:

- We have three fields
- All of them are required (which is implicit in the other versions)
- And what type they are.

Using this approach lets you have [optional fields](http://package.elm-lang.org/packages/NoRedInk/elm-decode-pipeline/1.0.0/Json-Decode-Pipeline#optional) as well.

## Summarized!

There you have it!
Three ways to decode JSON objects with more than 8 fields.
To summarize our summary, you can:

1. Use only the fields that you need.
   This means your problem can just go away with a mindset change.
2. Use `apply` or `(|:)` from `Json.Decode.Extra` for a quick fix.
3. Use `Json.Decode.Pipeline` to make a readable decoding pipeline to make future maintenance easier.

{{< elmSignup >}}

---

Edit August 23, 2016: Corrected the type signatures of the `User` constructor.
It didn't have `User` as the return value.
Thanks to Martin Janiczek for the catch!
