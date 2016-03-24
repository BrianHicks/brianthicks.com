---
title: State of Elm 2016 Results
date: "2016-04-22T09:03:00-05:00"

---

Earlier this year I published a "State of Elm" survey. 644 people answered. This
post details the results of that survey.

First of all, let me supply a big fancy warning: **I am not a data scientist or
statistician**. As I said about myself in the talk on this topic to the Chicago
Elm User Group: "I don't even play one on TV!" Still, this was an interesting
project, but take my conclusions with a grain of salt. If you *are* a real data
scientist, please let me know. It'd be great for someone with that kind of
background to look at these data.

Some background: 644 people answered this survey. It ran between January 26,
2016 and February 8, 2016. Most of these questions took multiple responses, so
the totals add up higher than 644. Most of the questions also had an "Other"
field to fill in, so there's a long tail on those questions. Without further
delay, let's take a look at the responses:

<!--more-->

## In which domains are you applying Elm?

{{< figure src="/images/state-of-elm-2016/domains.png" >}}

This one I kind of expected to fall where it did. Most people use Elm for web
development, then games and graphics. There were several people who said they
weren't using Elm (but, as we'll see later, they want to).

## What is your primary Elm development environment?

{{< figure src="/images/state-of-elm-2016/what-editor.png" >}}

Of these options Vim was the most popular, but not by much. These results
confirm to me that there's not one clear "best" editor for using Elm. One
surprise was the Visual Studio answer, which those 18 people all wrote in.

## How long have you been using Elm?

{{< figure src="/images/state-of-elm-2016/how-long.png" >}}

This figure encourages me. We've got a *lot* of people who just started using
Elm. The language also seems to have some sticking power to people who are
continuing on. Of course, there are also the four people who have been using Elm
*longer than 3 years*. Wow.

## What is your level of functional programming knowledge?

{{< figure src="/images/state-of-elm-2016/functional-programming-knowledge.png" >}}

The answers got cut off a little bit in these charts. They were:

1. Elm is my first functional language
2. I have basic familiarity with the general concepts
3. I know when and how to use a monad
4. I eat category theory for breakfast

We're seeing people using Elm who have a basic familiarity with functional
programming concepts. The Chicago Elm user group wondered if that group was
coming from Javascript. That *seems* right, but I don't have any correlation to
prove it. That also brings up a good question: What *does* define a functional
language? Lambas? Types? A question about background would have been good to
follow up with, which we should add next year.

## For what kinds of projects do you use Elm?

{{< figure src="/images/state-of-elm-2016/what-kinds-of-projects.png" >}}

We included this question to gauge people's level of involvement in Elm. It's
not surprising to see this level of engagement (mostly tinkering or side
projects). A new language is always a hard sell in a company, especially a young
one like Elm.

## Which versions of Elm do you use in production or development?

{{< figure src="/images/state-of-elm-2016/versions.png" >}}

This is a *huge* amount of people using the most recent version. This survey
shows data from shortly after the release of Elm 0.16.0. I imagine that now the
percentage in favor of that version would be even higher.

## Which browsers do you target?

{{< figure src="/images/state-of-elm-2016/browsers.png" >}}

This one is a mixed. Far and away the most targeted browser is Chrome, but the
IE family is making a strong showing here. Most people ticked all the versions
of IE they support, but I've retained the question wording here (i.e. 9+).
Firefox and Safari also have some support.

## What tools do you use to compile/package/deploy/release your Elm apps?

{{< figure src="/images/state-of-elm-2016/build-tools.png" >}}

The answers to this question surprised me. I expected we would see the majority
of people using a build system of some kind. Yet the top tool of that kind
(webpack) has *half* the amount that `elm-reactor` and `elm-make` do. I can
think of two explanations for this:

1. `elm-reactor` and `elm-make` are good tools. (They *are*, too!)
2. The same percentage of people who are using Elm for hobby and side projects
   took this answer.

Note the response "rails sprockets :(". I couldn't bear to take that poor
person's sad face out of the data when scrubbed it!

**EDIT**:
[Richard Feldman](https://twitter.com/rtfeldman/status/712323668215353344)
observes that:

> Also consider that "grunt + gulp + webpack == buildToolTotal"

Good point, and thanks for the catch! Webpack, gulp, brunch, grunt, gulp, and
broccoli taken together account for 293 responses, which would put those types
of build systems in aggregate in second place.

## What has been the biggest pain point for you in your use of Elm?

{{< figure src="/images/state-of-elm-2016/pain.png" >}}

This was the most interesting question to me, and the one with the highest
number of "other" responses. The biggest pain turned out to be "Server-side
Elm". In other words, people want to write their server-side components in Elm
as well. We'll go over why in a minute, but I suspect that people just chose
that out of convenience, not because it was an actual pain they felt. There are
a *lot* of interop pains though: primarily JavaScript, but HTML and CSS show up
too.

## Which *one* of the following languages would you choose to power your backend?

{{< figure src="/images/state-of-elm-2016/language.png" >}}

The answers to this question are why I'm casting a little doubt on the top
answer of the pain question. Elm has *4* responses. The top languages,
meanwhile, include Elixir, Javascript, and Haskell. I've separated these
languages into "static typing" and "dynamic typing" for the chart. This is
most visible in Javascript (Coffeescript vs Typescript, for example).

There are quite a few missing languages here, as well. PHP doesn't even show up,
for example. People just didn't write them in.

**EDIT**: As
[Amitai Burstein](https://twitter.com/amitaibu/status/713119982968827905) points
out: Drupal is, in fact, a PHP framework. Thanks for the correction!

## Where are you located?

{{< figure src="/images/state-of-elm-2016/location.png" >}}

Time for a big *mea culpa*. One of the options initially read "Eastern Europe
(including Great Britain)". Plus I completely forgot to include South America.
To correct the Europe issue, I've grouped the answers by continent (minus a few
outliers.) To everyone who wrote in "South America" before I remembered to add
the option: I'm sorry for the apparent slight. I know you exist, promise! Thanks
for correcting me.

Now that's done, we saw the highest rate of responses from North America and
Europe. A fair amount came from Asia and Oceania, and a few from South America.

## What is your job title?

{{< figure src="/images/state-of-elm-2016/title.png" >}}

This is one question that *really* could use a proper data scientist. I intended
to extract seniority and area of responsibility from these. But of course this
is the internet, so I got answers like "Ninja" and "Senior Business Deputy
Second Vice Fourth Level Prime Enterprise Archon Thrice Removed". There was also
too much data for me to scrub in a reasonable amount of time. *And* most of the
titles didn't state seniority at all. To get any value out of this data, I
separated the titles on spaces to extract terms.

The respondents were mostly "developers" or "engineers", and "senior" and "lead"
made frequent appearances. We also have a few C-level people looking at Elm, and
quite a few students.

Oh, and respect to our ninja friends. I look forward to some excellent
libraries, delivered in the dead of night.

## Thanks!

That's all for this year's survey. Stay strong, Elm community!

Thank you to Richard Feldman and Evan Czaplicki for their feedback on these
questions. Thanks to the State of Clojure survey team for the inspiration (and
questions). Finally, thank you to everyone who took the survey and shared it
within their network of Elm-loving friends and colleagues. Y'all are awesome.
