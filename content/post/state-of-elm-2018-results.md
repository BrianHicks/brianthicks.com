---
title: State of Elm 2018 Results
date: "2018-11-27T06:11:25-06:00"
tags: ["elm"]
draft: true

---

TODO: intro

TODO: why this took so long?

<!--more-->

## About You

{{< vegaLite schema="/static/state-of-elm/2018/charts/where.vega-lite.min.json" >}}

This was a multiple-choice answer, so the numbers don't add up to the total—mostly because people use Elm both at work and in side projects.

Anyway, TODO% of respondents are using Elm in some way!

31.26% are using Elm at work, which is cool.
It'll be helpful to look at this year-over-year next year.

{{< vegaLite schema="/static/state-of-elm/2018/charts/experience-rating.vega-lite.min.json" >}}

We have roughly the same shape of the distribution this year as last year.

Notably, this year we don't have as many people answering that they didn't have any experience whatsoever.

{{< vegaLite schema="/static/state-of-elm/2018/charts/languages.vega-lite.min.json" >}}

The differences here year-over-year are pretty significant.
That's because last year {survey design reason} and this year it was a blank field.

Top language is JavaScript, surprising... let me check... nobody.

Last year the second language was Haskell, which has grown but fallen down the charts a fair way.

{{< vegaLite schema="/static/state-of-elm/2018/charts/watering-holes.vega-lite.min.json" >}}

Some surprising changes this year:

- Blog posts tops the list.
  This is a new category this year!
 
- The Elm Discourse is both a new category, and came into existence just before this urvey was published.
  (It replaced the elm-discuss mailing list, and has about the same number of respondents.)

- The Elm Weekly newsletter dropped off since it stopped being published—it's back, now, though, and you can sign up at [elmweekly.nl](http://elmweekly.nl/)

{{< vegaLite schema="/static/state-of-elm/2018/charts/learning-resources.vega-lite.min.json" >}}

The Elm Guide—since rewritten for 0.19—dominates this list.
It's the go-to learning resource!

Below that, we have some interactive resources (the Elm Slack, StackOverflow, and Reddit threads), and books like Elm in Action, Programming Elm, and The JSON Survival Kit.

{{< vegaLite schema="/static/state-of-elm/2018/charts/usergroup.vega-lite.min.json" >}}

We don't have data for this year-over-year—we will repeat this next year so we do—but we do see that about 40% of respondents have an Elm user group near them!
Fantastic!

{{< vegaLite schema="/static/state-of-elm/2018/charts/nearest-city.vega-lite.min.json" >}}

This shows the city-level view of respondents.
There are hotspots in:

- San Francisco and the Bay Area
- London
- Oslo
- Berlin

TODO: fix this graph to show the city name in the tooltip instead of the coordinates

{{< vegaLite schema="/static/state-of-elm/2018/charts/nearest-city-country.vega-lite.min.json" >}}

Here's the same data organized by country.
When viewed in this way, the United States dominates the list, but all told European countries had 433 respondents, or about the same as the US.

## *Where* do you use Elm?

{{< vegaLite schema="/static/state-of-elm/2018/charts/domains.vega-lite.min.json" >}}

- no idea why gaming dropped last year
- overall these responses are up, so it's not super useful to compare them year-over-year
- I took "web development" off because it was oooobvious and not the intent of the question

{{< vegaLite schema="/static/state-of-elm/2018/charts/experience-length.vega-lite.min.json" >}}

Overall, people are using Elm longer over time.
Makes sense!

TODO: these need to be reordered

{{< vegaLite schema="/static/state-of-elm/2018/charts/progress-work.vega-lite.min.json" >}}

TODO: these imply an ordering, and I should reorder them in the chart.

{{< vegaLite schema="/static/state-of-elm/2018/charts/progress-work-license.vega-lite.min.json" >}}

Sure, mostly work projects are closed source. That totally makes sense from the data.
I'm interested in nothing that permissive licenses are more popular than share-alike license.

TODO: this data needs to be cleaned to correct "viral".

{{< vegaLite schema="/static/state-of-elm/2018/charts/progress-work-challenge-tagged.vega-lite.min.json" >}}

TODO: can I make the caption here into two lines?

TODO: I'd like to show some examples of people saying "buy-in" here to show what people are having trouble with

{{< vegaLite schema="/static/state-of-elm/2018/charts/progress-side.vega-lite.min.json" >}}

TODO: order these in the same way as the work question above.

{{< vegaLite schema="/static/state-of-elm/2018/charts/progress-side-license.vega-lite.min.json" >}}

TODO: fix this in the data, too

{{< vegaLite schema="/static/state-of-elm/2018/charts/progress-side-challenge-tagged.vega-lite.min.json" >}}

This is pretty self-explanatory: people don't have a lot of time for side projects!

Here's a tip: try challenged like [Advent of Code](https://adventofcode.com/2018) or [Project Euler](https://projecteuler.net/)!
They provide the framework for trying new languages with small, well-defined challenges.

{{< vegaLite schema="/static/state-of-elm/2018/charts/versions.vega-lite.min.json" >}}

0.19 is out *now*, but it wasn't when this survey came out.
That means that we need to be looking at the usage of 0.18 vs 0.17 and prior.
Happily, usage of old versions fell, and current versions rose.
I hope to see a similar chart next year with adoption of 0.19!

## *How* do you use Elm?

{{< vegaLite schema="/static/state-of-elm/2018/charts/elm-format.vega-lite.min.json" >}}

Last year the data showed that people were generally in favor of using elm-format.
This year, the effect is even stronger!
More people have heard of elm-format, and the amount of people who prefer to use it rose.

{{< vegaLite schema="/static/state-of-elm/2018/charts/css.vega-lite.min.json" >}}

This result—most people using plain CSS or SCSS—tells me that people are integrating Elm into larger existing codebases.

Somewhat unsurprisingly, the first two Elm libraries used are elm-css and style-elements.
Both are great options for styling Elm apps in a type-safe way!

TODO: link to Matt's talk on elm-ui.

{{< vegaLite schema="/static/state-of-elm/2018/charts/build-tools.vega-lite.min.json" >}}

Most people use webpack to build their Elm applications… not so surprising.

It *was* surprising to me to see that the second two results are elm-make and elm-reactor.
I'm curious what this means about how people's applications are delivered and built overall.

{{< vegaLite schema="/static/state-of-elm/2018/charts/editors.vega-lite.min.json" >}}

These are all great options!
I don't have a lot of commentary there?

{{< vegaLite schema="/static/state-of-elm/2018/charts/js-interop.vega-lite.min.json" >}}

TODO: comentary. This is a good one to pair on with Richard.

{{< vegaLite schema="/static/state-of-elm/2018/charts/test-tools.vega-lite.min.json" >}}

Almost 50/50 "I don't use this at all" vs "I use the thing you would expect".

This tells me that the split of testing is roughly "50% of people don't test their Elm applications".

That might have been a more useful question, in retrospect.

{{< vegaLite schema="/static/state-of-elm/2018/charts/test-targets.vega-lite.min.json" >}}

{{< vegaLite schema="/static/state-of-elm/2018/charts/attraction-tagged.vega-lite.min.json" >}}

{{< vegaLite schema="/static/state-of-elm/2018/charts/pain-tagged.vega-lite.min.json" >}}

{{< vegaLite schema="/static/state-of-elm/2018/charts/like-tagged.vega-lite.min.json" >}}

{{< vegaLiteRender >}}
