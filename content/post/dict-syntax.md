---
title: "Dict Syntax"
date: "2012-03-19T00:00:00-06:00"

---

I just found out something neat about Python's `dict` syntax. First of all, of course this works:


    >>> d = dict(a=1, b=2, c=3)
    
<!--more-->


But you can also stick dictionaries in there as the first argument. Go ahead, try it:


    >>> d = {'a': 1, 'b': 2}
    >>> d2 = dict(d, a=2, b=3)
    >>> d2
    {'a': 2, 'b': 3}


It's as if you called `update` on the dictionary. Neato, eh? It's
especially useful in [ming migrations][ming-migrations].

[ming-migrations]: http://merciless.sourceforge.net/tour.html#specifying-a-migration "Specifying a migration"
