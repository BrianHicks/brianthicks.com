---
date: "2016-07-05T10:00:00-05:00"
title: "Duplicate, Message, or Update? Contexts in Elm Components"
tags: ["elm"]

---

Imagine: you're implementing your Elm app. It's getting bigger all the time, and
you're happy that it's growing. Hooray! But now you need to make HTTP
requests&hellip; from a child component. What to do? You don't want to duplicate
the HTTP config as a field on the user everywhere, right? But likewise, you
don't want to forward actions to the parent *just* to make HTTP requests, right?
What's the way to solve this while sticking with the best architecture for your
app?

<!--more-->

## Three Options

We're going to assume that you need to scope all your requests with a user and
token. Something like this:

```elm
type alias Authentication =
    { user : String
    , token : String
    }
```

You already have this information stored on a field in your `Model`:

```elm
type alias Model =
    { auth : Authentication } -- plus the rest of your fields
```

But you'll eventually need to build child components that will need this config
too. You have three options here: duplication, child messaging, or value
passing.

You could stick `Authentication` into the child model everywhere you need it.
But this means you're going to have some issues because the data is duplicated
everywhere. And what if you need to change the values of `Authentication` after the
initial authentication? It doesn't scale well.

You could also [send messages from the children]({{< ref
"candy-and-allowances-parent-child-communication-in-elm.md" >}}) to the parent.
But sending messages to make effects to pass back to the children&hellip; that
has a nasty smell. First of all, you'll be moving the implementation of your
child out of the child. That means you're going to be doing
[shotgun surgery](https://en.wikipedia.org/wiki/Shotgun_surgery), which is best
avoided. More importantly: `Cmd`s are how we do external requests, not message
passing. Adding a layer of indirection will make the code harder to reason
about.

## The Solution: Just Use `update`

What if we made `Authentication` an argument to `update`? Something like this:

```elm
update : Authentication -> Msg -> Model -> (Model, Cmd Msg)
```

There's no duplication of data here! The update functions that need the context
will get the context. Changing authentication parameters is as simple as passing
the updated data from your parent. If *their* children need `Authentication`,
just pass it down to them.

There's also no mixing of `Msg` and `Cmd`. This will help out a great deal with
clarity of reasoning. When you issue your `Cmd`, the return value is a `Msg` in
the current component. No more, no less. Parent components only need to pass on
messsages that they would already.

In fact, this pattern can extend anywhere you need a little more context about
what you're doing. If you need [a list of siblings]({{< ref
"candy-and-allowances-part-two-child-child-communication-in-elm.md" >}}), for
example, you can pass it into `update`.

## Updated!

Now you know how to pass a contextual argument into an `update` function. More
relevant: you know *when* to do it. Next time you need to issue a `Cmd` with
context (like an HTTP request) you'll know what to do.

{{< elmSignup >}}
