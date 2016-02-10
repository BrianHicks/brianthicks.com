---
title: Test APIs Properly with vcr.py
slug: test-apis-properly-with-vcr-py
date: "2014-12-01T14:50:00-06:00"

---

When you're building API integrations, how do you test the part of your code
that talks to the remote server? I used to run a subset of tests against that
part of the code very infrequently, rather than testing *all* the code on every
commit. This saved a little time, but unfortunately still meant my tests were
dependent on an external service *plus* I wasn't always testing the affected
code. That's a really good way to get sporadic build failures!

<!--more-->

[vcr.py][vcr] (a Python port of Ruby's [vcr](https://github.com/vcr/vcr)) solved
these problems for me. VCR provides a decorator that mocks the HTTP request
handling code in Python, so you can use whatever library you like to make
requests and they'll be cached for future use. It looks like this:

```
@vcr.use_cassette('fixtures/cassettes/root_valid.yml')
def test_root_valid():
    resp = requests.get('http://www.google.com')
    assert resp.status_code == 200
```

The first time you run that code, requests will work normally and get Google's
homepage. However, the next time you run it something different happens: VCR
intercepts the request and sends the response you got the first time. It will
cache all the different parts of the request too, so when you need to do
authentication that'll be saved too. However, that brings up a new set of
problems: you probably don't want to commit your development credentials, even
in a fixture. Fortunately VCR has you covered here too:

```
@vcr.use_cassette('fixtures/cassettes/root_auth.yml', filter_headers=['Authorization'])
def test_root_auth():
    resp = requests.get(
        'http://www.google.com/',
        headers={
            'Authorization': 'Token %s' % os.getenv('GOOGLE_TOKEN'),
        }
    )
```

Now the `Authorization` header will be removed in the `root_auth.yml` fixture.
You can do
[more advanced scrubbing](https://github.com/kevin1024/vcrpy#custom-request-filtering),
too.

The path taken by VCR isn't perfect: errors can still creep through and you
should periodically regenerate all your fixtures to make sure you're not relying
on tests developed against old data or changed configuration. But what it does,
it does very well. So grab it with `pip install vcr.py` and get testing!

[vcr]: https://github.com/kevin1024/vcrpy "kevin1024/vcrpy"
