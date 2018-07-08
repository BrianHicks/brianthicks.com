---
date: "2018-07-08T07:34:00+02:00"
title: "Let's Make Nice Packages!"
tags: ["elm"]
draft: true
---

This year at [Elm Europe](https://2018.elmeurope.org/) I gave a talk called "Let's Make Nice Packages!"

It's about research.

No, wait, come back!

<!--more-->

<!-- TODO: post embed for talk -->
{{< youtube BAtql6ZbvpU >}}

I'm super grateful for having had the chance to speak at Elm Europe.
It was a blast!
I'd highly recommend going next year, and plan to be there myself if I can.

There are a bunch of things I had to cut from the talk in the interests of time.
Here are a few that came up in conversation with people at the conference:

## Help People Along The Way

First, if you follow all of the advice in my talk, *but do not help anyone along the way*, you will still fail.
You're trying to solve a problem, right?
In my experience, you'll have a much harder time solving the bigger picture problem if you don't get involved in the smaller ones.

If you do this, you're building a relationship and trust with the people you're working with.
Everybody feels appreciated when someone takes the time not only to listen to them, but to help them find a solution to something that's bothering them.
Then they'll be way more receptive to you saying, "hey, we talked about this earlier, what if we tried this new thing?"

Compare that to some random person showing up and say "hey I made a thing for youuuuuuu!"
Why should they believe that it will work for them?
It's just worse!

Practically speaking this means participating in discussions on Slack, Discourse, and Reddit.
Be helpful, empathetic, and kind.
People really appreciate that!

## Publish Little Solutions

Second, this whole process is a really nice way to get into blogging.
People tend to have the same problems, but not everybody will ask online.
So if you compile small solutions to problems you've helped with, and put them where people can see them, you're also building trust with people who you'll never have to speak with directly.

## What If I Need New Language Features to Solve the Problem?

*Rarely* while you're doing this, you find that you need something that Elm doesn't have, and which you can't add in a package.
The most common of these is Native code, but it comes up in other ways sometimes with language extensions or new syntax proposals.

This is an excellent time to stop and talk with people about what you're thinking about!
Put stuff in the "Learn" or "Request Feedback" categories on Discourse or ask in #general or #api-design on Slack.
Ask questions, people probably can help you in the way you've helped them.

And remember, communication *is* collaboration.
Having discussions is just as important as writing code and opening PRs, if not more!

### Check for the X/Y Problem

At the same time, do check that you're not hitting the [X/Y problem](TODO: link).
(And by the way, if your problem statement reads like "I don't have access to some web platform API in Elm", you *definitely* are.
The problem is always deeper than not having access to a specific API.)

Fortunately, it's not terribly difficult to use your notes to check this!
As a specific exercise, [5 Whys](TODO: link) is handy: just continue asking "why" until you get to the root of the problem.
A nice first question is "what are people trying to do?"

If you can't find the root problem in a satisfactory way, with concrete examples from people you've helped, then take it as a signal to reexamine your research.

On the other hand, sometimes there are legitimately things that can't yet be done.
Your research has revealed this in a concrete and quantifiable way, which is helpful.
Good job!

### OK, I did all that and still can't solve this problem without language extensions

If you have found you *still* need some kind of language change to make solving the problem even possible, it's time to write up your research and share it (probably on the elm-dev mailing list.)
You'll need to include these three things:

1. the problem you're trying to solve
2. the designs you tried, *without* language extensions
3. why those designs didn't solve the problem

Be as clear and concise as possible, and take the time to format your message to be read.
Use headings, lists, and a add quick summary at the top.
It helps more than you'd realize!

At this stage, please don't suggest solutions.
The core team follows this design process too, including the deep research and thinking.
At the language level, that research has a much bigger scope.
New features also usually need to solve several problems at once, so there will probably be some discussion and then a period of waiting.
It's better to do the right thing later than the wrong thing now.

## Note Organization

Finally, I like to organize my notes in Markdown like this.
It helps me remember to fill out all the sections:

```markdown
# {Thread Title} by {author}

Summary or additional thoughts.

## Context

What are they trying to do?

## The Fix

Your suggestion for how to fix the initial problem.
Don't forget other people's suggestions as well!

## Pain

This is where relational language goes. The header
is "pain" for me since this is typically what
they're expressing.

## Questions

> TODO: short example

## Worldview / Assumptions

> TODO: short example
```

To close out: if you have any questions about any of this, I'm always happy to talk about it!
You can find me on Slack at @brianhicks, or you can email me at [brian@brianthicks.com](mailto:brian@brianthicks.com).
