---
title: "Build Module Command-Line Tools with Click"
date: "2014-11-03T06:25:00-06:00"

---

I'm currently in the process of rewriting some of my everyday scripts to use
[Click][click]. It's a joy to use, especially for scripts with subcommands,
because it has an API that's well-thought-out but still fairly flexible. So
here's a simple code pattern that I've been using for keeping configuration. It
should show you why I'm so enthusiastic about this library right now:

[click]: http://click.pocoo.org/3/ "Click 3"

<!--more-->

## Configuration Handling

We're going to start with a configuration object. Just assume that I've imported
everything necessary before this (just `click`, `json`, and `py`.)

```
class Config(dict):
    def __init__(self, *args, **kwargs):
        self.config = py.path.local(
            click.get_app_dir('my_app')
        ).join('config.json') # A
        
        super(Config, self).__init__(*args, **kwargs)
        
    def load(self):
        """load a JSON config file from disk"""
        try:
            self.update(json.loads(self.config.read())) # B
        except py.error.ENOENT:
            pass
            
    def save(self):
    	self.config.ensure()
        with self.config.open('w') as f: # B
            f.write(json.dumps(self))
```

Ok, so this is a pretty basic pattern: subclass `dict` and add some methods and
state. You could do this with `.ini` files if you liked, but I've found JSON to
be very handy for this purpose because the `json` module is so convenient and
it's a simple format on disk. I've marked a couple lines:

 - **a:** this is one of the nice things that Click gives you: a place to store
   configuration files. It works cross-platform and puts files where you'd
   expect to find them. On Mac, this call would generate `~/Library/Application
   Support/my_app`.
 - **b:** just to save myself a little time here I'm using [`py`][py], which has
   nice support for joining files and conveniently creating directory trees that
   don't exist yet. It's nice how succinct it gets at these points. (of course,
   in `save` I'm being a little naive but still!)
 
The next step is to tell Click to create a "pass handler" for this. This is
Click's term for a decorator that holds on to an instrance of a specific object
to pass it to multiple functions. You commonly use them to create a bit of state
in a parent command and pass it to subcommands, but we can also use it to only
read the configuration from disk once.

```
pass_config = click.make_pass_decorator(Config, ensure=True)

@click.group()
@pass_config
def cli(config):
    config.load()
```

Ok, so we've got a root group for our application now. This group will do all
the initialization work that we need (in this case, loading the config from
disk.) We can also pass global parameters to it, if we want, and as long as we
save them on the config object they'll be persisted to the child commands. And
speaking of child commands, here are a few:

```
@cli.command()
@pass_config
def say_hello(config):
	"""say hello to someone"""
	click.echo("Hello, %s" % config.get("name", "unnamed entity"))

@cli.command()
@click.argument('name')
@pass_config
def my_name_is(config, name):
    """set the name to say hello to"""
    config['name'] = name
    config.save()
    click.echo("Set name")
```

So now we have a couple commands. They're fairly simple examples, but "hello
world" is always a good place to start. Note I'm using `click.echo` instead of
`print`. This is a wrapper between Python 2 and 3, and in addition will strip
terminal colors if the output is a file, neither of which happen with `print`.

Next we'll add a start line…

```
if __name__ == '__main__':
    cli()
```

and fire it up:

```
$ python cli.py
Usage: cli.py [OPTIONS] COMMAND [ARGS]...

Options:
  --help  Show this message and exit.
  
Commands:
  my_name_is  set the name to say hello to
  say_hello   say hello to someone

$ python cli.py say_hello
Hello, unnamed entity

$ python cli.py my_name_is Potatoman
Set name

$ python cli.py say_hello
Hello, Potatoman
```

So we can see it's saving and loading state, generating help, and processing
arguments, all in about 40 lines of Python. So now let's package it up for easy
installation:

```
from setuptools import setup

setup(
    name="hello",
    version="0.0.1",
    py_modules=["cli.py"],
    install_requires=["Click"],
    
    entry_points="""
        [console_scripts]
        hello=cli:cli
    """
)
```

So now if you install that with `pip install -e .` (`-e` for "editable", so you
can still make changes) you can run `hello` like so:

```
$ hello
Usage: hello [OPTIONS] COMMAND [ARGS]...

Options:
  --help  Show this message and exit.
  
Commands:
  my_name_is  set the name to say hello to
  say_hello   say hello to someone
```

So then, you can push it to Github/Bitbucket, the Python Package Index, and do
any of the normal things you would do with a package, and it's all
self-contained and modular. What more could you ask for in a proper command-line
tool?

[setuptools-doc]: http://click.pocoo.org/3/setuptools/ "Setuptools Integration"
[py]: http://pylib.readthedocs.org/en/latest/
