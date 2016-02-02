---
title: Speedy Sets
date: "2014-11-10T06:38:00-06:00"

---

Sets are a valuable tool in any programmer's toolbox. Finding unique items in a
list or shared items between two lists is super simple using sets. But did you
know they can be used for a considerable performance increase, in certain cases?

<!--more-->

(If you haven't used Python's sets before, go read about them on
[Dive Into Python 3](http://www.diveintopython3.net/native-datatypes.html#sets)
and come back for the rest.)

Because of how sets are implemented (as
[hash tables](http://en.wikipedia.org/wiki/Hash_table)), they can also speed a
Python program *way up* when you're searching for members of a set. The
[time complexity](https://wiki.python.org/moin/TimeComplexity) page on the
Python wiki says that for lists, `x in s` is O(n). But for sets, it's O(1). If
you're not familiar with big O notation, that means that when you use a list for
checking membership, Python will do as many operations as there are items in the
list in the worst case. On the other hand, when you use a set Python only has to
do one operation.

## Let's Benchmark It!

We're going to use the `timeit` module to get a simple benchmark going. Sticking
to the default of a million iterations, we'll get a list and a set of values and
then test how long it takes to get a member that *isn't* part of either.

```
In [1]: timeit.timeit(stmt='"q" in x', setup='x = range(100)')
Out[1]: 4.768558979034424

In [2]: timeit.timeit(stmt='"q" in x', setup='x = set(range(100))')
Out[2]: 0.05363011360168457
```

So in a list of 100, Python takes 4.76ms to do the lookup. On a set, it only
takes 0.05ms. A huge improvement, and that's a pretty small number of items! But
what if we increase the number of words we have to check, say by 10 times?

```
In [3]: timeit.timeit(stmt='"q" in x', setup='x = range(1000)')
Out[3]: 46.04593205451965

In [4]: timeit.timeit(stmt='"q" in x', setup='x = set(range(1000))')
Out[4]: 0.07138299942016602
```

So when we increase the count of values an order of magnitude, the time Python
takes to calculate membership in the list increases *about* an order of
magnitude. This goes along with what we'd expect from an O(n) operation.
Meanwhile, the time for a set to do the same thing stays about the same, since
it's O(1).

## Applied: A Simple Spellchecker

I'm going to steal this idea from this year's Stripe CTF: a spellchecker. In
this case, it's more like the Typo Detector 2000™ since we don't do any
suggestions, so let's call it `typodetector.py`. What this will do is read any
input from `stdin` and surround any words it doesn't know about in braces, like
`{jabberwocky}`.

I'm going to use `/usr/share/dict/words` for the word list here. If you want to
follow along and your system doesn't have that file, you can get something
similar from the [Duke CS Department](http://www.cs.duke.edu/~ola/ap/linuxwords)
or, on Linux, your package manager. I'm also going to spellcheck the plain text
version of
[The Adventures of Sherlock Holmes](https://www.gutenberg.org/ebooks/1661) from
Project Gutenberg, so you might want to grab that.

Here we go:

```
#!/usr/bin/env python
import re
import sys

with open('/usr/share/dict/words', 'r') as source:
    words = source.read().lower().split()

def check(match):
    """check if a word is in the word list"""
    word = match.group()  # re.sub gives us match objects, we need strings

    if word.lower() not in words:
        word = '{%s}' % word

    return word

def typodetect(doc):
    return re.sub(r'[\w\-]+', check, doc)

if __name__ == '__main__':
    print typodetect(sys.stdin.read().strip())
```

Now we can use it like this:

```
$ echo "Elvis was the kng of rock 'n roll" | python typodetector.py
Elvis was the {kng} of rock 'n roll
```

But let's try it on our big document (which I've conveniently named
`sherlockholmes.txt`) and send it to a new file, `sherlock_corrected.txt`.

```
$ python typodetector.py < sherlockholmes.txt > sherlock_corrected.txt
```

And&hellip; wait.

&hellip;

I actually ran out of patience to let that finish. When I interrupted it, it had
already gone for a couple minutes. I know it's whole book we're checking, but
that's way too slow. However, we can fix it! Let's make a simple change:

```
with open('/usr/share/dict/words', 'r') as source:
    words = set(source.read().lower().split())
```

So now that we're checking for membership in a `set` instead of a `list`, `time`
says it took 0.35 seconds *total*. A massive speedup!

So let's see what this means in terms of the benchmark we did. My word list has
235,886 words in it, and the regular expression we're using results in 108,260
matches. That means if we use a list (which is O(n) here, remember), Python
would have to do `len(words) * len(words_in_document)` operations, which comes
out to 25,537,018,360 worst case. Yep, 25 *BILLION*. But if we switch that out
to a set, Python does the same number of operations as words it has to check.
108,260. Quite a difference!

## So...

There are a couple things to keep in mind when using sets. First of all, they
can't store unhashable objects ('cause they're hash tables, remember?) That
means no lists or other such mutable goodies. Second, the items in a set are
unique. This is great sometimes, but it means there's no accounting for how many
of each item there were in the original collection! If you need that, though,
you can use
[`collections.Counter`](https://docs.python.org/2.7/library/collections.html#collections.Counter).

So, to recap: `list` membership is O(n) but `set` membership is O(1), which
makes a huge performance impact. So go find some code where you're checking for
members and see if a set would be a better idea instead!
