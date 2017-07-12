---
title: State of Elm 2017 Results
date: "2017-07-13T09:00:00-05:00"

---

The State of Elm 2017 results are here!
I first presented these as two talks, one to Elm Europe and one to the Oslo Elm Day.
I've embedded the Elm Europe talk below (it's shorter) but the [longer version](https://www.youtube.com/watch?v=NKl0dtSe8rs&feature=youtu.be) is on also YouTube.

{{< youtube BAtql6ZbvpU >}}

The rest of this post is a loose and shortened transcript of the Elm Europe version of the talk.

## So&hellip; What's This Survey For Anyway?

Let's start out with a story!

I got into Elm because I saw Richard Feldman's talk [Make the Backend Team Jealous]() at Strange Loop 20xx TODO.
I ended up using Elm to write a feature in a client project, and it was wonderful!
Eventually, I asked Richard on the Slack: "when's the Elm conference?"
His response? 

"Whenever you make it."

Mind. Blown.
It honestly hadn't occurred to me that I could just *do* that.

But it brought up a whole bunch of questions.
How many people?
What are their experience levels?
What problems can this conference solve for them?
Where is it?
When is it?
How much are tickets?

We set up the State of Elm 2016 to answer these questions, and it went great!
We got 614 responses, and put on the conference.
([The 2016 responses and summary are available too!]({{< ref "post/state-of-elm-2016-results.md" >}}))

## What Can We Improve?

Time passes, and we arrive in 2017.
I started thinking about what this year's version of the survey looked like.
What problems happened last year?
How could we avoid them?

[at this point in the talk I go into problems with last year's survey, which you can find in the [2016 results]({{< ref "post/state-of-elm-2016-results.md" >}}).]

We ended up with these questions:

- In which domain(s) are you applying Elm?
- How long have you been using Elm?
- How serious is your use of Elm?
- What is your level of experience with functional programming?
- What versions of Elm are you using?
- What language are you "coming from"?
- Where do you go for Elm news and discussion?
- Do you format your code with elm-format?
- What do you like the most about your use of Elm?
- What has been the biggest pain point in your use of Elm?

There were actually 5 more questions, but they turned out to not be useful signal so I've excluded them in this analysis:

- In what industry are you using Elm? (got vague data due to vague question wording)
- What is your level of influence within your team? (nearly everyone answered 10)
- Did you attend elm-conf US? (no bearing on other questions)
- Do you plan to attend Elm Europe? (no bearing on other questions)
- Any Other Comments? (mostly additional answers to other questions, which I incorporated into those questions)

## The Responses!

This year, we had 1,170 responses!
That's almost double last year (614).

### In Which Domain(s) Are You Applying Elm?

![In Which Domain(s) Are You Applying Elm?](/state-of-elm/2017/domain.png)

These answers were relatively the same year over year, so we can compare them.
This is not true of all the slides, but it is of this one.
To read these, you kind of have to double the 2016 count to get a proportional representation.

That said, both last year and this year the top response was Web Development, which is ~~totally expected~~ amazing!
And more people were using Elm for creating games last year than this year.

But other than that, we don't have a lot of parity between the two years.
This may be down to question design, and we'll make sure to keep this constant next year to see if we get a similar shift with no question change.

### How Long Have You Been Using Elm?

![How Long Have You Been Using Elm?](/state-of-elm/2017/usage.png)

This year we separated "curious/learning" and "just started".
This was meant to be "what is Elm" and "OK, I've installed the editor plugins and started a project, what's next?"
But, when you combine these, they exceed the amount of answers for the next category ("under a year", the highest.)
There are a lot of people coming into the community!

Then after those, we have a strict time scale of under a year to over four years.

Each successive year on this you see proportionally about the same number of people using Elm who were using it the year prior.
This is an encouraging sign!
It means people are sticking with Elm, hopefully getting value out of it, and remaining happy.

### How Serious is Your Use of Elm?

![How Serious is Your Use of Elm?](/state-of-elm/2017/how-serious.png)

The scale here is modified from last year, so I've chosen not to generate a year-over-year comparison for this question.
Last year didn't have enough nuance; it measured project kickoff to production, but didn't have things like side projects in production, or only in internal use.
This year, we added more responses to capture those!

This one surprised me.
I half expected to see some kind of curve, with all the people *not* using Elm outweighing those who *were* using Elm, but that's not the case!
Instead we see production levels all over this chart.
It's pretty well distributed!

### What is Your Level of Experience With Functional Programming?

![What is Your Level of Experience With Functional Programming?](/state-of-elm/2017/experience.png)

This is a pretty clear bell curve, with people preferring 7 most often.
It makes sense!

Almost nobody thinks they know *everything there is to know* about functional programming.

Conversely, if you don't know very much, you're more likely to answer 0 than 1.
In other words, "I know nothing" versus "I know only a little".

Interestingly, almost everyone who said they have background in Haskell answered 7 on this question.
You do you, humble Haskellers.

### What Versions of Elm Are You Using?

![What Versions of Elm Are You Using?](/state-of-elm/2017/versions.png)

Last year the survey closed *just* before 0.17 was released, so 0.16 was the latest version.

The number of people on the latest version hasn't changed much, proportionally (about 4%.)

The upgrade from Elm 0.17 to 0.18 is taking place slightly slower than that from Elm 0.16 to 0.17.
This is weird to me!
The 0.17 to 0.18 upgrade (some syntax and minor API changes) was much smaller in scope than 0.16 to 0.17 (removing `Signal` and `Effects`, with more syntax changes.)
You'd think people would move to 0.18 faster than they moved to 0.17!

On the other hand, the 0.17 to 0.18 has a weird reputation for being difficult, but it's really not!
You can use [elm-upgrade](https://github.com/avh4/elm-upgrade) to do most of the dirty work, then apply the rest of the API changes by hand.
There *are* legitimate reasons for not upgrading, but if you're not blocked by any of the changes then give one of those tools a shot!
You'll probably come away impressed, upgraded, and ready for future versions and fixes.


{{<elmSignup>}}
