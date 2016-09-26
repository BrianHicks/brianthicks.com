--
date: "2016-09-26T08:00:00-05:00"
title: "Two Talking Maybes is Maybe Too Many"
tags: ["elm"]
featureimage: "/images/crater-or-volcano-by-nasa.jpeg"

---

Richard Feldman spoke two weeks ago at the first elm-conf. (it went quite well,
thank you for asking!) He pointed out something as a code smell that's been
bothering me for a while. I want to emphasize it, so go ahead and watch the
recording and then we'll talk about it. It's only 25 minutes and well worth your
time:

<!--more-->

{{< youtube "IcgmSRJHu_8" >}}

Right, you're back?

The second example in his talk is a status bar. We're working with survey
questions here, and we want to be able to undo. The undo button lives up in the
status bar and lets us un-delete questions. Richard ends up with this starter
code:

```elm
type alias Model =
    { status : Maybe String
    , questionToRestore : Maybe SurveyQuestion
    }
```

But, he points out, this model has a problem! What if `questionToRestore` is
`Just thing` and `status` is `Nothing`? It doesn't make sense for our status bar
to have something to restore without a message.

Is this a problem with Elm? Hardly! It's a problem with our data model. And, as
Richard also points out in his talk:

{{< figure src="/images/richard-feldman-clearer-data-model.png"
           alt="Richard Feldman presenting at elm-conf. 'A clearer data model can lead to a clearer API' is displayed on a slide."
           caption="A clearer data model can lead to a clearer API" >}}

In other words, making sure the data model represents exactly (and only) the
states we can deal with is a great way to make our usage clearer. (In fact, this
removal of impossible states is his main point! You've watched the talk already,
right? Right?)

Anyway! Like all good speakers do, Richard solves the problem:

```elm
type Status
    = NoStatus
    | TextStatus String
    | DeletedStatus String SurveyQuestion
```

With the proper data modeling, the problem just goes away. Now we can't have a
mismatch between the two `Maybe` types because they don't exist! We can't have a
`DeletedStatus` without both text and a question, so the model can no longer be
in an invalid state. Changing the data model has eliminated the impossible
state.

## So what's the takeaway?

So how can we take this and apply it generally? There's so much in this talk,
but one big thing I'm taking away is that if we have two `Maybe` types that
interact there's something smelly going on. We've talked about this kind of
thing before when we were <a href="{{< ref
"duplicating-scientists-in-elm-stop-sharing-state.md" >}}">deduplicating
scientists</a>: any time you share state between two fields, you need to make it
difficult for those fields to get out of sync. In this case, I'd like to propose
this code smell in a new way:

> Two Talking `Maybe`s is Maybe Too Many

In other words, when you have two `Maybe`s interacting, find out how you can get
rid of that interaction as soon as you can. I'm going back and looking at my
code to figure out if there are any places where I can do exactly that; you
should too!

{{< elmSignup >}}
