---
title: State of Elm 2018 Results
date: "2018-11-27T06:11:25-06:00"
tags: ["elm"]
draft: true

---

The State of Elm survey takes the pulse of the Elm community.
What companies have Elm in production?
What are people’s experiences when coming to Elm, and are they learning at decent pace?
What tools are popular, and which need help?

This year, the survey ran from the end of Janary to the beginning of March, and collected 1,176 responses (about the same as last year.)
After the survey ended, I scrubbed each field for 17 of the questions to make sure we had good data, reduced five of the questions to tags, and performed the following analysis.
Thank you for your patience while I did this, and thank you to all the people who checked in and asked if they could help!

Let's get going!

<!--more-->

## About You

{{< vegaLite schema="/static/state-of-elm/2018/charts/where.vega-lite.min.json" >}}

This was a multiple-choice answer, so the numbers don't add up to the total—mostly because people use Elm both at work and in side projects.

When you consider these together, about 80% of peple (953) respondents are using Elm in some capacity.
Of those, 459 (48%) are using Elm at work, which is cool.
It'll be fun to see at how this changes year-over-year—I hope these numbers increase!

One particular note here: I've told various people that I get respondents who don't use Elm, and who don't want to.
I don't know why they take the survey!
But nobody really believes me, so I added an option here to quantify that.
This year, it was 7 respondents.
I've haven't removed their responses from these questions, since getting an outsider's perspective on our community can be helpful!
(But I *did* remove several troll responses; those were not useful data.)

{{< vegaLite schema="/static/state-of-elm/2018/charts/experience-rating.vega-lite.min.json" >}}

We have roughly the same shape of the distribution this year as last year.

Notably, this year we don't have as many people answering that they didn't have any experience whatsoever.

This question is designed to get at the idea of how confident people are when using Elm.
I think it may be redesigned next year, since these past two years it has not revealed anything useful (other than people click about the middle of the scale.)

{{< vegaLite schema="/static/state-of-elm/2018/charts/languages.vega-lite.min.json" >}}

The differences here year-over-year are pretty significant, and it has more to do with survey design than respondent differences.
Last year we asked "What *language* are you 'coming from'?" and this year we asked "What programming *languages*, other than Elm, are you most familiar with?"
The new language clarified the intent of the question a lot—and we'll use it next year—but it meant that we got a lot more responses!

The upshot of this is that most of these languages can't be compared year-over-year except people's top language which was… let me check… JavaScript.
Not really surprising, at least to me!

{{< vegaLite schema="/static/state-of-elm/2018/charts/watering-holes.vega-lite.min.json" >}}

Some surprising changes this year:

- Blog posts tops the list.
  This is a new category this year!

- The Elm Discourse is both a new category, and came into existence just before this urvey was published.
  (It replaced the elm-discuss mailing list, and has about the same number of respondents.)

- The Elm Weekly newsletter dropped off since it stopped being published—it's back now, though, and you can sign up at [elmweekly.nl](http://elmweekly.nl/)

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

{{< vegaLite schema="/static/state-of-elm/2018/charts/nearest-city-country.vega-lite.min.json" >}}

Here's the same data organized by country.
When viewed in this way, the United States dominates the list, but all told EU countries plus the UK had 433 respondents, or about the same as the US.

## *Where* do you use Elm?

{{< vegaLite schema="/static/state-of-elm/2018/charts/domains.vega-lite.min.json" >}}

Overall, these responses are up, so it's not super useful to compare them year-over-year, but we do see some interesting stuff coming together.

For example, I'm not sure why gaming dropped last year, but it sure picked up again this year!
I was curious what kinds of games people were writing, so I asked!
The folks in #gamedev on the Elm Slack pointed me to [rofrol/awesome-elm-gamedev](https://github.com/rofrol/awesome-elm-gamedev) as a nice overview, and [rofrol/elm-games](https://github.com/rofrol/elm-games/blob/master/README.md) as a comprehensive list of games in Elm.
Enjoy!

A note about "Web Development"…
I tried as hard as I could to avoid a situation where people answered this, and was very careful when tagging to try and figure out exactly what people were doing with Elm.
"Web Development" isn't exactly the most helpful answer!

{{< vegaLite schema="/static/state-of-elm/2018/charts/experience-length.vega-lite.min.json" >}}

