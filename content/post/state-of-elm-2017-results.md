---
title: State of Elm 2017 Results
date: "2017-07-13T09:00:00-05:00"

---

The State of Elm 2017 results are here!
I first presented these as two talks, one to Elm Europe and one to the Oslo Elm Day.
I've embedded the Elm Europe talk below (it's shorter) but the [longer version](https://www.youtube.com/watch?v=NKl0dtSe8rs&feature=youtu.be) is on also YouTube.

{{< youtube BAtql6ZbvpU >}}

## So&hellip; What's This Survey For Anyway?

The State of Elm survey is an indicator of where the Elm community is at any given time.
Where is Elm being used in production?
What are people's experiences coming to Elm, and how quickly are they leveling up?

Last year, the survey was skewed towards finding out if an Elm conference would be feasible.
Fast forward a year, and we've already had 3!
The community can take this data and make itself better.

By the way, [here are last year's results]({{< ref "post/state-of-elm-2016-results.md" >}}).

## This Year's Questions

This year, we asked these questions:

1. In which domain(s) are you applying Elm?
1. How long have you been using Elm?
1. How serious is your use of Elm?
1. What is your level of experience with functional programming?
1. What versions of Elm are you using?
1. What language are you "coming from"?
1. Where do you go for Elm news and discussion?
1. Do you format your code with `elm-format`?
1. What do you like the most about your use of Elm?
1. What has been the biggest pain point in your use of Elm?

There were actually 5 more questions, but they turned out to not be useful signals so I've excluded them in this analysis:

- In what industry are you using Elm? (got vague data due to vague question wording)
- What is your level of influence within your team? (nearly everyone answered 10)
- Did you attend elm-conf US? (no bearing on other questions)
- Do you plan to attend Elm Europe? (no bearing on other questions)
- Any Other Comments? (mostly additional answers to other questions, which I incorporated into those questions)

## The Responses!

This year, we had 1,170 responses!
That's almost double last year (614).
Hopefully we keep growing like this!

### In Which Domain(s) Are You Applying Elm?

![In Which Domain(s) Are You Applying Elm?](/images/state-of-elm-2017/domain.png)

These answers were relatively the same year over year, so we can compare them.
This is not true of all the slides, but it is of this one.
To read these, you kind of have to double the 2016 count to get a proportional representation.

That said, both last year and this year the top response was Web Development, which is ~~totally expected~~ amazing!
And more people were using Elm for creating games last year than this year.

But other than that, we don't have a lot of parity between the two years.
This may be down to question design, and we'll make sure to keep this constant next year to see if we get a similar shift with no question change.

### How Long Have You Been Using Elm?

![How Long Have You Been Using Elm?](/images/state-of-elm-2017/usage.png)

This year we separated "curious/learning" and "just started".
This was meant to be "what is Elm" and "OK, I've installed the editor plugins and started a project, what's next?"
But, when you combine these, they exceed the amount of answers for the next category ("under a year", the highest.)
There are a lot of people coming into the community!

Then after those, we have a strict time scale of under a year to over four years.

Each successive year on this you see proportionally about the same number of people using Elm who were using it the year prior.
This is an encouraging sign!
It means people are sticking with Elm, hopefully getting value out of it, and remaining happy.

### How Serious is Your Use of Elm?

![How Serious is Your Use of Elm?](/images/state-of-elm-2017/how-serious.png)

The scale here is modified from last year, so I've chosen not to generate a year-over-year comparison for this question.
Last year didn't have enough nuance; it measured project kickoff to production, but didn't have things like side projects in production, or only in internal use.
This year, we added more responses to capture those!

This one surprised me.
I half expected to see some kind of curve, with all the people *not* using Elm outweighing those who *were* using Elm, but that's not the case!
Instead we see production levels all over this chart.
It's pretty well distributed!

### What is Your Level of Experience With Functional Programming?

![What is Your Level of Experience With Functional Programming?](/images/state-of-elm-2017/experience.png)

This is a pretty clear bell curve, with people preferring 7 most often.
It makes sense!

Almost nobody thinks they know *everything there is to know* about functional programming.

Conversely, if you don't know very much, you're more likely to answer 0 than 1.
In other words, "I know nothing" versus "I know only a little".

Interestingly, almost everyone who said they have background in Haskell answered 7 on this question.
You do you, humble Haskellers.

### What Versions of Elm Are You Using?

![What Versions of Elm Are You Using?](/images/state-of-elm-2017/versions.png)

Last year the survey closed *just* before 0.17 was released, so 0.16 was the latest version.

The number of people on the latest version hasn't changed much, proportionally (about 4%.)

The upgrade from Elm 0.17 to 0.18 is taking place slightly slower than that from Elm 0.16 to 0.17.
This is weird to me!
The 0.17 to 0.18 upgrade (some syntax and minor API changes) was much smaller in scope than 0.16 to 0.17 (removing `Signal` and `Effects`, with more syntax changes.)
You'd think people would move to 0.18 faster than they moved to 0.17!

On the other hand, the 0.17 to 0.18 has a weird reputation for being difficult, but it's really not!
You can use [`elm-upgrade`](https://github.com/avh4/elm-upgrade) to do most of the dirty work, then apply the rest of the API changes by hand.
There *are* legitimate reasons for not upgrading, but if you're not blocked by any of the changes then give one of those tools a shot!
You'll probably come away impressed, upgraded, and ready for future versions and fixes.

### What Language Are You "Coming From"?

![What Language Are You "Coming From"?](/images/state-of-elm-2017/languages.png)

Hey, everybody knows JavaScript!
How about that!

Aside from JavaScript programmers being a rather large majority, the top 5 are Ruby, Python, Haskell and Java.

No functional language beside Haskell cracked the top 5.
I'm both nonplussed and surprised by this.
I had expected FP background to be spread out more.

It is notable that the top 3 languages all use dynamic typing systems.
We'll see later that Elm's static type system is a big draw for some people.

### Where Do You Go For Elm News And Discussion?

![Where Do You Go For Elm News And Discussion?](/images/state-of-elm-2017/wateringHoles.png)

Almost everybody uses the [Elm Slack](http://elmlang.herokuapp.com/) and the [Elm Subreddit](https://www.reddit.com/r/elm).
This correlates with how long people have been using Elm: new users tend to be on the subreddit, while more experienced users are on Slack.
This is not a complete disconnect, but an opportunity for growth: if more experienced users would answer questions on Reddit, it would make a more welcoming environment for newbies.

And, if you *are* a newbie: get on Slack. You'll find help much more quickly.
Part of that is because it's a chat instead of a message board, but there are also more people there.

Also notable: the [Elm Town podcast](https://elmtown.github.io/) had, at that point, had only a few episodes.
Despite that, it came in just under [elm-discuss](https://groups.google.com/forum/#!forum/elm-discuss).
Good job, Murphy, and keep it up!

### Do You Format Your Code With `elm-format`?

![Do You Format Your Code With elm-format?](/images/state-of-elm-2017/elm-format.png)

91% of people who have tried [`elm-format`](https://github.com/avh4/elm-format) prefer to use it.
It's enormously popular in the Elm community.

If you haven't, give it a try!

### What Do You Like The Most About Your Use of Elm?

![What Do You Like The Most About Your Use of Elm?](/images/state-of-elm-2017/likes.png)

These are mostly things you'd expect that people would like about Elm: the type system, great error messages, the fact that it's a pure functional language, et cetera.

There was one correlation that I want to point out!
Those people who answered that they were using Elm in production in any way were much more likely to say that they enjoyed the refactoring experience.
Those who weren't, didn't.
The difference is pretty stark!
It's one of those things that you're surprised by initially, then kind of go "well, yeah, that makes sense."

### What Has Been the Biggest Pain Point in Your Use of Elm?

![What Has Been the Biggest Pain Point in Your Use of Elm?](/images/state-of-elm-2017/pains.png)

The top pain people have with Elm is with the learning curve.
The is actually comprised of several pains; the top pain is the sum of all mentions of learning curve but they're also tagged with what the specific pain was (for example, "Learning Curve (FP)".)

Some specific detail about pains:

- **JSON Decoders**: This is one of those things that you probably have had trouble with. I certainly did. [So I wrote a book about them.](/json-survival-kit) They're really not that bad once you get used to them!
- **JS Interop**: This was mostly ports, not Native/Kernel code.
- **Package Ecosystem**: This was two main concerns: people not being able to find a package to do what they needed within Elm, and people not having support for some web API they needed (Web Audio made a strong showing here.)
- **Typeclasses**: There were very few mentions of people wanting to derive things here. It was mostly about being able to have some sort of interfacing.

## Love for Elm

It's a bummer to end on pains, so here are some nice things that people left in the survey comments for me:

> After 20 years of programming, Elm is my favorite language. :)

Mine too. :)

> Elm is the first language I actually get my side projects done [in]. Love it.

Tons of people have this experience! [Luke Westby talked about it at elm-conf 2016!](https://www.youtube.com/watch?v=wpYFTG-uViE)

> Elm Slack is excessively helpful. Can only recommend.

[Get on Slack. Get on Slack. Get on Slack. Get on Slack.](http://elmlang.herokuapp.com/)

## Conclusions

### If You're Stuck, ask in Slack.

How many times can I link to the Slack in this post?
Here are a couple more:
[Sign up for the Elm Slack. You won't regret it.](http://elmlang.herokuapp.com/)

Remember: **excessively** helpful.

### Listen to Elm Town!

If you're not listening to [Elm Town](https://elmtown.github.io/) yet, go give it a try.
A good entry point is the series of interviews with Evan Czaplicki about how Elm came to be the way it is.
You'll learn something, I can almost guarantee it.

### Upgrade to 0.18

It can be a big time investment to move some code bases to 0.18.
I know!
I'm doing it myself right now!
But the benefits are large enough that you really should consider doing it.
Again, [`elm-upgrade`](https://github.com/avh4/elm-upgrade) is really helpful here!

### Start an Elm Group Near You

There were a bunch of comments left saying, essentially, "I really wish there was an Elm/FP group/conference near me."
If you want to have one, start one!
I don't say this to be flippant!
It's tremendously rewarding, it will make the community around you better, and it will make you more valuable within it.
Plus&hellip;

### Finally, an Offer

If you're doing something out there in the Elm community, and having detailed data would be helpful, shoot me an email and I'll get you what you need.
This survey is a lot of work to run, but if I can help people out who need it, it makes it worth it.
You can get me at [brian@brianthicks.com](mailto:brian@brianthicks.com) or on the [Elm Slack @brianhicks](http://elmlang.herokuapp.com/) (had to get one more link in there!)

See you next year!

{{<elmSignup>}}
