---
title: Speed up pip install with Wheel
date: "2014-10-16T14:35:00-06:00"

---

So [PEP 427 (wheel)][wheel-pep] has been accepted and implemented. It's a
"built-in package format for python":

> A wheel is a ZIP-format archive with a specially formatted filename and the
> .whl extension. It is designed to contain all the files for a PEP 376
> compatible install in a way that is very close to the on-disk format. Many
> packages will be properly installed with only the “Unpack” step (simply
> extracting the file onto sys.path), and the unpacked archive preserves enough
> information to “Spread” (copy data and scripts to their final locations) at
> any later time. — [wheel docs][wheel-docs]

[wheel-docs]: http://wheel.readthedocs.org/en/latest/ "Wheel Docs"
[wheel-pep]: http://legacy.python.org/dev/peps/pep-0427/ "PEP 427 -- The Wheel Binary Package Format 1.0"

<!--more-->

This is pretty new stuff. In fact, it's so new you're probably not going to see
a lot of packages using the format on <abbr title="Python Package
Index">PyPI</abbr> yet, and you'll have to install it with `pip install wheel`.
But because of the way it works, you can already take advantage of the unpacking
and spreading mentioned above.

In fact, here's a <abbr title="Z Shell">ZSH</abbr> function that will save the
results of wheels and then install them later. This comes in handy because it
means you don't have to re-download packages for every single installation of
the same version across multiple virtual environments, and you only have to
build packages with extensions once. In practice, this means that installing
Pandas only takes a couple of seconds once you do it the first time, and you can
do it on a plane. Major win!

``` function wheel_install() { pip wheel --wheel-dir=$HOME/wheelhouse
--find-links=$HOME/wheelhouse $* pip install --use-wheel --no-index
--find-links=$HOME/wheelhouse $* } ```