Overall, people are using Elm longer over time.
Makes sense, since people who have been using Elm for one year are likely to use it for another, and another, and so on.

(Note: sorry for the messiness in the chart above; I used vega-lite for these and could not figure out how to get facets to order properly.
If you're a vega-lite expert and want to help fix this, get in touch.)

{{< vegaLite schema="/static/state-of-elm/2018/charts/progress-work.vega-lite.min.json" >}}

When people use Elm at work, they tend to get it into production.
Good news!

{{< vegaLite schema="/static/state-of-elm/2018/charts/progress-work-license.vega-lite.min.json" >}}

When work projects are in Elm, they're mostly closed source, which you can see in these responses.
When work projects *are* open-source, it's interesting to note that permissive licenses (like BSD-3, under which the compiler and most packages are licensed) are more popular than share-alike licenses like the GPL.

{{< vegaLite schema="/static/state-of-elm/2018/charts/progress-work-challenge-tagged.vega-lite.min.json" >}}

The highest response here is "Buy-In".
Most of these were things like "my boss wouldn't approve it" but some were "my peers don't like functional languages, or typed languages."
This leads into the second most answered item: Elm (and languages in the ML family) are unfamiliar, especially to people who mostly come from a C-style language background.
I think most of the rest of these items stem from these two.

{{< vegaLite schema="/static/state-of-elm/2018/charts/progress-side.vega-lite.min.json" >}}

In contrast with the "how far along is your work project" above, it's much easier to start a side project but much harder to finish it—there are usually no external deadlines or project managers asking for updates.
It makes sense to em, then, that the rate of projects in development would be higher than before, and we see that here.

{{< vegaLite schema="/static/state-of-elm/2018/charts/progress-side-license.vega-lite.min.json" >}}

The Elm compiler and most open-source Elm libraries are licensed as BSD-3, which falls under the top category here.

{{< vegaLite schema="/static/state-of-elm/2018/charts/progress-side-challenge-tagged.vega-lite.min.json" >}}

This is pretty self-explanatory: people don't have a lot of time for side projects!

For lessening learning cost, here's a tip: try challenges like [Advent of Code](https://adventofcode.com/2018) or [Project Euler](https://projecteuler.net/)!
They provide the framework for trying new languages with small, well-defined problems.

{{< vegaLite schema="/static/state-of-elm/2018/charts/versions.vega-lite.min.json" >}}

0.19 is out *now*, but it wasn't when this survey ran.
That means that we need to be looking at the usage of 0.18 vs 0.17 and prior.
Happily, usage of old versions fell, and current versions rose.
I hope to see a similar trend next year with adoption of 0.19!

## *How* do you use Elm?

{{< vegaLite schema="/static/state-of-elm/2018/charts/elm-format.vega-lite.min.json" >}}

Last year the data showed that people were generally in favor of using elm-format.
This year, the effect is even stronger!
More people have heard of elm-format, and the amount of people who prefer to use it rose.

{{< vegaLite schema="/static/state-of-elm/2018/charts/css.vega-lite.min.json" >}}

This result—most people using plain CSS or SCSS—tells me that people are integrating Elm into larger existing codebases.

Somewhat unsurprisingly, the first two Elm libraries used are elm-css and ~~style-elements~~ [elm-ui](https://2018.elm-conf.us/schedule/matthew-griffith).
Both are great options for styling Elm apps in a type-safe way!

{{< vegaLite schema="/static/state-of-elm/2018/charts/build-tools.vega-lite.min.json" >}}

Most people use webpack to build their Elm applications.
Kind of unsurprising, given the support in [elm-webpack-starter](https://github.com/elm-community/elm-webpack-starter) and [elm-webpack-loader](https://github.com/elm-community/elm-webpack-loader).

It *was* surprising to me to see that the second two results are elm-make and elm-reactor.
I'm curious what this means about how people's applications are delivered and built overall.

{{< vegaLite schema="/static/state-of-elm/2018/charts/editors.vega-lite.min.json" >}}

VSCode is surprisingly popular!
We didn't previously have a question like this but I would have expected to see atom at the top, followed by one of Vim or Emacs.
That *nearly* happened here, but I was really surprised to see Atom a third place!

One editor (which fell of the list as fewer than 1% of people answered it) was [Kakoune](https://kakoune.org/)—I was curious so I wrote part of this post in it.
It's got some really interesting ideas about selections.
If you're interested in text editors. maybe check it out!

{{< vegaLite schema="/static/state-of-elm/2018/charts/js-interop.vega-lite.min.json" >}}

Most people use external JavaScript libraries; things like the AWS SDK and D3 were common.

Next most common is localStorage, but almost nobody elaborated on *why*.

"Files" came in third.
I'm curious to see if that'll hold up next year, now that [`elm/files` and `elm/bytes` have been released](https://elm-lang.org/blog/working-with-files).

TODO: check with someone about possible reasons for localStorage

{{< vegaLite schema="/static/state-of-elm/2018/charts/test-tools.vega-lite.min.json" >}}

Almost 50 / 50 "I don't use this at all" vs "I use the thing you would expect".
This tells me that the split of testing is roughly "50% of people don't test their Elm applications".

A useful quetsion, but in retrospect it could have been simpler: "do you test your Elm projects"?

{{< vegaLite schema="/static/state-of-elm/2018/charts/test-targets.vega-lite.min.json" >}}

This is more enlightening: people write tests mostly when faced with complex functions whose behavior the compiler can't check.
This is when I write tests too, especially to avoid logical errors or changing values in incompatible ways.
I've personally found fuzz/property testing extremely valuable here.
[*PropEr Testing* by Fred Hebert](http://propertesting.com/toc.html) ([now a book](http://propertesting.com/)) really helped me get my mind around property testing in general—I'd recommend you read it if you're interested in upping your property testing game.

{{< vegaLite schema="/static/state-of-elm/2018/charts/attraction-tagged.vega-lite.min.json" >}}

We've got a big peak at the top here for functional programming—it's something a lot of people want to try out, which I'm happy about!
Similar thing going on for types; I'm glad people are exploring these areas for themselves.
I've found them really rewarding!

The third and fourth responses ("No Runtime Exceptions" and "Not JavaScript") are more in line with what I expected from this question.
These are things that are really painful in languages (like JavaScript) for which Elm is a commonly-listed alternative.
People want to find solutions to their pains, and if we can help them with that we can grow the Elm community!

(n.b. there's a looooong tail here, which I've cut off by only including items which occurred in 1% or more of responses.)

{{< vegaLite schema="/static/state-of-elm/2018/charts/pain-tagged.vega-lite.min.json" >}}

A note about these questions: getting this data is difficult and time-consuming since I have to distill nearly 1,200 plain text inputs into a smallish number of tags for presentation.
That means that there are some tags that completely change year-over-year depending on what people type in, and that may not always be accurate.
I've tried to minimize errors wherever possible, but it's still a completely human-driven process.
That said, I find them particularly valuable as a pulse on how people are feeling year-over-year, so they'll probably always be in the survey!

This year slightly more people had trouble with JSON Decoders than they did with the learning curve.
This flips the #1 and #2 spots year-over-year.

People also had notably less trouble with interop this year, but more problems with documentation.

I find it encouraging that respondents are having much more problems with scaling this year.
To me, that means they've grown their Elm codebases in such a way that they're having to think in the bigger picture instead of "hmm, what does `Maybe a` mean?"

We *did* see a big drop in people explicitly requesting type classes (or other forms of interfaces), but the total number of requests for type system features remains unchanged.

{{< vegaLite schema="/static/state-of-elm/2018/charts/like-tagged.vega-lite.min.json" >}}

More of the usual culprits for this question!

People like the error messages and types, of course, but we saw a big jump in people saying things like "If It Compiles, It Works" year over year.
We also saw a big jump in "Refactoring", which I think supports my point above about people having more trouble scaling their Elm apps since they're now having to do that as they've grown more advanced.

Another big change was the drop in "Not JavaScript" (47 responses to 18—nearly a 70% decrease!)
I hope that long-term Elm is seen as something good in it's own right, not just a refuge for people who have had a bad experience with JavaScript, so this kind of drop encourages me.

There were a lot of responses saying things like "Elm makes me a better programmer" and "Elm has improved the way I think about my work."
In addition to "Makes Me A Better Programmer", I tagged those as "Confidence" which roughly doubled in response this year.
Those were really nice to tag!

## Wrapping Up

TODO!

{{< vegaLiteRender >}}
