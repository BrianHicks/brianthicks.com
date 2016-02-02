---
title: "Automate your Python environment with pyenv"
date: "2015-04-15T10:05:00-06:00"

---

Managing different versions of Python is a pain. For example, if you’re working
on two projects that use different versions of Django, it gets really hard to
keep your virtual environments in order, and you have to remember to activate
the right one every time you work on a project. But what if you could just
switch between Pythons and virtual environments with a simple command; or, even
better, if you didn’t even have to issue a command but your tools knew which
version of Python and which virtualenv to use?

<!--more-->

Enter pyenv. It does all those things and more, installing and switching between
multiple versions of Python like it's nobody's business. It will even manage
your virtual environments without you even having to think about it.

## Installing (on OSX)

You can download pyenv at [Github](https://github.com/yyuu/pyenv), and install
it either with [Homebrew](http://brew.sh/) or with
[pyenv-installer](https://github.com/yyuu/pyenv-installer). The only requirement
is shell scripting capabilities, so this should even work on Windows, if you're
using cygwin.

For this post, I'm going to assume that you're using OSX, and have Homebrew
installed. In this case, all we need to do to install pyenv is&hellip;

    brew install pyenv pyenv-virtualenv
    
That will install all the dependencies for building different versions of Python
and using them in virtual environments. Once the command finishes, add pyenv to
your shell by adding the following to the bottom of your `~/.bashrc` (or
`~/.zshrc`, if you're using ZSH):

    if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

Then restart your shell, and we should be good to go!

## Install a version of Python (let's do pypy!)

Let's install a couple versions of Python. You can see what you already have by
issuing `pyenv versions`. If you're just installed all you'll see is "system",
the system Python interpreter. We can get a list of versions available to
install with `pyenv install --list`. It'll come back with a huge list of
versions. For this example, we're going to install the latest version of pypy,
so we run&hellip;

```
~ $ pyenv install pypy-2.5.0
Installing pypy-2.5.0-osx64...
Installing setuptools from https://bootstrap.pypa.io/ez_setup.py...
Installing pip from https://bootstrap.pypa.io/get-pip.py...
Installed pypy-2.5.0-osx64 to /Users/brianhicks/.pyenv/versions/pypy-2.5.0
```

Now when you run `pyenv versions`, you should see "pypy-2.5.0" included in the
list.

Next let's make a new directory and set the local python version. I'm going to
make mine in `~/Desktop/pypy_test/`:

```
~ $ mkdir ~/Desktop/pypy_test
~ $ cd ~/Desktop/pypy_test
~/Desktop/pypy_test $ pyenv local pypy-2.5.0
```

We'll set the version of pypy that we just installed as the local version in the
directory. That means that whenever you're in that directory and run python,
you'll get the version you specify. Let's demonstrate by moving *out* of that
directory and running Python, and then moving back in to see what happens:

```
~/Desktop/pypy_test $ cd ~/Desktop
~/Desktop $ python
Python 2.7.8 (default, Nov 14 2014, 15:57:55) 
[GCC 4.2.1 Compatible Apple LLVM 6.0 (clang-600.0.54)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>>
```

The "GCC 4.2.1" line tells us that we're using a CPython 2.7.8, which is
currently set as my default. Now, back in the `pypy_test` directory...

```
~/Desktop $ cd pypy_test
~/Desktop/pypy_test $ python
Python 2.7.8 (10f1b29a2bd2, Feb 02 2015, 21:22:55)
[PyPy 2.5.0 with GCC 4.2.1 Compatible Apple LLVM 6.0 (clang-600.0.56)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>>> 
```

Success!

If it's ever unclear what version you're using, run `pyenv version` to get the
current version. You can do something similar by running `pyenv global
[version]` to set a global version. I've done that on my machine to set Python
2.7.8 as managed by pyenv.

## Virtualenvs!

We can also use [pyenv-virtualenv](https://github.com/yyuu/pyenv-virtualenv)
(which we installed earlier) to manage virtual environments from pyenv. The
syntax for creating a new virtualenv looks like `pyenv virtualenv
[pyenv-version] [virtualenv-name]`. We'll make one for our pretend project now
with `pyenv virtualenv pypy-2.5.0 pypy_test`. I haven't included the output of
the command here, because it is very long: all the requirements for the
virtualenv including a copy of pip are installed.

Once you've created a virtualenv with this method, you can use it as a
first-class python version. It will even show up in `pyenv versions`! So in our
case, all we have to do is run `pyenv local pypy_test` within the directory we
created, and we'll be using our virtualenv automatically, with no further input
needed.

## Wrap Up

In this post, we've seen how to install and use both new versions of python and
new virtualenvs. Next time you're using multiple Python versions, consider
giving pyenv a try; it really does speed things up. And special thanks to
Yamashita, Yuu for writing such a useful tool in the first place!
